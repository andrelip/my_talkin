class ChannelList {

    static init(socket, user_token){
    var $status    = $("#status")
    var $messages  = $("#messages")
    var $input     = $("#message-input")
    var $username  = $("#username")

    socket.onOpen( ev => console.log("OPEN", ev) )
    socket.onError( ev => console.log("ERROR", ev) )
    socket.onClose( e => console.log("CLOSE", e))

    var chan = socket.channel(`users:${user_token}`, {})
    chan.join()
        .receive("ignore", () => console.log("auth error"))
        .receive("ok", () => console.log("join ok"))
        .receive("timeout", () => console.log("Connection interruption"))
    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    chan.on("users:new:channel", msg => {
        $messages.append(this.newRoomTemplate(msg))
        scrollTo(0, document.body.scrollHeight)
    })

    chan.on("users:load_content", msg => {
        console.log(msg)
        msg["body"] = {user: msg["user"], rooms: msg["rooms"]}
        $messages.append(this.multipleRoomsTemplate(msg))
        scrollTo(0, document.body.scrollHeight)
    })
    }

    static sanitize(html){ return $("<div/>").text(html).html() }

    static multipleRoomsTemplate(msg){
        let username = this.sanitize(msg.user || "anonymous")
        let channel_list = msg.rooms
        var text = ""
        channel_list
        JSON.parse(channel_list).forEach(m => {
          text = text + `<p>${ChannelList.sanitize(m.name)} - ${ChannelList.sanitize(m.token)} - lat: ${m.location.coordinates[0]} long: ${m.location.coordinates[1]}</p>\n`
        })
        console.log(text)
        return(text)
    }

    static newRoomTemplate(msg){
        let username = this.sanitize(msg.user || "anonymous")
        let channel_list = msg.room
        let content = JSON.parse(channel_list)
        var text = `<p>${ChannelList.sanitize(content.name)} - ${ChannelList.sanitize(content.token)} - ${content.location.coordinates[0]} ${content.location.coordinates[1]}</p>`
        return(text)
    }

}

export default ChannelList

FROM phusion/baseimage

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Phoenix Installation
RUN apt-get update && apt-get install -y wget && \
rm -rf /var/lib/apt/lists/* && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
dpkg -i erlang-solutions_1.0_all.deb && rm -rf  https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN apt-get update && apt-get install -y esl-erlang elixir postgresql postgresql-contrib libpq-dev bzip2 && \
rm -rf /var/lib/apt/lists/* && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN mix local.hex
#

# NODEJS
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.3.1

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN mix local.rebar --force && mix local.hex --force
#
#

# App Installation
WORKDIR /home/app/
ADD mix.exs /home/app/mix.exs
ADD mix.lock /home/app/mix.lock
RUN echo Y | mix deps.get -y
ADD . /home/app
RUN mix compile
#

# Use baseimage-docker's init system.
# CMD ["/sbin/my_init"]
CMD mix phoenix.server

# ...put your own build instructions here...

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

RUN apt-get update && apt-get install -y nodejs && \
rm -rf /var/lib/apt/lists/* && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp


# App Installation
WORKDIR /home/app/
ADD mix.exs /home/app/mix.exs
ADD mix.lock /home/app/mix.lock
RUN echo Y | mix deps.get -y
ADD . /home/app
#

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

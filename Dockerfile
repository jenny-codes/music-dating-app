FROM elixir:1.10.3

ENV PHX_VERSION 1.4.17
ENV NODE_MAJOR 12

ENV APP_ROOT /app
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

COPY . .

RUN set -x &&\
  mix local.hex --force &&\
  mix local.rebar --force &&\
  mix archive.install hex phx_new $PHX_VERSION --force &&\
  curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - &&\
  apt-get install -y nodejs inotify-tools &&\
  cd assets &&\
  npm install

CMD ["iex"]

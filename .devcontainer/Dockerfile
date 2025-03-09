FROM elixir:1.17.2-alpine

RUN apk update && \
  apk --no-cache --update add \
  make \
  g++ \
  git \
  wget \
  curl \
  npm \
  inotify-tools && \
  rm -rf /var/cache/apk/*


ENV MIX_ENV ${ENV}
ENV NODE_ENV ${NODE_ENV}

# Ensure latest versions of Hex/Rebar are installed on build
# And install the phx_new generator
RUN mix do local.hex --force, local.rebar --force


RUN mkdir /app
WORKDIR /app 


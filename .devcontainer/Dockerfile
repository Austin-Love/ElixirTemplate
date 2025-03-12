# FROM flyio/flyctl:latest AS flyio


FROM elixir:1.17.2-alpine AS runner


FROM runner
RUN apk update && \
  apk --no-cache --update add \
  make \
  g++ \
  git \
  wget \
  curl \
  npm \
  bash \
  inotify-tools && \
  rm -rf /var/cache/apk/*

RUN curl -L https://fly.io/install.sh | sh && \
  mv /root/.fly/bin/flyctl /usr/local/bin/ && \
  ln -s /usr/local/bin/flyctl /usr/local/bin/fly


# ENV PATH="/root/.fly:${PATH}"
ENV MIX_ENV ${ENV}
ENV NODE_ENV ${NODE_ENV}

# Ensure latest versions of Hex/Rebar are installed on build
# And install the phx_new generator
RUN mix do local.hex --force, local.rebar --force


RUN mkdir /app
WORKDIR /app 
# CMD ["curl", "-L", "https://fly.io/install.sh", "|", "sh"]

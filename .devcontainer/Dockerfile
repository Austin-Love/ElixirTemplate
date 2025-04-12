FROM elixir:1.18.2-slim AS runner


FROM runner
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  make \
  g++ \
  git \
  wget \
  curl \
  npm \
  bash \
  procps \
  ca-certificates \
  inotify-tools && \
  rm -rf /var/lib/apt/lists/*


RUN curl -L https://fly.io/install.sh | sh && \
  mv /root/.fly/bin/flyctl /usr/local/bin/ && \
  ln -s /usr/local/bin/flyctl /usr/local/bin/fly

ENV MIX_ENV ${ENV}
ENV NODE_ENV ${NODE_ENV}

# Ensure latest versions of Hex/Rebar are installed on build
# And install the phx_new generator
RUN mix do local.hex --force, local.rebar --force


RUN mkdir /app
WORKDIR /app

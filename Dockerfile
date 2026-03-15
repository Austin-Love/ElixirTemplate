# Production Dockerfile for Phoenix releases
# Build: docker build -t elixir_template .
# Run:   docker run -p 4000:4000 -e DATABASE_URL=... -e SECRET_KEY_BASE=... elixir_template

ARG ELIXIR_VERSION=1.18.2
ARG OTP_VERSION=27.1.2
ARG DEBIAN_VERSION=bookworm-20240701-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# ---- Build Stage ----
FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y && apt-get install -y build-essential git npm \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV="prod"

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/runtime.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib
COPY assets assets

RUN if [ -f assets/package.json ]; then npm ci --prefix ./assets; fi
RUN mix assets.deploy
RUN mix compile

COPY rel rel
RUN mix release

# ---- Runtime Stage ----
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV MIX_ENV="prod"
ENV PHX_SERVER=true

WORKDIR /app

RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/elixir_template ./

USER nobody

CMD ["/app/bin/server"]

# ElixirTemplate

A production-ready Phoenix 1.8 template for rapid prototyping and prototype-to-product conversion.

## What's Included

- **Authentication** - Complete user auth with email confirmation, magic links, and sudo mode
- **LiveView** - Real-time interactive UIs without writing JavaScript
- **Tailwind CSS + DaisyUI** - Utility-first styling with pre-built components
- **Background Jobs** - Oban for reliable async processing
- **Observability** - OpenTelemetry + Prometheus metrics out of the box
- **Email** - Swoosh with local dev preview at `/dev/mailbox`
- **API Ready** - OpenAPI/Swagger support with ReDoc UI
- **Security** - CSRF, rate limiting, Sobelow static analysis, dependency auditing
- **CI/CD** - GitHub Actions for tests and code quality
- **Docker** - Production Dockerfile and dev container

## Quick Start

```bash
# 1. Clone and rename
git clone <this-repo> my_app
cd my_app
./rename_template.sh MyApp

# 2. Setup
mix setup

# 3. Run
mix phx.server
```

Visit [localhost:4000](http://localhost:4000). Dev mailbox at [localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox).

## Prototyping Workflow

### Add a new resource (5 minutes)

```bash
# Generate a full CRUD feature with LiveView
mix phx.gen.live Blog Post posts title:string body:text published:boolean user_id:references:users

# Run the migration
mix ecto.migrate
```

Add the routes printed by the generator to `lib/elixir_template_web/router.ex` and you're done.

### Add a JSON API (5 minutes)

```bash
mix phx.gen.json Blog Post posts title:string body:text
```

Uncomment the API scope in the router and add your routes.

### Add a background job

```elixir
# 1. Create a worker in lib/elixir_template/workers/
defmodule ElixirTemplate.Workers.SendDigest do
  use Oban.Worker, queue: :mailers

  @impl true
  def perform(%Oban.Job{args: %{"user_id" => user_id}}) do
    # Your job logic here
    :ok
  end
end

# 2. Enqueue from anywhere
%{user_id: 123} |> ElixirTemplate.Workers.SendDigest.new() |> Oban.insert()
```

## Development

```bash
mix test                    # Run tests
mix test.watch              # Run tests on file change
mix credo --strict          # Code style
mix sobelow --config        # Security check
mix ex_check                # Run all checks
mix format                  # Format code
mix phx.routes              # List routes
```

### Dev Container

Open in VS Code with the Dev Containers extension, or:

```bash
docker compose -f .devcontainer/docker-compose.yml up
```

## Production Deployment

### Docker

```bash
docker build -t my_app .
docker run -p 4000:4000 \
  -e DATABASE_URL="ecto://..." \
  -e SECRET_KEY_BASE="$(mix phx.gen.secret)" \
  -e TOKEN_SIGNING_SECRET="$(mix phx.gen.secret)" \
  -e PHX_HOST="myapp.com" \
  my_app
```

### Fly.io

```bash
fly launch
fly deploy
```

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | prod | PostgreSQL connection string |
| `SECRET_KEY_BASE` | prod | Cookie signing secret |
| `TOKEN_SIGNING_SECRET` | prod | API token signing secret |
| `PHX_HOST` | prod | Production hostname |
| `PHX_SERVER` | prod | Set to `true` to start HTTP server |
| `PORT` | no | HTTP port (default: 4000) |

## Prototype-to-Product Checklist

- [ ] Rename template: `./rename_template.sh MyApp`
- [ ] Update `mix.exs` version and description
- [ ] Configure production mailer in `config/runtime.exs`
- [ ] Set up CI secrets for GitHub Actions
- [ ] Configure production database
- [ ] Enable SSL (`force_ssl` in `config/prod.exs`)
- [ ] Set up error tracking (Sentry, AppSignal, etc.)
- [ ] Review and tighten rate limits
- [ ] Add domain-specific contexts and schemas
- [ ] Set up production logging/monitoring

## Learn More

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view)
- [Ecto](https://hexdocs.pm/ecto)
- [Oban](https://hexdocs.pm/oban)
- [Tailwind CSS](https://tailwindcss.com/)
- [DaisyUI](https://daisyui.com/)

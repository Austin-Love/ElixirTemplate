# CLAUDE.md - AI-Assisted Development Guide

## Project Overview
Phoenix 1.8.3 + LiveView web application template with authentication, background jobs, and production-ready infrastructure.

## Quick Start
```bash
mix setup          # Install deps, build assets, create DB, run seeds
mix phx.server     # Start dev server at localhost:4000
iex -S mix phx.server  # Start with IEx shell
```

## Key Commands
```bash
mix test                    # Run tests
mix test --cover            # Run tests with coverage
mix credo                   # Code style analysis
mix sobelow                 # Security analysis
mix ex_check                # Run ALL checks (credo, sobelow, audit, etc.)
mix format                  # Format code (uses Styler)
mix ecto.migrate            # Run pending migrations
mix ecto.reset              # Drop + recreate + migrate DB
mix phx.routes              # List all routes
```

## Architecture
- **Phoenix 1.8.3** with **Bandit** web server (not Cowboy)
- **LiveView** for real-time interactive UIs
- **Ecto + PostgreSQL** for persistence
- **Tailwind CSS 4 + DaisyUI** for styling
- **Swoosh** for emails (dev: local adapter at `/dev/mailbox`)
- **Oban** for background job processing
- **OpenTelemetry + Prometheus** for observability

## Project Structure
```
lib/
  elixir_template/           # Business logic (contexts)
    accounts/                # User auth context
    accounts.ex              # Accounts public API
    repo.ex                  # Ecto repository
    mailer.ex                # Email service
    application.ex           # OTP supervision tree
  elixir_template_web/       # Web layer
    router.ex                # Route definitions
    endpoint.ex              # HTTP pipeline
    controllers/             # Traditional controllers
    live/                    # LiveView modules
    components/              # Shared UI components
config/
  config.exs                 # Base config
  dev.exs                    # Development config
  test.exs                   # Test config
  prod.exs                   # Production config
  runtime.exs                # Runtime config (env vars)
priv/
  repo/migrations/           # DB migrations
  repo/seeds.exs             # Seed data
  static/                    # Static assets
```

## Conventions
- **Contexts pattern**: Business logic lives in `lib/elixir_template/` context modules (e.g., `Accounts`)
- **Schema modules**: Live under their context (e.g., `Accounts.User`)
- **LiveView modules**: In `lib/elixir_template_web/live/`
- **Templates**: Colocated `.heex` files next to their LiveView/component modules
- **Tests mirror source**: `test/elixir_template/` for contexts, `test/elixir_template_web/` for web
- **Formatting**: Styler auto-formats on `mix format` - always format before committing
- **Line length**: 120 characters max (configured in .credo.exs)

## Scaffolding New Features
```bash
# Full CRUD with LiveView
mix phx.gen.live ContextName SchemaName schema_names field:type

# JSON API
mix phx.gen.json ContextName SchemaName schema_names field:type

# Context + schema only (no web layer)
mix phx.gen.context ContextName SchemaName schema_names field:type

# Database migration only
mix phx.gen.migration add_fields_to_table
```

## Auth System
- Session-based auth with `phx.gen.auth` (already configured)
- Magic link login supported
- Sudo mode for sensitive operations
- Auth plugs in `lib/elixir_template_web/user_auth.ex`

## Testing
- ExUnit with Ecto SQL sandbox (async-safe)
- Fixtures in `test/support/fixtures/`
- `ConnCase` for controller/LiveView tests, `DataCase` for context tests
- Property-based testing available via `stream_data`

## Environment Variables (Production)
- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY_BASE` - Cookie signing (generate with `mix phx.gen.secret`)
- `TOKEN_SIGNING_SECRET` - API token signing
- `PHX_HOST` - Production hostname
- `PHX_SERVER=true` - Enable HTTP server
- `PORT` - HTTP port (default: 4000)

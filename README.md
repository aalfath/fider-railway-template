[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/fider-1?utm_medium=integration&utm_source=button&utm_campaign=fider)

# Fider on Railway

A one-click Railway template for [Fider](https://fider.io), the open-source feedback board: people post ideas, vote and comment, and your team answers with a status.

## What the template deploys

| Service | Built from | Version | State |
|---|---|---|---|
| **Fider** | [`fider/Dockerfile`](fider/Dockerfile) | `getfider/fider:v0.40.0@sha256:9b4a0435…71f7` | none in the container: posts, users and uploaded images are stored in Postgres |
| **Mailpit** | [`mailpit/Dockerfile`](mailpit/Dockerfile) | `axllent/mailpit:v1.34.0@sha256:23a2ef85…4e` | volume at `/data` |
| **Postgres** | Railway's PostgreSQL | Railway's managed image | volume |

Fider has no passwords: everyone, the first administrator included, signs in with a link sent by email. The bundled Mailpit catches those emails so the board works on the first deploy with no SMTP account. Its web UI is password-protected. For real users, point Fider at your own SMTP server (see below).

Both app services build from this repository, so Railway tells everyone who deployed the template when a new version lands on `main`. Each deployer chooses when to apply it.

## After deploying

1. Open the **Fider** service's URL. It shows the "create your board" form. Enter your name, your email and a board name.
2. Open the **Mailpit** service's URL and sign in with the user and password in the Mailpit service's `MP_UI_AUTH` variable (`admin:PASSWORD`).
3. Open the "Your new Fider site" email and click the link. The board is activated and you're signed in as its administrator.

Only one board can be created. After that, `/signup` redirects to the board.

## Variables

**Fider**

| Variable | Default | Purpose |
|---|---|---|
| `BASE_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL used in links and emails. Change it if you add a custom domain |
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}?sslmode=disable` | Postgres over Railway's private network |
| `JWT_SECRET` | `${{secret(64)}}` | Signs sessions and sign-in links, generated per deploy |
| `EMAIL_NOREPLY` | `noreply@${{RAILWAY_PUBLIC_DOMAIN}}` | Sender address of Fider's emails |
| `EMAIL_SMTP_HOST` | `${{Mailpit.RAILWAY_PRIVATE_DOMAIN}}` | SMTP server (the bundled Mailpit) |
| `EMAIL_SMTP_PORT` | `1025` | SMTP port |
| `EMAIL_SMTP_ENABLE_STARTTLS` | `false` | Mailpit speaks plain SMTP on the private network |
| `PORT` | `3000` | HTTP port, health check `/_health` |

**Mailpit**

| Variable | Default | Purpose |
|---|---|---|
| `MP_UI_AUTH` | `admin:${{secret(24, …)}}` | Login for the Mailpit web UI, generated per deploy |
| `PORT` | `8025` | Web UI port, health check `/livez` |

### Sending real email

Set these on the Fider service and redeploy: `EMAIL_SMTP_HOST`, `EMAIL_SMTP_PORT`, `EMAIL_SMTP_USERNAME`, `EMAIL_SMTP_PASSWORD`, `EMAIL_SMTP_ENABLE_STARTTLS=true` (or `EMAIL_SMTP_ENABLE_IMPLICIT_TLS=true` for port 465) and an `EMAIL_NOREPLY` address your provider accepts. Mailgun (`EMAIL_MAILGUN_API`, `EMAIL_MAILGUN_DOMAIN`) and Amazon SES (`EMAIL_AWSSES_*`) work too. You can then remove the Mailpit service. All settings: [Fider's configuration docs](https://fider.io/docs/hosting-instance).

## Updates

The Fider and Mailpit images are pinned by version and digest in the two Dockerfiles. A version bump is a commit to `main` with an entry in [CHANGELOG.md](CHANGELOG.md), breaking changes first. Fider runs its database migrations on every start, so applying an update upgrades the schema. Back up Postgres before a major upgrade.

## Licence

This wrapper is MIT. Fider is [AGPL-3.0](https://github.com/getfider/fider/blob/main/LICENSE) and Mailpit is [MIT](https://github.com/axllent/mailpit/blob/develop/LICENSE).

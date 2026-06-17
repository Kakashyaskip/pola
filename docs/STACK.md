# Stack technique Pola

> Document de référence — à compléter avec les IDs et secrets réels

## Services Cloudflare

| Service | Nom | ID |
|---------|-----|-----|
| D1 (database) | pola-db | `PLACEHOLDER_D1_DATABASE_ID` |
| R2 (storage) | pola-photos | — |
| KV (sessions) | pola-sessions | `PLACEHOLDER_KV_NAMESPACE_ID` |
| Workers | pola-api | — |
| Pages | pola-web | — |

## Variables d'environnement à configurer

### API (wrangler.toml secrets)
```
JWT_SECRET=<générer avec openssl rand -base64 32>
RESEND_API_KEY=<depuis resend.com>
APPLE_TEAM_ID=<depuis Apple Developer>
```

### Web (.env.local)
```
AUTH_SECRET=<générer avec openssl rand -base64 32>
AUTH_APPLE_ID=app.pola.ios
AUTH_APPLE_SECRET=<JWT signé avec clé Apple>
NEXT_PUBLIC_API_URL=https://api.pola.app
```

## Paliers de prix

| Palier | Invités max | Prix |
|--------|------------|------|
| free | 5 | Gratuit |
| starter | 15 | 2,99€ |
| basic | 30 | 9,99€ |
| plus | 60 | 19,99€ |
| pro | 100 | 29,99€ |
| event | 150 | 49,99€ |
| premium | 200 | 69,99€ |

## IDs produits StoreKit

- `app.pola.tier.starter`
- `app.pola.tier.basic`
- `app.pola.tier.plus`
- `app.pola.tier.pro`
- `app.pola.tier.event`
- `app.pola.tier.premium`

## Structure R2

```
pola-photos/
└── events/
    └── {eventId}/
        └── {photoId}.jpg
```

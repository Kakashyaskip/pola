# Pola

Application iOS de caméra jetable numérique événementielle. Les hôtes créent un événement, génèrent un QR code, les invités prennent des photos avec un rendu argentique, et l'album est révélé à une date fixée.

## Stack

| Couche | Technologie |
|--------|-------------|
| iOS | Swift 6, SwiftUI, AVFoundation, Core Image, SwiftData, StoreKit 2 |
| Web | Next.js 15, TypeScript, Tailwind v4, shadcn/ui, Auth.js v5 |
| API | Cloudflare Workers, Hono, Drizzle ORM, Zod |
| Base de données | Cloudflare D1 (SQLite) |
| Stockage | Cloudflare R2 |
| Sessions | Cloudflare KV |

## Structure

```
pola/
├── apps/
│   ├── ios/          # Projet Xcode Swift 6
│   ├── web/          # Next.js 15
│   └── api/          # Cloudflare Worker (Hono)
├── packages/
│   └── shared-types/ # Types TS partagés
└── docs/             # Documentation et briefs
```

## Commandes

```bash
# Installer les dépendances
pnpm install

# Développement
pnpm dev:api     # Lance le worker en local (port 8787)
pnpm dev:web     # Lance Next.js en local (port 3000)

# Build
pnpm build:api
pnpm build:web

# Type checking
pnpm typecheck
```

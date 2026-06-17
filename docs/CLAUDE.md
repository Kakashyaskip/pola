# Pola — Instructions Claude Code

## Vision produit

Pola est une application iOS de caméra jetable numérique événementielle pour le marché français. Les hôtes créent un événement avec un QR code, les invités scannent et prennent un nombre limité de photos avec un rendu argentique, et l'album est révélé le lendemain. Cible : mariages, voyages, soirées, anniversaires. Modèle freemium en 7 paliers (gratuit → 69,99€).

## Stack résumée

- **iOS** : Swift 6, SwiftUI, MVVM + `@Observable`, AVFoundation (caméra), Core Image (filtres argentiques), SwiftData (persistance), StoreKit 2 (paiements), Sign in with Apple
- **Web** : Next.js (App Router), TypeScript strict, Tailwind v4, shadcn/ui, Auth.js v5, Cloudflare Pages
- **API** : Cloudflare Workers, Hono, TypeScript strict, Zod, JWT, D1 + Drizzle ORM
- **Stockage** : Cloudflare R2 (`pola-photos`), signed URLs uniquement
- **Sessions** : Cloudflare KV
- **Email** : Resend
- **Push** : APNs natif

## Conventions Swift

- Nommage : `PascalCase` pour types/fichiers, `camelCase` pour variables/fonctions
- Architecture : MVVM léger — Views ignorantes des données, ViewModels avec `@Observable`
- Pas d'UIKit sauf wrappers caméra nécessaires (AVFoundation uniquement)
- Swift 6 strict concurrency — pas de `nonisolated(unsafe)` sans raison documentée
- SwiftData pour la persistance locale, pas de CoreData directement
- Zéro librairie tierce sauf justification forte — URLSession + async/await natifs
- Les ViewModels ne font jamais d'UI, les Views ne font jamais d'appels réseau directs
- Pas de Singleton global sauf ServiceLocator unique si absolument nécessaire

## Conventions TypeScript

- `strict: true` partout, zéro `any`
- Zod sur toutes les entrées API (body, params, query)
- Types partagés via `@pola/shared-types` — ne pas dupliquer
- `ApiResponse<T>` pour toutes les réponses : `{ success: true, data: T } | { success: false, error: string, code: string }`
- Nommage fichiers : `kebab-case.ts`, exports : `camelCase` pour fonctions, `PascalCase` pour types
- Pas d'`import *`, imports explicites

## Obligations RGPD

- Jamais d'analytics tiers (pas de Mixpanel, Amplitude, GA, Plausible, etc.)
- Données hébergées en UE uniquement (Cloudflare EU region, Resend EU)
- Purge automatique des photos 30 jours après la révélation
- Pas de tracking cross-device, pas de fingerprinting
- Les sessions invités ne contiennent que l'ID appareil, jamais d'email ni nom réel
- Mentions légales, CGU, politique de confidentialité obligatoires avant tout achat

## Anti-patterns à éviter

- Firebase / Firestore — remplacé par Cloudflare D1 + KV
- Supabase — même raison
- Prisma — Drizzle est le choix retenu pour les Workers
- Alamofire / Moya — URLSession natif uniquement
- RxSwift / Combine — `@Observable` + async/await natifs
- Redux / Zustand côté web — React Server Components + state local
- `@MainActor` global sans raison — Swift 6 concurrency correcte
- Photos en base de données — toujours dans R2, clé dans la DB uniquement
- Accès direct R2 public — signed URLs uniquement (sécurité + RGPD)

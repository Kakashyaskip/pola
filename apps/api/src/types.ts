import type { DrizzleD1Database } from 'drizzle-orm/d1'
import type * as schema from './db/schema'

export type Env = {
  DB: D1Database
  PHOTOS: R2Bucket
  SESSIONS: KVNamespace
  ENVIRONMENT: string
  JWT_ISSUER: string
  APPLE_TEAM_ID: string
  APPLE_CLIENT_ID: string
  JWT_SECRET: string
  RESEND_API_KEY: string
}

export type AppBindings = {
  Bindings: Env
  Variables: {
    db: DrizzleD1Database<typeof schema>
    userId: string
  }
}

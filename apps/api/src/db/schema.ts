import { sqliteTable, text, integer, real } from 'drizzle-orm/sqlite-core'

export const users = sqliteTable('users', {
  id: text('id').primaryKey(),
  appleSubject: text('apple_subject').notNull().unique(),
  email: text('email'),
  name: text('name'),
  tier: text('tier', { enum: ['free', 'starter', 'basic', 'plus', 'pro', 'event', 'premium'] })
    .notNull()
    .default('free'),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
  updatedAt: integer('updated_at', { mode: 'timestamp' }).notNull(),
})

export const events = sqliteTable('events', {
  id: text('id').primaryKey(),
  hostId: text('host_id')
    .notNull()
    .references(() => users.id),
  name: text('name').notNull(),
  description: text('description'),
  maxGuests: integer('max_guests').notNull().default(5),
  maxPhotosPerGuest: integer('max_photos_per_guest').notNull().default(10),
  revealAt: integer('reveal_at', { mode: 'timestamp' }).notNull(),
  status: text('status', { enum: ['draft', 'active', 'revealed', 'expired'] })
    .notNull()
    .default('draft'),
  qrCode: text('qr_code'),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
  updatedAt: integer('updated_at', { mode: 'timestamp' }).notNull(),
})

export const photos = sqliteTable('photos', {
  id: text('id').primaryKey(),
  eventId: text('event_id')
    .notNull()
    .references(() => events.id),
  guestSessionId: text('guest_session_id').notNull(),
  r2Key: text('r2_key').notNull(),
  filter: text('filter').notNull().default('none'),
  takenAt: integer('taken_at', { mode: 'timestamp' }).notNull(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
})

export const guestSessions = sqliteTable('guest_sessions', {
  id: text('id').primaryKey(),
  eventId: text('event_id')
    .notNull()
    .references(() => events.id),
  deviceId: text('device_id').notNull(),
  nickname: text('nickname'),
  photosCount: integer('photos_count').notNull().default(0),
  joinedAt: integer('joined_at', { mode: 'timestamp' }).notNull(),
})

export const purchases = sqliteTable('purchases', {
  id: text('id').primaryKey(),
  userId: text('user_id')
    .notNull()
    .references(() => users.id),
  productId: text('product_id').notNull(),
  tier: text('tier', { enum: ['starter', 'basic', 'plus', 'pro', 'event', 'premium'] }).notNull(),
  amountEur: real('amount_eur').notNull(),
  appleTxId: text('apple_tx_id').notNull().unique(),
  environment: text('environment', { enum: ['sandbox', 'production'] }).notNull(),
  purchasedAt: integer('purchased_at', { mode: 'timestamp' }).notNull(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
})

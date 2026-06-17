export type Tier = 'free' | 'starter' | 'basic' | 'plus' | 'pro' | 'event' | 'premium'

export type EventStatus = 'draft' | 'active' | 'revealed' | 'expired'

export type User = {
  id: string
  appleSubject: string
  email: string | null
  name: string | null
  tier: Tier
  createdAt: string
  updatedAt: string
}

export type Event = {
  id: string
  hostId: string
  name: string
  description: string | null
  maxGuests: number
  maxPhotosPerGuest: number
  revealAt: string
  status: EventStatus
  qrCode: string | null
  createdAt: string
  updatedAt: string
}

export type Photo = {
  id: string
  eventId: string
  guestSessionId: string
  r2Key: string
  filter: string
  takenAt: string
  createdAt: string
  signedUrl?: string
}

export type GuestSession = {
  id: string
  eventId: string
  deviceId: string
  nickname: string | null
  photosCount: number
  joinedAt: string
}

export type Purchase = {
  id: string
  userId: string
  productId: string
  tier: Exclude<Tier, 'free'>
  amountEur: number
  appleTxId: string
  environment: 'sandbox' | 'production'
  purchasedAt: string
  createdAt: string
}

export const TIER_CONFIG: Record<Tier, { maxGuests: number; priceEur: number | null }> = {
  free: { maxGuests: 5, priceEur: null },
  starter: { maxGuests: 15, priceEur: 2.99 },
  basic: { maxGuests: 30, priceEur: 9.99 },
  plus: { maxGuests: 60, priceEur: 19.99 },
  pro: { maxGuests: 100, priceEur: 29.99 },
  event: { maxGuests: 150, priceEur: 49.99 },
  premium: { maxGuests: 200, priceEur: 69.99 },
}

export type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code: string }

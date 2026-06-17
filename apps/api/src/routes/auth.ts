import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'
import { verifyAppleIdentityToken, signJwt } from '../lib/auth'
import { createDb } from '../db/client'
import { users } from '../db/schema'
import { eq } from 'drizzle-orm'
import type { AppBindings } from '../types'

const auth = new Hono<AppBindings>()

auth.post(
  '/apple',
  zValidator('json', z.object({ identityToken: z.string() })),
  async (c) => {
    const { identityToken } = c.req.valid('json')
    const db = createDb(c.env.DB)

    const payload = await verifyAppleIdentityToken(identityToken, c.env)

    let user = await db.query.users.findFirst({
      where: eq(users.appleSubject, payload.sub),
    })

    if (!user) {
      const id = crypto.randomUUID()
      const now = new Date()
      await db.insert(users).values({
        id,
        appleSubject: payload.sub,
        email: payload.email ?? null,
        name: null,
        tier: 'free',
        createdAt: now,
        updatedAt: now,
      })
      user = await db.query.users.findFirst({ where: eq(users.id, id) })
    }

    if (!user) return c.json({ success: false, error: 'Erreur serveur', code: 'USER_CREATE_FAILED' }, 500)

    const token = await signJwt(
      { sub: user.id, tier: user.tier, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30 },
      c.env.JWT_SECRET,
    )

    return c.json({ token })
  },
)

auth.post(
  '/google',
  zValidator('json', z.object({ idToken: z.string() })),
  async (c) => {
    const { idToken } = c.req.valid('json')
    const db = createDb(c.env.DB)

    // Vérifier le token Google via tokeninfo endpoint
    const response = await fetch(`https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`)
    if (!response.ok) {
      return c.json({ success: false, error: 'Token Google invalide', code: 'INVALID_GOOGLE_TOKEN' }, 401)
    }

    const googlePayload = await response.json() as {
      sub: string
      email?: string
      name?: string
      aud: string
      exp: string
    }

    if (parseInt(googlePayload.exp) < Math.floor(Date.now() / 1000)) {
      return c.json({ success: false, error: 'Token expiré', code: 'TOKEN_EXPIRED' }, 401)
    }

    const googleSubject = `google:${googlePayload.sub}`

    let user = await db.query.users.findFirst({
      where: eq(users.appleSubject, googleSubject),
    })

    if (!user) {
      const id = crypto.randomUUID()
      const now = new Date()
      await db.insert(users).values({
        id,
        appleSubject: googleSubject,
        email: googlePayload.email ?? null,
        name: googlePayload.name ?? null,
        tier: 'free',
        createdAt: now,
        updatedAt: now,
      })
      user = await db.query.users.findFirst({ where: eq(users.id, id) })
    }

    if (!user) return c.json({ success: false, error: 'Erreur serveur', code: 'USER_CREATE_FAILED' }, 500)

    const token = await signJwt(
      { sub: user.id, tier: user.tier, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30 },
      c.env.JWT_SECRET,
    )

    return c.json({ token })
  },
)

export default auth

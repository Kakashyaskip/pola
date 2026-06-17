import type { Env } from '../types'

type ApplePublicKey = {
  kty: string
  kid: string
  alg: string
  n: string
  e: string
}

type AppleKeysResponse = {
  keys: ApplePublicKey[]
}

type AppleTokenPayload = {
  iss: string
  aud: string
  exp: number
  iat: number
  sub: string
  email?: string
  email_verified?: boolean
}

export async function verifyAppleIdentityToken(
  identityToken: string,
  env: Env,
): Promise<AppleTokenPayload> {
  const [headerB64] = identityToken.split('.')
  if (!headerB64) throw new Error('Invalid identity token format')

  const header = JSON.parse(atob(headerB64.replace(/-/g, '+').replace(/_/g, '/'))) as {
    kid: string
    alg: string
  }

  const response = await fetch('https://appleid.apple.com/auth/keys')
  const { keys } = (await response.json()) as AppleKeysResponse

  const jwk = keys.find((k) => k.kid === header.kid)
  if (!jwk) throw new Error('Apple public key not found')

  const publicKey = await crypto.subtle.importKey(
    'jwk',
    jwk,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['verify'],
  )

  const [, payloadB64, signatureB64] = identityToken.split('.')
  if (!payloadB64 || !signatureB64) throw new Error('Invalid identity token format')

  const signingInput = `${headerB64}.${payloadB64}`
  const signature = Uint8Array.from(
    atob(signatureB64.replace(/-/g, '+').replace(/_/g, '/')),
    (c) => c.charCodeAt(0),
  )

  const valid = await crypto.subtle.verify(
    'RSASSA-PKCS1-v1_5',
    publicKey,
    signature,
    new TextEncoder().encode(signingInput),
  )

  if (!valid) throw new Error('Invalid Apple identity token signature')

  const payload = JSON.parse(
    atob(payloadB64.replace(/-/g, '+').replace(/_/g, '/')),
  ) as AppleTokenPayload

  if (payload.iss !== 'https://appleid.apple.com') throw new Error('Invalid issuer')
  if (payload.aud !== env.APPLE_CLIENT_ID) throw new Error('Invalid audience')
  if (payload.exp < Math.floor(Date.now() / 1000)) throw new Error('Token expired')

  return payload
}

export async function signJwt(payload: Record<string, unknown>, secret: string): Promise<string> {
  const header = { alg: 'HS256', typ: 'JWT' }
  const encode = (obj: unknown) =>
    btoa(JSON.stringify(obj)).replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')

  const signingInput = `${encode(header)}.${encode(payload)}`
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  )

  const signature = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(signingInput))
  const signatureB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')

  return `${signingInput}.${signatureB64}`
}

export async function verifyJwt(token: string, secret: string): Promise<Record<string, unknown>> {
  const [headerB64, payloadB64, signatureB64] = token.split('.')
  if (!headerB64 || !payloadB64 || !signatureB64) throw new Error('Invalid JWT format')

  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['verify'],
  )

  const signingInput = `${headerB64}.${payloadB64}`
  const signature = Uint8Array.from(
    atob(signatureB64.replace(/-/g, '+').replace(/_/g, '/')),
    (c) => c.charCodeAt(0),
  )

  const valid = await crypto.subtle.verify(
    'HMAC',
    key,
    signature,
    new TextEncoder().encode(signingInput),
  )

  if (!valid) throw new Error('Invalid JWT signature')

  const payload = JSON.parse(
    atob(payloadB64.replace(/-/g, '+').replace(/_/g, '/')),
  ) as Record<string, unknown>

  const exp = payload['exp']
  if (typeof exp === 'number' && exp < Math.floor(Date.now() / 1000)) {
    throw new Error('JWT expired')
  }

  return payload
}

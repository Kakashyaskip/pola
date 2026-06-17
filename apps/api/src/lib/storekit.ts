type JWSTransaction = {
  productId: string
  transactionId: string
  originalTransactionId: string
  purchaseDate: number
  environment: 'Sandbox' | 'Production'
  type: string
  appAccountToken?: string
}

export async function decodeJWSTransaction(jws: string): Promise<JWSTransaction> {
  const [, payloadB64] = jws.split('.')
  if (!payloadB64) throw new Error('Invalid JWS transaction format')

  const payload = JSON.parse(
    atob(payloadB64.replace(/-/g, '+').replace(/_/g, '/')),
  ) as JWSTransaction

  return payload
}

export function productIdToTier(
  productId: string,
): 'starter' | 'basic' | 'plus' | 'pro' | 'event' | 'premium' {
  const map: Record<string, 'starter' | 'basic' | 'plus' | 'pro' | 'event' | 'premium'> = {
    'app.pola.tier.starter': 'starter',
    'app.pola.tier.basic': 'basic',
    'app.pola.tier.plus': 'plus',
    'app.pola.tier.pro': 'pro',
    'app.pola.tier.event': 'event',
    'app.pola.tier.premium': 'premium',
  }
  const tier = map[productId]
  if (!tier) throw new Error(`Unknown product ID: ${productId}`)
  return tier
}

export function tierToAmountEur(
  tier: 'starter' | 'basic' | 'plus' | 'pro' | 'event' | 'premium',
): number {
  const prices: Record<string, number> = {
    starter: 2.99,
    basic: 9.99,
    plus: 19.99,
    pro: 29.99,
    event: 49.99,
    premium: 69.99,
  }
  return prices[tier] ?? 0
}

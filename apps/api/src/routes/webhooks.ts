import { Hono } from 'hono'
import type { AppBindings } from '../types'

const webhooks = new Hono<AppBindings>()

// TODO: Sprint 1 — implement StoreKit Server-to-Server webhook handler

export default webhooks

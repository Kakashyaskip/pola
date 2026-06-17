import { Hono } from 'hono'
import type { AppBindings } from '../types'

const payments = new Hono<AppBindings>()

// TODO: Sprint 1 — implement payment verification routes

export default payments

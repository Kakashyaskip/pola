import { Hono } from 'hono'
import type { AppBindings } from '../types'

const events = new Hono<AppBindings>()

// TODO: Sprint 1 — implement event CRUD routes

export default events

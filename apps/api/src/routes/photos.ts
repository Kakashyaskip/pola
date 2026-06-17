import { Hono } from 'hono'
import type { AppBindings } from '../types'

const photos = new Hono<AppBindings>()

// TODO: Sprint 1 — implement photo upload/download routes

export default photos

import { Hono } from 'hono'
import { drizzle } from 'drizzle-orm/d1'
import * as schema from './db/schema'
import events from './routes/events'
import photos from './routes/photos'
import payments from './routes/payments'
import webhooks from './routes/webhooks'
import type { AppBindings } from './types'

const app = new Hono<AppBindings>()

app.use('*', async (c, next) => {
  c.set('db', drizzle(c.env.DB, { schema }))
  await next()
})

app.get('/', (c) => {
  return c.json({ status: 'ok', service: 'pola-api' })
})

app.route('/events', events)
app.route('/photos', photos)
app.route('/payments', payments)
app.route('/webhooks', webhooks)

export default app

type Props = {
  params: Promise<{ eventId: string }>
}

export default async function GaleriePage({ params }: Props) {
  const { eventId } = await params

  return (
    <main className="flex-1 p-8">
      <h1 className="text-2xl font-bold" style={{ color: 'var(--pola-black)' }}>
        Galerie
      </h1>
      <p className="mt-2 text-sm opacity-50">Événement {eventId} — Sprint 1</p>
    </main>
  )
}

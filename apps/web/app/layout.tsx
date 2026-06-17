import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Pola — Appareil photo jetable numérique',
  description:
    "Capturez vos moments avec un rendu argentique. L’album est révélé le lendemain.",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="fr" className="h-full">
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  )
}

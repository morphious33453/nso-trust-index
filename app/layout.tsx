export const metadata = {
  title: 'NSO Trust Index | St. Catharines Restaurant Rankings',
  description: 'Real-time trust rankings for St. Catharines restaurants based on Google reviews and rating trends.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}

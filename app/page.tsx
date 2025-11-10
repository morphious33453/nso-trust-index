import Link from 'next/link'

export default function Home() {
  return (
    <main style={{ maxWidth: '800px', margin: '0 auto', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '2.5rem', marginBottom: '1rem', color: '#1a202c' }}>
        🏆 NSO Trust Index
      </h1>
      <p style={{ fontSize: '1.25rem', color: '#4a5568', marginBottom: '2rem' }}>
        Real-time trust rankings for St. Catharines businesses
      </p>

      <div style={{ background: '#f7fafc', padding: '2rem', borderRadius: '8px', marginBottom: '2rem' }}>
        <h2 style={{ fontSize: '1.5rem', marginBottom: '1rem' }}>✅ MVP Live</h2>
        <p style={{ marginBottom: '1rem' }}>The Niagara Stands Out Trust Index tracks and ranks local businesses based on:</p>
        <ul style={{ marginLeft: '1.5rem', lineHeight: '1.8' }}>
          <li>Google review ratings (daily snapshots)</li>
          <li>Review count trends (7-day history)</li>
          <li>Trust score algorithm (rating stability)</li>
        </ul>
      </div>

      <div style={{ marginBottom: '2rem' }}>
        <h3 style={{ fontSize: '1.25rem', marginBottom: '1rem' }}>🎯 Quick Links</h3>
        <div style={{ display: 'grid', gap: '1rem' }}>
          <Link
            href="/st-catharines/restaurants"
            style={{
              display: 'block',
              padding: '1rem',
              background: '#667eea',
              color: 'white',
              textDecoration: 'none',
              borderRadius: '6px',
              fontWeight: '600'
            }}
          >
            📊 St. Catharines Restaurants Leaderboard
          </Link>
          <Link
            href="/methodology"
            style={{
              display: 'block',
              padding: '1rem',
              background: '#48bb78',
              color: 'white',
              textDecoration: 'none',
              borderRadius: '6px',
              fontWeight: '600'
            }}
          >
            🧮 How Rankings Are Calculated
          </Link>
        </div>
      </div>

      <div style={{ background: '#edf2f7', padding: '1.5rem', borderRadius: '8px' }}>
        <h3 style={{ fontSize: '1rem', marginBottom: '0.5rem', color: '#2d3748' }}>Database Status:</h3>
        <p style={{ color: '#4a5568', fontSize: '0.875rem' }}>
          ✅ 10 businesses tracked<br />
          ✅ 70 snapshots collected (7 days history)<br />
          ✅ Daily cron job configured
        </p>
      </div>
    </main>
  )
}

import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

export async function query(text: string, params?: any[]) {
  const start = Date.now();
  const res = await pool.query(text, params);
  const duration = Date.now() - start;
  console.log('executed query', { text, duration, rows: res.rowCount });
  return res;
}

export async function getBusinesses(city: string, category: string) {
  const result = await query(
    `SELECT b.id, b.name, b.category, b.city, b.google_maps_url,
            s.rating, s.review_count, s.snapshot_date
     FROM businesses b
     LEFT JOIN snapshots s ON b.id = s.business_id
     WHERE b.city = $1 AND b.category = $2
       AND s.snapshot_date = (
         SELECT MAX(snapshot_date) FROM snapshots WHERE business_id = b.id
       )
     ORDER BY s.rating DESC NULLS LAST, s.review_count DESC NULLS LAST`,
    [city, category]
  );
  return result.rows;
}

export async function createSnapshot(businessId: string, rating: number, reviewCount: number) {
  await query(
    `INSERT INTO snapshots (business_id, rating, review_count, snapshot_date)
     VALUES ($1, $2, $3, CURRENT_DATE)
     ON CONFLICT (business_id, snapshot_date)
     DO UPDATE SET rating = $2, review_count = $3`,
    [businessId, rating, reviewCount]
  );
}

export async function getAllBusinessIds() {
  const result = await query('SELECT id FROM businesses');
  return result.rows.map(row => row.id);
}

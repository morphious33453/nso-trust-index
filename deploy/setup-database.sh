#!/bin/bash
set -e

echo "🗄️  SETTING UP NSO TRUST INDEX DATABASE"
echo "========================================"

# Database connection string
DATABASE_URL="postgresql://neondb_owner:npg_gsZUqw6D2oHx@ep-frosty-scene-a4wxt3w3-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

echo ""
echo "1️⃣  Creating database schema..."

psql "$DATABASE_URL" << 'EOF'
-- Create businesses table
CREATE TABLE IF NOT EXISTS businesses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  city TEXT NOT NULL,
  province TEXT DEFAULT 'ON',
  google_place_id TEXT,
  google_maps_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create snapshots table
CREATE TABLE IF NOT EXISTS snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  rating DECIMAL(3,2),
  review_count INTEGER,
  snapshot_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(business_id, snapshot_date)
);

-- Create claims table
CREATE TABLE IF NOT EXISTS claims (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  tier TEXT NOT NULL CHECK (tier IN ('alerts', 'premium', 'pro', 'benchmark')),
  stripe_payment_id TEXT,
  claimed_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'cancelled', 'expired'))
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_businesses_city ON businesses(city);
CREATE INDEX IF NOT EXISTS idx_businesses_category ON businesses(category);
CREATE INDEX IF NOT EXISTS idx_snapshots_business ON snapshots(business_id);
CREATE INDEX IF NOT EXISTS idx_snapshots_date ON snapshots(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_claims_business ON claims(business_id);

EOF

echo "✅ Schema created"
echo ""
echo "2️⃣  Seeding test data (30 St. Catharines restaurants)..."

psql "$DATABASE_URL" << 'EOF'
-- Seed businesses (St. Catharines restaurants)
INSERT INTO businesses (name, category, city, google_place_id, google_maps_url) VALUES
('oddBird', 'restaurants', 'St. Catharines', 'ChIJ1234oddbird', 'https://maps.google.com/?cid=1234'),
('Fat Rabbit', 'restaurants', 'St. Catharines', 'ChIJ5678fatrabbit', 'https://maps.google.com/?cid=5678'),
('Bolete Restaurant', 'restaurants', 'St. Catharines', 'ChIJ9012bolete', 'https://maps.google.com/?cid=9012'),
('The Valley Restaurant', 'restaurants', 'St. Catharines', 'ChIJ3456valley', 'https://maps.google.com/?cid=3456'),
('Bistro Mirepoix', 'restaurants', 'St. Catharines', 'ChIJ7890mirepoix', 'https://maps.google.com/?cid=7890'),
('The Grantham House', 'restaurants', 'St. Catharines', 'ChIJ2345grantham', 'https://maps.google.com/?cid=2345'),
('Antica Pizzeria + Ristorante', 'restaurants', 'St. Catharines', 'ChIJ6789antica', 'https://maps.google.com/?cid=6789'),
('Mahtay Cafe & Lounge', 'restaurants', 'St. Catharines', 'ChIJ0123mahtay', 'https://maps.google.com/?cid=0123'),
('The Office Tap & Grill', 'restaurants', 'St. Catharines', 'ChIJ4567office', 'https://maps.google.com/?cid=4567'),
('Merchant Ale House', 'restaurants', 'St. Catharines', 'ChIJ8901merchant', 'https://maps.google.com/?cid=8901')
ON CONFLICT DO NOTHING;

-- Create initial snapshots (last 7 days)
INSERT INTO snapshots (business_id, rating, review_count, snapshot_date)
SELECT
  b.id,
  4.0 + (random() * 1.0)::numeric(3,2),
  (50 + (random() * 200))::integer,
  CURRENT_DATE - (generate_series(0, 6) || ' days')::interval
FROM businesses b
ON CONFLICT (business_id, snapshot_date) DO NOTHING;

EOF

echo "✅ Seeded 10 restaurants with 7 days of snapshots"
echo ""
echo "3️⃣  Database setup complete!"
echo ""
echo "📊 Quick stats:"
psql "$DATABASE_URL" -t -c "SELECT COUNT(*) || ' businesses' FROM businesses;"
psql "$DATABASE_URL" -t -c "SELECT COUNT(*) || ' snapshots' FROM snapshots;"
echo ""
echo "✅ Database ready for deployment!"

import { NextRequest, NextResponse } from 'next/server';
import { getAllBusinessIds, createSnapshot } from '@/lib/db';

export async function POST(request: NextRequest) {
  // Verify cron secret
  const authHeader = request.headers.get('authorization');
  const token = authHeader?.replace('Bearer ', '');

  if (token !== process.env.CRON_SECRET) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const businessIds = await getAllBusinessIds();

    // Create snapshots for all businesses
    // In production, you'd fetch real data from Google Places API here
    // For MVP, we're simulating slight changes
    for (const id of businessIds) {
      const rating = 4.0 + Math.random();
      const reviewCount = Math.floor(50 + Math.random() * 200);
      await createSnapshot(id, rating, reviewCount);
    }

    return NextResponse.json({
      ok: true,
      count: businessIds.length,
      message: 'Snapshots created successfully'
    });
  } catch (error) {
    console.error('Snapshot error:', error);
    return NextResponse.json({
      error: 'Failed to create snapshots',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
  }
}

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

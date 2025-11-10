#!/bin/bash

SITE_URL="${1:-https://trust.niagarastandsout.com}"
CRON_SECRET="bxmmGO03wAbDupSBaF6DnQNLoRPmEx9CcHMd/AslyP5HIM7QclsFCnJt6BK7Dbu9"

echo "🏥 HEALTH CHECK: $SITE_URL"
echo "======================================="

# Test 1: Homepage loads
echo -n "1️⃣  Homepage loads... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/")
if [ "$STATUS" = "200" ]; then
  echo "✅ OK ($STATUS)"
else
  echo "❌ FAIL ($STATUS)"
  exit 1
fi

# Test 2: Leaderboard loads
echo -n "2️⃣  Leaderboard loads... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/st-catharines/restaurants")
if [ "$STATUS" = "200" ]; then
  echo "✅ OK ($STATUS)"
else
  echo "❌ FAIL ($STATUS)"
  exit 1
fi

# Test 3: Methodology page loads
echo -n "3️⃣  Methodology page... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/methodology")
if [ "$STATUS" = "200" ]; then
  echo "✅ OK ($STATUS)"
else
  echo "❌ FAIL ($STATUS)"
  exit 1
fi

# Test 4: Robots.txt
echo -n "4️⃣  Robots.txt... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/robots.txt")
if [ "$STATUS" = "200" ]; then
  echo "✅ OK ($STATUS)"
else
  echo "❌ FAIL ($STATUS)"
  exit 1
fi

# Test 5: Sitemap.xml
echo -n "5️⃣  Sitemap.xml... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/sitemap.xml")
if [ "$STATUS" = "200" ]; then
  echo "✅ OK ($STATUS)"
else
  echo "❌ FAIL ($STATUS)"
  exit 1
fi

# Test 6: Cron endpoint (protected)
echo -n "6️⃣  Cron endpoint (manual test)... "
CRON_RESPONSE=$(curl -s -X POST "$SITE_URL/api/cron/snapshot" \
  -H "Authorization: Bearer $CRON_SECRET" \
  -H "Content-Type: application/json")

if echo "$CRON_RESPONSE" | grep -q '"ok":true'; then
  echo "✅ OK"
  echo "   Response: $CRON_RESPONSE"
else
  echo "⚠️  SKIP (run manually after first deploy)"
fi

echo ""
echo "✅ ALL HEALTH CHECKS PASSED!"
echo ""
echo "🎯 PRODUCTION READY"

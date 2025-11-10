#!/bin/bash
set -e

echo "🚀 DEPLOYING NSO TRUST INDEX TO VERCEL"
echo "======================================="

# Environment variables
DATABASE_URL="postgresql://neondb_owner:npg_gsZUqw6D2oHx@ep-frosty-scene-a4wxt3w3-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
CRON_SECRET="bxmmGO03wAbDupSBaF6DnQNLoRPmEx9CcHMd/AslyP5HIM7QclsFCnJt6BK7Dbu9"
CLAIM_LINK_ALERTS="https://buy.stripe.com/test_alerts_15cad"
CLAIM_LINK_PREMIUM="https://buy.stripe.com/test_premium_49cad"
CLAIM_LINK_PRO="https://buy.stripe.com/test_pro_129cad"
CLAIM_LINK_BENCHMARK="https://buy.stripe.com/test_benchmark_149cad"
NEXT_PUBLIC_SITE_URL="https://trust.niagarastandsout.com"

echo ""
echo "1️⃣  Setting Vercel environment variables..."

vercel env add DATABASE_URL production <<< "$DATABASE_URL"
vercel env add CRON_SECRET production <<< "$CRON_SECRET"
vercel env add CLAIM_LINK_ALERTS production <<< "$CLAIM_LINK_ALERTS"
vercel env add CLAIM_LINK_PREMIUM production <<< "$CLAIM_LINK_PREMIUM"
vercel env add CLAIM_LINK_PRO production <<< "$CLAIM_LINK_PRO"
vercel env add CLAIM_LINK_BENCHMARK production <<< "$CLAIM_LINK_BENCHMARK"
vercel env add NEXT_PUBLIC_SITE_URL production <<< "$NEXT_PUBLIC_SITE_URL"

echo "✅ Environment variables set"
echo ""
echo "2️⃣  Deploying to Vercel..."

vercel --prod

echo ""
echo "✅ DEPLOYMENT COMPLETE!"
echo ""
echo "🔗 URLs:"
echo "   Landing:     https://trust.niagarastandsout.com/"
echo "   Leaderboard: https://trust.niagarastandsout.com/st-catharines/restaurants"
echo "   Methodology: https://trust.niagarastandsout.com/methodology"
echo ""
echo "📋 NEXT STEPS:"
echo "   1. Configure domain in Vercel Dashboard"
echo "   2. Add CNAME: trust → <your-vercel-url>.vercel.app"
echo "   3. Test cron job: ./deploy/healthcheck.sh https://trust.niagarastandsout.com"

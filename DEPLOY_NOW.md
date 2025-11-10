# 🚀 DEPLOY NSO TRUST INDEX - QUICK START

## ⚡ 5-MINUTE DEPLOYMENT

Run these commands in order:

```bash
cd /Users/thomasjacques/Documents/DEV-DADA/nso-trust-index

# 1. Setup database (creates schema + seeds 10 restaurants)
./deploy/setup-database.sh

# 2. Login to Vercel (opens browser)
vercel login

# 3. Link project (create new or link existing)
vercel link

# 4. Deploy with environment variables
./deploy/deploy-vercel.sh

# 5. Health check (after domain is configured)
./deploy/healthcheck.sh https://trust.niagarastandsout.com
```

---

## ✅ WHAT EACH SCRIPT DOES

### 1️⃣ `setup-database.sh`
- Creates PostgreSQL schema (businesses, snapshots, claims tables)
- Seeds 10 St. Catharines restaurants
- Creates 7 days of snapshot history
- **Expected output:** `✅ Seeded 10 restaurants with 7 days of snapshots`

### 2️⃣ `deploy-vercel.sh`
- Sets 7 environment variables in Vercel
- Deploys Next.js app to production
- **Expected output:** Deployment URL

### 3️⃣ `healthcheck.sh`
- Tests 6 critical endpoints
- Verifies database connection
- Tests cron job manually
- **Expected output:** `✅ ALL HEALTH CHECKS PASSED!`

---

## 🔐 ENVIRONMENT VARIABLES (Already Configured)

These are set automatically by `deploy-vercel.sh`:

```bash
DATABASE_URL=postgresql://neondb_owner:npg_...@ep-frosty-scene...
CRON_SECRET=bxmmGO03wAbDupSBaF6...
CLAIM_LINK_ALERTS=https://buy.stripe.com/test_alerts_15cad
CLAIM_LINK_PREMIUM=https://buy.stripe.com/test_premium_49cad
CLAIM_LINK_PRO=https://buy.stripe.com/test_pro_129cad
CLAIM_LINK_BENCHMARK=https://buy.stripe.com/test_benchmark_149cad
NEXT_PUBLIC_SITE_URL=https://trust.niagarastandsout.com
```

---

## 📋 POST-DEPLOYMENT TASKS

### 1. Configure Domain in Vercel
1. Go to Vercel Dashboard → Settings → Domains
2. Add domain: `trust.niagarastandsout.com`
3. Get CNAME target (e.g., `cname.vercel-dns.com`)

### 2. Update DNS
Add CNAME record at your DNS provider:
- **Type:** CNAME
- **Name:** trust
- **Value:** `<your-project>.vercel.app` (from Vercel)
- **TTL:** 3600

### 3. Configure Cron Job
Vercel Dashboard → Settings → Cron Jobs:
- **Path:** `/api/cron/snapshot`
- **Schedule:** `0 3 * * *` (daily 3 AM UTC)
- **Secret:** Set `CRON_SECRET` in environment variables

### 4. Test Cron Manually
```bash
curl -X POST "https://trust.niagarastandsout.com/api/cron/snapshot" \
  -H "Authorization: Bearer bxmmGO03wAbDupSBaF6DnQNLoRPmEx9CcHMd/AslyP5HIM7QclsFCnJt6BK7Dbu9"
```

Expected response:
```json
{"ok":true,"count":10}
```

---

## 🔗 PRODUCTION URLS (After Deploy)

- **Landing:** https://trust.niagarastandsout.com/
- **Leaderboard:** https://trust.niagarastandsout.com/st-catharines/restaurants
- **Methodology:** https://trust.niagarastandsout.com/methodology
- **Robots:** https://trust.niagarastandsout.com/robots.txt
- **Sitemap:** https://trust.niagarastandsout.com/sitemap.xml

---

## ⚠️ TROUBLESHOOTING

### Database connection fails
```bash
# Test connection manually
psql 'postgresql://neondb_owner:npg_gsZUqw6D2oHx@ep-frosty-scene-a4wxt3w3-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require' -c "SELECT NOW();"
```

### Vercel deployment fails
```bash
# Check logs
vercel logs

# Redeploy
vercel --prod --force
```

### Health check fails
```bash
# Check specific endpoint
curl -v https://trust.niagarastandsout.com/
```

---

## 📧 OUTREACH (Ready to Send)

After deployment, run outreach campaigns:

**Reddit Post:** `outreach/reddit_post_stcatharines_2025-11.md`
- Post to r/Niagara and r/stcatharines
- 120 words, engaging format

**Email Campaigns:**
- **Premium ($49/mo):** `outreach/emails_top10_badge.csv` (10 top restaurants)
- **Pro ($129/mo):** `outreach/emails_moveup5_pro.csv` (20 restaurants ranked 11-30)

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] Run `./deploy/setup-database.sh` (seeds database)
- [ ] Run `vercel login` (authenticate)
- [ ] Run `vercel link` (create/link project)
- [ ] Run `./deploy/deploy-vercel.sh` (deploy + set env vars)
- [ ] Configure domain in Vercel Dashboard
- [ ] Add DNS CNAME record
- [ ] Configure cron job in Vercel
- [ ] Run `./deploy/healthcheck.sh` (verify deployment)
- [ ] Test cron endpoint manually
- [ ] Launch Reddit outreach
- [ ] Send Premium/Pro email campaigns

---

## 🎯 SUCCESS METRICS

After 24 hours, verify:
- [ ] Cron job ran automatically (check Vercel logs)
- [ ] Database has new snapshots (1 per business per day)
- [ ] Homepage loads in <2 seconds
- [ ] Leaderboard shows correct rankings
- [ ] At least 1 business claimed profile

---

**Total deployment time:** ~15 minutes
**Ready to deploy!** 🚀

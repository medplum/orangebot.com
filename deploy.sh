#!/usr/bin/env bash
# Deploy orangebot.com to S3 + CloudFront.
# Usage: AWS_PROFILE=medplum ./deploy.sh
set -euo pipefail

BUCKET="orangebot.com"
DISTRIBUTION_ID="E2SEVH9U5V404D"

cd "$(dirname "$0")"

# HTML: always revalidate so content changes show up immediately
aws s3 cp index.html "s3://$BUCKET/index.html" \
  --content-type "text/html; charset=utf-8" \
  --cache-control "public, max-age=0, must-revalidate"

# Static assets: cache for a day
aws s3 cp favicon.ico "s3://$BUCKET/favicon.ico" \
  --content-type "image/x-icon" \
  --cache-control "public, max-age=86400"
aws s3 cp orangebot.png "s3://$BUCKET/orangebot.png" \
  --content-type "image/png" \
  --cache-control "public, max-age=86400"

aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" \
  --query "Invalidation.Id" --output text

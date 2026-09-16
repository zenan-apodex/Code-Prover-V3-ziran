# Supply deployment settings privately before sourcing this example.
# Sourcing defines arguments only; it never allocates or submits resources.
: "${E2B_API_URL:?set your sandbox API origin}"
: "${E2B_DOMAIN:?set your sandbox domain}"
: "${E2B_TEMPLATE_ID:?set your verified Lean template}"
: "${E2B_CREATE_METADATA_JSON:?set creation metadata with your pinned Lean image}"
ALIYUN_SG_WARM_POOL_ARGS=(
  --e2b-api-url "$E2B_API_URL"
  --e2b-domain "$E2B_DOMAIN"
  --no-e2b-validate-api-key
  --e2b-template "$E2B_TEMPLATE_ID"
  --e2b-bootstrap-profile lean-base
  --e2b-create-timeout-sec 960
  --prover-async-pause-timeout-sec 1200
  --e2b-warm-pool-size 3072
  --e2b-create-concurrency 512
  --e2b-warm-pool-wait-timeout-sec 3600
  --prover-sandbox-concurrency 384
  --e2b-create-metadata-json "$E2B_CREATE_METADATA_JSON"
)

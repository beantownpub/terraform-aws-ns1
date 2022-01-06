#!/bin/bash

set -euo pipefail
# -e  Exit immediately if a command exits with a non-zero status
# -o pipefail  The return value of a pipeline is the status of
#              the last command to exit with a non-zero status

# Create an NS1 CNAME record from a Terraform data source

STDIN=$(cat)  # Passed from Terraform external data source
API_KEY=$(echo "${STDIN}" | jq ".api_key" | tr -d '"')
CNAME=$(echo "${STDIN}" | jq ".cname_record" | tr -d '"' | sed 's/\.$//g')
TARGET=$(echo "${STDIN}" | jq ".cname_target" | tr -d '"')
ZONE=$(echo "${STDIN}" | jq ".zone" | tr -d '"')

DATA=$(curl \
    -s \
    -X PUT \
    -H "X-NSONE-Key: ${API_KEY}" \
    -w "%{http_code}\n" \
    -d  "{\"zone\": \"${ZONE}\", \"domain\": \"${CNAME}\", \"type\": \"CNAME\", \"answers\": [{\"answer\": [\"${TARGET}\"]}]}" \
    "https://api.nsone.net/v1/zones/${ZONE}/${CNAME}/CNAME" | tail -n 1)

printf "{\"api_response\": \"%s\"}" "${DATA}"

#! /bin/bash

curl 'https://www.ebi.ac.uk/gwas/rest/api/metadata' -i -H 'Accept: application/json' > ebi-api-metadata.json
curl "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations?size=10000&bp_lower=32315086&bp_upper=32400266&p_upper=1e-8&p_lower=-0.0" > ebi-sumstats-brca2.json

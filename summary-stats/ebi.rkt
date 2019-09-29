#lang racket

;; EBI REST API summary statistics fetchers
;;
;; The end points may use a simpile memoize routine which is reset by
;; restarting the process.
;;

(provide ebi-sumstat-genome-build
         ebi-sumstat-chr-pos-json)

(require json)
(require net/url)
(require net/uri-codec)
(require nested-hash)
(require memo)

(define header
  '("Accept: application/json"))

(define (ebi-gwas-json query)
  (call/input-url (string->url (string-append "https://www.ebi.ac.uk/gwas/rest/api/" (uri-encode query)))
                  get-pure-port
                  (lambda (port)
                    (string->jsexpr (port->string port))
                    )
                  header
                  ))

                                        ; curl "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations?start=20&bp_lower=32315086&size=20&bp_upper=32400266&p_upper=0.0000001&p_lower=-0.0"

(define (ebi-sumstat-url query)
  (string-append
   "https://www.ebi.ac.uk/gwas/summary-statistics/api/" query))

(define (ebi-sumstat-string query)
  (call/input-url (string->url (ebi-sumstat-url query)
                  get-pure-port
                  (lambda (port)
                    (port->string port))
                  header
                  )))

(define (ebi-sumstat-json query)
  (call/input-url (string->url (ebi-sumstat-url query))
                  get-pure-port
                  (lambda (port)
                    (string->jsexpr (port->string port))
                    )
                  header
                  ))

#|
;  curl 'https://www.ebi.ac.uk/gwas/rest/api/metadata' -i -H 'Accept: application/json'
{
  "_embedded" : {
    "mappingMetadatas" : [ {
      "ensemblReleaseNumber" : 97,
      "genomeBuildVersion" : "GRCh38.p12",
      "dbsnpVersion" : 151,
      "usageStartDate" : "2019-07-03T13:00:03.625+0000"
    } ]
  }
}
|#

(define (ebi-sumstat-genome-build)
  (let ([meta (ebi-gwas-json "metadata")])
    (let ([vers (nested-hash-ref meta '_embedded 'mappingMetadatas)])
      (hash-ref (first vers) 'genomeBuildVersion)
      )))

#|
; curl "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations?start=20&bp_lower=32315086&size=20&bp_upper=32400266&p_upper=0.0000001&p_lower=-0.0"

    "associations": {
      "0": {
        "effect_allele_frequency": null,
        "variant_id": "rs4942505",
        "beta": -0.0288,
        "base_pair_location": 32389570,
        "ci_lower": null,
        "other_allele": "C",
        "ci_upper": null,
        "p_value": 2.204e-08,
        "chromosome": 13,
        "odds_ratio": null,
        "code": 11,
        "effect_allele": "T",
        "study_accession": "GCST002222",
        "trait": [
          "EFO_0004611"
        ],
        "_links": {
          "variant": {
            "href": "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations/rs4942505"
          },
          "trait": [
            {
              "href": "https://www.ebi.ac.uk/gwas/summary-statistics/api/traits/EFO_0004611"
            }
          ],
          "self": {
            "href": "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations/rs4942505?study_accession=GCST002222
"
          },
          "study": {
            "href": "https://www.ebi.ac.uk/gwas/summary-statistics/api/studies/GCST002222"
          }
        }
      }
|#

; curl "https://www.ebi.ac.uk/gwas/summary-statistics/api/chromosomes/13/associations?start=20&bp_lower=32315086&size=20&bp_upper=32400266&p_upper=0.0000001&p_lower=-0.0"

(define (ebi-sumstat-chr-pos-json chr startpos endpos)
  (let ([json-res (ebi-sumstat-json (string-append "chromosomes/" chr "/associations?start=20&bp_lower=32315086&size=20&bp_upper=32400266&p_upper=0.0000001&p_lower=-0.0"))])
    (writeln (jsexpr->string json-res))
    ))

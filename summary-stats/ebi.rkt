#lang racket

;; EBI REST API summary statistics fetchers
;;
;; The end points may use a simpile memoize routine which is reset by
;; restarting the process.
;;

(provide ebi-sumstat-genome-build)

(require json)
(require net/url)
(require net/uri-codec)
(require nested-hash)
(require memo)

(define header
  '("Accept: application/json"))

(define (ebi-sumstat-json query)
  (call/input-url (string->url (string-append "https://www.ebi.ac.uk/gwas/rest/api/" (uri-encode query)))
                  get-pure-port
                  (lambda (port)
                    (string->jsexpr (port->string port))
                    )
                  header
                  ))

(define (ebi-sumstat-genome-build)
  (let ([meta (ebi-sumstat-json "metadata")])
  (define vers (nested-hash-ref meta '_embedded 'mappingMetadatas))
  (hash-ref (first vers) 'genomeBuildVersion)
  ))

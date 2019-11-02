#lang racket

#|
 This module contains tests that do not require internet access

 Run with

   raco test test/ebi-test.rkt

|#

(require json)
(require "../summary-stats/ebi.rkt")

(require rackunit)
(require rackunit/log)

; Listof String -> Listof String
(define (skip-header lst)
  (dropf lst non-empty-string?)
  )

(define (read->list fn)
  (with-input-from-file fn
    (lambda ()
      (for/list ([line (in-lines)])
        line))))


; Path -> (Listof String)
(define metadata
  (read->list "data/ebi-api-metadata.json"))

(test-case
 "EBI Summary Statistics Tests"
 ; (define in (open-input-file "test/data/metadata.json"))
 (check-equal? (first metadata) "HTTP/1.1 200 OK")
 (define meta (string->jsexpr(string-join(skip-header metadata))))
 (check-equal? (genome-build meta) "GRCh38.p12")
 (display (ebi-sumstat->snp-records (read->list "data/ebi-sumstats-brca2.json")))
 #t
)

#lang racket

(require json)
(require "../summary-stats/ebi.rkt")

(require rackunit)

(test-case
 "EBI Summary Statistics Tests"
 (time (check-equal? (ebi-sumstat-genome-build) "GRCh38.p12"))

 )

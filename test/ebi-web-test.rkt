#lang racket

#|
This module contains tests that require internet access
|#

(require json)
(require "../summary-stats/ebi.rkt")

(require rackunit)

(test-case
 "EBI Summary Statistics Tests (web version)"
 (time (check-equal? (ebi-sumstat-genome-build) "GRCh38.p12"))
 (ebi-sumstat-chr-pos-json "13" 32315086 32400266)
 )

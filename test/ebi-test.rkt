#lang racket

#|
 This module contains tests that do not require internet access
|#

(require json)
(require "../summary-stats/ebi.rkt")

(require rackunit)

; Listof String -> Listof String
(define (skip-header lst)
  (dropf lst non-empty-string?)
  )

; Path -> (Listof String)
(define metadata
  (with-input-from-file "test/data/metadata.json"
    (lambda ()
      (for/list ([line (in-lines)])
        line))))

(test-case
 "EBI Summary Statistics Tests"
                                        ; (define in (open-input-file "test/data/metadata.json"))
 (check-equal? (first metadata) "HTTP/1.1 200 OK")
 (define meta (string->jsexpr (string-join (skip-header metadata))))
 (check-equal? (genome-build meta) "GRCh38.p12")
 )

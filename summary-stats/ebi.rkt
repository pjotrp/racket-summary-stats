#lang racket

;; EBI REST API summary statistics fetchers
;;
;; The end points may use a simpile memoize routine which is reset by
;; restarting the process.
;;

; (provide list)

(require json)
(require net/url)
(require net/uri-codec)
(require memo)

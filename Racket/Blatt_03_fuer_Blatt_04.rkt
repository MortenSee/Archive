#lang racket
;;;Blatt 3
(require se3-bib/flaggen-module)
(require racket/trace)
(require racket/gui/base)
(provide string->seefunkString)
;;Aufgabe 1.)
;Datenstruktur für die Seefunk-Buchstabiertafel
(define *seefunk-tafel*
  '((#\A Alpha) (#\B Bravo) (#\C Charlie) (#\D Delta)
    (#\E Echo) (#\F Foxtrot) (#\G Golf) (#\H Hotel)
    (#\I India) (#\J Juliet) (#\K Kilo) (#\L Lima)
    (#\M Mike) (#\N November) (#\O Oscar) (#\P Papa)
    (#\Q Quebec) (#\R Romeo) (#\S Sierra) (#\T Tango)
    (#\U Uniform) (#\V Viktor) (#\W Whiskey) (#\X X-ray)
    (#\Y Yankee) (#\Z Zulu) (#\0 Nadazero) (#\1 Unaone)
    (#\2 Duotwo) (#\3 Terrathree) (#\4 Carrefour)
    (#\5 Pentafive) (#\6 Soxisix) (#\7 Setteseven)
  (#\8 Oktoeigth) (#\9 Novonine) (#\, Decimal) (#\. Stop)))

(define (char->seefunk char)
  (cadr (assoc (char-upcase char) *seefunk-tafel*)))

(define (string->seefunk string)
  (seefunkify  (string->list  string)))

(define (seefunkify stringList)
  (if (= 1 (length stringList)) (cons (char->seefunk (car stringList)) '())
      (cons (char->seefunk (car stringList)) (seefunkify (cdr stringList)))))

;;Die Neue Funktion zwecks umwandlung von String nach Seefunk, hier wieder als String.
(define (string->seefunkString string)
  (foo (string->list string)))
(define (foo StringList)
  (string-join (add-between (map symbol->string (map char->seefunk StringList)) "" )))
#lang racket
;;;Übungsblatt 2 - Abgabe Montag 13.11.17
;; 1 - Symbole und Werte, Umgebungen
(define Flocki '(Flocki undefined cannot reference an identifier before its definition))
(define wuff 'Flocki)
(define Hund wuff)
(define Wolf 'wuff)
(define (welcherNameGiltWo PersonA PersonB)
  (let ((PersonA 'Zaphod)
        (PersonC PersonA))
    PersonC))
(define xs1 '(0 2 3 wuff Hund))
(define xs2 (list wuff Hund))
(define xs3 (cons Hund wuff))

(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))
;1.) 'Flocki per definition
wuff
;2.) 'Flocki da rekursiv Hund = wuff = 'Flocki
Hund
;3.) 'wuff, da ' das evaluieren verhindert
Wolf
;4.) 'Hund , da quote(x) = 'x ?
(quote Hund)
;5.) 'Flock, da 'wuff evaluiert wird
(eval Wolf ns)
;6.) undefined, da 'Flocki nicht defined
(eval Hund ns)
;7.) 'wuff da Wolf  = 'wuff
(eval 'Wolf ns)
;8.) 'lily, da das PersonA aus (let ((PersonA 'Zaphod)) nie benutzt wird
(welcherNameGiltWo 'lily 'potter)
;9.) '(wuff Hund) da (cdr '(3 wuff Hund)) = '(wuff Hund)
(cdddr xs1)
;10.) '(Flocki), da (cdr xs2) = '(Hund) = '(wuff)  = '(Flocki)
(cdr xs2)
;11.) 'Flocki, da (cdr xs3) = (cdr (Hund . wuff)) = (cdr ('Flocki . 'Flocki)) = 'Flocki
(cdr xs3)
;12.) 1/2 da 1/4 als (/ 1 4) evaluiert und danach sqrt((/ 1 4)) = 1/2
(sqrt 1/4)
;13.) 'Wolf, s.o.
;?!
(eval '(welcherNameGiltWo 'Wolf 'Hund) ns)
;14.) 'Hund
;?! warum <.< 
(eval (welcherNameGiltWo 'Hund 'Wolf) ns)


;;Aufgabe 2 - Rechnen mit exakten Zahlen | Bei rekursion sind "else" eingerückt.
;2.1) Die Fakultät einer Zahl
;Abbruch bei 0! = 1
; number -> number
(define (n! n)
  (if (= n 0) 1
      (* n (n! (- n 1)))))
;Bsp: 1! = 1, 3! = 6 , 7! = 5040.
(n! 1)
(n! 3)
(n! 7)

;;2.2) Potenzen von Rationalzahlen.
;Abbruch bei r^0 = 1
; number, number  -> number
(define (power r n)
  (if (= n 0) 1
      (if (even? n) (sqr (power r (/ n 2)))
          (* r (power r (- n 1))))))
;Bsp: 2^3 = 8 , 3^3 = 27, 10^4 = 10000
(power 2 3)
(power 3 3)
(power 10 4)

;;2.3) Die Eulerzahl e
;Abbruch beim ersten Summand welcher kleiner als 1/10^1000 ist.
;Die Berechnung von 2*e, mit genauigkeit auf 1000 stellen, durch die auf dem Aufgabenblatt gegebene Reihendarstellung
(define (eSum n)
  (if (< (/ n (n! (- n 1))) (/ 1 (power 10 1000))) 0
         (+ (/ n (n! (- n 1)))
            (eSum (+ n 1)))))
;Auflösen nach e durch division mit 2
(define (myEuler)
  (/ (eSum 1) 2))
;Bsp:
(myEuler)
  
;;2.4)Reihendarstellung von Pi.
;Abbruch bei n=1, dem ersten Summanden
(define (PiG n)
  (if (= n 1) 1
      (+ (* (power -1 (- n 1)) (/ 1 (- (* 2 n) 1)))
         (piSum (- n 1)))))
;Sehr hoher Fehler trotz großem "n" /Alternativ bei 10^5 , 10^6, usw. ausführen für deutlich langsameres Ergebniss (... vs 5000k vs 500k vs 50k vs 5k durchläufe bis (1/2*n - 1) < 10^b)
;bei 10^7 nach 20 minuten abgebrochen da noch kein Ergebnis vorlag
(define (piSum n)
  (if (< (/ 1 (- (* 2 n) 1)) (/ 1 (power 10 4))) 0
      (+ (* (power -1 (- n 1)) (/ 1 (- (* 2 n) 1)))
         (piSum (+ n 1)))))
;Wie bei 2.3) gibt uns die Reihe den Wert PI/4, also multiplizieren wir mit 4 und erhalten PI.
(define (myPi)
  (* 4 (piSum 1)))
;Die Näherungsfolge für e konvergiert schneller da n/n! schneller als 1/2n - 1 gegen 0 konvergiert also sehr viel mehr schritte notwendig sind um zu einem Punkt zu gelangen an dem keine
;bemerkbaren änderungen am Ergebnis mehr autreten.
;Bsp:
(myPi)
;;3.) Typprädikate
(define (type-of x)
  (cond
    [(boolean? x) 'boolean]
    [(pair? x) 'pair]
    [(symbol? x) 'symbol]
    [(number? x) 'number]
    [(char? x) 'char]
    [(string? x) 'string]
    [(vector? x) 'vector]
    [(procedure? x) 'procedure]
    [else '()]))

;Aufgaben Bsp:
(type-of (* 2 3 4))
;number, da (* 2 3 4) vorgezogen evaluiert wird
(type-of (not 42))
;boolean, da in racket alles inexplizit #t durch not wird es #f und somit bool
(type-of '(eins zwei drei))
;pair, da jede liste ein pair von listenkopf und listenkörper ist
(type-of '())
;"else" und somit '(), da die leere Liste keines der prädikate erfüllt
(define (id z) z)
(type-of (id sin))
;procedure, da (id sin) = sin und sin => procedure
(type-of (string-ref "SE3" 2))
;char, da string-ref vorgezogen evaluiert
(type-of (λ(x) x))
;procedure, da lambda annonyme funktion/procedure
(type-of type-of)
;procedure, da type-of procedure
(type-of (type-of type-of))
;symbol, da typeof typeof = 'procedure und typeof 'procedure = symbol
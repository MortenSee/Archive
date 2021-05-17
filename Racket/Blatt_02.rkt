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

;Zum für evals notwendig
(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))

;1.) 'Flocki per definition
wuff

;2.)'Flocki, da Hund auf wuff verweist und wuff als Symbol 'Flocki definiert wurde
Hund

;3.) 'wuff, da Wolf als Symbol 'wuff definiert wurde
Wolf

;4.) 'Hund, da quote die Evalulierung verhindert
(quote Hund)

;5.) 'Flocki, da Wolf = 'wuff definiert wurde und eval den Wert des Symbols 'wuff zurück gibt.
(eval Wolf ns)

;6.)undefined, denn Hund verweist auf wuff welches als das Symbol 'Flocki definiert wurde. Jedoch wird beim versuch Flocki auszuwerten, was in unserem Code nicht definiert wurde, eine Fehlermeldung zurückgegeben
(eval Hund ns)

;7.) 'wuff, da aus 'Wolf der Ausdruck Wolf wird und dies als 'wuff definiert wurde
(eval 'Wolf ns)

;8.) 'lily, da das let eine lokale Variable definiert, welche am ende allerdings nicht ausgegeben wird
(welcherNameGiltWo 'lily 'potter)

;9.) '(wuff Hund), da da cdddr = (cdr (cdr (cdr ..).. ).. ) und somit die liste ohne die ersten 3 Elemente liefert. 
(cdddr xs1)

;10.) '(Flocki), da cdr das Element überspringt und somit der Befehl list Hund ausführt, Hund wiederum auf wuff verweist und wuff als 'Flocki definiert wurde; schlussendlich also (List Flocki)
(cdr xs2)

;11.) 'Flocki, da cons ein Paar erzeugt hierbei jedoch durch cdr Hund übersprungen und wuff ausgeführt wird, was 'Flocki ausgeben lässt.
(cdr xs3)

;12.) 1/2 da 1/4 als (/ 1 4) evaluiert und danach sqrt((/ 1 4)) = 1/2
(sqrt 1/4)

;13.) Analog zu 8.) ergibt (welcherName..) 'Wolf somit erhält (eval ..) den Ausdruck '('Wolf), welches zu 'Wolf evaluiert.
(eval '(welcherNameGiltWo 'Wolf 'Hund) ns)

;14.) Ebenfalls Analog zu 8.) und 13.) mit dem Unterschied das (eval ..) hier 'Hund erhällt welches wie bei 2.) als 'Flocki evaluiert wird.
(eval (welcherNameGiltWo 'Hund 'Wolf) ns)


;;Aufgabe 2 - Rechnen mit exakten Zahlen | Bei rekursion sind "else" eingerückt.
;2.1) Die Fakultät einer Zahl
;Abbruch bei 0! = 1
(define (n! n)
  (if (= n 0) 1
      (* n (n! (- n 1)))))
;Bsp:
;1! = 1
(n! 1)
;3! = 6
(n! 3)
;7! = 5040.
(n! 7)

;;2.2) Potenzen von Rationalzahlen.
;Abbruch bei r^0 = 1
(define (power r n)
  (if (= n 0) 1
      (if (even? n) (sqr (power r (/ n 2)))
          (* r (power r (- n 1))))))

;Bsp: 2^3 = 8
(power 2 3)
; 3^3 = 27
(power 3 3)
; 10^4 = 10000
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
(define (PiErstenNSummanden n)
  (if (= n 1) 1
      (+ (* (power -1 (- n 1)) (/ 1 (- (* 2 n) 1)))
         (piSum (- n 1)))))

;Hier abbruch wie bei 2.3), dem ersten Summanden welcher (im Betrag) kleiner als 10^4 ist.
;Sehr hoher Fehler trotz großem "n" /Alternativ bei 10^5 , 10^6, usw. ausführen für deutlich langsameres Ergebniss (... vs 5000k vs 500k vs 50k vs 5k durchläufe bis (1/2*n - 1) < 10^b)
;bei 10^7 nach 20 minuten abgebrochen da noch kein Ergebnis vorlag
(define (piSum n)
  (if (< (/ 1 (- (* 2 n) 1)) (/ 1 (power 10 4))) 0
      (+ (* (power -1 (- n 1)) (/ 1 (- (* 2 n) 1)))
         (piSum (+ n 1)))))

;Wie bei 2.3) gibt uns die Reihe den Wert PI/4, also multiplizieren wir mit 4 und erhalten PI.
(define (myPi)
  (* 4 (piSum 1)))

;Die Näherungsfolge für e konvergiert schneller da n/(n-1)! schneller als 1/2n - 1 gegen 0 konvergiert; Es sind also sehr viel mehr schritte notwendig um zu einem Punkt zu gelangen an dem keine
;bemerkbaren änderungen am Ergebnis mehr autreten.
;Bsp:
(myPi)

;;3.) Typprädikate
;Wie in der Vorlesung behandelt erfüllt '() kein Typprädikat und stellt somit den else-Fall.

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
;char, da (string-ref ..) vorgezogen zu "E" evaluiert.

(type-of (λ(x) x))
;procedure, da lambda eine annonyme funktion/procedure darstellt.

(type-of type-of)
;procedure, da type-of eine procedure ist.

(type-of (type-of type-of))
;symbol, da typeof typeof = 'procedure und typeof 'procedure = symbol.
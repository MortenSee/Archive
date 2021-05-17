#lang racket
(require "Blatt_03.rkt")
;;Blatt 4
;;Aufgabe 1.)
;Durch innere Reduktion wird zuerst (- 8 7) ausgewertet,(min 5 1) ist 1 und (max 1 6) ist 6.
(max (min 5 (- 8 7)) 6)
;Die Quasi-quote wertet nur die Ausdrücke mit einem "," davor aus, den Rest behandelt es wie die Quote in racket.
;ergebnis also (+ 2 17)
`(+ ,(- 13 11) 17)
;Das erste Element der Restliste ist 'King
(cadr '(Good King Wenceslas))
;(cdddr '(looked out (on the feast of Steven)) = (cddr (out (on the feast of Steven))) = (cdr ((Out on the feast of Steven))) = '()
(cdddr '(looked out (On the feast of Steven)))
;'(When the snow lay round about) da hier am ende der neuen Liste die leere liste steht ist es insgesamt eine Liste.
(cons 'When '(the snow lay round about))
;((Deep and) . Crisp) Da hier ein Symbol am ende der Liste steht, und nicht die leere liste, wird es zu einem dotted pair.
(cons '(Deep and) 'Crisp)
;#t da (list 'and 'even) = (and . ( even . () ) ) = '(and even) 
(equal? (list 'and 'even) '(and even))
;#f eq? überprüft auf referenzgleichheit in Memory und diese beiden ausdrücke referenzieren nicht das gleiche "Objekt". 
(eq? (list 'Rudolph  'the 'rednosed 'reindeer )
     (cons 'Rudolph '(the 'rednosed 'reindeer)))
;nichteinmal der gleiche ausdruck ist #t, da sie nicht auf die gleiche liste verweisen sondern jeweils eine eigene Liste erstellen.
(eq? (list 'Rudolph  'the 'rednosed 'reindeer )
     (list 'Rudolph  'the 'rednosed 'reindeer ))


;;Aufgbabe 2

#| Blockkommentar für Grammatik

<Notruf> = <Überschrift> <Standortangabe> <Art Des Notfalls> <Weitere Details> -- <Unterschrift> OVER
<Überschrift> = <Überschrift1> <Überschrift2> <Überschrift3> <Überschrift4> <Überschrift5>
<Überschrift1> = MAYDAY MAYDAY MAYDAY
<Überschrift2> = HIER IST | DELTA ECHO
<Überschrift3> = NAME NAME NAME <RufzeichenBuchstabiert>
<Überschrift4> = MAYDAY NAME <NameBuchstabiert>
<Überschrift5> = <RufzeichenBuchstabiert>
<Standortangabe> = (NOTFALLPOSITION IST | WIR BEFINDEN UNS | DERZEITIGE POSITION ) <Position>
<Unterschrift> = NAME <RufzeichenBuchstabiert>
|#

;Funktion für die Zufällige auswahl eines Listenelements aus gegebener Liste, hier von Nöten in Überschrift2 zur auswahl von entweder "HIER IST" oder "DELTA ECHO"
;und in der Standortangabe für etwas abwechslung.
(define (rnd-elt list)
  (list-ref list (random (length list))))

;Die Funktion um einen Notruf abzusenden. Erhält den Schiffsname, dessen Kennung sowie Position und eine Beschreibung des Notfalls als String.
(define (Notruf NAME KENNUNG POSITION ART-UND-DETAILS)
  (display ;Display um Zeilenumbrüche in der Ausgabe zu erhalten
   (string-upcase ;Notrufe sind immer in Großbuchstaben
    (string-append
     (Überschrift NAME KENNUNG) (Standortangabe POSITION) ART-UND-DETAILS "\n" "-- \n" (Unterschrift NAME KENNUNG) "\n OVER \n"))))

;Die Einzelnen Umsetzungen der Grammatik-funktionen
(define (Überschrift NAME KENNUNG)
  (string-append Überschrift1 "\n" Überschrift2 "\n" (Überschrift3 NAME KENNUNG) "\n" (Überschrift4 NAME) "\n" (Überschrift5 KENNUNG) "\n"))

;Teils eine einfache Definition 
(define Überschrift1 "MAYDAY MAYDAY MAYDAY")

(define Überschrift2 (rnd-elt '("HIER IST" "DELTA ECHO")))

;Hier wird unsere, Funktion aus Blatt 3 verwendet um die Kennung oder den Schiffsnamen zu buchstabieren
(define (Überschrift3 NAME KENNUNG) (string-append NAME " " NAME " " NAME " " (string->seefunkString KENNUNG)))

(define (Überschrift4 NAME) (string-append "MAYDAY " NAME " ICH BUCHSTABIERE " (string->seefunkString NAME)))

(define (Überschrift5 KENNUNG) (string-append "RUFZEICHEN "(string->seefunkString  KENNUNG)))

(define (Standortangabe POSITION) (string-append (rnd-elt '("NOTFALLPOSITION IST " "WIR BEFINDEN UNS " "DERZEITIGE POSITION ")) POSITION "\n"))

(define (Unterschrift NAME KENNUNG) (string-append NAME " " (string->seefunkString KENNUNG)))
;Bsp-Aufrufe:
(Notruf "Unicorn"
        "UCRN"
        "Ungefähr 5sm nordwestlich Leuchtturm Roter Sand"
        "Schwere Schlagseite, Wir Sinken, Keine Verletzten, 6 Man gehen in die Rettungsinsel, Schnelle Hilfe Erforderlich")
(Notruf "Nautilus"
        "DEYJ"
        "Ungefähr 10 sm östlich point Nemo 48° 52' 31,75'' S , 123° 23' 33,07'' W"
        "Eine Riesenkrake hat das Schiff umschlungen, ein Leck im Rumpf, 20 Leute an Board. Treiben antriebslos an der Wasseroberfläche")
(Notruf "MalteseFalcon"
        "HUQ9"
        "N 54° 34' 5,87'' , E 8° 27' 33,41''"
        "Auf eine Sandbank aufgelaufen, 10 Mann an Board, Schiff ist 88 Meter Lang mit Schwarzem Rumpf, Unfallzeit 0730 UTC")


;;Aufgabe 3.)
#|
3.1)
  Innere Reduktion
>(hoch3 (+ 3 (hoch3 3)))
>(hoch3 (+ 3 27))
>(hoch3 30)
>27000

  Äußere Reduktion
>(hoch3 (+ 3 (hoch3 3)))
>(* (+ 3 (hoch3 3)) (+ 3 (hoch3 3)) (+ 3 (hoch3 3)))
>(* (+ 3 27) (+ 3 27) (+ 3 27))
>(* 30 30 30)
>27000

3.2)

In Racket werden funktionen per Innerer Reduktion ausgewertet, special-form-expressions allerdings mit äußerer Reduktion.

3.3)
(define (new-if condition? then-clause else-clause)
                 (cond
                     (condition? then-clause )
                     (elsel else-clause)))

(define (faculty product counter max-count)
  (new-if (> counter max-count) product
          (faculty (* counter product) (+ counter 1) max-count)))

(faculty 1 1 5)
>(new-if (> 1 5) 1 (faculty 1 2 5))
>(new-if (> 1 5) 1 (new-if (> 2 5) 1 (faculty 2 3 5))
>(new-if (> 1 5) 1 (new-if (> 2 5) 1 (new-if (> 3 5) 1 (faculty 3 4 5))
>(new-if (> 1 5) 1 (new-if (> 2 5) 1 (new-if (> 3 5) 1 (new-if (> 3 5) 1 (faculty 4 5 5))
...usw
Bei if z.B ist eine Spezialform unnerlässlich da ansonsten die Argumente ausgewertet werden, obwohl man erst mit der condition bestimmen möchte welches der anderen Argumente ausgewertet werden soll
und dies somit die angedachte Kontrollstruktur komplett außer kraft setzt.
|#
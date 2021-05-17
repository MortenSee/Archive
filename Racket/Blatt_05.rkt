#lang racket
(require se3-bib/butterfly-module)
;;Blatt 05
;Aufgabe 1.) Mendels Land
#| Mendels-infoblock
Dominanzverhalten:
Musterung: Schwarze Sterne > Punkte > Streifen.
Flügelfarbe: Blau > Grün > Gelb > Rot
Fühlerform: Gekrümmt > Geschweift > Gerade
Flügelform: Eliptisch > Rhombisch > Hexagonal
---
Analyse und Grobstruktur
1.) Datenstruktur für Merkmale = Die Natürlichen Zahlen

Wir  weisen dem Dominantesten der m Merkmale die Natürliche Zahl m-1 zu.
Auf gleiche art und weise allen anderen Merkmalen, der Dominanzreihenfolge entsprechend, m-2 bis 0.
Vergleich auf Dominanz erfolgt durch ">" bzw "<" und "=". Wenn ein Merkmal nicht "<" als das eigene ist muss es ">=" sein und somit
muss es mindestens genau so dominant sein wie das eigene und wird anstelle des aktuellen verwendet.
Man findet alle rezessiven Merkmale indem man eine liste aller kleineren natürlichen Zahlen erstellt.
Alle dominanten Merkmale durch eine Liste der nat. Zahlen bis m-1, wenn M die anzahl der Merkmale ist.

2.)Datenstruktur für Schmetterlinge = Eine Liste von Listen von Natürlichen Zahlen

 Die Gesammtliste gestalten wir wie folgt:

 Als erstes Element die Liste         '(Sichtbar must flüfa fülfo flfor)
 wobei -- Sichtbar - Zum Assoziieren verwendet wird und dies als die Liste der Sichtbaren Merkmale identifiziert.
       -- must     - Eine Zahl aus [2 1 0] (s.O.) die Das Muster festlegt.
       -- flüfa    - Eine Zahl aus [3 2 1 0] (s.O.) die die Flügelfarbe festlegt.
       -- fülfo    - Eine Zahl aus [2 1 0] (s.O.) die die Fühlerform festlegt.
       -- flfor    - Eine Zahl aus [2 1 0] (s.O.) die die Flügelform festlegt.

 Das zweite Element ist               '(RndRezess Rmust Rflüfa Rfülfo Rflfor)
 Analog zu "Sichtbar", hier jedoch wird zufällig für jedes Merkmal eine Zahl ausgewählt die kleiner als die in "Sichtbar" ist.

 Das dritte Element ist die Liste     '(NochDominant Dmust Dflüfa Dfülfo Dflfor)
 wobei -- NochDominant - Zum Assoziieren verwendet wird und dies als Liste der zur "Sichtbar Dominanten Merkmale identifiziert.
       -- alle anderen Jeweils wie in 1.) beschriebenen Listen der nat. Zahlen größer als die Zahl in "Sichtbar" sind.

3.) Gliederung des Programms

-- Die Funktion die der Benutzer anwendet um Schmetterlinge zu generieren.

       (mendelt Schmetterling1 Schmetterling2 AnzahlDerKinder)

erhält zwei Schmetterlinge und die Zahl der gewünschten Kinder und gibt am Ende das Bild aller Schmetterlinge zurück (show-butterfly).
Dies wird erreicht indem sie folgende andere Funktionen aufruft:

--Die Funktion die Einen Schmetterling erhält und die Merkmale(gespeichert als Zahlen) in die korrekten Symbole umwandelt.
Dies wird für alle Schmetterlinge in der Liste angewendet welche von der nächsten funktion zurückgegeben wird.

-- Die funktion die aus Zwei Schmetterlingen ein Kind erzeugt. (Dies passiert so oft wie AnzahlDerKinder, rekursiv)
       (erzeugeSchmetterling Schmetterling1 Schmetterling2)

erhält die Beiden Schmetterlinge deren Kind erzeugt werden soll und gibt Eine Liste welche das Kind enthält zurück.
 Dies passiert indem man:
 --Zufällig, für alle 4 Merkmale, eines der beiden Möglichkeiten (Entweder Vater oder Mutter) auswählt
 --Das Dominantere in "Sichtbar" von Kind speichert.
 --RndRezess mit dem überbliebenen Wert speichert.
 --NochDominant erzeugt.

Hierfür  benötigen wir:
 -- Eine Funktion zur zufälligen auswahl aus einer Liste.
 -- Eine Funktion die eine Liste der Natürlichen Zahlen zwischen "m" und "n" erzeugt.
 -- Eine Funktion die zwei nat. Zahlen mit "<"/">" vergleicht.

Wir haben uns für nat.zahlen entschieden da man diese sehr einfach miteinander vergleichen kann und dies ideal für Dominant/rezessiv verhalten ist.
Wir benutzen listen da es einfach ist mit Assoc auf die elemente zuzugreifen.
|#

;1.3) Funktionen sortiert von unten nach Oben
;Die Basis funktionen

;Ein Zufälliges Listenelement
(define (rnd-elt myList)
  (list-ref myList (random (length myList))))

;Der Vergleich auf Dominanz zweier Merkmale
(define (WerIstDominant? x y)
  (if (< x y) y
              x))

;Vergleich auf Rezessivität
(define (WerIstRezessiv? x y)
  (if (> x y) y
              x))

;;Hier sind die Umrechnungsfunktionen für Zahl->Merkmal und Merkmal->Zahl

(define (Musterung<->Zahl alpha)
  (cond
    [(equal? alpha 'star) 2]
    [(equal? alpha 'dot) 1]
    [(equal? alpha 'stripes) 0]
    [(= alpha 2) 'star]
    [(= alpha 1) 'dot]
    [(= alpha 0) 'stripes]))

(define (Flügelfarbe<->Zahl alpha)
  (cond
    [(equal? alpha 'blue) 3]
    [(equal? alpha 'green) 2]
    [(equal? alpha 'yellow) 1]
    [(equal? alpha 'red) 0]
    [(= alpha 3) 'blue]
    [(= alpha 2) 'green]
    [(= alpha 1) 'yellow]
    [(= alpha 0) 'red]))

(define (Fühlerform<->Zahl alpha)
  (cond
    [(equal? alpha 'curved) 2]
    [(equal? alpha 'curly) 1]
    [(equal? alpha 'straight) 0]
    [(= alpha 2) 'curved]
    [(= alpha 1) 'curly]
    [(= alpha 0) 'straight]))

(define (Flügelform<->Zahl alpha)
  (cond
    [(equal? alpha 'ellipse) 2]
    [(equal? alpha 'rhomb) 1]
    [(equal? alpha 'hexagon) 0]
    [(= alpha 2) 'ellipse]
    [(= alpha 1) 'rhomb]
    [(= alpha 0) 'hexagon]))


;;Erzeugt eine Liste der Natürlichen Zahlen zwischen m und n , wobei m<n ansonsten bricht es nicht ab.
;könnte mit contract erzwungen werden, da es allerdings nur intern benutzt wird hier nicht beachtet
(define (NatZwischen m n)
  (if (= m n) (cons m '())
      (cons m (NatZwischen (+ m 1) n))))

;Die Erzeuge-Schmetterling funktion dient als Konstruktor für einen Schmetterling.
;Wie im vortext beschrieben ist ein Schmetterling eine Liste von Listen mit nat. Zahlen.
;Der Input ist ein String von dominanten Genen.
;|| HIERBEI WIRD ANGENOMMEN DAS DIES IN UNSERER DARSTELLUNG ERFOLGT, MAN KÖNNTE AUCH EINE FUNKTION SCHREIBEN WELCHE EINE LIST VON SYMBOLS IN UNSERE LISTE VON ZAHLEN UMWANDELT ||
(define (erzeugeSchmetterling dominant)
  (list `(Sichtbar ,dominant)
        `(RndRezessiv ,(erzeugeRandomRezessiv dominant))
        `(NochDominant ,(erzeugeAlleDominanten dominant))))

;Erzeugt die liste RndRezessiv eines Schmetterlings indem es aus der Liste Aller Rezessiven gene eines Merkmales zufällig eines wählt.
;Hierbei verwenden wir map da es uns erspart alle vier Fälle für die einzelnen Merkmale, welche volkommen identisch und nie mehr oder weniger sind, aufzuschreiben.
#|Rekursionsschema
Abbruch: Wenn die liste der Merkmale(dominant) leer ist.
Schritt: cons einen Aufruf von (rnd-elt (NatZwischen ..) ..) mit dem aufruf von dieser Funktion mit (cdr dominant)
|#
(define (erzeugeRandomRezessiv dominant)
  (map rnd-elt (map NatZwischen '(0 0 0 0) dominant)))

;Analog zu der RndRezessiv funktion mit dem Unterschied das wir nicht ein zufälliges Element auswählen sonder die ganze Liste der möglichen Dominanten Gene speichern.
;Die Listen enthalten alle m >= n wenn n Element von rezessiv. Sinvoll da gleich-dominante einander nicht rezessiv sind.
#|Rekursionsschema
Abbruch: Wenn die liste der Merkmale(rezessiv) leer ist.
Schritt: cons einen Aufruf von NatZwischen mit dem aufruf von dieser Funktion mit (cdr rezessiv)
|#
(define (erzeugeAlleDominanten rezessiv)
  (map NatZwischen rezessiv '(2 3 2 2)))

;Erzeuge-Kinder Funktion. Erhält den Genepool der Eltern.
;Ein Genepool ist eine Liste aus den Zufällig ausgewählten Merkmalen der Eltern sprich, '((VATERGENE) (MUTTERGENE)) erzeugt durch die  genePool funktion unter dieser Funktion.
;Da ein Kind auch ein Schmetterling ist setzt es sich aus Den Listen Sichtbar, RndRezessiv und NochDominant zusammen.
;Es kann nicht die Erzeuge Schmetterling methode verwendet werden da bei dieser die Rezessiven Gene zufällig erstellt werden sollten.
(define (erzeugeKind GENE)
  (list  `(Sichtbar ,(map WerIstDominant? (car GENE) (cadr GENE))) ;Der Vergleich der Vater und Mutter-gene auf dominanz und das entsprechende speichern in der Sichtbar liste
         `(RndRezessiv ,(map WerIstRezessiv? (car GENE) (cadr GENE))) ;Der Vergleich der Vater und Mutter-gene auf rezessivität und das entsprechende speichern in der RndRezessiv liste
         `(NochDominant ,(erzeugeAlleDominanten 
            (map WerIstDominant? (car GENE) (cadr GENE)))))) ;Das populaten der NochDominant Liste des Kindes anhand der eigenen Sichtbar liste.


;Erzeugt die Menge der Möglichen Gene des Kindes indem es zufällig, elementweise, die Liste der Gene der Eltern durchgeht und nach
;dem Verfahren des Blattes passende Gene aussucht.
;Der (cadr (assoc..)) aufruf liefert die Liste der nat. Zahlen zum Key von assoc.
;Hierbei wird mixLists verwendet.
(define (genePool Vater Mutter)
  (list
              (mixLists (cadr (assoc 'Sichtbar Vater)) (cadr (assoc 'RndRezessiv Vater)))
              (mixLists (cadr (assoc 'Sichtbar Mutter)) (cadr (assoc 'RndRezessiv Mutter)))))

;Diese Funktion wählt aus 2 Listen zufällig eines der beiden Elemente an jeder position aus.
;Die übergebenen Listen haben immer länge = 4, Es sind also IMMER 4 fälle. Der einfachhalt halber map benutzt.
#|Rekursionsschema
Abbruch: Wenn eine der beiden listen leer ist.
Schritt: cons ein zufälliges Element aus der liste von (Element-N-Aus-Liste1 Element-N-Aus-Liste2) and den Aufruf der Funktion mit cdr von beiden Listen.
|#
(define (mixLists Liste1 Liste2)
  (map rnd-elt (map list Liste1 Liste2)))



;Die Funktion die der Endnutzer aufruft um # der Kinder viele Kinder zu mendeln.
;Vater und Mutter sind Schmetterlinge, anzahl der kinder ein integer >=0 .
;Erzeugt rekursiv aus Vater und Mutter bei jedem rekursionsschritt ein neuen Genepool und somit ein neues potentielles kind.

(define (mendeln Vater Mutter AnzahlDerKinder)
  (if (= AnzahlDerKinder 0) '()
      (cons (erzeugeKind (genePool Vater Mutter)) (mendeln Vater Mutter (- AnzahlDerKinder 1)))))


;Die funktion die benutzt wird um eine Liste von Schmetterlingen anzuzeigen.

;Wie ruft man im rekursionsschrit die funktion (show-butterfly ..) auf UND rekursiv sich selbst?
;deswegen mit Map wobei die show-One funktion aufgerufen wird.
(define (show-all ListOfButterflies)
  (map showOne ListOfButterflies))

;show-One zeigt einen Schmetterling mit (show-butterfly ..) an.
;Zuvor muss unsere Liste von Merkmalen ( gespeichert als nat. Zahlen) umgerechnet werden, dies geschieht mit displayBereitMachen.
;Da (show-Butterfly ..) die Argument in der Reihenfolge FARBE MUSTER FÜHLER FLÜGEL entgegennimmt, wir sie aber als MUSTER FARBE FÜLER FLÜGEL speichern muss 1 und 2 beim aufruf vertauscht werden.
(define (showOne Butterfly)
  (show-butterfly
       (second (displayBereitMachen  Butterfly))
       (first (displayBereitMachen  Butterfly))
       (third (displayBereitMachen Butterfly))
       (fourth (displayBereitMachen  Butterfly))))

;Eine Funktion die einen Schmetterling die Liste Sichtbar entnimmt und sie in von nat. Zahlen in die entsprechenden Symbole umwandelt.
;Schmetterling -> Liste von Merkmalen des Schmetterlings als Symbole.
  (define (displayBereitMachen Schmetterling)
    (list             (Musterung<->Zahl (first (cadr (assoc 'Sichtbar Schmetterling))))
                      (Flügelfarbe<->Zahl (second (cadr (assoc 'Sichtbar Schmetterling))))
                      (Fühlerform<->Zahl (third (cadr (assoc 'Sichtbar Schmetterling))))
                      (Flügelform<->Zahl (fourth (cadr (assoc 'Sichtbar Schmetterling))))))


;Aufgabe 2.)


;Aufgabe 3.)
#lang racket
(require se3-bib/prolog/prologInScheme)

#| 1.1 Prolog
a.)
(pokemon? . Pikachu)

b.)
(?typ . Pflanze)

c.)
(?typ . Normal) (?name .  Mauzi)

d.)
nicht unifizierbar, ?name kann nicht an zwei verschiedene Werte gebunden werden.

e.)
wird unifiziert aber es wird keine variable gebunden

f.)
(?typ . Kampf) (?name . Ash) (?name2 . Ash)

g.)

-------1.2
Eine Datenbank für ein Bib. System hat folgende Relationen:

(bestand ?Signatur ?Author ?Jahr ?Titel)

(ausleihe ?Signatur ?Lesernummer)

(vorbestellung ?Signatur ?Lesernummer)

(leser ?Name ?Vorname ?Lesernummer ?Geburstjahr)


|#


(<- (bestand "P_32" "Wells, H.G." 3200 "Zeitmaschinen leicht gemacht."))
(<- (bestand "P_50" "Nessie" 1790 "Mein Leben im Loch Ness"))
(<- (bestand "P_30" "Prefect, F." 1979 "Mostly Harmless..."))


(<- (ausleihe "P_30" 102))
(<- (ausleihe "P_32" 104))
(<- (ausleihe "P_50" 104))


(<- (vorbestellung "P_50" 102))
(<- (vorbestellung "P_30" 100))
(<- (vorbestellung "P_30" 104))

(<- (leser Neugierig Nena 100 1989))
(<- (leser Linux Leo 102 1990))
(<- (leser Luator Eva 104 1988))

;1.2.1
(<- (WerHatP_30Vorbestellt ?name ?vorname) :-
    (leser ?name ?vorname ?sig ?)
     (vorbestellung "P_30" ?sig))

(?- (WerHatP_30Vorbestellt ?name ?vorname))

;1.2.2

(?- (leser Luator Eva ? ?geburtsjahrEvaLuator))

;1.2.3
(<- (WerHatWellsAusgeliehen ?name ?vorname) :-
    (leser ?name  ?vorname ?num ?)
    (bestand ?sig "Wells, H.G." ? ?)
    (ausleihe ?sig ?num))

(?- (WerHatWellsAusgeliehen ?name ?vorname))

;1.2.4
(<- (ÄlterAls60undBuchVorbestellt ?name ?vorname) :-
    (leser ?name ?vorname ?num ?geburtsjahr)
    (vorbestellung ? ?num)
    (test (< ?geburtsjahr 1958)))

(?- (ÄlterAls60undBuchVorbestellt ?name ?vorname))

 ;1.2.5
(<- (WerHatMinEinBuch ?x ?y) :-
    (leser ?x ?y ?num ?)
    (ausleihe ?a ?num))

(<- (WerHatMehrAlsEinBuch ?name ?vorname) :-
    (leser ?name ?vorname ?num ?)
    (ausleihe ?buch ?num)
    (ausleihe ?buch2 ?num)
    (!= ?buch ?buch2))

(<- (WerHatGenauEinBuch ?x ?y) :-
    (WerHatMinEinBuch ?x ?y)
    (not WerHatMehrAlsEinBuch ?x ?y))

(?- (WerHatGenauEinBuch ?name ?vorname))
;--------2

;Die Harmonische Reihe als rekursive Funktion
(define (harmonischeReihe n)
  (if (zero? n) 0
      (+ (/ 1 n) (harmonischeReihe (- n 1)))))

;Die Memo funktion welche eine gegebene Funktion in eine Memo-Variante umwandelt
(define (memo fn)
  (letrec
      ([table '()]
       [store (lambda
                  (arg val)
                (set! table (cons (cons arg val) table))
                val)]
       [retrieve
        (lambda (arg)
          (let ((val-pair (assoc arg table)))
            (if val-pair (cdr val-pair) #f)))]
       [ensure-val
        (lambda (x)
          (let ([stored-val (retrieve x)])
            (if stored-val stored-val
                (store x (fn x)))))]) ensure-val))

;Die Harmonische Reihe als Memo-Funktion
(define harmonisch-memo (memo harmonischeReihe))

;Für den rekursiven abstieg muss auch die Memo Funktion verwendet werden, deshalb muss man die referenz auf die neue Memo-funktion ändern.
(set! harmonischeReihe (memo harmonischeReihe))

;----------Aufgabe 3

;Die Stream - Definitionen aus der Vorlesung
(defmacro (cons-stream2 a b)
  `(cons ,a (delay ,b)))

(define (head-stream stream)
  (car stream))

(define (tail-stream stream)
    (cond [(null? stream) '()]
          [(null? (cdr stream)) '()]
          [(pair? (cdr stream)) (cdr stream)]
          [else (force (cdr stream))]))

(define (empty−stream? stream)
    (null? stream))

(define the−empty−stream '())


;Die Funktion die einer natürlichen Zahl ihre FlipFlap variante zuordnet.
(define (FlipFlapFun n)
   (cond
    [(= (modulo n 5) (modulo n 3) 0) 'FlipFlap]
    [(= (modulo n 3) 0) 'Flip]
    [(= (modulo n 5) 0) 'Flap]
    [else n]))

;Eine FlipFlap als Strom der natürlichen Zahlen.
(define (FlipFlapStrom n)
  (cons (FlipFlapFun n)
        (delay (FlipFlapStrom (+ n 1)))))

;Die take-stream funktion aus der vorlesung
(define (take-stream n stream)
  (if (zero? n) '()
      (cons (head-stream stream) (take-stream (- n 1) (tail-stream stream)))))

;Der FlipFlap stromg
(define FlipFlap (FlipFlapStrom 1))

;Die ersten 25 einträge aus FlipFlap
(take-stream 25 FlipFlap)








  
#lang racket
;;;Blatt 3
(require se3-bib/flaggen-module)
(require racket/gui/base)
;;Aufgabe 1.)
;Wir haben uns bei der Wahl einer Datenstruktur für die Seefunk-Buchstabiertafel für eine Assoziationsliste entschieden
;da wir stets Key-Value Paare in der Seefunktafel vorliegen haben. Ein weiterer Grund für die Assoziationsliste ist, dass der Zugriff und das Abfragen solch einer Liste schnell und einfach erfolgt.

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

;Mit folgender Funktion durchsuchen wir die Datenstruktur, indem wir das übergebene Argument mit dem ersten Element der einzelnen Listen vergleichen.
;Zuvor wird das Argument in einen Großbuchstaben umgewandelt (für den Fall, dass er nicht als Großbuchstabe eingegeben wurde)

(define (char->seefunk char)
  (cadr (assoc (char-upcase char) *seefunk-tafel*)))

;Hier wird die Eingabe eines Strings in eine Liste mit den entsprechenden Zeichen umgewandelt.
;Hierfür wird der String in eine String-Liste umgewandelt und anschließend der Hilfsfunktion "seefunkify" übergeben.

(define (string->seefunk string)
  (seefunkify  (string->list  string)))

;Die Hilfsfunktion "seefunkify" wendet auf jedes Element der String-Liste unsere char->seefunk-Funktion an. Sie ist endrekursiv.

(define (seefunkify stringList)
  (if (= 1 (length stringList)) (cons (char->seefunk (car stringList)) '())
      (cons (char->seefunk (car stringList)) (seefunkify (cdr stringList)))))
;Beispiel-aufrufe:
;"Hallo" => Hotel Alpha Lima Lima Oscar
(string->seefunk "Hallo")
;"SE3" => Sierra Echo Terrathree
(string->seefunk "SE3")


;;Aufgabe 2.)

; Hier verwenden wir die Gleiche Datenstruktur wie bereits in Aufgabe 1.
;Die Begründung ist Analog.
;Da allerdings bereits alle variablen vom Modul vordefiniert sind könnte man sich eine solche Datenstruktur komplett sparen und
;einfach den eingegebenen Char in das Symbol des Characters umwandeln "(eval (string->symbol (string CHAR)))" (bei Zahlen muss zuvor ein "Z" appended werden)

(define *flaggen-tafel*
  '((#\A A) (#\B B) (#\C C) (#\D D)
    (#\E E) (#\F F) (#\G G) (#\H H)
    (#\I I) (#\J J) (#\K K) (#\L L)
    (#\M M) (#\N N) (#\O O) (#\P P)
    (#\Q Q) (#\R R) (#\S S) (#\T T)
    (#\U U) (#\V V) (#\W W) (#\X X)
    (#\Y Y) (#\Z Z) (#\0 Z0) (#\1 Z1)
    (#\2 Z2) (#\3 Z3) (#\4 Z4)
    (#\5 Z5) (#\6 Z6) (#\7 Z7)
  (#\8 Z8) (#\9 Z9)))

;Bei der Umwandlung ist ein eval von nöten da wir aus dem rest jeweils das symbol A-Z bekommen und diese noch auswerten müssen.
(define (char->flaggenalphabet char)
  (eval (cadr (assoc (char-upcase char) *flaggen-tafel*))))

;Die funktionen sind, bis auf verwendung der korrekten umwandlungsfunktion, zu denen aus A1 gleich.
(define (string->flaggenalphabet string)
  (flaggenfunkify (string->list  string)))

(define (flaggenfunkify stringList)
  (if (= 1 (length stringList)) (cons (char->flaggenalphabet (car stringList)) '())
      (cons (char->flaggenalphabet (car stringList)) (flaggenfunkify (cdr stringList)))))

;;Beispielaufrufe, Hier zum rauskopieren da es sonst zu fehler kommt
;;Kann man die Flaggen hier reinbekommen?
;(string->flaggenalphabet "Hallo")
;;naja, es lässt sich ja mit den Arbeitsblatt vergleichen...
;(string->flaggenalphabet "SE3")


;;Aufgabe 3.)

;Diese Aufgabe haben wir genauso gelöst wie Aufgabe 1 und 2.
;Genau wie in A2 ist hier eigentlich keine Datenstruktur notwendig wenn man den eingegeben Character in den jeweiligen Sting umwandeld via string-append

(define *morse-tafel*
  '((#\A "Morse-A.wav") (#\B "Morse-B.wav") (#\C "Morse-C.wav") (#\D "Morse-D.wav")
    (#\E "Morse-E.wav") (#\F "Morse-F.wav") (#\G "Morse-G.wav") (#\H "Morse-H.wav")
    (#\I "Morse-I.wav") (#\J "Morse-J.wav") (#\K "Morse-K.wav") (#\L "Morse-L.wav")
    (#\M "Morse-M.wav") (#\N "Morse-N.wav") (#\O "Morse-O.wav") (#\P "Morse-P.wav")
    (#\Q "Morse-Q.wav") (#\R "Morse-R.wav") (#\S "Morse-S.wav") (#\T "Morse-T.wav")
    (#\U "Morse-U.wav") (#\V "Morse-V.wav") (#\W "Morse-W.wav") (#\X "Morse-X.wav")
    (#\Y "Morse-Y.wav") (#\Z "Morse-Z.wav")))

;Diese funktionen sind, bis auf die korrekten funktionsnamen identisch zu A1 und A2
(define (char->morsecode char)
  (play-sound (cadr (assoc (char-upcase char) *morse-tafel*)) #f))

(define (string->morsecode string)
  (morsecodeify (string->list  string)))

(define (morsecodeify stringList)
  (if (= 1 (length stringList)) (cons (char->morsecode (car stringList)) '())
     (cons (char->morsecode (car stringList)) (morsecodeify (cdr stringList)))))

;Beispielaufrufe
; "Hallo" => .... .- .-.. .-.. ---
(string->morsecode "Hallo")
;"SEdrei" => ... . -.. .-. . ..
(string->morsecode "SEdrei")





#lang racket
(require 2htdp/image 2htdp/universe racket/trace lang/posn)


; Aufgabe 1

;  Funktion  | lineare Rek | Baumrek. | geschachtelt Rek | direkt Rek | indirekt Rek

 ; take      |   ja        |   nein   |          nein    |   ja       |   nein            

 ; drop      |   ja        |   nein   |          nein    |   ja       |   nein         

 ; merge     |   ja        |   nein   |          nein    |   ja       |   nein    
  
 ; merge-sort|  nein       |    ja    |          nein    |   ja       |   nein  

     

 ; take: Hier liegt „lineare Rekursion“ vor, da immer nur ein rekursiver Aufruf erfolgt

 ; Zudem ist es direkte Rekursion, da die Funktion sich selbst aufruft.

 ; drop: Auch liegt „lineare Rekursion“ vor. Dazu ruft sich die Funktion immer nur einmal selbst auf ;und ist somit direkte Rekursion.

 ;merge: Es ist wieder „lineare Rekursion“, da merge sich immer nur einmal aufruft. Hier liegt keine ;Baumrekursion vor, da die beiden rekursiven Aufrufe in der if-else-Klausel stecken, so dass nur einer ;der beiden reukursiven Aufrufe ausgeführt wird. Es liegt direkte Rekursion vor (siehe take).

 ; merge-sort: Hier liegt Baumrekursion vor, da hier die „merge“-Funktion mit zwei rekursiven ;Aufrufen als Parameter aufgerufen wird. Es liegt direkte Rekursion vor (siehe take).

 ; Geschachtelte Rekursion kommt bei keinem der Beispiele vor, da nirgends ein rekursiver Aufruf

 ; als Parameter eines rekursiven Aufrufs verwendet wird.

; Indirekte Rekursion liegt auch nirgends vor. In der Funktion „merge-sort“ werden zwar die anderen ;Funktionen aufgerufen, jedoch wird „merge-sort“ wiederum nicht bei den entsprechenden ;Funktionen aufgerufen. Also keine indirekte Rekursion.


#|Blatt 6 aufgabe 2.)
Weihnachtskarten
---------------
Hier erstellen wir unsere animierte weihnachstkarte

|#
(define canvas (empty-scene 900 600 "darkblue"))
(define  *height* (image-height canvas))
(define  *width* (image-width canvas))

;Bauen eines Schneemanns.

;Der Körper besteht aus n übereinandergelagerten  Schneekugeln. Hier representiert durch weiß ausgefüllte kreise.
;Diese können ein wenig überlappen um die größe zu stauchen.
;somit wird rekursiv ein n-stöckiger Schnemann gebaut

(define (snowball durchmesser)
  (if (< durchmesser 2) (error "wird kein schöner schneemann... lass das lieber sein")
      (circle (/ durchmesser 2) "solid" "white")))


(define (build-snowman größeDesErsten)
  (rotate 180 (build-snowman-1 größeDesErsten 3)))

;Das Bauen eines schneemanns
(define (build-snowman-1 n stage)
  (if (= 1 stage)
      (underlay/offset (overlay/align/offset "center" "center" (eyes n) 0 (* -1/4 n) (snowball n))
                             0 0 (rotate 84 (triangle (/ n 4) "solid" "orange")))
      (underlay/align/offset "center" "top" (snowball n) 0 (- (* 3/4 n) 6) (build-snowman-1 (* 3/4 n) (- stage 1)))))
;Die Augen des Schneemanns
(define (eyes n)
  (overlay/xy (circle (* 1/8 n) "solid" "black" ) (/ n 3) 0 (circle (* 1/8 n) "solid" "black")))


;;Baumrekursives Bauen von Schneemännern.
(define (snow-fam number größe1)
  (if (= 1 number) (beside (build-snowman größe1) (circle 1 "outline" "darkblue"))
      
      (beside/align "top" ;Der else- fall erstellt links und rechts neben einem schneemann wieder einen aufruf dieser funktion.
        (snow-fam (- number 1) (* größe1 3/4))
        (build-snowman größe1)
         (snow-fam (- number 1) (* 3/4 größe1)))))


;Hier der regulator für die anzahl der schneemänner und die größe des ersten
(define snowman-army (snow-fam 5 120))


;Erstelle den Background für die Animation, dieser besteht aus unserem dunkelblauem "canvas" und unserer armee von schneemännern.
(define background
  (place-image snowman-army (/ *width* 2) (- *height* 150) canvas))

;Erstellt eine liste aus listen von (POLYGON  X-startwert  T-modifikator-für-die-fallgeschwindigkeit-in-der-animation)
;Diese benutzen wir für unsere animation, das POLYGON ist unsere schneeflocke
(define (make-snowflakes n)
  (if (= n 1) (cons `(,(pulled-regular-polygon (random 15 45) 5 1 140 "solid" "white") ,(random 0 *width*) ,(random 1 4)) '())
          (cons `(,(rotate (random 0 60) (pulled-regular-polygon (random 15 45) 5 1 140 "solid" "white")) ,(random 0 *width*) ,(random 1 4)) (make-snowflakes (- n 1)))))

;Wir bauen uns eine liste aus 20 dieser schneeflocken mit deren startwert entlang der x-achse und einer eigenen fallgeschwindigkeit
(define all-snowflakes (make-snowflakes 20))

;für den zugriff auf die einzelnen elemente
(define snowflakes-Ani-bodies (map car all-snowflakes))
(define snowflake-Xkord (map cadr all-snowflakes))
(define snowflake-tMod (map caddr all-snowflakes))

;sollte für das dynamische positions erstellen genuzt werden, hatt aber nicht ganz geklappt
; (define snowflakes-Ani-Pos (map (lambda (x y) `(make-posn (+ ,x (* 25 (sin (sqrt t)))) (* ,y t))) snowflake-Xkord snowflake-tMod))

;Unser animationsloop
;anhand des faktors t werden die positionen entlang x und y achse der schneeflocken aktualisiert sodass diese den bildschirm herunterfallen.
;Als hintergrund dient der oben definierte "background" mit unseren schneemännern.
;Wollten eigentlich mithilfe der auskommentierten funktion diese positionen auch von der liste erstellen lassen, dies klappte auch soweit allerdings
;gelang es uns nicht sie innerhalb dieser funktion als liste von (posn ..) aufrufen zu übergeben
;deshalb hier für unsere 20 schneeflocken per hand die koordinaten.
 (define (winterwonderland t)
   (place-images
          snowflakes-Ani-bodies
          (list
           (make-posn (+ (first snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (first snowflake-tMod) t) (+ 50 *height*) ))
           (make-posn (+ (second snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (second snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (third snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (third snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (fourth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (fourth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (fifth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (fifth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (sixth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (sixth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (seventh snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (seventh snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (eighth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (eighth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (ninth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (ninth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (tenth snowflake-Xkord) (* 25 (sin (sqrt t)))) (modulo (* (tenth snowflake-tMod) t) (+ 50 *height*)))
           (make-posn (+ (tenth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (tenth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (ninth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (ninth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (eighth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (eighth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (seventh (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (seventh (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (sixth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (sixth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (fifth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (fifth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (fourth (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (fourth (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (third (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (third (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (second (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (second (reverse snowflake-tMod)) t) (+ 50 *height*)))
           (make-posn (+ (first (reverse snowflake-Xkord)) (* 25 (sin (sqrt t)))) (modulo (* (first (reverse snowflake-tMod)) t) (+ 50 *height*))))
           background))

;der animations aufruf
(animate winterwonderland)

#lang racket
(require racket/gui/base)

(define *morse-tafel*
  '((#\A "Morse-A.wav") (#\B "Morse-B.wav") (#\C "Morse-C.wav") (#\D "Morse-D.wav")
    (#\E "Morse-E.wav") (#\F "Morse-F.wav") (#\G "Morse-G.wav") (#\H "Morse-H.wav")
    (#\I "Morse-I.wav") (#\J "Morse-J.wav") (#\K "Morse-K.wav") (#\L "Morse-L.wav")
    (#\M "Morse-M.wav") (#\N "Morse-N.wav") (#\O "Morse-O.wav") (#\P "Morse-P.wav")
    (#\Q "Morse-Q.wav") (#\R "Morse-R.wav") (#\S "Morse-S.wav") (#\T "Morse-T.wav")
    (#\U "Morse-U.wav") (#\V "Morse-V.wav") (#\W "Morse-W.wav") (#\X "Morse-X.wav")
    (#\Y "Morse-Y.wav") (#\Z "Morse-Z.wav")))


(define (char->morsecode char)
  (play-sound (cadr (assoc (char-upcase char) *morse-tafel*)) #f))

(define (string->morsecode string)
  (morsecodeify (string->list  string)))

(define (morsecodeify stringList)
  (if (= 1 (length stringList)) (cons (char->morsecode (car stringList)) '())
     (cons (char->morsecode (car stringList)) (morsecodeify (cdr stringList)))))

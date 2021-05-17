#lang swindle
(require swindle/setf swindle/misc)
;Blatt 09
#| Aufgabe 1 -- CLOS und generische Funktionen

1.1.)

Definieren sie in CLOS geeignete Klassen um Literaturbeiträge darstellen zu können
Eigenschaften:
 -Einen eindeutigen Schlüssel
 -Die Namen der Autorinnen und Autoren
 -Das Erscheinungsjahr
 -Der Titel

Spezifikationen

Bücher
 -Verlag
 -Verlagsort
 -Buchreihe
 -Seriennummer

Sammelbände
 -Buch
 -Name Des Heruasgebers
 -Seitenangaben zu den Artikeln im Buch

Zeitschrift
 -Name der Zeitschrift
 -Nummer des Bandes
 -Nummer des Heftes
 -Erscheinungsmonat


|#

(defclass Literaturbeitrag ()
  (titel :accessor get-titel
         :initarg :titel)
  (author :accessor get-author
          :initarg :author)
  (release :accessor get-release-date
           :initarg :date)
  (auth-key :accessor get-key
            :initarg :key))

(defclass Buch (Literaturbeitrag)
  (verlag :accessor get-verlag
         :initarg :verlag)
  (verlagsort :accessor get-VerOrt
          :initarg :verlagsO)
  (reihe :accessor get-reihe
           :initarg :reihe)
  (seriennummer :accessor get-seriennummer
            :initarg :seriennummer))


(defclass Sammelband (Buch)
  (herausgeber :accessor get-herausgeber
             :initarg :herausgeber)
  (index :accessor get-index
         :initarg :index))

(defclass Zeitschrift (Literaturbeitrag)
  (name :accessor get-name
        :initarg :name)
  (band# :accessor get-band-num
         :initarg :bandnum)
  (heft# :accessor get-heft-num
         :initarg :heftnum)
  (release-mo :accessor get-release-mo
              :initarg :rel-mo))

(define Literaturbeitrag1 (make Buch
                    :titel "Mein Leben im Loch Ness: Verfolgt als Ungeheuer"
                    :author "Nessie"
                    :date "1790"
                    :key (random 100000)
                    :verlag "Minority-Verlag"
                    :verlagsO "Inverness"
                    :reihe "Die besondere Biographie"
                    :seriennummer "1"))

(define Literaturbeitrag2 (make Sammelband
                    :titel "Mostly harmless - Some observations concerning the third planet of the solar system"
                    :author "Prefect F." 
                    :date "1979"
                    :key (random 100000)
                    :verlag "Galactic Press"
                    :verlagsO "Vega-System, 3rd planet"
                    :reihe "1500 edition"
                    :seriennummer "p. 500"
                    :herausgeber "Adams, D."
                    :index "The Hitchhiker’s Guide to the Galaxy, Volume 5 of 'Travel in style'"))

(define Literaturbeitrag3 (make Zeitschrift
                                :titel "Zeitmaschinen leicht gemacht"
                                :author "Wells, H.G."
                                :date "3200"
                                :key (random 100000)
                                :name "Heimwerkerpraxis für Anfänger"
                                :bandnum "500"
                                :heftnum "3"))
#| 1.2.) Generische Funktionen und Methoden

Definieren sie eine generische funktion "cite" welche
 -einen Literaturbeitrag als argument erhält.
 -einen String mit den korrekten Zitaten ausgibt.

|#
(defgeneric* cite ((lit Literaturbeitrag)))

;--- Die implementierung für eine beliebiges Literaturbeitrags Objekt.
;-- hier mit dem Schlüsselwort :around implementiert da sie die allgemeinste methode darstellt und am ende ein newline anfängt.
(defmethod cite :around ((beitrag Literaturbeitrag))
  (print (string-append (get-author beitrag) " (" (get-release-date beitrag) "). " (get-titel beitrag) ", "))
  (call-next-method)
  (display "\n"))

;--- Die implementierung für ein Buch-Objekt
;-- ergänzt die nötigen informationen des Buches zu denen des allgemeinen Literaturbeitrags.
(defmethod cite ((buch Buch))
  (print (string-append  "Band "
                 (get-seriennummer buch) " der Reihe: "
                 (get-reihe buch) ". "
                 (get-verlag buch) ", "
                 (get-VerOrt buch)".")))

;--- Die implementierung für ein Sammelband-Objekt
;-- ergänzungsmethode mit dem Schlüssel :before, da sie die informationen vor die des Buches schreiben muss.
(defmethod cite :before ((samm Sammelband))
  (print (string-append "In "
                 (get-herausgeber samm) ", "
                 (get-index samm)". ")))

;--- Die implementierung für Zeitschrift-Objekte
;-- keine ergänzungsmethode, da man nur Informationen zum allgemeinen Literaturbeitrag ergänzen muss.
(defmethod cite ((zeit Zeitschrift))
  (print (string-append (get-name zeit) ". " (get-band-num zeit) "(" (get-heft-num zeit) ").")))

;---Bsp:
(cite Literaturbeitrag1)

(cite Literaturbeitrag2)

(cite Literaturbeitrag3)
(display "\n")

#| 1.3.) Ergänzungsmethoden

---Was ist eine Ergänzungsmethode?
Eine Ergänzungsmethode ist eine defmethod, welche durch Schlüsselwörter
  -before
  -after
  -around
eine bereits existierende defmethod-implementierung einer generischen methode erweitern können.
Sie werden, sofern die Input-argumente auf ihre signatur zutreffen, aufgerufen und rufen ihren code
entsprechend des Schlüsselwortes entweder
 -vor der allgemeineren Methode
 -nach der allgemeineren Methode
 -einen Spezifizierten Teil davor, und einen danach auf.
und "ergänzen" somit eine bereits bestehende Methode ohne diese überflüssig zu machen oder den gesammten code zu duplizieren.


---Vorteile gegenüber "super"-calls in Java?
es werden stets ALLE ergänzungsmethoden in ihrer gesammtheit ausgeführt, wenn eine generische methode aufgerufen wird. Es kann nicht passieren das ein aufruf verloren geht oder nicht stattfindet.
Java super calls können nur vor oder nach der eigentlichen methode agieren, den ergänzungsmethoden steht auch noch around zur verfügung.

---Wie könnten sie in diesem System verwendet werden?
Sie können verwendet werden um code-duplicate zu vermeiden.

---Wie müsste man das System umstrukturieren?
Man müsste nichts verändern, da sie bereits verwendet werden.

|#

;Aufgabe 2.)
;----2.1)
;---Das Allgemeinste Speichermedium
;-- als Slot einen boolean, welcher angibt ob man es herausnehmen kann oder nicht.
(defclass Speichermedium ()
  (herausnehmbar :accessor ist-herausnehmbar))

;--- Die nächste spezifikation von Speichermedien, jedes Speichermedium ist min. einer dieser drei Typen.

(defclass Magnetisch (Speichermedium))

(defclass Optisch (Speichermedium))

(defclass Semiconductor (Speichermedium))

;--- Die Speichermedien des Typ "Magnetisch"

(defclass HDD (Magnetisch)
  (herausnehmbar :initvalue #f))

(defclass Diskette (Magnetisch)
  (herausnehmbar :initvalue #f))

;--- Die Speichermedien des Typ "Optisch"

(defclass CD/DVD (Optisch)
  (herausnehmbar :initvalue #t))

;--- Die Speichermedien des Typ "Semiconductor"

(defclass SSD (Semiconductor)
  (herausnehmbar :initvalue #f))

(defclass RAM (Semiconductor)
  (herausnehmbar :initvalue #f))

(defclass USB (Semiconductor)
  (herausnehmbar :initvalue #t))

;--- Die Speichermedien, welche mehr als einen Supertyp haben.

(defclass MagnetoDisk (Magnetisch Optisch)
  (herausnehmbar :initvalue #t))

(defclass SSHD (HDD SSD)
  (herausnehmbar :initvalue #f))

(defclass Bankkarte (Magnetisch Semiconductor)
  (herausnehmbar :initvalue #t))


;--- Die Generischen Funktionen aus 2.2)

(defgeneric* get-speichertyp ((medium Speichermedium)))

(defgeneric* get-maxLeseGsw ((medium Speichermedium)))

(defgeneric* get-Kapazität ((medium Speichermedium)))

(defgeneric* get-Lebenserwartung ((medium Speichermedium)))

(defgeneric* get-Mobilitätskapazitäten ((medium Speichermedium)))

;--- 2.3)
;-- Die Implementierung von 2.2.5) Der Abfrage der Mobilität.
; Das hierzu nötige Feld ist bereits im Allgemeinsten Speichermedium vorhanden
; Da jedes Speichermedium entweder herausnehmbar oder nicht-herausnehmbar ist kann jedes Spezifische Speichermedium dieses Feld
; einfach vom allgemeinsten erben und die initialbelegung selbst bestimmen
;---
(defmethod get-Mobilitätskapazitäten ((medium Speichermedium)) ;Die funktion ist applicable für jede art von Speichermedium.
  (if (ist-herausnehmbar medium) "Dieses Speichermedium ist herausnehmbar" "Dieses Speichermedium ist nicht herausnehmbar"))

;---Bsp:
(define testMagnetoDisk (make MagnetoDisk))
(define testSSHD (make SSHD))
(define testBankkarte (make Bankkarte))

(display (string-append "MagnetoDisk: " (get-Mobilitätskapazitäten testMagnetoDisk)"\n"))
;> #t -> "Dieses Speichermedium ist herausnehmbar"
(display (string-append "SSHD: " (get-Mobilitätskapazitäten testSSHD) "\n"))
;> #f -> "Dieses Speichermedium ist nicht herausnehmbar"
(display (string-append "Bankkarte: " (get-Mobilitätskapazitäten testBankkarte)))
;> #t -> "Dieses Speichermedium ist herausnehmbar"

;--- Wie arbeitet die implementierte generische funktion auf diesen Objekten?
; Die Funktion erhählt das Objekt (bsp: testSSHD) als argument.
; Sie greift auf den "herausnehmbar" slot zu und ließt den wert ab (hier #f)
; Somit wird der entsprechende string ("Dieses Speichermedium ist nicht herausnehmbar") ausgegeben
;--- Der Begriff der Präzedenzliste
; Das in der superklasse (Speichermedium) definierte Feld "herausnehmbar" wird an alle subklassen (hier SSHD) vererbt
; Bei dieser vererbung  werden alle accessoren, initargs sowie initvalue weitergegeben
; Die accessoren sowie initarg bleiben zusätzlich zu den in der klasse selbst definierten accessoren und initarg erhalten,
; Die initvalue wird jedoch überschrieben.
; Beim Aufruf unserer Funktion steigt es solange die Präzedenzliste der Klassenhierarchie hinab, bis es die (hier SSHD) klasse findet und liest deren wert
; Hierbei wird immer der spezifischte wert beibehalten, hätte also "Magnetisch" das initvalue "#t" so würde dieses von dem initvalue von SSHD (#f) überschrieben werden, da die klasse spezifischer ist.
;---



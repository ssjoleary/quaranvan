(var t 0)
(var SCENE "BAR")
(local SCENES
  {:CANVAS      {:x 0 :y 0}
   :BAR         {:x 30 :y 0}
   :PARKING-LOT {:x 60 :y 0}})
(local all {})
(local (w h) (values 240 136))
(var OPENING? true)
(var SCENE-SET? false)

(fn load-palette
  [str]
  (for [i 0 15 1]
    (poke (+ 0x03FC0 (* i 3))
          (tonumber (string.sub str (+ (* i 6) 1) (+ (* i 6) 2)) 16))

    (poke (+ 0x03FC0 (* i 3) 1)
          (tonumber (string.sub str (+ (* i 6) 3) (+ (* i 6) 4)) 16))

    (poke (+ 0x03FC0 (* i 3) 2)
          (tonumber (string.sub str (+ (* i 6) 5) (+ (* i 6) 6)) 16))))

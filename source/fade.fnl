(var fade 255)
(var FADING false)
(var palette {})
(var ticker 0)

(for [i 0 47]
  (table.insert palette (peek (+ 0x3FC0 i))))

(fn clamp
  [x min max]
  (math.min max (math.max min x)))

(fn palette-adjust
  [ra ga ba rm gm bm]
  (let [rm (or rm 1)
        gm (or gm 1)
        bm (or bm 1)]
    (for [i 3 47 3]
      (poke (+ 0x3FC0 i) (clamp (-> (. palette i)
                                    (* rm)
                                    (+ ra)) 0 255))
      (poke (+ 0x3FC0 i 1) (clamp (-> (. palette (+ i 1))
                                      (* gm)
                                      (+ ga)) 0 255))
      (poke (+ 0x3FC0 i 2) (clamp (-> (. palette (+ i 2))
                                      (* bm)
                                      (+ ba)) 0 255)))))

(fn gray-scale
  [amt]
  (palette-adjust amt amt amt))

(fn fader
  []
  (when FADING
    (set ticker (+ ticker 1))
    (when (>= ticker 25)
     (load-palette "1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57")
     (set FADING false)
     (set ticker 0))))

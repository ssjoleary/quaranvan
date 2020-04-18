(local initial-positions {:Hero [96 57] :Willie [115 57] :Colter [264 16] :Tyler [84 300] :Neil [39 304]})
(set chars.Hero {:name "Hero" :spr 256 :portrait 257 :side-1 259 :side-2 260 :down-1 261 :down-2 262 :up-1 263 :up-2 264})
(set chars.Willie {:name "Willie" :spr 288 :portrait 289})
(set chars.Colter {:name "Colter" :spr 320 :portrait 321})
(set chars.Tyler {:name "Tyler" :spr 352 :portrait 353})
(set chars.Neil {:name "Neil" :spr 384 :portrait 385})

(fn init
  []
  (each [name pos (pairs initial-positions)]
    (let [[x y] pos]
     (tset (. chars name) :x x)
     (tset (. chars name) :y y)))
  (each [name (pairs chars)]
   (tset convos name (. all name))))

(fn draw
  []
  (if
    (= SCENE "BAR")
    (render-bar-scene)

    (and (= SCENE "PARKING-LOT") (not fading))
    (render-parking-lot-scene)))

(fn game-options
  []
  (when (btnp 6)
    (set-dialog (fn []
                  (set who nil)
                  (let [choice (ask "" ["Restart" "Cancel"])]
                    (when (= choice "Restart")
                      (reset)))))))

(fn game-loop
  []
  (cls)
  (game-options)
  (draw)
  (draw-dialog :portrait)
  (dialog?)
  (interaction?)
  (fader)
  (set t (+ 1 t)))

(fn splash-screen
  []
  (cls)
  (draw)
  (print "q  u  a  r  a  n  v  a  n" 60 10)
  (print "Press z to start" 75 25)
  (for [i 0 6]
   (when (btnp i)
     (global TIC game-loop))))

(init)
(trace "This is the console; type run to start.")
(trace "Press ESC for the art, code, and sound.")
(global TIC splash-screen) ; Function called once every frame

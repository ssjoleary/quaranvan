(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (cam-x cam-y) (values center-x center-y))

(var t 0)
(var restart nil)

(local all {})
(local chars {})

(local initial-positions {:Hero [105 65] :Willie [125 65] :Colter [264 16] :Tyler [84 300] :Neil [39 304]})
(set chars.Hero {:name "Hero" :spr 256 :portrait 257 :side-1 259 :side-2 260 :down-1 261 :down-2 262 :up-1 263 :up-2 264})
(set chars.Willie {:name "Willie" :spr 288 :portrait 289})
(set chars.Colter {:name "Colter" :spr 320 :portrait 321})
(set chars.Tyler {:name "Tyler" :spr 352 :portrait 353})
(set chars.Neil {:name "Neil" :spr 384 :portrait 385})

(set chars.Narrator {:name "Narrator" :x 0 :y 0 :portrait 271})

(fn init
  []
  (each [name pos (pairs initial-positions)]
    (let [[x y] pos]
     (tset (. chars name) :x x)
     (tset (. chars name) :y y)))
  (set-dialog (fn [] (describe "Unknown Bar" "" "Downtown Toronto...")))
  (each [name (pairs chars)]
   (tset convos name (. all name))))

(fn walking-animation
  [anim-spr-1 anim-spr-2 x y flip?]
  (if
    (= 1 (// (% t 60) 40))
    (spr anim-spr-1 x y 0 1 flip? 0 1 2)

    (= 0 (// (% t 60) 40))
    (spr anim-spr-2 x y 0 1 flip? 0 1 2)))

(fn draw
  []
  (map 12 7 7 11 96 56 1 1)
  (if
   (= 1 (// (% t 60) 30))
   (spr 5 120 64 0 1 0 0 1 1)

   (= 0 (// (% t 60) 30))
   (spr 6 120 64 0 1 0 0 1 1))
  (let [c chars.Willie]
    (spr c.spr c.x c.y 0 1 1 0 1 2))
  (let [c chars.Hero]
    (if
      (btn 0)
      (walking-animation c.up-1 c.up-2 c.x c.y 0)
      (btn 1)
      (walking-animation c.down-1 c.down-2 c.x c.y 0)
      (btn 2)
      (walking-animation c.side-1 c.side-2 c.x c.y 1)
      (btn 3)
      (walking-animation c.side-1 c.side-2 c.x c.y 0)
      (spr c.spr c.x c.y 0 1 0 0 1 2))))

(fn can-move-point?
  [px py]
  (= 1 (mget (// px 8) (// py 8))))

(fn can-move?
  [x y]
  (and (can-move-point? x y)
       (can-move-point? (+ x 5) y)))

(fn move
  []
  (let [dx  (if (btn 2) -1 (btn 3) 1 0)
        dy  (if (btn 0) -1 (btn 1) 1 0)
        x   chars.Hero.x
        y   chars.Hero.y]
    (if
      (can-move? (+ x dx) (+ y dy 15))
      (set (chars.Hero.x chars.Hero.y) (values (+ x dx) (+ y dy)))

      (can-move? (+ x dx) (+ y 15))
      (set chars.Hero.x (+ x dx))

      (can-move? x (+ y dy 15))
      (set chars.Hero.y (+ y dy)))))

(fn interact
  []
  (if (and (btn 4) (= 120 (mget (// chars.Hero.x 8) (// (+ chars.Hero.y 16) 8))))
    (mset chars.Hero.x (+ chars.Hero.y 15) 122)))

(fn check-dialog
  []
  (when (btnp 6)
    (set-dialog (fn []
                  (set who nil)
                  (let [choice (ask "" ["Restart" "Cancel"])]
                    (when (= choice "Restart")
                      (restart))))))
  (let [talking-to (dialog chars.Hero.x chars.Hero.y (btnp 4))]
   (if (and talking-to (btnp 0)) (choose -1)
    (and talking-to (btnp 1)) (choose 1)
    (not talking-to) (move))))

(fn main
  []
  (cls)
  (draw)
  (draw-dialog :portrait)
  (check-dialog)
  (set t (+ 1 t)))

(fn intro
  []
  (cls)
  (draw)
  (print "q  u  a  r  a  n  v  a  n" 60 10)
  (print "Press z to start" 75 25)
  (for [i 0 6]
   (when (btnp i)
     (global TIC main))))

(init)
(trace "This is the console; type run to start.")
(trace "Press ESC for the art, code, and sound.")
(global TIC intro) ; Function called once every frame
(set restart (fn [] (init) (global TIC main)))

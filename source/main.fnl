(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (cam-x cam-y) (values center-x center-y))

(local t 0)

(local chars {})

(local initial-positions {:Hero [-15 0] :Willie [5 0] :Colter [264 16] :Tyler [84 300] :Neil [39 304]})
(set chars.Hero {:name "Hero" :spr 256 :portrait 257})
(set chars.Willie {:name "Willie" :spr 288 :portrait 289})
(set chars.Colter {:name "Colter" :spr 320 :portrait 321})
(set chars.Tyler {:name "Tyler" :spr 352 :portrait 353})
(set chars.Neil {:name "Neil" :spr 384 :portrait 385})

(fn lerp
  [a b t]
  (+ (* a (- 1 t)) (* t b)))

(fn init
  []
  (each [name pos (pairs initial-positions)]
    (let [[x y] pos]
     (tset (. chars name) :x x)
     (tset (. chars name) :y y))))

(fn draw
  []
  (let [c chars.Hero]
    (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 (or c.w 1) (or c.h 2)))
  (let [c chars.Willie]
    (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 1 0 (or c.w 1) (or c.h 2))))

(fn filter [f t]
  (local res [])
  (each [_ x (pairs t)]
    (when (f x) (table.insert res x)))
  res)

(fn hit?
  [px py char]
  (and (~= :Hero char.name)
       (<= char.x px (+ char.x (- (* (or char.w 1) 8) 1)))
       (<= char.y py (+ char.y (- (* (or char.h 2) 8) 1)))))

(fn can-move-point?
  [px py thru-chars?]
  (and (= 1 (mget (// px 8) (// py 8)))
       (or thru-chars? (= 0 (# (filter (partial hit? px py) chars))))))

(fn can-move?
  [x y thru-chars?]
 (and (can-move-point? x y thru-chars?)
  (can-move-point? (+ x 6) y thru-chars?)
  (can-move-point? x (+ y 7) thru-chars?)
  (can-move-point? (+ x 6) (+ y 7) thru-chars?)))

(fn move
  []
  (let [amt (if (btn 5) 1.7 1)
        dx (if (btn 2) (- amt) (btn 3) amt 0)
        dy (if (btn 0) (- amt) (btn 1) amt 0)
        x chars.Hero.x
        y chars.Hero.y]
    (if (can-move? (+ x dx) (+ y dy 8))
        (set (chars.Hero.x chars.Hero.y) (values (+ x dx) (+ y dy)))

        ;; if you're stuck at the start of the frame, don't let character
        ;; collisions stop you from getting un-stuck
        (and (not (can-move? x (+ 8 y))) (can-move? (+ x dx) (+ y dy 8) true))
        (set (chars.Hero.x chars.Hero.y) (values (+ x dx) (+ y dy)))

        (can-move? (+ x dx) (+ y 8))
        (set chars.Hero.x (+ x dx))

        (can-move? x (+ y dy 8))
        (set chars.Hero.y (+ y dy)))))

(fn intro
  []
  (cls)
  (draw)
  (print "q  u  a  r  a  n  v  a  n" 60 10)
  (map 6 10 14 4 10 26 0 2)
  (move))

(init)
(trace "This is the console; type run to start.")
(trace "Press ESC for the art, code, and sound.")

(global TIC intro) ; Function called once every frame

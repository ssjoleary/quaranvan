(fn walking-animation
  [anim-spr-1 anim-spr-2 x y flip?]
  (if
    (= 1 (// (% t 60) 40))
    (spr anim-spr-1 x y 0 1 flip? 0 1 2)

    (= 0 (// (% t 60) 40))
    (spr anim-spr-2 x y 0 1 flip? 0 1 2)))

(fn render-hero
  [c]
  (if
    (btn 0)
    (walking-animation c.up-1 c.up-2 c.x c.y 0)
    (btn 1)
    (walking-animation c.down-1 c.down-2 c.x c.y 0)
    (btn 2)
    (walking-animation c.side-1 c.side-2 c.x c.y 1)
    (btn 3)
    (walking-animation c.side-1 c.side-2 c.x c.y 0)
    (spr c.spr c.x c.y 0 1 0 0 1 2)))

(fn can-move-point?
  [px py]
  (and
    (not (= 0 (mget (// px 8) (// py 8))))
    (>= 96 (mget (// px 8) (// py 8)))))

(fn can-move?
  [x y]
  (and (can-move-point? x y)
       (can-move-point? (+ x 11) y)))

(fn move
  []
  (let [dx  (if (btn 2) -1 (btn 3) 1 0)
        dy  (if (btn 0) -1 (btn 1) 1 0)
        x   chars.Hero.x
        y   chars.Hero.y]
    (print (mget (// x 8) (// y 8)))
    (print (mget (// (+ x dx) 8) (// (+ y dy 15) 8)) 0 20)
    (if
      (can-move? (+ x dx) (+ y dy 15))
      (set (chars.Hero.x chars.Hero.y) (values (+ x dx) (+ y dy)))

      (can-move? (+ x dx) (+ y 15))
      (set chars.Hero.x (+ x dx))

      (can-move? x (+ y dy 15))
      (set chars.Hero.y (+ y dy)))))

(fn interaction?
  []
  (when (and (btn 4) (= 119 (mget (// chars.Hero.x 8) (// (+ chars.Hero.y 15) 8))))
    (mset (// chars.Hero.x 8) (// (+ chars.Hero.y 16) 8) 7)
    (mset (// (+ chars.Hero.x 8) 8) (// (+ chars.Hero.y 16) 8) 8)
    (mset (// chars.Hero.x 8) (// (+ chars.Hero.y 24) 8) 23)
    (mset (// (+ chars.Hero.x 8) 8) (// (+ chars.Hero.y 24) 8) 24))
  (when (= 81 (mget (// chars.Hero.x 8) (// (+ chars.Hero.y 16) 8)))
    (set fading true)
    (set SCENE "PARKING-LOT")))

(fn dialog?
  []
  (let [talking-to (dialog chars.Hero.x chars.Hero.y (btnp 4))]
   (if (and talking-to (btnp 0)) (choose -1)
    (and talking-to (btnp 1)) (choose 1)
    (not talking-to) (move))))

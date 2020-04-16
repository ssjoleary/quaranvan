(local chars {})

(var said nil)
(var who nil)
(var choices nil)
(var choice nil)
(var current-talk nil)

(local convos {})
(local events {})
(local prev-events {})

(fn distance* [ax ay bx by]
  (let [dx (- ax bx)
        dy (- ay by)]
    (math.sqrt (+ (* dx dx) (* dy dy)))))

(fn distance [a b]
  (let [w (* 8 (or b.w 1))
        h (* 8 (or b.h 1))]
    (math.min (distance* a.x a.y b.x b.y)
              (distance* a.x a.y (+ b.x w) b.y)
              (distance* a.x a.y b.x (+ b.y h))
              (distance* a.x a.y (+ b.x w) (+ b.y h))
              (distance* a.x a.y (+ b.x (/ w 2)) (+ b.y h)))))

(fn publish [...]
  (each [_ event (ipairs [...])]
    (tset events (. event :event) true)))

(fn has-happened [event-name] (= true (. events event-name)))

(fn describe [...]
  (let [prev-who who]
    (set who nil)
    (set said (table.concat [...] "\n"))
    (coroutine.yield)
    (set who prev-who)
    (set said nil)))

(fn say
  [...]
  (set said (table.concat [...] "\n"))
  (coroutine.yield)
  (set said nil))

(fn say-as
  [name ...]
  (let [prev-who who]
    (set who (and name (assert (. chars name) (.. name " not found"))))
    (say ...)
    (set who prev-who)))

(fn reply [...]
  (say-as :Hero ...))

(fn ask
  [q ch]
  (set (said choices choice) (values q ch 1))
  (let [answer (coroutine.yield)]
    (set (said choices choice) nil)
    answer))

(local talk-range 12)

(fn find-convo
  [x y]
  (var target nil)
  (var target-dist talk-range)
  (var char nil)
  (each [name c (pairs chars)]
    (when (and (. convos name)
               (< (distance {:x x :y y} c)
                  target-dist)
               (not c.moving?))
      (set target name)
      (set target-dist (distance {:x x :y y} c))
      (set char c)))
  (values (. convos target) char))

(fn choose
  [dir]
  (when (and current-talk choice)
    (set choice (-> (+ dir choice)
                    (math.max 1)
                    (math.min (# choices))))))

(fn dialog
  [x y act?]
  (when act?
    (if current-talk
        (do (assert (coroutine.resume current-talk
                                      (and choices (. choices choice))))
            (when (= (coroutine.status current-talk)
                     "dead")
              (set current-talk nil)))
        (let [(convo char) (find-convo (+ x 4) (+ y 4))]
          (when convo
            (set current-talk (coroutine.create convo))
            (set who char)
            (coroutine.resume current-talk)))))
  (and current-talk {:said said :who who :choices choices}))

(fn set-dialog
  [f]
  (set current-talk (coroutine.create f))
  (set who (. chars :Hero))
  (coroutine.resume current-talk))

(fn draw-dialog
  [portrait-key]
  (when said
   (let [box-height (if (and choices (> (# choices) 3))
                     (+ 12 (* (# choices) 10)) 42)
         box-height (if (= said "")
                     (math.max (- box-height 10) 42) box-height)]
    (rect 0 0 238 box-height 13)
    (rectb 1 1 236 (- box-height 2) 15))
   (print (: said :gsub "|" "") 38 6)
   (when (and who (. who portrait-key))
    (print who.name 5 26)
    (spr (. who portrait-key) 8 6 0 1 0 0 2 2))
   (when choices
    (each [i ch (ipairs choices)]
     (let [choice-y (if (= said "") 0 8)]
      (when (= i choice)
       (print ">" 32 (+ choice-y (* 8 i))))
      (print ch 38 (+ choice-y (* 8 i))))))))

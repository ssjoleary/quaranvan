(fn all.Willie
  []
  (say "Hello there")
  (reply "Hey")
  (say "Go and see if you can open"
       ""
       "that door over there")
  (reply "Ok"))

(fn render-bar-specifics
  []
  (when OPENING?
    (set-dialog (fn [] (describe "Teds Bar" "" "Downtown Toronto...")))
    (set OPENING? false)
    (set SCENE-SET? true))
  (when (not SCENE-SET?)
    (set (chars.Hero.x chars.Hero.y) (values 114 111))
    (set SCENE-SET? true))
  (if
   (= 1 (// (% t 60) 30))
   (spr 5 114 56 0 1 0 0 1 1)

   (= 0 (// (% t 60) 30))
   (spr 6 114 56 0 1 0 0 1 1))
  (let [c chars.Willie]
    (spr c.spr c.x c.y 0 1 1 0 1 2))
  (let [c chars.Hero]
    (render-hero c)))

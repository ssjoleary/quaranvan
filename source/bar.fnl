(fn all.Willie
  []
  (say "Hello there")
  (reply "Hey")
  (say "Go and see if you can open"
       ""
       "that door over there")
  (reply "Ok"))

(fn render-bar-scene
  []
  (when OPENING
    (set-dialog (fn [] (describe "Teds Bar" "" "Downtown Toronto...")))
    (set OPENING false))
  (map 12 6
       5 10
       89 48
       1
       1)
  (if
   (= 1 (// (% t 60) 30))
   (spr 5 107 56 0 1 0 0 1 1)

   (= 0 (// (% t 60) 30))
   (spr 6 107 56 0 1 0 0 1 1))
  (let [c chars.Willie]
    (spr c.spr c.x c.y 0 1 1 0 1 2))
  (let [c chars.Hero]
    (render-hero c)))

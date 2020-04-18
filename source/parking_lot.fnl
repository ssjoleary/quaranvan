(fn render-parking-lot-scene
  []
  (map 5 30
       15 11
       55 30
       1
       1)
  (let [c chars.Hero]
    (tset c :x 103)
    (tset c :y 57)
    (render-hero c)))

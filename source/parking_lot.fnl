(fn render-parking-lot-scene
  []
  (let [c chars.Hero]
    (tset c :x 43)
    (tset c :y 96)
    (render-hero c)))

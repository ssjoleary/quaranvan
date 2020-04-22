(fn render-parking-lot-scene
  []
  (when (not SCENE-SET?)
    (set (chars.Hero.x chars.Hero.y) (values 43 96))
    (set SCENE-SET? true))
  (render-hero chars.Hero))

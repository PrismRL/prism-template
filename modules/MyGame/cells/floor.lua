prism.registerCell("Floor", function()
   return prism.Cell.fromComponents {
      prism.components.Drawable("."),
      prism.components.Collider({ allowedMovetypes = { "walk", "fly" } }),
   }
end)

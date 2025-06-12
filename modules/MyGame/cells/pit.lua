prism.registerCell("Pit", function()
   return prism.Cell.fromComponents {
      prism.components.Drawable(" "),
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
   }
end)

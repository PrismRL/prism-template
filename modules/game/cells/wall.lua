prism.registerCell("Wall", function()
   return prism.Cell.fromComponents {
      prism.components.Name("Wall"),
      prism.components.Drawable("#"),
      prism.components.Collider(),
      prism.components.Opaque(),
   }
end)


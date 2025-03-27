---@param mapBuilder MapBuilder
return function (mapBuilder)
   return function ()
      mapBuilder:drawRectangle(4, 4, 8, 8, prism.cells.Wall)
      coroutine.yield()
      mapBuilder:drawRectangle(5, 5, 7, 7, prism.cells.Floor)
      coroutine.yield()
      mapBuilder:drawEllipse(20, 20, 10, 10, prism.cells.Wall)
      coroutine:yield()
      mapBuilder:drawEllipse(20, 20, 8, 8, prism.cells.Floor)
      coroutine:yield()
      mapBuilder:drawRectangle(10, 10, 15, 15, prism.cells.Wall)
      coroutine:yield()
      mapBuilder:drawRectangle(11, 11, 14, 14, prism.cells.Floor)
   end
end
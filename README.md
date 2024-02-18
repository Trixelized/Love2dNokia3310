Handles:
- Canvas setup (and scaling it to the target window or canvas)
- B/W to 2-color shader (jam palettes)
- Very cheap audio

Minimal setup example:
```lua
local nokia = require("nokia3310")

function love.load()
    nokia.init()
end

function love.draw()
    nokia.draw(function()
        -- draw game in b/w here
    end)
end
```

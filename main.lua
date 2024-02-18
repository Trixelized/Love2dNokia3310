-- Load the Nokia 3310 module
local nokia = require("nokia3310")

function love.load()

    -- Initialize the module on load
    nokia.init()
    -- We can either set a palette on init, or manually:
    nokia.setPalette("original")

    -- Time counter, used in the example
    TimePassed = 0

end

function love.update(dt)

    -- Increment time passed, used in the example
    TimePassed = TimePassed + dt

end

function love.draw()

    -- Wrap our draw event inside nokia.draw
    nokia.draw(
        function()

            -- This is all example
            love.graphics.setLineStyle("rough")

            local w, h = nokia.getDimensions()
            love.graphics.setColor(nokia.black) -- or {0, 0, 0}
            love.graphics.circle(
                "fill",
                math.floor(w * math.abs(1 - 2 * ((0.40 * TimePassed) % 1))),
                math.floor(h * math.abs(1 - 2 * ((0.67 * TimePassed) % 1))),
                5
            )
            love.graphics.rectangle("line", 1.5, 1.5, w - 3, h - 3)

        end
    )
end

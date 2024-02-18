--[[

    Made by Trixelized

    MIT License: https://opensource.org/license/mit/
    Aka 'do whatever the hell you want' :)

--]]


-- The module containing all functions
local nokia3310 = {
    ---Shorthand for white color
    white = {1, 1, 1, 1},
    ---Shorthand for black color
    black = {0, 0, 0, 1}
}


local nokia = {
    myCanvas = nil,
    myShader = nil,
    width = 84,
    height = 48,
    myPalette = "original"
}


local palettes = {
    original = {
        white = {199 / 255, 240 / 255, 216 / 255},
        black = {067 / 255, 082 / 255, 061 / 255}
    },
    harsh = {
        white = {155 / 255, 199 / 255, 000 / 255},
        black = {043 / 255, 063 / 255, 009 / 255}
    },
    gray = {
        white = {135 / 255, 145 / 255, 136 / 255},
        black = {026 / 255, 025 / 255, 020 / 255}
    }
}


---@alias nokia3310.palette
---| "original"
---| "harsh"
---| "gray"


local nokiaShader = [[
    uniform vec3 colors[2];

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
        // Read red from the source texture & color
        float val = (Texel(tex, texture_coords) * color).r;
        // Turn value into either 0 or 1 based on a threshold of 0.5
        val = step(0.5, val);
        return mix(vec4(colors[0], 1.0), vec4(colors[1], 1.0), val);
    }
]]


-- Internal function, initializes the shader
local function initializeShader()
    if not nokia.myShader then
        nokia.myShader = love.graphics.newShader(nokiaShader)
    end
end


---Initialize the Nokia 3310 module.
---This will create the canvas, prepare the shader and such.
---Optionally set an alternate palette.
---@param palette nokia3310.palette? -- The palette used (optional)
---@return nil
function nokia3310.init(palette)

    -- Create the canvas based on width/height
    -- Assign appropriate format and filter
    if not nokia.myCanvas then
        local w, h = nokia3310.getDimensions()
        nokia.myCanvas = love.graphics.newCanvas(w, h)
        nokia.myCanvas:setFilter("linear", "nearest")
    end

    -- Set the palette if defined
    if palette then
        nokia3310.setPalette(palette)
    end

    initializeShader()

end


---Set the Nokia 3310 palette.
---@param palette nokia3310.palette -- The palette used
---@return nil
function nokia3310.setPalette(palette)
    nokia.myPalette = palette
end

---Get the Nokia 3310 dimensions.
---In case you forgot.
---@return integer width
---@return integer height
function nokia3310.getDimensions()
    return nokia.width, nokia.height
end

-- Internal function, draws the canvas to the window
local function drawCanvas()

    -- Get the canvas dimensions
    local canvasW, canvasH = nokia.myCanvas:getDimensions()

    -- Get the target window or canvas dimensions
    local targetCanvas = love.graphics.getCanvas()
    local winW, winH
    if targetCanvas ~= nil then
        winW, winH = targetCanvas:getDimensions()
    else
        winW, winH = love.graphics.getDimensions()
    end

    -- Calculate target scale (to fit the canvas into the window)
    local upW, upH = winW / canvasW, winH / canvasH
    local targetScale = math.min(upW, upH)

    -- Prepare the shader
    local prevShd = love.graphics.getShader()
    love.graphics.setShader(nokia.myShader)
    nokia.myShader:send(
        "colors",
        palettes[nokia.myPalette].black,
        palettes[nokia.myPalette].white
    )

    -- Finally, draw the canvas
    love.graphics.draw(
        nokia.myCanvas,
        winW / 2, winH / 2,
        0,
        targetScale, targetScale,
        canvasW / 2, canvasH / 2
    )

    -- Reset the shader
    love.graphics.setShader(prevShd)

end


---Draw containing code onto the Nokia 3310 canvas.
---It will automatically draw the canvas itself, centered to the window.
---@param drawFunction function
---@return nil
function nokia3310.draw(drawFunction)

    -- Set the canvas target
    local prevCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(nokia.myCanvas)

    -- Clear and draw onto the canvas
    love.graphics.clear({1, 1, 1})
    drawFunction()

    -- Reset the canvas target & reset color
    if prevCanvas then
        love.graphics.setCanvas(prevCanvas)
    else
        love.graphics.setCanvas()
    end
    love.graphics.setColor({1, 1, 1})

    drawCanvas()

end


---A super lazy way to play nothing but 1 sound
---@param sound love.Source
---@return nil
function nokia3310.playSound(sound)
    love.audio.stop()
    love.audio.play(sound)
end


return nokia3310
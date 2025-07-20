matmodPickerLoader = {}

local x, y, i
local used = {}
matmodPickerLoader.initialized = false

function matmodPickerLoader.initializeConfig()
    if matmodPickerLoader.initialized then
        return
    end
    matmodPickerLoader.initialized = true

    matmodPickerLoader.config = root.assetJson("/interface/wedit/matmodPicker/matmodPicker.config")

    local mods = root.assetJson("/interface/wedit/matmodPicker/matmods.json")

    x, y, i = 0, 0, 0

    for _, v in ipairs(mods) do
        matmodPickerLoader.addMod(v)
    end
end

function matmodPickerLoader.addMod(mod)
    if used[mod.name] then
        return
    end
    used[mod.name] = true

    local emtpyFrameBackground = {
        type = "image",
        file = "/interface/wedit/materialPicker/materials/emptyFrameBackground.png",
        position = { x, y },
        zlevel = 1,
    }

    local button = {
        type = "button",
        base = mod.buttonImage,
        hover = mod.buttonImage .. "?brightness=15",
        pressedOffset = { 0, -1 },
        position = { x + 2, y + 2 },
        data = mod.name,
        callback = "pickMod",
        zlevel = 2
    }

    local emptyFrame = {
        type = "image",
        file = "/interface/wedit/materialPicker/materials/emptyFrame.png",
        position = { x, y },
        zlevel = 3,
    }

    matmodPickerLoader.config.gui.modScroll.children[mod.name .. "emptyFrameBackground"] = emtpyFrameBackground
    matmodPickerLoader.config.gui.modScroll.children[mod.name] = button
    matmodPickerLoader.config.gui.modScroll.children[mod.name .. "emptyFrame"] = emptyFrame

    matmodPickerLoader.nextPosition()
end

function matmodPickerLoader.nextPosition()
    i = i + 1
    if i > 5 then
        y = y - 22
        i = 0
    end

    x = i * 22
end
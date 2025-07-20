matmodPickerLoader = {}

local x, y, i
matmodPickerLoader.initialized = false

function matmodPickerLoader.initializeConfig()
    if matmodPickerLoader.initialized then
        return
    end
    matmodPickerLoader.initialized = true

    matmodPickerLoader.config = root.assetJson("/interface/wedit/matmodPicker/matmodPicker.config")

    local mods = root.assetJson("/interface/wedit/matmodPicker/matmods.json") -- { "modName" : [ { "name" : "matmod", "buttonImage" : "/tiles/mods/air.png" } ] }

    x, y, i = 0, 0, 0

    local baseGameAssets = "Base Game Assets"
    matmodPickerLoader.addLabel(baseGameAssets .. " Mat Mods")
    for _, mod in ipairs(mods[baseGameAssets]) do
        matmodPickerLoader.addMod(mod)
    end

    for label, matmod in pairs(mods) do
        if label ~= baseGameAssets then
            matmodPickerLoader.addLabel(label .. " Mat Mods")
            for _, mod in ipairs(matmod) do
                matmodPickerLoader.addMod(mod)
            end
        end
    end
end

function matmodPickerLoader.addLabel(label)
    matmodPickerLoader.nextPosition(true, true)
    local labelConfig = {
        type = "label",
        value = label,
        position = { x, y },
        zlevel = 0,
    }

    matmodPickerLoader.config.gui.modScroll.children[label] = labelConfig

    matmodPickerLoader.nextPosition(true)
end

function matmodPickerLoader.addMod(mod)
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

function matmodPickerLoader.nextPosition(isLabel, isUp) -- Its looks like . . shit. Need to fix it
    if isLabel then
        if isUp then
            if i ~= 0 then
                y = y - 10
            else
                y = y + 10
            end
            i = 0
        else
            y = y - 22
        end
    else
        i = i + 1
        if i > 5 then
            y = y - 22
            i = 0
        end
    end

    x = i * 22
end
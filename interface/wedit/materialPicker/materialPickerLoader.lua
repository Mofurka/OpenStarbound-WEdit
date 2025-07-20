materialPickerLoader = {}

local x, y, i
materialPickerLoader.initialized = false

function materialPickerLoader.initializeConfig()
    if materialPickerLoader.initialized then
        return
    end
    materialPickerLoader.initialized = true

    materialPickerLoader.config = root.assetJson("/interface/wedit/materialPicker/materialPicker.config")

    local materials = root.assetJson("/interface/wedit/materialPicker/materials.json")
    local platforms = root.assetJson("/interface/wedit/materialPicker/platforms.json")

    x, y, i = 0, -19, 0

    --materialPickerLoader.addAir()
    local baseGameAssets = "Base Game Assets"

    materialPickerLoader.addLabel(baseGameAssets .. " Materials")
    for _, mat in ipairs(materials[baseGameAssets]) do
        materialPickerLoader.addMaterial(mat)
    end

    materialPickerLoader.addLabel(baseGameAssets .. " Platforms")
    for _, mat in ipairs(platforms[baseGameAssets]) do
        materialPickerLoader.addMaterial(mat)
    end

    for label, material in pairs(materials) do
        if label ~= baseGameAssets then
            materialPickerLoader.addLabel(label .. " Materials")
            for _, mat in ipairs(material) do
                materialPickerLoader.addMaterial(mat)
            end
        end
    end

    for label, material in ipairs(platforms) do
        if label ~= baseGameAssets then
            materialPickerLoader.addLabel(label .. " Platforms")
            for _, mat in ipairs(material) do
                materialPickerLoader.addMaterial(mat)
            end
        end
    end

end

function materialPickerLoader.addLabel(label)

    materialPickerLoader.nextPosition(true, true)

    local labelConfig = {
        type = "label",
        value = label,
        position = { x, y },
        zlevel = 0,
    }

    materialPickerLoader.config.gui.materialScroll.children[label] = labelConfig

    materialPickerLoader.nextPosition(true)

end

function materialPickerLoader.addMaterial(material)

    local emtpyFrameBackground = {
        type = "image",
        file = "/interface/wedit/materialPicker/materials/emptyFrameBackground.png",
        position = { x, y },
        zlevel = 1,
    }

    local button = {
        type = "button",
        base = material.buttonImage,
        hover = material.buttonImage .. "?brightness=15",
        pressedOffset = { 0, -1 },
        position = { x + 2, y + 2 },
        data = material.name,
        callback = "pickMaterial",
        zlevel = 2
    }

    local emptyFrame = {
        type = "image",
        file = "/interface/wedit/materialPicker/materials/emptyFrame.png",
        position = { x, y },
        zlevel = 3,
    }

    materialPickerLoader.config.gui.materialScroll.children[material.name .. "emptyFrameBackground"] = emtpyFrameBackground

    materialPickerLoader.config.gui.materialScroll.children[material.name] = button

    materialPickerLoader.config.gui.materialScroll.children[material.name .. "emptyFrame"] = emptyFrame

    materialPickerLoader.nextPosition()

end

function materialPickerLoader.addAir()

    local button = {
        type = "button",
        base = "/interface/wedit/materialPicker/materials/air.png",
        hover = "/interface/wedit/materialPicker/materials/air.png?brightness=15",
        pressedOffset = { 0, -1 },
        position = { x, y },
        data = false,
        callback = "pickMaterial"
    }

    materialPickerLoader.config.gui.materialScroll.children["air"] = button

    materialPickerLoader.nextPosition()

end

function materialPickerLoader.nextPosition(isLabel, isUp)

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
        if i > 9 then
            y = y - 22
            i = 0
        end
    end

    x = i * 22

end
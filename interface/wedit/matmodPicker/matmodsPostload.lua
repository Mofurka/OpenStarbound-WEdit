local matmodConfigPath = "/interface/wedit/matmodPicker/matmods.json"

local matmodList = assets.scan("/tiles/mods", "matmod")

local matmodData = {}

for _, path in ipairs(matmodList) do
    local matmod = assets.json(path)
    if matmod then
        local buttonImage = "/tiles/mods/" .. matmod.renderParameters.texture .. "?crop;0;0;16;16" or "/assetmissing.png"
        table.insert(matmodData, {
            name = matmod.modName,
            buttonImage = buttonImage
        })
    end
end

assets.add(matmodConfigPath, matmodData)
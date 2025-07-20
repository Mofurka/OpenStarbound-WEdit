local matmodConfigPath = "/interface/wedit/matmodPicker/matmods.json"

local matmodList = assets.scan("/tiles/mods", "matmod")

local function getModName(assetSourcePaths, modPath)
    local mod = assetSourcePaths[modPath]
    if mod == nil then return UNKNOWN end
    if mod.name == nil then
        mod.name = UNKNOWN
        if mod.friendlyName == nil then
            mod.friendlyName = UNKNOWN
        end
    end
    return mod.name, mod.friendlyName
end
local sourcePaths = assets.sourcePaths(true)


local matmodData = {} -- { "modName" : [ { "name" : "matmod", "buttonImage" : "/tiles/mods/air.png" } ] }

for _, path in ipairs(matmodList) do
    local matmod = assets.json(path)
    local origin = assets.origin(path)
    local _, friendlyName = getModName(sourcePaths, origin)
    if matmod then
        if not matmodData[friendlyName] then
            matmodData[friendlyName] = {}
        end
        local buttonImage = "/tiles/mods/" .. matmod.renderParameters.texture .. "?crop;0;0;16;16" or "/assetmissing.png"
        table.insert(matmodData[friendlyName], {
            name = matmod.modName,
            buttonImage = buttonImage,
        })
    end
end

assets.add(matmodConfigPath, matmodData)
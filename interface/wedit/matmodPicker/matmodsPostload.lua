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


local matmodData = {}

for _, path in ipairs(matmodList) do
    local matmod = assets.json(path)
    local origin = assets.origin(path)
    local name, friendlyName = getModName(sourcePaths, origin)
    if matmod then
        if not matmodData[name] then
            matmodData[name] = {
                image = "/tiles/mods/" .. matmod.renderParameters.texture .. "?crop;0;0;16;16" or "/assetmissing.png",
                friendlyName = friendlyName .. " Mat Mods",
                items = {},
            }
        end
        local image = "/tiles/mods/" .. matmod.renderParameters.texture .. "?crop;0;0;16;16" or "/assetmissing.png"
        table.insert(matmodData[name]["items"], {
            name = matmod.modName,
            image = image,
        })
    end
end

assets.add(matmodConfigPath, matmodData)
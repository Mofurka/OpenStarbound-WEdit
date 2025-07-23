local materialsConfigPath = "/interface/wedit/materialPicker/materials.json"
local platformsConfigPath = "/interface/wedit/materialPicker/platforms.json"

local matitems = assets.scan("/items/materials", "matitem")
-- returns a table of material paths
-- example ["/tiles/materials/ikn_marblewp.material","/tiles/materials/sand.material","/tiles/materials/viridescent/viridescent_tile1.material","/tiles/materials/darksmoothstone.material","/tiles/materials/havencrest/havencrest_tile8.material","/tiles/materials/elysia/elysia_tile1.material"]

local materialDict = {}

local function getModName(assetSourcePaths, modPath)
    local mod = assetSourcePaths[modPath]
    if mod == nil then
        return UNKNOWN
    end
    if mod.name == nil then
        mod.name = UNKNOWN
        if mod.friendlyName == nil then
            mod.friendlyName = UNKNOWN
        end
    end
    return mod.name, mod.friendlyName
end
local sourcePaths = assets.sourcePaths(true)

for _, path in ipairs(matitems) do
    local material = assets.json(path)
    local origin = assets.origin(path)
    local name, friendlyName = getModName(sourcePaths, origin)

    if material then
        if material.category == "platform" then
            name = name .. "_platforms"
            if materialDict[name] == nil then
                materialDict[name] = {
                    friendlyName = friendlyName .. " Platforms",
                    category = "platform",
                    items = {},
                    modImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
                }
            end
            local image = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(materialDict[name]["items"], {
                name = material.itemName,
                image = image,
                shortdescription = material.shortdescription or "",
            })
        else
            name = name .. "_blocks"
            if materialDict[name] == nil then
                materialDict[name] = {
                    friendlyName = friendlyName .. " Blocks",
                    category = material.category or "unknown",
                    items = {},
                    modImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
                }
            end
            local image = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(materialDict[name]["items"], {
                name = material.itemName,
                image = image,
                shortdescription = material.shortdescription or "",
            })
        end
    end

end

assets.add(materialsConfigPath, materialDict)

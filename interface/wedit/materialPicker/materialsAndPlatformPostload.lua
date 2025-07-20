local materialsConfigPath = "/interface/wedit/materialPicker/materials.json"
local platformsConfigPath = "/interface/wedit/materialPicker/platforms.json"

local matitems = assets.scan("/items/materials", "matitem")
-- returns a table of material paths
-- example ["/tiles/materials/ikn_marblewp.material","/tiles/materials/sand.material","/tiles/materials/viridescent/viridescent_tile1.material","/tiles/materials/darksmoothstone.material","/tiles/materials/havencrest/havencrest_tile8.material","/tiles/materials/elysia/elysia_tile1.material"]

local materialDict = {}
local platformDict = {}

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
    local _, friendlyName = getModName(sourcePaths, origin)
    --[[    {
            "itemName" : "modernplatform",
            "price" : 0,
            "category" : "platform",
            "rarity" : "Common",
            "inventoryIcon" : "modernplatform.png",
            "materialId" : 47,
            "learnBlueprintsOnPickup" : [ "modernplatform" ]
        }]]

    if material then
        if material.category == "block" then
            if materialDict[friendlyName] == nil then
                materialDict[friendlyName] = {}
            end
            local buttonImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(materialDict[friendlyName], {
                name = material.itemName,
                buttonImage = buttonImage
            })
        elseif material.category == "platform" then
            if platformDict[friendlyName] == nil then
                platformDict[friendlyName] = {}
            end
            local buttonImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(platformDict[friendlyName], {
                name = material.itemName,
                buttonImage = buttonImage
            })
        end
    end

end

assets.add(materialsConfigPath, materialDict)
assets.add(platformsConfigPath, platformDict)

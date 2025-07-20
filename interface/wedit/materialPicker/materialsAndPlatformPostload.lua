local materialsConfigPath = "/interface/wedit/materialPicker/materials.json"
local platformsConfigPath = "/interface/wedit/materialPicker/platforms.json"

local matitems = assets.scan("/items/materials", "matitem")
-- returns a table of material paths
-- example ["/tiles/materials/ikn_marblewp.material","/tiles/materials/sand.material","/tiles/materials/viridescent/viridescent_tile1.material","/tiles/materials/darksmoothstone.material","/tiles/materials/havencrest/havencrest_tile8.material","/tiles/materials/elysia/elysia_tile1.material"]

local materialList = {} -- [ {name = "materialName", buttonImage = "materialImage.png"} ]
local platformList = {} -- [ {name = "platformName", buttonImage = "platformImage.png"} ]



for _, path in ipairs(matitems) do
    local material = assets.json(path)
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
            local buttonImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(materialList, {
                name = material.itemName,
                buttonImage = buttonImage
            })
        elseif material.category == "platform" then
            local buttonImage = "/items/materials/" .. material.inventoryIcon or "/assetmissing.png"
            table.insert(platformList, {
                name = material.itemName,
                buttonImage = buttonImage
            })
        end
    end

end

assets.add(materialsConfigPath, materialList)
assets.add(platformsConfigPath, platformList)

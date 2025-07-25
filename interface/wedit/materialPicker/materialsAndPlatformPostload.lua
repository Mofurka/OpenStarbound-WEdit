local materialsConfigPath = "/interface/wedit/materialPicker/materials.json"

local matitemsPathList = assets.scan("/", "matitem")
local materialsPathList = assets.scan("/", "material")
-- returns a table of material paths
-- example ["/tiles/materials/ikn_marblewp.material","/tiles/materials/sand.material","/tiles/materials/viridescent/viridescent_tile1.material","/tiles/materials/darksmoothstone.material","/tiles/materials/havencrest/havencrest_tile8.material","/tiles/materials/elysia/elysia_tile1.material"]
-- material example
-- {
--  "materialId" : 104,
--  "materialName" : "cheapwallpaper",
--  "particleColor" : [214, 200, 147, 255],
--  "itemDrop" : "cheapwallpaper",
--  "description" : "Cheap, tacky wallpaper.",
--  "shortdescription" : "Tacky Wallpaper",
--  "glitchDescription" : "Unsettled. This wall paper is overwhelmingly gaudy.",
--  "floranDescription" : "Floran adore pretty wall paperss.",
--  "novakidDescription" : "Why'd anyone want to cover their walls with paper lookin' like this?",
--  "footstepSound" : "/sfx/blocks/footstep_lightwood.ogg",
--  "health" : 8,
--  "category" : "materials",
--  "damageTable" : "/tiles/flammableDamage.config",
--
--  "renderTemplate" : "/tiles/classicmaterialtemplate.config",
--  "renderParameters" : {
--    "texture" : "cheapwallpaper.png",
--    "variants" : 1,
--    "lightTransparent" : false,
--    "multiColored" : true,
--    "occludesBelow" : true,
--    "zLevel" : 2650
--  }
--}

-- matitem example
-- {
--  "itemName" : "alienrock",
--  "price" : 0,
--  "category" : "block",
--  "rarity" : "Common",
--  "inventoryIcon" : "alienrock.png",
--  "description" : "This strange rock comes from an alien world.",
--  "shortdescription" : "Alien Rock",
--  "glitchdescription" : "Amazed. This rock is of an alien origin.",
--  "florandescription" : "Floran like sstrange rocks.",
--  "novakiddescription" : "Some kinda alien lookin' rock.",
--
--  "materialId" : 143
--}

local materialMap = {}
local matitemsMap = {}

local function getDirectoryPath(filePath)
    return filePath:match("(.*/)")
end

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

for _, path in ipairs(matitemsPathList) do
    local matitem = assets.json(path)
    local matitemId = matitem.materialId
    if matitemId then
        local stripedPath = getDirectoryPath(path)
        matitemsMap[matitemId] = {
            icon = stripedPath .. matitem.inventoryIcon or "/assetmissing.png",
            shortdescription = matitem.shortdescription or "",
            category = matitem.category or "block",
        }
    end
end



for _, path in ipairs(materialsPathList) do
    local material = assets.json(path)
    local origin = assets.origin(path)
    local name, friendlyName = getModName(sourcePaths, origin)
    local materialId = material.materialId
    if materialId then
        local matitem = matitemsMap[materialId]
        if matitem then
            if matitem.category == "platform" then
                name = name .. "_platforms"
                if materialMap[name] == nil then
                    materialMap[name] = {
                        friendlyName = friendlyName .. " Platforms",
                        category = matitem.category,
                        items = {},
                        modImage = matitem.icon
                    }
                end
                table.insert(materialMap[name]["items"], {
                    name = material.materialName,
                    image = matitem.icon,
                    shortdescription = matitem.shortdescription
                })
            else
                name = name .. "_blocks"
                if materialMap[name] == nil then
                    materialMap[name] = {
                        friendlyName = friendlyName .. " Blocks",
                        category = material.category or "unknown",
                        items = {},
                        modImage = matitem.icon
                    }
                end
                table.insert(materialMap[name]["items"], {
                    name = material.materialName,
                    image = matitem.icon,
                    shortdescription = matitem.shortdescription
                })
            end
        end
    end

end

assets.add(materialsConfigPath, materialMap)

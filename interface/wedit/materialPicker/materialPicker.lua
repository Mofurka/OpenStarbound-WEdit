local MATERIAL_LIST = "materialScroll.materialList"
local CATEGORY_LIST = "categoryScroll.categoryList"
local BASE_GAME_ASSETS_MATERIALS = "base_blocks"
local BASE_GAME_ASSETS_PLATFORM = "base_platforms"

local materials

function init()
    -- Prevent multiples material pickers.
    -- If the value is somehow true while the interface is closed, a reload should fix this.
    -- controller.lua forces them back to false on init.
    if status.statusProperty("wedit.materialPicker.open") then
        forceClosed = true
        pane.dismiss()
    end

    status.setStatusProperty("wedit.materialPicker.open", true)
    materials = root.assetJson("/interface/wedit/materialPicker/materials.json")
    populateCategorySorted()
    populateItemList(materials[BASE_GAME_ASSETS_MATERIALS]["items"])


end

function update()


end

function populateCategorySorted()
    widget.clearListItems(CATEGORY_LIST)
    populateCategoryList(BASE_GAME_ASSETS_MATERIALS, materials[BASE_GAME_ASSETS_MATERIALS])
    populateCategoryList(BASE_GAME_ASSETS_PLATFORM, materials[BASE_GAME_ASSETS_PLATFORM])
    for categoryName, categoryData in pairs(materials) do
        if categoryName ~= BASE_GAME_ASSETS_MATERIALS and categoryName ~= BASE_GAME_ASSETS_PLATFORM then
            populateCategoryList(categoryName, categoryData)
        end
    end
end

function populateCategoryList(categoryName, categoryData)
    local w = widget.addListItem(CATEGORY_LIST)
    local wName = CATEGORY_LIST .. "." .. w
    widget.setImage(wName .. ".categoryIcon", categoryData.modImage or "/assetmissing.png")
    widget.setData(wName .. ".emptyFrameForeground", {defaultTooltip = categoryData.friendlyName})
    widget.setData(wName, categoryName)
end

function pickCategory()
    local data = widget.getData(CATEGORY_LIST .. "." .. widget.getListSelected(CATEGORY_LIST))

        populateItemList(materials[data]["items"])

end

function populateItemList(items)
    if not items or #items == 0 then
        return
    end
    widget.clearListItems(MATERIAL_LIST)
    for _, item in ipairs(items) do
        local w = widget.addListItem(MATERIAL_LIST)
        local wName = MATERIAL_LIST .. "." .. w
        widget.setImage(wName .. ".materialIcon", item.image)
        widget.setData(wName .. ".emptyFrameForeground", {defaultTooltip = item.name})
        widget.setData(wName, item.name)
    end
end

function pickMaterial()
    local selected = widget.getListSelected(MATERIAL_LIST)
    if not selected then return end
    local data = widget.getData(MATERIAL_LIST .. "." .. selected)
    world.sendEntityMessage(player.id(), "wedit.updateColor", data)
end

function createTooltip(screenPosition)
    if self.tooltipFields then
        for widgetName, tooltip in pairs(self.tooltipFields) do
            if widget.inMember(widgetName, screenPosition) then
                return tooltip
            end
        end
    end
    local w = widget.getChildAt(screenPosition)
    sb.setLogMap("MaterialPicker Widget", "%s", w)
    if w then
        w = w:sub(2)
        local wData = widget.getData(w)
        if wData and type(wData) == "table" and wData.defaultTooltip then
            return wData.defaultTooltip
        end
    end
end


function uninit()
    widget.clearListItems(MATERIAL_LIST)
    widget.clearListItems(CATEGORY_LIST)
    if not forceClosed then
        status.setStatusProperty("wedit.materialPicker.open", nil)
    end
end

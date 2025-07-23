require("/scripts/deg_timer_wedit/timer.lua")

local MATERIAL_LIST = "materialScroll.materialList"
local CATEGORY_LIST = "categoryScroll.categoryList"
local BASE_GAME_ASSETS_MATERIALS = "base_blocks"
local BASE_GAME_ASSETS_PLATFORM = "base_platforms"

local materials

local currentCategory = BASE_GAME_ASSETS_MATERIALS

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

function update(dt)
    timers:update(dt)
end

function clearSearchBar()
    widget.setText("txbSearchBar", "")
    if timers:has(searchTimerId) then
        timers:remove(searchTimerId)
    end
end

function search(wName)
    local searchString = widget.getText(wName)
    --chat.addMessage("Searching for: " .. searchString or "")
    if timers:has(searchTimerId) then
        timers:remove(searchTimerId)
    end

    searchTimerId = timers:add(0.5, function()
        sortSearch(searchString:lower())
    end)

end

function sortSearch(searchString)
    local items = materials[currentCategory]["items"]
    if searchString == "" then
        populateItemList(items)
        return
    else
        local sortedItems = {}
        for _, item in ipairs(items) do
            if item.name:lower():find(searchString) or item.shortdescription:lower():find(searchString) then
                table.insert(sortedItems, item)
            end
        end
        populateItemList(sortedItems)
    end
end

function populateCategorySorted()
    widget.clearListItems(CATEGORY_LIST)
    addCategory(BASE_GAME_ASSETS_MATERIALS, materials[BASE_GAME_ASSETS_MATERIALS])
    addCategory(BASE_GAME_ASSETS_PLATFORM, materials[BASE_GAME_ASSETS_PLATFORM])
    for categoryName, categoryData in pairs(materials) do
        if categoryName ~= BASE_GAME_ASSETS_MATERIALS and categoryName ~= BASE_GAME_ASSETS_PLATFORM then
            addCategory(categoryName, categoryData)
        end
    end
end

function addCategory(categoryName, categoryData)
    local w = widget.addListItem(CATEGORY_LIST)
    local wName = CATEGORY_LIST .. "." .. w
    widget.setImage(wName .. ".categoryIcon", categoryData.modImage or "/assetmissing.png")
    widget.setData(wName .. ".emptyFrameForeground", { defaultTooltip = categoryData.friendlyName })
    widget.setData(wName, categoryName)
end

function pickCategory()
    local selected = widget.getListSelected(CATEGORY_LIST)
    if not selected then
        return
    end
    local data = widget.getData(CATEGORY_LIST .. "." .. selected)
    currentCategory = data
    clearSearchBar()
    populateItemList(materials[data]["items"])
end

function populateItemList(items)
    widget.clearListItems(MATERIAL_LIST)
    if not items or #items == 0 then
        return
    end
    for _, item in ipairs(items) do
        local w = widget.addListItem(MATERIAL_LIST)
        local wName = MATERIAL_LIST .. "." .. w
        widget.setImage(wName .. ".materialIcon", item.image)
        widget.setData(wName .. ".emptyFrameForeground", { defaultTooltip = string.format("%s : %s", item.shortdescription, item.name) })
        widget.setData(wName, item.name)
    end
end

function pickMaterial()
    local selected = widget.getListSelected(MATERIAL_LIST)
    if not selected then
        return
    end
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

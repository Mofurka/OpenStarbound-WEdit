require("/scripts/deg_timer_wedit/timer.lua")

local MATMOD_LIST = "modScroll.modList"
local CATEGORY_LIST = "categoryScroll.categoryList"
local BASE_GAME_ASSETS_MATMODS = "base"

local mods

local currentCategory = BASE_GAME_ASSETS_MATMODS

function init()
    -- Prevent multiples matmod pickers.
    -- If the value is somehow true while the interface is closed, a reload should fix this.
    -- controller.lua forces them back to false on init.
    if status.statusProperty("wedit.matmodPicker.open") then
        forceClosed = true
        pane.dismiss()
        return
    end

    status.setStatusProperty("wedit.matmodPicker.open", true)
    mods = root.assetJson("/interface/wedit/matmodPicker/matmods.json")
    populateCategorySorted()
    populateItemList(mods[BASE_GAME_ASSETS_MATMODS]["items"])
end

function update(dt)
    timers:update(dt)
end

function pickCategory()
    local selected = widget.getListSelected(CATEGORY_LIST)
    if not selected then
        return
    end
    local data = widget.getData(CATEGORY_LIST .. "." .. selected)
    currentCategory = data
    clearSearchBar()
    populateItemList(mods[data]["items"])
end

function pickMod()
    local selected = widget.getListSelected(MATMOD_LIST)
    if not selected then
        return
    end
    local data = widget.getData(MATMOD_LIST .. "." .. selected)
    world.sendEntityMessage(player.id(), "wedit.updateMatmod", data)
end

function populateCategorySorted()
    widget.clearListItems(CATEGORY_LIST)
    addCategory(BASE_GAME_ASSETS_MATMODS, mods[BASE_GAME_ASSETS_MATMODS])
    for categoryName, categoryData in pairs(mods) do
        if categoryName ~= BASE_GAME_ASSETS_MATMODS then
            addCategory(categoryName, categoryData)
        end
    end
end

function addCategory(categoryName, categoryData)
    local w = widget.addListItem(CATEGORY_LIST)
    local wName = CATEGORY_LIST .. "." .. w
    widget.setImage(wName .. ".categoryIcon", categoryData.image or "/assetmissing.png")
    widget.setData(wName .. ".emptyFrameForeground", { defaultTooltip = categoryData.friendlyName })
    widget.setData(wName, categoryName)
end

function populateItemList(items)

    widget.clearListItems(MATMOD_LIST)
    if not items or #items == 0 then
        return
    end
    for _, item in ipairs(items) do
        local w = widget.addListItem(MATMOD_LIST)
        local wName = MATMOD_LIST .. "." .. w
        widget.setImage(wName .. ".itemIcon", item.image or "/assetmissing.png")
        widget.setData(wName, item.name)
        widget.setData(wName .. ".emptyFrameForeground", { defaultTooltip = item.friendlyName })
    end
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
    local items = mods[currentCategory]["items"]
    if searchString == "" then
        populateItemList(items)
        return
    else
        local sortedItems = {}
        for _, item in ipairs(items) do
            if item.name:lower():find(searchString) then
                table.insert(sortedItems, item)
            end
        end
        populateItemList(sortedItems)
    end
end

function uninit()
    if not forceClosed then
        status.setStatusProperty("wedit.matmodPicker.open", nil)
    end
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
    sb.setLogMap("Matmod Picker Widget", "%s", w)
    if w then
        w = w:sub(2)
        local wData = widget.getData(w)
        if wData and type(wData) == "table" and wData.defaultTooltip then
            return wData.defaultTooltip
        end
    end
end



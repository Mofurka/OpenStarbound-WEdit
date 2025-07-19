function init()
    isOsb = root.assetOrigin and root.assetOrigin("/opensb/coconut.png")
    if not isOsb then
        script.setUpdateDelta(0)
        sb.logError("OpenSB not found! https://github.com/OpenStarbound/OpenStarbound")
    end
end


function update(dt)
    if input.bindDown("opensb", "materialCollisionCycle") then
        world.sendEntityMessage(player.id(), "wedit.cycleMaterialCollision")
    end
end
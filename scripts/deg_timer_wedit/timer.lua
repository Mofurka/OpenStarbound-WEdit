
TimerKeeper = {}
TimerKeeper.__index = TimerKeeper

function TimerKeeper.new()
  local self = setmetatable({}, TimerKeeper)
  self.timers = {}
  self.next_id = 1
  return self
end

function TimerKeeper:add(duration, fun)
  local id = self.next_id
  self.next_id = self.next_id + 1
  self.timers[id] = { duration = duration, fun = fun }
  return id
end


function TimerKeeper:remove(id)
  if self.timers[id] then
    self.timers[id] = nil
    return true
  end
  return false
end

function TimerKeeper:empty()
  return next(self.timers) == nil
end

function TimerKeeper:clear()
  self.timers = {}
  self.next_id = 1
end

function TimerKeeper:has(id)
  if id == nil then
    return false
  end
  return self.timers[id] ~= nil
end

function TimerKeeper:update(dt)
  local current = self.timers
  self.timers = {}
  for id, timer in pairs(current) do
    timer.duration = timer.duration - dt
    if timer.duration <= 0 then
      timer.fun()
    else
      self.timers[id] = timer
    end
  end
end

timers = TimerKeeper.new()

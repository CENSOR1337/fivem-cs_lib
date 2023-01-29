local table_unpack = table.unpack
local Citizen_Await = Citizen.Await

local triggerServerCallback = function(eventname, listener, ...)
    if not (listener) then error("listener for server callback is nil") end
    local callbackId = lib.utils.randomString(16)
    local cbEventName = "cslib:serverCallbacks:" .. eventname
    lib.onceNet(cbEventName .. callbackId, listener)
    TriggerServerEvent(cbEventName, callbackId, ...)
end

local triggerServerCallbackSync = function(eventname, ...)
    local function handler(...)
        local p = promise.new()
        triggerServerCallback(eventname, function(...)
            p:resolve({ ... })
        end, ...)
        return Citizen_Await(p)
    end

    return table_unpack(handler(...))
end

return {
    triggerServerCallback = triggerServerCallback,
    triggerServerCallbackSync = triggerServerCallbackSync
}

local frame = _G.CreateFrame("FRAME") -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED") -- Fired when saved variables are loaded
local beast_lore_target
local addonName = ...

-- Event handler
function frame:OnEvent(event, ...)
    local arg1 = ...
    if event == "ADDON_LOADED" and arg1 == addonName then
        --@debug@
        print("LibHunterPetInfo loaded")
        --@end-debug@

        self:RegisterEvent("UNIT_SPELLCAST_SENT")
    elseif event ~= "ADDON_LOADED" then
        if self[event] == nil then
            error('No event handler for ' .. event)
        else
            self[event](...)
        end
    end
end
frame:SetScript("OnEvent", frame.OnEvent)

function frame.UNIT_SPELLCAST_SENT(_, target, _, spell)
    if spell == 1462 then
        --@debug@
        print('Beast lore casted at ' .. target)
        --@end-debug@
        beast_lore_target = target
        frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end
end

function frame.UNIT_SPELLCAST_SUCCEEDED(_, _, spell)
    if spell == 1462 then
        --@debug@
        print('Beast lore successful')
        --@end-debug@
        frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
        frame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end
end

function frame.UPDATE_MOUSEOVER_UNIT()
    if _G.GetUnitName("mouseover") == beast_lore_target then
        local lore = _G['BeastLore']:ParseBeastLoreTooltip()
        if not lore then
            return
        end
        --@debug@
        print('Saved lore for ' .. lore['name'], lore['abilities'][1])
        --@end-debug@
        frame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
    end
end
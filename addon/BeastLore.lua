_G['BeastLore'] = {}
local BeastLore = _G['BeastLore']

if not _G['BeastLoreData'] then
    _G['BeastLoreData'] = {}
end
local utils = _G.LibStub('BM-utils-1', 5)

---Get the content of the current tooltip
function BeastLore.ReadTooltip()
    local lines = {}
    local line
    for lineNum = 1, _G['GameTooltip']:NumLines() do
        line = _G["GameTooltipTextLeft" .. lineNum]:GetText();
        table.insert(lines, line)
    end
    return lines
end

function BeastLore.ParseBeastLore(tooltip)
    local patterns = {
        level = 'Level (%d+) (.+)',
        --abilities = 'Tamed Abilities: (.+) %(Rank (%d)%)',
        abilities = 'Tamed Abilities: (.+)',
        diet = 'Diet: (.+)',
    }
    local diet = {}
    local abilities = {}
    local beastName = tooltip[1]
    local level

    for _, line in ipairs(tooltip) do
        if line == 'Cannot be Tamed' then
            _G['BeastLoreData'][beastName] = line
            --@debug@
            print(beastName .. ' cannot be tamed')
            --@end-debug@
            return false
        end
        for key, pattern in pairs(patterns) do
            local _, _, match = string.find(line, pattern)
            if match then
                if key == 'abilities' then
                    for spell, rank in string.gmatch(match, '(%u[%w ]+) %(Rank (%d)%)') do
                        --@debug@
                        utils:printf('Spell %s Rank %d', spell, rank)
                        --@end-debug@
                        table.insert(abilities, { name = spell, rank = rank })
                    end
--[[                    if string.find(match, 'Rank') == nil then
                        print('Spell without rank found, please mouse over again', match, line)
                        --return false
                    end]]
                elseif key == 'diet' then
                    for item in string.gmatch(match, '[^%s,]+') do
                        table.insert(diet, item)
                    end
                elseif key == 'level' then
                    level = match
                end
            end
        end
    end
    if abilities[1] == nil and diet[1] == nil then
        --@debug@
        print('No beast info in tooltip')
        --@end-debug@
        return false
    end

    local guid = _G.UnitGUID("mouseover")
    if not _G['BeastLoreData'][beastName] then
        _G['BeastLoreData'][beastName] = { level = level, name = beastName, guid = guid }
    end
    if abilities then
        _G['BeastLoreData'][beastName]['abilities'] = abilities
    end
    if diet then
        _G['BeastLoreData'][beastName]['diet'] = diet
    end
    _G['BeastLoreData'][beastName]['tooltip'] = tooltip

    return _G['BeastLoreData'][beastName]
end

function BeastLore:ParseBeastLoreTooltip()
    return self.ParseBeastLore(self.ReadTooltip())
end
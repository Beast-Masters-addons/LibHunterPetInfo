_G['LocalizedTables'] = {}
local LocalizedTables = _G['LocalizedTables']
local locale = _G.GetLocale()

_G['LocalizedTableData'] = {
    PetDiet = _G['PetDietLocale'],
    PetFamilyNames = _G['PetFamilyNames'],
}

function LocalizedTables.getTable(tableName)
    assert(_G['LocalizedTableData'][tableName], ('Invalid table name: %s'):format(tableName))
    local currentTable = _G['LocalizedTableData'][tableName]
    if currentTable[locale] == nil then
        --@debug@
        print(('Invalid locale %s for table %s, falling back to enUS'):format(locale, tableName))
        --@end-debug@
        return currentTable['enUS']
    else
        return currentTable[locale]
    end
end

function LocalizedTables.getValue(tableName, valueName)
    local localizedTable = LocalizedTables.getTable(tableName)
    assert(localizedTable[valueName], ('Invalid key %s for table %s'):format(valueName, tableName))
    return localizedTable[valueName]
end
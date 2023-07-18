local utils = {
    dependencies = {}
}

function utils:init()

end

function utils:isInTable(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end

    return false
end

function utils:areAllValuesInTable(table1, table2)
    local countTable = {}

    -- Create a count table for table2
    for _, value in pairs(table2) do
        if countTable[value] then
            countTable[value] = countTable[value] + 1
        else
            countTable[value] = 1
        end
    end

    -- Check that each value in table1 is present in the count table
    for _, value in pairs(table1) do
        if not countTable[value] or countTable[value] == 0 then
            return false
        end

        countTable[value] = countTable[value] - 1
    end

    return true
end

function utils:areTablesEqual(table1, table2)
    -- Check if the tables have the same size
    if #table1 ~= #table2 then
        return false
    end

    -- Check if the tables have the same elements
    for i = 1, #table1 do
        if table1[i] ~= table2[i] then
            return false
        end
    end

    return true
end

function utils:lenghtOfTable(tbl)
    local i = 0

    for _, v in pairs(tbl) do
        i = i + 1
    end
    return i
end

function utils:uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local ret = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and global:random(0, 0xf) or global:random(8, 0xb)
        if c == 'y' then
            v = bit32.bor(bit32.band(v, 0x3), 0x8)
        end
        return string.format('%x', v)
    end)
    return ret
end

function utils:copyFile(sourceFile, destinationFile)
    local input = assert(io.open(sourceFile, "rb"))
    local output = assert(io.open(destinationFile, "wb"))

    local data = input:read("*a") -- lit tout le fichier
    output:write(data) -- écrit les données dans le fichier de destination

    input:close()
    output:close()
end

function utils:createBackupFileName(originalFileName)
    local date = os.date("*t") -- récupère la date et l'heure actuelles

    local year = date.year
    local month = date.month
    local day = date.day
    local hour = date.hour
    local min = date.min
    local sec = date.sec

    local backupFileName = string.format("%sbackup_%02d-%02d-%04d-%02d-%02d-%02d_", "", day, month, year, hour, min, sec)
    return backupFileName .. originalFileName
end

function utils:getLatestBackupFilePath(directory)
    local allFilesNameInDirectory = global:getAllFilesNameInDirectory(directory)
    local latestTime = 0
    local latestFile = nil
    for _, filename in pairs(allFilesNameInDirectory) do
        if filename:find("backup") then
            local day, month, year, hour, min, sec = filename:match("backup_(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)")
            local timestamp = os.time({year=year, month=month, day=day, hour=hour, min=min, sec=sec})
            if timestamp > latestTime then
                latestTime = timestamp
                latestFile = filename
            end
        end
    end

    if latestFile then
        return directory .. "\\" .. latestFile
    else
        return nil
    end
end

function utils:convertNumberKeysToStrings(t)
    local newTable = {}
    for k, v in pairs(t) do
        if type(k) == "number" then
            k = tostring(k)
        end
        if type(v) == "table" then
            newTable[k] = convertNumberKeysToStrings(v)
        else
            newTable[k] = v
        end
    end
    return newTable
end

function utils:convertNumberValueToStrings(t)
    local newTable = {}
    for k, v in pairs(t) do
        if type(v) == "number" then
            v = tostring(v)
        end
        if type(v) == "table" then
            newTable[k] = convertNumberValueToStrings(v)
        else
            newTable[k] = v
        end
    end
    return newTable
end

return utils
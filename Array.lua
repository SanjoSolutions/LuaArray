local function filter(list, predicate)
    local result = {}
    for index, item in ipairs(list) do
        if predicate(item) then
            table.insert(result, item)
        end
    end
    return result
end

local function findIndex(list, predicate)
    for index, item in ipairs(list) do
        if predicate(item) then
            return index
        end
    end
    return -1
end

local function isEqual(value)
    return function (value2)
        return value2 == value
    end
end

local function indexOf(list, value)
    return findIndex(list, isEqual(value))
end

local function find(list, predicate)
    local index = findIndex(list, predicate)
    local result
    if index == -1 then
        result = nil
    else
        result = list[index]
    end
    return result
end

local function includes(list, value)
    return find(list, function (value2)
        return value2 == value
    end) ~= nil
end

local function map(list, predicate)
    local result = {}
    for index, item in ipairs(list) do
        result[index] = predicate(item, index)
    end
    return result
end

local function reduce(list, predicate, initialValue)
    local value
    local initialIndex
    if initialValue == nil then
        value = list[1]
        initialIndex = 2
    else
        value = initialValue
        initialIndex = 1
    end
    for index = initialIndex, #list do
        value = predicate(value, list[index], list)
    end
    return value
end

local function all(list, predicate)
    for _, item in ipairs(list) do
        if not predicate(item) then
            return false
        end
    end
    return true
end

local function copy(list)
    local result = {}
    for index, item in ipairs(list) do
        result[index] = item
    end
    return result
end

local function concat(...)
    local result = {}
    for _, list in ipairs({...}) do
        for _, item in ipairs(list) do
            table.insert(result, item)
        end
    end
    return result
end

local function append(list, listToAppend)
    for _, item in ipairs(listToAppend) do
        table.insert(list, item)
    end
end

local function extreme(list, predicate, extremeFn)
    local result
    if #list == 0 then
        result = nil
    else
        local extremeIndex = 1
        for index, item in ipairs(list) do
            if extremeFn(predicate(item), predicate(list[extremeIndex])) then
                extremeIndex = index
            end
        end
        result = list[extremeIndex]
    end
    return result
end

local function smallerThan(a, b)
    return a < b
end

local function min(list, predicate)
    return extreme(list, predicate, smallerThan)
end

local function greaterThan(a, b)
    return a > b
end

local function max(list, predicate)
    return extreme(list, predicate, greaterThan)
end

local function maxCompare(list, compare)
    local result
    if #list == 0 then
        result = nil
    else
        local maxIndex = 1
        for index, item in ipairs(list) do
            if compare(item, list[maxIndex]) then
                maxIndex = index
            end
        end
        result = list[maxIndex]
    end
    return result
end

local function count(list, predicate)
    return #filter(list, predicate)
end

local function any(list, predicate)
    for _, item in ipairs(list) do
        if predicate(item) then
            return true
        end
    end
    return false
end

local function groupBy(list, predicate)
    local groups = {}
    for _, value in ipairs(list) do
        local key = predicate(value)
        if not groups[key] then
            groups[key] = {}
        end
        table.insert(groups[key], value)
    end
    return groups
end

local function pickWhile(list, condition)
    local picks = {}
    local index = 1
    while index <= #list and condition(picks, list[index]) do
        table.insert(picks, list[index])
        index = index + 1
    end
    return picks
end

local function slice(list, startIndex, length)
    if length == nil then
        length = #list - startIndex + 1
    end
    local endIndex = startIndex + length - 1
    local result = {}
    for index = startIndex, endIndex do
        table.insert(result, list[index])
    end
    return result
end

local function unique(list)
    local inList = {}
    local result = {}
    for _, item in ipairs(list) do
        if not inList[item] then
            inList[item] = true
            table.insert(result, item)
        end
    end
    return result
end

Array = {
    filter = filter,
    find = find,
    includes = includes,
    map = map,
    reduce = reduce,
    all = all,
    copy = copy,
    concat = concat,
    append = append,
    extreme = extreme,
    min = min,
    max = max,
    maxCompare = maxCompare,
    findIndex = findIndex,
    indexOf = indexOf,
    count = count,
    any = any,
    groupBy = groupBy,
    pickWhile = pickWhile,
    slice = slice,
    unique = unique
}

local addOnName = 'Array'
local version = '1.0.0'

if _G.Library and not Library.isRegistered(addOnName, version) then
  local Function = Library.retrieve('Function', '^1.0.0')
    local Object = Library.retrieve('Object', '^1.0.0')
    local Float = Library.retrieve('Float', '^1.0.0')
    local Boolean = Library.retrieve('Boolean', '^1.0.0')

  --- @class Array
  local Array = {}

  function Array.create(table)
    local array
    if table then
      array = Array.copy(table)
    else
      array = {}
    end
    setmetatable(array, { __index = Array })
    return array
  end

  function Array.length(list)
    local length = 0
    for key in pairs(list) do
      if type(key) == 'number' and key > length then
        length = key
      end
    end
    return length
  end

  function Array.filter(list, predicate)
    local result = Array.create()
    for index = 1, Array.length(list) do
      local item = list[index]
      if predicate(item) then
        table.insert(result, item)
      end
    end
    return result
  end

  function Array.findIndex(list, predicate)
    for index = 1, Array.length(list) do
      local item = list[index]
      if predicate(item) then
        return index
      end
    end
    return -1
  end

  local function seemsEqual(a, b)
    if type(a) == 'number' and type(b) == 'number' then
      return Float.seemsCloseBy(a, b)
    else
      return a == b
    end
  end

  function Array.indexOf(list, value)
    return Array.findIndex(list, function(b)
      return seemsEqual(value, b)
    end)
  end

  function Array.find(list, predicate)
    local index = Array.findIndex(list, predicate)
    local result
    if index == -1 then
      result = nil
    else
      result = list[index]
    end
    return result, index
  end

  function Array.includes(list, value)
    return Array.find(list, function(value2)
      return value2 == value
    end) ~= nil
  end

  function Array.map(list, predicate)
    local result = Array.create()
    for index = 1, Array.length(list) do
      local item = list[index]
      result[index] = predicate(item, index)
    end
    return result
  end

  function Array.reduce(list, predicate, initialValue)
    local value
    local initialIndex
    if initialValue == nil then
      value = list[1]
      initialIndex = 2
    else
      value = initialValue
      initialIndex = 1
    end
    for index = initialIndex, Array.length(list) do
      value = predicate(value, list[index], list)
    end
    return value
  end

  function Array.all(list, predicate)
    for index = 1, Array.length(list) do
      local item = list[index]
      if not predicate(item) then
        return false
      end
    end
    return true
  end

  function Array.copy(list)
    local result = Array.create()
    for index = 1, Array.length(list) do
      local item = list[index]
      result[index] = item
    end
    return result
  end

  function Array.concat(...)
    local result = Array.create()
    local lists = { ... }
    for index = 1, Array.length(lists) do
      local list = lists[index]
      for index2 = 1, Array.length(list) do
        local item = list[index2]
        table.insert(result, item)
      end
    end
    return result
  end

  function Array.append(array, listToAppend)
    for index = 1, Array.length(listToAppend) do
      local item = listToAppend[index]
      table.insert(array, item)
    end
    return array
  end

  function Array.extreme(list, predicate, extremeFn)
    predicate = predicate or Function.identity
    local result
    if Array.length(list) == 0 then
      result = nil
    else
      local extremeIndex = 1
      for index = 1, Array.length(list) do
        local item = list[index]
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

  function Array.min(list, predicate)
    return Array.extreme(list, predicate, smallerThan)
  end

  local function greaterThan(a, b)
    return a > b
  end

  function Array.max(list, predicate)
    return Array.extreme(list, predicate, greaterThan)
  end

  function Array.maxCompare(list, compare)
    local result
    if Array.length(list) == 0 then
      result = nil
    else
      local maxIndex = 1
      for index = 1, Array.length(list) do
        local item = list[index]
        if compare(item, list[maxIndex]) then
          maxIndex = index
        end
      end
      result = list[maxIndex]
    end
    return result
  end

  function Array.count(list, predicate)
    return Array.length(Array.filter(list, predicate))
  end

  function Array.any(list, predicate)
    for index = 1, Array.length(list) do
      local item = list[index]
      if predicate(item) then
        return true
      end
    end
    return false
  end

  function Array.groupBy(list, predicate)
    local groups = {}
    for index = 1, Array.length(list) do
      local value = list[index]
      local key = predicate(value)
      if not groups[key] then
        groups[key] = {}
      end
      table.insert(groups[key], value)
    end
    return groups
  end

  function Array.pickWhile(list, condition)
    local picks = {}
    local index = 1
    while index <= Array.length(list) and condition(picks, list[index]) do
      table.insert(picks, list[index])
      index = index + 1
    end
    return picks
  end

  function Array.slice(list, startIndex, length)
    if length == nil then
      length = Array.length(list) - startIndex + 1
    end
    local endIndex = startIndex + length - 1
    local result = Array.create()
    for index = startIndex, endIndex do
      table.insert(result, list[index])
    end
    return result
  end

  function Array.unique(list)
    local inList = {}
    local result = Array.create()
    for index = 1, Array.length(list) do
      local item = list[index]
      if not inList[item] then
        inList[item] = true
        table.insert(result, item)
      end
    end
    return result
  end

  function Array.forEach(list, predicate)
    for index = 1, Array.length(list) do
      local value = list[index]
      predicate(value, index)
    end
    return list
  end

  function Array.equals(listA, listB, predicate)
    predicate = predicate or Function.identity

    local lengthOfListA = Array.length(listA)

    if lengthOfListA ~= Array.length(listB) then
      return false
    end

    local length = lengthOfListA
    for index = 1, length do
      if not seemsEqual(predicate(listA[index]), predicate(listB[index])) then
        return false
      end
    end

    return true
  end

  function Array.flat(list)
    local result = Array.create()
    for index = 1, Array.length(list) do
      local element = list[index]
      if Array.isArray(element) then
        for index = 1, Array.length(element) do
          local element2 = element[index]
          table.insert(result, element2)
        end
      else
        table.insert(result, element)
      end
    end
    return result
  end

  function Array.flatMap(list, predicate)
    return Array.flat(Array.map(list, predicate))
  end

  local function isNumber(value)
    return type(value) == 'number'
  end

  local function areAllKeysNumbers(table)
    return Array.all(Object.keys(table), isNumber)
  end

  function Array.isArray(list)
    return type(list) == 'table' and areAllKeysNumbers(list)
  end

  function Array.isArrayWithSubsequentIndexes(list)
    return Array.isArray(list) and Array.length(list) == #list
  end

  function Array.selectTrue(list)
    return Array.filter(list, Function.isTrue)
  end

  function Array.generateNumbers(from, to, interval)
    local numbers = Array.create()
    for number = from, to, interval do
      table.insert(numbers, number)
    end
    return numbers
  end

  function Array.isTrueForAllInInterval(from, to, interval, predicate)
    local values = Array.generateNumbers(from, to, interval)
    return Array.all(values, predicate)
  end

  function Array.hasElements(array)
    return Boolean.toBoolean(next(array))
  end

  function Array.isEmpty(array)
    return not Array.hasElements(array)
  end

  function Array.remove(array, value)
    local equals = Function.partial(seemsEqual, value)
    local index
    repeat
      index = Array.findIndex(array, equals)
      if index ~= -1 then
        table.remove(array, index)
      end
    until index == -1
    return array
  end

  function Array.removeFirstOccurence(array, value)
    local equals = Function.partial(seemsEqual, value)
    local index = Array.findIndex(array, equals)
    if index ~= -1 then
      table.remove(array, index)
    end
    return array
  end

  Library.register(addOnName, version, Array)
else
  error(addOnName + ' requires Library. It seems absent.')
end

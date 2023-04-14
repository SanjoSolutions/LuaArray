# Lua Array

This work is devoted to God.

A library of functions for arrays which can be used by other add-ons to save some development work.

Most functions are similar to the functions for arrays which are provided by JavaScript.

Please check out the source code for details regarding the function parameters.

**The functions include:**

* **Array.length**: a function for determining the length of an array in a way that supports "gaps" in arrays.
* **Array.filter**: a function for filtering an array.
* **Array.findIndex**: a function for finding an index of an array element whose value meets certain conditions.
* **Array.indexOf**: a function for finding the index of a value in an array.
* **Array.find**: a function for finding an element in an array which meets certain conditions.
* **Array.includes**: a function for checking if an array includes a specific value.
* **Array.map**: a function for mapping all values of an array to other values.
* **Array.reduce**: a function to aggregate the values of an array to one value.
* **Array.all**: a function to check if all elements in an array meet certain conditions.
* **Array.copy**: a function to copy an array.
* **Array.concat**: a function to concat multiple arrays.
* **Array.append**: a function to append the elements of an array to another array.
* **Array.extreme**: a function to find the most "extreme" value in an array based on an "extreme" function which tells the function if a value is more "extreme" than another.
* **Array.min**: a function which returns the minimum value.
* **Array.max**: a function which returns the maximum value.
* **Array.maxCompare**: a function which returns the maximum value and supports a custom compare function.
* **Array.count**: a function which counts the number of elements which meet certain conditions.
* **Array.any**: a function which returns true when any of the elements of an array meet certain conditions.
* **Array.groupBy**: a function to group the elements of an array.
* **Array.pickWhile**: a function to pick elements as long as the current element meets certain conditions.
* **Array.slice**: a function that can create a new array which is a "slice" of another array.
* **Array.unique**: a function which removes duplicates in an array. Therefore creates an array where the elements are unique in the array (occur only once).
* **Array.forEach**: a function for doing something for each element in an array.
* **Array.equals**: a function for checking if two array are equal.
* **Array.flat**: a function for flattening an array one level.
* **Array.flatMap**: a functions for first mapping the elements of an array and then flattening the resulting array.
* **Array.isArray**: a function for checking if a table is an array.
* **Array.isArrayWithSubsequentIndexes**: a function for checking if a list is an array with subsequent indexes.
* **Array.selectTrue**: a function which returns a new array which only includes elements of the passed array which evaluated as "truthy".
* **Array.generateNumbers**: a function for generating an array with subsequent numbers.
* **Array.isTrueForAllInInterval**: a function which checks if a predicate is true for a set of numbers (specified via from, to and interval).
* **Array.hasElements**: an array which checks if an array has any elements (one or more).
* **Array.isEmpty**: a function which checks if an array is empty (has zero elements).
* **Array.remove**: a function for removing all elements of an array which equal a given value.
* **Array.removeFirstOccurence**: a function for removing the first element of an array which equals a given value.
* **Array.create**: a function for creating an array. This array has all the array functions on its metatable.

## Usage

### Embedding

#### Introduction

With this approach, the library is included as part of the add-on. A benefit to the add-on user is, that only
the add-on appears in the add-on list. So it can be easier to enable or disable an add-on and its library dependencies
compared to an approach where the libraries are included as add-ons (in this case each library shows as an add-on in the add-ons list and the user potentially is required to tick multiple checkboxes to enable or disable an add-on and its library dependencies).

#### How to do it

This library registers itself via the library "[Library](https://github.com/SanjoSolutions/LuaLibrary)". With this approach it is avoided to create another global (with its theoretical potential that other add-ons already use the same global). And "Library" also handles when multiple add-ons load the same library, potentially different versions of it.
To embed it, also include "[Library](https://github.com/SanjoSolutions/LuaLibrary)" as a dependency to your add-on.

In our example, we have installed both "Library", "Array" and the dependencies of "Array" ("Boolean", "Set", "Object", "Function", "Float") inside the "libs" folder inside the add-on folder.

In your add-ons TOC file add (to load "Library" and "Array" and its dependencies):

```
libs/Library/Library.xml
libs/Boolean/Boolean.xml
libs/Set/Set.xml
libs/Object/Object.xml
libs/Function/Function.xml
libs/Float/Float.xml
libs/Array/Array.xml
```

It's recommended to load the library files first, so that the libraries are available in the other Lua files.

In your Lua file(s), you can access the library via:

```lua
local Array = Library.retrieve('Array', '^1.0.0')
```

### As add-on

This library can also just be put directly in the AddOns folder. In this case the library is available via the global `Array`.

If you develop an add-on and do this approach, you can just include this library in your release as a folder next to your add-ons folder.

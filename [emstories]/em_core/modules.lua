Extends = function(baseClass)

    local newClass = {}
  
    local classMt  = {
      __index = newClass,
    }
  
    function newClass:create(...)
  
      local newInst = {}
  
      setmetatable(newInst, classMt)
  
      local override
  
      if type(newClass.constructor) == 'function' then
        override = newInst:constructor(...)
      end
  
      if override ~= nil then
        return override
      else
        return newInst
      end
  
    end
  
    if baseClass ~= nil then
  
      setmetatable(newClass, {
  
        __index = function(t, k)
  
          if k == 'super' then
            return baseClass
          else
            return baseClass[k]
          end
  
        end
  
      })
  
    end
  
    -- Implementation of additional OO properties starts here --
  
    -- Return the class object of the instance
    function newClass:type()
      return newClass
    end
  
    -- Return the prototype the instance
    function newClass:prototype()
      return baseClass
    end
  
    -- Return true if the caller is an instance of theClass
    function newClass:instanceOf(theClass)
  
      local isInstanceOf = false
  
      local curClass = newClass
  
      while (curClass ~= nil) and (not isInstanceOf) do
        if curClass == theClass then
          isInstanceOf = true
        else
          curClass = curClass:prototype()
        end
      end
  
      return isInstanceOf
  
    end
  
    return newClass
  
  end
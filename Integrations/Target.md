### for target scripts follow here

# QB-Target [LINK](https://github.com/qbcore-framework/qb-target)

 - go to `qb-target/init.lua` and find function `Gangcheck` and replace with this
```lua
 GangCheck = function(gang)
    local mygang = exports['sayer-gangs']:GetGang()
	if type(gang) == 'table' then
		gang = gang[mygang.name]
		if gang and mygang.grade.level >= gang then
			return true
		end
	elseif gang == 'all' or gang == mygang.name then
		return true
	end
	return false
end
```


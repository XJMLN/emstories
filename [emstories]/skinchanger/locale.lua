Locales = {}

function _(str, ...) -- Translate string

	if Locales['pl'] ~= nil then

		if Locales['pl'][str] ~= nil then
			return string.format(Locales['pl'][str], ...)
		else
			return 'Translation [' .. 'pl' .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. 'pl' .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end

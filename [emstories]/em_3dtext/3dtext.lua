

function Draw3DText(x, y, z, text, dist,scaled)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * scaled
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen and distance < 10 then
    SetTextScale(scale, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    end
end


function DrawDialogueText(text,time)
    --ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function DrawBigNotification(text)
    AddTextEntry("VehiclePlateData",text)
    BeginTextCommandThefeedPost("VehiclePlateData")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true,true)
end

function DrawHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(false,true,true,-1)
end
function DrawNotification(title,subtitle,text,onlyText,iconName,iconType,flash)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)

    if (onlyText) then 
        EndTextCommandThefeedPostTicker(true,true)
    else
        EndTextCommandThefeedPostMessagetext(iconName,iconName, flash, iconType, title, subtitle)
    end
end

function Draw2DText(settings)

	settings = settings or {}
	local text = settings.text or "Text"
	local font = settings.font or 1
	local x = settings.x or 0
	local y = settings.y or 0
	local scale = settings.scale or 1.0
	local red = settings.red or 255
	local green = settings.green or 255
	local blue = settings.blue or 255
	local alpha = settings.alpha or 255
	local startWrap = settings.startWrap or 0.0
	local endWrap = settings.endWrap or 1.0
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(red, green, blue, alpha)
	SetTextWrap(startWrap, endWrap)
	if settings.center == true then
		SetTextCentre(true)
	end
	if settings.right == true then
		SetTextJustification(2)
	end
    if (settings.outline) then 
        SetTextOutline()
    end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)

end

exports("Draw2DText",Draw2DText)
exports("DrawHelp",DrawHelp)
RegisterNetEvent("3dtext:DrawDialogue")
RegisterNetEvent('3dtext:DrawBigNotification')
AddEventHandler("3dtext:DrawBigNotification",DrawBigNotification)
AddEventHandler("3dtext:DrawDialogue",DrawDialogueText)
RegisterNetEvent("3dtext:DrawNotification")
AddEventHandler("3dtext:DrawNotification",DrawNotification)
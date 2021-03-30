CONFIG = {
    url = "https://discord.com/api/webhooks/826390930415943681/IA1MVMJN5m4HSOOIaMijRK8fYO0sfpMSYDK86ymYjetHF-YRnI00zAbKHjqnPlKmSpNJ",
    avatar = "https://cdn.discordapp.com/icons/796790923114971166/72f809bf23126aabbadc52412ff18010.png",
    nick = "Emergency Stories",
}

function discord_sendRestartMessage()
    local date = os.date('*t')
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local DateString = date.day .. '/' .. date.month .. '/' .. date.year .. ' - ' .. date.hour .. ':' .. date.min
    local embed = {
        {
            ["color"]= 1127128,
            ["title"]="Status serwera",
            ["description"]="Serwer jest w trakcie restartowania.",
            ["footer"]={
                ["text"]=DateString,
            }

        }
    }
    PerformHttpRequest(CONFIG.url, function(err, text, headers) end, 'POST',
    json.encode({username = CONFIG.nick, embeds = embed, avatar_url = CONFIG.avatar}),
    { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("discordHook:sendLevelMsg")
AddEventHandler("discordHook:sendLevelMsg",function(lowLevel,hLevel,XP)
    local embed = {
        {
            ["color"]= 1127128,
            ["title"]="[EVENT WATCH | AC] Awans na kolejny poziom",
            ["description"]=GetPlayerName(source).." - poprzedni poziom: "..lowLevel..", aktualny poziom: "..hLevel.." [XP: "..XP.."]",
        }
    }
    PerformHttpRequest(CONFIG.url, function(err, text, headers) end, 'POST',
    json.encode({username = CONFIG.nick, embeds = embed, avatar_url = CONFIG.avatar}),
    { ['Content-Type'] = 'application/json' })
end)
exports('discord_sendRestartMessage',discord_sendRestartMessage)

function discord_onDutyMessage(playerName, callsign, departmentName, departmentID)
    local embed = {
        {
            ["color"]=9488236,
            ["author"]={
                ["name"]= departmentName,
                ['icon_url']="https://emergencystories.pl/images/logos/department-"..departmentID..".png"
            },
            ["description"]="`"..callsign.."` rozpoczyna służbę.",
        }
    }
    PerformHttpRequest(CONFIG.url,function(err,text,headers) end, 'POST',
    json.encode({username = CONFIG.nick, embeds = embed, avatar_url = CONFIG.avatar}),{
        ['Content-Type'] = 'application/json'
    })
end
exports("onDutyMessage",discord_onDutyMessage)
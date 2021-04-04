CONFIG = {
    url = "https://discord.com/api/webhooks/826390930415943681/IA1MVMJN5m4HSOOIaMijRK8fYO0sfpMSYDK86ymYjetHF-YRnI00zAbKHjqnPlKmSpNJ",
    urlAdmin = "https://discord.com/api/webhooks/828348661091139604/5ol2_LbNDmfEsy1MQOCMVdxsb6IAQptWMWXhaX9eMsu8eh5VVrZOzsNp4iufCsafYRSU",
    avatar = "https://cdn.discordapp.com/icons/796790923114971166/72f809bf23126aabbadc52412ff18010.png",
    nick = "Emergency Stories",
}

local departmentNames = {
    [1]="Los Santos Fire Department",
    [2]="Los Santos Medical Center",
    [3]="Sandy Shores Medical Center",
    [4]="Paleto Bay Medical Center",
    [5]="Los Santos Police Department",
    [6]="Blaine County Police Department",
    [7]="San Andreas Highway Patrol"
}

function discord_onXPAdd(message)
    local message = message
    local embed = {
        {
            ['color']=9488236,
            ['author']={
                ['name']=CONFIG.nick,
                ['icon_url']=CONFIG.avatar,
            },
            ['description']=message,
        }
    }
    PerformHttpRequest(CONFIG.urlAdmin,function(err,text,headers) end, 'POST',
    json.encode({username = CONFIG.nick, embeds = embed, avatar_url = CONFIG.avatar}),{
        ['Content-Type'] = 'application/json'
    })
end

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

function discord_acceptCallout(factionID,departmentID,callsign,missionData)
    local missionTitle = missionData.title
    local departmentName = departmentNames[departmentID]
    local embed = {
        {
            ["color"]=39423,
            ["author"]={
                ["name"]= departmentName,
                ["icon_url"]="https://emergencystories.pl/images/logos/department-"..departmentID..".png"
            },
            ["description"]="`"..callsign.."` odpowiada na zgłoszenie *"..missionTitle.."*."
        }
    }
    PerformHttpRequest(CONFIG.url,function(err,text,headers) end, 'POST',
    json.encode({username = CONFIG.nick, embeds = embed, avatar_url = CONFIG.avatar}),{
        ['Content-Type'] = 'application/json'
    })
end
exports("onDispatchAccept",discord_acceptCallout)
exports("onDutyMessage",discord_onDutyMessage)
exports("onXPAdd",discord_onXPAdd)
exports('discord_sendRestartMessage',discord_sendRestartMessage)
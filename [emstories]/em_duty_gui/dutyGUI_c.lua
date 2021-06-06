local isWindowOpen = false
local playerData = nil
local calloutCooldown = false
MENUS = {}
MENUS.main = RageUI.CreateMenu("Służba","Wybierz opcje")
MENUS.dispatch = RageUI.CreateSubMenu(MENUS.main,"Centrala","Wybierz opcje")
MENUS.callouts = RageUI.CreateSubMenu(MENUS.main,"Wezwania","Wybierz opcje")
MENUS.main:DisplayGlare(false)
MENUS.dispatch:DisplayGlare(false)
MENUS.callouts:DisplayGlare(false)
MENUS.callouts.EnableMouse = true
MENUS.dispatch.EnableMouse = true

MENUS.main.EnableMouse = true
MENUS.main.Closed = function() -- @todo: przerobic na funkcje ktora resetuje menusVariables
    isWindowOpen = false
    playerData = nil
end

local menusVariables = {
    dispatch = {
        [1]={label="Wezwij lawetę",desc="Wezwij lawetę na miejsce w którym przebywasz",called=false, calledLabel="~r~Anuluj lawetę", calledDesc="Anuluj wezwanie lawety",showedLabel="Wezwij lawetę", showedDesc="Wezwij lawetę na miejsce w którym przebywasz"},
        [2]={label="Wezwij ambulans",desc="Wezwij ambulans na miejsce w którym przebywasz",called=false, calledLabel="~r~Anuluj ambulans", calledDesc="Anuluj wezwanie ambulansu",showedLabel="Wezwij ambulans", showedDesc="Wezwij ambulans na miejsce w którym przebywasz"},
        [3]={label="Wezwij koronera",desc="Wezwij koronera na miejsce w którym przebywasz",called=false, calledLabel="~r~Anuluj koronera", calledDesc="Anuluj wezwanie koronera",showedLabel="Wezwij koronera", showedDesc="Wezwij koronera na miejsce w którym przebywasz"},
        [4]={label="Wezwij hycla",desc="Wezwij hycla na miejsce w którym przebywasz",called=false, calledLabel="~r~Anuluj hycla", calledDesc="Anuluj wezwanie hycla",showedLabel="Wezwij hycla", showedDesc="Wezwij hycla na miejsce w którym przebywasz"},
    },
    callouts = {
        [1]={
            ["Inne"]={
                {label="Rowerzysta na autostradzie",id=3},
                {label="Pojazd na wstecznym",id=1},
            },
            ['Konwoje']={
                {label="Eskorta pojazdu",id=2},
            }
        },
        [2]={
            ['Upadki']={
                {label="Upadek w metrze",id=1},
                {label="Upadek z schodów",id=2},
            },
            ['Transport']={
                {label="Transport krwi",id=3}
            }
        },
        [3]={
            ['Pożary']={
                {label="Pożar burdelu",id=1},
                {label="Pożar transformatora",id=2},
                {label="Pożar składowiska",id=3},
                {label="Pożar domu",id=4},
                {label="Pożar przytułka dla bezdomnych",id=5},
                {label="Pożar złomowiska",id=6},
                {label="Pożar doków",id=7},
                {label="Pożar lasu",id=8}
            },
            ['Wypadki']={
                {label="Uderzenie w słup energetyczny",id=9}
            }

        }
    }
}

function duty_gui_cancelService(serviceID)
    local item = menusVariables['dispatch'][serviceID]
    item.showedLabel = item.label
    item.showedDesc = item.desc
    item.called = false
end

function duty_gui_cooldown()
    calloutCooldown = true
    Citizen.CreateThread(function()
        Citizen.Wait(300000)
        calloutCooldown = false
        exports.em_gui:showNotification("Informacja","Możesz ponownie wygenerować wezwanie.",9000)
    end)
end
Citizen.CreateThread(function()
    while true do
        if (isWindowOpen) then
            RageUI.IsVisible(MENUS.main, function()
                RageUI.Button("Wezwania","Wygeneruj wezwanie",{RightLabel = ">>>"},true,{},MENUS.callouts)
                RageUI.Button("Centrala","Wezwij wsparcie",{RightLabel = ">>>"},true,{},MENUS.dispatch)
                if (LocalPlayer.state.onCallout) then
                    RageUI.Button("Przerwij wezwanie","Przerwij wezwanie",{RightBadge= RageUI.BadgeStyle.Alert, Color ={BackgroundColor={212, 71, 53}, HighLightColor={235, 101, 84}}}, true, {
                        onSelected = function()
                            exports.em_fd_callouts:accident_fd_cancel()
                            exports.em_fd_callouts:fireCallout_cancel()
                            exports.em_mc_callouts:mcCallout_cancel()
                            RageUI.Visible(MENUS['main'],false)
                        end
                    })
                end
                RageUI.Button("Zakończ służbę","Zakończ służbę",{RightBadge= RageUI.BadgeStyle.Alert, Color ={BackgroundColor={212, 71, 53}, HighLightColor={235, 101, 84}}}, true, {
                    onSelected = function()
                        exports.em_duty:playerEndDuty()
                        TriggerServerEvent("em_duty_gui:endDuty")
                        RageUI.Visible(MENUS['main'],false)
                    end
                })
            end)

            --
            --  Dispatch Menu
            --
            RageUI.IsVisible(MENUS.dispatch, function()
                for i,v in ipairs(menusVariables['dispatch']) do
                    RageUI.Button(v.showedLabel,v.showedDesc,{},true,{
                        onSelected = function()
                            if (v.called) then
                                v.showedLabel = v.label
                                v.showedDesc = v.desc
                                v.called = false
                                ai_services_cancel(i)
                                duty_gui_cancelService(i)
                                return
                            else
                                v.showedLabel = v.calledLabel
                                v.showedDesc = v.calledDesc
                                v.called = true
                                ai_services_init(i)
                                return
                            end
                        end
                    })
                end
            end)

            RageUI.IsVisible(MENUS.callouts, function()
                for i,v in pairs(menusVariables['callouts'][LocalPlayer.state.factionID]) do
                    RageUI.Separator(i)
                    
                    for _,k in pairs(menusVariables['callouts'][LocalPlayer.state.factionID][i]) do
                        RageUI.Button(k.label,"Generuj wezwanie",{},true,{
                            onSelected = function()
                                duty_spawnCallout(k.id)
                            end
                        })
                    end
                end
            end)
        end
        Citizen.Wait(1.0)
    end
end)
function duty_renderGUI(data)
    playerData = data
    isWindowOpen = true
    RageUI.Visible(MENUS['main'],true)
end

function duty_spawnCallout(ID)
    if (calloutCooldown) then
        exports.em_3dtext:DrawNotification("System","System","~r~Musisz odczekać przed ponownym wygenerowaniem wezwania.",true)
        return
    end
    TriggerServerEvent("callouts_checkCallout",ID,LocalPlayer.state.factionID)
end

function duty_calloutCallback(state,ID)
    if (not state) then return end
    duty_gui_cooldown()
    isWindowOpen = false
    RageUI.Visible(MENUS['main'],false)
    RageUI.Visible(MENUS['dispatch'],false)
    RageUI.Visible(MENUS['callouts'],false)
    local fid = LocalPlayer.state.factionID
    TriggerServerEvent("callouts_request",ID,fid)
end
function duty_onKeyPress()
    if (not isWindowOpen) then
        TriggerServerEvent("em_duty_gui:checkPlayerFaction")
    else
        isWindowOpen = false
        RageUI.Visible(MENUS['main'],false)
        RageUI.Visible(MENUS['dispatch'],false)
        RageUI.Visible(MENUS['callouts'],false)
    end
end


RegisterNetEvent("em_duty_gui:showGUI")
RegisterNetEvent("em_duty_gui:returnCalloutState")
AddEventHandler("em_duty_gui:returnCalloutState",duty_calloutCallback)
AddEventHandler("em_duty_gui:showGUI",duty_renderGUI)
RegisterCommand("dutygui",duty_onKeyPress)
RegisterKeyMapping("dutygui","Menu Służby","keyboard","f1")
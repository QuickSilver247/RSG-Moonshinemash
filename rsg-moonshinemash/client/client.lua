local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local moonshinemashkit = 0
isLoggedIn = false
PlayerJob = {}

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = RSGCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('RSGCore:Client:OnJobUpdate')
AddEventHandler('RSGCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end
----------------------------------------

-- setup moonshine mash kit
RegisterNetEvent('rsg-moonshinemash:client:moonshinemashkit')
AddEventHandler('rsg-moonshinemash:client:moonshinemashkit', function(itemName) 
    if moonshinemashkit ~= 0 then
        SetEntityAsMissionEntity(moonshinekit)
        DeleteObject(moonshinemashkit)
        moonshinemashkit = 0
    else
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
        Wait(10000)
        ClearPedTasks(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
        --local pos = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55)
        --local modelHash = `p_barrelhalf04x`
        local modelHash = GetHashKey(Config.Prop)
        if not HasModelLoaded(modelHash) then
            -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(1)
            end
        end
        local prop = CreateObject(modelHash, pos, true)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop)
        PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
        moonshinemashkit = prop
    end
end, false)

-- create moonshine mash kit / destroy(police only)
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        local moonshineObject = GetClosestObjectOfType(pos, 5.0, GetHashKey(Config.Prop), false, false, false)
        if moonshineObject ~= 0 and PlayerJob.name ~= Config.LawJobName then
            local objectPos = GetEntityCoords(moonshineObject)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, Lang:t('menu.mix'))
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    TriggerEvent('rsg-moonshinemash:client:craftmenu')
                end
            end
        else
            local objectPos = GetEntityCoords(moonshineObject)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, Lang:t('menu.destroy'))
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    local player = PlayerPedId()
                    TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
                    Wait(5000)
                    ClearPedTasks(player)
                    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
                    DeleteObject(moonshineObject)
                    PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
                    RSGCore.Functions.Notify(Lang:t('primary.mash_barrel_destroyed'), 'primary')
                end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
end)

-- mash menu
RegisterNetEvent('rsg-moonshinemash:client:craftmenu', function(data)
    exports['rsg-menu']:openMenu({
        {
            header = Lang:t('menu.mash'),
            isMenuHeader = true,
        },
        {
            header = Lang:t('menu.mix_mash'),
            txt = Lang:t('text.xwheat_10xwater_10xcorn_and_5xginseng'),
            params = {
                event = 'rsg-moonshinemash:client:moonshinemash',
                isServer = false,
            }
        },
        {
            header = Lang:t('menu.close_menu'),
            txt = '',
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
end)

function HasRequirements(requirements)
    local found_requirements = {}
    local count = 0
    local missing = {}
    for i, require in ipairs(requirements) do
        if RSGCore.Functions.HasItem(require) then
            found_requirements[#found_requirements + 1] = require
            count = count + 1
        else
            missing[#missing + 1] = require
        end
    end

    if count == #requirements then
        return true
    elseif count == 0 then
        RSGCore.Functions.Notify("You are missing all of the requirements: " .. table.concat(missing, ", "), 'error')
        return false
    else
        RSGCore.Functions.Notify("You are missing the following requirements: " .. table.concat(missing, ", "), 'error')
        return false
    end
end

-- make moonshine mash
RegisterNetEvent("rsg-moonshinemash:client:moonshinemash")
AddEventHandler("rsg-moonshinemash:client:moonshinemash", function()
    if isBusy then
        return
    else
        local hasItems = HasRequirements({'wheat','corn','water','ginseng'})
        if hasItems then
            isBusy = not isBusy
            local player = PlayerPedId()
		    TaskStartScenarioInPlace(player, GetHashKey('0x93E8BE15'), 15000, true, false, false, false)
            ClearPedTasks(ped)
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            TriggerServerEvent('rsg-moonshinemash:server:givemoonshinemash', 1)
            PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
           isBusy = not isBusy
       else
           RSGCore.Functions.Notify(Lang:t('error.you_dont_have_the_ingredients_to_make_this'), 'error')
       end
    end
end)
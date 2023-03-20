local RSGCore = exports['rsg-core']:GetCoreObject()

-- use moonshine mash kit
RSGCore.Functions.CreateUseableItem("moonshinemashkit", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('rsg-moonshinemash:client:moonshinemashkit', source, item.name)
    end
end)
----------------------------------------

-- mix moonshine mash
RegisterServerEvent('rsg-moonshinemash:server:givemoonshinemash')
AddEventHandler('rsg-moonshinemash:server:givemoonshinemash', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if amount == 1 then
        Player.Functions.RemoveItem('wheat', 10)
        Player.Functions.RemoveItem('corn', 10)
        Player.Functions.RemoveItem('water', 10)
		Player.Functions.RemoveItem('ginseng', 5)
        Player.Functions.AddItem('moonshinemash', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['moonshinemash'], "add")
        RSGCore.Functions.Notify(src, Lang:t('success.you_made_some_moonshine_mash'), 'success')
    else
        RSGCore.Functions.Notify(src, Lang:t('error.something_went_wrong'), 'error')
        print('something went wrong with moonshinemash script could be exploit!')
    end
end)
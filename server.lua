local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('npc_head_system:getNPCData', function(source, cb, npcId)
    MySQL.Async.fetchAll('SELECT * FROM npc_head_system WHERE npc_id = @npc_id', {
        ['@npc_id'] = npcId
    }, function(result)
        if result[1] then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('npc_head_system:attackNPC')
AddEventHandler('npc_head_system:attackNPC', function(npc)
    local xPlayer = ESX.GetPlayerFromId(source)
    local npcId = NetworkGetNetworkIdFromEntity(npc)

    MySQL.Async.execute('INSERT INTO npc_head_system (player_id, npc_id, attack_count) VALUES (@player_id, @npc_id, 1) ON DUPLICATE KEY UPDATE attack_count = attack_count + 1', {
        ['@player_id'] = xPlayer.identifier,
        ['@npc_id'] = npcId
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print('NPC attack recorded for player ' .. xPlayer.identifier)
        end
    end)
end)
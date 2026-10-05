local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    for _, npcConfig in ipairs(Config.NPCs) do
        RequestModel(GetHashKey(npcConfig.model))
        while not HasModelLoaded(GetHashKey(npcConfig.model)) do
            Citizen.Wait(0)
        end

        local npc = CreatePed(4, GetHashKey(npcConfig.model), npcConfig.coords.x, npcConfig.coords.y, npcConfig.coords.z, npcConfig.heading, false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedCombatAttributes(npc, 46, true)
        SetPedSeeingRange(npc, 10.0)
        SetPedHearingRange(npc, 10.0)
        SetPedAlertness(npc, 3)
        SetPedKeepTask(npc, true)

        if npcConfig.greenHead then
            SetPedHeadBlendData(npc, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, true)
            SetPedHeadOverlayColor(npc, 1, 1, 0, 0)
        end

        TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, npcConfig in ipairs(Config.NPCs) do
            local npc = GetClosestPed(playerCoords.x, playerCoords.y, playerCoords.z, 2.0, 1, 0, 0, 0, -1)
            if npc ~= 0 and IsPedAPlayer(npc) == false then
                local npcCoords = GetEntityCoords(npc)
                local distance = #(playerCoords - npcCoords)

                if distance < 2.0 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to attack the NPC')

                    if IsControlJustPressed(0, Config.AttackButton) then
                        RequestAnimDict(npcConfig.attackAnimDict)
                        while not HasAnimDictLoaded(npcConfig.attackAnimDict) do
                            Citizen.Wait(0)
                        end

                        TaskPlayAnim(npc, npcConfig.attackAnimDict, npcConfig.attackAnimName, 8.0, -8.0, -1, 0, 0, false, false, false)
                        TriggerServerEvent('npc_head_system:attackNPC', npc)
                    end
                end
            end
        end
    end
end)
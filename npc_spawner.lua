-- Spawn NPCs at configured locations
CreateThread(function()
    for k, v in pairs(Config.Locations) do
        if v.enabled and v.useNPC then
            RequestModel(v.npcModel)
            while not HasModelLoaded(v.npcModel) do Wait(10) end

            local ped = CreatePed(0, v.npcModel, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
        end
    end
end)
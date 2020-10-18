local Playtime = 0

CreateThread(function()
    SetNuiFocus(false, false)
    while (true) do
        if (IsControlJustPressed(0, Config.ToggleKey)) then
            SendNUIMessage({Action = "Show", Toggle = true})
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(true, false)
        elseif (IsControlJustReleased(0, Config.ToggleKey)) then
            SendNUIMessage({Action = "Show", Toggle = false})
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false, false)
        end

        Wait(5)
    end
end)

CreateThread(function()
    while (true) do
        Playtime = Playtime + 1
        SendNUIMessage({Action = "Playtime", Playtime = Playtime})

        Wait(1000)
    end
end)

RegisterNetEvent("getnek-scoreboard:UpdatePlayers")
AddEventHandler("getnek-scoreboard:UpdatePlayers", function(PlayersList)
    SendNUIMessage({Action = "Update", Players = PlayersList})

    Wait(50)
end)
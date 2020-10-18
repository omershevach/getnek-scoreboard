Config.BotToken = ("")

local PlayersList = {}
local Retval

CreateThread(function()
    while true do
        for Index, Player in ipairs(PlayersList) do
            PlayersList[Index] = nil
        end

        for _, PlayerId in ipairs(GetPlayers()) do
            Retval = false

            if (GetPlayerDiscord(PlayerId) ~= nil) then
                PerformHttpRequest("https://discordapp.com/api/guilds/" .. Config.GuildId .. "/members/" .. GetPlayerDiscord(PlayerId), function(Code, Data, Headers)
                    if (Code == 200) then
                        table.insert(PlayersList, {Id = tonumber(PlayerId), Steam = GetPlayerName(PlayerId), Discord = json.decode(Data).user.username .. "#" .. json.decode(Data).user.discriminator, Ping = GetPlayerPing(PlayerId)})
                        Retval = true
                    end
                end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot " .. Config.BotToken})

                while (not Retval) do Wait(150) end
            end
        end

        table.sort(PlayersList, function(A, B) return A.Id < B.Id end)

        TriggerClientEvent("getnek-scoreboard:UpdatePlayers", -1, PlayersList)

		Wait(Config.UpdateInterval * 1000)
	end
end)

function GetPlayerDiscord(PlayerId)
    if (PlayerId ~= nil) then
        local PlayerIdNum = GetNumPlayerIdentifiers(PlayerId)

        for Index = 0, PlayerIdNum do
            local CurrentId = GetPlayerIdentifier(PlayerId, Index)

            if (CurrentId ~= nil) then
                if (string.match(CurrentId, "discord:")) then
                    return GetPlayerIdentifier(PlayerId, Index):gsub("discord:", "")
                end
            end
        end
    end
    
    return nil
end
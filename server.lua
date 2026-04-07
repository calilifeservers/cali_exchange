local QBCore = exports[Config.Framework]:GetCoreObject()

-- Player initiates marked bills exchange
RegisterServerEvent("markedbills:tryExchange", function(locationKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cfg = Config.Locations[locationKey]

    if not cfg or not cfg.enabled then return end

    -- Optional whitelist enforcement
    if cfg.useWhitelist and not ValidateID(Player.PlayerData.citizenid, cfg.citizenidWhitelist) then
        TriggerClientEvent('QBCore:Notify', src, "You're not authorized to use this exchange.", "error")
        return
    end

    local item = GetInventoryItem(Player, "markedbills")
    if not item or item.amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "No marked bills found.", "error")
        return
    end

    local worth = 0
    if cfg.useMetadata then
        -- Validate metadata bundle
        if not item.info or not item.info.worth then
            TriggerClientEvent('QBCore:Notify', src, "Invalid marked bills data.", "error")
            return
        end
        worth = item.info.worth
    else
        -- Fallback: assume each bill is $1000 flat
        worth = item.amount * 1
    end

    TriggerClientEvent("markedbills:startExchange", src, worth, locationKey)
end)

-- Final transaction: payout and removal
RegisterServerEvent("markedbills:completeExchange", function(worth, locationKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local cfg = Config.Locations[locationKey]
    local finalCash = worth

    -- Apply exchange fee
    if Config.ExchangeFee.Type == "percent" then
        finalCash = math.floor(worth * ((100 - Config.ExchangeFee.Value) / 100))
    else
        finalCash = worth - Config.ExchangeFee.Value
    end

    -- Remove appropriate quantity of marked bills
    if cfg.useMetadata then
        RemoveItem(Player, "markedbills", 1)
    else
        local count = math.floor(worth / 1)
        RemoveItem(Player, "markedbills", count)
    end

    -- Give clean money
    AddCash(Player, finalCash)

    -- Notify player
    TriggerClientEvent('QBCore:Notify', src,
        ("Exchange complete! Fee: $%s | Received: $%s")
        :format((worth - finalCash), finalCash), "success"
    )

    -- Log to Discord
    SendToDiscord(locationKey,
        "🧾 Marked Bills Exchanged",
        ("Player: **%s**\nCitizenID: `%s`\nLaundered: `$%d`\nPayout: `$%d`\nLocation: `%s`")
        :format(Player.PlayerData.name, Player.PlayerData.citizenid, worth, finalCash, locationKey)
    )
end)
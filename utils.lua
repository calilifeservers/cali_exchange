-- Retrieves the markedbills item from the player
function GetInventoryItem(Player, item)
    return Player.Functions.GetItemByName(item)
end

-- Removes a specified number of markedbills from player (usually 1 bundle)
function RemoveItem(Player, item, count)
    Player.Functions.RemoveItem(item, count)
end

-- Adds clean cash to player's wallet
function AddCash(Player, amount)
    Player.Functions.AddMoney("cash", amount)
end

-- Checks whether the player's citizenid is on the whitelist
function ValidateID(cid, whitelist)
    for _, id in pairs(whitelist) do
        if cid == id then return true end
    end
    return false
end

-- Sends a Discord embed to the specified exchange location's webhook
function SendToDiscord(locationKey, title, description)
    local cfg = Config.Webhooks[locationKey]
    if not cfg or not cfg.Enabled or not cfg.URL then return end

    local payload = {
        username = cfg.Name or "Marked Bills Logger",
        avatar_url = cfg.Avatar,
        embeds = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = 56108, -- nice green-blue color
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }}
    }

    PerformHttpRequest(cfg.URL, function(err, text, headers) end, "POST", json.encode(payload), {
        ["Content-Type"] = "application/json"
    })
end
local QBCore = exports[Config.Framework]:GetCoreObject()

-- Register interactive QBTarget zones for enabled exchange points
for name, v in pairs(Config.Locations) do
    if v.enabled then
        exports['qb-target']:AddBoxZone(name, vector3(v.coords.x, v.coords.y, v.coords.z), 1.2, 1.2, {
            name = name,
            heading = v.coords.w,
            debugPoly = false,
            minZ = v.coords.z - 1.0,
            maxZ = v.coords.z + 1.0,
        }, {
            options = {{
                label = "Exchange Marked Bills",
                icon = "fas fa-dollar-sign",
                action = function()
                    TriggerServerEvent("markedbills:tryExchange", name)
                end
            }},
            distance = 2.0
        })
    end
end

-- Event triggered by server when player passes validation
RegisterNetEvent("markedbills:startExchange", function(worth, locationKey)
    local mg = Config.MinigameSettings

    if not mg.Enabled then
        TriggerExchange(worth, locationKey)
        return
    end

    -- ps-ui minigame logic based on config
    if mg.Type == "ps-ui" then
        if mg.Game == "Circle" then
            exports["ps-ui"]:Circle(function(success)
                if success then TriggerExchange(worth, locationKey) end
            end, mg.Attempts, mg.TimePerAttempt)

        elseif mg.Game == "Thermite" then
            exports["ps-ui"]:Thermite(function(success)
                if success then TriggerExchange(worth, locationKey) end
            end, mg.Attempts, mg.TimePerAttempt, 1) -- Last param: grid size/difficulty

        elseif mg.Game == "Scrambler" then
            exports["ps-ui"]:Scrambler(function(success)
                if success then TriggerExchange(worth, locationKey) end
            end, mg.Attempts, mg.TimePerAttempt)

        else
            -- Fallback: skip game
            TriggerExchange(worth, locationKey)
        end
    
    elseif mg.Type == "boii" then
        if mg.Game == "anagram" then
            exports['boii_minigames']:anagram({
                style = 'default', -- Style template
                loading_time = 5000, -- Total time to complete loading sequence in (ms)
                difficulty = mg.Difficulty, -- Game difficulty refer to `const word_lists` in `html/scripts/anagram/anagram.js`
                guesses = 5, -- Amount of guesses until fail
                timer = 30000 -- Time allowed for guessing in (ms)
            }, function(success) -- Game callback
                if success then
                    TriggerExchange(worth, locationKey) end
            end)
        
        elseif mg.Game == "skill_circle" then
            exports['boii_minigames']:skill_circle({
                style = 'default', -- Style template
                icon = 'fa-solid fa-paw', -- Any font-awesome icon; will use template icon if none is provided
                area_size = 4, -- Size of the target area in Math.PI / "value"
                speed = 0.02, -- Speed the target area moves
            }, function(success) -- Game callback
                if success == 'perfect' then
                     TriggerExchange(worth, locationKey)
                elseif success == 'success' then
                     TriggerExchange(worth, locationKey) end
            end)

        elseif mg.Game == "skill_bar" then
            exports['boii_minigames']:skill_bar({
                style = 'default', -- Style template
                icon = 'fa-solid fa-paw', -- Any font-awesome icon; will use template icon if none is provided
                orientation = 2, -- Orientation of the bar; 1 = horizontal centre, 2 = vertical right.
                area_size = 20, -- Size of the target area in %
                perfect_area_size = 5, -- Size of the perfect area in %
                speed = 0.5, -- Speed the target area moves
                moving_icon = true, -- Toggle icon movement; true = icon will move randomly, false = icon will stay in a static position
                icon_speed = 3, -- Speed to move the icon if icon movement enabled; this value is / 100 in the javascript side true value is 0.03
            }, function(success) -- Game callback
                if success == 'perfect' then
                    TriggerExchange(worth, locationKey)
                elseif success == 'success' then
                    TriggerExchange(worth, locationKey) end
            end)
        
        else
            -- Fallback: skip game
            TriggerExchange(worth, locationKey)
        end
    end
end)

-- Handles animation, progress bar, then notifies server
function TriggerExchange(worth, locationKey)
    local anim = Config.ProgressBar.Animations[math.random(#Config.ProgressBar.Animations)]
    RequestAnimDict(anim.dict)
    while not HasAnimDictLoaded(anim.dict) do Wait(10) end

    TaskPlayAnim(PlayerPedId(), anim.dict, anim.anim, 8.0, 8.0, Config.ProgressBar.Time, 1, 0, false, false, false)

    QBCore.Functions.Progressbar("markedbills_exchange", "Exchanging...", Config.ProgressBar.Time, false, true, {}, {}, {}, {}, function()
        -- Notify server of completed progress bar
        TriggerServerEvent("markedbills:completeExchange", worth, locationKey)
    end)
end
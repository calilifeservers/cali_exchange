Config = {
    Framework = "qb-core",
    Inventory = "qb-inventory",

    ExchangeFee = {
        Type = "percent", -- 'percent' or 'fixed'
        Value = 10,
    },

    ProgressBar = {
        Time = 5000,
        Animations = {
            {dict = "amb@prop_human_parking_meter@male@idle_a", anim = "idle_a"},
            {dict = "amb@world_human_smoking@male@male_a@idle_a", anim = "idle_c"},
        }
    },

    MinigameSettings = {
        Enabled = true,
        Type = "boii", -- "ps-ui" or "boii"
        Game = "anagram", -- For ps-ui "Circle" or "Thermite" or "Scrambler" For boii "skill_bar" or "skill_circle" or "anagram"
        Attempts = 3, -- ps-ui setting
        TimePerAttempt = 10, -- ps-ui setting
        Difficulty = 1, -- boii anagram setting
    },

    Locations = {
        ["cayo_perico"] = {
            enabled = true,
            coords = vector4(4506.3, -4550.98, 4.16, 155.85),
            useNPC = true,
            npcModel = "cs_bankman",
            useWhitelist = false,
            citizenidWhitelist = {},
            useMetadata = true, -- ✅ Uses metadata info.worth
        },
        ["farm_exchange"] = {
            enabled = false,
            coords = vector4(2445.51, 4988.56, 46.81, 139.74),
            useNPC = true,
            npcModel = "cs_bankman",
            useWhitelist = true,
            citizenidWhitelist = {"ECL97804", "MZR73472"},
            useMetadata = true, -- ✅ Uses metadata info.worth
        },
        ["alley_trade"] = {
            enabled = false,
            coords = vector4(800.4, -2000.6, 29.2, 180.0),
            useNPC = true,
			npcModel = "cs_bankman",
            useWhitelist = false,
            citizenidWhitelist = {},
            useMetadata = false, -- ✅ Uses quantity * fixed value
        }
    },

    Webhooks = {
        farm_exchange = {
            Enabled = false,
            URL = "https://discord.com/api/webhooks/1393776014068547724/YQFhGCza9Anab1npcZn0Ngw1GjV34JgyuVGHZSX5N75FqsvTnK_6RhAOtm7G1Gapat0k",
            Name = "Farm Exchange Logs",
            Avatar = "https://imgur.com/ZERci2s"
        },
        alley_trade = {
            Enabled = false,
            URL = "https://discord.com/api/webhooks/your_webhook_alley_here",
            Name = "Alley Trade Logs",
            Avatar = "https://i.imgur.com/XGQzaxC.png"
        }
    }
}
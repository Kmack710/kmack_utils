local xpConfig = {
    ['Hacking'] = { --- Label of the Xp/Rep
        xpImage = 'https://cdn-icons-png.flaticon.com/512/6463/6463383.png', -- image for the xp menu
        maxLevel = 10, -- set to whatever the top level will be
        xpPerLevel = 500, -- set to whatever the xp per level will be
        doubleXpReqPerLevel = true, -- double the xp required per level
        notifyOnLevelUp = true, -- notify the player when they level up
        criminal = true, --- to hide this option from jobs in config
        ranks = {
            [0] = 'No Rank',
            [1] = 'Script Kiddie',
            [2] = 'Hacker',
            [3] = 'Elite Hacker',
            [4] = 'Master Hacker',
            [5] = 'Cyber Terror',
            [6] = 'Cyber Warlord',
            [7] = 'Cyber God',
            [8] = 'Cyber Deity',
            [9] = 'Cyber Overlord',
            [10] = 'Cyber King',
        }
    },
    ['Cooking'] = {
        xpImage = 'https://cdn-icons-png.flaticon.com/512/5370/5370178.png',
        maxLevel = 10,
        xpPerLevel = 500,
        doubleXpReqPerLevel = false,
        notifyOnLevelUp = true,
        criminal = false,
        ranks = {
            [0] = 'No Rank',
            [1] = 'Line Cook',
            [2] = 'Sous Chef',
            [3] = 'Head Chef',
            [4] = 'Executive Chef',
            [5] = 'Celebrity Chef',
            [6] = 'Master Chef',
            [7] = 'Iron Chef',
            [8] = 'Top Chef',
            [9] = 'Michelin Star Chef',
            [10] = 'Gordon Ramsay',
        }
    },
    ['Fishing'] = {
        xpImage = 'https://cdn-icons-png.flaticon.com/512/803/803791.png',
        maxLevel = 10,
        xpPerLevel = 500,
        doubleXpReqPerLevel = true,
        notifyOnLevelUp = true,
        criminal = false,
        ranks = {
            [0] = 'No Rank',
            [1] = 'Fisherman',
            [2] = 'Angler',
            [3] = 'Master Angler',
            [4] = 'Fishing Pro',
            [5] = 'Fishing Expert',
            [6] = 'Fishing Master',
            [7] = 'Fishing Legend',
            [8] = 'Fishing God',
            [9] = 'Fishing Deity',
            [10] = 'Fishing King',
        }
    },
    ---- Garbage, fishing, hunting

}

return xpConfig
Config = {}
Config.DebugCode = true
Config.NotifyScript = 'qb'
Config.Target = 'qb'
Config.Webhooks = {
    Enable = false,
    URL = 'CHANGEME',
}

Config.MaxRepInZones = 1000 --can change to whatever you like. i prefer it high but its however you set your server up
Config.HangAroundTimeNeededInZone = 10 -- in minutes ( time needed to be in zone without leaving to gain rep for hangaround) (not including cooldown)
Config.EnableDecay = true -- Toggle decay logic on/off (zones will lose x rep every x minutes)
Config.NotifyLostZone = true --Notifes players of owning gang when they lose a zone
Config.NotifyWarFinished = true --Notifies gang members who won what zone when war ends
Config.NotifyWarStarted = true --notofies gang members when a zone is vulnerable

Config.RepBooster = { -- useful if you want to do temporary Booster weekends to give more rep to certain activities.
    ['drugselling'] = 1.5, -- (EXAMPLE) will multiply by this amount (less than 1 would take rep away, 1.5 would give 50% more rep, 2 would give 100% more rep etc etc)
}

Config.Wars = {
    Enable = true, -- if false will auto takeover zone when occupying gang loses all rep
    MaxWars = 5, --if max number of wars are reached it will stop people from starting more
    WarsLength = 1, -- in minutes how long a war lasts
}

Config.Zones = {                                                            --is not rstricted by gta zones. so you can make as many or as little as you want.
    ["ROCKF"] = {                                                           --must be a Unique Code
        label = "Rockford Hills",
        decay = {time = 240, amount = 1},                                                         -- Decay 1 rep every 240 minutes(4 hours) of inactivity
        coords = {
            { startX = -1379.12, startY = -257.26, endX = -1299.88, endY = -38.12 },
            { startX = -920.61, startY = -465.30, endX = -521.31, endY = -407.48 },
            { startX = -1299.5, startY = -407.3, endX = -550.21, endY = -126.82 },
            { startX = -1299.55, startY = -126.82, endX = -743.39, endY = 445.02 },
            { startX = -743.39, startY = -126.82, endX = -594.91, endY = 13.48 },
        },
        activities = {  --all activities must be setup with the AddZoneRep export in your other scripts (qb-drugs, qb-vehiclekeys, etc)
            ['drugselling'] = { --see ReadMe for instruction to add to qb-drugs
                RepAmount = 10, --amount of rep to award to the zone (if player is owner gang then increases rep else removes it from the owner gang )
                Cooldown = 1, --in minutes so people cant spam actions to gain rep
            },
            ['killing'] = {
                RepAmount = 50,
                WarOnly = true, --will only work if war is happening in this zone (will still kill players but wont add rep if not in a war zone)
            },
            ['carjacking'] = { --needs export adding to your vehicle keys script
                RepAmount = 20,
                Cooldown = 10,
            },
            ['graffiti'] = { --requires rcore_spray or some other spray paint script (this is an example of what you can have)
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = { --hangaround is an internal activity and does not require an export
                RepAmount = 1,
                Cooldown = 60,
            },
        },
    },
    ['MORN'] = {
        label = "Morningwood",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -1635.47, startY = -500.0, endX = -1379.12, endY = -107.29 },
            { startX = -1379.12, startY = -511.5, endX = -1299.88, endY = -257.26 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['MOVIE'] = {
        label = "Richards Majestic",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -1380.23, startY = -849.50, endX = -1172.24, endY = -511.48 },
            { startX = -1172.24, startY = -576.61, endX = -1072.88, endY = -543.51 },
            { startX = -1172.24, startY = -722.8, endX = -1127.62, endY = -576.61 },
            { startX = -1172.24, startY = -543.51, endX = -998.41, endY = -511.48 },
            { startX = -1299.88, startY = -511.48, endX = -920.5, endY = -407.23 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['KOREAT'] = {
        label = "Little Seoul",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -1127.62, startY = -723.01, endX = -1072.88, endY = -576.61 },
            { startX = -1072.88, startY = -723.01, endX = -998.41, endY = -543.51 },
            { startX = -931.96, startY = -849.49, endX = -774.41, endY = -723.01 },
            { startX = -865.98, startY = -907.78, endX = -774.41, endY = -849.49 },
            { startX = -812.41, startY = -1019.71, endX = -774.41, endY = -907.78 },
            { startX = -998.41, startY = -723.01, endX = -403.51, endY = -511.48 },
            { startX = -920.61, startY = -511.48, endX = -521.31, endY = -465.30 },
            { startX = -573.84, startY = -1425.40, endX = -403.51, endY = -1158.02 },
            { startX = -774.41, startY = -1158.02, endX = -354.71, endY = -723.01 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['MIRR'] = {
        label = "Mirror Park",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 869.70, startY = -820.90, endX = 1391.07, endY = -282.32 },
        },
        activities = {
            ['killing'] = {
                RepAmount = 50,
                WarOnly = true,
            },
            ['drugselling'] = {
                RepAmount = 10,
                -- Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['LMESA'] = {
        label = "La Mesa",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 921.45, startY = -1901.45, endX = 1118.89, endY = -1708.33 },
            { startX = 505.03, startY = -1158.02, endX = 934.14, endY = -1006.57 },
            { startX = 618.7, startY = -1708.33, endX = 1118.27, endY = -1392.36 },
            { startX = 618.7, startY = -1158.62, endX = 934.14, endY = -1392.26 },
            { startX = 505.03, startY = -1006.57, endX = 888.46, endY = -820.90 },
            { startX = 505.03, startY = -820.90, endX = 869.70, endY = -510.0 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['MURR'] = {
        label = "Murrieta Heights",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 1390.09, startY = -821.79, endX = 888.93, endY = -1005.22 },
            { startX = 1485.03, startY = -1006.57 , endX = 934.14, endY = -1392.26 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['STRAW'] = {
        label = "Strawberry",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -63.92, startY = -1700.53, endX = 91.27, endY = -1425.40 },
            { startX = -403.51, startY = -1425.40, endX = 618.43, endY = -1158.02 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['RANCHO'] = {
        label = "Rancho",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 359.48, startY = -1761.99, endX = 618.43, endY = -1426.72 },
            { startX = 271.51, startY = -1761.99, endX = 359.48, endY = -1613.16 },
            { startX = 222.40, startY = -2022.57, endX = 618.43, endY = -1761.99 },
            { startX = 123.73, startY = -2168.95, endX = 505.03, endY = -2022.57 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['BANNI'] = {
        label = "Banning",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 504.70, startY = -2169.65, endX = -273.60, endY = -2361.38 },
            { startX = 121.16, startY = -2023.51, endX = -137.42, endY = -2168.58 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['CHAMH'] = {
        label = "Chamberlain Hills",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -283.92, startY = -1761.99, endX = -63.92, endY = -1425.40 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['DAVIS'] = {
        label = "Davis",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -63.92, startY = -1761.99, endX = 271.51, endY = -1700.53 },
            { startX = 91.27, startY = -1700.53, endX = 271.51, endY = -1613.16 },
            { startX = 91.27, startY = -1613.16, endX = 359.48, endY = -1425.40 },
            { startX = -139.74, startY = -2022.57, endX = -9.70, endY = -1761.99 },
            { startX = -9.70, startY = -2022.57, endX = 115.40, endY = -1761.99 },
            { startX = 115.40, startY = -2022.57, endX = 222.40, endY = -1761.99 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 10,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['PBOX'] = {
        label = "Pillbox Hill",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -276.21, startY = -722.91, endX = 285.43, endY = -573.01 },
            { startX = -354.71, startY = -1158.02, endX = 119.43, endY = -722.91 },
            { startX = 199.43, startY = -877.91, endX = 285.43, endY = -722.91 },
            { startX = 119.43, startY = -1158.02, endX = 199.43, endY = -722.91 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['TEXTI'] = {
        label = "Textile City",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 285.43, startY = -877.91, endX = 505.03, endY = -510.0 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['SKID'] = {
        label = "Mission Row",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 199.43, startY = -1158.02, endX = 505.03, endY = -877.91 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['DTVINE'] = {
        label = "Downtown Vinewood",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 48.53, startY = -20.78, endX = 695.87, endY = 445.02 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['WVINE'] = {
        label = "West Vinewood",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -743.39, startY = 13.47, endX = 48.53, endY = 445.02 },
            { startX = -246.39, startY = -20.78, endX = 48.53, endY = 13.48 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
    ['BURTON'] = {
        label = "Burton",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -594.91, startY = -126.82, endX = -246.39, endY = 13.48 },
            { startX = -550.21, startY = -310.80, endX = -246.39, endY = -126.82 },
            { startX = -246.39, startY = -378.61, endX = -90.0, endY = -20.78 },
            { startX = -246.39, startY = -452.98, endX = -90.0, endY = -378.61 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['VCANA'] = {
        label = "Vespucci Canals",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -1319.77, startY = -1074.78, endX = -1095.41, endY = -960.49 },
            { startX = -1272.77, startY = -960.49, endX = -1095.41, endY = -849.49 },
            { startX = -1250.79, startY = -1174.30, endX = -1095.41, endY = -1074.78 },
            { startX = -1249.24, startY = -1237.30, endX = -1095.41, endY = -1174.30 },
            { startX = -1232.34, startY = -1287.02, endX = -1095.41, endY = -1237.30 },
            { startX = -1202.04, startY = -1389.87, endX = -1095.41, endY = -1287.02 },
            { startX = -1182.04, startY = -1450.40, endX = -1095.41, endY = -1389.87 },
            { startX = -1095.41, startY = -1214.40, endX = -774.41, endY = -1019.71 },
            { startX = -1095.41, startY = -1019.71, endX = -812.41, endY = -907.78 },
            { startX = -1095.41, startY = -907.78, endX = -865.98, endY = -849.49 },
            { startX = -1172.0, startY = -849.49, endX = -931.96, endY = -723.01 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['ALTA'] = {
        label = "Alta",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -90.0, startY = -480.90, endX = 695.99, endY = -177.0 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['EBURO'] = {
        label = "El Burro Heights",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 1118.89, startY = -1901.45, endX = 1485.92, endY = -1391.50 },
            { startX = 1048.75, startY = -1901.45, endX = 1767.54, endY = -2718.08 },
            { startX = 1969.72, startY = -932.35, endX = 1673.43, endY = -1550.59 },
            { startX = 1485.75, startY = -1305.37, endX = 1673.43, endY = -1550.59 },
            { startX = 1767.54, startY = -1901.45, endX = 1486.15, endY = -1551.31 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['CYPRE'] = {
        label = "Cypress Flats",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 618.7, startY = -2718.48, endX = 921.45, endY = -1708.33 },
            { startX = 921.45, startY = -2718.48, endX = 1048.54, endY = -1901.45 },
            { startX = 506.08, startY = -2023.64, endX = 618.7, endY = -2718.48 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['VESP'] = {
        label = "Vespucci",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -1450.59, startY = -1287.02, endX = -1232.34, endY = -1237.30 },
            { startX = -1450.59, startY = -1237.30, endX = -1249.24, endY = -1174.30 },
            { startX = -1450.59, startY = -1174.30, endX = -1250.79, endY = -1074.78 },
            { startX = -1450.59, startY = -1389.87, endX = -1202.04, endY = -1287.02 },
            { startX = -1450.59, startY = -1600.40, endX = -1182.04, endY = -1389.87 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['HAWICK'] = {
        label = "Hawick",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -90.0, startY = -177.0, endX = 695.87, endY = -20.78 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['EAST_V'] = {
        label = "East Vinewood",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 696.0, startY = -282.5, endX = 1391.0, endY = -35.97 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['GRAPES'] = {
        label = "Grapeseed",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 1605.27, startY = 4543.62, endX = 2413.98, endY = 5269.38 },
            { startX = 2413.98, startY = 5138.80, endX = 2498.52, endY = 5269.38 },
            { startX = 2413.98, startY = 4778.17, endX = 2561.79, endY = 5138.80 },
            { startX = 2413.98, startY = 4417.53, endX = 2632.58, endY = 4778.17 },
            { startX = 2413.98, startY = 4036.53, endX = 2734.72, endY = 4417.53 },
            { startX = 1605.27, startY = 4820.46, endX = 1648.42, endY = 4931.77 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['SANDY'] = {
        label = "Sandy Shores",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 1295.66, startY = 3455.35, endX = 2145.09, endY = 4012.51 },
            { startX = 2413.98, startY = 3554.05, endX = 2807.76, endY = 4036.53 },
            { startX = 2145.09, startY = 3554.05, endX = 2413.98, endY = 3819.50 },
            { startX = 2145.09, startY = 3294.46, endX = 2693.05, endY = 3554.05 },
            { startX = 2083.31, startY = 3925.83, endX = 2145.09, endY = 3954.88 },
            { startX = 2057.38, startY = 3954.88, endX = 2145.09, endY = 4012.50 },
            { startX = 1990.20, startY = 3973.64, endX = 2057.38, endY = 4012.51 },
            { startX = 1976.69, startY = 3981.51, endX = 1990.20, endY = 3995.50 },
            { startX = 1752.23, startY = 3995.50, endX = 1990.20, endY = 4012.50 },
            { startX = 1691.23, startY = 3983.57, endX = 1752.23, endY = 4012.50 },
            { startX = 1691.23, startY = 3967.40, endX = 1713.04, endY = 3983.58 },
            { startX = 1446.97, startY = 3954.97, endX = 1691.23, endY = 4012.50 },
            { startX = 1446.97, startY = 3930.21, endX = 1683.75, endY = 3954.97 },
            { startX = 1446.97, startY = 3888.02, endX = 1508.13, endY = 3930.21 },
            { startX = 1508.13, startY = 3888.02, endX = 1540.87, endY = 3904.46 },
            { startX = 1532.13, startY = 3856.76, endX = 1584.82, endY = 3888.02 },
            { startX = 1446.97, startY = 3819.74, endX = 1532.13, endY = 3888.02 },
            { startX = 1295.66, startY = 3888.02, endX = 1446.97, endY = 4012.51 },
            { startX = 1295.66, startY = 3812.33, endX = 1388.96, endY = 3888.02 },
            { startX = 1295.66, startY = 3741.06, endX = 1356.98, endY = 3812.33 },
            { startX = 1295.66, startY = 3713.35, endX = 1325.48, endY = 3741.06 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['HARM'] = {
        label = "Harmony",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = 814.77, startY = 2565.58, endX = -42.92, endY = 3140.76 },
            --[[{ startX = 2413.98, startY = 3554.05, endX = 2807.76, endY = 4036.53 },
            { startX = 2145.09, startY = 3554.05, endX = 2413.98, endY = 3819.50 },
            { startX = 2145.09, startY = 3294.46, endX = 2693.05, endY = 3554.05 },
            { startX = 2083.31, startY = 3925.83, endX = 2145.09, endY = 3954.88 },
            { startX = 2057.38, startY = 3954.88, endX = 2145.09, endY = 4012.50 },
            { startX = 1990.20, startY = 3973.64, endX = 2057.38, endY = 4012.51 },
            { startX = 1976.69, startY = 3981.51, endX = 1990.20, endY = 3995.50 },
            { startX = 1752.23, startY = 3995.50, endX = 1990.20, endY = 4012.50 },
            { startX = 1691.23, startY = 3983.57, endX = 1752.23, endY = 4012.50 },
            { startX = 1691.23, startY = 3967.40, endX = 1713.04, endY = 3983.58 },
            { startX = 1446.97, startY = 3954.97, endX = 1691.23, endY = 4012.50 },
            { startX = 1446.97, startY = 3930.21, endX = 1683.75, endY = 3954.97 },
            { startX = 1446.97, startY = 3888.02, endX = 1508.13, endY = 3930.21 },
            { startX = 1508.13, startY = 3888.02, endX = 1540.87, endY = 3904.46 },
            { startX = 1532.13, startY = 3856.76, endX = 1584.82, endY = 3888.02 },
            { startX = 1446.97, startY = 3819.74, endX = 1532.13, endY = 3888.02 },
            { startX = 1295.66, startY = 3888.02, endX = 1446.97, endY = 4012.51 },
            { startX = 1295.66, startY = 3812.33, endX = 1388.96, endY = 3888.02 },
            { startX = 1295.66, startY = 3741.06, endX = 1356.98, endY = 3812.33 },
            { startX = 1295.66, startY = 3713.35, endX = 1325.48, endY = 3741.06 },]]
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
        },
    },
    ['PALETO'] = {
        label = "Paleto Bay",
        decay = {time = 240, amount = 1},
        coords = {
            { startX = -333.95, startY = 6006.86, endX = -188.97, endY = 6147.87 },
            { startX = -282.23, startY = 6147.87, endX = -137.25, endY = 6288.88 },
            { startX = -137.25, startY = 6195.79, endX = 7.74, endY = 6336.80 },
            { startX = -59.31, startY = 6336.80, endX = 66.28, endY = 6452.00 },
            { startX = 66.28, startY = 6409.34, endX = 211.26, endY = 6518.35 },
            { startX = 110.86, startY = 6518.35, endX = 516.84, endY = 6614.36 },
            { startX = -680.83, startY = 6147.87, endX = -282.23, endY = 6288.88 },
            { startX = -598.05, startY = 6288.88, endX = -137.25, endY = 6477.81 },
            { startX = 66.28, startY = 6518.35, endX = 110.86, endY = 6614.36 },
            { startX = -357.76, startY = 6477.81, endX = 66.28, endY = 6614.36 },
            { startX = 10.82, startY = 6614.36, endX = 133.50, endY = 7165.53 },
            { startX = -188.97, startY = 6006.86, endX = -39.51, endY = 6147.87 },
            { startX = -137.25, startY = 6147.87, endX = -39.51, endY = 6195.79 },
            { startX = 7.74, startY = 6195.79, endX = 66.28, endY = 6336.80 },
            { startX = -137.25, startY = 6336.80, endX = -59.31, endY = 6477.81 },
            { startX = -59.31, startY = 6452.00, endX = 66.28, endY = 6477.81 },
            { startX = -481.00, startY = 6006.37, endX = -333.95, endY = 6147.87 },
            { startX = -112.83, startY = 6614.36, endX = 10.82, endY = 6786.93 },
            { startX = -202.03, startY = 6614.36, endX = -112.83, endY = 6703.23 },
            { startX = -164.47, startY = 6703.23, endX = -112.83, endY = 6744.03 },
            { startX = 133.50, startY = 6614.36, endX = 465.00, endY = 6785.33 },
            { startX = 133.50, startY = 6785.33, endX = 387.30, endY = 6900.54 },
            { startX = 133.50, startY = 6900.54, endX = 284.08, endY = 6996.90 },
            { startX = 133.50, startY = 6996.90, endX = 224.78, endY = 7065.80 },
            { startX = 465.00, startY = 6705.98, endX = 617.57, endY = 6745.77 },
            { startX = 387.30, startY = 6785.33, endX = 473.72, endY = 6840.19 },
            { startX = 284.08, startY = 6900.54, endX = 386.59, endY = 6949.75 },
            { startX = 133.50, startY = 7065.80, endX = 193.80, endY = 7165.53 },
            { startX = 224.78, startY = 6996.90, endX = 277.79, endY = 7065.80 },
            { startX = 284.08, startY = 6949.75, endX = 332.08, endY = 6996.90 },
            { startX = 387.30, startY = 6840.19, endX = 430.30, endY = 6900.54 },
            { startX = 465.00, startY = 6745.77, endX = 541.00, endY = 6785.33 },
            { startX = 465.00, startY = 6614.36, endX = 617.57, endY = 6705.98 },
            { startX = -43.31, startY = 6882.58, endX = 10.82, endY = 7165.53 },
            { startX = -103.31, startY = 6786.93, endX = 10.82, endY = 6882.58 },
            { startX = -234.25, startY = 6006.86, endX = -188.97, endY = 6046.44 },
            { startX = -61.55, startY = 6006.86, endX = -39.51, endY = 6025.03 },
            { startX = -165.24, startY = 6006.86, endX = -149.20, endY = 6021.46 },
            { startX = -58.57, startY = 6115.46, endX = -39.51, endY = 6147.87 },
            { startX = -117.17, startY = 6056.50, endX = -39.51, endY = 6115.46 },
            { startX = -108.56, startY = 6006.86, endX = -88.03, endY = 6017.70 },
            { startX = -128.49, startY = 6020.11, endX = -93.62, endY = 6045.88 },
        },
        activities = {
            ['drugselling'] = {
                RepAmount = 10,
                Cooldown = 1,
            },
            ['graffiti'] = {
                RepAmount = 5,
                Cooldown = 5,
            },
            ['carjacking'] = {
                RepAmount = 2,
                Cooldown = 10,
            },
            ['hangaround'] = {
                RepAmount = 2,
                Cooldown = 60,
            },
        },
    },
}
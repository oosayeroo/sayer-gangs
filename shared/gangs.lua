Gangs = { -- these must also be in your qb-core/shared/gangs.lua file too
-- some options you can use in grades
-- name = !IMPORTANT the name which shows everywhere for that grade
-- isBoss = optional / means this grade can controls everything the gang has collectively
-- canRecruit = optional / allows this grade to recruit, promote, demote and remove a gang member
-- canCollectTax = optional / allows members to collect tax from protection rackets or other businesses
    ['ballas'] = {
        colour = 27, -- find from this website -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        label = 'Ballas',
        grades = { --grades must start with 0 and be in order
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
    ['vagos'] = {
        colour = 5,
        label = 'Vagos',
        grades = {
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
    ['lostmc'] = {
        colour = 40,
        label = 'The Lost MC',
        grades = {
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
    ['cartel'] = {
        colour = 52,
        label = 'Cartel',
        grades = {
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
    ['families'] = {
        colour = 2,
        label = 'Families',
        grades = {
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
    ['triads'] = {
        colour = 1,
        label = 'Triads',
        grades = {
            [0] = { name = 'Recruit' },
            [1] = { name = 'Enforcer' },
            [2] = { name = 'Shot Caller', canRecruit = true, canCollectTax = true },
            [3] = { name = 'Boss', canRecruit = true, isBoss = true, canCollectTax = true },
        },
    },
}
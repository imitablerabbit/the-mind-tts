-- Global variables. These should be initialised by calling the functions
-- below. This is only really here for clenliness. It can help me to easily
-- find all of the global variables which are in use.
numberCards = {}
numberCardsLookup = {}
numberDeckZone = nil
numberDeckPosition = nil
numberDiscardZone = nil
numberDiscardPosition = nil
numberDeck = nil
numberDiscardDeck = nil
numberCheckTriggerCount = 30
numberCheckCount = 0

levelCards = {}
levelCardsLookup = {}
levelCurrentZone = nil
levelCurrentPosition = nil
levelDiscardZone = nil
levelDiscardPosition = nil
levelDeck = nil

lifeCards = {}
lifeCardsLookup = {}
playingRound = false

shurikenCards = {}
shurikenCardsLookup = {}
shurikenVotes = nil -- only populated during a vote

-- ============================================================================
-- Global Callback Functions
-- ============================================================================

--[[
-- The onLoad event is called after the game save finishes loading.
--]]
function onLoad()
    initNumberCards()
    initLevelCards()
    initLifeCards()
    initShurikenCards()
    initLevelButtons()
    initNumbersButtons()
    initShurikenButtons()
    drawLines()
end

--[[
-- Checks whether the numbers discard deck is in numerical order.
-- The deck will be checked every 30 frames. If it is not in order then the
-- players will lose a life automatically.
--]]
function onUpdate()
    numberCheckCount = numberCheckCount + 1
    if numberCheckCount < numberCheckTriggerCount or not playingRound then
        return
    end
    numberCheckCount = 0
    if not numberDiscardDeck then
        local deck = getZoneObject(numberDiscardZone)
        if type(deck) ~= "number" and deck and deck.tag == "Deck" then
            numberDiscardDeck = deck
        else
            return
        end
    end
    local ordered, card = isDeckOrdered(numberCardsLookup, numberDiscardDeck, false)
    if type(ordered) ~= "number" and not ordered then
        broadcastToAll("That's not a consecutive card!")
        removeLife()
        playingRound = false
        -- Move the discard pile off to the side slightly. This will then get
        -- ordered along side any loose cards in players hands.
        local deckPosition = numberDiscardDeck.getPosition()
        local newDeckPosition = deckPosition:copy()
        newDeckPosition.x = newDeckPosition.x - 3
        numberDiscardDeck.setPosition(newDeckPosition)
        -- Move any loose cards to the number discard pile if they have a lower
        -- value that the highest card within the ordered deck.
        local allObjects = getAllObjects()
        if allObjects then
            for i, object in ipairs(allObjects) do
                if object.tag == "Card" then
                    local data = numberCardsLookup[object.guid]
                    if data and data.value < card.value then
                        Wait.frames(
                            function()
                                object.setPosition(newDeckPosition)
                            end, 10)
                    end
                end
            end
        end
        -- Reorder the discard pile so that everything is back into numeric order.
        local dropPosition = numberDiscardPosition:copy()
        dropPosition.y = 2
        Wait.frames(
            function()
                orderDeck(numberCards, numberDiscardDeck, dropPosition,
                    function()
                        -- Reset the discard deck so that the next tick can find
                        -- it and check the order again. No point in trying to
                        -- find it again here.
                        numberDiscardDeck = nil
                        playingRound = true
                    end)
            end, 30)
    end
end

-- ============================================================================
-- Card Initialisation Functions
-- ============================================================================

--[[
-- Initialise the global variables associated with the main number deck that
-- gets dealt out to each of the players.
--]]
function initNumberCards()
    numberCards[1] = {guid = '5bd80d', value = 1, description = "Number 1"}
    numberCards[2] = {guid = '201c46', value = 2, description = "Number 2"}
    numberCards[3] = {guid = '66f68b', value = 3, description = "Number 3"}
    numberCards[4] = {guid = '4d0e68', value = 4, description = "Number 4"}
    numberCards[5] = {guid = '49e180', value = 5, description = "Number 5"}
    numberCards[6] = {guid = 'f02251', value = 6, description = "Number 6"}
    numberCards[7] = {guid = '08c6ef', value = 7, description = "Number 7"}
    numberCards[8] = {guid = 'a213c6', value = 8, description = "Number 8"}
    numberCards[9] = {guid = 'c4aab6', value = 9, description = "Number 9"}
    numberCards[10] = {guid = 'a48022', value = 10, description = "Number 10"}
    numberCards[11] = {guid = '7fc75a', value = 11, description = "Number 11"}
    numberCards[12] = {guid = '7fea34', value = 12, description = "Number 12"}
    numberCards[13] = {guid = '972da8', value = 13, description = "Number 13"}
    numberCards[14] = {guid = 'b7a752', value = 14, description = "Number 14"}
    numberCards[15] = {guid = 'a73668', value = 15, description = "Number 15"}
    numberCards[16] = {guid = 'cc8c2d', value = 16, description = "Number 16"}
    numberCards[17] = {guid = '40a6ff', value = 17, description = "Number 17"}
    numberCards[18] = {guid = 'a7b7da', value = 18, description = "Number 18"}
    numberCards[19] = {guid = 'd89275', value = 19, description = "Number 19"}
    numberCards[20] = {guid = 'a170db', value = 20, description = "Number 20"}
    numberCards[21] = {guid = 'e8a64c', value = 21, description = "Number 21"}
    numberCards[22] = {guid = '3b84a1', value = 22, description = "Number 22"}
    numberCards[23] = {guid = 'b146ae', value = 23, description = "Number 23"}
    numberCards[24] = {guid = '3005bc', value = 24, description = "Number 24"}
    numberCards[25] = {guid = '77010a', value = 25, description = "Number 25"}
    numberCards[26] = {guid = '0f2b17', value = 26, description = "Number 26"}
    numberCards[27] = {guid = '343b74', value = 27, description = "Number 27"}
    numberCards[28] = {guid = '62caa9', value = 28, description = "Number 28"}
    numberCards[29] = {guid = 'f07e3d', value = 29, description = "Number 29"}
    numberCards[30] = {guid = '92fd62', value = 30, description = "Number 30"}
    numberCards[31] = {guid = '61dbbc', value = 31, description = "Number 31"}
    numberCards[32] = {guid = '5d28cf', value = 32, description = "Number 32"}
    numberCards[33] = {guid = '47cfb8', value = 33, description = "Number 33"}
    numberCards[34] = {guid = '0303d8', value = 34, description = "Number 34"}
    numberCards[35] = {guid = '8fc8dd', value = 35, description = "Number 35"}
    numberCards[36] = {guid = '6173df', value = 36, description = "Number 36"}
    numberCards[37] = {guid = 'b9417d', value = 37, description = "Number 37"}
    numberCards[38] = {guid = '5bd34b', value = 38, description = "Number 38"}
    numberCards[39] = {guid = 'a5c1ed', value = 39, description = "Number 39"}
    numberCards[40] = {guid = 'ff93fc', value = 40, description = "Number 40"}
    numberCards[41] = {guid = '751f48', value = 41, description = "Number 41"}
    numberCards[42] = {guid = '873c12', value = 42, description = "Number 42"}
    numberCards[43] = {guid = '4770d1', value = 43, description = "Number 43"}
    numberCards[44] = {guid = '67ea68', value = 44, description = "Number 44"}
    numberCards[45] = {guid = '93ef61', value = 45, description = "Number 45"}
    numberCards[46] = {guid = 'f9179d', value = 46, description = "Number 46"}
    numberCards[47] = {guid = 'd06a44', value = 47, description = "Number 47"}
    numberCards[48] = {guid = '9a56dc', value = 48, description = "Number 48"}
    numberCards[49] = {guid = 'e46231', value = 49, description = "Number 49"}
    numberCards[50] = {guid = '1c452f', value = 50, description = "Number 50"}
    numberCards[51] = {guid = '5abc8c', value = 51, description = "Number 51"}
    numberCards[52] = {guid = '4b8a4b', value = 52, description = "Number 52"}
    numberCards[53] = {guid = '3793ee', value = 53, description = "Number 53"}
    numberCards[54] = {guid = '75a7ed', value = 54, description = "Number 54"}
    numberCards[55] = {guid = '0f9a9d', value = 55, description = "Number 55"}
    numberCards[56] = {guid = '0c682a', value = 56, description = "Number 56"}
    numberCards[57] = {guid = 'e40dbd', value = 57, description = "Number 57"}
    numberCards[58] = {guid = '0040de', value = 58, description = "Number 58"}
    numberCards[59] = {guid = '08d65f', value = 59, description = "Number 59"}
    numberCards[60] = {guid = '269016', value = 60, description = "Number 60"}
    numberCards[61] = {guid = 'd93db0', value = 61, description = "Number 61"}
    numberCards[62] = {guid = '34f7ce', value = 62, description = "Number 62"}
    numberCards[63] = {guid = 'be5af0', value = 63, description = "Number 63"}
    numberCards[64] = {guid = 'ec7154', value = 64, description = "Number 64"}
    numberCards[65] = {guid = '8dd306', value = 65, description = "Number 65"}
    numberCards[66] = {guid = 'da85bd', value = 66, description = "Number 66"}
    numberCards[67] = {guid = 'cd920a', value = 67, description = "Number 67"}
    numberCards[68] = {guid = 'dbb2b6', value = 68, description = "Number 68"}
    numberCards[69] = {guid = '46f994', value = 69, description = "Number 69"}
    numberCards[70] = {guid = '9ffd85', value = 70, description = "Number 70"}
    numberCards[71] = {guid = '0f225b', value = 71, description = "Number 71"}
    numberCards[72] = {guid = 'f083bc', value = 72, description = "Number 72"}
    numberCards[73] = {guid = '28f929', value = 73, description = "Number 73"}
    numberCards[74] = {guid = 'a17722', value = 74, description = "Number 74"}
    numberCards[75] = {guid = 'b18fd7', value = 75, description = "Number 75"}
    numberCards[76] = {guid = '1743b5', value = 76, description = "Number 76"}
    numberCards[77] = {guid = 'c36d16', value = 77, description = "Number 77"}
    numberCards[78] = {guid = '2bcd67', value = 78, description = "Number 78"}
    numberCards[79] = {guid = '152ee6', value = 79, description = "Number 79"}
    numberCards[80] = {guid = 'df8c3e', value = 80, description = "Number 80"}
    numberCards[81] = {guid = 'f36ab4', value = 81, description = "Number 81"}
    numberCards[82] = {guid = 'd7f1f6', value = 82, description = "Number 82"}
    numberCards[83] = {guid = '5d2018', value = 83, description = "Number 83"}
    numberCards[84] = {guid = '8dc9c4', value = 84, description = "Number 84"}
    numberCards[85] = {guid = '4bb74f', value = 85, description = "Number 85"}
    numberCards[86] = {guid = '57b088', value = 86, description = "Number 86"}
    numberCards[87] = {guid = '1f4f20', value = 87, description = "Number 87"}
    numberCards[88] = {guid = 'a18b1a', value = 88, description = "Number 88"}
    numberCards[89] = {guid = 'dfe30d', value = 89, description = "Number 89"}
    numberCards[90] = {guid = '292dba', value = 90, description = "Number 90"}
    numberCards[91] = {guid = '27c966', value = 91, description = "Number 91"}
    numberCards[92] = {guid = 'aead1d', value = 92, description = "Number 92"}
    numberCards[93] = {guid = 'e6ea5a', value = 93, description = "Number 93"}
    numberCards[94] = {guid = '8cb1b1', value = 94, description = "Number 94"}
    numberCards[95] = {guid = 'f3288f', value = 95, description = "Number 95"}
    numberCards[96] = {guid = 'e436fe', value = 96, description = "Number 96"}
    numberCards[97] = {guid = '70de93', value = 97, description = "Number 97"}
    numberCards[98] = {guid = '079016', value = 98, description = "Number 98"}
    numberCards[99] = {guid = '08afca', value = 99, description = "Number 99"}
    numberCards[100] = {guid = 'b49deb', value = 100, description = "Number 100"}
    for i, card in ipairs(numberCards) do
        numberCardsLookup[card.guid] = card
    end
    numberDeckZone = getObjectFromGUID('fe3494')
    numberDeckPosition = {-3.00, 1.46, 0.00}
    numberDiscardZone = getObjectFromGUID('79b9e2')
    numberDiscardPosition = Vector(-6.00, 0.97, 0.00)
    numberDeck = numberDeckZone.getObjects()[1]
end

--[[
-- Initialise the level deck. This represents what level the group is currently
-- on. As this progresses the group will gain lives and shurikens.
--]]
function initLevelCards()
    levelCards = {}
    levelCards[1] = {guid = '247c92', value = 1, description = "Level 1", gainLife = false, gainShuriken = false}
    levelCards[2] = {guid = '4bf571', value = 2, description = "Level 2", gainLife = false, gainShuriken = true}
    levelCards[3] = {guid = '25af26', value = 3, description = "Level 3", gainLife = true, gainShuriken = false}
    levelCards[4] = {guid = '8acb9e', value = 4, description = "Level 4", gainLife = false, gainShuriken = false}
    levelCards[5] = {guid = '22d875', value = 5, description = "Level 5", gainLife = false, gainShuriken = true}
    levelCards[6] = {guid = '2bcc9e', value = 6, description = "Level 6", gainLife = true, gainShuriken = false}
    levelCards[7] = {guid = '548646', value = 7, description = "Level 7", gainLife = false, gainShuriken = false}
    levelCards[8] = {guid = 'dca238', value = 8, description = "Level 8", gainLife = false, gainShuriken = true}
    levelCards[9] = {guid = 'fb035c', value = 9, description = "Level 9", gainLife = true, gainShuriken = false}
    levelCards[10] = {guid = 'b95026', value = 10, description = "Level 10", gainLife = false, gainShuriken = false}
    levelCards[11] = {guid = '03623d', value = 11, description = "Level 11", gainLife = false, gainShuriken = false}
    levelCards[12] = {guid = 'd24cde', value = 12, description = "Level 12", gainLife = false, gainShuriken = false}
    for i, card in ipairs(levelCards) do
        levelCardsLookup[card.guid] = card
    end
    levelCurrentZone = getObjectFromGUID("f8d8a1")
    levelCurrentPosition = Vector(6.00, 0.97, 0.00)
    levelDiscardZone = getObjectFromGUID("4f02e7")
    levelDiscardPosition = Vector(3.00, 0.97, 0.00)
    levelDeck = levelCurrentZone.getObjects()[1]
end

--[[
-- Initialise the life cards. These represent the number of lives that the
-- players have. Face up lives represent the number of lives remaining.
--]]
function initLifeCards()
    lifeCards[1] = {guid = '9a3b4d', value = 1, description = "Life 1"}
    lifeCards[2] = {guid = '5d4937', value = 2, description = "Life 2"}
    lifeCards[3] = {guid = '90899d', value = 3, description = "Life 3"}
    lifeCards[4] = {guid = '433ed2', value = 4, description = "Life 4"}
    lifeCards[5] = {guid = '1e9748', value = 5, description = "Life 5"}
    for i, card in ipairs(lifeCards) do
        lifeCardsLookup[card.guid] = card
    end
end

--[[
-- Initialise the shuriken cards. These represent the number of shurikens that
-- the players have left. Face up cards represent the number of shurikens remaining.
--]]
function initShurikenCards()
    shurikenCards[1] = {guid = 'fc4bd4', value = 1, description = "Shuriken 1"}
    shurikenCards[2] = {guid = '52f787', value = 2, description = "Shuriken 2"}
    shurikenCards[3] = {guid = '86f6be', value = 3, description = "Shuriken 3"}
    for i, card in ipairs(shurikenCards) do
        shurikenCardsLookup[card.guid] = card
    end
end

-- ============================================================================
-- Button Initialisation Functions
-- ============================================================================

function initLevelButtons()
    local previousCoin = getObjectFromGUID("e9d1a5")
    local nextCoin = getObjectFromGUID("dae278")
    previousCoin.clearButtons()
    previousCoin.createButton({
        click_function = "previousLevel",
        function_owner = self,
        label          = "Previous",
        position       = vector(0, 2, 0),
        rotation       = vector(0, 270, 0),
        width          = 2500,
        height         = 1000,
        font_size      = 500,
        tooltip        = "Go back to the previous level",
    })
    nextCoin.clearButtons()
    nextCoin.createButton({
        click_function = "nextLevel",
        function_owner = self,
        label          = "Next",
        position       = vector(0, 2, 0),
        rotation       = vector(0, 270, 0),
        width          = 2500,
        height         = 1000,
        font_size      = 500,
        tooltip        = "Advance to the next level",
    })
end

function initNumbersButtons()
    local resetCoin = getObjectFromGUID("c15ecd")
    local dealCoin = getObjectFromGUID("b50b8c")
    resetCoin.clearButtons()
    resetCoin.createButton({
        click_function = "resetNumberCards",
        function_owner = self,
        label          = "Reset",
        position       = vector(0, 2, 0),
        rotation       = vector(0, 270, 0),
        width          = 2500,
        height         = 1000,
        font_size      = 500,
        tooltip        = "Reset the numbers deck ready for the next level",
    })
    dealCoin.clearButtons()
    dealCoin.createButton({
        click_function = "dealNumberCards",
        function_owner = self,
        label          = "Deal",
        position       = vector(0, 2, 0),
        rotation       = vector(0, 270, 0),
        width          = 2500,
        height         = 1000,
        font_size      = 500,
        tooltip        = "Deal cards for the current level",
    })
end

--[[
-- Create the shuriken vote button. Each player should press this button to
-- vote on whether to use a shuriken. If all of the players seated at the table
-- have voted to use the shuriken, then we will use one. The use of a shuriken
-- is not automatic though.
--]]
function initShurikenButtons()
    local shurikenCoin = getObjectFromGUID("15bb08")
    shurikenCoin.clearButtons()
    shurikenCoin.createButton({
        click_function = "voteShurikenHandler",
        function_owner = self,
        label          = "Vote For Shuriken",
        position       = vector(0, 2, 0),
        rotation       = vector(0, 270, 0),
        width          = 5000,
        height         = 1000,
        font_size      = 500,
        tooltip        = "Vote to use a shuriken",
    })
end

-- ============================================================================
-- Vector Initialisation Functions
-- ============================================================================

function drawLines()
    local lifeBoundLines = {
        {{18.00, 0.97, -10.00}, {18.00, 0.97, 10.00}}, -- Left
        {{18.00, 0.97, 10.00}, {10.00, 0.97, 10.00}},  -- Bottom
        {{10.00, 0.97, 10.00}, {10.00, 0.97, -10.00}}, -- Right
        {{10.00, 0.97, -10.00}, {18.00, 0.97, -10.00}} -- Top
    }
    local lifeHeadingLines = {
        {{18.00, 0.97, -12.00}, {18.00, 0.97, -10.00}}, -- Left
        {{10.00, 0.97, -10.00}, {10.00, 0.97, -12.00}}, -- Right
        {{18.00, 0.97, -12.00}, {10.00, 0.97, -12.00}}  -- Top
    }
    local shurikenBoundLines = {
        {{-10.00, 0.97, -6.00}, {-10.00, 0.97, 6.00}}, -- Left
        {{-10.00, 0.97, 6.00}, {-18.00, 0.97, 6.00}},  -- Bottom
        {{-18.00, 0.97, 6.00}, {-18.00, 0.97, -6.00}}, -- Right
        {{-18.00, 0.97, -6.00}, {-10.00, 0.97, -6.00}} -- Top
    }
    local shurikenHeadingLines = {
        {{-10.00, 0.97, -8.00}, {-10.00, 0.97, 6.00}},  -- Left
        {{-18.00, 0.97, -6.00}, {-18.00, 0.97, -8.00}}, -- Right
        {{-18.00, 0.97, -8.00}, {-10.00, 0.97, -8.00}}  -- Top
    }
    local levelBoundLines = {
        {{8.00, 0.97, -2.00}, {8.01, 0.97, 2.00}}, -- Left
        {{8.01, 0.97, 2.00}, {1.01, 0.97, 2.00}},  -- Bottom
        {{1.01, 0.97, 2.00}, {1.00, 0.97, -2.00}}, -- Right
        {{1.00, 0.97, -2.00}, {8.00, 0.97, -2.00}} -- Top
    }
    local levelHeadingLines = {
        {{8.00, 0.97, -4.00}, {8.00, 0.99, -2.00}}, -- Left
        {{1.00, 0.99, -2.00}, {1.00, 0.97, -4.00}}, -- Right
        {{1.00, 0.97, -4.00}, {8.00, 0.97, -4.00}}  -- Top
    }
    local numberBoundLines = {
        {{-1.01, 0.97, -1.99}, {-1.00, 0.97, 2.00}}, -- Left
        {{-1.00, 0.97, 2.00}, {-8.00, 0.97, 2.00}},  -- Bottom
        {{-8.00, 0.97, 2.00}, {-8.00, 0.97, -2.00}}, -- Right
        {{-8.00, 0.97, -2.00}, {-1.01, 0.97, -1.99}} -- Top
    }
    local numberHeadingLines = {
        {{-1.00, 0.99, -4.00}, {-1.01, 0.97, -1.99}}, -- Left
        {{-8.00, 0.97, -2.00}, {-8.00, 0.99, -4.00}}, -- Right
        {{-8.00, 0.99, -4.00}, {-1.00, 0.99, -4.00}}  -- Top
    }
    -- Combine all of the individual line tables into a single one so that we
    -- can generate vetor tables for all of them.
    local allLines = {}
    for i, l in ipairs(lifeBoundLines) do table.insert(allLines, l) end
    for i, l in ipairs(shurikenBoundLines) do table.insert(allLines, l) end
    for i, l in ipairs(levelBoundLines) do table.insert(allLines, l) end
    for i, l in ipairs(numberBoundLines) do table.insert(allLines, l) end
    for i, l in ipairs(lifeHeadingLines) do table.insert(allLines, l) end
    for i, l in ipairs(shurikenHeadingLines) do table.insert(allLines, l) end
    for i, l in ipairs(levelHeadingLines) do table.insert(allLines, l) end
    for i, l in ipairs(numberHeadingLines) do table.insert(allLines, l) end
    local vectorLines = {}
    for i, line in ipairs(allLines) do
        table.insert(vectorLines, {
            points = line,
            color = {1, 1, 1},
            thickness = 0.1,
            rotation = {0, 0, 0}
        })
    end
    Global.setVectorLines(vectorLines)
end

-- ============================================================================
-- Item Card Functions
-- ============================================================================

--[[
-- How many life cards are currently face up?
--]]
function remainingLives()
    return faceUpCards(lifeCards)
end

--[[
-- Flip over the next life card in the area to add a new life
--]]
function addLife()
    local lives = remainingLives() + 1
    ensureFaceUpCount(lifeCards, lives)
    broadcastToAll("Gained 1 life!")
end

--[[
-- Flip over an existing life card to remove a life.
--]]
function removeLife()
    local lives = remainingLives() - 1
    ensureFaceUpCount(lifeCards, lives)
    broadcastToAll("Lost 1 life!")
end

--[[
-- How many shuriken cards are currently face up?
--]]
function remainingShuriken()
    return faceUpCards(shurikenCards)
end

--[[
-- Flip over the next life card in the area to add a new life
--]]
function addShuriken()
    local shuriken = remainingShuriken() + 1
    ensureFaceUpCount(shurikenCards, shuriken)
    broadcastToAll("Gained 1 shuriken!")
end

--[[
-- Flip over an existing life card to remove a life.
--]]
function removeShuriken()
    local shuriken = remainingShuriken() - 1
    ensureFaceUpCount(shurikenCards, shuriken)
    broadcastToAll("Lost 1 shuriken!")
end

-- ============================================================================
-- Level Deck Functions
-- ============================================================================

--[[
-- Find what level number the players are on. This is determined by getting the
-- deck within the current level zone and looking at the bottom card in the object
-- list.
--]]
function currentLevel(levelZone)
    local levelsObject = getZoneObject(levelZone)
    if type(levelsObject) == "number" then
        logError("unable to get current level (-1)")
        return -1
    end
    local card = nil
    if levelsObject.tag == "Card" then
        card = levelsObject
    elseif levelsObject.tag == "Deck" then
        local cards = levelsObject.getObjects()
        local deckSize = #cards
        card = cards[deckSize]
    end
    if not card then
        logError("unable to get current level (-2)")
        return -2
    end
    local levelCard = levelCardsLookup[card.guid]
    return levelCard
end

--[[
-- Progresses the level deck in the zone its discard. The argument `gainBonus`
-- denotes whether or not a life/shuriken would be gained provided that the current
-- level allows it. This flag is used to control whether or not the level
-- advancement behaves as though the players completed the level or just decided
-- to start elsewhere. The remove bonus does the same but in reverse, e.g. it will
-- remove lives. These parameters should be mutually exclusive.
--]]
function moveLevel(levelZone, discardPosition, gainBonus, removeBonus)
    local returnCode = 0
    if gainBonus or removeBonus then
        local current = currentLevel(levelZone)
        local currentData = nil
        if type(current) == "table" then
            currentData = levelCardsLookup[current.guid]
        elseif current == 0 then
            return returnCode
        elseif current < 0 then
            returnCode = -1
            logError("unable to move level ("..returnCode..")")
            return returnCode
        end
        if gainBonus and currentData.gainLife then
            addLife()
        end
        if gainBonus and currentData.gainShuriken then
            addShuriken()
        end
        if removeBonus and currentData.gainLife then
            removeLife()
        end
        if removeBonus and currentData.gainShuriken then
            removeShuriken()
        end
    end
    -- Physically move the card from its zone to the discard position.
    local levelsObject = getZoneObject(levelZone)
    if type(levelsObject) == "number" then
        returnCode = -2
        logError("unable to move level ("..returnCode..")")
        return returnCode
    end
    if levelsObject.tag == "Card" then
        levelsObject.setPositionSmooth(discardPosition, false, false)
    elseif levelsObject.tag == "Deck" then
        levelsObject.takeObject({
            position = discardPosition
        })
    end
end

--[[
-- Advance to the next level and gain the rewards.
--]]
function nextLevel()
    local discardPosition = levelDiscardPosition:copy()
    discardPosition.y = discardPosition.y + 1
    moveLevel(levelCurrentZone, discardPosition, true, false)
end

--[[
-- Move back to the previousLevel and lose the rewards.
--]]
function previousLevel()
    local discardPosition = levelCurrentPosition:copy()
    discardPosition.y = discardPosition.y + 1
    moveLevel(levelDiscardZone, discardPosition, false, true)
end

-- ============================================================================
-- Deck Sorting Functions
-- ============================================================================

--[[
-- Take the cards out of the numberDeck and recreate them in numeric order on the
-- discard pile.
--]]
function orderNumberDeck()
    local dropPosition = numberDiscardPosition:copy()
    dropPosition.y = 3
    return orderDeck(numberCards, numberDeck, dropPosition,
        function()
            log("Finished ordering number deck")
            local deckObjects = findInRadiusBy(numberDiscardPosition, 4,
                function(obj)
                    return (obj.tag == "Deck")
                end)
            if not deckObjects then return end
            numberDeck = deckObjects[1]
        end)
end

--[[
-- Take the cards out of the levelsDeck and recreate them in numeric order on the
-- discard pile.
--]]
function orderLevelDeck()
    local dropPosition = levelDiscardPosition:copy()
    dropPosition.y = 3
    return orderDeck(levelCards, levelDeck, dropPosition,
        function()
            log("Finished ordering level deck")
            local deckObjects = findInRadiusBy(levelDiscardPosition, 4,
                function(obj)
                    return (obj.tag == "Deck")
                end)
            if not deckObjects then return end
            levelDeck = deckObjects[1]
        end)
end

-- ============================================================================
-- Number Deck Functions
-- ============================================================================

--[[
-- Deal cards equal to the current level count to all of the seated players at the
-- table. This function assumes that the numbers deck has been recreated and
-- shuffled.
--]]
function dealNumberCards()
    local deck = getZoneObject(numberDeckZone)
    if type(deck) == "number" then
        logError("unable to deal cards (-1)")
        return -1
    end
    if deck.tag ~= "Deck" then
        logError("unable to deal cards (-2)")
        return -2
    end
    local current = currentLevel(levelCurrentZone)
    if type(current) == "number" then
        logError("unable to deal cards (-3)")
        return -3
    end
    deck.deal(current.value)
    playingRound = true
    return 0
end

--[[
-- Gather all of the number cards from the discard pile and move them to the normal
-- deck position. Shuffle the deck ready for the cards to be dealt out. This
-- function can receive an optional callback which will be called once all of the
-- cards have been pulled back into the deck and recreated.
--]]
function resetNumberCards()
    local discardObjs = numberDiscardZone.getObjects()
    if not discardObjs then
        logError("unable to reset number cards (-1)")
        return -1
    end
    -- Loop over discard pile. This could contain decks of cards.
    for i, card in ipairs(discardObjs) do
        if isFaceUp(card) then
            card.flip()
        end
        card.setPositionSmooth(numberDeckPosition, false, false)
    end
    -- Loop over loose cards anywhere in the game.
    for i, cardData in ipairs(numberCards) do
        local card = getObjectFromGUID(cardData.guid)
        if card then
            if isFaceUp(card) then
                card.flip()
            end
            card.setPosition(numberDiscardPosition)
            card.setPositionSmooth(numberDeckPosition, false, false)
        end
    end
    Wait.frames(function()
        local deck = getZoneObject(numberDeckZone)
        if type(deck) == "number" then
            logError("unable to reset number cards (-2)")
            return -2
        end
        deck.shuffle()
    end, 60)
    numberDiscardDeck = nil
    playingRound = false
    return 0
end

-- ============================================================================
-- Shuriken Voting Functions
-- ============================================================================

--[[
-- Handle the vote shuriken button. If this is the first time then we will
-- start a new vote. After 5 seconds, depending on the number of seated players
-- who have voted to use a shuriken, we will either stop the vote or use a
-- shuriken.
--]]
function voteShurikenHandler(obj, playerColor, altClick)
    if not shurikenVotes then
        shurikenVotes = {}
        Wait.time(checkShurikenVotes, 5, 0)
        broadcastToAll(playerColor.." has started a vote to use a shuriken.")
    else
        broadcastToAll(playerColor.." has voted to use a shuriken.")
    end
    castVote(playerColor, shurikenVotes)
end

--[[
-- Check whether all of the players have voted to use a shuriken. If they have
-- then remove a shuriken and reset the shuriken vote data.
--]]
function checkShurikenVotes()
    if not shurikenVotes then
       logWarn("no active shuriken vote")
       return -1
    end
    if allColorsVoted(shurikenVotes) then
        broadcastToAll("All players voted to use a shuriken")
        useShuriken()
    else
        broadcastToAll("Not all players voted to use a shuriken within the time limit. Cancelling vote.")
    end
    shurikenVotes = nil
end

--[[
-- Fetch the lowest card from the player hands and add it to the discard pile.
-- reorganise the deck when done.
-- TODO: This function is messy and shares common code with the number detection
--]]
function useShuriken()
    removeShuriken()
    playingRound = false
    -- Move the discard pile off to the side slightly. This will then get
    -- ordered along side any loose cards in players hands.
    local newDeckPosition = numberDiscardPosition:copy()
    newDeckPosition.x = newDeckPosition.x - 3
    local discardObject = getZoneObject(numberDiscardZone)
    if type(discardObject) ~= "number" and discardObject ~= nil then
        discardObject.setPosition(newDeckPosition)
    end
    -- Move the lowest cards from the players hand to the same position as the
    -- discard pile.
    Wait.frames(
        function()
            local players = seatedPlayers()
            if players ~= nil then
                for i, player in ipairs(players) do
                    local objects = player:getHandObjects()
                    local lowest = nil
                    local lowestObject = nil
                    if objects ~= nil then
                        for j, object in ipairs(objects) do
                            if object.tag == "Card" then
                                local card = numberCardsLookup[object.guid]
                                if card and lowest == nil or card.value < lowest.value then
                                    lowest = card
                                    lowestObject = object
                                end
                            end
                        end
                        if lowestObject ~= nil then
                            lowestObject.setPosition(newDeckPosition)
                        end
                    end
                end
            end
        end, 10)
    -- Reorder the discard pile so that everything is back into numeric order.
    local dropPosition = numberDiscardPosition:copy()
    dropPosition.y = 2
    Wait.frames(
        function()
            -- Maybe all the loose cards have just formed a new discard deck.
            -- Check for it using the typical zone object functions.
            if numberDiscardDeck == nil then
                local discardObjects = findInRadiusBy(newDeckPosition, 4,
                    function(obj)
                        if obj.tag == "Deck" or obj.tag == "Card" then
                            return true
                        end
                        return false
                    end)
                -- Shhh, just pretend this is the only object.
                local discardObject = discardObjects[1]
                if discardObject ~= nil and type(discardObject) ~= "number" then
                    log(discardObject)
                    if discardObject.tag == "Deck" then
                        numberDiscardDeck = discardObject
                        orderDeck(numberCards, numberDiscardDeck, dropPosition,
                            function()
                                -- Reset the discard deck so that the next tick can find
                                -- it and check the order again. No point in trying to
                                -- find it again here.
                                numberDiscardDeck = nil
                                playingRound = true
                            end)
                    elseif discardObject.tag == "Card" then
                        discardObject.setPositionSmooth(dropPosition, false, false)
                        playingRound = true
                    else
                        playingRound = true
                    end
                end
            else
                orderDeck(numberCards, numberDiscardDeck, dropPosition,
                    function()
                        -- Reset the discard deck so that the next tick can find
                        -- it and check the order again. No point in trying to
                        -- find it again here.
                        numberDiscardDeck = nil
                        playingRound = true
                    end)
            end
        end, 40)
end

--[[
-- Cast a vote for the player color within the vote table.
--]]
function castVote(playerColor, voteTable)
    if not playerColor then return -1 end
    if not voteTable then return -2 end
    voteTable[playerColor] = true
end

--[[
-- Check whether all of the players seated around the table have voted
-- on whether they should use a shuriken.
--]]
function allColorsVoted(voteTable)
    local seated = seatedPlayers()
    for i, player in ipairs(seated) do
        if not voteTable[player.color] then
            return false
        end
    end
    return true
end

-- ============================================================================
-- Util Functions
-- ============================================================================

--[[
-- Return the only object in this zone. If there is more than one object, this
-- function will fail and print out an error to the log.
--]]
function getZoneObject(zone)
    if not zone then
        logError("invalid zone object")
        return -1
    end
    local objs = zone.getObjects()
    if not objs then
        logWarn("no objects in zone")
        return -2
    end
    -- Check how many items are in the objs. If there is more than 1 then
    -- something is not right and we should bail out.
    local objCount = #objs
    if objCount > 1 then
        logWarn("multiple objects in zone - unable to distinguish")
        return -3
    end
    if objCount < 1 then
        logWarn("no objects in zone")
        return -2
    end
    return objs[1]
end

--[[
-- Reorder the decks in realtime based on the indices of the cards within the
-- cardTable argument. This function essentially loops over a card table and will
-- pull out cards from a deck based on the GUID of the object. It will then place
-- this onto the new position passed in as the discardPosition. It is important to
-- know that this function will very likely destroy the GUID of the old deck.
-- You can also pass in an optional callback function will which be called once the
-- deck has been completely reordered.
--]]
function orderDeck(cardTable, deck, movePosition, callback)
    if not cardTable then return -1 end
    if not deck then return -2 end
    if not movePosition then return -3 end
    local initialObjects = deck.getObjects()
    local deckSize = #initialObjects
    local last = nil
    local frameSleep = 5
    local frameSleepDelay = 0
    local callbackDelay = 100
    local x = 1
    for i, card in ipairs(cardTable) do
        local remaining = deckSize - x
        if remaining == 0 then frameSleepDelay = 5 end
        for j, obj in ipairs(initialObjects) do
            if obj.guid == card.guid then
                Wait.frames(function()
                    if remaining == 0 then
                        local c = getObjectFromGUID(card.guid)
                        c.setPositionSmooth(movePosition, false, false)
                        return
                    end
                    deck.takeObject({
                        position = movePosition,
                        guid = card.guid})
                end, (frameSleep * x) + frameSleepDelay)
                x = x + 1
            end
        end
    end
    -- Call the optional callback once the decks have been reordered.
    if callback then
        Wait.frames(function()
            callback()
        end, (frameSleep * deckSize) + frameSleepDelay + callbackDelay)
    end
    return 0
end

--[[
-- Check whether a deck is in either ascending or descending order based
-- on the "value" key in the decks lookup table. If the deck is not in order,
-- this function will return the last card that was in order.
--]]
function isDeckOrdered(cardTable, deck, ascending)
    if not deck then return -1 end
    if not cardTable then return -2 end
    local cards = deck.getObjects()
    if not cards then return -3 end
    local previous = nil
    for i, card in ipairs(cards) do
        local data = cardTable[card.guid]
        if not data then return -4 end
        if previous ~= nil then
            if ascending and previous.value < data.value then
                return false, previous
            elseif not ascending and previous.value > data.value then
                return false, previous
            end
        end
        previous = data
    end
    return true, nil
end

--[[
-- Find all of the objects within a given radius and return the result. This
-- function can also take in an optional filtering function which can remove
-- undesirable objects from the final list.
--]]
function findInRadiusBy(pos, radius, func, debug)
    local radius = (radius or 1)
    local objList = Physics.cast({
        origin=pos, direction={0,1,0}, type=2, size={radius,radius,radius},
        max_distance=0, debug=(debug or false)
    })
    local refinedList = {}
    for _, obj in ipairs(objList) do
        if func == nil then
            table.insert(refinedList, obj.hit_object)
        else
            if func(obj.hit_object) then
                table.insert(refinedList, obj.hit_object)
            end
        end
    end
    return refinedList
end

--[[
-- Check whether the passed in card is face up. This function works based on the
-- rotation value of the card. There is a small amount of leeway that is given to
-- the rotation of the object in order to account for some physics.
-- There is an optional tolerance parameter. This value should be within the range
-- of 0-90. It is ideal to use >0 though.
--]]
function isFaceUp(object, tolerance)
    if not object then return -1 end
    if not tolerance then tolerance = 20 end
    local rotation = object.getRotation()[3]
    if rotation < tolerance or rotation > (360 - tolerance) then
        return true
    end
    return false
end

--[[
-- Count the number of cards in the passed in card table that are currently face
-- up someone in the game. This function will not count decks. The cards have to
-- be laying relatively flat and individually accessible for them to be counted.
--]]
function faceUpCards(cardTable)
    local count = 0
    for i, card in ipairs(cardTable) do
        local object = getObjectFromGUID(card.guid)
        if object and isFaceUp(object) then
            count = count + 1
        end
    end
    return count
end

--[[
-- Flip over the cards in the card table to ensure that only the cards starting
-- from 1 and going until `count` will be face up. Any other cards will be turned
-- face down.
--]]
function ensureFaceUpCount(cardTable, count)
    for i, card in ipairs(cardTable) do
        local object = getObjectFromGUID(card.guid)
        if not object then return -1 end
        local faceUp = isFaceUp(object)
        if i <= count then
            -- Make sure that the card is facing up
            if not faceUp then
                object.flip()
            end
        else
            -- Make sure that the card is facing down
            if faceUp then
                object.flip()
            end
        end
    end
end

--[[
-- Gathers a list of all the seated players at the table.
--]]
function seatedPlayers()
    local players = Player.getPlayers()
    local seatedPlayers = {}
    local x = 1
    for i, player in ipairs(players) do
        if player.seated then
            seatedPlayers[x] = player
            x = x + 1
        end
    end
    return seatedPlayers
end

--[[
-- Log a warning to the in game log. This function will make sure that the text
-- is printed in blue.
--]]
function logWarn(var)
    logStyle("warn", "Blue")
    log("Warn: "..var, nil, "warn")
end

--[[
-- Log an error to the in game log. This function will make sure that the text
-- is printed in red.
--]]
function logError(var)
    logStyle("error", "Red")
    log("Error: "..var, nil, "error")
end

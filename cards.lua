function createCards()
    deck = {}
    suits = { 'diamonds', 'hearts', 'clubs', 'spades' }
    hand = {}
    playerPos = 3
    columns = {}

    for i = 1, 5 do
        local t = { x = 35 + ( ( i - 1 ) * 70 ), y = 0, w = 45, h = 250 }
        table.insert( columns, t )
    end

    for suit = 1, 4 do
        for rank = 2, 14 do
            local card = {}
            card.removeCard = false
            card.suit = suits[suit]
            card.rank = rank
            table.insert(deck, card)
        end
    end
end

function removeBigHeartsDiamonds()
    for i = #deck, 1, -1 do
        if deck[i].suit == 'diamonds' or deck[i].suit == 'hearts' then
            if deck[i].rank > 10 then
                table.remove(deck, i)
            end
        end
    end
end

function copyDeck()
    copyDeck = {}
    for i = 1, #deck do
        table.insert(copyDeck, deck[i])
    end
  
    math.randomseed(os.time()) 
    
    -- remove 43 cards (not sure why it stops at 44 by default)
    shuffleDeck = {}
    repeat 
        for i = #copyDeck, 1, -1 do
            local randCard = 1 + math.floor( math.random( #copyDeck ) )
            table.insert( shuffleDeck, copyDeck[randCard] )
            table.remove( copyDeck, randCard )
        end
    until #copyDeck == 1 

    -- remove the last card
    table.insert( shuffleDeck, copyDeck[1] )
    copyDeck = {}
end

function dealCards( num )
    for i = 1, num  + 1 do
        if i == 3 then 
            table.insert( hand, { suit = 'joker', rank = 0 } )
        else
            table.insert( hand, shuffleDeck[ 1 ] )
            table.remove( shuffleDeck, 1 )
        end
    end

    hand[1] = { suit = 'diamonds', rank = 7 }
    hand[2] = { suit = 'clubs', rank = 8 }
    hand[3] = { suit = 'joker', rank = 0 }
    hand[4] = { suit = 'spades', rank = 9 }
    hand[5] = { suit = 'hearts', rank = 10 }

    print( #hand )
end

function drawCards()
    for i = 1, #hand do
        if hand[i].suit == 'joker' then
            --nothing
        elseif hand[i].suit == 'clubs' then
            love.graphics.draw( sprSkeleton_small.spritesheet, sprSkeleton_small.quads[ 1 ], columns[i].x, 70 ) 
        elseif hand[i].suit == 'spades' then
            love.graphics.draw( sprSlime_small.spritesheet, sprSlime_small.quads[ 1 ], columns[i].x, 70 ) 
        elseif hand[i].suit == 'hearts' then
            love.graphics.draw( sprRedChest.spritesheet, sprRedChest.quads[ 1 ], columns[i].x, 120 ) 
        elseif hand[i].suit == 'diamonds' then
            love.graphics.draw( sprGoldChest.spritesheet, sprGoldChest.quads[ 1 ], columns[i].x, 120 ) 
        end

    end
end

function checkColumn()
    for i = 1, #columns do
        playerPos = 0
        if ( player.x - 40 ) + 30 >= columns[i].x and
            ( player.x - 20 ) <= columns[i].x + columns[i].w then
            playerPos = i
            return
        end
    end
end

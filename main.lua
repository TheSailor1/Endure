-- REMOVE BEFORE SHIPPING
-- ***********************
develop = false
if develop then
    --local
    nest = require("nest").init({ console = "3ds", scale= 1, emulateJoystick = true })
end
require( 'cards' )
require( 'animations' )

function love.load()
    -- REMOVE BEFORE SHIPPING
    -- ***********************
    if develop then
        --love.window.setPosition( 400, 200, 2)
        --love.window.setTitle( 'ENDURE' )
    end
    
    touches = {}

    top = love.graphics.newImage( "assets/Dungeon2.png" )
    btm = love.graphics.newImage( "assets/bottomScreen.png" )

    -- audio
    sfxClick = love.audio.newSource( 'assets/click.ogg', 'static' )
    sfxAttack = love.audio.newSource( 'assets/Stab.ogg', 'static' )
    sfxEquip = love.audio.newSource( 'assets/Equip.ogg', 'static' )
    sfxWalk = love.audio.newSource( 'assets/Walking3.ogg', 'static' )
    sfxHit = love.audio.newSource( 'assets/Hit.ogg', 'static' )

    songBg = love.audio.newSource( 'assets/Evil.ogg', 'stream' )


    createCards()
    removeBigHeartsDiamonds()
    copyDeck()
    dealCards( 4 )
 
    numJoysticks = love.joystick.getJoystickCount()

    player = {}
    player.x, player.y  = love.graphics.getDimensions()
    player.x = player.x / 2
    player.y = player.y / 2
    player.speed = 140
    player.state = 'idle'
    player.equip = 'fists'
    player.nextItem = 'fists'
    player.weaponRank = 1
    player.weaponStrength = 3
    player.maxHP = 20
    player.hp = player.maxHP

    --sprites
    sprPlayer_up = newAnimation( love.graphics.newImage( 'assets/Walk-up.png' ), 128, 128, 1 )
    sprPlayer_left = newAnimation( love.graphics.newImage( 'assets/Walk-left.png' ), 128, 128, 1 )
    sprPlayer_idle = newAnimation( love.graphics.newImage( 'assets/Walk-idle.png' ), 128, 128, 1 )
    sprPlayer_idle_dagger = newAnimation( love.graphics.newImage( 'assets/Walk-idle-dagger.png' ), 128, 128, 1 )
    sprPlayer_down = newAnimation( love.graphics.newImage( 'assets/Walk-down.png' ), 128, 128, 1 )
    sprFPPlayer_fist = newAnimation( love.graphics.newImage( 'assets/FP_Player-fists.png' ), 240, 168, 2.8 )
    sprFPPlayer_dagger = newAnimation( love.graphics.newImage( 'assets/FP_Player-dagger.png' ), 240, 168, 1.8 )
    sprFPPlayer_stab = newAnimation( love.graphics.newImage( 'assets/FP_Player-stab.png' ), 165, 166, 0.3 )
    sprFPPlayer_equip = newAnimation( love.graphics.newImage( 'assets/FP_Player-equip.png' ), 240, 168, 0.3 )
    sprCandles = newAnimation( love.graphics.newImage( 'assets/Candles.png' ), 187, 106, 1 )
    sprSlime = newAnimation( love.graphics.newImage( 'assets/SlimeEyePop.png' ), 144, 140, 1.4 )
    sprSlime_small = newAnimation( love.graphics.newImage( 'assets/SlimeSmall.png' ), 61, 73, 1 )
    sprSkeleton = newAnimation( love.graphics.newImage( 'assets/Skeleton.png' ), 80, 125, 1 )
    sprSkeleton_small = newAnimation( love.graphics.newImage( 'assets/SkeletonSmall.png' ), 48, 67, 1 )
    sprText_equip = newAnimation( love.graphics.newImage( 'assets/equip.png' ), 75, 16, 1 )
    sprText_numbers = newAnimation( love.graphics.newImage( 'assets/numbers.png' ), 15, 14, 1 )
    sprMiceSpider = newAnimation( love.graphics.newImage( 'assets/MiceOverlay.png' ), 400, 240, 1 )
    sprAxe = newAnimation( love.graphics.newImage( 'assets/Axe.png' ), 65, 85, 1 )
    sprPotion = newAnimation( love.graphics.newImage( 'assets/Potion.png' ), 76, 84, 1 )
    sprDoor_closed = newAnimation( love.graphics.newImage( 'assets/DoorClosed.png' ), 83, 130, 1 )
    sprRedChest = newAnimation( love.graphics.newImage( 'assets/RedChest.png' ), 40, 32, 1 )
    sprGoldChest = newAnimation( love.graphics.newImage( 'assets/GoldChest.png' ), 40, 32, 1 )
    sprIcons = newAnimation( love.graphics.newImage( 'assets/Icons.png' ), 15, 12, 1 )


    animationTimer = 0
    t = 0
end

function love.update(dt)
    t = t + 1

    songBg:play()

    joysticks = love.joystick.getJoysticks()
    
    actionA = false

    if #joysticks > 0  then
        padLeft = joysticks[1]:isGamepadDown( 'dpleft' ) 
        padRight = joysticks[1]:isGamepadDown( 'dpright' ) 
        padUp = joysticks[1]:isGamepadDown( 'dpup' ) 
        padDown = joysticks[1]:isGamepadDown( 'dpdown' ) 
        bumpLeft = joysticks[1]:isGamepadDown( 'leftshoulder' )
        bumpRight = joysticks[1]:isGamepadDown( 'rightshoulder' )
        actionA = joysticks[1]:isGamepadDown( 'a' )

        directionX = joysticks[1]:getGamepadAxis( 'leftx' )
        directionY = joysticks[1]:getGamepadAxis( 'lefty' )

        player.state = 'idle'

        
        if directionX < -0.5 then
            player.x = player.x - player.speed * dt
            player.state = 'left'
        elseif directionX > 0.5 then
            player.x = player.x + player.speed * dt
            player.state = 'right'
        end

        if directionY > 0.5 then
                if develop == true then
                    if player.y < 240 then
                        player.y = player.y + player.speed * dt
                        player.state = 'down'
                    end
                else
                    if player.y > 100 then
                        player.y = player.y - player.speed * dt
                        player.state = 'up'
                    end
                end
        elseif directionY < -0.5 then
                if develop == true then
                    if player.y > 100 then
                        player.y = player.y - player.speed * dt
                        player.state = 'up'
                    end
                else
                    if player.y < 240 then
                        player.y = player.y + player.speed * dt
                        player.state = 'down'
                    end
                end
        else 
            directionY = 0
        end

        if padLeft then
            player.x = player.x - player.speed * dt
            player.state = 'left'
        elseif padRight then
            player.x = player.x + player.speed * dt
            player.state = 'right'
        end

        if padUp then
            if player.y > 100 then
                player.y = player.y - player.speed * dt
                player.state = 'up'
            end
        elseif padDown then
            player.y = player.y + player.speed * dt
            player.state = 'down'
        end
    end

    --[[
    kLeft = love.keyboard.isDown( 'left' )
    kRight = love.keyboard.isDown( 'right' )
    kUp = love.keyboard.isDown( 'up' )
    kDown = love.keyboard.isDown( 'down' )

    if kLeft then
        player.x = player.x - player.speed * dt
        player.state = 'left'
    elseif kRight then
        player.x = player.x + player.speed * dt
        player.state = 'right'
    elseif kUp then
        player.y = player.y - player.speed * dt
        player.state = 'up'
    elseif kDown then
        player.y = player.y + player.speed * dt
        player.state = 'down'
    else
        player.state = 'idle'
    end

    if player.state ~= 'idle'  then 
        sfxWalk:play() 
    else
        sfxWalk:stop()
    end
    ]]--


    if player.x < 40 then player.x = 40 end
    if player.x > 400 then player.x = 400 end
    if player.y < -5 then player.y = -5 end
    if player.y > 180 then player.y = 180 end

    checkColumn()

    if player.equip == 'fists' then 
        bumpLeft = true
        bumpRight = false
    elseif player.equip == 'dagger' then
        bumpLeft = false
        bumpRight = true
    elseif player.equip == 'stab' then
        actionA = true
    end

    local sprPlayer
    local sprPlayer2

    if player.state == 'up' then
        sprPlayer = sprPlayer_up
    elseif player.state == 'down' then
        sprPlayer = sprPlayer_down
    elseif player.state == 'left' then
        sprPlayer = sprPlayer_left
    elseif player.state == 'right' then
        sprPlayer = sprPlayer_left
    else
        if player.equip == 'fists' then
            sprPlayer = sprPlayer_idle
        elseif player.equip == 'dagger' then
            sprPlayer = sprPlayer_idle_dagger
        elseif player.equip == 'stab' then
            sprPlayer = sprPlayer_idle_dagger
        elseif player.equip == 'equip' then
            sprPlayer = sprPlayer_idle_dagger
        end
    end

    if player.equip == 'fists' then
        sprPlayer2 = sprFPPlayer_fist
    elseif player.equip == 'dagger' then
        sprPlayer2 = sprFPPlayer_dagger
    elseif player.equip == 'stab' then
        sprPlayer2 = sprFPPlayer_stab
    elseif player.equip == 'equip' then
        sprPlayer2 = sprFPPlayer_equip
    end

    sprPlayer.currentTime = sprPlayer.currentTime + dt
    if sprPlayer.currentTime >= sprPlayer.duration then
        sprPlayer.currentTime = sprPlayer.currentTime - sprPlayer.duration
    end
    sprPlayer2.currentTime = sprPlayer2.currentTime + dt
    if sprPlayer2.currentTime >= sprPlayer2.duration then
        sprPlayer2.currentTime = sprPlayer2.currentTime - sprPlayer2.duration
    end
    
    local candles = sprCandles
    candles.currentTime = candles.currentTime + dt
    if candles.currentTime >= candles.duration then
       candles.currentTime = candles.currentTime - candles.duration
    end

    local slime = sprSlime
    slime.currentTime = slime.currentTime + dt
    if slime.currentTime >= slime.duration then
       slime.currentTime = slime.currentTime - slime.duration
    end
end

function love.draw(screen)
    local sprPlayer
    local sprPlayer2
    local flipX = 1

    --pixel perfet
    love.graphics.setDefaultFilter('nearest', 'nearest')

    if player.state == 'up' then
        sprPlayer = sprPlayer_up
    elseif player.state == 'down' then
        sprPlayer = sprPlayer_down
    elseif player.state == 'left' then
        sprPlayer = sprPlayer_left
    elseif player.state == 'right' then
        sprPlayer = sprPlayer_left
        flipX = -1
    else
        if player.equip == 'fists' then
            sprPlayer = sprPlayer_idle
        elseif player.equip == 'dagger' then
            sprPlayer = sprPlayer_idle_dagger
        elseif player.equip == 'stab' then
            sprPlayer = sprPlayer_idle_dagger
        elseif player.equip == 'equip' then
            sprPlayer = sprPlayer_idle_dagger
        end
    end
    local spriteNum = math.floor( sprPlayer.currentTime / sprPlayer.duration * #sprPlayer.quads ) + 1
    
    if animationTimer > 0 then
        animationTimer = animationTimer - 1
    else
        animationTimer = 0
        player.equip = player.nextItem
    end

    if player.equip == 'fists' then
        sprPlayer2 = sprFPPlayer_fist
    elseif player.equip == 'dagger' then
        sprPlayer2 = sprFPPlayer_dagger
    elseif player.equip == 'stab' then
        sprPlayer2 = sprFPPlayer_stab
    elseif player.equip == 'equip' then
        sprPlayer2 = sprFPPlayer_equip
    end

    local spriteNum2 = math.floor( sprPlayer2.currentTime / sprPlayer2.duration * #sprPlayer2.quads ) + 1
    local slimeNum = math.floor( sprSlime.currentTime / sprSlime.duration * #sprSlime.quads ) + 1

    -- TOP SCREEN
    if screen ~= "bottom" then
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.clear( 1, 1, 1 )
        love.graphics.draw( top, 0, 0 )
        
        -- enemies
        drawCards()

        -- player
        love.graphics.draw( sprPlayer.spritesheet, sprPlayer.quads[ spriteNum ], player.x - 24, player.y - 24, 0, flipX, 1, 64, 0 )
        
        --Mice Spider overlay
        love.graphics.draw( sprMiceSpider.spritesheet, sprMiceSpider.quads[ 1 ], 0, 0 )

        love.graphics.print( tostring( love.timer.getFPS() ) )

    end

    local candles = sprCandles
    local candleNum = math.floor( candles.currentTime / candles.duration * #candles.quads ) + 1

    -- BOTTOM SCREEN
    if screen == "bottom" then
        love.graphics.clear( 0, 0, 0, 1 )
        
        love.graphics.draw( btm, 0, 0 )
        
        local tens,ones = nil, nil
        
        --Enemy
        if player.state == 'idle' or player.state == 'up' then
            if playerPos <= 5  and playerPos > 0 then
                love.graphics.draw( candles.spritesheet, candles.quads[ candleNum ], 0, 68, 0, 1, 1, 0, 0 )
                for i = 1, #hand do
                    if hand[playerPos].suit == 'diamonds' then
                        love.graphics.draw( sprAxe.spritesheet, sprPotion.quads[ 1 ], 45 + ( math.sin(t * 0.01) * 4 ), 35 + ( math.cos(t * 0.07) * 3 ), 0, 1, 1, 0, 0 )
                    elseif hand[playerPos].suit == 'hearts' then
                        love.graphics.draw( sprPotion.spritesheet, sprPotion.quads[ 1 ], 50 + ( math.sin(t * 0.01) * 4 ), 35 + ( math.cos(t * 0.07) * 3 ), 0, 1, 1, 0, 0 )
                    elseif hand[playerPos].suit == 'spades' then
                        love.graphics.draw( sprSlime.spritesheet, sprSlime.quads[ slimeNum ], 10, 25, 0, 1, 1, 0, 0 )
                    elseif hand[playerPos].suit == 'clubs' then
                        love.graphics.draw( sprSkeleton.spritesheet, sprSkeleton.quads[ 1 ], 55, 35, 0, 1, 1, 0, 0 )
                    elseif hand[playerPos].suit == 'joker' then
                        love.graphics.draw( sprDoor_closed.spritesheet, sprDoor_closed.quads[ 1 ], 50, 14, 0, 1, 1, 0, 0 )
                    end
                end


                local col, ico
                
                if hand[ playerPos ].suit == 'joker' then
                    --nothing
                elseif hand[ playerPos ].suit == 'spades' or hand[ playerPos ].suit == 'clubs' then
                    if player.equip ~= 'fists' then
                        -- Can player use weapon
                        if player.weaponRank >= hand[ playerPos ].rank then

                            if player.weaponStrength >= hand[ playerPos].rank then
                                -- rank of enemy
                                col = { 255 / 255, 163 / 255, 0 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( hand[ playerPos ].rank, 20, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  3  ], 0, 10 )
                                -- hp of enemy (pulled from rank)
                                col = { 0 / 255, 228 / 255, 54 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( hand[ playerPos ].rank, 80, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  4  ], 60, 10 )
                            else
                                -- rank of enemy
                                col = { 255 / 255, 163 / 255, 0 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( hand[ playerPos ].rank, 20, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  3  ], 0, 10 )
                                -- hp of enemy (pulled from rank)
                                col = { 0 / 255, 228 / 255, 54 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( player.weaponStrength, 60, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  4  ], 40, 10 )
                                -- damage from the enemy 
                                col = { 195 / 255, 0, 76 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( hand[ playerPos ].rank - player.weaponStrength, 80, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  1  ], 60, 10 )
                            end

                        else
                            -- Weapon rank too low to use
                                -- rank of enemy
                                col = { 255 / 255, 163 / 255, 0 / 255, 1 }
                                love.graphics.setColor( col )
                                love.graphics.print( hand[ playerPos ].rank, 20, 10 )
                                love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  3  ], 0, 10 )
                                love.graphics.print( "YOU CAN'T ATTACK", 40, 10 )

                        end


                        -- if players weapon is weaker than enemy
                    else
                        col = { 195 / 255, 0, 76 / 255, 1 }
                        love.graphics.setColor( col )
                        love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[  1  ], 0, 10 )
                        love.graphics.print( hand[ playerPos ].rank, 20, 10 )
                    end
                end


                --[[
                if hand[ playerPos ].suit == 'joker' then
                    col = { 0, 0, 0, 0 }
                    ico = nil
                elseif hand[ playerPos ].suit == 'spades' or hand[ playerPos ].suit == 'clubs' then
                    if player.equip == 'fists' then
                        ico = { { 1 } }
                    else
                        ico = { { 3, hand[ playerPos ].rank }, { 4, hand[ playerPos ].rank } }
                        col = { 255 / 255, 255 / 255, 255 / 255, 1 }
                    end
                elseif hand[ playerPos ].suit == 'hearts' then
                    col = { 28 / 255, 94 / 255, 172 / 255, 1 }
                    ico = { { 4 } }
                elseif hand[ playerPos ].suit == 'diamonds' then
                    ico = { { 3 } }
                end

                if ico ~= nil then
                    for i = 1, #ico do
                if ico[ i ][ 2 ] >= 10 then
                    tens = tonumber( tostring( string.sub( ico[ i ][ 2 ], 1, 1 ) ) )
                    ones = tonumber( tostring( string.sub( ico[ i ][ 2 ], 2, 2 ) ) )
                    if ones == 0 then ones = 10 end
                else
                    tens = 10
                    ones = tonumber( tostring( string.sub( ico[ i ][ 2 ], 1, 1 ) ) )
                    if ones == 0 then ones = 10 end
                end

                --tens
                love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ tens ], 25, 20 )
                --ones
                love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ ones ], 40, 20 )
                
                        love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[ ico[ i ][ 1 ] ], 5, 20 )
                    end
                end
                ]]--

                love.graphics.setColor( 1, 1, 1, 1 )
            end
        end


        -- player
        love.graphics.draw( sprPlayer2.spritesheet, sprPlayer2.quads[ spriteNum2 ], 14, 240 - 168, 0, 1, 1, 24, 0 )

        love.graphics.setColor( 0, 0, 0, 0.4 )
        if bumpLeft == true then
            love.graphics.rectangle( 'fill', 204, 25, 48, 58 )
        end
        if bumpRight == true then
            love.graphics.rectangle( 'fill', 256, 25, 48, 58 )
        end
        if actionA == true then
            love.graphics.rectangle( 'fill', 203, 88, 101, 58 )
        end
        love.graphics.setColor( 1, 1, 1, 1 )

        -- UI STUFF
        love.graphics.draw( sprText_equip.spritesheet, sprText_equip.quads[1], 220, 5 )

        local tens,ones = nil, nil


        -- hp icon
        love.graphics.setColor( 0, 228 / 255, 54 / 255, 1 )
        love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[ 4 ], 245, 185 )
        if player.hp >= 10 then
            tens = tonumber( tostring( string.sub( player.hp, 1, 1 ) ) )
            ones = tonumber( tostring( string.sub( player.hp, 2, 2 ) ) )
            if ones == 0 then ones = 10 end
        else
            tens = 10
            ones = tonumber( tostring( string.sub( player.hp, 1, 1 ) ) )
            if ones == 0 then ones = 10 end
        end
        --tens
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ tens ], 237, 205 )
        --ones
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ ones ], 252, 205 )
        

        -- rank of weapon
        love.graphics.setColor( 255 / 255, 163 / 255, 0 / 255, 1 )
        love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[ 3 ], 225, 135 )
        if player.weaponRank >= 10 then
            tens = tonumber( tostring( string.sub( player.weaponRank, 1, 1 ) ) )
            ones = tonumber( tostring( string.sub( player.weaponRank, 2, 2 ) ) )
            if ones == 0 then ones = 10 end
        else
            tens = 10
            ones = tonumber( tostring( string.sub( player.weaponRank, 1, 1 ) ) )
            if ones == 0 then ones = 10 end
        end
        --tens
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ tens ], 220, 160 )
        --ones
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ ones ], 235, 160 )
        
        
        -- strength of weapon
        love.graphics.setColor( 195 / 255, 0 / 255, 76 / 255, 1 )
        love.graphics.draw( sprIcons.spritesheet, sprIcons.quads[ 2 ], 265, 135 )
        if player.weaponStrength >= 10 then
            tens = tonumber( tostring( string.sub( player.weaponStrength, 1, 1 ) ) )
            ones = tonumber( tostring( string.sub( player.weaponStrength, 2, 2 ) ) )
            if ones == 0 then ones = 10 end
        else
            tens = 10
            ones = tonumber( tostring( string.sub( player.weaponStrength, 1, 1 ) ) )
            if ones == 0 then ones = 10 end
        end
        --tens
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ tens ], 260, 160 )
        --ones
        love.graphics.draw( sprText_numbers.spritesheet, sprText_numbers.quads[ ones ], 275, 160 )

        love.graphics.print( tostring( love.timer.getFPS() ) )

    end -- /bottomScreen
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == 'z' then
        if animationTimer == 0 then
            animationTimer = 50
            player.nextItem = 'fists'
            player.equip = 'equip'
            sfxEquip:play()
        end
    elseif key == 'x' then
        if animationTimer == 0 then
            animationTimer = 50
            player.nextItem = 'dagger'
            player.equip = 'equip'
            sfxEquip:play()
        end
    elseif key == 'space' then
        if playerPos > 0  and animationTimer == 0 then
            if hand[ playerPos ].suit == 'spades' or hand[ playerPos ].suit == 'clubs' then
                actionA = true
                animationTimer = 50
                player.nextItem = player.equip
                player.equip = 'stab'
                sfxAttack:stop()
                sfxAttack:play()
                sfxHit:play()
            end
        end
    end
end

function love.gamepadpressed(joystick, button)
    if joystick == joysticks[1] then 
        if button == 'back' then
            love.event.quit()
        end

        if button == 'leftshoulder' and player.equip ~= 'fists' then
            animationTimer = 50
            player.nextItem = 'fists'
            player.equip = 'equip'
            sfxEquip:play()
        elseif button == 'rightshoulder' and player.equip ~= 'dagger' then
            animationTimer = 50
            player.nextItem = 'dagger'
            player.equip = 'equip'
            sfxEquip:play()
        elseif button == 'a' and animationTimer == 0 and playerPos ~= 0 then
            if hand[ playerPos ].suit == 'spades' or hand[ playerPos ].suit == 'clubs' then
                actionA = true
                animationTimer = 50
                player.nextItem = player.equip
                player.equip = 'stab'
                sfxAttack:stop()
                sfxAttack:play()
                sfxHit:play()
            end
        end
    end
end



function love.touchpressed(id, x, y, dx, dy, pressure)
    touches[id] = {x = x, y = y}

    -- Equip Fists
    if x >= 204 and
        x <= 204 + 48 and
        y >= 25 and
        y <= 25 + 58 and animationTimer == 0 then
        bumpLeft = true
        bumpRight= false
        animationTimer = 50
        player.nextItem = 'fists'
        player.equip = 'equip'
        sfxEquip:play()
    end

    -- Equip Weapon
    if x >= 256 and
        x <= 246 + 48 and
        y >= 25 and
        y <= 25 + 58 and animationTimer == 0 then
        bumpLeft = false
        bumpRight = true
        animationTimer = 50
        player.nextItem = 'dagger'
        player.equip = 'equip'
        sfxEquip:play()
    end

    -- Attack / Action
    if x >= 203 and
        x <= 203 + 101 and
        y >= 88 and
        y <= 88 + 58 and animationTimer == 0 then
        -- Check what the player is trying to attack / action with
        if hand[ playerPos ].suit == 'spades' or hand[ playerPos ].suit == 'clubs' then
            actionA = true
            animationTimer = 50
            player.nextItem = player.equip
            player.equip = 'stab'
            sfxAttack:stop()
            sfxAttack:play()
            sfxHit:play()
        else
            sfxEquip:play()
        end
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    touches[id] = nil
    --bumpLeft = false
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    touches[id] = {x = x, y = y}
end


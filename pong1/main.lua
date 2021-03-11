push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


function love.load()
	love.graphics.setDefaultFilter('nearest','nearest')
	math.randomseed(os.time())
	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)
	victoryFont = love.graphics.newFont('font.ttf', 16)
	love.graphics.setFont(smallFont)
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})


	winningplayer=0
	player1score = 0
	player2score = 0
	player1Y = 30
	player2Y = VIRTUAL_HEIGHT-50
	player1=Paddle(10, 30, 5, 20) 
	player2=Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20) 

	ball=Ball(VIRTUAL_WIDTH/2-2, VIRTUAL_HEIGHT/2-2, 4, 4)

	gameState='start'
end

function love.update(dt)
	if ball:collides(player1) then
		ball.dx=-ball.dx*1.25
		ball.x=player1.x+5
			if ball.dy<0 then
				ball.dy=-math.random(30,160)
			else
				ball.dy=math.random(30,160)
			end
	end	
	if ball:collides(player2) then
		ball.dx=-ball.dx*1.25
		ball.x=player2.x-4
			if ball.dy<0 then
				ball.dy=-math.random(10,100)
			else
				ball.dy=math.random(10,100)
			end
	end	

	if ball.y<=0 then
		ball.y=0
		ball.dy=-ball.dy
	end
	if ball.y>=VIRTUAL_HEIGHT-4 then
		ball.y=VIRTUAL_HEIGHT-4
		ball.dy=-ball.dy
	end

	if ball.x<0 then
		player2score=player2score+1
		ball:reset()
	end
	if ball.x>VIRTUAL_WIDTH then
		player1score=player1score+1
		ball:reset()
	end


	if love.keyboard.isDown('w') then
		player1.dy=-PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy=PADDLE_SPEED
	else
		player1.dy=0
	end
	
	if love.keyboard.isDown('up') then
		player2.dy=-PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy=PADDLE_SPEED
	else
		player2.dy=0
	end

	if gameState=='beforeStart'then
		gameState='start'
		player1score=0
		player2score=0
		winningplayer=0
		
	end

	if player1score<5 and player2score<5 then

	
		if gameState=='play' then
			ball:update(dt)
		end

		elseif player1score==5 then
			gameState='done'
			winningplayer=1
		elseif player2score==5 then
			gameState='done'
			winningplayer=2

		end
	player1:update(dt)
	player2:update(dt)




end



function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key =='enter' or key == 'return' then
		if gameState=='start' then
			gameState='play'
			
		elseif gameState=='play' then
			gameState='start'
			ball:reset()
			
		end
	elseif key =='space' then 
		gameState='beforeStart'
		ball:reset()
	end
end

function love.draw()
	push:apply('start')

	love.graphics.clear(40/255,45/255,52/255,255/255)
	
	if gameState=='start' then
		love.graphics.setFont(smallFont)
    	love.graphics.printf('Hello Pong!\n\nPress ENTER to start or pause game', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState=='done'then
    	love.graphics.setFont(victoryFont)
    	love.graphics.printf('Player ' .. tostring(winningplayer) .. ' wins!', 0, 120, VIRTUAL_WIDTH, 'center')
    	love.graphics.setFont(smallFont)
    	love.graphics.printf('Hello Pong!\n\nPress SPACE to restart game', 0, 20, VIRTUAL_WIDTH, 'center')

    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2score),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGHT/3)
 

    player1:render()
    player2:render()
    ball:render()
    push:apply('end')
end
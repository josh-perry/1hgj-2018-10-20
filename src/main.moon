score = 0
failed = false
peachy = require("libs/peachy")
lume = require("libs/lume")

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()

timeLeft = 5
maxTime = 5
outOfTime = false

local wirecutter

currentWire = lume.randomchoice({"red", "blue", "green"})
local currentWireHint

wireColours = {
	red: {1, 0, 0},
	green: {0, 1, 0},
	blue: {0, 0, 1}
}

wires = {}

class Wirecutter
	new: =>
		@x = 0
		@y = 0

		@sprite = peachy.new("img/wirecutter.json", love.graphics.newImage("img/wirecutter.png"), "hold")

	draw: =>
		@sprite\draw(@x, @y)

	update: (dt) =>
		@x, @y = love.mouse.getPosition!

		if @cutting
			@sprite\setTag("cut")
		else
			@sprite\setTag("hold")

		@sprite\update(dt)

class Wire
	new: (colourName, wires) =>
		@colourName = colourName

		if @colourName == "red"
			@colour = {1, 0, 0}

		if @colourName == "green"
			@colour = {0, 1, 0}

		if @colourName == "blue"
			@colour = {0, 0, 1}

		goodX = false
		while not goodX
			goodX = true

			@x1 = love.math.random(50, WIDTH-50)

			for i, v in ipairs(wires)
				if math.abs(@x1 - v.x1) <= 32
					goodX = false

		@y1 = 0
		@x2 = @x1
		@y2 = HEIGHT

	draw: =>
		love.graphics.setColor(@colour)
		love.graphics.line(@x1, @y1, @x2, @y2)

newWire = ->
	wires = {}

	currentWire = lume.randomchoice({"red", "blue", "green"})
	table.insert(wires, Wire("red", wires))
	table.insert(wires, Wire("green", wires))
	table.insert(wires, Wire("blue", wires))

	currentWireHint = wireColours[currentWire]

	if score >= 5
		currentWireHint = lume.randomchoice({wireColours["red"], wireColours["green"], wireColours["blue"]})

love.load = ->
	love.mouse.setVisible(false)
	love.graphics.setFont(love.graphics.newFont(28))

	wirecutter = Wirecutter!
	love.graphics.setBackgroundColor(1, 1, 1)

	love.graphics.setLineWidth(4)
	love.graphics.setLineStyle("rough")

	table.insert(wires, Wire("red", wires))
	table.insert(wires, Wire("green", wires))
	table.insert(wires, Wire("blue", wires))

	currentWireHint = wireColours[currentWire]

love.draw = ->
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(score, 0, 10, WIDTH, "center")

	if outOfTime
		love.graphics.printf("Too slow!", 0, HEIGHT/2, WIDTH, "center")
		return

	if failed
		love.graphics.printf(string.format("You were supposed to cut the %s wire, you idiot!", currentWire), 0, HEIGHT/2, WIDTH, "center")
		return

	for i, v in ipairs(wires)
		v\draw!

	love.graphics.setColor(1, 1, 1)
	wirecutter\draw!

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, HEIGHT-50, WIDTH*(timeLeft/maxTime), 16)

	love.graphics.setColor(1, 1, 1)
	text = {
		{0, 0, 0, 1},
		"Cut the ",

		currentWireHint,
		currentWire,

		{0, 0, 0, 1},
		" wire!"
	}

	love.graphics.printf(text, 0, HEIGHT/2, WIDTH, "center")

love.update = (dt) ->
	if failed return

	if timeLeft <= 0
		failed = true
		outOfTime = true

	wirecutter\update(dt)
	wirecutter.cutting = love.mouse.isDown(1)

	timeLeft -= dt

love.mousereleased = (x, y) ->
	if failed
		love.event.quit("restart")
		return

	for i, v in ipairs(wires)
		if math.abs(x - v.x1) <= 16
			if v.colourName == currentWire
				newWire()
				score += 1

				if score >= 5
					maxTime = 4

				if score >= 10
					maxTime = 3

				if score >= 15
					maxTime = 2

				timeLeft = maxTime
				break
			else
				failed = true
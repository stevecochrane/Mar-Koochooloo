local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local classicImage = gfx.image.new("images/options-classic")
local classicSelectedImage = gfx.image.new("images/options-classic-selected")
local manualImage = gfx.image.new("images/options-manual")
local manualSelectedImage = gfx.image.new("images/options-manual-selected")

class("OptionsControl").extends(gfx.sprite)

function OptionsControl:init()
	OptionsControl.super.init(self)

	self.appleSprite = nil
	self.classicSprite = nil
	self.control = "speed"
	self.manualSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 25)
	self:moveTo(48, 80)

	self.classicSprite = gfx.sprite.new(classicSelectedImage)
	self.classicSprite:setCenter(0, 0)
	self.classicSprite:moveTo(self.x + 122, self.y)
	self.classicSprite:add()

	self.manualSprite = gfx.sprite.new(manualSelectedImage)
	self.manualSprite:setCenter(0, 0)
	self.manualSprite:moveTo(self.x + 207, self.y)
	self.manualSprite:add()
end

function OptionsControl:setControl(newControl)
	self.control = newControl
	self:updateDisplay()
end

function OptionsControl:toggle()
	if self.control == "speed" then
		self.control = "puzzle"
	else
		self.control = "speed"
	end
	self:updateDisplay()
end

function OptionsControl:updateDisplay()
	if self.control == "speed" then
		self.classicSprite:setImage(classicSelectedImage)
		self.manualSprite:setImage(manualImage)
	else
		self.classicSprite:setImage(classicImage)
		self.manualSprite:setImage(manualSelectedImage)
	end

	self:markDirty()
end

function OptionsControl:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y + 4)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsControl:deselect()
	self.selected = false
	self.appleSprite:remove()
	self:markDirty()
end

function OptionsControl:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Control", 24, 3)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

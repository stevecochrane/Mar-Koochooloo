local gfx <const> = playdate.graphics

local classicImage = gfx.image.new("images/options-classic")
local classicSelectedImage = gfx.image.new("images/options-classic-selected")
local foodImage = gfx.image.new("images/food")
local gentleImage = gfx.image.new("images/options-gentle")
local gentleSelectedImage = gfx.image.new("images/options-gentle-selected")

class("OptionsMode").extends(gfx.sprite)

function OptionsMode:init()
	OptionsMode.super.init(self)

	self.foodSprite = nil
	self.classicSprite = nil
	self.mode = "classic"
	self.gentleSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 25)
	self:moveTo(48, 72)

	self.classicSprite = gfx.sprite.new(classicSelectedImage)
	self.classicSprite:setCenter(0, 0)
	self.classicSprite:moveTo(self.x + 128, self.y)
	self.classicSprite:add()

	self.gentleSprite = gfx.sprite.new(gentleSelectedImage)
	self.gentleSprite:setCenter(0, 0)
	self.gentleSprite:moveTo(self.x + 213, self.y)
	self.gentleSprite:add()
end

function OptionsMode:setMode(newMode)
	self.mode = newMode
	self:updateDisplay()
end

function OptionsMode:updateDisplay()
	if self.mode == "classic" then
		self.classicSprite:setImage(classicSelectedImage)
		self.gentleSprite:setImage(gentleImage)
	else
		self.classicSprite:setImage(classicImage)
		self.gentleSprite:setImage(gentleSelectedImage)
	end

	self:markDirty()
end

function OptionsMode:select()
	self.selected = true

	self.foodSprite = gfx.sprite.new(foodImage)
	self.foodSprite:setCenter(0, 0)
	self.foodSprite:moveTo(self.x, self.y + 4)
	self.foodSprite:add()

	self:markDirty()
end

function OptionsMode:deselect()
	self.selected = false
	self.foodSprite:remove()
	self:markDirty()
end

function OptionsMode:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Mode", 24, 3)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

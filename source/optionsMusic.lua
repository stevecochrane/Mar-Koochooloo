local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local radioNotSelectedImage = gfx.image.new("images/radio-not-selected")
local radioSelectedImage = gfx.image.new("images/radio-selected")

class("OptionsMusic").extends(gfx.sprite)

function OptionsMusic:init()
	OptionsMusic.super.init(self)

	self.appleSprite = nil
	self.music = "one"
	self.radioOneSprite = nil
	self.radioTwoSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 20)
	self:moveTo(48, 144)

	self.radioOneSprite = gfx.sprite.new(radioSelectedImage)
	self.radioOneSprite:setCenter(0, 0)
	self.radioOneSprite:moveTo(self.x + 122, self.y)
	self.radioOneSprite:add()

	self.radioTwoSprite = gfx.sprite.new(radioNotSelectedImage)
	self.radioTwoSprite:setCenter(0, 0)
	self.radioTwoSprite:moveTo(self.x + 173, self.y)
	self.radioTwoSprite:add()
end

function OptionsMusic:setMusic(newMusic)
	self.music = newMusic
	self:updateDisplay()
end

function OptionsMusic:toggle()
	if self.music == "one" then
		self.music = "two"
	else
		self.music = "one"
	end
	self:updateDisplay()
end

function OptionsMusic:updateDisplay()
	if self.music == "one" then
		self.radioOneSprite:setImage(radioSelectedImage)
		self.radioTwoSprite:setImage(radioNotSelectedImage)
	else
		self.radioOneSprite:setImage(radioNotSelectedImage)
		self.radioTwoSprite:setImage(radioSelectedImage)
	end

	self:markDirty()
end

function OptionsMusic:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsMusic:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function OptionsMusic:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	gfx.drawText("Music", 24, 0)
	gfx.drawText("1", 140, 0)
	gfx.drawText("2", 191, 0)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

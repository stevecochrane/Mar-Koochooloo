local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local music1Image = gfx.image.new("images/options-music-1")
local music1SelectedImage = gfx.image.new("images/options-music-1-selected")
local music2Image = gfx.image.new("images/options-music-2")
local music2SelectedImage = gfx.image.new("images/options-music-2-selected")

class("OptionsMusic").extends(gfx.sprite)

function OptionsMusic:init()
	OptionsMusic.super.init(self)

	self.appleSprite = nil
	self.music = 1
	self.music1Sprite = nil
	self.music2Sprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 25)
	self:moveTo(48, 147)

	self.music1Sprite = gfx.sprite.new(music1SelectedImage)
	self.music1Sprite:setCenter(0, 0)
	self.music1Sprite:moveTo(self.x + 128, self.y)
	self.music1Sprite:add()

	self.music2Sprite = gfx.sprite.new(music2Image)
	self.music2Sprite:setCenter(0, 0)
	self.music2Sprite:moveTo(self.x + 170, self.y)
	self.music2Sprite:add()
end

function OptionsMusic:setMusic(newMusic)
	self.music = newMusic
	self:updateDisplay()
end

function OptionsMusic:toggle()
	if self.music == 1 then
		self.music = 2
	else
		self.music = 1
	end
	self:updateDisplay()
end

function OptionsMusic:updateDisplay()
	if self.music == 1 then
		self.music1Sprite:setImage(music1SelectedImage)
		self.music2Sprite:setImage(music2Image)
	else
		self.music1Sprite:setImage(music1Image)
		self.music2Sprite:setImage(music2SelectedImage)
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
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

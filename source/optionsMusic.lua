local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local music1Image = gfx.image.new("images/options-music-1")
local music1SelectedImage = gfx.image.new("images/options-music-1-selected")
local music2Image = gfx.image.new("images/options-music-2")
local music2SelectedImage = gfx.image.new("images/options-music-2-selected")
local music3Image = gfx.image.new("images/options-music-3")
local music3SelectedImage = gfx.image.new("images/options-music-3-selected")

local music1XOffset = 128
local music2XOffset = 165
local music3XOffset = 202
local musicYOffset = 3

class("OptionsMusic").extends(gfx.sprite)

function OptionsMusic:init()
	OptionsMusic.super.init(self)

	self.appleSprite = nil
	self.music = 1
	self.music1Sprite = nil
	self.music2Sprite = nil
	self.music3Sprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 25)
	self:moveTo(48, 147)

	self.music1Sprite = gfx.sprite.new(music1SelectedImage)
	self.music1Sprite:setCenter(0, 0)
	self.music1Sprite:moveTo(self.x + music1XOffset, self.y - musicYOffset)
	self.music1Sprite:add()

	self.music2Sprite = gfx.sprite.new(music2Image)
	self.music2Sprite:setCenter(0, 0)
	self.music2Sprite:moveTo(self.x + music2XOffset, self.y - musicYOffset)
	self.music2Sprite:add()

	self.music3Sprite = gfx.sprite.new(music3Image)
	self.music3Sprite:setCenter(0, 0)
	self.music3Sprite:moveTo(self.x + music3XOffset, self.y - musicYOffset)
	self.music3Sprite:add()
end

function OptionsMusic:setMusic(newMusic)
	self.music = newMusic
	self:updateDisplay()
end

function OptionsMusic:updateDisplay()
	if self.music == 1 then
		self.music1Sprite:setImage(music1SelectedImage)
		self.music2Sprite:setImage(music2Image)
		self.music3Sprite:setImage(music3Image)
	elseif self.music == 2 then
		self.music1Sprite:setImage(music1Image)
		self.music2Sprite:setImage(music2SelectedImage)
		self.music3Sprite:setImage(music3Image)
	else
		self.music1Sprite:setImage(music1Image)
		self.music2Sprite:setImage(music2Image)
		self.music3Sprite:setImage(music3SelectedImage)
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

function OptionsMusic:moveToSecondRow()
	self:moveTo(48, 111)
	self.music1Sprite:moveTo(self.x + music1XOffset, self.y - musicYOffset)
	self.music2Sprite:moveTo(self.x + music2XOffset, self.y - musicYOffset)
	self.music3Sprite:moveTo(self.x + music3XOffset, self.y - musicYOffset)
	self:markDirty()
end

function OptionsMusic:moveToThirdRow()
	self:moveTo(48, 147)
	self.music1Sprite:moveTo(self.x + music1XOffset, self.y - musicYOffset)
	self.music2Sprite:moveTo(self.x + music2XOffset, self.y - musicYOffset)
	self.music3Sprite:moveTo(self.x + music3XOffset, self.y - musicYOffset)
	self:markDirty()
end

function OptionsMusic:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Music", 24, 0)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")
local arrowLeftImage = gfx.image.new("images/arrow-left")
local arrowRightImage = gfx.image.new("images/arrow-right")

class("OptionsDifficulty").extends(gfx.sprite)

function OptionsDifficulty:init()
	OptionsDifficulty.super.init(self)

	self.appleSprite = nil
	self.selected = false
	self.difficulty = 0

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(304, 20)
	self:moveTo(48, 112)

	self.arrowLeftSprite = gfx.sprite.new(arrowLeftImage)
	self.arrowLeftSprite:setCenter(0, 0)
	self.arrowLeftSprite:moveTo(self.x + 165, self.y + 2)
	self.arrowLeftSprite:add()

	self.arrowRightSprite = gfx.sprite.new(arrowRightImage)
	self.arrowRightSprite:setCenter(0, 0)
	self.arrowRightSprite:moveTo(self.x + 206, self.y + 2)
	self.arrowRightSprite:add()
end

function OptionsDifficulty:setDifficulty(newDifficulty)
	self.difficulty = newDifficulty
	self:markDirty()
end

function OptionsDifficulty:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function OptionsDifficulty:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function OptionsDifficulty:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	-- Draw "Difficulty" label text
	gfx.drawText("Difficulty", 24, 0)

	-- Draw difficulty setting number as string
	gfx.drawTextAligned(tostring(self.difficulty), 189, 0, kTextAlignment.center)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

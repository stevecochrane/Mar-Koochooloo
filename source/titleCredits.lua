local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")

class("TitleCredits").extends(gfx.sprite)

function TitleCredits:init()
	TitleCredits.super.init(self)

	self.appleSprite = nil
	self.selected = false

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(150, 168)
end

function TitleCredits:select()
	self.selected = true

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y)
	self.appleSprite:add()

	self:markDirty()
end

function TitleCredits:deselect()
	self.selected = false

	self.appleSprite:remove()

	self:markDirty()
end

function TitleCredits:draw()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	local Asheville14Bold <const> = gfx.font.new('Fonts/Asheville-Sans-14-Bold')
	gfx.setFont(Asheville14Bold);

	gfx.drawText("Credits", 24, 0)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	local Asheville14Light <const> = gfx.font.new('Fonts/Asheville-Sans-14-Light')
	gfx.setFont(Asheville14Light);
end

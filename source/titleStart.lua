local gfx <const> = playdate.graphics

local foodImage = gfx.image.new("images/food")

class("TitleStart").extends(gfx.sprite)

function TitleStart:init()
	TitleStart.super.init(self)

	self.blinker = gfx.animation.blinker.new()
	self.blinker.cycles = 10
	self.blinker.onDuration = 150
	self.blinker.offDuration = 150

	self.foodSprite = nil
	self.selected = false
	self.visible = true

	self:setZIndex(1)
	self:setCenter(0, 0)
	self:setSize(272, 20)
	self:moveTo(150, 144)
end

function TitleStart:blink()
	self.blinker:start()
end

function TitleStart:select()
	self.selected = true

	self.foodSprite = gfx.sprite.new(foodImage)
	self.foodSprite:setCenter(0, 0)
	self.foodSprite:moveTo(self.x, self.y + 1)
	self.foodSprite:add()

	self:markDirty()
end

function TitleStart:deselect()
	self.selected = false

	self.foodSprite:remove()

	self:markDirty()
end

function TitleStart:update()
	if self.blinker.running then
		if self.visible and not self.blinker.on then
			self.visible = false
			self:markDirty()
		elseif not self.visible and self.blinker.on then
			self.visible = true
			self:markDirty()
		end
	end
end

function TitleStart:draw()
	if self.visible then
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	end

	gfx.drawText("Start", 24, 0)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

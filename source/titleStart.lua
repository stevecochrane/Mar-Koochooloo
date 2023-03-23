local gfx <const> = playdate.graphics

local appleImage = gfx.image.new("images/apple")

class("TitleStart").extends(gfx.sprite)

function TitleStart:init()
	TitleStart.super.init(self)

	self.blinker = gfx.animation.blinker.new()
	self.blinker.cycles = 10
	self.blinker.onDuration = 150
	self.blinker.offDuration = 150

	self.appleSprite = nil
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

	self.appleSprite = gfx.sprite.new(appleImage)
	self.appleSprite:setCenter(0, 0)
	self.appleSprite:moveTo(self.x, self.y + 1)
	self.appleSprite:add()

	self:markDirty()
end

function TitleStart:deselect()
	self.selected = false

	self.appleSprite:remove()

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
	local Roobert11Medium <const> = gfx.font.new('Fonts/Roobert-11-Medium')
	local Asheville14Light <const> = gfx.font.new('Fonts/Asheville-Sans-14-Light')

	if self.visible then
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	end

	gfx.setFont(Roobert11Medium);
	gfx.drawText("Start", 24, 0)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	gfx.setFont(Asheville14Light);
end

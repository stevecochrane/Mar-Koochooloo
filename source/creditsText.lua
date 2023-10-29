local gfx <const> = playdate.graphics

class("CreditsText").extends(gfx.sprite)

function CreditsText:init()
	CreditsText.super.init(self)
	self:setCenter(0, 0)
	self:setSize(400, 240)
	self:moveTo(0, 0)
end

function CreditsText:draw()
	local Roobert10Bold <const> = gfx.font.new('Fonts/Roobert-10-Bold')

	local margin = 10
	local rowHeight = 20

	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	gfx.drawText("For Darya, with love", margin, margin)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Design, Programming, Graphics", margin, margin + rowHeight * 2)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Steve Cochrane", margin, margin + rowHeight * 3)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Music, Sound Effects", margin, margin + rowHeight * 5)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("KRVB", margin, margin + rowHeight * 6)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Playtesting, Feedback", margin, margin + rowHeight * 8)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Darya, Darya's Maman", margin, margin + rowHeight * 9)

	gfx.drawTextAligned("Ⓐ", 390, margin + rowHeight * 10, kTextAlignment.right)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

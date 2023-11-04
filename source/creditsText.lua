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

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Design, Programming, Graphics", margin, margin)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Steve Cochrane", margin, margin + rowHeight * 1)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Music, Sound Effects", margin, margin + rowHeight * 3)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("KRVB", margin, margin + rowHeight * 4)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Playtesting, Feedback", margin, margin + rowHeight * 6)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Darya, Maman", margin, margin + rowHeight * 7)

	gfx.setFont(Roobert11Medium)
	gfx.drawText("Thank you for playing!", margin, margin + rowHeight * 10)

	gfx.drawTextAligned("Ⓐ", 390, margin + rowHeight * 10, kTextAlignment.right)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

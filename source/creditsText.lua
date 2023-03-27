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

	local leftMargin = 20
	local rowHeight = 20

	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	gfx.drawText("For Darya, with love", leftMargin, rowHeight * 1)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Design, Programming, Graphics", leftMargin, rowHeight * 3)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Steve Cochrane", leftMargin, rowHeight * 4)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Music, Sound Effects", leftMargin, rowHeight * 6)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Nik Son", leftMargin, rowHeight * 7)

	gfx.setFont(Roobert10Bold)
	gfx.drawText("Playtesting, Feedback", leftMargin, rowHeight * 9)
	gfx.setFont(Roobert11Medium)
	gfx.drawText("Nazgol Bagheri, Darya Cochrane", leftMargin, rowHeight * 10)

	gfx.drawTextAligned("Ⓐ", 380, rowHeight * 10, kTextAlignment.right)

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

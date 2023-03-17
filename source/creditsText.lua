local gfx <const> = playdate.graphics

class("CreditsText").extends(gfx.sprite)

function CreditsText:init()
	CreditsText.super.init(self)
	self:setCenter(0, 0)
	self:setSize(400, 240)
	self:moveTo(0, 0)
end

function CreditsText:draw()
	local Asheville14Bold <const> = gfx.font.new('Fonts/Asheville-Sans-14-Bold')
	local Asheville14Light <const> = gfx.font.new('Fonts/Asheville-Sans-14-Light')

	local leftMargin = 16
	local rowHeight = 16

	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	gfx.setFont(Asheville14Bold)
	gfx.drawText("For Darya with love", leftMargin, rowHeight * 1)

	gfx.setFont(Asheville14Light)
	gfx.drawText("Design, Programming, Art, Sound Effects", leftMargin, rowHeight * 3)
	gfx.setFont(Asheville14Bold)
	gfx.drawText("Steve Cochrane", leftMargin, rowHeight * 4)

	gfx.setFont(Asheville14Light)
	gfx.drawText("Music, Sound Effects", leftMargin, rowHeight * 6)
	gfx.setFont(Asheville14Bold)
	gfx.drawText("Nik Son", leftMargin, rowHeight * 7)

	gfx.setFont(Asheville14Light)
	gfx.drawText("Playtesting, Feedback", leftMargin, rowHeight * 9)
	gfx.setFont(Asheville14Bold)
	gfx.drawText("Nazgol Bagheri, Darya Cochrane", leftMargin, rowHeight * 10)

	gfx.setFont(Asheville14Bold)
	gfx.drawText("Thank you for playing!", leftMargin, rowHeight * 12)

	-- Reset to defaults so this doesn't change other areas of the game
	gfx.setFont(Asheville14Light)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

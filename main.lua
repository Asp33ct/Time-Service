lighting = game:service("Lighting")

DayAmbient = Color3.new(99/255, 97/255, 85/255) --for 0-255, make sure to divide by 255 e.g. 128/255
DayBrightness = 1
DayOutdoorAmbient = Color3.new(25/25, 25/25, 25/25)
DayShadowColor = Color3.new(.59,.59,.59)
DayFogColor = Color3.new(.59,.59,.59)
DayFogEnd = 1000
DayFogStart = 100

NightAmbient = Color3.new(0,0,0)
NightBrightness = .3
NightOutdoorAmbient = Color3.new(0.1,0.1,0.1)
NightShadowColor = Color3.new(.59,.59,.59)
NightFogColor = Color3.new(2/255, 2/255, 2/255)
NightFogEnd = 1000
NightFogStart = 100

TotalDayLength = 10 --minutes

SummerDayLength = 50 --arbitrary units, gets divided by total
SummerTransitionLength = 20 --actually half of the time since it appears twice
SummerNightLength = 30

WinterDayLength = 30
WinterTransitionLength = 20
WinterNightLength = 50


--do not touch below plz
SecondsPerYear = 31556900
--formula = "(tick()-(math.floor(tick()/31556900)*31556900))/31556900"
YearAlpha = 0
DayAlpha = math.random()
calc = function() YearAlpha = (tick()-(math.floor(tick()/31556900)*31556900))/31556900 end
calc()
function calc2(alpha,be,en)local a = 0 if be ~= en then a = (-math.cos(math.pi*alpha*2)/2+0.5)*(en-be)+be else a = be end return a end
function calc3(alpha,be,en)local a = 0 if be ~= en then a = (-math.cos(math.pi*alpha)/2+0.5)*(en-be)+be else a = be end return a end
function calc4(alpha,be,en)local r = 0 local g = 0 local b = 0 if be.r ~= en.r then r = (-math.cos(math.pi*alpha)/2+0.5)*(en.r-be.r)+be.r
else r = be.r end if be.g ~= en.g then g = (-math.cos(math.pi*alpha)/2+0.5)*(en.g-be.g)+be.g else g = be.g end if be.b ~= en.b then
b = (-math.cos(math.pi*alpha)/2+0.5)*(en.b-be.b)+be.b else b = be.b end return Color3.new(r,g,b)end
function setl(input)lighting:SetMinutesAfterMidnight(input*1440)end
sl = math.abs(SummerDayLength)+math.abs(SummerTransitionLength)+math.abs(SummerNightLength)
wl = math.abs(WinterDayLength)+math.abs(WinterTransitionLength)+math.abs(WinterNightLength)
function upl(a)
	lighting.Ambient = calc4(a,NightAmbient,DayAmbient)
	lighting.Brightness = calc3(a,NightBrightness,DayBrightness)
	lighting.OutdoorAmbient = calc4(a,NightOutdoorAmbient,DayOutdoorAmbient)
	lighting.ShadowColor = calc4(a,NightShadowColor,DayShadowColor)
	lighting.FogColor = calc4(a,NightFogColor,DayFogColor)
	lighting.FogEnd = calc3(a,NightFogEnd,DayFogEnd)
	lighting.FogStart = calc3(a,NightFogStart,DayFogStart)
end
MorningLength = 5/24
TwilightLength = 2/24
DayLength = 10/24
TwilightLength = 2/24
NightLength = 5/24
while true do
	calc()
	local TR = calc2(YearAlpha,wl,sl)
	local DL = calc2(YearAlpha,math.abs(WinterDayLength),math.abs(SummerDayLength))/TR
	local TL = calc2(YearAlpha,math.abs(WinterTransitionLength),math.abs(SummerTransitionLength))/TR
	local NL = calc2(YearAlpha,math.abs(WinterNightLength),math.abs(SummerNightLength))/TR
	repeat
		wait(0.05)
		DayAlpha = DayAlpha+0.05/(TotalDayLength*60)
		--print(DayAlpha)
		if DayAlpha <= NL/2 then
			local al = (DayAlpha)/NL*2
			setl(al*MorningLength)
			--print("first "..al)
			upl(0)
		elseif DayAlpha <= (NL/2+TL/2)then
			local al = (DayAlpha-NL/2)/TL*2
			setl(al*TwilightLength+MorningLength)
			--print("second "..al)
			upl(al)
		elseif DayAlpha <= (NL/2+TL/2+DL) then
			local al = (DayAlpha-NL/2-TL/2)/DL
			setl(al*DayLength+TwilightLength+MorningLength)
			--print("third "..al)
			upl(1)
		elseif DayAlpha <= (NL/2+TL+DL) then
			local al = (DayAlpha-NL/2-TL/2-DL)/TL*2
			setl(al*TwilightLength+DayLength+TwilightLength+MorningLength)
			--print("fourth "..al)
			upl(1-al)
		else
			local al = (DayAlpha-NL/2-TL-DL)/NL*2
			setl(al*NightLength+TwilightLength+DayLength+TwilightLength+MorningLength)
			--print("fifth "..al)
			upl(0)
		end
	until DayAlpha >= 1
	DayAlpha = 0
	print("It's a new day!")
end

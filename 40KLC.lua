-- Script Settings --
SIMILAR = 0.80
TIMEOUT = 3

immersive = true
setImmersiveMode(immersive)
genVersion = "9.0.2-pro2"
setAutoGameArea = true
pcall (autoGameArea, setAutoGameArea)
scriptDimension = 1280
Settings:setScriptDimension(true, scriptDimension)
Settings:setCompareDimension(true, scriptDimension)
Settings:set("AutoWaitTimeout", TIMEOUT)
Settings:set("MinSimilarity", SIMILAR)

--Sets root folder structure(so that it runs from whatever folder your script is ran from.
ROOT = scriptPath()

--Sets a custom path for my images folder, make sure your imagename.png is in yoyr images folder
DIR_IMAGES = ROOT .. "Images"
setImagePath(DIR_IMAGES)

setHighlightTextStyle(0x96666666, 0xf8ffffff, 6)

--These 3 lines are where your paint / debug info will be displayed on your screen
REG_PAINT_LINE1 = Region(1080, 10, 242, 34)
REG_PAINT_LINE2 = Region(1080, 43, 242, 34)
REG_PAINT_LINE3 = Region(1080, 76, 242, 34)

function paint(section)
    local seconds = StaTimer:check()
    REG_PAINT_LINE1:highlightOff()
    REG_PAINT_LINE2:highlightOff()
    REG_PAINT_LINE3:highlightOff()
    REG_PAINT_LINE1:highlight("Runtime: " .. secondsToClock(seconds) .. "")
    --REG_PAINT_LINE2:highlight("T: " .. TARGETS .. " A: " .. ATTACKS .. " R: " .. REPAIRS .. " D: " .. DEATHS .. " M: " .. MINE)
    if (cbDebug) then 
		REG_PAINT_LINE3:highlight("Debug Section: " .. section)
	else
		REG_PAINT_LINE3:highlight("Section: " .. section)
	end
end

--function to convert seconds to easier-to-read string:
function secondsToClock(seconds)
    local seconds = tonumber(seconds)
    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

function regionWaitMulti(target, seconds, debug, skipLocation, index, previousSnap, colorMatch)
    local timer = Timer()
    local match
    local length = table.getn(target)
    if (index > length or index <= 0) then
        index = 1
    end

    while (true) do
        --        for i, t in ipairs(target) do
        if (not previousSnap) then
            if (colorMatch) then
            	--print('Color')
                snapshotColor()
            else
                snapshot()
            end
        end
        usePreviousSnap(true)
        for i = index, length do
            local t = target[i]
            local image = t.target

            if ((t.region and (t.region):exists(image, 0)) or
                    (not t.region and exists(image, 0))) then -- check once
                usePreviousSnap(false)
                if (t.region) then
                    match = (t.region):getLastMatch()
                else
                    match = getLastMatch()
                end
                --            if (debug) then match:offset(0, -cutoutHeight):highlight(0.5) end
                return i, t.id, match
            end
        end
        index = 1
        if (skipLocation ~= nil) then click(skipLocation) end
        if (timer:check() > seconds) then
            usePreviousSnap(false)
            return -1, "__none__"
        end
    end
end

function marchcheck()
	if Region(4, 215, 90, 90):existsClick('Marches.png') then
		--print('Marches Found')
		wait(1)
	end
	reg = Region(135, 170, 80, 280)
	if cbDebug then reg:highlight(.5) end
	if reg:exists('CollectFuel.png') then
		cf = false print('Fuel Found')
	else
		cf = true print('Mine Fuel')
	end
	if reg:exists('CollectMetal.png') then
		cm = false print('Metal Found')
	else
		cm = true print('Mine Metal')
	end
	if reg:exists('CollectAdamantium.png') then
		ca = false print('Adamantium Found')
	else
		ca = true print('Mine Adamantium')
	end
	if reg:exists('CollectPlasma.png') then
		cp = false print('Plasma Found')
	else
		cp = true print('Mine Plasma')
	end
	if reg:exists('CollectCrystal.png') then
		cc = false print('Crystal Found')
	else
		cc = true print('Mine Crystal')
	end
	Region(4, 215, 90, 90):existsClick('Marches.png')
	wait(.5)
	return cf, cm, ca, cp, cc
end

function dialogLogin()
	dialogInit()
	addTextView("Enter Password: ")
	addEditPassword('password', 'none')
	dialogShow("40KLC - User Verification")
end

function dialogFull()
	-- Give the user options
	dialogInit()
	siLine = {"NONE", "Line 1", "Line 2", "Line 3", "Line 4", "Line 5"}
	siAction = {"NONE", "Mine Metal", "Mine Fuel", "Mine Adamantium", "Mine Plasma", "Mine Crystal"}
	addTextView("Settings")
	newRow()
	addTextView("   ")
	addCheckBox("cbDebug", "Debug Highlights", false)
	newRow()
	addTextView("March 1: ")
	addSpinnerIndex("spAction1", siAction, "NONE")
	addTextView("  Line Up:  ")
	addSpinnerIndex("spLine1", siLine, "NONE")
	newRow()
	addTextView("March 2: ")
	addSpinnerIndex("spAction2", siAction, "NONE")
	addTextView("  Line Up:  ")
	addSpinnerIndex("spLine2", siLine, "NONE")
	newRow()
	addTextView("March 3: ")
	addSpinnerIndex("spAction3", siAction, "NONE")
	addTextView("  Line Up:  ")
	addSpinnerIndex("spLine3", siLine, "NONE")
	newRow()
	addTextView("March 4: ")
	addSpinnerIndex("spAction4", siAction, "NONE")
	addTextView("  Line Up:  ")
	addSpinnerIndex("spLine4", siLine, "NONE")
	newRow()
	addTextView("March 5: ")
	addSpinnerIndex("spAction5", siAction, "NONE")
	addTextView("  Line Up:  ")
	addSpinnerIndex("spLine5", siLine, "NONE")
	newRow()
	dialogShowFullScreen("Warhammer 40k Lost Crusade")
end

function mine(res, line)
	print('Mine ' .. res.tar .. ' ' .. line.tar)
	if cbDebug then Region(51, 587, 90, 90):highlight(.5) end
	if Region(51, 587, 90, 90):existsClick('Starmap.png') then
		if cbDebug then Region(45, 580, 80, 80):highlight(.5) end
		Region(45, 580, 80, 80):wait('Base.png', 10)
		wait(1)
	end
	if cbDebug then Region(1070, 529, 80, 80):highlight(.5) end
	if Region(1070, 529, 80, 80):existsClick('Search.png') then
		wait(1)
		if cbDebug then res.reg:highlight(.5) end
		res.reg:existsClick(res.tar)
		wait(1)
		if cbDebug then Region(884, 612, 80, 80):highlight(.5) end
		Region(884, 612, 80, 80):existsClick('Explore.png')
		wait(1)
		if cbDebug then Region(728, 280, 86, 86):highlight(.5) end
		Region(728, 280, 86, 86):existsClick('Collect.png')
		wait(1)
		if cbDebug then line.reg:highlight(.5) end
        if line ~= 1 then
		    line.reg:existsClick(line.tar)
            wait(1)
        end
		if cbDebug then Region(973, 597, 86, 86):highlight(.5) end
		if not Region(973, 597, 86, 86):existsClick('Deploy.png') then
			Region(1100, 7, 90, 90):existsClick('Close.png')
		end
		wait(1)
	end
end

function updateVer()
	local imgs = { 'Starmap.png',  'Explore.png', 'MineCrystal.png', 'MinePlasma.png', 'MineAdamantium.png',
							 'MineFuel.png', 'MineMetal.png', 'Base.png', 'Search.png', 'CollectMetal.png',
							'CollectFuel.png', 'CollectAdamantium.png', 'CollectPlasma.png', 'Marches.png',
							'Line5.png', 'Line4.png', 'Line3.png', 'Line2.png', 'Line1.png', 'Collect.png', 'Deploy.png',
							'Help.png', 'Close.png', 'CollectCrystal.png' }

-- Setup Github and check for updates
	gitVersion = loadstring(httpGet("https://raw.githubusercontent.com/Zenkrye/40KLC/main/40KLCver.lua"))
	webVersion = gitVersion()
	curVersion = dofile(ROOT .."40KLCver.lua")
	print('New Version: ' .. webVersion .. '  Current Version: ' .. curVersion)
	if curVersion == webVersion then
    	toast ("You are running the most current version!")
	else
 	   httpDownload("https://raw.github.com/Zenkrye/40KLC/main/40KLCver.lua", ROOT .."40KLCver.lua")
		httpDownload("https://raw.github.com/Zenkrye/40KLC/main/40KLC.luae3", ROOT .."40KLC.luae3")
		for i = 1, table.getn(imgs) do
			toast ("Updating files " .. i .. " of " .. table.getn(imgs))
			gitImg = "https://raw.github.com/Zenkrye/40KLC/main/Images/" .. imgs[i]
			--print(gitImg .. " Dir: " .. DIR_IMAGES .. " Img: " .. imgs[i].pat)
			--print(gitImg .. DIR_IMAGES .. imgs[i].pat)
			httpDownload(gitImg , DIR_IMAGES .. "/" .. imgs[i])
			total = i
		end 	 
		scriptExit("Star Trek Fleet Command has been updated! " .. total .. " images updated")
	end
end

function cleanup()
	paint('Cleanup')
  local clean = {
    { id = '1', target = 'Base.png', region = Region(45, 580, 80, 80), },
    { id = '2', target = 'Help.png', region = Region(840, 520, 360, 90), },
 }
 
	Region(840, 520, 360, 90):highlight(.5)
	Exit = 0
	while (Exit == 0)
	do
		local id, tar, m = regionWaitMulti(clean, 1, cbDebug, nil, 1, false, false)
		if (id == -1) then
			--if Region(135, 0, 130, 130):exists('Power.png') then
				Exit = 1
			--end
		elseif (id ~= nil)  then
			click(m)
		end
	end
end

--- Main ---
updateVer()

--Only initialize t / timer ONCE during script!
dialogLogin()

StaTimer = Timer()
CheckTimer = Timer()
local check = 0

if password == '40klc@)22' then
	dialogFull()
else
	dialogFull()
end

local action = {}
table.insert(action, { id = '1', tar = 'NONE', reg = Region(450, 463, 80, 80)})
table.insert(action, { id = '2', tar = 'MineMetal.png', reg = Region(450, 463, 80, 80)})
table.insert(action, { id = '3', tar = 'MineFuel.png', reg = Region(550, 460, 80, 80)})
table.insert(action, { id = '4', tar = 'MineAdamantium.png', reg = Region(652, 466, 80, 80)})
table.insert(action, { id = '5', tar = 'MinePlasma.png', reg = Region(750, 463, 80, 80)})
table.insert(action, { id = '6', tar = 'MineCrystal.png', reg = Region(850, 463, 80, 80)})

local line = {}
table.insert(line, { id = '0', tar = 'NONE', reg = Region(450, 463, 80, 80)})
table.insert(line, { id = '1', tar = 'Line1.png', reg = Region(204, 620, 86, 86)})
table.insert(line, { id = '2', tar = 'Line2.png', reg = Region(274, 620, 86, 86)})
table.insert(line, { id = '3', tar = 'Line3.png', reg = Region(343, 620, 86, 86)})
table.insert(line, { id = '4', tar = 'Line4.png', reg = Region(414, 620, 86, 86)})
table.insert(line, { id = '5', tar = 'Line5.png', reg = Region(482, 620, 86, 86)})

local marches = {}
if (spMarch1 ~= 1) then
		table.insert(marches, { rss = spAction1, line = spLine1 })
end
if (spMarch2 ~= 1) then
		table.insert(marches, { rss = spAction2, line = spLine2 })
end
if (spMarch3 ~= 1) then
		table.insert(marches, { rss = spAction3, line = spLine3 })
end
if (spMarch4 ~= 1) then
		table.insert(marches, { rss = spAction4, line = spLine4 })
end
if (spMarch5 ~= 1) then
		table.insert(marches, { rss = spAction5, line = spLine5 })
end

while (true)
do
	if (CheckTimer:check() > check) then
		bFuel, bMetal, bAdamantium, bPlasma, bCrystal = marchcheck()
		for i, m in ipairs(marches) do
			print(i, m.rss, m.line)
			if bMetal and m.rss == 2 then mine(action[m.rss], line[m.line]) end
			if bFuel and m.rss == 3 then mine(action[m.rss], line[m.line]) end
			if bAdamantium and m.rss == 4 then mine(action[m.rss], line[m.line]) end
			if bPlasma and m.rss == 5 then mine(action[m.rss], line[m.line]) end
			if bCrystal and m.rss == 6 then mine(action[m.rss], line[m.line]) end
			check = CheckTimer:check() + 5*60
		end
		wait(5)
	end
	cleanup()
end

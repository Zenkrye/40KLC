-- Script Settings --
SIMILAR = 0.50
TIMEOUT = 5

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
	if reg:exists('Rallying.png') then
		rf = false print('Rally Found')
	else
		rf = true print('Rally Forces')
	end
	Region(4, 215, 90, 90):existsClick('Marches.png')
	wait(.5)
	return cf, cm, ca, cp, cc, rf
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
	siAction = {"NONE", "Mine Metal", "Mine Fuel", "Mine Adamantium", "Mine Plasma", "Mine Crystal", "Rally Forces"}
	addTextView("Settings")
	newRow()
	addTextView("   ")
	addCheckBox("cbDebug", "Debug Highlights", false)
	addTextView("   ")
	addCheckBox("cbResearch", "Research", false)
	addTextView("   ")
	addCheckBox("cbDread", "Dreadnought", false)
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

function task(res)
	print('Task: ' .. res.tar)
	if cbDebug then Region(51, 587, 90, 90):highlight(.5) end
	if Region(51, 587, 90, 90):existsClick('Starmap.png') then
		wait(3)
		if cbDebug then Region(45, 580, 80, 80):highlight(.5) end
		Region(45, 580, 80, 80):wait('Base.png', 60)
		wait(1)
	end
	if cbDebug then Region(840, 520, 420, 90):highlight(.5) end
	if Region(840, 520, 420, 90):existsClick('MapSearch.png') then
		wait(1)
		if cbDebug then res.reg:highlight(.5) end
		res.reg:existsClick(res.tar)
		wait(1)
		if cbDebug then Region(884, 612, 80, 80):highlight(.5) end
		Region(884, 612, 80, 80):existsClick('Explore.png')
		wait(1)
	end
end

function mine(res, line)
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

function rally(res, line)
	if cbDebug then Region(727, 230, 90, 90):highlight(.5) end
	Region(727, 230, 90, 90):existsClick('Rally.png')		
	wait(1)
	if cbDebug then Region(762, 537, 70, 70):highlight(.5) end
	Region(762, 537, 70, 70):existsClick('RallyAttack.png')
	wait(1)
	if Region(673, 406, 90, 90):exists('RestoreAP.png') then
		--if cbDebug then Region(1100, 7, 90, 90):highlight(.5) end
		--Region(1100, 7, 90, 90):existsClick('Close.png')
		--Region(1100, 7, 90, 90):existsClick('Close.png')
	else
		if cbDebug then line.reg:highlight(.5) end
 	   if line ~= 1 then
			line.reg:existsClick(line.tar)
 	       wait(1)
 	    end
		if cbDebug then Region(973, 597, 86, 86):highlight(.5) end
		if not Region(973, 597, 86, 86):existsClick('Deploy.png') then
			Region(1100, 7, 90, 90):existsClick('Close.png')
		end
	end
	wait(1)
end

function updateVer()
	local imgs = { 'AllianceAid.png', 'AttackAP.png', 'Back.png', 'Base.png', 'Build.png', 'Collect.png', 
							'CollectMetal.png', 'CollectFuel.png', 'CollectAdamantium.png', 'CollectPlasma.png',
							'Close.png', 'CollectCrystal.png', 'Deploy.png', 'Explore.png', 'Fleet.png', 'Forces.png', 
							'Help.png', 'Line5.png', 'Line4.png', 'Line3.png', 'Line2.png', 'Line1.png',
							'MapSearch.png',  'Marches.png', 'MineCrystal.png', 'MinePlasma.png', 'MineAdamantium.png',
							'MineFuel.png', 'MineMetal.png', 'Rally.png', 'Rallying.png', 'RallyAttack.png',
							'Research01.png', 'Research02.png', 'Research03.png', 'Research04.png', 
							'RestoreAP.png', 'Search.png', 'Train.png', 'Starmap.png', 
							'Train.png', 'TrainDread.png', 'TrainUnits.png',   }

-- Setup Github and check for updates
	gitVersion = loadstring(httpGet("https://raw.githubusercontent.com/Zenkrye/40KLC/main/40KLCver.lua"))
	webVersion = gitVersion()
	curVersion = dofile(ROOT .."40KLCver.lua")
	print('New Version: ' .. webVersion .. '  Current Version: ' .. curVersion)
	if curVersion == webVersion then
    	toast ("You are running the most current version!")
	else
		toast ("Updating files, this may take a few minutes")
		httpDownload("https://raw.github.com/Zenkrye/40KLC/main/40KLCver.lua", ROOT .."40KLCver.lua")
		httpDownload("https://raw.github.com/Zenkrye/40KLC/main/40KLC.luae3", ROOT .."40KLC.luae3")
 	   for i = 1, table.getn(imgs) do
			gitImg = "https://raw.github.com/Zenkrye/40KLC/main/Images/" .. imgs[i]
			httpDownload(gitImg , DIR_IMAGES .. "/" .. imgs[i])
			total = i
		end 	 
		scriptExit("Warhammer 40K Lost Crusade has been updated! " .. total .. " images updated")
	end
end

function cleanup()
	paint('Cleanup')
  local clean = {
    { id = '1', target = 'Base.png', region = Region(45, 580, 80, 80), },
    { id = '2', target = 'Back.png', region = Region(0, 0, 90, 90), },
    { id = '3', target = 'Help.png', region = Region(840, 520, 420, 90), },
 }
 
	Region(840, 520, 420, 90):highlight(.5)
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

function checkqueue(img)
	print('Check Queue: ' .. img)
	if cbDebug then Region(5, 130, 90, 330):highlight(.5) end
	if Region(5, 130, 90, 330):existsClick(Pattern(img)) then
		--print('Marches Found')
		wait(3)
	end
	reg = Region(430, 120, 90, 500)
	if cbDebug then reg:highlight(1) end
	results = listToTable(reg:findAllNoFindException(Pattern('Search.png')))
	if Region(5, 130, 90, 330):existsClick(Pattern(img)) then
		--print('Close Marches')
		wait(1)
	end
	return table.getn(results)
end

function research()
	if Region(5, 130, 90, 330):existsClick(Pattern('Train.png')) then
		--print('Marches Found')
		wait(3)
	end
	if cbDebug then Region(140, 460, 80, 80):highlight(.5) end
	if cbDebug then Region(430, 460, 80, 80):highlight(.5) end
	if Region(140, 460, 80, 80):exists('Research01.png') and Region(430, 460, 80, 80):exists('Search.png') then
		print('Go Research')
		Region(140, 460, 80, 80):existsClick(Pattern('Research01.png'))
		wait(1)
		if Region(729, 434, 80, 80):existsClick(Pattern('Research02.png')) then
			wait(2)
			Region(460, 610, 80, 80):highlight(.5)
			Region(460, 610, 80, 80):existsClick(Pattern('Research03.png'))
			wait(1)
			Region(977, 560, 80, 80):existsClick(Pattern('Research04.png'))
			wait(1)
			Region(784, 557, 80, 80):existsClick(Pattern('AllianceAid.png'))
			wait(2)
			Region(780, 5, 500, 300):highlight(.5)
			Region(780, 5, 500, 300):existsClick(Pattern('Close.png'))
			wait(2)
		end
		repeat
			if cbDebug then Region(0, 0, 90, 90):highlight(.5) end
			Region(0, 0, 90, 90):existsClick(Pattern('Back.png'))
		until Region(51, 587, 90, 90):exists('Starmap.png')
	else
		if Region(5, 130, 90, 330):existsClick(Pattern('Train.png')) then
			--print('Marches Found')
			wait(3)
		end
	end
end

function train(unit)
	if Region(140, 250, 80, 80):exists(unit) and Region(430, 250, 80, 80):exists('Search.png') then
		print('Train Dread')
	else
		print('Already Training Dread')
	end
end
--- Main ---
updateVer()
--Only initialize t / timer ONCE during script!
StaTimer = Timer()
CheckTimer = Timer()

dialogLogin()

local check = 0

if password == '40klc@)22' then
	dialogFull()
else
	dialogFull()
end

local action = {}
table.insert(action, { id = '1', tar = 'NONE', reg = Region(450, 463, 80, 80)})
table.insert(action, { id = '2', tar = 'MineMetal.png', reg = Region(450, 460, 120, 80)})
table.insert(action, { id = '3', tar = 'MineFuel.png', reg = Region(550, 460, 120, 80)})
table.insert(action, { id = '4', tar = 'MineAdamantium.png', reg = Region(650, 460, 120, 80)})
table.insert(action, { id = '5', tar = 'MinePlasma.png', reg = Region(750, 460, 120, 80)})
table.insert(action, { id = '6', tar = 'MineCrystal.png', reg = Region(850, 460, 120, 80)})
table.insert(action, { id = '7', tar = 'Fleet.png', reg = Region(350, 460, 120, 100)})
table.insert(action, { id = '8', tar = 'Forces.png', reg = Region(250, 460, 120, 100)})

local line = {}
table.insert(line, { id = '0', tar = 'NONE', reg = Region(450, 463, 80, 80)})
table.insert(line, { id = '1', tar = 'Line1.png', reg = Region(204, 620, 86, 86)})
table.insert(line, { id = '2', tar = 'Line2.png', reg = Region(274, 620, 86, 86)})
table.insert(line, { id = '3', tar = 'Line3.png', reg = Region(343, 620, 86, 86)})
table.insert(line, { id = '4', tar = 'Line4.png', reg = Region(414, 620, 86, 86)})
table.insert(line, { id = '5', tar = 'Line5.png', reg = Region(482, 620, 86, 86)})

local totMarch = 0
local marches = {}
if (spAction1 ~= 1) then
		table.insert(marches, { rss = spAction1, line = spLine1 })
		totMarch = totMarch + 1
end
if (spAction2 ~= 1) then
		table.insert(marches, { rss = spAction2, line = spLine2 })
		totMarch = totMarch + 1
end
if (spAction3 ~= 1) then
		table.insert(marches, { rss = spAction3, line = spLine3 })
		totMarch = totMarch + 1
end
if (spAction4 ~= 1) then
		table.insert(marches, { rss = spAction4, line = spLine4 })
		totMarch = totMarch + 1
end
if (spAction5 ~= 1) then
		table.insert(marches, { rss = spAction5, line = spLine5 })
		totMarch = totMarch + 1
end

while (true)
do
	if (CheckTimer:check() > check) then
		if cbResearch then research() end
		if cbDread then train('TrainDread.png') end
		--build = checkqueue('Build.png')
		--print ('Check: ' .. build .. ' <= Build: 2 ')
		--wait(2)
		march = 5 - checkqueue('Marches.png')
		print ('Check: ' .. march .. ' <= Marches: ' .. totMarch)
		wait(2)
		if march <= totMarch then
			bFuel, bMetal, bAdamantium, bPlasma, bCrystal, bRally = marchcheck()
			for i, m in ipairs(marches) do
				--print(i, m.rss, m.line)
				if bMetal and m.rss == 2 then task(action[m.rss]) mine(action[m.rss], line[m.line]) end
				if bFuel and m.rss == 3 then task(action[m.rss]) mine(action[m.rss], line[m.line]) end
				if bAdamantium and m.rss == 4 then task(action[m.rss]) mine(action[m.rss], line[m.line]) end
				if bPlasma and m.rss == 5 then task(action[m.rss]) mine(action[m.rss], line[m.line]) end
				if bCrystal and m.rss == 6 then task(action[m.rss]) mine(action[m.rss], line[m.line]) end
				if bRally and m.rss == 7 then task(action[m.rss]) rally(action[m.rss], line[m.line]) end
			end
		end
		--train = checkqueue('Train.png')
		--print ('Check: ' .. train .. ' <= Train: 7 ')
		--wait(2)
		check = CheckTimer:check() + math.random(180, 360)
		wait(5)
	end
	cleanup()
end
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
		cp = false print('Crystal Found')
	else
		cp = true print('Mine Crystal')
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
	addTextView("Settings")
	newRow()
	addTextView("   ")
	addCheckBox("cbDebug", "Debug Highlights", false)
	newRow()
	addTextView("Select Resources to Mine")
	newRow()
	addCheckBox("cbMetal", "Metal", true)
	addTextView("  Line Up:  ")
	addSpinnerIndex("spMetal", siLine, "NONE")
	newRow()
	addCheckBox("cbFuel", "Fuel", true)
	addTextView("  Line Up:  ")
	addSpinnerIndex("spFuel", siLine, "NONE")
	newRow()
	addCheckBox("cbAdamantium", "Adamantium", true)
	addTextView("  Line Up:  ")
	addSpinnerIndex("spAdam", siLine, "NONE")
	newRow()
	addCheckBox("cbPlasma", "Plasma", true)
	addTextView("  Line Up:  ")
	addSpinnerIndex("spPlasma", siLine, "NONE")
	newRow()
	addCheckBox("cbCrystal", "Crystal", true)
	addTextView("  Line Up:  ")
	addSpinnerIndex("spCrystal", siLine, "NONE")

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
                if not line == 1 then
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

--- Main ---
updateVer()

--Only initialize t / timer ONCE during script!
dialogLogin()

local CheckTimer = Timer()
local check = 0

if password == '40klc@)22' then
	dialogFull()
else
	dialogFull()
end

local rss = {}
table.insert(rss, { id = '1', tar = 'MineMetal.png', reg = Region(450, 463, 80, 80)})
table.insert(rss, { id = '2', tar = 'MineFuel.png', reg = Region(550, 460, 80, 80)})
table.insert(rss, { id = '3', tar = 'MineAdamantium.png', reg = Region(652, 466, 80, 80)})
table.insert(rss, { id = '4', tar = 'MinePlasma.png', reg = Region(750, 463, 80, 80)})
table.insert(rss, { id = '5', tar = 'MineCrystal.png', reg = Region(850, 463, 80, 80)})

local line = {}
table.insert(line, { id = '0', tar = 'NONE', reg = Region(450, 463, 80, 80)})
table.insert(line, { id = '1', tar = 'Line1.png', reg = Region(204, 620, 86, 86)})
table.insert(line, { id = '2', tar = 'Line2.png', reg = Region(274, 620, 86, 86)})
table.insert(line, { id = '3', tar = 'Line3.png', reg = Region(343, 620, 86, 86)})
table.insert(line, { id = '4', tar = 'Line4.png', reg = Region(414, 620, 86, 86)})
table.insert(line, { id = '5', tar = 'Line5.png', reg = Region(482, 620, 86, 86)})

while (true)
do
	if (CheckTimer:check() > check) then
		bFuel, bMetal, bAdamantium, bPlasma, bCrystal = marchcheck()
		if bMetal and cbMetal then mine(rss[1], line[spMetal]) end
		if bFuel and cbFuel then mine(rss[2], line[spFuel])	end
		if bAdamantium and cbAdamantium then mine(rss[3], line[spAdam]) end
		if bPlasma and cbPlasma then mine(rss[4], line[spPlasma]) end
		if bCrystal and cbCrystal then mine(rss[5], line[spCrystal]) end
		check = CheckTimer:check() + 5*60
	end
	if cbDebug then Region(840, 520, 360, 90):highlight(.5) end
	Region(840, 520, 360, 90):existsClick('Help.png')
	wait(5)
end

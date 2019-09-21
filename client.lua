local COLOR = {
	["DOLLAR"] = {
		["RGB"] = {69, 124, 59},
		["HEX"] = "#457C3B"
	},
	["REDDOLLAR"] = {
		["RGB"] = {180, 25, 10},
		["HEX"] = "#B4191D"
	},
	["TEXT"] = {
		["RGB"] = {220, 220, 220},
		["HEX"] = "#DCDCDC"
	},
	["KEY"] = {
		["RGB"] = {160, 160, 160},
		["HEX"] = "#A0A0A0"
	}
}



local DeathMatch = false
local ZonesDisplay = {}
local PedSyncObj = {}
local ObjectInStream = {}
local VehiclesInStream = {}
local VehicleTrunk = {}
local SkinList,SwitchButtonL,SwitchButtonR,SwitchButtonAccept,PEDChangeSkin = false
local SkinFlag = true
local PlayersMessage = {}
local PlayersAction = {}
local RobAction = false
local FireTimer = {}
local StreamData = {}
local VideoMemory = {["HUD"] = {}}


local PData = {
	["Interface"] = {
		["Full"] = true, 
		["WantedLevel"] = true,
		["Inventory"] = true,
		["AreaName"] = true,
		["Collections"] = true
	}, 
	['Mission'] = false, -- Миссия такси, автобуса, полицейского, пожарника
	['WantedFlashing'] = false, 
	['AnimatedMarker'] = {}, 
	['Target'] = {}, 
	['blip'] = {}, 
	['stamina'] = 8,
	['LVLUPSTAMINA'] = 10,
	['rage'] = 0, 
	['ShakeLVL'] = 0, 
	['TARR'] = {}, -- Target, по центру, ниже, выше
	['MultipleAction'] = {},
}




local LangArr = {}
function Text(text, repl)
	if(LangArr[text]) then
		text = LangArr[text]
	end
	if(repl) then
		for i, dat in pairs(repl) do
			text = string.gsub(text, dat[1], dat[2])
		end
	end
	return text
end

local timers = {}
local timersAction = {}
local backpackid = false
local titleText = ""
local ToolTipText = ""
local ToolTipRaceText = false
local ToolTipTimers = false
toggleAllControls(true)
local screenWidth, screenHeight = guiGetScreenSize()
local scale = ((screenWidth/1920)+(screenHeight/1080))
local NewScale = ((screenWidth/1920)+(screenHeight/1080))/2
local scalex = (screenWidth/1920)
local scaley = (screenHeight/1080)
local PrisonSleep = false
local PrisonGavno = false
local dialogActionTimer = false
local dialogTimer = false
local dialogViewTimer = false
local dialogTitle = false
local PlayerChangeSkinTeam = ""
local PlayerChangeSkinTeamRang = ""
local PlayerChangeSkinTeamRespect = ""
local PlayerChangeSkinTeamRespectNextLevel = ""
local OriginalArr = false
local RespectTempFileTimers = false
local GTASound = false
local tuningList = false
local ToC1, ToC2, ToC3, ToC4 = false, false, false, false
local upgrades = false
local TCButton = {}
local TCButton2 = {}
local usableslot = 1
local CallPolice = false
local BANKCTL = false
local Targets = {}
local MyHouseBlip = {}
local SpawnPoints = {}
local initializedInv = false
local DragElement = false
local DragElementId = false
local DragElementName = false
local DragStart = {}
local DragX = false
local DragY = false
local MouseX, MouseY = 0, 0
local PBut = {["player"] = {}, ["shop"] = {}, ["backpack"] = {}, ["trunk"] = {}}
local PInv = {["player"] = {}, ["shop"] = {}, ["backpack"] = {}, ["trunk"] = {}}
local InventoryMass = 0
local MaxMass = 0
local MassColor = tocolor(255,255,255,255)
local SleepTimer = false
local ArrestTimerEvent = false
local DrugsTimer = false
local SpunkTimer = false
local GPSObject = {}
local VehicleSpeed = 0
local SlowTahometer = 0
local screenSource = dxCreateScreenSource(screenWidth, screenHeight)
local IDF, NF, RANG, PING = false
local TabScroll = 1
local MAXSCROLL = math.floor((screenHeight/2.8)/dxGetFontHeight(scale/1.8, "default-bold"))
local TABCurrent = 0
local PText = {["biz"] = {}, ["bank"] = {}, ["INVHUD"] = {}, ["HUD"] = {}}
--[[ 
HUD:
	1 - DeathMatch
	2 - Встать с койки, DeathMatch 2
	3 - ChangeInfo
	4 - ChangeInfoAdv
	5 - helpmessage
	6 - MissionCompleted
	7 - MissionCompleted
	8 - input
	9 - очки ярости
--]]
local RespawnTimer = false
local RespectMsg = false

local BindedKeys = {} --[key] = {TriggerServerEvent(unpack)}



function GetDistance(a,b)
	local x,y,z = getElementPosition(a)
	local x2,y2,z2 = getElementPosition(b)
	return getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
end



function MinusToPlus(var)
	if(var < 0) then
		var = var-var-var
	end
	return var
end



local trafficlight = {
	["0"] = "west",
	["1"] = "west",
	["2"] = false,
	["3"] = "north",
	["4"] = "north"
}

local TexturesSize = {
	["HUD"] = {
		["LocationTarget"] = NewScale*4, 
		["ArrowTarget"] = NewScale*3, 
		["Wanted"] = NewScale*2, 
	}, 
}



 


function dxDrawCircleCustom( posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI, text)
	if(startAngle == stopAngle) then
		return false
	end
 
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
 
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
 
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
 
	local n = 0
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
		dxDrawLine(startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI)
		if(text) then
			dxDrawText(n, (startX/1.17)+posX,(startY/1.17)+posY, (startX/1.17)+posX,(startY/1.17)+posY, tocolor(160,160,160,255), scale/2, "default-bold", "center", "center")
			n=n+1
		end
	end
	return true
end


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning)
	if(text) then
		local r,g,b = bitExtract(color, 0, 8), bitExtract(color, 8, 8), bitExtract(color, 16, 8)
		if(r+g+b >= 100) then r = 0 g = 0 b = 0 else r = 255 g = 255 b = 255 end
		local textb = string.gsub(text, "#%x%x%x%x%x%x", "")
		local locsca = math.round(scale, 0)
		if (locsca == 0) then locsca = 1 end
		for oX = -locsca, locsca do 
			for oY = -locsca, locsca do 
				dxDrawText(textb, left + oX, top + oY, right + oX, bottom + oY, tocolor(r, g, b, bitExtract(color, 24, 8)), scale, font, alignX, alignY, clip, wordBreak,postGUI,false, not PData["Interface"]["LowPC"])
			end
		end

		dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true, not PData["Interface"]["LowPC"])
	end
end




local VehicleType = {
	[441] = "RC", 
	[464] = "RC", 
	[594] = "RC", 
	[501] = "RC", 
	[465] = "RC", 
	[564] = "RC", 
}
function GetVehicleType(theVehicle)
	if(isElement(theVehicle)) then theVehicle = getElementModel(theVehicle) end
	return VehicleType[theVehicle] or getVehicleType(theVehicle)
end





local abx,aby,abz = false
local air_brake = false



function putPlayerInPosition(timeslice)
	local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
	ctx,cty = ctx-cx,cty-cy
	timeslice = timeslice*0.1
	if getKeyState("num_7") then timeslice = timeslice*4 end
	if getKeyState("num_9") then timeslice = timeslice*0.25 end
	local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
	ctx,cty = ctx*mult,cty*mult
	if getKeyState("w") then abx,aby = abx+ctx,aby+cty end
	if getKeyState("s") then abx,aby = abx-ctx,aby-cty end
	if getKeyState("d") then abx,aby = abx+cty,aby-ctx end
	if getKeyState("a") then abx,aby = abx-cty,aby+ctx end
	if getKeyState("space") then abz = abz+timeslice end
	if getKeyState("lshift") then abz = abz-timeslice end
	setElementRotation(localPlayer,0,0, getPedCameraRotation(localPlayer), "ZXY", true)
	setElementPosition(localPlayer,abx,aby,abz)
end

function toggleAirBrake()
	if(getPlayerName(localPlayer) ~= "alexaxel705") then
		local rand = math.random(1,100)
		if(rand ~= 1) then
			ToolTip("Чит код не сработал")
			return false
		end
	end
	air_brake = not air_brake or nil
	if air_brake then
		abx,aby,abz = getElementPosition(localPlayer)
		addEventHandler("onClientPreRender", root, putPlayerInPosition)
	else
		abx,aby,abz = nil
		removeEventHandler("onClientPreRender", root, putPlayerInPosition)
	end
end
addCommandHandler("noclip", toggleAirBrake)



local Collections = {
	[953] = {
		["San Fierro"] = {
			[1] = {-2657, 1564, -6}, 
			[2] = {-1252, 501, -8}, 
			[3] = {-1625, 4, -10}, 
			[4] = {-1484, 1489, -10}, 
			[5] = {-2505.4, 1543.7, -22.6}, 
			[6] = {-2727, -469, -5}, 
			[7] = {-1364, 390, -5}, 
		},
		["The Visage"] = {
			[8] = {2090, 1898, 8}, 
		},
		["Bone County"] = {
			[9] = {796, 2939, -5}, 
		},
		["The Sherman Dam"] = {
			[10] = {-783, 2116, 35}, 
		},
		["Verdant Bluffs"] = {
			[11] = {979, -2210, -3}, 
		},
		["Mount Chiliad"] = {
			[12] = {-2889, -1042, -9}, 
		},
		["Garver Bridge"] = {
			[13] = {-1266, 966, -10}, 
		},
		["Red County"] = {
			[14] = {-1013, 478, -7}, 
			[15] = {486, -253, -4}, 
			[16] = {40, -531, -8}, 
			[17] = {-765, 247, -8}, 
			[18] = {2767, 470, -8}, 
			[19] = {2179, 235, -5}, 
		},
		["Flint County"] = {
			[20] = {-90, -910, -5}, 
			[21] = {26.4, -1320.9, -10}, 
			[22] = {-207, -1682, -8}, 
			[23] = {-1175, -2639, -2.5}, 
			[24] = {-1097, -2858, -8}, 
		},
		["Tierra Robada"] = {
			[25] = {-832, 925, -2}, 
			[26] = {-659, 874, -2}, 
			[27] = {-955, 2628, 35}, 
			[28] = {-1066, 2197, 32}, 
			[29] = {-821, 1374, -8}, 
			[30] = {-2110.5, 2329.7, -7.5}, 
			[31] = {-1538, 1708, -3.3}, 
			[32] = {-2685, 2153, -5}, 
		},
		["Come-A-Lot"] = {
			[33] = {2130, 1152, 7}, 
		},
		["Fisher's Lagoon"] = {
			[34] = {2098, -108, -2}, 
		},
		["Pilgrim"] = {
			[35] = {2531, 1569, 9}, 
		},
		["Pirates in Men's Pants"] = {
			[36] = {2013, 1670, 7}, 
		},
		["Whetstone"] = {
			[37] = {-1672, -1641, -2}, 
		},
		["Marina"] = {
			[38] = {723, -1586, -3}, 
		},
		["Las Venturas"] = {
			[39] = {2998, 2998, -10}, 
		},
		["Glen Park"] = {
			[40] = {1968, -1203, 17}, 
		},
		["Los Santos"] = {
			[41] = {67, -1018, -5}, 
			[42] = {2327, -2662, -5}, 
			[43] = {1249, -2687, -1}, 
		},
		["Santa Maria Beach"] = {
			[44] = {155, -1975, -8}, 
		},
		["Roca Escalante"] = {
			[45] = {2578, 2382, 16}, 
		},
		["Playa del Seville"] = {
			[46] = {2945.1, -2051.9, -3}, 
		},
		["Mulholland"] = {
			[47] = {1279, -806, 85}, 
		},
		["Verona Beach"] = {
			[48] = {725, -1849, -5}, 
		},
		["Ocean Docks"] = {
			[49] = {2750, -2584, -5}, 
			[50] = {2621, -2506, -5}, 
		},
	},
	[954] = {
		["The Four Dragons Casino"] = {
			[1] = {1934.1, 988.8, 22}, 
		},
		["Rockshore East"] = {
			[2] = {2864, 857, 13}, 
		},
		["Greenglass College"] = {
			[3] = {1084, 1076, 11}, 
		},
		["Las Venturas Airport"] = {
			[4] = {1603, 1435, 11}, 
			[5] = {1521, 1690, 10.6}, 
			[6] = {1393, 1832, 12.3}, 
		},
		["Pilson Intersection"] = {
			[7] = {1376, 2304, 15}, 
		},
		["Yellow Bell Golf Course"] = {
			[8] = {1433, 2796, 20}, 
		},
		["Blackfield Chapel"] = {
			[9] = {1526.2, 751, 29}, 
		},
		["The Visage"] = {
			[10] = {2077, 1912, 14}, 
		},
		["Pirates in Men's Pants"] = {
			[11] = {2003, 1672, 12}, 
		},
		["The Emerald Isle"] = {
			[12] = {2035, 2305, 18}, 
			[13] = {2020, 2352, 11}, 
			[14] = {2173, 2465, 11}, 
			[15] = {2031.3, 2207.3, 11}, 
		},
		["LVA Freight Depot"] = {
			[16] = {1462, 936, 10}, 
		},
		["K.A.C.C. Military Fuels"] = {
			[17] = {2626, 2841, 11}, 
		},
		["Whitewood Estates"] = {
			[18] = {919, 2070, 11}, 
			[19] = {970, 1787, 11}, 
		},
		["Rockshore West"] = {
			[20] = {2071, 712, 11}, 
			[21] = {2125.5, 789.2, 11.4}, 
		},
		["Redsands West"] = {
			[22] = {1680.3, 2226.9, 16.1}, 
			[23] = {1582, 2401, 19}, 
		},
		["Redsands East"] = {
			[24] = {1863, 2314, 15}, 
			[25] = {2058.7, 2159.1, 16}, 
		},
		["Royal Casino"] = {
			[26] = {2274, 1507, 24}, 
		},
		["Julius Thruway East"] = {
			[27] = {2706, 1862.5, 24.4}, 
		},
		["Starfish Casino"] = {
			[28] = {2371, 2009, 15}, 
			[29] = {2588, 1902, 15}, 
			[30] = {2215, 1968, 11}, 
		},
		["Randolph Industrial Estate"] = {
			[31] = {1767, 601, 13}, 
		},
		["Blackfield Intersection"] = {
			[32] = {1362.9, 1015.2, 11}, 
		},
		["Las Venturas"] = {
			[33] = {2054, 2434, 166}, 
			[34] = {984, 2563, 12}, 
			[35] = {2493, 922, 16}, 
		},
		["Creek"] = {
			[36] = {2879, 2522, 11}, 
		},
		["Roca Escalante"] = {
			[37] = {2491, 2263, 15}, 
			[38] = {2583, 2387, 16}, 
		},
		["The Camel's Toe"] = {
			[39] = {2323, 1284, 97}, 
			[40] = {2417, 1281, 21}, 
		},
		["Prickle Pine"] = {
			[41] = {1224, 2617, 11}, 
			[42] = {1768, 2847, 9}, 
			[43] = {1881, 2846, 11}, 
		},
		["Come-A-Lot"] = {
			[44] = {2238, 1135, 49}, 
			[45] = {2108, 1003, 46}, 
			[46] = {2509, 1144, 19}, 
		},
		["Julius Thruway North"] = {
			[47] = {2184, 2529, 11}, 
		},
		["Old Venturas Strip"] = {
			[48] = {2612, 2200, -1}, 
			[49] = {2440.1, 2161.1, 20}, 
		},
		["The Clown's Pocket"] = {
			[50] = {2239, 1839, 18}, 
		},
	},
	[1276] = {
		["San Fierro"] = {
			[1] = {-1504.9, 1374.3, 3.9}, 
		},
		["Bone County"] = {
			[2] = {755.7, 2060.3, 6.7}, 
			[3] = {797.2, 1669.3, 5.3}, 
			[4] = {710.4, 1207.6, 13.8}, 
			[5] = {-101.9, 1228.1, 22.4}, 
		},
		["Avispa Country Club"] = {
			[6] = {-2762.7, -262.4, 7.2}, 
		},
		["Juniper Hollow"] = {
			[7] = {-2317.4, 1066.9, 66.7}, 
		},
		["Fisher's Lagoon"] = {
			[8] = {2102.6, -105.7, 2.2}, 
		},
		["Ocean Flats"] = {
			[9] = {-2797.6, -124.2, 7.2}, 
		},
		["Los Santos International"] = {
			[10] = {2197.9, -2619.7, 13.5}, 
			[11] = {1470.3, -2311.9, 13.5}, 
			[12] = {1651, -2266.8, -1.3}, 
			[13] = {1383.5, -2586.2, 13.5}, 
			[14] = {1627.5, -2286.5, 94.1}, 
		},
		["Come-A-Lot"] = {
			[15] = {2365.6, 1006.3, 10.8}, 
		},
		["Cranberry Station"] = {
			[16] = {-1973.1, 114.8, 30.6}, 
		},
		["City Hall"] = {
			[17] = {-2708, 378, 12}, 
		},
		["Mulholland"] = {
			[18] = {1292, -907.4, 42.9}, 
		},
		["Julius Thruway North"] = {
			[19] = {2225, 2529.6, 17.4}, 
		},
		["Montgomery"] = {
			[20] = {1236.8, 374.4, 19.6}, 
		},
		["Queens"] = {
			[21] = {-2494.8, 314.4, 29.2}, 
		},
		["Doherty"] = {
			[22] = {-2060.1, 254.6, 37.1}, 
			[23] = {-2018.1, -104.8, 35}, 
			[24] = {-2222.5, -302, 42.8}, 
		},
		["Bayside Marina"] = {
			[25] = {-2250.1, 2418.2, 2.5}, 
		},
		["Richman"] = {
			[26] = {782.9, -1019.9, 26.4}, 
		},
		["Calton Heights"] = {
			[27] = {-2173.7, 1213.2, 37.3}, 
		},
		["Vinewood"] = {
			[28] = {745.5, -1381.4, 25.7}, 
		},
		["Verona Beach"] = {
			[29] = {836.4, -1855.6, 8.4}, 
		},
		["Mount Chiliad"] = {
			[30] = {-2229.4, -1741.3, 480.9}, 
			[31] = {-2672.1, -980.7, 1.3}, 
		},
		["LVA Freight Depot"] = {
			[32] = {1752.9, 980.5, 12.9}, 
		},
		["El Quebrados"] = {
			[33] = {-1417.3, 2579, 55.8}, 
		},
		["Tierra Robada"] = {
			[34] = {-943.9, 1432.2, 30.1}, 
		},
		["Redsands East"] = {
			[35] = {1980.7, 2166.1, 11.1}, 
			[36] = {1976.3, 2266.9, 27.2}, 
			[37] = {1972.6, 2294.7, 16.5}, 
			[38] = {1939.4, 2375.5, 23.9}, 
			[39] = {1875.3, 2076.4, 16.1}, 
		},
		["Randolph Industrial Estate"] = {
			[40] = {1628.3, 600.6, 1.8}, 
		},
		["Roca Escalante"] = {
			[41] = {2288.3, 2442.9, 10.8}, 
		},
		["The Camel's Toe"] = {
			[42] = {2339.7, 1305, 67.5}, 
		},
		["Leafy Hollow"] = {
			[43] = {-1104.3, -1639.4, 76.4}, 
		},
		["Caligula's Palace"] = {
			[44] = {2406.2, 1681.4, 14.3}, 
		},
		["Market"] = {
			[45] = {1248.3, -1250, 63.7}, 
			[46] = {1073.8, -1303.7, 17.1}, 
		},
		["Missionary Hill"] = {
			[47] = {-2531.8, -704.7, 139.3}, 
		},
		["Restricted Area"] = {
			[48] = {164.1, 1849.9, 33.9}, 
			[49] = {232, 1858.2, 15.8}, 
		},
		["Idlewood"] = {
			[50] = {2070.5, -1549.5, 13.4}, 
		},
		["Commerce"] = {
			[51] = {1363.4, -1794, 36}, 
			[52] = {1720.8, -1473, 13.6}, 
		},
		["Downtown Los Santos"] = {
			[53] = {1511.6, -1363, 13.9}, 
		},
		["Green Palms"] = {
			[54] = {246.8, 1435.2, 23.4}, 
		},
		["Las Venturas"] = {
			[55] = {2044.4, 2377, 143.6}, 
			[56] = {2809.7, 2972.3, 1.2}, 
		},
		["Santa Maria Beach"] = {
			[57] = {153.8, -1954, 47.9}, 
			[58] = {498.5, -1870.7, 4.7}, 
		},
		["Pilgrim"] = {
			[59] = {2454.5, 1499.5, 11.6}, 
		},
		["Angel Pine"] = {
			[60] = {-2155.8, -2352.2, 30.7}, 
		},
		["Glen Park"] = {
			[61] = {1915.3, -1354.9, 23.4}, 
		},
		["Kincaid Bridge"] = {
			[62] = {-1113.2, 845.5, 3.1}, 
		},
		["Yellow Bell Golf Course"] = {
			[63] = {1488.7, 2773.9, 10.8}, 
			[64] = {1432.6, 2751.3, 19.5}, 
		},
		["Las Payasadas"] = {
			[65] = {-242.2, 2712.4, 66.8}, 
		},
		["Valle Ocultado"] = {
			[66] = {-910.2, 2672.3, 42.4}, 
		},
		["Verdant Bluffs"] = {
			[67] = {1690.8, -1966.3, 8.5}, 
			[68] = {1093.3, -2026, 69}, 
		},
		["Flint Intersection"] = {
			[69] = {-91.1, -1577.9, 2.6}, 
		},
		["Prickle Pine"] = {
			[70] = {1265.5, 2609.4, 10.8}, 
		},
		["Flint Range"] = {
			[71] = {-362.9, -1417.4, 29.6}, 
		},
		["San Fierro Bay"] = {
			[72] = {-2415.2, 1554.3, 26}, 
		},
		["Las Venturas Airport"] = {
			[73] = {1715.4, 1313.3, 10.8}, 
			[74] = {1690, 1484, 11.7}, 
			[75] = {1580.7, 1488.9, 17.2}, 
			[76] = {1617.8, 1440, 25.7}, 
			[77] = {1308.1, 1261.4, 14.3}, 
		},
		["Ganton"] = {
			[78] = {2482.7, -1642.6, 23.4}, 
			[79] = {2320.6, -1631.8, 14.7}, 
		},
		["Las Colinas"] = {
			[80] = {2013.8, -962.7, 42.5}, 
			[81] = {2426.5, -1015.3, 54.3}, 
		},
		["The Visage"] = {
			[82] = {2094.8, 1890.3, 10.4}, 
		},
		["Whetstone"] = {
			[83] = {-1848.5, -1708.7, 41.1}, 
			[84] = {-1619.6, -2690.4, 48.7}, 
		},
		["Red County"] = {
			[85] = {875.3, -589.4, 18}, 
		},
		["Palisades"] = {
			[86] = {-2912.9, 1241.7, 1.4}, 
		},
		["Blueberry"] = {
			[87] = {194.1, -234.6, 1.8}, 
		},
		["Los Santos"] = {
			[88] = {1531, -1370.2, 330.1}, 
		},
		["Rodeo"] = {
			[89] = {401.9, -1624.8, 34.2}, 
		},
		["Easter Bay Airport"] = {
			[90] = {-1539.9, -438.1, 6}, 
			[91] = {-1611.1, -697.1, 2}, 
		},
		["Ocean Docks"] = {
			[92] = {2233.4, -2283.1, 14.4}, 
			[93] = {2768.5, -2568.8, 3}, 
		},
		["East Beach"] = {
			[94] = {2666.1, -1438.7, 16.3}, 
			[95] = {2866.2, -1588.5, 22.4}, 
			[96] = {2820.2, -1467.4, 36.1}, 
			[97] = {2680.1, -1807.3, 31.4}, 
		},
		["Juniper Hill"] = {
			[98] = {-2278.6, 629.8, 53.1}, 
			[99] = {-2446.8, 758, 41.3}, 
		},
		["Downtown"] = {
			[100] = {-1970.2, 706, 48}, 
		},
	}
}









function save()
	local x,y,z = getElementPosition(localPlayer)
	local rx,ry,rz = getElementRotation(localPlayer)
	if(getPedOccupiedVehicle(localPlayer)) then
		x,y,z = getElementPosition(getPedOccupiedVehicle(localPlayer))
		if(not getElementData(localPlayer, "City")) then 
			z = getGroundPosition(x,y,z)
		else
			z = z-1
		end
		outputChatBox(math.round(x, 1)..", "..math.round(y, 1)..", "..math.round(z, 1)) 
		rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
		outputChatBox(math.round(rz, 0))
	else
		outputChatBox(math.round(x, 1)..", "..math.round(y, 1)..", "..math.round(z, 1)) 
		outputChatBox(math.round(rz, 0))
	end
	triggerServerEvent("saveserver", localPlayer, localPlayer, x,y,z,rx,ry,rz)
end

local SaveTimer = false
function saveauto()
	if(PData["Driver"]) then
		if(not isTimer(SaveTimer)) then
			helpmessage("Запись начата")
			SaveTimer = setTimer(function() 
				if(PData["Driver"]["Distance"] > 10) then
					PData["Driver"]["Distance"] = 0
					save()
				end
			end, 50, 0)
		else
			helpmessage("Запись остановлена")
			killTimer(SaveTimer)
		end
	end
end


function cursor() 
    if isCursorShowing(thePlayer) then
		showCursor(false)
	else
		showCursor(true)
    end

end


if getPlayerName(localPlayer) == "alexaxel705" or getPlayerName(localPlayer) == "Mishel'"  then
	bindKey("num_1", "down", saveauto) 
	bindKey("F2", "down", cursor) 
end
bindKey("num_3", "down", save) -- Для всех

local Day = {
	[1] = "ВС",
	[2] = "ПН",
	[3] = "ВТ",
	[4] = "СР",
	[5] = "ЧТ",
	[6] = "ПТ",
	[7] = "СБ"
}
			
local Month = {
	[1] = "Января",
	[2] = "Февраля",
	[3] = "Марта",
	[4] = "Апреля",
	[5] = "Мая",
	[6] = "Июня",
	[7] = "Июля",
	[8] = "Августа",
	[9] = "Сентября",
	[10] = "Октября",
	[11] = "Ноября",
	[12] = "Декабря"
}

function Set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end



local WeaponTiming = {
	[16] = 1500,
	[17] = 1500,
	[18] = 1500
}


local WeaponNamesArr = {
	["АК-47"] = 30,
	["Граната"] = 16,
	["Газовая граната"] = 17, 
	["Взрывчатка"] = 39,
	["Молотов"] = 18,
	["Кольт 45"] = 22,
	["USP-S"] = 23,
	["Deagle"] = 24,
	["М16"] = 31,
	["Mossberg"] = 25,
	["Sawed-Off"] = 26,
	["SPAS-12"] = 27,
	["Узи"] = 28,
	["MP5"] = 29,
	["Tec-9"] = 32,
	["ИЖ-12"] = 33,
	["M40"] = 34,
	["Dildo XXL"] = 10,
	["Dildo"] = 11,
	["Вибратор"] = 12,
	["Клюшка"] = 2,
	["Бита"] = 5,
	["Дубинка"] = 3,
	["Лопата"] = 6,
	["Кастет"] = 1,
	["Миниган"] = 38,
	["Цветы"] = 14, 
	["Трость"] = 15, 
	["Камера"] = 43,
	["Огнетушитель"] = 42,
	["Спрей"] = 41,
	["Базука"] = 35,
	["Ракетная установка"] = 36, 
	["Огнемет"] = 37,
	["Бензопила"] = 9,
	["Нож"] = 4,
	["Катана"] = 8, 
	["Удочка"] = 7,
	["Парашют"] = 46,
	["Рюкзак"] = 3026,
	["Чемодан"] = 1210,
	["Канистра"] = 1650,
	["Пакет"] = 2663,
	["Запаска"] = 1025,
	["Нефть"] = 3632, 
	["Пропан"] = 1370, 
	["Химикаты"] = 1218,
	["Бензин"] = 1225, 
	["Удобрения"] = 1222, 
	["Алкоголь"] = 2900, 
	["Мясо"] = 2805, 
	["Зерно"] = 1453
}



local ColorArray = {"000000","F5F5F5",
"2A77A1","840410",
"263739","86446E",
"D78E10","4C75B7",
"BDBEC6","5E7072",
"46597A","656A79",
"5D7E8D","58595A",
"D6DAD6","9CA1A3",
"335F3F","730E1A",
"7B0A2A","9F9D94",
"3B4E78","732E3E",
"691E3B","96918C",
"515459","3F3E45",
"A5A9A7","635C5A",
"3D4A68","979592",
"421F21","5F272B",
"8494AB","767B7C",
"646464","5A5752",
"252527","2D3A35",
"93A396","6D7A88",
"221918","6F675F",
"7C1C2A","5F0A15",
"193826","5D1B20",
"9D9872","7A7560",
"989586","ADB0B0",
"848988","304F45",
"4D6268","162248",
"272F4B","7D6256",
"9EA4AB","9C8D71",
"6D1822","4E6881",
"9C9C98","917347",
"661C26","949D9F",
"A4A7A5","8E8C46",
"341A1E","6A7A8C",
"AAAD8E","AB988F",
"851F2E","6F8297",
"585853","9AA790",
"601A23","20202C",
"A4A096","AA9D84",
"78222B","0E316D",
"722A3F","7B715E",
"741D28","1E2E32",
"4D322F","7C1B44",
"2E5B20","395A83",
"6D2837","A7A28F",
"AFB1B1","364155",
"6D6C6E","0F6A89",
"204B6B","2B3E57",
"9B9F9D","6C8495",
"4D5D60","AE9B7F",
"406C8F","1F253B",
"AB9276","134573",
"96816C","64686A",
"105082","A19983",
"385694","525661",
"7F6956","8C929A",
"596E87","473532",
"44624F","730A27",
"223457","640D1B",
"A3ADC6","695853",
"9B8B80","620B1C",
"5B5D5E","624428",
"731827","1B376D",
"EC6AAE"}





local SpawnAction = {}
function PlayerSpawn()
	triggerEvent("onClientElementStreamIn", localPlayer)
	local x,y,z = getElementPosition(localPlayer)
	local zone = getZoneName(x,y,z)
	PData["stamina"] = 5+math.floor(getPedStat(localPlayer, 22)/40)
	for v,k in pairs(GPSObject) do
		destroyElement(GPSObject[v])
		GPSObject[v] = nil
		destroyElement(v)
	end
	PInv["player"] = fromJSON(getElementData(localPlayer, "inv"))
	SetupInventory() 
	PData["wasted"] = nil
	SetPlayerHudComponentVisible("all", true)
	
	for i = 1, #SpawnAction do
		triggerEvent(unpack(SpawnAction[i]))
	end
	SpawnAction = {}
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), PlayerSpawn)
addEvent("PlayerSpawn", true)
addEventHandler("PlayerSpawn", getRootElement(), PlayerSpawn)


function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end





function SetZoneDisplay(zone, notzone)
	if(zone ~= "Unknown") then
		if(zone == "Yellow Bell Station") then zone = "Koyoen Station" end
		
		if(ZonesDisplay[#ZonesDisplay]) then
			if(ZonesDisplay[#ZonesDisplay][3]) then
				if(ZonesDisplay[#ZonesDisplay][3] > 255) then
					ZonesDisplay[#ZonesDisplay][3] = 255 -- Для ускорения
				end
			else
				ZonesDisplay[#ZonesDisplay][3] = "fast"
			end
		end
		ZonesDisplay[#ZonesDisplay+1] = {zone, 0, false}
	end
	
	if(not notzone) then
		exports["vehicle_node"]:LoadZone(getPlayerCity(localPlayer), zone)
	end
end
addEvent("SetZoneDisplay", true)
addEventHandler("SetZoneDisplay", getRootElement(), SetZoneDisplay)







addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()),  
function()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if(getElementData(source, "ped")) then
		playSFX("genrl", 53, 5, false)
		if(getElementData(source, "data") == "SwitchButtonR") then
			NextSkinPlus()
		elseif(getElementData(source, "data") == "SwitchButtonL") then
			NextSkinMinus()
		elseif(getElementData(source, "data") == "SwitchButtonAccept") then
			NextSkinEnter()
		elseif(getElementData(source, "data") == "NewSwitchButtonL") then
			NewNextSkinMinus()
		elseif(getElementData(source, "data") == "NewSwitchButtonAccept") then
			NewNextSkinEnter()
		elseif(getElementData(source, "data") == "NewSwitchButtonR") then
			NewNextSkinPlus()
		end 
	elseif(getElementData(source, "TuningColor1")) then
		OriginVehicleUpgrade(theVehicle)
		local c1,c2,c3,c4 = getVehicleColor(theVehicle)
		if(c1 ~= getElementData(source, "TuningColor1")) then
			setVehicleColor(theVehicle, getElementData(source, "TuningColor1"), c2, c3, c4)
			playSFX("genrl", 53, 5, false)
			helpmessage("Перекрасить\n$500")
		else
			if(getElementData(source, "TuningColor1") ~= ToC1) then
				playSFX("genrl", 53, 6, false)
				triggerServerEvent("BuyColor", localPlayer, c1,c2,c3,c4,500)
			else
				helpmessage("Твой авто уже такого цвета!")
			end
		end
	elseif(getElementData(source, "TuningColor2")) then
		OriginVehicleUpgrade(theVehicle)
		local c1,c2,c3,c4 = getVehicleColor(theVehicle)
		if(c2 ~= getElementData(source, "TuningColor2")) then
			setVehicleColor(theVehicle, c1, getElementData(source, "TuningColor2"), c3, c4)
			playSFX("genrl", 53, 5, false)
			helpmessage("Перекрасить\n$500")
		else
			if(getElementData(source, "TuningColor2") ~= ToC2) then
				playSFX("genrl", 53, 6, false)
				triggerServerEvent("BuyColor", localPlayer, c1,c2,c3,c4,500)
			else
				helpmessage("Твой авто уже такого цвета!")
			end
		end
	end
end)  



function OriginVehicleUpgrade(theVehicle)
	for upgradeKey, upgradeValue in ipairs (getVehicleUpgrades(theVehicle)) do removeVehicleUpgrade(theVehicle, upgradeValue) end
	for upgradeKey, upgradeValue in ipairs (upgrades) do addVehicleUpgrade(theVehicle, upgradeValue) end
	return true
end



local Upgrading = {
	[1] = {
		["text"] = "Двигатель",
		["data"] = {}
	},
	[2] = {
		["text"] = "Турбонаддув",
		["data"] = {}
	},
	[3] = {
		["text"] = "Трансмиссия",
		["data"] = {}
	},
	[4] = {
		["text"] = "Подвеска",
		["data"] = {}
	},
	[5] = {
		["text"] = "Тормоза",
		["data"] = {}
	},
	[6] = {
		["text"] = "Шины",
		["data"] = {}
	},
	[7] = {
		["text"] = "Крыша",
		["data"] = {
			{"Scoop", 1006, 1000},
			{"Alien ver.3", 1032, 10000},
			{"X-Flow ver.1", 1033, 10000},
			{"X-Flow ver.3", 1053, 10000},
			{"Alien ver.5", 1054, 10000},
			{"Alien ver.6", 1055, 10000},
			{"Alien ver.4", 1038, 10000},
			{"X-Flow ver.2", 1035, 10000},
			{"X-Flow ver.4", 1061, 10000},
			{"Alien ver.1", 1067, 10000},
			{"X-Flow ver.5", 1068, 10000},
			{"Covertible", 1103, 10000},
			{"Alien ver.2", 1088, 10000},
			{"X-Flow ver.6", 1091, 10000},
			{"Vinyl Hardtop", 1128, 10000},
			{"Hardtop", 1130, 10000},
			{"Softtop", 1131, 10000}
		}
	},
	[8] = {
		["text"] = "Боковые юбки",
		["data"] = {
			{"noname", 1007, 900},
			{"Alien ver.1", 1026, 10000},
			{"X-Flow ver.1", 1031, 10000},
			{"X-Flow ver.2", 1039, 10000},
			{"Alien ver.2", 1040, 10000},
			{"Chrome ver.1", 1042, 10000},
			{"Alien ver.3", 1047, 10000},
			{"X-Flow ver.3", 1048, 10000},
			{"Alien ver.4", 1056, 10000},
			{"X-Flow ver.4", 1057, 10000},
			{"Alien ver.5", 1069, 10000},
			{"X-Flow ver.5", 1070, 10000},
			{"X-Flow ver.6", 1093, 10000},
			{"Chrome ver.2", 1099, 10000},
			{"Chrome Flames ver.1", 1101, 10000},
			{"Chrome Strip ver.1", 1102, 10000},
			{"Alien ver.6", 1090, 10000},
			{"Chrome Arches", 1106, 10000},
			{"Chrome Strip ver.2", 1107, 10000},
			{"Chrome Trim", 1118, 10000},
			{"Wheelcovers", 1119, 10000},
			{"Chrome Flames ver.2", 1122, 10000},
			{"Chrome Strip ver.3", 1133, 10000},
			{"Chrome Strip ver.4", 1134, 10000},
			{"Chrome Arches", 1124, 10000}
		}
	},
	[9] = {
		["text"] = "Противотуманки",
		["data"] = {
			{"Круглые", 1013, 3500},
			{"Квадратные", 1024, 4500}
		}
	},
	[10] = {
		["text"] = "Выхлопная труба",
		["data"] = {
			{"Upswept", 1018, 2200},
			{"Twin", 1019, 3100},
			{"Large", 1020, 3500},
			{"Medium", 1021, 3000},
			{"Small", 1022, 2500},
			{"Alien ver.1", 1028, 10000},
			{"X-Flow ver.1", 1029, 10000},
			{"Chrome ver.4", 1126, 10000},
			{"Slamin ver.4", 1127, 10000},
			{"Chrome ver.5", 1129, 10000},
			{"Slamin ver.5", 1132, 10000},
			{"Slamin ver.6", 1135, 10000},
			{"Chrome ver.6", 1136, 10000},
			{"Chrome ver.3", 1113, 10000},
			{"Slamin ver.3", 1114, 10000},
			{"Alien ver.2", 1034, 10000},
			{"X-Flow ver.2", 1037, 10000},
			{"Slamin ver.1", 1043, 10000},
			{"Chrome ver.1", 1044, 10000},
			{"X-Flow ver.3", 1045, 10000},
			{"Alien ver.3", 1046, 10000},
			{"X-Flow ver.4", 1059, 10000},
			{"Alien ver.4", 1064, 10000},
			{"Alien ver.5", 1065, 10000},
			{"X-Flow ver.5", 1066, 10000},
			{"Chrome ver.2", 1104, 10000},
			{"Slamin ver.2", 1105, 10000},
			{"Alien ver.6", 1092, 10000},
			{"X-Flow ver.6", 1089, 10000}
		}
	},
	[11] = {
		["text"] = "Колеса",
		["data"] = {
			{"Offroad", 1025, 1000},
			{"Shadow", 1073, 7500},
			{"Mega", 1074, 6000},
			{"Rimshine", 1075, 7000},
			{"Wires", 1076, 7500},
			{"Classic", 1077, 5500},
			{"Twist", 1078, 8500},
			{"Cutter", 1079, 8000},
			{"Switch", 1080, 8300},
			{"Grove", 1081, 6300},
			{"Import", 1082, 11600},
			{"Dollar", 1083, 4500},
			{"Trance", 1084, 3500},
			{"Atomic", 1085, 7200},
			{"Ahab", 1096, 10000},
			{"Virtual", 1097, 10000},
			{"Access", 1098, 10000},
		}
	},
	[12] = {
		["text"] = "Сабвуфер",
		["data"] = {
			{"сабвуфер", 1086, 15000}
		}
	},
	[13] = {
		["text"] = "Гидравлика",
		["data"] = {
			{"гидравлика", 1087, 25000}
		}
	},
	[14] = {
		["text"] = "Винил",
		["data"] = {
			{"Винил 1", 10, 10000},
			{"Винил 2", 11, 10000},
			{"Винил 3", 12, 10000},
			{"Винил 4", 13, 10000}
		}
	},
	[15] = {
		["text"] = "Задний кенгурятник",
		["data"] = {
			{"Chrome", 1109, 10000},
			{"Slamin", 1110, 10000}
		}
	},
	[17] = {
		["text"] = "Нитро",
		["data"] = {
			{"Нитро x2", 1008, 20000},
			{"Нитро x5", 1009, 45000},
			{"Нитро x10", 1010, 78000}
		}
	},
	[16] = {
		["text"] = "Передний кенгурятник",
		["data"] = {
			{"Chrome Grill", 1100, 10000},
			{"Chrome", 1115, 10000},
			{"Slamin", 1116, 10000},
			{"Chrome Bars", 1123, 10000},
			{"Chrome Lights", 1125, 10000}
		}
	},
	[18] = {
		["text"] = "Спойлер",
		["data"] = {
			{"PRO", 1000, 1100},
			{"WIN", 1001, 1200},
			{"Drag", 1002, 1250},
			{"Alpha", 1003, 1400},
			{"Fury", 1023, 1500},
			{"Alien ver.1", 1049, 10000},
			{"X-Flow ver.1", 1050, 10000},
			{"X-Flow ver.2", 1060, 10000},
			{"Alien ver.2", 1058, 10000},
			{"Alien ver.3", 1138, 10000},
			{"X-Flow ver.3", 1139, 10000},
			{"X-Flow ver.4", 1146, 10000},
			{"Alien ver.4", 1147, 10000},
			{"Alien ver.5", 1162, 10000},
			{"X-Flow ver.6", 1163, 10000},
			{"Alien ver.6", 1164, 10000},
			{"X-Flow ver.5", 1158, 10000}
		}
	},
	[19] = {
		["text"] = "Капот",
		["data"] = {
			{"ver.1", 1111, 10000},
			{"ver.2", 1112, 10000},
			{"ver.3", 1142, 10000},
			{"ver.4", 1143, 10000},
			{"ver.5", 1144, 10000},
			{"ver.6", 1145, 10000}
		}
	},
	[20] = {
		["text"] = "Передний бампер",
		["data"] = {
			{"Chrome ver.1", 1117, 10000},
			{"X-Flow ver.1", 1152, 10000},
			{"Alien ver.1", 1153, 10000},
			{"Alien ver.2", 1155, 10000},
			{"X-Flow ver.2", 1157, 10000},
			{"Alien ver.3", 1160, 10000},
			{"X-Flow ver.3", 1165, 10000},
			{"Alien ver.4", 1166, 10000},
			{"Alien ver.5", 1169, 10000},
			{"X-Flow ver.4", 1170, 10000},
			{"Alien ver.6", 1171, 10000},
			{"X-Flow ver.5", 1172, 10000},
			{"X-Flow ver.6", 1173, 10000},
			{"Chrome ver.2", 1174, 10000},
			{"Chrome ver.3", 1176, 10000},
			{"Chrome ver.4", 1179, 10000},
			{"Slamin ver.1", 1181, 10000},
			{"Chrome ver.5", 1182, 10000},
			{"Slamin ver.2", 1185, 10000},
			{"Slamin ver.3", 1188, 10000},
			{"Chrome ver.6", 1189, 10000},
			{"Slamin ver.4", 1190, 10000},
			{"Chrome ver.7", 1191, 10000}
		}
	},
	[21] = {
		["text"] = "Верх",
		["data"] = {
			{"Champ", 1004, 2300},
			{"Fury", 1005, 2250},
			{"Race", 1011, 2300},
			{"Worx", 1012, 2250}
		}
	},
	[22] = {
		["text"] = "Задний бампер",
		["data"] = {
			{"X-Flow ver.1", 1140, 10000},
			{"Alien ver.2", 1141, 10000},
			{"X-Flow ver.2", 1148, 10000},
			{"Alien ver.3", 1149, 10000},
			{"Alien ver.4", 1150, 10000},
			{"X-Flow ver.3", 1151, 10000},
			{"Alien ver.5", 1154, 10000},
			{"X-Flow ver.4", 1156, 10000},
			{"Alien ver.6", 1159, 10000},
			{"X-Flow ver.5", 1161, 10000},
			{"X-Flow ver.6", 1167, 10000},
			{"Alien ver.1", 1168, 10000},
			{"Slamin ver.1", 1175, 10000},
			{"Slamin ver.2", 1177, 10000},
			{"Slamin ver.3", 1178, 10000},
			{"Chrome ver.1", 1180, 10000},
			{"Slamin ver.4", 1183, 10000},
			{"Chrome ver.2", 1184, 10000},
			{"Slamin ver.5", 1186, 10000},
			{"Chrome ver.3", 1187, 10000},
			{"Chrome ver.4", 1192, 10000},
			{"Slamin ver.5", 1193, 10000}
		}
	},
	--[[[23] = {
		["text"] = "Цвет",
		["data"] = {
			{"Цвет 1", "color1", 100},
			{"Цвет 2", "color2", 100},
		}
	}, --]]
}





local OrigX, OrigY, OrigZ = false
function CameraTuning(handl, othercomp)
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	ToC1, ToC2, ToC3, ToC4 = getVehicleColor(theVehicle)
	upgrades = getVehicleUpgrades(theVehicle)
	OrigX, OrigY, OrigZ = getElementPosition(theVehicle)
	setCameraMatrix (OrigX-5, OrigY+4,OrigZ+1, OrigX, OrigY, OrigZ)
	showCursor(true)

	LoadUpgrade(true, handl, othercomp)

	
	local x,y = guiGetScreenSize()
	local S = 60
	local PosX=0
	local PosY=y-((y/S)*13)

	for slot = 1, #ColorArray do
		local r,g,b = hex2rgb(ColorArray[slot])
		if(slot <= 10) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-1)), PosY, x/S, y/S, slot, false)
		elseif(slot <= 20) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-11)), PosY+(y/S), x/S, y/S, slot, false)
		elseif(slot <= 30) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-21)), PosY+(y/S)*2, x/S, y/S, slot, false)
		elseif(slot <= 40) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-31)), PosY+(y/S)*3, x/S, y/S, slot, false)
		elseif(slot <= 50) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-41)), PosY+(y/S)*4, x/S, y/S, slot, false)
		elseif(slot <= 60) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-51)), PosY+(y/S)*5, x/S, y/S, slot, false)
		elseif(slot <= 70) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-61)), PosY+(y/S)*6, x/S, y/S, slot, false)
		elseif(slot <= 80) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-71)), PosY+(y/S)*7, x/S, y/S, slot, false)
		elseif(slot <= 90) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-81)), PosY+(y/S)*8, x/S, y/S, slot, false)
		elseif(slot <= 100) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-91)), PosY+(y/S)*9, x/S, y/S, slot, false)
		elseif(slot <= 110) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-101)), PosY+(y/S)*10, x/S, y/S, slot, false)
		elseif(slot <= 120) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-111)), PosY+(y/S)*11, x/S, y/S, slot, false)
		elseif(slot <= 130) then
			TCButton[slot] = guiCreateButton(PosX+((x/S)*(slot-121)), PosY+(y/S)*12, x/S, y/S, slot, false)
		end
		guiSetAlpha(TCButton[slot], 0)
		setElementData(TCButton[slot], "TuningColor1", slot-1)
	end
	guiSetAlpha(TCButton[ToC1+1], 0.5)
	
	local PosX=0+(x/S*11)

	for slot = 1, #ColorArray do
		local r,g,b = hex2rgb(ColorArray[slot])
		if(slot <= 10) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-1)), PosY, x/S, y/S, slot, false)
		elseif(slot <= 20) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-11)), PosY+(y/S), x/S, y/S, slot, false)
		elseif(slot <= 30) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-21)), PosY+(y/S)*2, x/S, y/S, slot, false)
		elseif(slot <= 40) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-31)), PosY+(y/S)*3, x/S, y/S, slot, false)
		elseif(slot <= 50) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-41)), PosY+(y/S)*4, x/S, y/S, slot, false)
		elseif(slot <= 60) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-51)), PosY+(y/S)*5, x/S, y/S, slot, false)
		elseif(slot <= 70) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-61)), PosY+(y/S)*6, x/S, y/S, slot, false)
		elseif(slot <= 80) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-71)), PosY+(y/S)*7, x/S, y/S, slot, false)
		elseif(slot <= 90) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-81)), PosY+(y/S)*8, x/S, y/S, slot, false)
		elseif(slot <= 100) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-91)), PosY+(y/S)*9, x/S, y/S, slot, false)
		elseif(slot <= 110) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-101)), PosY+(y/S)*10, x/S, y/S, slot, false)
		elseif(slot <= 120) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-111)), PosY+(y/S)*11, x/S, y/S, slot, false)
		elseif(slot <= 130) then
			TCButton2[slot] = guiCreateButton(PosX+((x/S)*(slot-121)), PosY+(y/S)*12, x/S, y/S, slot, false)
		end
		guiSetAlpha(TCButton2[slot], 0)
		setElementData(TCButton2[slot], "TuningColor2", slot-1)
	end
	guiSetAlpha(TCButton2[ToC2+1], 0.5)
end
addEvent("CameraTuning", true )
addEventHandler("CameraTuning", getRootElement(), CameraTuning)


	



local vinyl_vehicles={
    [483] = {0}, 
    [534] = {0,1,2}, 
    [535] = {0,1,2}, 
    [536] = {0,1,2}, 
    [558] = {0,1,2}, 
    [559] = {0,1,2}, 
    [560] = {0,1,2}, 
    [561] = {0,1,2}, 
    [562] = {0,1,2}, 
    [565] = {0,1,2}, 
    [567] = {0,1,2}, 
    [575] = {0,1}, 
    [576] = {0,1,2}, 
}

local TuningSelector = 1


local PartsMultipler = {
	["Tires"] = {
		["RC"] = {[1] = {0.20000000298023, 1.1000000238419}, [2] = {0.75, 0.89999997615814}, [3] = {0.49000000953674, 0.5}}, 
		["Trailer"] = {[1] = {0.44999998807907, 0.44999998807907}, [2] = {0.75, 0.75}, [3] = {0.5, 0.5}}, 
		["Plane"] = {[1] = {0.050000000745058, 1.5}, [2] = {0.80000001192093, 45}, [3] = {0.5, 0.85000002384186}}, 
		["Monster Truck"] = {[1] = {0.64999997615814, 0.77999997138977}, [2] = {0.80000001192093, 0.85000002384186}, [3] = {0.5, 0.55000001192093}}, 
		["Train"] = {[1] = {0.97000002861023, 0.97000002861023}, [2] = {0.76999998092651, 0.76999998092651}, [3] = {0.50999999046326, 0.50999999046326}}, 
		["Boat"] = {[1] = {-3.5, 3.5}, [2] = {3.5, 25}, [3] = {0.40000000596046, 1}}, 
		["Bike"] = {[1] = {1.2000000476837, 1.7999999523163}, [2] = {0.81999999284744, 0.89999997615814}, [3] = {0.46000000834465, 0.50999999046326}}, 
		["Automobile"] = {[1] = {0.5, 2.5}, [2] = {0.64999997615814, 0.9200000166893}, [3] = {0.34999999403954, 0.60000002384186}}, 
		["Quad"] = {[1] = {0.69999998807907, 0.69999998807907}, [2] = {0.89999997615814, 0.89999997615814}, [3] = {0.49000000953674, 0.49000000953674}}, 
	}, 
	["Turbo"] = {
		["Automobile"] = {[1] = {0, 2}, [2] = {0.7000000476837, 1}}, 
	}, 
	["Engines"] = {
		["RC"] = {[1] = {0.40000000596046, 20}, [2] = {0.20000000298023, 120}}, 
		["Trailer"] = {[1] = {7.1999998092651, 7.1999998092651}, [2] = {2, 2}}, 
		["Plane"] = {[1] = {0.68000000715256, 6.4000000953674}, [2] = {4, 20}}, 
		["Monster Truck"] = {[1] = {10, 18}, [2] = {2, 4}}, 
		["Train"] = {[1] = {8, 10}, [2] = {1, 3}}, 
		["Quad"] = {[1] = {10, 10}, [2] = {5, 5}}, 
		["BMX"] = {[1] = {7.1999998092651, 10}, [2] = {5, 7}}, 
		["Boat"] = {[1] = {0.20000000298023, 1.2000000476837}, [2] = {1, 1}}, 
		["Bike"] = {[1] = {12, 24}, [2] = {4, 5}}, 
		["Automobile"] = {[1] = {4.8000001907349, 16}, [2] = {1.3999999761581, 20}}, 
		["Unknown"] = {[1] = {8, 8}, [2] = {5, 5}}, 
		["Helicopter"] = {[1] = {6.4000000953674, 6.4000000953674}, [2] = {0.050000000745058, 0.20000000298023}}, 
	}, 
	["Brakes"] = {
		["RC"] = {[1] = {5.5, 5.5}}, 
		["Trailer"] = {[1] = {8, 8}}, 
		["Plane"] = {[1] = {0.0099999997764826, 1.5}}, 
		["Monster Truck"] = {[1] = {3.1700000762939, 7}}, 
		["Helicopter"] = {[1] = {5, 5}}, 
		["BMX"] = {[1] = {19, 19}}, 
		["Boat"] = {[1] = {0.019999999552965, 0.070000000298023}}, 
		["Bike"] = {[1] = {10, 15}}, 
		["Automobile"] = {[1] = {3.5, 15}}, 
		["Train"] = {[1] = {8.5, 8.5}}, 
	}, 
}





function GetVehiclePower(mass, acceleration) return math.ceil(mass/(140)*(acceleration)) end
function GetVehicleTopSpeed(acceleration, dragcoeff, maxvel)
	local pureMax = math.floor(math.sqrt(3300*acceleration/dragcoeff)*1.18) 
	if(pureMax < maxvel) then
		return (1000/348)*pureMax
	else
		return (1000/348)*maxvel
	end
end --При 26.5


function GetVehicleAcceleration(acceleration, tractionMultiplier) 
	local theVehicleType = GetVehicleType(getPedOccupiedVehicle(localPlayer))
	local minacc = PartsMultipler["Engines"][theVehicleType][1][1]-PartsMultipler["Turbo"][theVehicleType][1][1]
	local maxacc = PartsMultipler["Engines"][theVehicleType][1][2]+PartsMultipler["Turbo"][theVehicleType][1][2]
	
	return ((GetValPer(minacc, maxacc, acceleration)*10)/2)+(GetVehicleClutch(tractionMultiplier)/2)
end 



function GetVehicleClutch(tractionMultiplier)
	local theVehicleType = GetVehicleType(getPedOccupiedVehicle(localPlayer))
	return GetValPer(PartsMultipler["Tires"][theVehicleType][1][1], PartsMultipler["Tires"][theVehicleType][1][2], tractionMultiplier)*10
end


function GetVehicleControl(tractionBias)
	local theVehicleType = GetVehicleType(getPedOccupiedVehicle(localPlayer))
	return GetValPer(PartsMultipler["Tires"][theVehicleType][3][1], PartsMultipler["Tires"][theVehicleType][3][2], tractionBias)*10
end


function GetValPer(mins, maxs, raw)
	mins = math.round(mins, 2)
	maxs = math.round(maxs, 2)
	raw = math.round(raw, 2)
    return (raw-mins)/(maxs-mins)*100
end
 


function GetElementAttacker(element)
	local attacker = getElementData(element, "attacker")
	if(attacker) then
		attacker = getPlayerFromName(attacker)
	end
	return attacker
end



function GetVehicleBrakes(brakes, tractionLoss)
	local theVehicleType = GetVehicleType(getPedOccupiedVehicle(localPlayer))
	return ((GetValPer(PartsMultipler["Brakes"][theVehicleType][1][1], PartsMultipler["Brakes"][theVehicleType][1][2], brakes)*10)/2)+
		((GetValPer(PartsMultipler["Tires"][theVehicleType][2][1], PartsMultipler["Tires"][theVehicleType][2][2], tractionLoss)*10)/2)
end



local Tun = {}
local STPER = false
function LoadUpgrade(Update, handl, othercomp)
	Tun = {}
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if(Update) then
		STPER = getVehicleHandling(theVehicle)
		if(handl) then
			for i = 1, 6 do
				Upgrading[i]["data"] = {}
			end
			local handl = fromJSON(handl)
			Upgrading[1]["data"][1] = {handl[1].." [Установлен]", "Engines", "Установлено"}
			if(handl[2] ~= "") then Upgrading[2]["data"][1] = {handl[2].." [Установлено]", "Turbo", "Установлено"} end
			Upgrading[3]["data"][1] = {handl[3].." [Установлена]", "Transmission", "Установлено"}
			Upgrading[4]["data"][1] = {handl[4].." [Установлена]", "Suspension", "Установлено"}
			Upgrading[5]["data"][1] = {handl[5].." [Установлены]", "Brakes", "Установлено"}
			Upgrading[6]["data"][1] = {handl[6].." [Установлены]", "Tires", "Установлено"}
			local vtype = GetVehicleType(theVehicle)
			for i, arr in pairs(fromJSON(othercomp)) do
				local ks = nil
				if i == "Engines" then ks = 1
				elseif i == "Turbo" then ks = 2
				elseif i == "Transmission" then ks = 3
				elseif i == "Suspension" then ks = 4
				elseif i == "Brakes" then ks = 5
				elseif i == "Tires" then ks = 6 end
				for name, har in pairs(arr) do
					if(vtype == har[1]) then
						Upgrading[ks]["data"][#Upgrading[ks]["data"]+1] = {name, i, 0}
					end
				end
			end
		end
	end
	ChangeInfo("")
	TuningSelector = 1
	tuningList=true
	PText["tuning"] = {}
	local FH = dxGetFontHeight(scale, "default-bold")*1.1
	local x,y = 30*scalex, (screenHeight/4)

	local TotalCount = 1
	for i = 1, #Upgrading do
		local count = 0
		for item, key in pairs(Upgrading[i]["data"]) do
			if(LatencyUpgrade(key[2])) then
				count=count+1
			end
		end
		if(count > 0) then
			local color = tocolor(98, 125, 152, 255)
			if(TuningSelector == TotalCount) then
				color = tocolor(201, 219, 244, 255)
			end
			PText["tuning"][TotalCount] = {Upgrading[i]["text"], x, y+(FH*TotalCount), screenWidth, screenHeight, color, scale, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}, {"TuningListOpen", localPlayer, i}}
			TotalCount=TotalCount+1
		end
	end

	setCameraMatrix (OrigX-5, OrigY+4,OrigZ+1, OrigX, OrigY, OrigZ)
	UpdateTuningPerformans()
end



local NEWPER = false
function UpdateTuningPerformans(NewDat)
	local Power = GetVehiclePower(STPER["mass"], STPER["engineAcceleration"])
	local Acceleration = GetVehicleAcceleration(STPER["engineAcceleration"], STPER["tractionMultiplier"])
	local TopSpeed = math.floor(GetVehicleTopSpeed(STPER["engineAcceleration"], STPER["dragCoeff"], STPER["maxVelocity"])/(1000/348))
	local Brake = math.floor(STPER["brakeBias"]*100)..'/'..(100)-math.floor(STPER["brakeBias"]*100)
	local Trans = STPER["driveType"].." "..STPER["numberOfGears"]
	local Control = GetVehicleControl(STPER["tractionBias"])
	
	if(NewDat) then
		NEWPER = getVehicleHandling(getPedOccupiedVehicle(localPlayer))
		local nTopSpeed = (GetVehicleTopSpeed(NEWPER["engineAcceleration"], NEWPER["dragCoeff"], NEWPER["maxVelocity"])/(1000/348))-(GetVehicleTopSpeed(STPER["engineAcceleration"], STPER["dragCoeff"], STPER["maxVelocity"])/(1000/348))
		if(nTopSpeed > 0) then TopSpeed = TopSpeed..'+'..nTopSpeed
		elseif(nTopSpeed < 0) then TopSpeed = TopSpeed..''..nTopSpeed end
		
		local nPower = GetVehiclePower(NEWPER["mass"], NEWPER["engineAcceleration"])-GetVehiclePower(STPER["mass"], STPER["engineAcceleration"])
		if(nPower > 0) then Power = Power..'+'..nPower
		elseif(nPower < 0) then Power = Power..''..nPower end
		Acceleration = GetVehicleAcceleration(NEWPER["engineAcceleration"], NEWPER["tractionMultiplier"])-GetVehicleAcceleration(STPER["engineAcceleration"], STPER["tractionMultiplier"])
		Brake = math.floor(NEWPER["brakeBias"]*100)..'/'..(100)-math.floor(NEWPER["brakeBias"]*100)
		Trans = NEWPER["driveType"].." "..NEWPER["numberOfGears"]
		Control = GetVehicleControl(NEWPER["tractionBias"])
	else
		triggerServerEvent("UpgradePreload", localPlayer, localPlayer)
		NEWPER = false
	end
	local sx,sy = (screenWidth/2.55), screenHeight-(150*scaley)
	
	PText["tuning"]["topspeed"] = {Text("Макс скорость").." "..TopSpeed.." "..Text("КМ/Ч"), sx, sy-(30*scaley), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.7, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}}
	PText["tuning"]["power"] = {Text("Мощность").." "..Power.." "..Text("Л.С."), sx+(300*scaley), sy-(30*scaley), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.7, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}}
	PText["tuning"]["acceleration"] = {Text("Ускорение").." ("..Trans.." АКПП)", sx+(600*scaley), sy-(30*scaley), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.7, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}}
	PText["tuning"]["brakes"] = {Text("Тормоза").." "..Brake, sx+(900*scaley), sy-(30*scaley), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.7, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}}
	PText["tuning"]["Управление"] = {Text("Управление").." "..Control, sx+(900*scaley), sy-(170*scaley), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.7, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}}

end


function TuningListOpen(num, page)
	if(not num) then
		if(Tun["num"]) then
			num = Tun["num"]
		else
			return false
		end
	else
		Tun["num"] = num
	end
	
	local maxpage = math.ceil(#Upgrading[num]["data"]/15)
	TuningSelector = 1
	if(not page or maxpage == 1) then 
		Tun["page"] = 1
	else
		Tun["page"] = Tun["page"]+page
		if(Tun["page"] > maxpage) then
			Tun["page"] = 1
		elseif(Tun["page"] <= 0) then
			Tun["page"] = maxpage
		end
	end
	PText["tuning"] = {}
	local FH = dxGetFontHeight(scale, "default-bold")*1.1
	local x,y = 30*scalex, (screenHeight/4)
	local count = 0
	
	for i = (Tun["page"]*15)-14, Tun["page"]*15 do
		if(Upgrading[num]["data"][i]) then
			count=count+1
			local color = tocolor(150, 150, 150, 255)
			local dat = nil
			local advtext = ""

			if(LatencyUpgrade(Upgrading[num]["data"][i][2])) then
				color = tocolor(98, 125, 152, 255)
				dat = {"BuyTuningShop", localPlayer, Upgrading[num]["data"][i][1], Upgrading[num]["data"][i][2], Upgrading[num]["data"][i][3]}
			else
				advtext = "[недоступно]"
			end
			PText["tuning"][count] = {Upgrading[num]["data"][i][1]..advtext, x, y+(FH*count), screenWidth, screenHeight, color, scale, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}, dat}
			if(page) then
				if(page < 0) then
					TuningSelector=count
				end
			end
		end
	end
	PText["tuning"][TuningSelector][6] = tocolor(201, 219, 244, 255)
	UpgradePreload(Upgrading[num]["text"], PText["tuning"][TuningSelector][20][3], PText["tuning"][TuningSelector][20][4], PText["tuning"][TuningSelector][20][5])
end
addEvent("TuningListOpen", true )
addEventHandler("TuningListOpen", getRootElement(), TuningListOpen)




function BuyTuningShop(item, upgrd, cost)
	if(cost ~= "Установлено") then
		triggerServerEvent("VehicleUpgrade", localPlayer, upgrd, cost)
		playSFX("genrl", 53, 6, false)
	end
end
addEvent("BuyTuningShop", true )
addEventHandler("BuyTuningShop", getRootElement(), BuyTuningShop)


function BuyUpgrade(handl, othercomp)
	guiSetAlpha(TCButton[ToC1+1], 0)
	guiSetAlpha(TCButton2[ToC2+1], 0)
	ToC1, ToC2, ToC3, ToC4 = getVehicleColor(getPedOccupiedVehicle(localPlayer))
	guiSetAlpha(TCButton[ToC1+1], 0.5)
	guiSetAlpha(TCButton2[ToC2+1], 0.5)
	if(handl) then
		LoadUpgrade(true, handl, othercomp)
	else
		upgrades = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		helpmessage("#009900"..Text("КУПЛЕНО").."!")
		LoadUpgrade()
	end
end
addEvent("BuyUpgrade", true )
addEventHandler("BuyUpgrade", getRootElement(), BuyUpgrade)


function UpgradePreload(razdel, name, upgr, cost) 
	helpmessage("")
	local theVehicle = getPedOccupiedVehicle(localPlayer)


	if(tonumber(upgr)) then
		OriginVehicleUpgrade(theVehicle)
		addVehicleUpgrade(theVehicle, upgr)
		helpmessage(COLOR["DOLLAR"]["HEX"].."$"..cost)
		UpdateTuningPerformans()
	else
		if(cost == "Установлено") then
			UpdateTuningPerformans()
		else
			triggerServerEvent("UpgradePreload", localPlayer, localPlayer, name, upgr)
		end
	end
	
	
	playSFX("genrl", 53, 5, false)
	if(razdel) then
		if razdel == "Выхлопная труба" then
			local x,y,z = getVehicleComponentPosition(theVehicle, "exhaust_ok", "world")
			setCameraMatrix(x+4, y+(0.8) ,z, x, y, z)
		elseif razdel == "Спойлер" then
			local x,y,z = getVehicleComponentPosition(theVehicle, "boot_dummy", "world")
			setCameraMatrix(x+4, y ,z+1, x, y, z)
		elseif razdel == "Задний бампер" then
			local x,y,z = getVehicleComponentPosition(theVehicle, "boot_dummy", "world")
			setCameraMatrix(x+4, y ,z+0.5, x, y, z)
		end
	end
end



function UpgradeServerPreload() 
	helpmessage(COLOR["DOLLAR"]["HEX"]..Text("БЕСПЛАТНО"))
	UpdateTuningPerformans(true)
end
addEvent("UpgradeServerPreload", true )
addEventHandler("UpgradeServerPreload", getRootElement(), UpgradeServerPreload)




function TuningExit()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	PData["Driver"]["Handling"] = getVehicleHandling(theVehicle)
	setVehicleColor(theVehicle ,ToC1, ToC2, ToC3, ToC4)
	showCursor(false)
	tuningList=false
	for slot = 1, #TCButton do
		destroyElement(TCButton[slot])
	end
	for slot = 1, #TCButton2 do
		destroyElement(TCButton2[slot])
	end
	OriginVehicleUpgrade(theVehicle)
	triggerServerEvent("ExitTuning", localPlayer, theVehicle)
	PText["tuning"] = {}
end









function LatencyUpgrade(Upgrade)
	if(not tonumber(Upgrade)) then return true end
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	
	if(Upgrade == 1087) then
		return true
	end
	
	if(Upgrade == 10 or Upgrade == 11 or Upgrade == 12 or Upgrade == 13) then 
		if(vinyl_vehicles[getElementModel(theVehicle)]) then
			return true
		end
	end
	
	addVehicleUpgrade(theVehicle, Upgrade)
	local CurrentUpgrades = getVehicleUpgrades(theVehicle)
	for slot = 0, #CurrentUpgrades do
		if(Upgrade == CurrentUpgrades[slot]) then
			OriginVehicleUpgrade(theVehicle)
			return true
		end
	end
	
	return false
end



function PoliceAddMarker(x, y, z, gpsmessage)
	GPS(x,y,z,gpsmessage)
	helpmessage("#4682B4"..Text("Поступил новый вызов!\n #FFFFFFОтправляйся на #FF0000красный маркер"))
	playSFX("script", 58, math.random(22, 35), false)
end
addEvent("PoliceAddMarker", true)
addEventHandler("PoliceAddMarker", getRootElement(), PoliceAddMarker)




function GPS(x,y,z,info,after)
	local GPSM = createMarker(x, y, z, "checkpoint", 5, 255, 50, 50, 170)
	setElementData(GPSM , "type", "GPS")
	GPSObject[GPSM] = createBlipAttachedTo(GPSM)
	if(x ~= 228 and y ~= 228 and z ~= 228) then
		local px, py, pz = getElementPosition(localPlayer)
		triggerServerEvent("GetPathByCoordsNEW", localPlayer, localPlayer, px, py, pz, x,y,z)
	end
	if(info) then setElementData(GPSM, "info", Text(info)) end
	if(after) then setElementData(GPSM, "after", after) end
	playSFX("script", 217, 0, false)
end
addEvent("AddGPSMarker", true)
addEventHandler("AddGPSMarker", getRootElement(), GPS)




function RemoveGPSMarker(info)
	for k,v in pairs(getElementsByType "marker") do
		if(getElementData(v, "info") == info) then
			destroyElement(GPSObject[v])
			GPSObject[v] = nil
			destroyElement(v)
		end
	end
end
addEvent("RemoveGPSMarker", true)
addEventHandler("RemoveGPSMarker", getRootElement(), RemoveGPSMarker)




function openmap()
	if(isPlayerMapForced()) then
		forcePlayerMap(false)
	else
		forcePlayerMap(true)
	end
end


function hideinv()
	if(PData["Interface"]["Full"]) then
		SetPlayerHudComponentVisible("all", false)
		showChat(false)
		removeEventHandler("onClientRender", root, DrawOnClientRender)
	else
		SetPlayerHudComponentVisible("all", true)
		showChat(true)
		addEventHandler("onClientRender", root, DrawOnClientRender)
	end
end





function NotForLowPC()
	for _, thePlayer in pairs(getElementsByType("player", getRootElement(), true)) do
		UpdateDisplayArmas(thePlayer)
	end
	for _, thePed in pairs(getElementsByType("ped", getRootElement(), true)) do
		UpdateDisplayArmas(thePed)
	end

	for mar, dat in pairs(PData["AnimatedMarker"]) do
		if(dat[1] == "up") then
			dat[2] = dat[2]+0.01
			if(dat[2] >= 0.25) then
				dat[1] = "down"
			end
		else
			dat[2] = dat[2]-0.01
			if(dat[2] <= -0.25) then
				dat[1] = "up"
			end
		end
		if(isElementAttached(mar)) then
			setElementAttachedOffsets(mar, dat[3], dat[4], dat[5]+dat[2])
		else
			setElementPosition(mar, dat[3], dat[4], dat[5]+dat[2])
		end
	end
end
addEventHandler("onClientPreRender", root, NotForLowPC)






function onWastedEffect(killer, weapon, bodypart)
	local x,y,z = getElementPosition(source)
	if(weapon == 50) then
		createEffect("blood_heli", x, y, z, 0, 0, 0, 300, true)
	end
	local e = createEffect("insects", x, y, z, 0, 0, 0, 10, true)
	setElementParent(e, source)
end
addEventHandler("onClientPedWasted", getRootElement(), onWastedEffect)
addEventHandler("onClientPlayerWasted", getRootElement(), onWastedEffect)




local ReplaceShader = dxCreateShader("texreplace.fx")
local EmptyTexture = dxCreateTexture(1,1)
function lowPcMode()
	if(PData["Interface"]["LowPC"]) then
		PData["Interface"]["LowPC"] = false
		helpmessage("Режим для #551A8Bслабых#FFFFFF компьютеров выключен")
		engineRemoveShaderFromWorldTexture(ReplaceShader,"collisionsmoke")
		engineRemoveShaderFromWorldTexture(ReplaceShader,"bullethitsmoke")
		engineRemoveShaderFromWorldTexture(ReplaceShader,"bullethitsmoke1")
		engineRemoveShaderFromWorldTexture(ReplaceShader,"boatsplash")
		setWorldSpecialPropertyEnabled("randomfoliage", true)
		resetPedsLODDistance()
		resetVehiclesLODDistance()
		setCloudsEnabled(true)
		setBirdsEnabled(true)
		addEventHandler("onClientPreRender", getRootElement(), NotForLowPC)
		addEventHandler("onClientPedWasted", getRootElement(), onWastedEffect)
		addEventHandler("onClientPlayerWasted", getRootElement(), onWastedEffect)
		
		for thePlayer, dat in pairs(StreamData) do
			UpdateArmas(thePlayer)
		end
		
		for category, textrzd in pairs(TexturesSize) do
			for texname, size in pairs(textrzd) do
				TexturesSize[category][texname] = size*2
				VideoMemory[category][texname] = nil
			end
		end
	else
		PData["Interface"]["LowPC"] = true
		helpmessage("Режим для #551A8Bслабых#FFFFFF компьютеров включен")
		dxSetShaderValue(ReplaceShader,"gTexture",EmptyTexture)
		engineApplyShaderToWorldTexture(ReplaceShader,"collisionsmoke")
		engineApplyShaderToWorldTexture(ReplaceShader,"bullethitsmoke")
		engineApplyShaderToWorldTexture(ReplaceShader,"bullethitsmoke1")
		engineApplyShaderToWorldTexture(ReplaceShader,"boatsplash")
		setPedsLODDistance(50)
		setVehiclesLODDistance(50)
		setWorldSpecialPropertyEnabled("randomfoliage", false)
		setCloudsEnabled(false)
		setBirdsEnabled(false)
		removeEventHandler("onClientPreRender", getRootElement(), NotForLowPC)
		removeEventHandler("onClientPedWasted", getRootElement(), onWastedEffect)
		removeEventHandler("onClientPlayerWasted", getRootElement(), onWastedEffect)

		
		for thePlayer, dat in pairs(StreamData) do
			if(dat["armas"]) then
				for _, v in pairs(dat["armas"]) do
					destroyElement(v)
				end
			end
			dat["armas"] = {}
		end
		
		for category, textrzd in pairs(TexturesSize) do
			for texname, size in pairs(textrzd) do
				TexturesSize[category][texname] = size/2
				VideoMemory[category][texname] = nil
			end
		end
	end
end


function StartMission()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if(not PData["Mission"]) then
		if(theVehicle) then
			if(getElementModel(theVehicle) == 431) then
				triggerServerEvent("FindBusStop", localPlayer, localPlayer, getPlayerCity(localPlayer))
			end
		end
		PData["Mission"] = true
	else
		PData["Mission"] = false
	end
end



function SetPlayerHudComponentVisible(component, show)
	setPlayerHudComponentVisible(component, show)
	if(component == "all") then
		if(show) then
			setPlayerHudComponentVisible("wanted", false)
			setPlayerHudComponentVisible("area_name", false)
			setPlayerHudComponentVisible("vehicle_name", false)
			for name, _ in pairs(PData["Interface"]) do
				PData["Interface"][name] = true
			end
		else
			for name, _ in pairs(PData["Interface"]) do
				PData["Interface"][name] = false
			end
		end
	end
end



function GPSFoundShop(bytype, varname, varval, name) --Тип, имя даты, значение даты, название
	local x,y,z = getElementPosition(localPlayer)
	local pic = false
	local mindist = 9999
	for key,thePickups in pairs(getElementsByType(bytype)) do
		if(getElementData(thePickups, varname) == varval) then
			local x2,y2,z2 = getElementPosition(thePickups)
			local dist = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
			if(dist < mindist) then
				mindist = dist
				pic = thePickups
			end
		end
	end
	local x3,y3,z3 = getElementPosition(pic)
	GPS(x3,y3,z3, name)
end
addEvent("GPSFoundShop", true)
addEventHandler("GPSFoundShop", localPlayer, GPSFoundShop)






function MarkerHit(hitPlayer, Dimension)
	if(not Dimension) then return false end
	if(hitPlayer == localPlayer) then
		if(getElementData(source, "type") == "GPS") then
			destroyElement(GPSObject[source])
			GPSObject[source] = nil
			if(getElementData(source, "after")) then 
				playSFX("genrl", 52, 14, false) 
				helpmessage(getElementData(source, "after")) 
			end
			destroyElement(source)
		elseif(getElementData(source, "TrailerInfo")) then
			ChangeInfo(getElementData(source, "TrailerInfo"), 5000)
		elseif(getElementData(source, "type") == "Race") then
			NextRaceMarker()
		elseif(getElementData(source, "type") == "RVMarker") then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if(theVehicle) then
				if(not PData["MarkerTrigger"]) then
					setPedCanBeKnockedOffBike(localPlayer, false)
					local x,y,z = getElementPosition(theVehicle)
					local _,_,rz = getElementRotation(theVehicle)
					triggerServerEvent("OpenTuning", localPlayer, localPlayer, x,y,getGroundPosition(x,y,z),rz)
					PData["MarkerTrigger"] = true
				else
					PData["MarkerTrigger"] = nil
				end
			end
		elseif(getElementData(source, "type") == "GEnter") then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if(theVehicle) then
				setPedCanBeKnockedOffBike(localPlayer, false)
			end
		elseif(getElementData(source, "type") == "GExit") then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if(theVehicle) then
				setPedCanBeKnockedOffBike(localPlayer, false)
			end
		elseif(getElementData(source, "type") == "SPRAY") then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if(theVehicle) then
				SetZoneDisplay("Pay 'n' Spray", true)
				local x,y,z,lx,ly,lz = getCameraMatrix()
				local x2, y2, z2 = getElementPosition(source)
				local lx2,ly2,lz2 = getPointInFrontOfPoint(x2, y2, z2+5, 80-tonumber(getElementData(source, "rz")), 20)
				SmoothCameraMove(lx2, ly2, lz2, x2, y2, z2, 1500)
				PData["Pay 'n' Spray Timer"] = setTimer(function(x,y,z,x2,y2,z2)
					SmoothCameraMove(x,y,z,x2,y2,z2, 1500, true)
				end, 3000, 1, x,y,z,x2,y2,z2)
			end
		elseif(getElementData(source, "TriggerBot")) then
			local thePed = FoundPedByTINF(source)
			if(thePed) then
				if(thePed ~= localPlayer) then
					local theVehicle = getPedOccupiedVehicle(localPlayer)
					if(not theVehicle) then
						if(not isPedDoingTask(localPlayer, "TASK_SIMPLE_FIGHT") and not isPedDoingTask(thePed, "TASK_SIMPLE_FIGHT")) then
							if(GetElementAttacker(thePed)) then
								if(getElementHealth(thePed) < 20) then
									if(getElementData(thePed,  "dialog")) then
										triggerServerEvent("PedDialog", localPlayer, localPlayer, thePed)
									end
								end
								return false
							end
							
							if(getElementData(thePed,  "dialog")) then
								triggerServerEvent("PedDialog", localPlayer, localPlayer, thePed)
							end
						end
					end
				end
			end
		else 
			local Attached = getElementParent(source)
			if(Attached) then
				if(getElementData(Attached, "gates")) then
					triggerServerEvent("opengate", localPlayer, Attached, "Enter")
				end
			end
		end
	end
end
addEventHandler("onClientMarkerHit", getRootElement(), MarkerHit)


function markerLeave(hitPlayer, Dimension)
	--Костыль, не работает Dimension
	if(hitPlayer == localPlayer) then
		if(getElementData(source, "TriggerBot")) then
			local thePed = FoundPedByTINF(source)
			triggerServerEvent("DialogBreak", localPlayer, localPlayer, false, thePed)
		else 
			local Attached = getElementParent(source)
			if(Attached) then
				if(getElementData(Attached, "gates")) then
					triggerServerEvent("opengate", localPlayer, Attached, "Leave")
				end
			end
		end
	end
end
addEventHandler("onClientMarkerLeave", getRootElement(), markerLeave)


function FoundPedByTINF(thePed)
	local TINF = getElementData(thePed, "TriggerBot")
	for _,ped in pairs(getElementsByType("ped", getRootElement(), true)) do
		if(getElementData(ped, "TINF") == TINF) then
			return ped
		end
	end
	for _,ped in pairs(getElementsByType("player", getRootElement(), true)) do
		if(getPlayerName(ped) == TINF) then
			return ped
		end
	end
	return false
end


function BankControl(biz, data)
	if(BANKCTL) then
		BANKCTL = false
		PText["bank"] = {}
		showCursor(false)
	else
		bankControlUpdate(biz, data)
	end
end
addEvent("BankControl", true)
addEventHandler("BankControl", localPlayer, BankControl)


function bankControlUpdate(biz, data)
	PText["bank"] = {}
	local m = fromJSON(data)
	
	local text = "Денег на счету "..COLOR["DOLLAR"]["HEX"].."$"..m[1].." "
	local textWidth = dxGetTextWidth(text, scale*0.8, "default-bold", true)
	PText["bank"]["money"] = {text, 660*scalex, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {}}
	PText["bank"]["bank"] = {Text("пополнить"), 660*scalex+textWidth, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"CreateButtonInputInt", localPlayer, "bank", "Введи сумму", toJSON{biz}}}
	local textWidth = textWidth+dxGetTextWidth(Text("пополнить").." ", scale*0.8, "default-bold", true)
	PText["bank"]["withdraw"] = {Text("снять"),  660*scalex+textWidth, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"CreateButtonInputInt", localPlayer, "withdraw", "Введи сумму", toJSON{biz}}}	
	BANKCTL = m[2]
	showCursor(true)
end
addEvent("bankControlUpdate", true)
addEventHandler("bankControlUpdate", localPlayer, bankControlUpdate)








function MyVoice(voice, voicebank)
	triggerServerEvent("CheckVoice", localPlayer, voice, voicebank)
	local voi = playSound("http://109.227.228.4/engine/include/MTA/"..voicebank.."/"..md5(voice)..".wav")
	setSoundVolume(voi, 0.7)
end
addEvent("MyVoice", true)
addEventHandler("MyVoice", localPlayer, MyVoice)




function PlayerDialog(array, ped, endl)
	if(isTimer(dialogActionTimer)) then killTimer(dialogActionTimer) end
	if(isTimer(dialogTimer)) then killTimer(dialogTimer) end
	if(isTimer(dialogViewTimer)) then killTimer(dialogViewTimer) end
	if(array) then
	
		setElementData(ped, "saytome", "true")
		PData['dialogPed'] = ped
		
		PText["dialog"] = {}
		dialogTitle = array["dialog"][math.random(#array["dialog"])]
		MyVoice(dialogTitle, "dg")
	
		if(not ped) then
			showCursor(true)
			BindedKeys = {}
			PlayerDialogAction(array, ped)
		else
			PlayerSayEvent(dialogTitle, ped)
			BindedKeys = {}
			dialogActionTimer = setTimer(function()
				PlayerDialogAction(array, ped)
			end, (#dialogTitle*50), 1)

		end

	else
		PText["dialog"] = nil
		dialogTitle = false
		if(ped) then
			if(endl) then
				MyVoice(endl, "dg")
				PlayerSayEvent(endl, ped)
			end
			setElementData(ped, "saytome", nil)
			PData['dialogPed'] = nil
		else
			showCursor(false)
		end
	end
end
addEvent("PlayerDialog", true)
addEventHandler("PlayerDialog", localPlayer, PlayerDialog)


function ServerDialogCall(data)
	if(isTimer(dialogActionTimer)) then killTimer(dialogActionTimer) end
	if(isTimer(dialogTimer)) then killTimer(dialogTimer) end
	if(isTimer(dialogViewTimer)) then killTimer(dialogViewTimer) end
	if(dialogTitle) then
		PText["dialog"] = nil
		dialogTitle=false
		triggerServerEvent(unpack(data))
	end
end
addEvent("ServerDialogCall", true)
addEventHandler("ServerDialogCall", localPlayer, ServerDialogCall)



function PlayerDialogAction(array, ped)
	local FH = dxGetFontHeight(scale, "default-bold")*1.5
	local x,y = screenWidth/4, (screenHeight/1.2)

	for name,arr in pairs (array) do
		if(name ~= "dialog") then
			PText["dialog"][name] = {name..": "..arr["text"], x, y-(FH*(tablelength(array)-name)), screenWidth, screenHeight, tocolor(255,255,255, 255), scale*1.5, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true}, {"ServerDialogCall", localPlayer, {"DialogRelease", localPlayer, localPlayer, name, ped}}}
			BindedKeys[tostring(name)] = {"ServerDialogCall", localPlayer, {"DialogRelease", localPlayer, localPlayer, name, ped}}
			if(arr["timer"]) then
				dialogTimer = setTimer(function()
					triggerServerEvent("DialogRelease", localPlayer, localPlayer, name, ped)
					killTimer(dialogViewTimer)
				end, arr["timer"], 1)
				dialogViewTimer = setTimer(function(num, text)
					local remaining, executesRemaining, totalExecutes = getTimerDetails(dialogTimer) 
					PText["dialog"][num][1] = text.." #FF0000("..("%.1f"):format(remaining/1000)..")"
				end, 100, 0, name, name..": "..arr["text"])
			end
		end
	end

end




function bizControl(name, data)
	PText["biz"] = {}
	MissionCompleted("", "")
	if(data["money"]) then
		local text = "Текущий баланс "..COLOR["DOLLAR"]["HEX"].."$"..data["money"].." "
		local textWidth = dxGetTextWidth(text, scale*0.8, "default-bold", true)
		PText["biz"][#PText["biz"]+1] = {text, 660*scalex, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {}}
		PText["biz"][#PText["biz"]+1] = {"пополнить", 660*scalex+textWidth, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"CreateButtonInputInt", localPlayer, "givebizmoney", "Введи сумму", toJSON{name}}}	
		local textWidth = textWidth+dxGetTextWidth("пополнить ", scale*0.8, "default-bold", true)
		PText["biz"][#PText["biz"]+1] = {"снять",  660*scalex+textWidth, 400*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"CreateButtonInputInt", localPlayer, "removebizmoney", "Введи сумму", toJSON{name}}}	
	end
	
	
	if(data["Nachalnik"]) then
		if(data["vacancy"]) then
			for i, dat in pairs(data["vacancy"]) do
				local text = "#CCCCCC"..dat[2].."#FFFFFF - "..dat[3].." "
				local FH = dxGetFontHeight(scale*0.8, "default-bold")*1.1
				local textWidth = dxGetTextWidth(text, scale*0.8, "default-bold", true)
				PText["biz"][#PText["biz"]+1] = {text, 660*scalex, 400*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {}}	
				if(dat[3] ~= "") then
					PText["biz"][#PText["biz"]+1] = {"уволить", 660*scalex+textWidth, 400*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"ServerCall", localPlayer, {"editBizVacancy", localPlayer, localPlayer, "", toJSON({dat[1], dat[2], name, i-1})}}}
				else
					PText["biz"][#PText["biz"]+1] = {"назначить", 660*scalex+textWidth, 400*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"CreateButtonInputInt", localPlayer, "editBizVacancy", "Введи имя", toJSON{dat[1], dat[2], name, i-1}}}
				end
			end
		end
	else
		if(data["vacancy"]) then
			for i, dat in pairs(data["vacancy"]) do
				local text = "#CCCCCC"..dat[2].."#FFFFFF - "..dat[3].." "
				local FH = dxGetFontHeight(scale*0.8, "default-bold")*1.1
				local textWidth = dxGetTextWidth(text, scale*0.8, "default-bold", true)
				PText["biz"][#PText["biz"]+1] = {text, 660*scalex, 440*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {}}	
				if(dat[3] == "") then
					PText["biz"][#PText["biz"]+1] = {"устроиться", 660*scalex+textWidth, 440*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"ServerCall", localPlayer, {"startBizVacancy", localPlayer, localPlayer, "", toJSON({dat[1], dat[2], name, i-1})}}}
				elseif(dat[3] == getPlayerName(localPlayer)) then
					PText["biz"][#PText["biz"]+1] = {"уволиться", 660*scalex+textWidth, 440*scaley+(FH*i), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {["border"] = true, ["line"] = true}, {"ServerCall", localPlayer, {"stopBizVacancy", localPlayer, localPlayer, "", toJSON({dat[1], dat[2], name, i-1})}}}
				end
			end
		end
	end

	
	if(data["var"]) then
		local FH = dxGetFontHeight(scale*0.8, "default-bold")*1.1
		PInv["shop"] = {} 
		PBut["shop"] = {} 
		for varname, dats in pairs(data["var"]) do
			if(varname == "Торговля") then
			
			else
				local text = "#CCCCCC"..varname..": "..dats.." "
				PText["biz"][#PText["biz"]+1] = {text, 660*scalex, 370*scaley+(FH*(#PText["biz"]+1)), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*0.8, "default-bold", "left", "top", false, false, false, true, false, 0, 0, 0, {}}
			end
		end
	end
	
	PData["BizControlName"] = {name, data["name"]}

	showCursor(true)
end
addEvent("bizControl", true)
addEventHandler("bizControl", localPlayer, bizControl)





function ServerCall(data)
	triggerServerEvent(unpack(data))
end
addEvent("ServerCall", true)
addEventHandler("ServerCall", localPlayer, ServerCall)



--[Скин] = [Стиль походки, команда, пол, оружие, диалоги, {возможные имена ботов},]
local SkinData = {
	[0] = {0, "Мирные жители", "Мужчина"},
	[7] = {118, "Мирные жители", "Мужчина"},
	[9] = {129, "Мирные жители", "Женщина"},
	[10] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[11] = {129, "Мирные жители", "Женщина"},
	[12] = {132, "Мирные жители", "Женщина"},
	[13] = {129, "Мирные жители", "Женщина"},
	[14] = {118, "Мирные жители", "Мужчина"},
	[15] = {118, "Мирные жители", "Мужчина"},
	[16] = {118, "Мирные жители", "Мужчина"},
	[17] = {118, "Мирные жители", "Мужчина"},
	[18] = {118, "Мирные жители", "Мужчина"},
	[19] = {118, "Мирные жители", "Мужчина"},
	[20] = {118, "Мирные жители", "Мужчина"},
	[21] = {118, "Мирные жители", "Мужчина"},
	[22] = {118, "Мирные жители", "Мужчина"},
	[23] = {118, "Мирные жители", "Мужчина"},
	[24] = {118, "Мирные жители", "Мужчина"},
	[25] = {118, "Мирные жители", "Мужчина"},
	[26] = {118, "Мирные жители", "Мужчина"},
	[27] = {118, "Мирные жители", "Мужчина", nil, nil, {"Строитель"}},
	[28] = {118, "Мирные жители", "Мужчина"},
	[29] = {118, "Мирные жители", "Мужчина"},
	[30] = {121, "Колумбийский картель", "Мужчина", 29},
	[31] = {129, "Мирные жители", "Женщина"},
	[32] = {118, "Мирные жители", "Мужчина"},
	[33] = {118, "Мирные жители", "Мужчина"},
	[34] = {118, "Мирные жители", "Мужчина"},
	[35] = {118, "Мирные жители", "Мужчина"},
	[36] = {118, "Мирные жители", "Мужчина", 2},
	[37] = {118, "Мирные жители", "Мужчина", 2},
	[38] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[39] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[40] = {131, "Мирные жители", "Женщина"},
	[41] = {129, "Мирные жители", "Женщина"},
	[43] = {121, "Колумбийский картель", "Мужчина", 29},
	[44] = {118, "Мирные жители", "Мужчина"},
	[45] = {118, "Мирные жители", "Мужчина"},
	[46] = {121, "Мирные жители", "Мужчина"},
	[47] = {118, "Мирные жители", "Мужчина"},
	[48] = {118, "Мирные жители", "Мужчина"},
	[49] = {120, "Мирные жители", "Мужчина"},
	[50] = {118, "Мирные жители", "Мужчина"},
	[51] = {118, "Мирные жители", "Мужчина"},
	[52] = {118, "Мирные жители", "Мужчина"},
	[53] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[54] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[55] = {129, "Мирные жители", "Женщина"},
	[56] = {129, "Мирные жители", "Женщина"},
	[57] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[58] = {118, "Мирные жители", "Мужчина"},
	[59] = {118, "Мирные жители", "Мужчина"},
	[60] = {118, "Мирные жители", "Мужчина"},
	[61] = {118, "Мирные жители", "Мужчина", nil, nil, {"Пилот"}},
	[62] = {0, "Уголовники", "Мужчина"},
	[63] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[64] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[66] = {118, "Мирные жители", "Мужчина"},
	[67] = {118, "Мирные жители", "Мужчина"},
	[68] = {118, "Мирные жители", "Мужчина"},
	[69] = {129, "Мирные жители", "Женщина"},
	[70] = {128, "МЧС", "Мужчина"},
	[71] = {128, "Мирные жители", "Мужчина", 22},
	[72] = {118, "Мирные жители", "Мужчина"},
	[73] = {118, "Мирные жители", "Мужчина"},
	[75] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[76] = {129, "Мирные жители", "Женщина"},
	[77] = {135, "Мирные жители", "Женщина", nil, "Бомж", {"Бездомная", "Бомжиха"}},
	[78] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[79] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[80] = {118, "Мирные жители", "Мужчина", nil, nil, {"Боксер"}},
	[81] = {118, "Мирные жители", "Мужчина", nil, nil, {"Боксер"}},
	[82] = {118, "Мирные жители", "Мужчина"},
	[83] = {118, "Мирные жители", "Мужчина"},
	[84] = {118, "Мирные жители", "Мужчина"},
	[85] = {132, "Мирные жители", "Женщина"},
	[87] = {132, "Мирные жители", "Женщина", nil, nil, {"Стриптизерша"}},
	[88] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[89] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[90] = {132, "Мирные жители", "Женщина"},
	[91] = {132, "Мирные жители", "Женщина"},
	[92] = {138, "Мирные жители", "Женщина", nil, nil, {"Девушка на роликах"}},
	[93] = {132, "Мирные жители", "Женщина"},
	[94] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[95] = {121, "Колумбийский картель", "Мужчина", 29},
	[96] = {132, "Мирные жители", "Женщина"},
	[97] = {132, "Мирные жители", "Женщина"},
	[98] = {132, "Мирные жители", "Женщина"},
	[99] = {138, "Мирные жители", "Мужчина", nil, nil, {"Парень на роликах"}},
	[100] = {121, "Байкеры", "Мужчина", 22},
	[101] = {132, "Мирные жители", "Женщина"},
	[102] = {121, "Баллас", "Мужчина", 5},
	[103] = {121, "Баллас", "Мужчина", 22},
	[104] = {121, "Баллас", "Мужчина", 22},
	[105] = {122, "Гроув-стрит", "Мужчина", 4},
	[106] = {122, "Гроув-стрит", "Мужчина", 22},
	[107] = {122, "Гроув-стрит", "Мужчина", 22},
	[108] = {121, "Вагос", "Мужчина", 22},
	[109] = {121, "Вагос", "Мужчина", 22},
	[110] = {121, "Вагос", "Мужчина", 22},
	[111] = {121, "Русская мафия", "Мужчина", 25},
	[112] = {121, "Русская мафия", "Мужчина", 25},
	[113] = {121, "Русская мафия", "Мужчина", 25},
	[114] = {122, "Ацтекас", "Мужчина", 28},
	[115] = {122, "Ацтекас", "Мужчина", 28},
	[116] = {122, "Ацтекас", "Мужчина", 28},
	[117] = {122, "Триады", "Мужчина", 22},
	[118] = {122, "Триады", "Мужчина", 29},
	[120] = {122, "Триады", "Мужчина", 30},
	[121] = {121, "Da Nang Boys", "Мужчина", 22, nil, {"DNB", "Куми-ин"}},
	[122] = {121, "Da Nang Boys", "Мужчина", 28, nil, {"DNB", "Сансита"}},
	[123] = {121, "Da Nang Boys", "Мужчина", 25, nil, {"DNB", "Дэката"}},
	[124] = {118, "Мирные жители", "Мужчина"},
	[125] = {121, "Русская мафия", "Мужчина", 25},
	[126] = {121, "Русская мафия", "Мужчина", 25},
	[127] = {121, "Русская мафия", "Мужчина", 25},
	[128] = {118, "Мирные жители", "Мужчина"},
	[129] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[130] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[131] = {132, "Мирные жители", "Женщина"},
	[132] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[133] = {118, "Мирные жители", "Мужчина"},
	[134] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[135] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[136] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[137] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[138] = {132, "Мирные жители", "Женщина"},
	[139] = {132, "Мирные жители", "Женщина"},
	[140] = {132, "Мирные жители", "Женщина"},
	[141] = {129, "Мирные жители", "Женщина"},
	[142] = {118, "Мирные жители", "Мужчина"},
	[143] = {118, "Мирные жители", "Мужчина"},
	[144] = {118, "Мирные жители", "Мужчина"},
	[145] = {133, "Мирные жители", "Женщина"},
	[146] = {133, "Мирные жители", "Женщина"},
	[147] = {118, "Мирные жители", "Мужчина"},
	[148] = {129, "Мирные жители", "Женщина"},
	[150] = {129, "Мирные жители", "Женщина"},
	[151] = {129, "Мирные жители", "Женщина"},
	[152] = {132, "Мирные жители", "Женщина"},
	[153] = {118, "Мирные жители", "Мужчина", nil, nil, {"Строитель"}},
	[154] = {118, "Мирные жители", "Мужчина"},
	[155] = {118, "Мирные жители", "Мужчина"},
	[158] = {122, "Деревенщины", "Мужчина", 33},
	[159] = {119, "Деревенщины", "Мужчина", 33},
	[160] = {119, "Деревенщины", "Мужчина", 33},
	[161] = {119, "Деревенщины", "Мужчина", 33},
	[162] = {126, "Деревенщины", "Мужчина", 33},
	[163] = {118, "ЦРУ", "Мужчина", 31},
	[164] = {118, "ЦРУ", "Мужчина", 31},
	[165] = {118, "ЦРУ", "Мужчина", 31},
	[166] = {118, "ЦРУ", "Мужчина", 31},
	[167] = {118, "Мирные жители", "Мужчина"},
	[168] = {118, "Мирные жители", "Мужчина"},
	[169] = {129, "Da Nang Boys", "Женщина", 31, nil, {"DNB", "Кумитё"}},
	[170] = {118, "Мирные жители", "Мужчина"},
	[171] = {118, "Мирные жители", "Мужчина"},
	[172] = {129, "Мирные жители", "Женщина"},
	[173] = {121, "Рифа", "Мужчина", 32},
	[174] = {121, "Рифа", "Мужчина", 32},
	[175] = {121, "Рифа", "Мужчина", 32},
	[176] = {118, "Мирные жители", "Мужчина"},
	[177] = {118, "Мирные жители", "Мужчина"},
	[178] = {132, "Мирные жители", "Женщина"},
	[179] = {121, "Колумбийский картель", "Мужчина", 29},
	[180] = {118, "Мирные жители", "Мужчина"},
	[181] = {121, "Байкеры", "Мужчина", 22},
	[182] = {118, "Мирные жители", "Мужчина"},
	[183] = {118, "Мирные жители", "Мужчина"},
	[184] = {118, "Мирные жители", "Мужчина"},
	[185] = {118, "Мирные жители", "Мужчина"},
	[186] = {118, "Мирные жители", "Мужчина"},
	[187] = {118, "Мирные жители", "Мужчина"},
	[188] = {118, "Мирные жители", "Мужчина"},
	[189] = {118, "Мирные жители", "Мужчина"},
	[190] = {132, "Мирные жители", "Женщина"},
	[191] = {121, "Мирные жители", "Женщина"},
	[192] = {121, "Мирные жители", "Женщина"},
	[193] = {132, "Мирные жители", "Женщина"},
	[194] = {132, "Мирные жители", "Женщина"},
	[195] = {132, "Мирные жители", "Женщина"},
	[196] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[197] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[198] = {129, "Мирные жители", "Женщина"},
	[199] = {134, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[200] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[201] = {129, "Мирные жители", "Женщина"},
	[202] = {118, "Мирные жители", "Мужчина"},
	[203] = {118, "Мирные жители", "Мужчина"},
	[204] = {118, "Мирные жители", "Мужчина"},
	[205] = {135, "Мирные жители", "Женщина"},
	[206] = {118, "Мирные жители", "Мужчина"},
	[207] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[209] = {118, "Мирные жители", "Мужчина"},
	[210] = {118, "Мирные жители", "Мужчина"},
	[211] = {132, "Мирные жители", "Женщина"},
	[212] = {118, "Мирные жители", "Мужчина"},
	[213] = {0, "Уголовники", "Мужчина"},
	[214] = {132, "Мирные жители", "Женщина"},
	[215] = {134, "Мирные жители", "Женщина"},
	[216] = {132, "Мирные жители", "Женщина"},
	[217] = {118, "Мирные жители", "Мужчина"},
	[218] = {132, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[219] = {132, "Мирные жители", "Женщина"},
	[220] = {118, "Мирные жители", "Мужчина"},
	[221] = {118, "Колумбийский картель", "Мужчина"},
	[222] = {121, "Колумбийский картель", "Мужчина", 29},
	[223] = {121, "Мирные жители", "Мужчина"},
	[224] = {134, "Мирные жители", "Женщина"},
	[225] = {134, "Мирные жители", "Женщина"},
	[226] = {135, "Мирные жители", "Женщина"},
	[227] = {118, "Мирные жители", "Мужчина"},
	[228] = {118, "Мирные жители", "Мужчина"},
	[229] = {118, "Мирные жители", "Мужчина"},
	[230] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[231] = {132, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[232] = {132, "Мирные жители", "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[233] = {129, "Мирные жители", "Женщина"},
	[234] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[235] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[236] = {120, "Мирные жители", "Мужчина", nil, nil, {"Дед", "Старик"}},
	[237] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[238] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[239] = {118, "Мирные жители", "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[240] = {118, "Мирные жители", "Мужчина"},
	[241] = {124, "Мирные жители", "Мужчина"},
	[242] = {121, "Колумбийский картель", "Мужчина", 29},
	[243] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[244] = {132, "Мирные жители", "Женщина", nil, nil, {"Шлюха"}},
	[245] = {135, "Мирные жители", "Женщина"},
	[246] = {132, "Мирные жители", "Женщина", nil, nil, {"Стриптизерша"}},
	[247] = {121, "Байкеры", "Мужчина", 22},
	[248] = {121, "Байкеры", "Мужчина", 22},
	[249] = {118, "Мирные жители", "Мужчина"},
	[250] = {118, "Мирные жители", "Мужчина"},
	[251] = {132, "Мирные жители", "Женщина"},
	[252] = {133, "Уголовники", "Мужчина"},
	[253] = {118, "Мирные жители", "Мужчина"},
	[254] = {121, "Байкеры", "Мужчина", 22},
	[255] = {118, "Мирные жители", "Мужчина"},
	[256] = {132, "Мирные жители", "Женщина"},
	[257] = {132, "Мирные жители", "Женщина", nil, nil, {"Стриптизерша"}},
	[258] = {124, "Мирные жители", "Мужчина"},
	[259] = {124, "Мирные жители", "Мужчина"},
	[260] = {118, "Мирные жители", "Мужчина", nil, nil, {"Строитель"}},
	[261] = {118, "Байкеры", "Мужчина"},
	[262] = {118, "Мирные жители", "Мужчина"},
	[263] = {132, "Мирные жители", "Женщина"},
	[264] = {128, "Мирные жители", "Мужчина"},
	[265] = {128, "Полиция", "Мужчина", 22},
	[266] = {128, "Полиция", "Мужчина", 22},
	[267] = {128, "Полиция", "Мужчина", 22},
	[268] = {0, "Уголовники", "Мужчина"},
	[269] = {122, "Гроув-стрит", "Мужчина", 22},
	[270] = {122, "Гроув-стрит", "Мужчина", 30},
	[271] = {122, "Гроув-стрит", "Мужчина", 30},
	[272] = {118, "Мирные жители", "Мужчина"},
	[274] = {128, "МЧС", "Мужчина"},
	[275] = {128, "МЧС", "Мужчина"},
	[276] = {128, "МЧС", "Мужчина"},
	[277] = {118, "МЧС", "Мужчина", nil, nil, {"Пожарный"}},
	[278] = {118, "МЧС", "Мужчина", nil, nil, {"Пожарный"}},
	[279] = {118, "МЧС", "Мужчина", nil, nil, {"Пожарный"}},
	[280] = {128, "Полиция", "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[281] = {128, "Полиция", "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[282] = {128, "Полиция", "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[283] = {128, "Полиция", "Мужчина", 22, nil, {"Шериф"}},
	[284] = {128, "Полиция", "Мужчина", 22, nil, {"Патрульный"}},
	[285] = {128, "Полиция", "Мужчина", 32, nil, {"SWAT"}},
	[286] = {128, "ФБР", "Мужчина", 30, nil, {"ФБР"}},
	[287] = {0, "Военные", "Мужчина", 31, nil, {"Военный"}},
	[288] = {128, "Полиция", "Мужчина", 22, nil, {"Шериф"}},
	[290] = {118, "Мирные жители", "Мужчина"},
	[291] = {118, "Мирные жители", "Мужчина"},
	[292] = {122, "Ацтекас", "Мужчина", 30},
	[293] = {122, "Гроув-стрит", "Мужчина", 22},
	[294] = {122, "Триады", "Мужчина", 30},
	[295] = {118, "Мирные жители", "Мужчина"},
	[296] = {118, "Мирные жители", "Мужчина"},
	[297] = {118, "Мирные жители", "Мужчина"},
	[298] = {132, "Мирные жители", "Женщина"},
	[299] = {0, "Мирные жители", "Мужчина"},
	[300] = {122, "Гроув-стрит", "Мужчина", 30},
	[301] = {122, "Гроув-стрит", "Мужчина", 30},
	[302] = {118, "Мирные жители", "Мужчина"},
	[303] = {118, "Мирные жители", "Мужчина"},
	[304] = {132, "Мирные жители", "Женщина"},
	[305] = {118, "Мирные жители", "Мужчина"},
	[306] = {118, "Мирные жители", "Мужчина"},
	[307] = {118, "Мирные жители", "Мужчина"},
	[308] = {118, "Мирные жители", "Мужчина"},
	[309] = {118, "Мирные жители", "Мужчина"},
	[310] = {118, "Мирные жители", "Мужчина"},
	[311] = {122, "Гроув-стрит", "Мужчина", 22},
	[312] = {0, "Военные", "Мужчина"}
}






local wardprobePosition = false
local wardprobeArr = false
local wardprobeType = false



function SetwardprobeSkin(skinid)
	local i = 0
	for skin, key in pairs(wardprobeArr) do
		i=i+1
		if(i == skinid) then
			skin=tonumber(skin)
			triggerServerEvent("SetPlayerModel", localPlayer, localPlayer, skin)
			PlayerChangeSkinTeam=RGBToHex(getTeamColor(getTeamFromName(SkinData[skin][2])))..SkinData[skin][2]
			PlayerChangeSkinTeamRang=SkinData[skin][3]
			if(wardprobeType == "house") then
				if(key == 999) then
					PlayerChangeSkinTeamRespect="бесконечное количество шт."
				else
					PlayerChangeSkinTeamRespect=key.." шт."
				end
			elseif(wardprobeType == "shop") then
				PlayerChangeSkinTeamRespect="$"..key
			end

			if(skin == 285 or skin == 264) then
				PlayerChangeSkinTeamRespectNextLevel="скрывает имя игрока"
			else
				PlayerChangeSkinTeamRespectNextLevel=""
			end
		end
	end

end






function wardrobe(arr,types)
	wardprobeType=types
	wardprobeArr=fromJSON(arr)

	setCameraMatrix(255.5, -41.4, 1002.5,  258.3, -41.8, 1002.5)
	PEDChangeSkin=true

	GTASound = playSound("http://109.227.228.4/engine/include/MTA/music/Bossa-Nova.mp3", true)
	setSoundVolume(GTASound, 0.25)
	
	SwitchButtonL = guiCreateButton(0.5-(0.08), 0.8, 0.04, 0.04, "<-", true)
	SwitchButtonR = guiCreateButton(0.5+(0.04), 0.8, 0.04, 0.04, "->", true)
	if(wardprobeType == "house") then
		SwitchButtonAccept = guiCreateButton(0.5-(0.04), 0.8, 0.08, 0.04, "ВЫБРАТЬ", true)
		local curskin = tostring(getElementModel(localPlayer))
		if(not wardprobeArr[curskin]) then wardprobeArr[curskin] = 1 end
		local i = 0
		for v, key in pairs(wardprobeArr) do
			i=i+1
			if(v == curskin) then
				wardprobePosition=i
			end
		end
	elseif(wardprobeType == "shop") then
		wardprobePosition=1
		SwitchButtonAccept = guiCreateButton(0.5-(0.04), 0.8, 0.08, 0.04, "КУПИТЬ", true)
	end
	SetwardprobeSkin(wardprobePosition)
	setElementData(SwitchButtonL, "data", "NewSwitchButtonL")
	setElementData(SwitchButtonR, "data", "NewSwitchButtonR")
	setElementData(SwitchButtonAccept, "data", "NewSwitchButtonAccept")
	setElementData(SwitchButtonL, "ped", "1")
	setElementData(SwitchButtonR, "ped", "1")
	setElementData(SwitchButtonAccept, "ped", "1")


	showCursor(true)
	bindKey("arrow_l", "down", NewNextSkinMinus) 
	bindKey("arrow_r", "down", NewNextSkinPlus) 
	bindKey("enter", "down", NewNextSkinEnter) 	
end
addEvent("wardrobe", true)
addEventHandler("wardrobe", localPlayer, wardrobe)



local RobActionTimer = false
function RobEvent(value)
	if(isTimer(RobActionTimer)) then
		killTimer(RobActionTimer)
	end
	
	
	if(RobAction == false) then
		RobAction = {value*10, false}
	else
		if(value) then
			RobAction[1] = RobAction[1]+(value*10) 
			RobAction[2] = value*10
		else
			RobAction = false
			return true
		end
	end
	
	
	RobActionTimer = setTimer(function() RobAction[2] = false end, 2500, 1)
end
addEvent("RobEvent", true)
addEventHandler("RobEvent", localPlayer, RobEvent)



function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end




function NewNextSkinPlus()
	if(wardprobePosition == tablelength(wardprobeArr)) then
		wardprobePosition=1
	else
		wardprobePosition=wardprobePosition+1
	end
	SetwardprobeSkin(wardprobePosition)
end


function NewNextSkinMinus()
	if(wardprobePosition == 1) then
		wardprobePosition = tablelength(wardprobeArr)
	else
		wardprobePosition = wardprobePosition-1
	end
	SetwardprobeSkin(wardprobePosition)
end

function NewNextSkinEnter(_, _, closed)
	unbindKey ("arrow_l", "down", NewNextSkinMinus) 
	unbindKey ("arrow_r", "down", NewNextSkinPlus) 
	unbindKey ("enter", "down", NewNextSkinEnter) 
	stopSound(GTASound)
	PEDChangeSkin = "play"
	showCursor(false)
	if(closed) then 
		triggerServerEvent("buywardrobe", localPlayer, localPlayer)
	else
		local i = 0
		for skin, key in pairs(wardprobeArr) do
			i=i+1
			if(i == wardprobePosition) then
				if(wardprobeType == "house") then
					triggerServerEvent("wardrobe", localPlayer, localPlayer, skin)
					break
				elseif(wardprobeType == "shop") then
					triggerServerEvent("buywardrobe", localPlayer, localPlayer, skin, key)
					break
				end
			end
		end
	end
	wardprobeArr = false
	guiSetVisible(SwitchButtonAccept, false)
	guiSetVisible(SwitchButtonL, false)
	guiSetVisible(SwitchButtonR, false)
	PlayerChangeSkinTeam=""
	PlayerChangeSkinTeamRang=""
	PlayerChangeSkinTeamRespect=""
	PlayerChangeSkinTeamRespectNextLevel=""
end




local lookedHouse = false
local ViewHouse = 1

local CityColor = {
	["San Fierro"] = "#404552",  
	["Los Santos"] = "#FFC200", 
	["Las Venturas"] = "#DBC2FF", 
	["Tierra Robada"] = "#097380", 
	["Bone County"] = "#CCB277", 
	["Red County"] = "#C02221", 
	["Flint County"] = "#7C9B5F", 
	["Whetstone"] = "#999999"
}


function LookHouse(h)
	setElementDimension(localPlayer, 0)
	setElementInterior(localPlayer, 0) 
	local x,y,z = h[1], h[2], h[3]
	local zone = getZoneName(x,y,z,true)
	local color = {"#9EDA46", "#FFFFFF"}
	if(CityColor[zone]) then color[1] = CityColor[zone] end
	PlayerChangeSkinTeam = color[1]..getZoneName(x,y,z, true)

	if(h[4] == "house") then
		PlayerChangeSkinTeamRang = color[2]..getZoneName(x,y,z).." "..getElementData(getElementByID(h[5]), "zone")
	else
		PlayerChangeSkinTeamRang = color[2]..h[5]
	end
	lookedHouse = h
	
	if(h[6] == 90) then
		setCameraMatrix(x+20, y-20, z+30, x, y, z)
	elseif(h[6] == 180) then
		setCameraMatrix(x-20, y-20, z+30, x, y, z)
	elseif(h[6] == 270) then
		setCameraMatrix(x-20, y+20, z+30, x, y, z)
	elseif(h[6] == 360) then
		setCameraMatrix(x+20, y+20, z+30, x, y, z)
	else
		setCameraMatrix(x-100, y-100, z+150, x, y, z)
	end
end



function NextSkinMinus()
	if(SpawnPoints[ViewHouse-1]) then
		LookHouse(SpawnPoints[ViewHouse-1])
		ViewHouse=ViewHouse-1
	else
		LookHouse(SpawnPoints[#SpawnPoints])
		ViewHouse=#SpawnPoints
	end
end

function NextSkinPlus()
	if(SpawnPoints[ViewHouse+1]) then
		LookHouse(SpawnPoints[ViewHouse+1])
		ViewHouse=ViewHouse+1
	else
		LookHouse(SpawnPoints[1])
		ViewHouse=1
	end
end


function NextSkinEnter()
	if(SkinFlag) then
		PText["HUD"][3] = nil
		PlayerChangeSkinTeam=""
		PlayerChangeSkinTeamRang=""
		PlayerChangeSkinTeamRespect=""
		PlayerChangeSkinTeamRespectNextLevel=""
		triggerServerEvent("SpawnedAfterChangeEvent", localPlayer, localPlayer, lookedHouse[4], lookedHouse[5])
		lookedHouse = false
	end
end





function StartLookZones(zones, update)
	if(#MyHouseBlip > 0) then 
		for slot = 1, #MyHouseBlip do
			destroyElement(MyHouseBlip[slot])
		end
		MyHouseBlip={}
	end
	

	SpawnPoints=fromJSON(zones)

	for i = 1, #SpawnPoints do
		if(SpawnPoints[i][4] == "house") then
			local x,y,z = SpawnPoints[i][1],SpawnPoints[i][2],SpawnPoints[i][3]
			MyHouseBlip[#MyHouseBlip+1]=createBlip(x, y, z, 31)
			local angle = SpawnPoints[i][6]
			if(not angle) then 
				if(not processLineOfSight(x, y, z, x+1, y, z, true)) then
					angle = 90
				elseif(not processLineOfSight(x, y, z, x-1, y, z, true)) then
					angle = 180
				elseif(not processLineOfSight(x, y, z, x, y+1, z, true)) then
					angle = 270
				elseif(not processLineOfSight(x, y, z, x, y-1, z, true)) then
					angle = 360
				else
					angle = 0
				end
			end
			SpawnPoints[i][6] = angle
		end
	end
	
	if(not update) then
		setElementDimension(localPlayer, getElementData(localPlayer,"id"))
		setElementInterior(localPlayer, 0)	
		PEDChangeSkin = true
		
		SwitchButtonL = guiCreateButton(0.5-(0.08), 0.8, 0.04, 0.04, "<-", true)
		SwitchButtonR = guiCreateButton(0.5+(0.04), 0.8, 0.04, 0.04, "->", true)
		
		SwitchButtonAccept = guiCreateButton(0.5-(0.04), 0.8, 0.08, 0.04, "ВЫБРАТЬ", true)
		setElementData(SwitchButtonL, "data", "SwitchButtonL")
		setElementData(SwitchButtonR, "data", "SwitchButtonR")
		setElementData(SwitchButtonAccept, "data", "SwitchButtonAccept")
		setElementData(SwitchButtonL, "ped", PEDChangeSkin)
		setElementData(SwitchButtonR, "ped", PEDChangeSkin)
		setElementData(SwitchButtonAccept, "ped", PEDChangeSkin)
		showCursor(true)
		bindKey ("arrow_l", "down", NextSkinMinus) 
		bindKey ("arrow_r", "down", NextSkinPlus) 
		bindKey ("enter", "down", NextSkinEnter)
		LookHouse(SpawnPoints[1])
	end
end
addEvent("StartLookZones", true)
addEventHandler("StartLookZones", localPlayer, StartLookZones)




local EditHomeKey = {
	["1"] = "Трейлер", 
	["2"] = "Маленькая комната", 
	["3"] = "Дом 1 этаж (бедный)", 
	["4"] = "Дом 1 этаж (нормальный)", 
	["5"] = "Дом 1 этаж (богатый)", 
	["6"] = "Дом 2 этажа (бедный)", 
	["7"] = "Дом 2 этажа (нормальный)", 
	["8"] = "Дом 2 этаж (богатый)", 
	["9"] = "Special", 
	["0"] = "Гараж"
}


function sendEditHome(key)
	triggerServerEvent("SetHomeType", localPlayer, localPlayer, PlayerChangeSkinTeamRang:gsub('#%x%x%x%x%x%x', ''), EditHomeKey[key])
end



function StartLookZonesBeta(zones, update)
	if(#MyHouseBlip > 0) then 
		for slot = 1, #MyHouseBlip do
			destroyElement(MyHouseBlip[slot])
		end
		MyHouseBlip={}
	end
	
	
	
	bindKey ("0", "down", sendEditHome, 0)
	bindKey ("1", "down", sendEditHome, 1)
	bindKey ("2", "down", sendEditHome, 2)
	bindKey ("3", "down", sendEditHome, 3)
	bindKey ("4", "down", sendEditHome, 4)
	bindKey ("5", "down", sendEditHome, 5)
	bindKey ("6", "down", sendEditHome, 6)
	bindKey ("7", "down", sendEditHome, 7)
	bindKey ("8", "down", sendEditHome, 8)
	bindKey ("9", "down", sendEditHome, 9)
	
	
	SpawnPoints = fromJSON(zones)
	for i = 1, #SpawnPoints do
		if(SpawnPoints[i][4] == "house") then
			local x,y,z = SpawnPoints[i][1],SpawnPoints[i][2],SpawnPoints[i][3]
			MyHouseBlip[#MyHouseBlip+1]=createBlip(x, y, z, 31)
			local angle = SpawnPoints[i][6]
			if(not angle) then 
				if(not processLineOfSight(x, y, z, x+1, y, z, true)) then
					angle = 90
				elseif(not processLineOfSight(x, y, z, x-1, y, z, true)) then
					angle = 180
				elseif(not processLineOfSight(x, y, z, x, y+1, z, true)) then
					angle = 270
				elseif(not processLineOfSight(x, y, z, x, y-1, z, true)) then
					angle = 360
				else
					angle = 0
				end
			end
			SpawnPoints[i][6] = angle
		end
	end
	
	if(not update) then
		setElementDimension(localPlayer, getElementData(localPlayer,"id"))
		setElementInterior(localPlayer, 0)	
		PEDChangeSkin = true
		
		SwitchButtonL = guiCreateButton(0.5-(0.08), 0.8, 0.04, 0.04, "<-", true)
		SwitchButtonR = guiCreateButton(0.5+(0.04), 0.8, 0.04, 0.04, "->", true)
		
		SwitchButtonAccept = guiCreateButton(0.5-(0.04), 0.8, 0.08, 0.04, "ВЫБРАТЬ", true)
		setElementData(SwitchButtonL, "data", "SwitchButtonL")
		setElementData(SwitchButtonR, "data", "SwitchButtonR")
		setElementData(SwitchButtonAccept, "data", "SwitchButtonAccept")
		setElementData(SwitchButtonL, "ped", PEDChangeSkin)
		setElementData(SwitchButtonR, "ped", PEDChangeSkin)
		setElementData(SwitchButtonAccept, "ped", PEDChangeSkin)
		showCursor(true)
		bindKey ("arrow_l", "down", NextSkinMinus) 
		bindKey ("arrow_r", "down", NextSkinPlus) 
		bindKey ("enter", "down", NextSkinEnter)
		LookHouse(SpawnPoints[1])
	else
		playSFX("genrl", 75, 1, false)
		helpmessage("")
		MissionCompleted(update, "")
		local x,y,z = getElementPosition(localPlayer)
		setCameraMatrix(x+20, y-20, z+30, x, y, z)
		PEDChangeSkin = "cinema"
		setTimer(function(thePlayer)
			setCameraTarget(localPlayer)
			PEDChangeSkin = "play"
		end, 4000, 1)
	end
end
addEvent("StartLookZonesBeta", true)
addEventHandler("StartLookZonesBeta", localPlayer, StartLookZonesBeta)






function CloseSkinSwitch()
	if(GTASound) then
		stopSound(GTASound)
		GTASound = false
	end
	unbindKey ("arrow_l", "down", NextSkinMinus) 
	unbindKey ("arrow_r", "down", NextSkinPlus) 
	unbindKey ("enter", "down", NextSkinEnter) 
	PEDChangeSkin="play"
	showCursor(false)
	guiSetVisible(SwitchButtonAccept, false)
	guiSetVisible(SwitchButtonL, false)
	guiSetVisible(SwitchButtonR, false)
end
addEvent("CloseSkinSwitchEvent", true)
addEventHandler("CloseSkinSwitchEvent", localPlayer, CloseSkinSwitch)








local radioVehicleIds={}
function CreateVehicleAudioEvent(vehicle,typest, station,song)
	if(radioVehicleIds[vehicle]) then
		stopSound(radioVehicleIds[vehicle])
	end
	local x,y,z = getElementPosition(vehicle)
	radioVehicleIds[vehicle]=playSFX3D(typest, station, song, x, y, z,true)
	attachElements(radioVehicleIds[vehicle], vehicle, 0, 0, 0)
	setSoundVolume(radioVehicleIds[vehicle], 1.0)
	setSoundMaxDistance(radioVehicleIds[vehicle], 65)
	setSoundMinDistance(radioVehicleIds[vehicle], 8)
end
addEvent("CreateVehicleAudioEvent", true)
addEventHandler("CreateVehicleAudioEvent", localPlayer, CreateVehicleAudioEvent)



-- ИД обьекта, Навык
local WeaponModel = {
	[0] = {nil, 177},
	[1] = {331, 177},
	[2] = {333, 177},
	[3] = {334, 177},
	[4] = {335, 177},
	[5] = {336, 177},
	[6] = {337, 177},
	[7] = {338, 177},
	[8] = {339, 177},
	[9] = {341, 177},
	[10] = {321, 177},
	[11] = {322, 177},
	[12] = {323, 177},
	[14] = {325, 177},
	[15] = {326, 177},
	[22] = {346, 69},
	[23] = {347, 70},
	[24] = {348, 71},
	[25] = {349, 72},
	[26] = {350, 73},
	[27] = {351, 74},
	[28] = {352, 75},
	[29] = {353, 76},
	[32] = {372, 75},
	[30] = {355, 77},
	[31] = {356, 78},
	[33] = {357, 79},
	[34] = {358, 79},
	[35] = {359, nil},
	[36] = {360, nil},
	[37] = {361, nil},
	[38] = {362, nil},
	[16] = {342, nil},
	[17] = {343, nil},
	[18] = {344, nil},
	[39] = {363, nil},
	[40] = {364, nil},
	[41] = {365, nil},
	[42] = {366, nil},
	[43] = {367, nil},
	[44] = {368, nil},
	[45] = {369, nil},
	[46] = {371, nil},
	[3026] = {3026, nil},
	[1210] = {1210, nil},
	[1650] = {1650, nil},
	[2663] = {2663, nil},
	[1025] = {1025, nil},
	[3632] = {3632, nil}, 
	[1370] = {1370, nil}, 
	[1218] = {1218, nil}, 
	[1222] = {1222, nil}, 
	[1225] = {1225, nil}, 
	[1453] = {1453, nil},
	[330] = {330, nil}, 
	[2900] = {2900, nil}, 
}




function table.copy(t)
	local t2 = {};
	for k,v in pairs(t) do
		if type(v) == "table" then
			t2[k] = table.copy(v);
		else
			t2[k] = v;
		end
	end
	return t2;
end



function table.empty(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end


function UpdateArmas(thePlayer)
	if(getElementData(thePlayer, "armasplus")) then
		StreamData[thePlayer]["armasplus"] = fromJSON(getElementData(thePlayer, "armasplus"))
	else
		StreamData[thePlayer]["armasplus"] = {}
	end
	local WeaponUseTEMP = table.copy(StreamData[thePlayer]["armasplus"])
	if(getElementModel(thePlayer) ~= 0 and getElementModel(thePlayer) ~= 294 and getElementModel(thePlayer) ~= 293) then
		local invars = getElementData(thePlayer, "inv")
		if(invars) then
			local ars = fromJSON(invars)
			for _, data in pairs(ars) do
				for _, dat in pairs(data) do
					if(dat["name"]) then
						if(WeaponNamesArr[dat["name"]]) then
							WeaponUseTEMP[WeaponModel[WeaponNamesArr[dat["name"]]][1]]=true
						end
					end
				end
			end
		else
			return false
		end
	end
	if(getPedWeapon(thePlayer) ~= 0) then WeaponUseTEMP[WeaponModel[getPedWeapon(thePlayer)][1]] = nil end
	for v,z in pairs(WeaponUseTEMP) do
		if(not StreamData[thePlayer]["armas"][v]) then
			CreatePlayerArmas(thePlayer, v)
		end
	end
	
	for v,z in pairs(StreamData[thePlayer]["armas"]) do
		if(not WeaponUseTEMP[v]) then
			destroyElement(StreamData[thePlayer]["armas"][v])
			StreamData[thePlayer]["armas"][v] = nil
		end
	end
end


local WardrobeObject = {
	[1740] = true, 
	[1741] = true, 
	[1743] = true, 
	[2088] = true, 
	[2091] = true,
	[2094] = true,
	[2095] = true,
	[2158] = true,
	[2306] = true, 
	[2323] = true, 
	[2328] = true, 
	[2307] = true, 
	[2329] = true, 
	[2330] = true, 
	[1567] = true, --Дверь
	[14867] = true
}






function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end




local ActualBones = {1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 51, 52, 53, 54}



local CopCar = {
	[433] = true, 
	[470] = true, 
	[596] = true, 
	[597] = true, 
	[598] = true, 
	[599] = true, 
	[427] = true, 
	[490] = true, 
	[523] = true, 
}

function GetTurretPosition(x,y,z, vx,vy,vz,rz)
	local dist = getDistanceBetweenPoints3D(vx, vy, vz, x,y,z)/50
	local angle = math.rad(z-vz)/dist
	local vry = GetMarrot(findRotation(x,y,vx,vy),rz-180)
	return -math.rad(vry), angle
end


local FirePos = {}
local MovePlayerTo = {}
function UpdateBot()
	for _,thePed in pairs(getElementsByType("ped", getRootElement(), true)) do
		if(getElementData(thePed, "PedFight")) then return false end -- Для Underlords
		local theVehicle = getPedOccupiedVehicle(thePed)
		local attacker = GetElementAttacker(thePed)
		
		local hx,hy,hz = getPedBonePosition(thePed, 8)

		if(not attacker) then
			if(getTeamGroup(getElementData(thePed, "team")) == "Официалы") then
				for _,player in ipairs(getElementsByType("player", getRootElement(), true)) do 
					if(not isPedDead(player)) then
						if(getElementData(player, "WantedLevel")) then
							if(getElementData(player, "WantedLevel") > 0) then
								local ax, ay, az = getElementPosition(player)
								if(isLineOfSightClear(hx,hy,hz, ax, ay, az, true, false, false, false, false, false, false)) then
									triggerServerEvent("PedDamage", player, thePed, -1, 160, 0)
								end
							end
						end
					end
				end
			end
		end
		
		
		if(theVehicle) then
			if(MovePlayerTo[thePed]) then MovePlayerTo[thePed] = nil end -- Костыль
			local vx,vy,vz = getElementPosition(theVehicle)
			local rx,ry,rz = getElementRotation(theVehicle)
			local brakes = false
			local maxspd = 40
			local PointDistance = 4
			local mreverse = false
			
			local pathData = getElementData(thePed, "path")
			local path = {0,0}
			local nextpath = {0,0}
			if(pathData) then
				path = pathData[1]
				nextpath = pathData[2] or pathData[1]
				
				local dist = getDistanceBetweenPoints2D(path[1], path[2], vx,vy)
				if(dist <= PointDistance) then
					triggerServerEvent("DriverBotNextPath", localPlayer, localPlayer, thePed)
				end
				
			else
				brakes = true
			end
			
			
			local vxv, vyv, vzv = getElementVelocity(theVehicle)
			local s = (vxv^2 + vyv^2 + vzv^2)^(0.5)*156
	
			local nextrot = GetMarrot(findRotation(path[1], path[2], nextpath[1], nextpath[2]),rz)
			if(nextrot < 0) then nextrot = nextrot-nextrot-nextrot end
			if(nextrot > 90) then nextrot = 90 end
			
			if(attacker) then maxspd = 220 end
			local limitspeed = maxspd-((maxspd-10)*(nextrot/90))
	
			
			if(brakes) then
				setPedAnalogControlState(thePed, "accelerate", 0)
				setPedAnalogControlState(thePed, "brake_reverse", 0)
				setPedControlState(thePed, "handbrake", true)
				setElementVelocity (theVehicle, 0,0,0)
			else
				local rot = GetMarrot(findRotation(vx,vy,path[1], path[2]),rz)
				if(rot > 80) then 
					if(rot > 100) then mreverse = true end
					rot = 20 
				elseif(rot < -20) then 
					if(rot < -80) then mreverse = true end
					rot = -20 
				end
	
				
				if(mreverse) then
					setPedAnalogControlState(thePed, "brake_reverse", 1-(s*1/limitspeed))
					setPedAnalogControlState(thePed, "accelerate", 0)
					setPedControlState(thePed, "handbrake", false)
					if(s > 10) then
						setPedControlState(thePed, "handbrake", true)
					else
						if(rot > 0) then
							setPedAnalogControlState(thePed, "vehicle_left", (rot)/20)
						else
							setPedAnalogControlState(thePed, "vehicle_right", -(rot)/20)
						end
					end
				else
					if(rot > 0) then
						setPedAnalogControlState(thePed, "vehicle_right", (rot)/20)
					else
						setPedAnalogControlState(thePed, "vehicle_left", -(rot)/20)
					end
				
					setPedAnalogControlState(thePed, "brake_reverse", 0)
					setPedControlState(thePed, "handbrake", false)
					if(s < limitspeed) then 
						setPedAnalogControlState(thePed, "accelerate", 1-(s*1/limitspeed))
					else
						setPedAnalogControlState(thePed, "accelerate", 0)
						setPedAnalogControlState(thePed, "brake_reverse", (s/limitspeed)-1)
					end
				end
			end
			
		else
			local dialogrz = getElementData(thePed, "dialogrz")
			if(not dialogrz) then
				if(isElementSyncer(thePed)) then
					if(attacker) then
						local x,y,z = getPedBonePosition(attacker, ActualBones[math.random(#ActualBones)])
						MovePlayerTo[thePed] = {x,y,z,0,"fast",false,false,true} -- x,y,z,rz,speed,event,args,fire
						if(getTeamGroup(getElementData(thePed, "team")) == "Официалы") then
							if(getElementData(attacker, "NoFireMePolice")) then
								MovePlayerTo[thePed][8] = false
								if(GetDistance(thePed, attacker) < 15) then
									if(getElementData(attacker, "NoFireMePolice") == "0") then
										triggerServerEvent("PoliceArrest", localPlayer, thePed, attacker)
									end
								end
							end
							
							
							if(getElementData(attacker, "WantedLevel") == 0) then
								triggerServerEvent("NoAttack", localPlayer, attacker, thePed)
								setPedControlState(thePed, "aim_weapon", false) 
								setPedControlState(thePed, "sprint", false)
							end
						end
					else
						local x,y,z = getElementPosition(thePed)
						local x2,y2,z2 = getPositionInFront(thePed, 2)
						local _,_,_,_,hitElement,_,_,_,_ = processLineOfSight(x,y,z,x2,y2,z2, false,true)
						if(hitElement) then
							if(getElementType(hitElement) == "vehicle") then
								if(getVehicleOccupant(hitElement)) then
									local rand = math.random(1,5)
									if(rand == 1) then
										StartAnimation(thePed, "ped", "fucku", 1500, false, true, true, false)
									elseif(rand == 2) then
										StartAnimation(thePed, "ped", "ev_step", 1500, false, true, true, false)
									end
								end
							end
						end
						MovePlayerTo[thePed] = FoundBotPath(thePed) or nil -- обычное поведение
					end
				end
			end
		end
		if(MovePlayerTo[thePed]) then
			local dialog = getElementData(thePed, "saytome")
			local px,py,pz = getElementPosition(thePed)
			if(dialog) then
				setPedAimTarget(thePed,px,py,pz)
				setPedAnalogControlState(thePed, "forwards", 0)
			else
				local distance = getDistanceBetweenPoints3D(px,py,pz,MovePlayerTo[thePed][1],MovePlayerTo[thePed][2],MovePlayerTo[thePed][3])
				
				if(distance > 1) then
					local angle = findRotation(px,py,MovePlayerTo[thePed][1],MovePlayerTo[thePed][2])
					if(getElementType(thePed) == "player") then
						setPedAnalogControlState(thePed, "forwards", 1)
						setPedControlState(thePed, "walk", true)
						setPedCameraRotation(thePed, angle)
					else
						setPedAnalogControlState(thePed, "forwards", 1)
						if(MovePlayerTo[thePed][5] == "fast") then
							setPedControlState(thePed, "sprint", true)
						else
							setPedControlState(thePed, "walk", true)
						end
						setPedCameraRotation(thePed, -angle)
					end
					
					if(GetElementAttacker(thePed)) then
						local weapon = getPedWeapon(thePed)
						if(weapon) then
							local range = 2
							if(weapon > 9) then 
								range = getWeaponProperty(weapon, "poor", "weapon_range")/2
							end
							local firespeed = 300
							if(WeaponTiming[weapon]) then firespeed = WeaponTiming[weapon] end
							if(range > distance) then
								setPedAnalogControlState(thePed, "forwards", 0)
								setPedControlState(thePed, "sprint", false)
								setPedControlState(thePed, "walk", false)
								if(not isTimer(FireTimer[thePed])) then
									setPedControlState(thePed, "aim_weapon", true)
									setPedAimTarget(thePed,MovePlayerTo[thePed][1],MovePlayerTo[thePed][2],MovePlayerTo[thePed][3])
									
									if(MovePlayerTo[thePed][8]) then
										setPedControlState(thePed, "fire", true)
									end
									
									FireTimer[thePed] = setTimer(function(thePed)
										setPedControlState(thePed, "fire", false)
										setPedAimTarget(thePed,0,0,0) -- Костыль
									end, firespeed, 1, thePed)
								end
							end
						end
					end
				else
					if(getElementType(thePed) == "player") then
						setPedControlState(thePed, "forwards", false)
						setElementRotation(thePed, 0,0,MovePlayerTo[thePed][4],"default",true)
						if(MovePlayerTo[thePed][6]) then
							triggerServerEvent(MovePlayerTo[thePed][6], thePed, thePed, unpack(MovePlayerTo[thePed][7]))
						end
						MovePlayerTo[thePed] = nil
					end
				end
			end
		end
	end
end



		
function StartAnimation(thePlayer, block, anim, times, loop, updatePosition, interruptable, freezeLastFrame, forced)
	triggerServerEvent("StartAnimation", localPlayer, thePlayer, block, anim, times, loop, updatePosition, interruptable, freezeLastFrame, forced)
end


local VehTypeSkill = {
	["Automobile"] = 160,
	["Monster Truck"] = 160,
	["Unknown"] = 160,
	["Trailer"] = 160,
	["Train"] = 160,
	["Boat"] = 160,
	["Bike"] = 229,
	["Quad"] = 229,
	["BMX"] = 230,
	["Helicopter"] = 169,
	["Plane"] = 169
}






function getVehicleOneGear(engineAcceleration, dragCoeff, numberOfGears) -- engineAcceleration, dragCoeff, numberOfGears
	return (math.sqrt(3300*engineAcceleration/dragCoeff)*1.18)/numberOfGears
end


function getVehicleGear(theVehicle, engineAcceleration, dragCoeff, numberOfGears)
	local onegear = getVehicleOneGear(engineAcceleration, dragCoeff, numberOfGears)
	local result = 0
	for Gear = 0, numberOfGears, 1 do
		if(getVehicleCurrentGear(theVehicle) > 0) then
			if(onegear*Gear <= VehicleSpeed) then
				if((Gear+1) <= numberOfGears) then
					result = (Gear+1)
				end
			end
		else
			result = 0
		end
	end
    return result
end



function getVehicleRPM(theVehicle, engineAcceleration, dragCoeff, numberOfGears)
	local onegear = getVehicleOneGear(engineAcceleration, dragCoeff, numberOfGears)
	local MaxRPM = GetVehicleMaxRPM(engineAcceleration)
	local Gear = getVehicleGear(theVehicle, engineAcceleration, dragCoeff, numberOfGears)
	local crpm = 0
	if(getKeyState("w") and getKeyState("s") or getKeyState("w") and getKeyState("space")) then
		crpm = MaxRPM/onegear*(onegear-((onegear*Gear)-onegear))
	else
		if(Gear > 0) then
			crpm = MaxRPM/onegear*(onegear-((onegear*Gear)-VehicleSpeed))
		else
			crpm = MaxRPM/onegear*((VehicleSpeed-onegear*Gear))
		end
	end
	if getVehicleEngineState(theVehicle) == true then
		if(crpm < 800) then 
			crpm = 800
		else
			if(crpm > MaxRPM) then crpm = MaxRPM end -- Костыль
		end
	end
    return crpm
end


function GetVehicleMaxRPM(engineAcceleration)
	return (((10*(engineAcceleration))*1.5))*40
end


local PedHorn = {}
function HornPed(thePed, thePlayer)
	if(not isTimer(PedHorn[thePed])) then
		setPedControlState(thePed, "horn", true)
		PedHorn[thePed] = setTimer(function() 
			if(getPedControlState(thePed, "horn")) then
				setPedControlState(thePed, "horn", false)
			else
				setPedControlState(thePed, "horn", true)
			end
		end, math.random(100,500), 5)
		if(thePlayer) then
			local rand = math.random(1,5)
			if(rand > 2) then
				StartAnimation(thePlayer, "ped", "fucku", 1500, false, true, true, false)
			elseif(rand == 1) then
				StartAnimation(thePlayer, "ped", "ev_step", 1500, false, true, true, false)
			elseif(rand == 2) then
				StartAnimation(thePlayer, "ped", "ev_dive", 3000,false,true,true,false)
			end
		end
	end
end



local bones = {
	[1] = {5,4,6}, --head{5,nil,6}
	[2] = {4,5,8}, --neck
	[3] = {3,1,31}, --spine {3,nil,31}
	[4] = {1,2,3}, --pelvis
	[5] = {4,32,5}, --left clavicle
	[6] = {4,22,5}, --right clavicle
	[7] = {32,33,34}, --left shoulder
	[8] = {22,23,24}, --right shoulder
	[9] = {33,34,32}, --left elbow
	[10] = {23,24,22}, --right elbow
	[11] = {34,35,36}, --left hand
	[12] = {24,25,26}, --right hand
	[13] = {41,42,43}, --left hip
	[14] = {51,52,53}, --right hip
	[15] = {42,43,44}, --left knee
	[16] = {52,53,54}, --right knee
	[17] = {43,42,44}, --left ankle
	[18] = {53,52,54}, --right angle
	[19] = {44,43,42}, --left foot
	[20] = {54,53,52} --right foot
}


function updateWorld()
	UpdateBot()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if(PData["Driver"] and theVehicle) then
		if(getElementDimension(localPlayer) == 0 or getElementData(localPlayer, "City")) then
			local x,y,z = getElementPosition(theVehicle)
			PData["Driver"]["Distance"] = PData["Driver"]["Distance"]+getDistanceBetweenPoints3D(PData["Driver"]["drx"], PData["Driver"]["dry"], PData["Driver"]["drz"], x, y, z)
			PData["Driver"]["drx"], PData["Driver"]["dry"], PData["Driver"]["drz"] = x,y,z
			if(PData["Driver"]["Distance"] >= 2000) then
				local VehType = GetVehicleType(theVehicle)
				PData["Driver"]["Distance"] = 0
				triggerServerEvent("AddSkill", localPlayer, localPlayer, VehTypeSkill[VehType], 5)
			end
			
			if(GetVehicleType(theVehicle) == "Automobile" or GetVehicleType(theVehicle) == "Bike") then
				if(not isVehicleOnGround(theVehicle)) then
					if(not PData["Driver"]["jump"]) then 
						PData["Driver"]["jump"] = {0} 
						PData["Driver"]["jump"][2], PData["Driver"]["jump"][3], PData["Driver"]["jump"][4] = getElementPosition(theVehicle)
						PData["Driver"]["jump"][5], PData["Driver"]["jump"][6], PData["Driver"]["jump"][7] = getElementRotation(theVehicle)
						PData["Driver"]["jump"][8], PData["Driver"]["jump"][9], PData["Driver"]["jump"][10] = 0, 0, 0
					end
					PData["Driver"]["jump"][1] = PData["Driver"]["jump"][1]+0.5
					if(PData["Driver"]["jump"][1] >= 10) then
						RageInfo(Text("Отрыв от земли +{points}", {{"{points}", math.round(PData["Driver"]["jump"][1], 0)}}))
						
						local rx,ry,rz = getElementRotation(theVehicle)
						PData["Driver"]["jump"][8] = math.round(PData["Driver"]["jump"][8]+MinusToPlus(math.sin(rx-PData["Driver"]["jump"][5])), 0)
						PData["Driver"]["jump"][9] = math.round(PData["Driver"]["jump"][9]+MinusToPlus(math.sin(ry-PData["Driver"]["jump"][6])), 0)
						PData["Driver"]["jump"][10] = math.round(PData["Driver"]["jump"][10]+MinusToPlus(math.sin(rz-PData["Driver"]["jump"][7])), 0)
						
						PData["Driver"]["jump"][5], PData["Driver"]["jump"][6], PData["Driver"]["jump"][7] = getElementRotation(theVehicle)
						
					end
				else
					if(PData["Driver"]["jump"]) then
						if(PData["Driver"]["jump"][1] >= 10) then
							AddRage(math.round(PData["Driver"]["jump"][1]*10, 0))
							local x,y,z = getElementPosition(theVehicle)
							local jumph = math.floor(PData["Driver"]["jump"][4]-z, 1)
							if(jumph < 0) then jumph = jumph-jumph-jumph end
							if(jumph > 10) then
								local salto = (math.round(PData["Driver"]["jump"][8]/360, 0))+(math.round(PData["Driver"]["jump"][9]/360, 0))+(math.round(PData["Driver"]["jump"][10]/360, 0))
								helpmessage("Дистанция: "..math.floor(getDistanceBetweenPoints2D(PData["Driver"]["jump"][2], PData["Driver"]["jump"][3], x,y), 1)..
								"м Высота: "..jumph.."м "..
								"Переворотов: "..salto..
								" Вращение: "..PData["Driver"]["jump"][8]+PData["Driver"]["jump"][9]+PData["Driver"]["jump"][10].."°")
							end
						end
						PData["Driver"]["jump"] = nil
					end
				end
			end
				
				
			if(VehicleSpeed > 100) then
				local vxl,vyl,vzl, vxr, vyr, vzr = false
				local vxc, vyc, vzc = getElementPosition(theVehicle)
				if(GetVehicleType(theVehicle) == "Automobile") then
					vxl, vyl, vzl = getVehicleComponentPosition(theVehicle, "wheel_lf_dummy", "world")
					vxr, vyr, vzr = getVehicleComponentPosition(theVehicle, "wheel_rf_dummy", "world")
				elseif(GetVehicleType(theVehicle) == "Bike") then
					vxl, vyl, vzl = getVehicleComponentPosition(theVehicle, "wheel_front", "world")
					vxr, vyr, vzr = getVehicleComponentPosition(theVehicle, "wheel_front", "world")
				end
				
				if(vxr) then
					local _,_,rz = getElementRotation(theVehicle)
					
					local x,y,z = getPointInFrontOfPoint(vxc, vyc, vzc, rz-270, 30)
					local _,_,_,_,hitElement,_,_,_,_ = processLineOfSight(vxc, vyc, vzc,x,y,z, false, true, true, false, false, false, false, false, theVehicle,false,false)
					if(hitElement) then
						if(getElementType(hitElement) == "vehicle") then
							if(not PData["VehicleBonus3"]) then PData["VehicleBonus3"] = 0 end
							PData["VehicleBonus3"] = PData["VehicleBonus3"] + 0.2
							if(PData["VehicleBonus3"] > 1) then 
								RageInfo(Text("Преследование +{points}", {{"{points}", math.round(PData["VehicleBonus3"], 0)}}))
							end
						elseif(getElementType(hitElement) == "ped") then
							StartAnimation(hitElement, "ped", "ev_dive", 3000,false,true,true,false)
						end
					else
						if(PData["VehicleBonus3"]) then
							if(PData["VehicleBonus3"] > 1) then 
								AddRage(math.round(PData["VehicleBonus3"], 0))
								PData["VehicleBonus3"] = nil
							end
						end
					end
					
					
					x,y,z = getPointInFrontOfPoint(vxl, vyl, vzl, rz-180, 1)
					_,_,_,_,hitElement,_,_,_,_ = processLineOfSight(vxl,vyl,vzl+0.5,x,y,z+0.5, false, true, false, false, false, false, false, false, theVehicle,false,false)
					if(hitElement) then
						local occ = getVehicleOccupant(hitElement)
						if(occ) then
							if(getElementType(occ) == "ped") then
								local _, _, brz = getElementRotation(hitElement)
								if(brz-rz >= 40 or brz-rz <= -40) then
									if(not isTimer(PData["VehicleBonus"])) then
										AddRage(math.round(VehicleSpeed-50, 0))
										RageInfo(Text("Опасное вождение +{points}", {{"{points}", math.round(VehicleSpeed-50, 0)}}))
										PData["VehicleBonus"] = setTimer(function() end, 2000, 1)
									end
									HornPed(occ)
								else
									if(not isTimer(PData["VehicleBonus"])) then
										AddRage(math.round(VehicleSpeed-50, 0))
										RageInfo(Text("Обгон +{points}", {{"{points}", math.round(VehicleSpeed-50, 0)}}))
										PData["VehicleBonus"] = setTimer(function() end, 2000, 1)
									end
									HornPed(occ)
								end
							end
						end
					end
					
			
					
					x,y,z = getPointInFrontOfPoint(vxr, vyr, vzr, rz, 1)
					_,_,_,_,hitElement,_,_,_,_ = processLineOfSight(vxr, vyr, vzr+0.5,x,y,z+0.5, false, true, false, false, false, false, false, false, theVehicle,false,false)
					if(hitElement) then
						local occ = getVehicleOccupant(hitElement)
						if(occ) then
							if(getElementType(occ) == "ped") then
								local _, _, brz = getElementRotation(hitElement)
								if(brz-rz >= 40 or brz-rz <= -40) then
									if(not isTimer(PData["VehicleBonus"])) then
										AddRage(math.round(VehicleSpeed-100, 0))
										RageInfo(Text("Опасное вождение +{points}", {{"{points}", math.round(VehicleSpeed-100, 0)}}))
										PData["VehicleBonus"] = setTimer(function() end, 2000, 1)
									end
									HornPed(occ)
								else	
									if(not isTimer(PData["VehicleBonus"])) then
										AddRage(math.round(VehicleSpeed-100, 0))
										RageInfo(Text("Обгон +{points}", {{"{points}", math.round(VehicleSpeed-100, 0)}}))
										PData["VehicleBonus"] = setTimer(function() end, 2000, 1)
									end
									HornPed(occ)
								end
							end
						end
					end
				end
			end
		end
	end
end
setTimer(updateWorld, 50, 0)




function checkKey()
	if(PEDChangeSkin == "play") then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if(getPedControlState(localPlayer, "sprint")) and PData["stamina"] ~= 0 then
			PData["stamina"] = PData["stamina"]-1
			if(getPedStat(localPlayer, 22) ~= 1000) then
				PData["LVLUPSTAMINA"] = PData["LVLUPSTAMINA"]-1
				if(PData["LVLUPSTAMINA"] == 0) then
					triggerServerEvent("StaminaOut", localPlayer, true)
					PData["LVLUPSTAMINA"] = 10
				end
			end
		end
		if(PData["stamina"] <= 0) then
			triggerServerEvent("StaminaOut", localPlayer)
			setPedControlState(localPlayer, "sprint", false)
		end
		
		for _, thePlayer in pairs(getElementsByType("player", getRootElement(), true)) do
			UpdateArmas(thePlayer)
		end
		for _, thePed in pairs(getElementsByType("ped", getRootElement(), true)) do
			UpdateArmas(thePed)
		end
		if(theVehicle and PData["ClearDriving"]) then
			if(VehicleSpeed < 1) then
				if(isTimer(PData["ClearDriving"])) then resetTimer(PData["ClearDriving"]) end
				if(getElementData(theVehicle, "owner") == getPlayerName(localPlayer)) then
					ChangeInfo(Text("Нажми {key} чтобы припарковать машину", {{"{key}", COLOR["KEY"]["HEX"].."P#FFFFFF"}}), 1000)
				end
			end
		end
	end	
	if(PING) then UpdateTabEvent() end
	
	local x,y,z = getElementPosition(localPlayer)
	local x2,y2,z2 = getPositionInFront(localPlayer, 1)
	PData["TARR"] = {} 
	for i = 1, 3 do
		local _,_,_,_,_,_,_,_,_,_,_,wmodel,wx,wy,wz = processLineOfSight(x,y,z,x2,y2,z2-(1-(0.5*i)), true,false,false,true,false,false,false,false,localPlayer, true) 
		if(wmodel) then
			PData["TARR"][wmodel] = {wx,wy,wz}
		end
	end
	
	for k, arr in pairs(PData["TARR"]) do
		if(k) then
			if(PData["Target"][k]) then
				if(PData["Target"][k][1] == arr[1] and PData["Target"][k][2] == arr[2] and PData["Target"][k][3] == arr[3]) then
					return
				end
			end
			PData["Target"][k] = {arr[1], arr[2], arr[3]}
			if(WardrobeObject[k]) then
				ToolTip(Text("Нажми {key} чтобы переодеться", {{"{key}", COLOR["KEY"]["HEX"].."F#FFFFFF"}}))
			
			end
		end
	end
	for i, key in pairs(PData["Target"]) do
		if(not PData["TARR"][i]) then
			PData["Target"][i] = nil
		end
	end
	
	

end
setTimer(checkKey,700,0)




local BannedMaterial = {
	[0] = true, 
	[1] = true, 
	[9] = true, 
	[75] = true, 
	[76] = true,
	[118] = true,
}



function BotCheckPath(x,y,z,x2,y2,z2,city,zone)
	local gz = getGroundPosition(x2,y2,z2)
	if(isLineOfSightClear(x,y,z-0.45,x2,y2,gz+0.1, true, true, true, true)) then
		if(zone == getZoneName(x2,y2,z2)) then
			if(zone ~= "Unknown") then  
				local material = exports["vehicle_node"]:GetGroundMaterial(x2,y2,z2, gz-2,city)
				if(not BannedMaterial[material]) then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end






function FoundBotPath(ped)
	local arr = {}
	local x,y,z = getElementPosition(ped)
	local x2,y2,z2 = getPositionInFront(ped, 8)
	local zone = getZoneName(x,y,z, false)
	local city = getPlayerCity(ped)
	
	if(getElementData(ped, "GROUP")) then
		local thePlayer = getPlayerFromName(getElementData(ped, "GROUP"))
		if(thePlayer) then
			local xp,yp,zp = getElementPosition(thePlayer)
			return {xp,yp,zp,0,"silent"}
		end
	end
	
	if(BotCheckPath(x,y,z,x2,y2,z2,city,zone)) then 
		return {x2,y2,z2,0,"silent"}
	else
		local x3,y3,z3 = getPositionInRight(ped, 2)
		local a3,b3,c3 = getPositionInFR(ped, 2)
		local x4,y4,z4 = getPositionInLeft(ped, 2)
		local a4,b4,c4 = getPositionInFL(ped, 2)
		if(BotCheckPath(x,y,z, a3,b3,c3,city,zone)) then
			arr[#arr+1] = {a3,b3,c3,0,"silent"}
		elseif(BotCheckPath(x,y,z, x3,y3,z3,city,zone)) then
			arr[#arr+1] = {x3,y3,z3,0,"silent"}
		end

		if(BotCheckPath(x,y,z, a4,b4,c4,city,zone)) then
			arr[#arr+1] = {a4,b4,c4,0,"silent"}
		elseif(BotCheckPath(x,y,z, x4,y4,z4,city,zone)) then
			arr[#arr+1] = {x4,y4,z4,0,"silent"}
		end

		if(#arr == 0) then
			local x5,y5,z5 = getPositionInBack(ped, 8)
			if(BotCheckPath(x,y,z, x5,y5,z5,city,zone)) then -- В крайнем случае идем назад
				return {x5,y5,z5,0,"silent"}
			else
				if(getElementData(ped, "TINF")) then
					local arrtmp = fromJSON(getElementData(ped, "TINF"))
					
					arr = {arrtmp[3], arrtmp[4], arrtmp[5], arrtmp[6], "silent"}
					return arr --Если нет путей
				else
					return false
				end
			end
		end
		return arr[math.random(1,#arr)] --Если спереди что то мешает выбераем рандомный свободный путь
	end
end





	
local SkillName = {
	[165] = "Пьяница", 
	[160] = "Вождение",
	[229] = "Мотоциклист",
	[230] = "Велосипедист",
	[169] = "Летчик",
	[161] = "Грузоперевозки",
	[157] = "Рыболов",
	[177] = "Рукопашный бой",
	[69] = "Пистолет",
	[70] = "Пистолет с глуш.",
	[71] = "Дигл",
	[72] = "Дробовик",
	[73] = "Sawn-Off",
	[74] = "SPAZ-12",
	[75] = "УЗИ",
	[76] = "MP5",
	[77] = "АК-47",
	[78] = "M4",
	[79] = "Винтовка",
	[24] = "Здоровье",
	[22] = "Выносливость"
}


local SkillLevel = {
	[165] = {
		[0] = "Ты понизил свой навык пьяницы\nТеперь ты пьяница застенчивый", 
		[500] = "Ты повысил свой навык пьяницы\nТеперь ты пьяница выносливый", 
		[999] = "Ты повысил свой навык пьяницы\nТеперь ты пьяница вездесущий", 
	}, 
	[229] = {
		[0] = "Ты понизил свой навык мотоциклиста", 
		[500] = "Ты повысил свой навык мотоциклиста\nУ тебя меньше шансов упасть с мотоцикла", 
		[999] = "Ты повысил свой навык мотоциклиста\nУ тебя меньше шансов упасть с мотоцикла", 
	}
	
}

 

 
function getPointInFrontOfPoint(x, y, z, rZ, dist)
	local offsetRot = math.rad(rZ)
	local vx = x + dist * math.cos(offsetRot)
	local vy = y + dist * math.sin(offsetRot)  
	return vx, vy, z
end







function getMatrixFromEulerAngles(x,y,z)
	x,y,z = math.rad(x),math.rad(y),math.rad(z)
	local sinx,cosx,siny,cosy,sinz,cosz = math.sin(x),math.cos(x),math.sin(y),math.cos(y),math.sin(z),math.cos(z)
	return
		cosy*cosz-siny*sinx*sinz,cosy*sinz+siny*sinx*cosz,-siny*cosx,
		-cosx*sinz,cosx*cosz,sinx,
		siny*cosz+cosy*sinx*sinz,siny*sinz-cosy*sinx*cosz,cosy*cosx
end

function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return math.deg(math.asin(z2)),-math.deg(math.atan2(vx,vz)),-math.deg(math.atan2(x2,y2))
end




function updateStamina()
	if(PEDChangeSkin == "play") then
		if PData["stamina"] ~= 8+math.floor(getPedStat(localPlayer, 22)/40) and getPedControlState(localPlayer, "sprint") == false then
			PData["stamina"] = PData["stamina"] +1
		end
		if(PData["ShakeLVL"] > 0) then
			PData["ShakeLVL"] = PData["ShakeLVL"]-1
			setCameraShakeLevel(PData["ShakeLVL"])
		end	
	end
end
setTimer(updateStamina,1000,0)



function DrugsPlayerEffect()
	if(isTimer(DrugsTimer)) then
		resetTimer(DrugsTimer)
	else
		DrugsTimer = setTimer(function()
			setWeather(math.random(0,19))
			setWindVelocity(math.random(1,100), math.random(1,100), math.random(1,100))
			setGameSpeed(math.random(1,20)/10)
			setSkyGradient(math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255))
		end, 1000+math.random(0,4000), 0 )
	end
end
addEvent("DrugsPlayerEffect", true)
addEventHandler("DrugsPlayerEffect", root, DrugsPlayerEffect)


function SpunkPlayerEffect()
	if(isTimer(SpunkTimer)) then
		resetTimer(SpunkTimer)
	else
		SpunkTimer = setTimer(function()
			SleepSound("script", math.random(1,200), math.random(0,55), false)
		end, 1000+math.random(0,4000), 0)
	end
end
addEvent("SpunkPlayerEffect", true)
addEventHandler("SpunkPlayerEffect", root, SpunkPlayerEffect)





function OpenTAB()
	if(Targets["theVehicle"]) then
		if(getVehiclePlateText(Targets["theVehicle"]) == "SELL 228") then
			triggerServerEvent("BuyCar", localPlayer, Targets["theVehicle"])
		end
	end
	UpdateTabEvent()
end



function getPlayerCity(thePlayer)
	return getElementData(thePlayer, "City") or "San Andreas"
end

function UpdateTabEvent()
	IDF, NF, RANG, PING = "","","",""
	TABCurrent = 0
	
	local thePlayers = getElementsByType("player")
	
	if(TabScroll > #thePlayers) then TabScroll = #thePlayers end
	for slot = TabScroll, #thePlayers do
		if(TABCurrent < MAXSCROLL) then
			if(isElement(thePlayers[slot])) then
				if(getElementData(thePlayers[slot], "color")) then
					RANG=RANG..getPlayerCity(thePlayers[slot]).."\n"
					IDF = IDF..getElementData(thePlayers[slot], "id").."\n"
					NF = NF..getElementData(thePlayers[slot], "color")..getPlayerName(thePlayers[slot]):gsub('#%x%x%x%x%x%x', '').."\n"
					PING = PING..getPlayerPing(thePlayers[slot]).."\n"
					TABCurrent = TABCurrent+1
				end
			else
				RANG=RANG..thePlayers[slot][2].."\n"
				IDF = IDF..(TABCurrent+1).."\n"
				NF = NF.."#FFFFFF"..thePlayers[slot][1].."\n"
				PING = PING.."0".."\n"
				TABCurrent = TABCurrent+1
			end
		end
	end
end

function CloseTAB()
	IDF = false
	NF = false
	RANG = false
	PING = false
end






function isnan(x) 
    if (x ~= x) then 
        return true 
    end 
    if type(x) ~= "number" then 
       return false 
    end 
    if tostring(x) == tostring((-1)^0.5) then 
        return true 
    end 
    return false 
end 






-- bone, offx,offy,offz,offrx,offry,offrz
local ModelPlayerPosition = {
	[352] = {13, -0.06, 0.05, -0.1, -5, 260, 90},
	[353] = {13, -0.06, 0.05, -0.1, -5, 260, 90},
	[372] = {13, -0.06, 0.05, -0.1, -5, 260, 90},
	[346] = {14, 0.08, 0.05, -0.1, 5, 260, 90},
	[347] = {14, 0.08, 0.05, -0.1, 5, 260, 90},
	[348] = {14, 0.08, 0.05, -0.1, 5, 260, 90},
	[342] = {14, 0.08, 0.05, -0.1, 5, 260, 90},
	[335] = {14, 0.13, -0.08, -0.04, 5, 0, 90},
	[367] = {3, 0.11, 0.13, 0.1, 0, 40, 90},
	[349] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[350] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[351] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[355] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[356] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[357] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[358] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[359] = {3, 0.07, -0.14, 0, 0, 290, 15}, 
	[341] = {3, 0, -0.14, -0.25, 0, 290, 15}, 
	[3026] = {3, 0, -0.10, -0.15, 0, 270, 0}, 
	[339] = {3, 0.15, -0.14, 0.2, 0, 200, 15},
	[338] = {3, 0.15, -0.14, 0.2, 0, 200, 15},
	[333] = {3, 0.15, -0.14, 0.2, 0, 200, 15},
	[336] = {3, 0.15, -0.14, 0.2, 0, 200, 15},
	[337] = {3, 0.15, -0.14, 0.2, 0, 200, 15},
	[321] = {4, 0, -0.04, -0.1, 0, 160, 90},
	[322] = {4, 0, -0.04, -0.1, 0, 160, 90},
	[323] = {4, 0, -0.04, -0.1, 0, 160, 90},
	[1484] = {11,0.01,0,0.15,0,140,0},
	[1950] = {11,-0.14,0.05,0.1,0,100,0},
	[1951] = {11,-0.14,0.05,0.1,0,100,0},
	[1669] = {11,-0.14,0.05,0.1,0,100,0},
	[1543] = {11,-0.22,0.05,0.15,0,100,0},
	[1544] = {11,-0.15,0.05,0.30,0,140,0},
	[1546] = {11,0,0.1,0.1,0,90,0},
	[330] = {12,0,0,0.03,0,-90,0},
	[2880] = {12,0,0,0,0,-90,0},
	[2881] = {12,0,0,0,0,-90,0},
	[2769] = {11,0,0,0.1,0,0,0},
	[3027] = {1, 0, 0.09, -0.01, 90, 90, 90},
	[1210] = {12, 0, 0.1, 0.3, 0, 180, 0},
	[954] = {12, 0, 0.1, 0.3, 0, 180, 0},
	[1276] = {12, 0, 0.1, 0.3, 0, 180, 0},
	[2663] = {12, 0, 0, 0.3, 0, 180, 0},
	[1650] = {12, 0, 0, 0.15, 0, 180, 0},
	[1609] = {3, 0, 0, -0.25, 90, 0, 0},
	[1608] = {3, 0, 0, -0.25, 90, 0, 0},
	[1607] = {3, 0, 0, -0.25, 90, 0, 0},
	[1025] = {12, 0.2, 0.05, 0, 0, 0, 75},
	[3632] = {12, 0, 0, 0, 0, 90, 0},
	[1370] = {12, 0, 0, 0, 0, 90, 0},
	[1218] = {12, 0, 0, 0, 0, 90, 0},
	[1222] = {12, 0, 0, 0, 0, 90, 0},
	[1225] = {12, 0, 0, 0, 0, 90, 0},
	[1453] = {12, 0.2, 0.1, 0, 0, 90, 345},
	[2900] = {12, -0.1, 0.3, 0.15, 0, 90, 0},
}





function UpdateDisplayArmas(thePlayer)
	if(isElementAttached(thePlayer)) then
		local ATT = getElementAttachedTo(thePlayer)
		local rx,ry,rz=getElementRotation(ATT)
		setElementRotation(thePlayer,rx,ry,rz,"default",true)
	end
	if(StreamData[thePlayer]) then
		for model,weapon in pairs(StreamData[thePlayer]["armas"]) do
			model = tonumber(model)
			if(ModelPlayerPosition[model]) then
				local bone, offx,offy,offz,offrx,offry,offrz = unpack(ModelPlayerPosition[model])
				if(getElementData(thePlayer, "BottleAnus")) then
					if(model == getElementData(thePlayer, "BottleAnus")) then
						bone, offx,offy,offz,offrx,offry,offrz = 3, -0.1, 0.1, -0.6, 0, 0, 0
					end
				end
				
				
				local x,y,z = getPedBonePosition(thePlayer,bones[bone][1])


				local xx,xy,xz,yx,yy,yz,zx,zy,zz = getBoneMatrix(thePlayer,bone)
				local objx = x+offx*xx+offy*yx+offz*zx
				local objy = y+offx*xy+offy*yy+offz*zy
				local objz = z+offx*xz+offy*yz+offz*zz
				local rxx,rxy,rxz,ryx,ryy,ryz,rzx,rzy,rzz = getMatrixFromEulerAngles(offrx,offry,offrz)
				
				local txx = rxx*xx+rxy*yx+rxz*zx
				local txy = rxx*xy+rxy*yy+rxz*zy
				local txz = rxx*xz+rxy*yz+rxz*zz
				local tyx = ryx*xx+ryy*yx+ryz*zx
				local tyy = ryx*xy+ryy*yy+ryz*zy
				local tyz = ryx*xz+ryy*yz+ryz*zz
				local tzx = rzx*xx+rzy*yx+rzz*zx
				local tzy = rzx*xy+rzy*yy+rzz*zy
				local tzz = rzx*xz+rzy*yz+rzz*zz
				offrx,offry,offrz = getEulerAnglesFromMatrix(txx,txy,txz,tyx,tyy,tyz,tzx,tzy,tzz)
				
				if(isnan(offrx) or isnan(offry) or isnan(offrz)) then return false end		
				if(isnan(objx) or isnan(objy) or isnan(objz)) then return false end
				

				setElementPosition(weapon,objx,objy,objz)
				setElementRotation(weapon,offrx,offry,offrz,"ZXY")
			end
		end
	end
end






function deathmatchInfo(times, scores)
	if(times) then
		local mins = string.format("%02.f", math.floor(times/60))
		PText["HUD"][1] = {"ВРЕМЯ\n#BFCBFAУБИЙСТВ", screenWidth, screenHeight-(500*scalex), screenWidth-(150*scalex), 0, tocolor(232, 232, 255, 255), NewScale*3, "clear", "right", "top", false, false, false, true, true, 0, 0, 0,  {["border"] = true}}
		PText["HUD"][2] = {""..mins..":"..string.format("%02.f", times-(mins*60)).."\n#BFCBFA"..scores, screenWidth, screenHeight-(500*scalex), screenWidth-(20*scalex), 0, tocolor(232, 232, 255, 255), NewScale*3, "clear", "right", "top", false, false, false, true, true, 0, 0, 0,  {["border"] = true}}
		DeathMatch = true
	else
		DeathMatch = false
		PText["HUD"][1] = nil
		PText["HUD"][2] = nil
	end
end
addEvent("deathmatchInfo", true)
addEventHandler("deathmatchInfo", localPlayer, deathmatchInfo)





function LoginClient(open)
	if(open) then
		triggerEvent("CreateButtonInputInt", localPlayer, "loginPlayerEvent", Text("Регистрация/Вход"))
		showCursor(true)
		
		outputChatBox(Text("Нажми {key} чтобы писать в общий чат", {{"{key}", COLOR["KEY"]["HEX"].."T#FFFFFF"}}),  255, 255, 255,true)
		outputChatBox(Text("Нажми {key} чтобы писать в командный чат", {{"{key}", COLOR["KEY"]["HEX"].."Y#FFFFFF"}}),  255, 255, 255,true)
		outputChatBox(Text("Исходный код сервера {link}", {{"{link}", "#2980B9https://github.com/alexaxel705/MTA-Tomsk"}}),  255, 255, 255,true)
		outputChatBox(Text("Группа ВКонтакте {link}", {{"{link}", "#2980B9http://vk.com/mtatomsk"}}),  255, 255, 255,true)
		outputChatBox("Обновление 21.09.2019: Добавлены зоны для общего чата", 255, 150, 150,true)
	else
		PText["HUD"][8] = nil
	end
end
addEvent("LoginWindow", true)
addEventHandler("LoginWindow", localPlayer, LoginClient)



function StartUnload()
	LoginClient(false)
	for name, dat in pairs(VideoMemory) do
		VideoMemory[name] = {}
	end
	stopSound(GTASound)
	return true
end





function HUDPreload()
	VideoMemory["HUD"]["TABPanel"] = dxCreateRenderTarget(screenWidth, screenHeight, true)
	dxSetRenderTarget(VideoMemory["HUD"]["TABPanel"], true)
	dxSetBlendMode("modulate_add")

	local x,y = 510*scalex, 270*scaley
	dxDrawRectangle(x,y, 750*NewScale, 500*NewScale, tocolor(0, 0, 0, 180))	
	dxDrawBorderedText("Multi Theft Auto: Stories (RPG\\DM) [Russian\Tomsk]", 540*scalex, 285*scaley, 0, 0, tocolor(200, 200, 200, 255), NewScale*1.2, "default-bold", "left", "top")
	dxDrawBorderedText(Text("ид"), x+(15*NewScale), y+(40*scaley), 0, 0, tocolor(74, 140, 178, 255), NewScale*1.2, "default-bold", "left", "top")
	dxDrawBorderedText(Text("ник"), x+(60*NewScale), y+(40*scaley), 0, 0, tocolor(74, 140, 178, 255), NewScale*1.2, "default-bold", "left", "top")
	dxDrawBorderedText("локация", x+(310*NewScale), y+(40*scaley), 0, 0, tocolor(74, 140, 178, 255), NewScale*1.2, "default-bold", "left", "top")
	dxDrawBorderedText(Text("пинг"), x+(710*NewScale), y+(40*scaley), 0, 0, tocolor(74, 140, 178, 255), NewScale*1.2, "default-bold", "left", "top")
	dxDrawLine(510*scalex, 329*scaley, x+(750*NewScale), 329*scaley, tocolor(120,120,120,255), 1)
	dxDrawRectangle(475*scalex, 810*scaley, 470*NewScale, 215*NewScale, tocolor(0, 0, 0, 170))
	dxDrawBorderedText(Text("Итоги"), 500*scalex, 780*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*4, "default-bold", "left", "top")
	
	dxDrawRectangle(975*scalex, 810*scaley, 470*NewScale, 215*NewScale, tocolor(0, 0, 0, 170))
	dxSetBlendMode("blend")

	VideoMemory["HUD"]["WantedBackground"] = dxCreateRenderTarget(dxGetTextWidth("★★★★★★", NewScale*2, "pricedown", false), dxGetFontHeight(NewScale*2, "pricedown"), true)
	dxSetRenderTarget(VideoMemory["HUD"]["WantedBackground"], true)
	dxSetBlendMode("modulate_add")
	dxDrawBorderedText("★★★★★★", 0, 0, 0, 0, tocolor(40,40,40,200), NewScale*2, "pricedown", "left", "top")
	dxSetBlendMode("blend")
	
	VideoMemory["HUD"]["Cinema"] = dxCreateRenderTarget(screenWidth, screenHeight, true)
	dxSetRenderTarget(VideoMemory["HUD"]["Cinema"], true)
	dxSetBlendMode("modulate_add")
	dxDrawRectangle(0,0,screenWidth, screenHeight/9, tocolor(0,0,0,255))
	dxDrawRectangle(0,screenHeight-(screenHeight/9),screenWidth, screenHeight/9, tocolor(0,0,0,255))
	dxSetBlendMode("blend")

	dxSetRenderTarget()
	return true
end


	
local SoundsTheme = {
	[1] = "http://109.227.228.4/engine/include/MTA/music/Blue-In-Green.mp3", 
	[2] = "http://109.227.228.4/engine/include/MTA/music/Autumn-Leaves.mp3",
	[3] = "http://109.227.228.4/engine/include/MTA/music/Almost-blue.mp3", 
	[4] = "http://109.227.228.4/engine/include/MTA/music/GTA3.mp3", 
	
}

function StartLoad() -- Первый этап загрузки
	setTime(12, 0)
	setWeather(0)
	setFogDistance(300)
	setFarClipDistance(300)
	setMinuteDuration(10000000)
	
	local LangCode = getLocalization()["code"]
	local Lang = {
		["ru"] = "Ru_ru.po", 
		["en_US"] = "Ru_en.po", 
		["az"] = "Ru_az.po", 
	}

	if(not Lang[LangCode]) then
		LangCode = "ru"
	end
	local hFile = fileOpen("lang/"..Lang[LangCode], true)

	local ft = fileRead(hFile, 5500)
	while not fileIsEOF(hFile) do
		ft = ft .. fileRead(hFile, 5500)
	end
	
	ft = string.gsub(ft, 'msgid ""\n', 'msgid ')
	ft = string.gsub(ft, 'msgstr ""\n', 'msgstr ')
	ft = string.gsub(ft, '"\n"', '')
	LangArr = {}
	local Lines = split(ft, "\n")
	for i = 1, #Lines do
		if(string.sub(Lines[i], 0, 5) == "msgid") then
			LangArr[string.sub(Lines[i], 8, #Lines[i]-1)] = string.sub(Lines[i+1], 9, #Lines[i+1]-1)
		end
	end
	fileClose(hFile)
	
	if(HUDPreload()) then
		PEDChangeSkin = "intro"

		showChat(true)
		fadeCamera(true, 2.0)
		SetPlayerHudComponentVisible("all", false)

		LoginClient(true)

		GTASound = playSound(SoundsTheme[math.random(#SoundsTheme)], true)
		setSoundVolume(GTASound, 0.5)
	end
end

function displayLoadedRes(res)
	if(getResourceName(res) == "228") then
		if(getPlayerCity(localPlayer) == "San Andreas") then
			local col = engineLoadCOL("models/des_a51infenc.col")
			engineReplaceCOL(col, 16094)
			local dff = engineLoadDFF("models/des_a51infenc.dff")
			engineReplaceModel(dff, 16094)
			
			
			col = engineLoadCOL("models/des_a51_labs.col")
			engineReplaceCOL(col, 16639)
			
			col = engineLoadCOL("models/prison-gates.col")
			engineReplaceCOL(col, 14883)
			dff = engineLoadDFF("models/prison-gates.dff")
			engineReplaceModel(dff, 14883)
			
			col = engineLoadCOL("models/kb_tr_main.col")
			engineReplaceCOL(col, 14385)
			col = engineLoadCOL("models/trukstp01.col")
			engineReplaceCOL(col, 14655)
			col = engineLoadCOL("models/bdupsnew.col")
			engineReplaceCOL(col, 14803)
			col = engineLoadCOL("models/mc_straps_int.col")
			engineReplaceCOL(col, 14821)
			col = engineLoadCOL("models/kylie_barn.col")
			engineReplaceCOL(col, 14871)
			col = engineLoadCOL("models/bdups_main.col")
			engineReplaceCOL(col, 14801)
		end
		
		if(tonumber(getElementData(root, "ServerTime")) < 696902400) then
			txd = engineLoadTXD("models/copcarvg.txd")
			engineImportTXD(txd, 596)
			dff = engineLoadDFF("models/copcarvg.dff")
			engineReplaceModel(dff, 596)
			
			txd = engineLoadTXD("models/copcarvg.txd")
			engineImportTXD(txd, 597)
			dff = engineLoadDFF("models/copcarvg.dff")
			engineReplaceModel(dff, 597)
		end
		
		StartLoad()
	elseif(getResourceName(res) == "vehicle_node") then
		local x,y,z = getElementPosition(localPlayer)
		exports["vehicle_node"]:LoadZone(getPlayerCity(localPlayer), exports["ps2_weather"]:GetZoneName(x,y,z, false, getPlayerCity(localPlayer)))
	end
end
addEventHandler("onClientResourceStart", getRootElement(), displayLoadedRes)






function AuthComplete(CollectDat)
	local data = fromJSON(CollectDat)

	for model, dat in pairs(Collections) do
		for zone, dat2 in pairs(dat) do
			for i, v in pairs(dat2) do
				if(not data[tostring(model)][tostring(i)]) then
					Collections[model][zone][i] = createPickup(v[1],v[2],v[3], 3, model, 0)
					setElementData(Collections[model][zone][i], "id", i)
				end
			end
		end
	end


	PText["INVHUD"][10] = nil
	PText["INVHUD"][11] = nil
	PText["INVHUD"][12] = nil
	PText["INVHUD"][13] = nil
	PText["INVHUD"][14] = nil
	
	
	call(getResourceFromName("Draw_Intro"), "StopIntro")
end
addEvent("AuthComplete", true)
addEventHandler("AuthComplete", localPlayer, AuthComplete)






function CallPhoneInput()
	triggerEvent("CreateButtonInputInt", localPlayer, "CallPhoneOutput", "Введи номер или ИД игрока")
end
addEvent("CallPhoneInput", true)
addEventHandler("CallPhoneInput", localPlayer, CallPhoneInput)




function UpdTarget() targetingActivated(getPedTarget(localPlayer)) end
addEvent("UpdTarget", true)
addEventHandler("UpdTarget", localPlayer, UpdTarget)





function stopVehicleEntry(thePlayer, seat, door)
	if(getVehiclePlateText(source) == "SELL 228") then
		setVehicleLocked(source, true)
	elseif(getElementData(source, "owner")) then
		if(getElementData(source, "owner") ~= getPlayerName(thePlayer)) then
			setVehicleLocked(source, true)
		else
			setVehicleLocked(source, false)		
		end
	end
end
addEventHandler("onClientVehicleStartEnter",getRootElement(),stopVehicleEntry)








function CreateBlip(x, y, z, icon, size, r, g, b, a, ordering, visibleDistance, info)
	createBlip(x, y, z, icon, size, r, g, b, a, ordering, visibleDistance)
	--PData['blip'][#PData['blip']+1] = createBlip(x, y, z, icon, size, r, g, b, a, ordering, visibleDistance)
	--setElementData(PData['blip'][#PData['blip']], 'info', Text(info))
	--return PData['blip'][#PData['blip']]
end



CreateBlip(2071, -1794, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(824, -1588, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(672, -496, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(2080, 2123, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(-1450, 2592, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(-2571, 246, 0, 7, 0, 0, 0, 0, 0, 0, 300, "Парикмахерская")
CreateBlip(2067, -1780, 0, 39, 0, 0, 0, 0, 0, 0, 300, "Тату салон")
CreateBlip(2095, 2123, 0, 39, 0, 0, 0, 0, 0, 0, 300, "Тату салон")
CreateBlip(-2491, -39, 0, 39, 0, 0, 0, 0, 0, 0, 300, "Тату салон")
CreateBlip(648, 873, 0, 11, 0, 0, 0, 0, 0, 0, 300, "Карьер «Hunter Quarry»")
CreateBlip(-1857, -1680, 0, 11, 0, 0, 0, 0, 0, 0, 300, "Свалка Angel Pine")
CreateBlip(1642, -2286, 0, 5, 0, 0, 0, 0, 0, 0, 300, "Аэропорт Los Santos")
CreateBlip(-1409, -298, 0, 5, 0, 0, 0, 0, 0, 0, 300, "Аэропорт San Fierro")
CreateBlip(1672, 1448, 0, 5, 0, 0, 0, 0, 0, 0, 300, "Аэропорт Las Venturas")
CreateBlip(1742, -1458, 0, 20, 0, 0, 0, 0, 0, 0, 300, "Пожарная станция Los Santos")
CreateBlip(-2026, 84, 0, 20, 0, 0, 0, 0, 0, 0, 300, "Пожарная станция San Fierro")
CreateBlip(1760, 2081, 0, 20, 0, 0, 0, 0, 0, 0, 300, "Пожарная станция Las Venturas №3")
CreateBlip(-52, -1131, 0, 51, 0, 0, 0, 0, 0, 0, 300, "База грузоперевозок")
CreateBlip(-330, 2671, 0, 51, 0, 0, 0, 0, 0, 0, 300, "Pecker's Feed & Seed")
CreateBlip(1096, 1902, 0, 51, 0, 0, 0, 0, 0, 0, 300, "База грузоперевозок")
CreateBlip(261, 1410, 0, 51, 0, 0, 0, 0, 0, 0, 300, "НПЗ «Green Palms»")
CreateBlip(-1035, -614, 0, 51, 0, 0, 0, 0, 0, 0, 300, "Easter Bay Chemicals")
CreateBlip(1760, -2056, 0, 51, 0, 0, 0, 0, 0, 0, 300, "База грузоперевозок")
CreateBlip(1676, 2325, 0, 51, 0, 0, 0, 0, 0, 0, 300, "Склад «Redsands West»")
CreateBlip(2390, 2760, 0, 51, 0, 0, 0, 0, 0, 0, 300, "База грузоперевозок")
CreateBlip(2220, -1721, 0, 54, 0, 0, 0, 0, 0, 0, 300, "Тренажерный зал")
CreateBlip(-2271, -156, 0, 54, 0, 0, 0, 0, 0, 0, 300, "Тренажерный зал")
CreateBlip(1969, 2296, 0, 54, 0, 0, 0, 0, 0, 0, 300, "Тренажерный зал")
CreateBlip(-2026, -102, 0, 36, 0, 0, 0, 0, 0, 0, 300, "Автошкола")
CreateBlip(-2624, 1412, 0, 23, 0, 0, 0, 0, 0, 0, 300, "Синдикат локо")
CreateBlip(-217, 979, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Шериф округа Bone County")
CreateBlip(-1395, 2642, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Шериф El Quebrados")
CreateBlip(-2161, -2384, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Шериф Angel Pine")
CreateBlip(626, -571, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Шериф округа Red County")
CreateBlip(1555, -1675, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Полицейский участок Los Santos")
CreateBlip(2297, 2459, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Полицейский участок Las Venturas")
CreateBlip(-1581, 719, 0, 30, 0, 0, 0, 0, 0, 0, 300, "Полицейский участок San Fierro")
CreateBlip(1481, -1772, 0, 19, 0, 0, 0, 0, 0, 0, 300, "Мэрия Los Santos")
CreateBlip(-2766, 375, 0, 19, 0, 0, 0, 0, 0, 0, 300, "Мэрия San Fierro")
CreateBlip(2389, 2466, 0, 19, 0, 0, 0, 0, 0, 0, 300, "Мэрия Las Venturas")
CreateBlip(-1420, 2583, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(-99, 1117, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(2064, -1831, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(1024, -1023, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(487, -1739, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(-1904, 283, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(-2425, 1021, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(1974, 2162, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(720, -456, 0, 63, 0, 0, 0, 0, 0, 0, 300, "Pay 'n' Spray")
CreateBlip(-1957, 276, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон «Wang Cars»")
CreateBlip(-1657, 1212, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(520, 2372, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(1943, 2068, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(2200, 1389, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(553, -1279, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(2127, -1139, 0, 55, 0, 0, 0, 0, 0, 0, 300, "Автосалон")
CreateBlip(701, -519,  0, 55, 0, 0, 0, 0, 0, 0, 300, "Мотосалон «Dillmore»")
CreateBlip(2693, -1706, 0, 33, 0, 0, 0, 0, 0, 0, 300, "Стадион LS")
CreateBlip(1097, 1598,  0, 33, 0, 0, 0, 0, 0, 0, 300, "Стадион LV")
CreateBlip(-1514, 2518, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Больница")
CreateBlip(-320, 1048, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Медицинский центр Fort Caston")
CreateBlip(1607, 1815, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Госпиталь Las Venturas")
CreateBlip(1172, -1323, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Больница")
CreateBlip(2034, -1401, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Больница")
CreateBlip(1225, 313, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Больница")
CreateBlip(-2204, -2309, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Больница")
CreateBlip(-2655, 640, 0, 22, 0, 0, 0, 0, 0, 0, 300, "Медицинский центр San Fierro")
CreateBlip(2644, -2044, 0, 27, 0, 0, 0, 0, 0, 0, 300, "Тюнинг")
CreateBlip(1041, -1015, 0, 27, 0, 0, 0, 0, 0, 0, 300, "TransFender")
CreateBlip(-1935, 246, 0, 27, 0, 0, 0, 0, 0, 0, 300, "TransFender")
CreateBlip(2386, 1052, 0, 27, 0, 0, 0, 0, 0, 0, 300, "Тюнинг")
CreateBlip(-2721, 217, 0, 27, 0, 0, 0, 0, 0, 0, 300, "Wheel Arch Angels")
CreateBlip(-1213, 1830, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(172, 1176, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2397, -1899, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(928, -1352, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(928, -1352, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2420, -1508, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2393, 2041, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2638, 1671, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2838, 2407, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2101, 2228, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(-2672, 258, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(-2155, -2460, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(-1816, 618, 0, 14, 0, 0, 0, 0, 0, 0, 300, "Cluckin' Bell")
CreateBlip(2105, -1806, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2331, 75, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(1367, 248, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(-1721, 1359, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2638, 1849, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2541, 2148, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2351, 2533, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2083, 2224, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(-1808, 945, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(203, -202, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(2756, 2477, 0, 29, 0, 0, 0, 0, 0, 0, 300, "The Well Stacked Pizza Co.")
CreateBlip(810, -1616, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(1199, -918, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(-2336, -166, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(-1912, 827, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(-2355, 1008, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(2169, 2795, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(1157, 2072, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(2472, 2034, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(1872, 2071, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(2367, 2071, 0, 10, 0, 0, 0, 0, 0, 0, 300, "Burger Shot")
CreateBlip(1836, -1682, 0, 48, 0, 0, 0, 0, 0, 0, 300, "Клуб")
CreateBlip(2507, 1242, 0, 48, 0, 0, 0, 0, 0, 0, 300, "Клуб")
CreateBlip(387, -1817, 0, 50, 0, 0, 0, 0, 0, 0, 300, "Закусочная")
CreateBlip(24, -2646, 0, 50, 0, 0, 0, 0, 0, 0, 300, "Закусочная")
CreateBlip(-384, 2206, 0, 50, 0, 0, 0, 0, 0, 0, 300, "Закусочная")
CreateBlip(-53, 1188, 0, 50, 0, 0, 0, 0, 0, 0, 300, "Закусочная")
CreateBlip(875, -968, 0, 17, 0, 0, 0, 0, 0, 0, 300, "Ресторан")
CreateBlip(-2524, 1216, 0, 17, 0, 0, 0, 0, 0, 0, 300, "Ресторан")
CreateBlip(-1942, 2379, 0, 17, 0, 0, 0, 0, 0, 0, 300, "Ресторан")
CreateBlip(-858, 1535, 0, 17, 0, 0, 0, 0, 0, 0, 300, "Ресторан")
CreateBlip(-187, 1210, 0, 17, 0, 0, 0, 0, 0, 0, 300, "Ресторан")
CreateBlip(2244, -1665, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Binco")
CreateBlip(-2373, 910, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Binco")
CreateBlip(2101, 2257, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Binco")
CreateBlip(1657, 1733, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Binco")
CreateBlip(-1882, 866, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Zip")
CreateBlip(2090, 2224, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Zip")
CreateBlip(1456, -1137, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Zip")
CreateBlip(2572, 1904, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Zip")
CreateBlip(461, -1500, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Victim")
CreateBlip(2803, 2430, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Victim")
CreateBlip(454, -1478, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Didier Sachs")
CreateBlip(2112, -1211, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Sub Urban")
CreateBlip(-2489, -29, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Sub Urban")
CreateBlip(2779, 2453, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Sub Urban")
CreateBlip(823, -1757, 0, 45, 0, 0, 0, 0, 0, 0, 300, "BOBO")
CreateBlip(499, -1360, 0, 45, 0, 0, 0, 0, 0, 0, 300, "ProLaps")
CreateBlip(-2492, 2363, 0, 45, 0, 0, 0, 0, 0, 0, 300, "ProLaps")
CreateBlip(2826, 2407, 0, 45, 0, 0, 0, 0, 0, 0, 300, "ProLaps")
CreateBlip(-1694, 951, 0, 45, 0, 0, 0, 0, 0, 0, 300, "Victim")
CreateBlip(-179, 1133, 0, 52, 0, 0, 0, 0, 0, 0, 300, "Банк")
CreateBlip(-2456, 503, 0, 52, 0, 0, 0, 0, 0, 0, 300, "Банк")
CreateBlip(-828, 1504, 0, 52, 0, 0, 0, 0, 0, 0, 300, "Банк")
CreateBlip(2447, 2376, 0, 52, 0, 0, 0, 0, 0, 0, 300, "Банк")
CreateBlip(593, -1251, 0, 52, 0, 0, 0, 0, 0, 0, 300, "Credit and Commerce Bank of San Andreas")
CreateBlip(1368, -1279, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(2400, -1981, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(-1508, 2610, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(2159, 943, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(776, 1871, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(-316, 829, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(-2626, 208, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(2333, 61, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(-2093, -2464, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(2539, 2083, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(243, -178, 0, 6, 0, 0, 0, 0, 0, 0, 300, "Ammu-Nation")
CreateBlip(-179, 1087, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Attica Bar")
CreateBlip(2310, -1643, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Ten Green Bottle")
CreateBlip(1945, -2042, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Attica Bar")
CreateBlip(2441, -1376, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Attica Bar")
CreateBlip(2460, -1344, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Attica Bar")
CreateBlip(2361, -1332, 0, 49, 0, 0, 0, 0, 0, 0, 300, "Attica Bar")
CreateBlip(2441, 2065, 0, 49, 0, 0, 0, 0, 0, 0, 300, "The Craw Bar")




function onClientColShapeHit(theElement, matchingDimension)
	if(not matchingDimension) then return false end
	if getElementType(theElement) == "player" then 
		if(theElement == localPlayer) then
			if(getPedOccupiedVehicle(localPlayer)) then return false end
			if(getElementData(source, "type")) then
				if(getElementData(source, "type") == "GEnter") then
					ToolTip(Text("Нажми {key} чтобы войти", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}}))
					triggerServerEvent("GarageColEnter", localPlayer, localPlayer, source)
					
					if(getElementData(source, "owner") == getPlayerName(localPlayer)) then
						if(getElementData(source, "locked") == 1) then
							helpmessage(Text("Нажми {key} чтобы открыть гараж", {{"{key}", COLOR["KEY"]["HEX"].."F3#FFFFFF"}}))
						else
							helpmessage(Text("Нажми {key} чтобы закрыть гараж", {{"{key}", COLOR["KEY"]["HEX"].."F3#FFFFFF"}}))
						end
					end
				elseif(getElementData(source, "type") == "GExit") then
					ToolTip(Text("Нажми {key} чтобы выйти", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}}))
					triggerServerEvent("GarageColEnter", localPlayer, localPlayer, source)
				end
			elseif(getElementData(source, "Three")) then
				triggerServerEvent("ThreeColEnter", localPlayer, localPlayer, source)
			elseif(getElementData(source, "vending")) then
				toggleControl("enter_exit", false) 
				ToolTip(Text("Sprunk стоимость #3B7231$20#FFFFFF").."\n"..Text("Нажми {key} чтобы купить", {{"{key}", COLOR["KEY"]["HEX"].."F#FFFFFF"}}))
				
				triggerServerEvent("VendingColEnter", localPlayer, localPlayer, source)
			end
		end
	elseif getElementType(theElement) == "vehicle" then 
		if(theElement == getPedOccupiedVehicle(localPlayer)) then
			if(getElementData(source, "type")) then
				if(getElementData(source, "type") == "PetrolFuelCol") then
					ToolTip(Text("Нажми {key} чтобы заправиться", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}}))
					triggerServerEvent("PetrolFuelColEnter", localPlayer, localPlayer, source)
				elseif(getElementData(source, "type") == "GEnter") then
					ToolTip(Text("Нажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы\nзаехать в гараж"))
					triggerServerEvent("GarageColEnter", localPlayer, localPlayer, source)
				elseif(getElementData(source, "type") == "GExit") then
					ToolTip("Нажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы\nвыехать из гаража")
					triggerServerEvent("GarageColEnter", localPlayer, localPlayer, source)
				end
			elseif(getElementData(source, "Three")) then
				if(getElementModel(theElement) == 532) then
					triggerServerEvent("HarvestThree", localPlayer, localPlayer, source, true)
				end
			end
		end
	end	
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit)





function onClientColShapeLeave(thePlayer, matchingDimension)
	if(not matchingDimension) then return false end
	if getElementType(thePlayer) == "player" then 
		if(thePlayer == localPlayer) then
			if(getElementData(source, "vending")) then
				if(not getPedOccupiedVehicle(localPlayer)) then
					toggleControl("enter_exit", true) 
				end
			end
		end
	end	
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave)




function RespectMessage(group, count) 
	if(PData["wasted"]) then
		SpawnAction[#SpawnAction+1] = {"RespectMessage", localPlayer, group, count}
	else
		count = tonumber(count)
		group = tonumber(group)

		if(SkillLevel[group]) then
			for slot = getPedStat(localPlayer, group)+1, getPedStat(localPlayer, group)+count do
				 if SkillLevel[group][slot] then
					ToolTip(SkillLevel[group][slot])
				 end
			end
		end
					
					
		if(isTimer(RespectTempFileTimers)) then
			if(not RespectMsg[group]) then
				RespectMsg[group] = count
			else
				RespectMsg[group] = RespectMsg[group]+count
			end
			resetTimer(RespectTempFileTimers)
		else
			RespectMsg = {[group] = count}
			RespectTempFileTimers = setTimer(function()
				RespectMsg = false
			end, 3500, 1)
			PlaySFXSound(14)
		end
	end
end
addEvent("RespectMessage", true)
addEventHandler("RespectMessage", localPlayer, RespectMessage)



function helpmessage(message)
	if(isTimer(PData["helpmessageTimer"])) then
		killTimer(PData["helpmessageTimer"])
	end
	
	PData["helpmessage"] = message

	PData["helpmessageTimer"] = setTimer(function()
		PData["helpmessage"] = nil
	end, 3500, 1)
end
addEvent("helpmessageEvent", true)
addEventHandler("helpmessageEvent", localPlayer, helpmessage)




function MissionCompleted(job, money, removetarget, cinema)
	if(removetarget) then
		Targets["thePlayer"] = nil
	end
	if(isTimer(PData["MissionCompletedTimer"])) then
		killTimer(PData["MissionCompletedTimer"])
	end
	
	
	if(job) then
		PText["HUD"][6] = {"#744D02"..Text(job), screenWidth, screenHeight/2-dxGetFontHeight(NewScale*6, "sans")/2, 0, 0, tocolor(255, 255, 255, 255), NewScale*6, "sans", "center", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}
	end
	
	if(money) then
		if(tonumber(money)) then
			PText["HUD"][7] = {"$"..money, screenWidth, screenHeight/2+(dxGetFontHeight(NewScale*4, "pricedown")/2), 0, 0, tocolor(255, 255, 255, 255), NewScale*4, "pricedown", "center", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}	
		else
			PText["HUD"][7] = {money, screenWidth, screenHeight/2+(dxGetFontHeight(NewScale*6, "sans")/2), 0, 0, tocolor(255, 255, 255, 255), NewScale*6, "sans", "center", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}	
		end
	end
	
	PData["MissionCompletedTimer"] = setTimer(function()
		PText["HUD"][6] = nil
		PText["HUD"][7] = nil
	end, 3500, 1)
	
	if(cinema) then
		cinema = fromJSON(cinema)
		playSFX("genrl", 75, 1, false)
		local x,y,z = getElementPosition(localPlayer)
		LookHouse(cinema[1])
		PEDChangeSkin = "cinema"
		setTimer(function(thePlayer)
			setCameraTarget(localPlayer)
			PEDChangeSkin = "play"
		end, 3500, 1)
	end
end
addEvent("MissionCompleted", true)
addEventHandler("MissionCompleted", localPlayer, MissionCompleted)


function ToolTip(message)
	if(message ~= ToolTipText) then
		playSoundFrontEnd(11)
		if(isTimer(ToolTipTimers)) then
			killTimer(ToolTipTimers)
			ToolTipText = message
			ToolTipTimers = setTimer(function()
				ToolTipText = ""
			end, 1000+(#message*50), 1)
		else
			ToolTipText = message
			ToolTipTimers = setTimer(function()
				ToolTipText = ""
			end, 1000+(#message*50), 1)
		end
	end
end
addEvent("ToolTip", true)
addEventHandler("ToolTip", root, ToolTip)




function CallPoliceEvent()
	triggerServerEvent("CallPolice", localPlayer, CallPolice)
end


function PoliceArrestEvent()
	if(not isTimer(ArrestTimerEvent)) then
		if(Targets["theVehicle"]) then 
			triggerServerEvent("PoliceArrestCar", localPlayer)
		end
		ArrestTimerEvent=setTimer(function() end, 4000, 1)
	end
end




function TrunkReq(arg)
	triggerServerEvent("TrunkOpen", localPlayer, localPlayer, Targets["theVehicle"]) 
end
addEvent("TrunkReq", true)
addEventHandler("TrunkReq", localPlayer, TrunkReq)



function CarJack()
	triggerServerEvent("RemovePedFromVehicle", localPlayer, getVehicleOccupant(Targets["theVehicle"]), localPlayer) 
end
addEvent("CarJack", true)
addEventHandler("CarJack", localPlayer, CarJack)


function PedDialog()
	triggerServerEvent("PedDialog", localPlayer, localPlayer, Targets["thePlayer"] or Targets["thePed"])
end
addEvent("PedDialog", true)
addEventHandler("PedDialog", localPlayer, PedDialog)







function PrisonSleepEv()
	local x,y, _ = getElementPosition(localPlayer)
	local x2,y2,_ = getElementPosition(PrisonSleep)
	local Dist = getDistanceBetweenPoints2D(x,y,x2,y2)

	if(Dist < 3 and not isTimer(SleepTimer)) then
		local x,y,z = getElementPosition(PrisonSleep)
		local rx,ry,rz = getElementRotation(PrisonSleep)
		triggerServerEvent("PrisonSleep", localPlayer, x,y,z,rz)
		fadeCamera(false, 4.0, 0, 0, 0)
		bindKey("space", "down", StopSleep)
		
		
		SleepTimer = setTimer(function()
			SleepSound("script",  39, math.random(0,114), false)
		end, 5000, 0)
		
		PText["HUD"][2] = {Text("Нажми {key} чтобы встать", {{"{key}", COLOR["KEY"]["HEX"].."Space#FFFFFF"}}), screenWidth, screenHeight-(150*scalex), 0, 0, tocolor(255, 255, 255, 255), scale*2, "sans", "center", "top", false, false, false, true, true, 0, 0, 0, {}}
	else
		unbindKey("e", "down", PrisonSleepEv) 
		PrisonSleep = false
	end
end

function PrisonGavnoEv()
	local ox,oy,oz = getElementPosition(PrisonGavno)
	local rx,ry,rz = getElementRotation(PrisonGavno)
	local px,py,pz = getElementPosition(localPlayer)
	local x,y,z = getPointInFrontOfPoint(ox,oy,oz+1,rz-90,0.8)
	if(getDistanceBetweenPoints2D(ox,oy, px, py) < 2) then
		triggerServerEvent("PrisonGavno", localPlayer, x,y,z,rz)
	end
end

function PrisonPiss() triggerServerEvent("PrisonPiss", localPlayer, localPlayer) end


function SleepSound(bank,id,id2)
	local sound = playSFX(bank, id, id2, false)
	setSoundEffectEnabled (sound, "reverb", true)
end

function StopSleep()
	fadeCamera(true, 4.0, 0, 0, 0)
	killTimer(SleepTimer)
	unbindKey("space", "down", StopSleep)
	triggerServerEvent("PrisonSleep", localPlayer)
	PText["HUD"][2] = nil
end





local effectNames = {"blood_heli","boat_prop","camflash","carwashspray","cement","cloudfast","coke_puff","coke_trail","cigarette_smoke",
"explosion_barrel","explosion_crate","explosion_door","exhale","explosion_fuel_car","explosion_large","explosion_medium",
"explosion_molotov","explosion_small","explosion_tiny","extinguisher","flame","fire","fire_med","fire_large","flamethrower",
"fire_bike","fire_car","gunflash","gunsmoke","insects","heli_dust","jetpack","jetthrust","nitro","molotov_flame",
"overheat_car","overheat_car_electric","prt_blood","prt_boatsplash","prt_bubble","prt_cardebris","prt_collisionsmoke",
"prt_glass","prt_gunshell","prt_sand","prt_sand2","prt_smokeII_3_expand","prt_smoke_huge","prt_spark","prt_spark_2",
"prt_splash","prt_wake","prt_watersplash","prt_wheeldirt","petrolcan","puke","riot_smoke","spraycan","smoke30lit","smoke30m",
"smoke50lit","shootlight","smoke_flare","tank_fire","teargas","teargasAD","tree_hit_fir","tree_hit_palm","vent","vent2",
"water_hydrant","water_ripples","water_speed","water_splash","water_splash_big","water_splsh_sml","water_swim","waterfall_end",
"water_fnt_tme","water_fountain","wallbust","WS_factorysmoke"}



local o = createObject(2525, 262.9, 79, 1000, 0,0,90)
setElementInterior(o, 6)
setElementDimension(o, 1)

o = createObject(2525, 317.25, 317.2, 998.12, 0,0,30)
setElementInterior(o, 5)
setElementDimension(o, 1)

o = createObject(2525, 317.25, 317.2, 998.12, 0,0,30)
setElementInterior(o, 5)
setElementDimension(o, 2)

o = createObject(2525, 317.25, 317.2, 998.12, 0,0,30)
setElementInterior(o, 5)
setElementDimension(o, 3)

o = createObject(2525, 317.25, 317.2, 998.12, 0,0,30)
setElementInterior(o, 5)
setElementDimension(o, 4)

o = createObject(2525, 218.4, 107.6, 997.9, 0,0,180)
setElementInterior(o, 10)
setElementDimension(o, 1)

o = createObject(2525, 192.8, 173, 1002, 0,0,180)
setElementInterior(o, 3)
setElementDimension(o, 1)


DrugsEffect = {}
DrugsAnimation = {"PLY_CASH","PUN_CASH","PUN_HOLLER","PUN_LOOP","strip_A","strip_B","strip_C","strip_D","strip_E","strip_F","strip_G","STR_A2B","STR_B2A","STR_B2C","STR_C1","STR_C2", "STR_C2B", "STR_Loop_A","STR_Loop_B","STR_Loop_C"}
function targetingActivated(target)
	if(PEDChangeSkin == "play") then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		local PTeam = getTeamName(getPlayerTeam(localPlayer))
		if(isTimer(SpunkTimer)) then
			local x,y,z = getElementPosition(target)
			local ground = getGroundPosition(x, y, z)
			DrugsEffect[#DrugsEffect+1] = createEffect(effectNames[math.random(1,#effectNames)],x,y,z)
			DrugsEffect[#DrugsEffect+1] = createPed(math.random(0,299),x+math.random(-10,10),y+math.random(-10,10), ground+0.5, math.random(0,360))
			setElementInterior(DrugsEffect[#DrugsEffect], getElementInterior(localPlayer))
			setElementDimension(DrugsEffect[#DrugsEffect], getElementDimension(localPlayer))
			StartAnimation(DrugsEffect[#DrugsEffect], "STRIP", DrugsAnimation[math.random(1,#DrugsAnimation)])
			local rand = math.random(0,10)
			if(rand == 0) then 
				setPedHeadless(DrugsEffect[#DrugsEffect],true)
			end
		end

		if(CallPolice) then
			CallPolice = false
			unbindKey ("F3", "down", CallPoliceEvent) 
		end


	
		for name, _ in pairs(Targets) do
			if(name == "theVehicle") then
				if(PTeam == "Полиция") then
					unbindKey("e", "down", PoliceArrestEvent)
				end
			end
			Targets[name] = nil
		end
		
		
		
		if(PrisonGavno) then
			PrisonGavno = false
			unbindKey("e", "down", PrisonGavnoEv)
			unbindKey("f", "down", PrisonPiss)
		end
		
		if (target) then
			if(tostring(getElementType(target)) == "player") then
				Targets["thePlayer"] = target
				if(PTeam == "Мирные жители" or PTeam == "МЧС" and PTeam ~= "Полиция") then
					if(getElementData(target, "WantedLevel") ~= 0) then
						bindKey ("F3", "down", CallPoliceEvent)
						CallPolice=getPlayerName(target)
					end
				end

				local x, y, z = getElementPosition(localPlayer)
				local x2, y2, z2 = getElementPosition(target)
				local distance = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
				local message=""
				if(CallPolice) then
					message = message.."Нажми #A0A0A0F3#FFFFFF чтобы позвонить в полицию\n"	
				end
				ChangeInfo(message, 5000)
			elseif(tostring(getElementType(target)) == "vehicle") then
				if(theVehicle) then
					if(theVehicle ~= target) then
						Targets["theVehicle"] = target
						if(PTeam == "Полиция") then
							bindKey ("e", "down", PoliceArrestEvent)
							if(getElementModel(theVehicle) == 596 or getElementModel(theVehicle) == 597 or getElementModel(theVehicle) == 598 or getElementModel(theVehicle) == 599 or getElementModel(theVehicle) == 523) then
								helpmessage("Нажми #A0A0A0E#FFFFFF чтобы\nпотребовать остановить автомобиль", 3000)
							end
						end
					end
				else
					if(not isPedDoingTask(localPlayer, "TASK_COMPLEX_ENTER_CAR_AS_DRIVER")
					and not isPedDoingTask(localPlayer, "TASK_COMPLEX_ENTER_CAR_AS_PASSENGER")) then
						Targets["theVehicle"] = target
					end
				end

				local t=""
				if(getVehiclePlateText(target) == "SELL 228") then
					t=t..Text("Нажми {key} чтобы купить", {{"{key}", COLOR["KEY"]["HEX"].."TAB#FFFFFF"}})
				end
				
				if(getElementData(target, "owner") == getPlayerName(localPlayer)) then
					if(getElementData(target, "siren")) then
						t=t.."\nНажми #A0A0A0ALT#FFFFFF чтобы управлять сигнализацией"
					end
				end
				ChangeInfo(t, 5000)
			elseif(tostring(getElementType(target)) == "object") then
				if(getElementModel(target) == 1812) then
					ToolTip(Text("Нажми {key} чтобы лечь", {{"{key}", COLOR["KEY"]["HEX"].."F#FFFFFF"}}))
					PrisonSleep = target
					bindKey("f", "down", PrisonSleepEv)
				elseif(getElementModel(target) == 2525) then
					ChangeInfo("Нажми #A0A0A0F#FFFFFF чтобы справить нужду\nНажми #A0A0A0E#FFFFFF чтобы чистить говно", 5000)
					PrisonGavno = target
					bindKey ("e", "down", PrisonGavnoEv)
					bindKey ("f", "down", PrisonPiss)
				end
			elseif(tostring(getElementType(target)) == "ped") then
				if(getElementData(target, "team")) then
					local team=getElementData(target, "team")
					color=getTeamVariable(team)
					if(team == getTeamName(getPlayerTeam(localPlayer))) then
						ChangeInfo("Нажми #A0A0A0P #FFFFFFчтобы пригласить в группу", 5000)
					end
				end
				Targets["thePed"] = target
			end
		else 
			if(not theVehicle) then ChangeInfo() end
		end
	end
end
addEventHandler("onClientPlayerTarget", getRootElement(), targetingActivated)


 


function getVehicleHandlingProperty(theVehicle, property)
    local HT = getVehicleHandling(theVehicle) 
	return HT[property]
end




function PlaySFX3DforAll(script, bank, id, x,y,z, loop, mindist, maxdist, effect, effectbool) 
	local s = playSFX3D(script, bank, id, x,y,z, loop)
	if(mindist) then
		setSoundMinDistance(s, mindist)
		setSoundMaxDistance(s, maxdist)
	end
	if(effect) then
		setSoundEffectEnabled(s, effect, effectbool)
	end
end
addEvent("PlaySFX3DforAll", true)
addEventHandler("PlaySFX3DforAll", localPlayer, PlaySFX3DforAll)


function PlaySFXClient(c,b,s)
	playSFX(c,b,s,false)
end
addEvent("PlaySFXClient", true)
addEventHandler("PlaySFXClient", localPlayer, PlaySFXClient)


function bloodfoot(thePlayer, bool) 
	if(isElement(thePlayer)) then
		setPedFootBloodEnabled(thePlayer, bool)
	end
end
addEvent("bloodfoot", true)
addEventHandler("bloodfoot", localPlayer, bloodfoot)




local imageTimer = false
addEvent("onMyClientScreenShot",true)
addEventHandler("onMyClientScreenShot", resourceRoot,
    function(pixels)
	if isTimer(imageTimer) then killTimer(imageTimer) end
		cameraimage = dxCreateTexture(pixels)
		playSFX("script", 75, 6, false)
		imageTimer = setTimer(function()
			destroyElement(cameraimage)
			cameraimage=false
		end, 10000, 1)
    end
)
 
 

local score = 0
local tick
local idleTime
local multTime
local mult = 1





function onClientChatMessageHandler(text)
	if(PEDChangeSkin == "play") then
		if string.find(text, "http?://[%w-_%.%?%.:/%+=&]+") then -- if string.match and text itself are the same
			local s, e = string.find(text, "http?://[%w-_%.%?%.:/%+=&]+")
			PData["WebLink"] = string.sub(text, s, e)
			ToolTip("В чат добавлена ссылка\nНажми F5 чтобы посмотреть")
		end
	end

end
addEventHandler("onClientChatMessage", getRootElement(), onClientChatMessageHandler)



function RemoveInventory()
	if(initializedInv) then
		initializedInv=false
		PBut["player"] = {}
	end
end










function DevelopmentRender()
	AddRage(5)
end








function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if 
		type(sEventName) == 'string' and 
		isElement(pElementAttachedTo) and 
		type(func) == 'function' 
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end



function ShowInfoKey()
	if(isEventHandlerAdded("onClientRender", root, DevelopmentRender)) then
		setDevelopmentMode(false)
		removeEventHandler("onClientRender", root, DevelopmentRender)
	else
		outputChatBox("Player model: "..getElementModel(localPlayer))
		local tar = getPedTarget(localPlayer)
		if(tar) then
			outputChatBox("Target model: "..getElementModel(tar))
			local modelname = getElementData(tar, "objname")
			if(modelname) then
				outputChatBox("model name: "..modelname)
				
				destroyElement(tar)
			end
		end
		
		local w, h = guiGetScreenSize ()
		local tx, ty, tz = getWorldFromScreenPosition ( w/2, h/2, 50 )
		local px, py, pz = getCameraMatrix()
		hit, x, y, z, _, _, _, _, _, _, _, modelid = processLineOfSight ( px, py, pz, tx, ty, tz, true, true, true, true, true, true, true, true, localPlayer, true, true)
		if modelid then
			outputChatBox("World model: "..modelid)
		end

		
		setDevelopmentMode(true)
		addEventHandler("onClientRender", root, DevelopmentRender)
		
		
		
		for _,name in ipairs(engineGetVisibleTextureNames("*")) do
			outputConsole(name)
		end

		--GPS(math.random(-3000,3000), math.random(-3000,3000), math.random(-3000,3000), "Случайная точка ")
	end
end
addEvent("ShowInfoKey", true)
addEventHandler("ShowInfoKey", localPlayer, ShowInfoKey)












function handsup()
	triggerServerEvent("handsup", localPlayer, localPlayer)	
end

function park()
	if(Targets["thePed"]) then
		triggerServerEvent("InviteBot", localPlayer, Targets["thePed"])
	else
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if(theVehicle) then
			if(getElementData(theVehicle, "owner") == getPlayerName(localPlayer) and not tuningList and VehicleSpeed < 1) then
				triggerServerEvent("ParkMyCar", localPlayer, theVehicle)
				setPedControlState(localPlayer, "enter_exit", true)
			end
		end
	end
end


local objectTypes = {
	[1524] = "Графити", 
    [1525] = "Графити",
	[1526] = "Графити",
	[1528] = "Графити",
	[1529] = "Графити",
	[1530] = "Графити",
	[1531] = "Графити"
}

function GetObjectType(obj)
	local model = getElementModel(obj)
	return objectTypes[model] or "Неизвестно"
end


function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if source == localPlayer then
		if(not hitElement) then
			local col = createObject(16635, hitX, hitY, hitZ)
			for _, v in pairs(getElementsByType("colshape", getRootElement(), true)) do
				if(isElementWithinColShape(col, v)) then
					hitElement = getElementAttachedTo(v)
				--	ToolTip("Графити")
				end
			end
			destroyElement(col)
		end
		
		if(weapon == 39) then
			 helpmessage("Используй ПКМ чтобы взорвать взрывчатку")
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, onClientPlayerWeaponFireFunc)





function SetupInventory()
	if(not initializedInv) then
		local StPosx = (screenWidth)-((80*NewScale)*10)
		local StPosxy = (screenHeight)-(80*NewScale)
		local binvx = 0
		local binvy = 0

		for i,val in pairs(PInv["player"]) do
			PBut["player"][i] = {StPosx+binvx, StPosxy+binvy, 80*NewScale, 60*NewScale}

			binvx = binvx+(80.5*NewScale)
		end
		
		initializedInv = true
	end
end
addEvent("SetupInventory", true)
addEventHandler("SetupInventory", localPlayer, SetupInventory)



local Cheatkeys = {}
local Cheats = {
	["hesoyam"] = true,
	["afzllqll"] = true,
	["icikpyh"] = true,
	["auifrvqs"] = true, 
	["mghxyrm"] = true, 
	["cfvfgmj"] = true, 
	["cwjxuoc"] = true, 
	["alnsfmzo"] = true, 
	["ysohnul"] = true,
	["ppgwjht"] = true, 
	["liyoaay"] = true, 
	["aezakmi"] = true,
	["ripazha"] = true,
	["jbgvnb"] = true,
	["lxgiwyl"] = true,
	["professionalskit"] = true,
	["kjkszpj"] = true,
	["uzumymw"] = true,
	["fullclip"] = true, 
	["wanrltw"] = true, 
	["ncsgdag"] = true, 
	["professionalkiller"] = true, 
	["aiwprton"] = true, 
	["cqzijmb"] = true, 
	["pdnejoh"] = true, 
	["vpjtqwv"] = true, 
	["aqtbcodx"] = true, 
	["krijebr"] = true, 
	["ubhyzhq"] = true, 
	["rzhsuew"] = true, 
	["akjjyglc"] = true, 
	["fourwheelfun"] = true, 
	["amomhrer"] = true, 
	["eegcyxt"] = true, 
	["agbdlcid"] = true, 
	["jqntdmh"] = true, 
	["jumpjet"] = true, 
	["ohdude"] = true, 
	["urkqsrk"] = true, 
	["kgggdkp"] = true, 
	["rocketman"] = true, 
	["yecgaa"] = true, 
	["aiypwzqp"] = true, 
	["vkypqcf"] = true, 
	["szcmawo"] = true,
	["cpktnwt"] = true,
	["jhjoecw"] = true,
	["ljspqk"] = true,
	["bringiton"] = true,
	["osrblhh"] = true,
	["turnuptheheat"] = true, 
	["asnaeb"] = true,
	["turndowntheheat"] = true, 
	["ogxsdag"] = true, 
	["worshipme"] = true, 
	["xjvsnaj"] = true, 
	["nightprowler"] = true, 
	["ofviac"] = true, 
}     


function CheatCode(code)
	if(getPlayerName(localPlayer) ~= "alexaxel705") then
		local rand = math.random(1,100)
		if(rand ~= 1) then
			ToolTip("Чит код не сработал")
			return false
		end
	end
	local x,y,z = getElementPosition(localPlayer)
	local zone = exports["ps2_weather"]:GetZoneName(x,y,z, true, getElementData(localPlayer, "City"))
	if(code == "hesoyam") then
		triggerServerEvent("hesoyam", localPlayer, localPlayer)
	elseif(code == "ofviac") then
		triggerServerEvent("ofviac", localPlayer, localPlayer)		
		triggerServerEvent("CheatWeather", localPlayer, zone, code)
	elseif(code == "xjvsnaj" or code == "nightprowler") then
		triggerServerEvent("nightprowler", localPlayer, localPlayer)
	elseif(code == "wanrltw" or code == "fullclip") then
		if(getElementData(localPlayer, "FullClip")) then
			triggerServerEvent("FullClip", localPlayer, localPlayer, false)
			ToolTip("Чит деактивирован")
			return true
		else
			triggerServerEvent("FullClip", localPlayer, localPlayer, true)
		end
	elseif(code == "ogxsdag" or code == "worshipme") then
		triggerServerEvent("Respect", localPlayer, localPlayer, "civilian", 1000)
		triggerServerEvent("Respect", localPlayer, localPlayer, "vagos", 1000)
		triggerServerEvent("Respect", localPlayer, localPlayer, "police", 1000)
		triggerServerEvent("Respect", localPlayer, localPlayer, "grove", 1000)
		triggerServerEvent("Respect", localPlayer, localPlayer, "ugol", 1000)
		triggerServerEvent("Respect", localPlayer, localPlayer, "ballas", 1000)
	elseif(code == "ljspqk" or code == "bringiton") then
		triggerServerEvent("WantedLevel", localPlayer, localPlayer, 6)
	elseif(code == "osrblhh" or code == "turnuptheheat") then
		triggerServerEvent("WantedLevel", localPlayer, localPlayer, 2)
	elseif(code == "asnaeb" or code == "turndowntheheat") then
		triggerServerEvent("WantedLevel", localPlayer, localPlayer, -6)
	elseif(code == "aezakmi") then
		triggerServerEvent("WantedLevel", localPlayer, localPlayer, "AEZAKMI")
		if(getElementData(localPlayer, "AEZAKMI")) then
			ToolTip("Чит деактивирован")
			return true
		end
	elseif(code == "cpktnwt") then
		for _, Vehicle in pairs(getElementsByType("vehicle", getRootElement(), true)) do
			local x,y,z = getElementPosition(Vehicle)
			createExplosion(x,y,z, 0, true)
		end
	elseif(code == "szcmawo") then
		triggerServerEvent("kill", localPlayer, localPlayer)
	elseif(code == "vkypqcf") then
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 22, 1000)
	elseif(code == "afzllqll" or
		   code == "icikpyh" or
		   code == "auifrvqs" or
		   code == "mghxyrm" or
		   code == "alnsfmzo" or
		   code == "cfvfgmj" or
		   code == "cwjxuoc") then
		triggerServerEvent("CheatWeather", localPlayer, zone, code)
	elseif(code == "ppgwjht") then
		triggerServerEvent("ppgwjht", localPlayer, localPlayer)
	elseif(code == "ysohnul") then
		if(getGameSpeed() == 2) then 
			ToolTip("Чит деактивирован") 
			setGameSpeed(1.2)
			return true 
		else
			setGameSpeed(2)
		end
	elseif(code == "liyoaay") then
		if(getGameSpeed() == 0.5) then 
			ToolTip("Чит деактивирован") 
			setGameSpeed(1.2)
			return true 
		else
			setGameSpeed(0.5)
		end
	elseif(code == "jhjoecw") then
		setWorldSpecialPropertyEnabled("extrabunny", not isWorldSpecialPropertyEnabled("extrabunny"))
		if(not isWorldSpecialPropertyEnabled("extrabunny")) then ToolTip("Чит деактивирован") return false end
	elseif(code == "ripazha") then
		setWorldSpecialPropertyEnabled("aircars", not isWorldSpecialPropertyEnabled("aircars"))
		if(not isWorldSpecialPropertyEnabled("aircars")) then ToolTip("Чит деактивирован") return false end
	elseif(code == "jbgvnb") then
		setWorldSpecialPropertyEnabled("hovercars", not isWorldSpecialPropertyEnabled("hovercars"))
		if(not isWorldSpecialPropertyEnabled("hovercars")) then ToolTip("Чит деактивирован") return false end
	elseif(code == "lxgiwyl") then
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Кастет", ["txd"] = "Кастет"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Бита", ["txd"] = "Бита"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Кольт 45", ["txd"] = "Кольт 45"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Mossberg", ["txd"] = "Mossberg"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Узи", ["txd"] = "Узи"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "АК-47", ["txd"] = "АК-47"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "ИЖ-12", ["txd"] = "ИЖ-12"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Базука", ["txd"] = "Базука"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Молотов", ["txd"] = "Молотов"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Спрей", ["txd"] = "Спрей"})
	elseif(code == "professionalskit" or code == "kjkszpj") then	
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Нож", ["txd"] = "Нож"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Deagle", ["txd"] = "Deagle"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Sawed-Off", ["txd"] = "Sawed-Off"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Tec-9", ["txd"] = "Tec-9"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "М16", ["txd"] = "М16"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "M40", ["txd"] = "M40"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Огнетушитель", ["txd"] = "Огнетушитель"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Огнемет", ["txd"] = "Огнемет"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Граната", ["txd"] = "Граната"})
	elseif(code == "uzumymw") then
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Бензопила", ["txd"] = "Бензопила"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "USP-S", ["txd"] = "USP-S"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "SPAS-12", ["txd"] = "SPAS-12"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "MP5", ["txd"] = "MP5"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Ракетная установка", ["txd"] = "Ракетная установка"})
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Взрывчатка", ["txd"] = "Взрывчатка"})
	elseif(code == "professionalkiller" or code == "ncsgdag") then	
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 177, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 69, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 70, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 71, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 72, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 73, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 74, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 75, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 76, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 77, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 78, 1000)
		triggerServerEvent("AddSkill", localPlayer, localPlayer, 79, 1000)
	elseif(code == "aiwprton") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 432, x, y, z)
	elseif(code == "cqzijmb") then
		local x,y,z = getElementPosition(localPlayer)
		triggerServerEvent("vpc", localPlayer, localPlayer, 504, x, y, z)
	elseif(code == "pdnejoh") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 494, x, y, z)
	elseif(code == "vpjtqwv") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 503, x, y, z)
	elseif(code == "aqtbcodx") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 442, x, y, z)
	elseif(code == "krijebr") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 409, x, y, z)
	elseif(code == "ubhyzhq") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 408, x, y, z)
	elseif(code == "rzhsuew") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 457, x, y, z)
	elseif(code == "akjjyglc" or code == "fourwheelfun") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 471, x, y, z)
	elseif(code == "amomhrer") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 514, x, y, z)
	elseif(code == "eegcyxt") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 486, x, y, z)
	elseif(code == "agbdlcid") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 556, x, y, z)
	elseif(code == "jqntdmh") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 489, x, y, z)
	elseif(code == "jumpjet") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 520, x, y, z)
	elseif(code == "ohdude") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 425, x, y, z)
	elseif(code == "urkqsrk") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 513, x, y, z)
	elseif(code == "kgggdkp") then
		triggerServerEvent("vpc", localPlayer, localPlayer, 539, x, y, z)
	elseif(code == "rocketman" or code == "yecgaa") then
		triggerServerEvent("rocketman", localPlayer, localPlayer)
		if(isPedWearingJetpack(localPlayer)) then
			ToolTip("Чит деактивирован")
			return true
		end
	elseif(code == "aiypwzqp") then
		triggerServerEvent("AddInventoryItem", localPlayer, localPlayer, {["name"] = "Парашют", ["txd"] = "Парашют"})
	end
	ToolTip("Чит активирован")
end



local StandartObjects = {
	[2956] = { -- #IMMMCRAN
		{2194.438, -1912.756, 11.907, 0,0,0}
	}, 
	[5678] = { -- #LAE_SMOKECUTSCENE
		{2055.0, -1695.0, 15.0, 0,0,0}, 
	}, 
	[2904] = { -- #WAREHOUSE_DOOR1
		{2799.75, -2405.394, 14.58, 0,0,0}, 
		{2799.75, -2430.215, 14.58, 0,0,0}, 
		{2799.75, -2443.487, 14.58, 0,0,0}, 
		{2799.75, -2468.254, 14.58, 0,0,0}, 
		{2799.75, -2481.711, 14.58, 0,0,0}, 
		{2799.75, -2506.313, 14.58, 0,0,0}, 
	}, 
	[3109] = { -- #IMY_LA_DOOR
		{2118.088, -2274.635, 20.867, 0,0,225.0}, 
	}, 
	[3061] = { -- #AD_FLATDOOR
		{1833.36, -1995.45, 13.2, 0,0,270}, 
		{1819.81, -1994.66, 13.2,0,0,0},  
		{1827.68, -1980.0, 13.2,0,0,270},  
		{1851.84, -1990.67, 13.2,0,0,0},  
		{1867.29, -1984.96, 13.2,0,0,270},  
		{1866.52, -1998.53, 13.2,0,0,90},  
		{1899.75, -1984.95, 13.2,0,0,270},  
		{1914.39, -1992.82, 13.2,0,0,180},  
		{1899.01, -1998.5, 13.2,0,0,90},  
		{1900.89, -2020.11, 13.2,0,0,0},  
		{1914.4, -2020.91, 13.2,0,0,180},  
		{1906.54, -2035.52, 13.2,0,0,90},  
		{1851.86, -2020.14, 13.2,0,0,0},  
		{1865.42, -2020.89, 13.2,0,0,180},  
		{1857.55, -2035.52, 13.2,0,0,90},  
	},
	[3029] = { -- #CR1_DOOR
		{2352.851, -1171.027, 26.9669, 0, 0, 90},
	}, 
	[1965] = { -- #IMCMPTRKDRL_LAS
		{2192.925, -2231.824, 15.69,0,0,315}, 
		{2195.072, -2229.589, 15.69,0,0,85}, 
		{2200.184, -2224.419, 15.69,0,0,315}, 
		{2202.432, -2222.266, 15.69,0,0,85}, 
		{2207.766, -2217.281, 15.69,0,0,315}, 
		{2210.014, -2215.058, 15.69,0,0,85}, 
		{2215.096, -2210.761, 15.69,0,0,315}, 
		{2217.344, -2208.537, 15.69,0,0,85}, 
	}, 
	[2893] = { -- #KMB_RAMP
		{2193.418, -2231.352, 14.183,0,0,45}, 
		{2194.642, -2230.128, 14.183,0,0,45}, 
		{2200.686, -2224.019, 14.183,0,0,45}, 
		{2201.91, -2222.795, 14.183,0,0,45}, 
		{2208.243, -2216.833, 14.183,0,0,45}, 
		{2209.468, -2215.609, 14.183,0,0,45}, 
		{2215.489, -2210.406, 14.183,0,0,45}, 
		{2216.713, -2209.182, 14.183,0,0,45}, 
	}, 
	[3058] = { -- #storm_drain_cover
		{2631.852, -1482.75, 18.109, 0,0,0}
	}, 
	[3125] = { -- #WD_FENCE_ANIM
		{2167.763, -1470.354, 25.328, 0,0,90}, 
		{2167.763, -1465.688, 25.328, 0,0,90}, 
		{2167.763, -1461.021, 25.328, 0,0,90}, 
		{2174.328, -1470.354, 25.328, 0,0,270}, 
		{2174.328, -1465.688, 25.328, 0,0,270}, 
		{2174.328, -1461.021, 25.328, 0,0,270}, 
	}, 
	[3083] = { -- #md_poster
		{2167.82, -1518.193, 20.237,0,0,0}
	},
	[2947] = { -- #cr_door_01
		{2322.845, 8.304, 25.483, 0,0,0}, 
		{2316.233, 0.712, 25.742, 0,0,270}
	}, 
	[2946] = { -- #cr_door_03
		{2304.257, -17.744, 25.742, 0,0,0}, 
		{2304.257, -14.583, 25.742, 0,0,180}
	}, 
	[3374] = { -- #SW_HAYBREAK02
		{-1053.792, -1187.624, 129.396, 0,0,0}, 
		{-1038.506, -1154.722, 129.699, 0,0,0}, 
		{-1105.419, -1112.451, 128.864, 0,0,0}, 
		{-1182.346, -1043.797, 129.699, 0,0,0}, 
		{-1141.389, -1008.254, 129.735, 0,0,0}, 
		{-1197.385, -1084.951, 129.743, 0,0,0}, 
		{-1161.353, -1117.198, 129.049, 0,0,0}, 
	},
	[2984] = { -- #PORTALOO
		{-2087.861, 178.2922, 35.3947, 0,0,3.3302}, 
		{-2114.903, 156.9329, 35.4667, 0,0,271.6719}, 
		{-2116.425, 157.4618, 35.7225, 0,0,269.1095}, 
		{-2054.474, 222.6438, 35.8767, 0,0,0}, 
		{-2069.262, 285.8519, 35.8543, 0,0,51.0305}, 
		{-2134.873, 293.1065, 35.4117, 0,0, 175.9489}, 
	}, 
	[3041] = { -- #CT_TABLE
		{-2201.436, 647.109, 48.413, 0,0,0}
	}, 
	[3039] = { -- #CT_STALL1
		{-2213.413, 640.908, 48.43, 0,0,90}
	}, 
	[3035] = { -- #TMP_BIN
		{-2183.968, 647.055, 49.185, 0,0,0}, 
		{-2172.813, 654.019, 49.185, 0,0,270}, 
		{-2172.813, 649.293, 49.185, 0,0,270}, 
	}, 
	[2935] = { -- KMB_CONTAINER_YEL
		{-1649.476, 9.1182, 4.060, 0,0, 315.1249}, 
	},
	[2934] = { -- #KMB_CONTAINER_RED
		{-1658.85, 44.8514, 4.06, 0,0,315.2922}, 
		{1023.181, 2106.604, 14.7301, 0,0,0}, 
		{1077.014, 2070.743, 14.7635, 0,0,0}, 
		{-820.3694, 1933.666, 7.3952, 0,0,11.8154}, 
		{-822.3879, 1945.519, 7.4836, 0,0,11.8154}, 
	},
	[2932] = { -- #KMB_CONTAINER_BLUE
		{-1570.986, 55.2009, 17.746, 0,0,40.4082}, 
		{-1564.401, 62.1434, 17.7537, 0,0,235.0724}, 
		{-1582.202, 54.1735, 17.7537, 0,0,0}, 
	}, 
	[959] = { -- #CJ_CHIP_MAKER_BITS
		{1074.903, 2139.611, 10.7203, 0,0,180}, 
		{1069.485, 2139.611, 10.7203, 0,0,180}, 
		{1062.456, 2139.611, 10.7203, 0,0,180}, 
		{1081.268, 2123.686, 10.7203, 0,0,90}, 
		{1081.236, 2130.681, 10.7203, 0,0,90}, 
		{1086.855, 2077.532, 10.7203, 0,0,0}, 
		{1091.818, 2121.257, 10.7203, 0,0,180}, 
		{1094.163, 2102.352, 10.7203, 0,0,90}, 
		{1094.163, 2092.352, 10.7203, 0,0,90}, 
	},
	[958] = { -- #CJ_CHIP_MAKER
		{1074.903, 2139.611, 10.7203, 0,0,180}, 		
		{1069.485, 2139.611, 10.7203, 0,0,180}, 
		{1062.456, 2139.611, 10.7203, 0,0,180}, 
		{1081.268, 2123.686, 10.7203, 0,0,90}, 
		{1081.236, 2130.681, 10.7203, 0,0,90}, 
		{1086.855, 2077.532, 10.7203, 0,0,0}, 
		{1091.818, 2121.257, 10.7203, 0,0,180}, 
		{1094.163, 2102.352, 10.7203, 0,0,90}, 
		{1094.163, 2092.352, 10.7203, 0,0,90}, 
	}, 
	[1299] = { -- #SMASHBOXPILE
		{-829.8794, 1957.827, 6.4364, 0,0,7.1004}, 
		{-824.9033, 1958.443, 6.5048, 0,0,9.1604}, 
	}, 
	[2974] = { -- #K_CARGO1
		{-828.3333, 1952.527, 5.9651, 0,0,102.0394}, 
		{-825.9227, 1953.171, 5.9651, 0,0,100.9489}, 
	}, 
	[2972] = { -- #K_CARGO4
		{-827.6044, 1958.276, 5.9873, 0,0,101.9089}
	}, 
	[1498] = { -- #GEN_DOOREXT03
		{2401.75, -1714.477, 13.125, 0,0,0}, 
		{2038.036, 2721.37, 10.53, 0,0,-180}, 
	},
	[1505] = { -- #GEN_DOOREXT07
		{-2574.495, 1153.023, 54.669, 0,0,-19.444}, 
	},
	[1496] = { -- #GEN_DOORSHOP02
		{-1800.706, 1201.041, 24.12, 0,0,0}, 
	},
	[1501] = { -- #GEN_DOOREXT04
		{-383.46, -1439.64, 25.33, 0,0,90}, 
	}, 
	[1522] = { -- #GEN_DOORSHOP3
		{-1390.79, 2639.33, 54.973, 0,0,0}, 
	}, 
	[3093] = { -- #CUNTGIRLDOOR
		{-371.4, -1429.42, 26.47, 0,0,0}, 
	},
	[2896] = { -- #CASKET_LAW
		{885.6575, -1077.412, 23.3188, 0,0,0}
	},
	
}





for model, dat in pairs(StandartObjects) do
	for _, v in pairs(dat) do
		createObject(model, v[1], v[2], v[3], v[4], v[5], v[6])
	end
end




function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end


local UpperSymbols = {
	["0"] = ")", 
	["1"] = "!", 
	["2"] = "@", 
	["3"] = "#", 
	["4"] = "$", 
	["5"] = "%", 
	["6"] = "^", 
	["7"] = "&", 
	["8"] = "*", 
	["9"] = "(", 
	["-"] = "_", 
	["="] = "+", 
}


function playerPressedKey(button, press)
	if(button == "mouse2") then
		if(isPlayerMapForced()) then
			if(press) then
				showCursor(true)
			else
				showCursor(false)
			end
		end
	end
	
	if(getPedOccupiedVehicle(localPlayer)) then
		if(getPedOccupiedVehicleSeat(localPlayer) == 0) then
			if(button == "lshift") then
				if(PData['rage'] > 0) then
					if(press) then
						AddRage(-2)
						PData['ragetimer'] = setTimer(function() 
							AddRage(-2)
						end, 50, 0)
						triggerServerEvent("Acceleration", localPlayer, localPlayer)
					else
						killTimer(PData['ragetimer'])
						triggerServerEvent("AccelerationDown", localPlayer, localPlayer)
					end
				end
			end
		end
	end
	
	
    if (press) then
		if(#Cheatkeys > 99) then
			table.remove(Cheatkeys, 1)
		end
		table.insert(Cheatkeys, button)
		local CheatLabel = ""
		for _, text in pairs(Cheatkeys) do
			CheatLabel = CheatLabel..text
		end
		
		for k, _ in pairs(Cheats) do
			if(string.find(CheatLabel, k)) then
				CheatCode(k)
				Cheatkeys = {}
				break
			end
		end
		
	
		if(BindedKeys[button]) then
			triggerEvent(unpack(BindedKeys[button]))
			if(button == "enter") then
				PText["HUD"][8] = nil
				BindedKeys[button] = nil
			end
			cancelEvent()
		end
		
		if(PText["HUD"][8]) then
			if(button == "space") then
				button = " "
			elseif(button == "backspace") then
				BindedKeys["enter"][3][4] = BindedKeys["enter"][3][4]:sub(1, -2)
			end
			if(#button == 1) then
				if getKeyState("lshift") == true or getKeyState("rshift") == true then
					button = string.upper(button)
					if(UpperSymbols[button]) then button = UpperSymbols[button] end
				end
				BindedKeys["enter"][3][4] = BindedKeys["enter"][3][4]..button
				cancelEvent()
			end
		end
		
		
		for key, arr in pairs(PData["MultipleAction"]) do
			if(key == button) then
				triggerEvent(arr[1], localPlayer, localPlayer, arr[5])
			end
		end
		

		if(tuningList) then
			if(button == "s" or button == "arrow_d") then
				cancelEvent()
				if(TuningSelector+1 <= #PText["tuning"]) then
					PText["tuning"][TuningSelector][6] = tocolor(98, 125, 152, 255)
					PText["tuning"][TuningSelector+1][6] = tocolor(201, 219, 244, 255)
					TuningSelector = TuningSelector+1
				else
					PText["tuning"][TuningSelector][6] = tocolor(98, 125, 152, 255)
					PText["tuning"][1][6] = tocolor(201, 219, 244, 255)
					TuningSelector = 1
					TuningListOpen(false, 1)
				end
				if(PText["tuning"][TuningSelector][20][5]) then UpgradePreload(nil, PText["tuning"][TuningSelector][20][3], PText["tuning"][TuningSelector][20][4], PText["tuning"][TuningSelector][20][5]) end
			elseif(button == "w" or button == "arrow_u") then
				cancelEvent()
				if(TuningSelector-1 >= 1) then
					PText["tuning"][TuningSelector][6] = tocolor(98, 125, 152, 255)
					PText["tuning"][TuningSelector-1][6] = tocolor(201, 219, 244, 255)
					TuningSelector = TuningSelector-1
				else
					PText["tuning"][TuningSelector][6] = tocolor(98, 125, 152, 255)
					PText["tuning"][#PText["tuning"]][6] = tocolor(201, 219, 244, 255)
					TuningSelector = #PText["tuning"]
					TuningListOpen(false, -1)
				end
				if(PText["tuning"][TuningSelector][20][5]) then UpgradePreload(nil, PText["tuning"][TuningSelector][20][3], PText["tuning"][TuningSelector][20][4], PText["tuning"][TuningSelector][20][5]) end
			elseif(button == "e" or button == "enter" or button == "space" or button == "d") then
				cancelEvent()
				triggerEvent(unpack(PText["tuning"][TuningSelector][20]))
			elseif(button == "backspace" or button == "escape") then
				cancelEvent()
				if(PText["tuning"][TuningSelector][20][5]) then 
					LoadUpgrade()
				else
					TuningExit()
				end
			end
		end
		if(button == "escape") then
			if(PData["BizControlName"]) then
				cancelEvent()
				triggerServerEvent("StopBizControl", localPlayer, PData["BizControlName"][1]) 
				PData["BizControlName"] = nil
				PText["biz"] = {}
				showCursor(false)
			end
			if(BANKCTL) then
				cancelEvent()
				BankControl()
			end
			if(wardprobeArr) then
				cancelEvent()
				NewNextSkinEnter(nil,nil,true)
			end
		elseif(button == "f") then
			for i, key in pairs(PData["Target"]) do
				if(WardrobeObject[i]) then
					triggerServerEvent("EnterWardrobe", localPlayer, localPlayer, getElementDimension(localPlayer))
				end
			end
		elseif(button == "mouse_wheel_up") then
			if(PING) then
				if(TabScroll > 1) then
					TabScroll=TabScroll-1
					UpdateTabEvent()
				end
			end
		elseif(button == "mouse_wheel_down") then
			if(PING) then
				if(MAXSCROLL < TABCurrent) then
					TabScroll=TabScroll+1
					UpdateTabEvent()
				end
			end
		end
    end
end
addEventHandler("onClientKey", root, playerPressedKey)




function CreateTarget(el)
	local ex,ey,ez = getElementPosition(el)
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(ex,ey,ez,px,py,pz)
	if(dist < 30) then
		local types = getElementType(el)
		if(dist < 2) then
			if(types == "vehicle") then 
				local driver = getVehicleOccupant(el)
				if(driver) then
					if(getElementType(driver) == "ped") then
						PData["MultipleAction"]["f"] = {"CarJack", false, false, false}
					end
				end
			elseif(types == "player" or types == "ped") then
				sx,sy = getScreenFromWorldPosition(ex,ey,ez)
				if(sx and sy) then
					PData["MultipleAction"]["e"] = {"PedDialog", "Начать разговор", sx,sy}
				end
			end
		end
		local AllBones = false
		if(types == "vehicle") then 
			AllBones = getVehicleComponents(el)
		elseif(types == "ped" or types == "player") then 
			AllBones = {1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 51, 52, 53, 54} 
		end
		
		local minx, maxx, miny, maxy = screenWidth, 0, screenHeight, 0
		
		if(AllBones) then
			for bones in pairs(AllBones) do
				local x,y,z = false, false, false
				if(types == "vehicle") then 
					x,y,z = getVehicleComponentPosition(el, bones, "world")
							
				
					if(bones == "boot_dummy" or bones == "bump_rear_dummy") then
						local distdummy = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
						if(distdummy < 3) then
							sx,sy = getScreenFromWorldPosition(x,y,z)
							if(sx and sy) then
								--PData["MultipleAction"]["e"] = {"TrunkReq", "открыть", sx, sy}
							end
						end
					end
				elseif(types == "ped" or types == "player") then 
					x,y,z = getPedBonePosition(el, AllBones[bones]) 
				end
		
				x,y = getScreenFromWorldPosition(x,y,z)
				if(x and y) then
					if(x > maxx) then
						maxx = x
					end
					if(x < minx) then
						minx = x
					end
					
					if(y > maxy) then
						maxy = y
					end
					if(y < miny) then
						miny = y
					end
				end
			end

			local p = (40-dist) --Отступ
			maxx = maxx+(p*scalex)
			minx = minx-(p*scalex)
			maxy = maxy+(p*scaley)
			miny = miny-(p*scaley)
			
			local sizeBox = 10
			
			dxDrawLine(maxx, maxy, maxx+sizeBox, maxy, tocolor(255,255,255,180), 1)
			dxDrawLine(maxx+sizeBox, maxy, maxx+sizeBox, maxy-sizeBox, tocolor(255,255,255,180), 1)
			
			dxDrawLine(maxx, miny, maxx+sizeBox, miny, tocolor(255,255,255,180), 1)
			dxDrawLine(maxx+sizeBox, miny, maxx+sizeBox, miny+sizeBox, tocolor(255,255,255,180), 1)
			
			
			dxDrawLine(minx, maxy, minx+sizeBox, maxy, tocolor(255,255,255,180), 1)
			dxDrawLine(minx, maxy, minx, maxy-sizeBox, tocolor(255,255,255,180), 1)
			
			dxDrawLine(minx, miny, minx+sizeBox, miny, tocolor(255,255,255,180), 1)
			dxDrawLine(minx, miny, minx, miny+sizeBox, tocolor(255,255,255,180), 1)
			
			local text = false
			if(types == "vehicle") then 
				text = getVehicleName(el)
				if(getElementData(el, "year")) then
					text = text.." "..getElementData(el, "year")
				end
			elseif(types == "ped") then 
				text = "Неизвестно"
			end
			
			if(getElementData(el, "name")) then
				text = getElementData(el, "name")
			end
			
			if(text) then
				local tw = dxGetTextWidth(text, scale/2, "default-bold", true)
				local th = dxGetFontHeight(scale/2, "default-bold")
				dxDrawRectangle(minx+(1*scalex), miny+(1*scaley), tw+(10*scalex), th+(8*scaley), tocolor(0,0,0,180))
				dxDrawText(text, minx+(6*scalex), miny+(5*scaley), 0, 0, tocolor(200, 200, 200, 255), scale/2, "default-bold", "left", "top", false, false, false, true)
			end
		end	
	end
end

function ShakeLevel(level)
	PData["ShakeLVL"] = PData["ShakeLVL"]+level
end
addEvent("ShakeLevel", true)
addEventHandler("ShakeLevel", localPlayer, ShakeLevel)




local PlayerPissing = {}
local PlayerPissingTimer = {}
function PlayerPiss(thePlayer)
	if(not PlayerPissing[thePlayer]) then
		local x,y,z = getElementPosition(thePlayer)
		local rx,ry,rz = getElementRotation(thePlayer)
		x,y,z = getPointInFrontOfPoint(x, y, z-0.2, rz-270, 0.5)
		PlaySFX3DforAll("script", 61, 0, x,y,z, false, 0, 10)
		
		PlayerPissing[thePlayer] = createEffect("petrolcan", x, y, z, 90, 0, -rz, 50, true)
		
		PlayerPissingTimer[thePlayer] = setTimer(function()
			destroyElement(PlayerPissing[thePlayer])
			PlayerPissing[thePlayer] = nil
		end, 5000, 1)
	end
end
addEvent("PlayerPiss", true)
addEventHandler("PlayerPiss", localPlayer, PlayerPiss)


local PlayerPuked = {}
local PlayerPukeTimer = {}
function PlayerPuke(thePlayer)
	if(not PlayerPuked[thePlayer]) then
		local x,y,z = getElementPosition(thePlayer)
		local rx,ry,rz = getElementRotation(thePlayer)
		x,y,z = getPointInFrontOfPoint(x, y, z, rz, 0.3)
		PlayerPuked[thePlayer] = true
		
		PlayerPukeTimer[thePlayer] = setTimer(function()
			createEffect("puke", x, y, z, 270, 0, -rz, 50, true)
		
		end, 3000, 1)
		
		PlayerPukeTimer[thePlayer] = setTimer(function()
			destroyElement(PlayerPuked[thePlayer])
			PlayerPuked[thePlayer] = nil
		end, 5000, 1)
	end
end
addEvent("PlayerPuke", true)
addEventHandler("PlayerPuke", localPlayer, PlayerPuke)




local CameraFade = false
local FadeUpTime = 0
function DrawOnClientRender()	
	if(CameraFade) then
		if(CameraFade[3] == "in") then
			if(CameraFade[1] > CameraFade[2]) then -- Затемнение
				CameraFade[2] = getTickCount()-FadeUpTime
			end
			if(CameraFade[2]/CameraFade[1] > 1) then CameraFade[2] = CameraFade[1] end
		elseif(CameraFade[3] == "out") then
			CameraFade[2] = CameraFade[1]-(getTickCount()-FadeUpTime)
			if(CameraFade[2] < 0) then
				CameraFade = false
			end
		end
		if(CameraFade) then
			dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 255*(CameraFade[2]/CameraFade[1])))
		end
	end
	
	if(ZonesDisplay[1]) then
		if(not PData['Minimize']) then
			if(PData["Interface"]["AreaName"]) then
				if(getElementData(localPlayer, "City")) then
					dxDrawImage(screenWidth-(dxGetTextWidth(ZonesDisplay[1][1], NewScale*6, "default-bold", true)*1.15)-(25*scalex), (screenHeight-(25*scaley))-dxGetFontHeight(NewScale*4, "default-bold"), (dxGetTextWidth(ZonesDisplay[1][1], NewScale*6, "default-bold", true)*1.3), dxGetFontHeight(NewScale*4, "default-bold"), DrawLocationLiberty(ZonesDisplay[1][1]), 0, 0, 0, tocolor(255, 255, 255, ZonesDisplay[1][2]))
				else
					dxDrawImage(screenWidth-(dxGetTextWidth(ZonesDisplay[1][1], NewScale*4, "diploma", true))-(25*scalex), (screenHeight)-dxGetFontHeight(NewScale*4, "diploma")-(25*scaley), dxGetTextWidth(ZonesDisplay[1][1], NewScale*4, "diploma", true), dxGetFontHeight(NewScale*4, "diploma"), DrawLocation(ZonesDisplay[1][1]), 0, 0, 0, tocolor(255, 255, 255, ZonesDisplay[1][2]))
				end
			end
		end

		if(tonumber(ZonesDisplay[1][3])) then
			if(ZonesDisplay[1][3] > 0) then
				ZonesDisplay[1][3] = ZonesDisplay[1][3]-5
				if(ZonesDisplay[1][3] <= 255) then
					ZonesDisplay[1][2] = ZonesDisplay[1][3]
				end
			else
				VideoMemory["HUD"]["LocationTarget"] = nil
				table.remove(ZonesDisplay, 1)
			end
		elseif(ZonesDisplay[1][2] < 255) then
			ZonesDisplay[1][2] = ZonesDisplay[1][2]+5
		elseif(ZonesDisplay[1][2] == 255) then
			if(ZonesDisplay[1][3] == "fast") then
				ZonesDisplay[1][3] = 255
			else
				ZonesDisplay[1][3] = 1200
			end
		end
	end


	if(PData['CameraMove']) then
		if(isTimer(PData['CameraMove']['timer'])) then
			local remaining, _, totalExecutes = getTimerDetails(PData['CameraMove']['timer'])
			local percent = 100-(remaining/totalExecutes)*100
			local a1, a2 = PData['CameraMove']['sourcePosition'], PData['CameraMove']['needPosition']
			local newx, newy, newz, newlx, newly, newlz = a1[1]-a2[1], a1[2]-a2[2], a1[3]-a2[3], a1[4]-a2[4], a1[5]-a2[5], a1[6]-a2[6]
			newx, newy, newz, newlx, newly, newlz = (newx/100)*percent, (newy/100)*percent, (newz/100)*percent, (newlx/100)*percent, (newly/100)*percent, (newlz/100)*percent 
			setCameraMatrix(a1[1]-newx, a1[2]-newy, a1[3]-newz, a1[4]-newlx, a1[5]-newly, a1[6]-newlz)
		end
	end

	if(isPlayerMapForced()) then
		return false
	end

	if(not PData["wasted"]) then
		if(Targets["theVehicle"]) then
			CreateTarget(Targets["theVehicle"])
			
			local fract = ""
			local color = false
			local PLText = getVehiclePlateText(Targets["theVehicle"])
			local ps = string.sub(PLText, 0, 1)
			local pe = string.sub(PLText, 6, 9)
			if(PLText == "VAGOS228") then
				fract="Вагос"
				color=getTeamVariable("Вагос")
			elseif(PLText == "RIFA 228") then
				fract="Рифа"
				color=getTeamVariable("Вагос")
			elseif(PLText == "YAZA 228") then
				fract="Da Nang Boys"
				color=getTeamVariable("Вагос")
			elseif(PLText == "METAL228") then
				fract="Байкеры"
				color=getTeamVariable("Вагос")
			elseif(PLText == "TRIA 228") then
				fract="Триады"
				color=getTeamVariable("Гроув-стрит")
			elseif(PLText == "GRST 228" or PLText == "GROVE4L_") then
				fract="Гроув-стрит"	
				color=getTeamVariable("Гроув-стрит")
			elseif(PLText == "AZTC 228") then
				fract="Ацтекас"	
				color=getTeamVariable("Гроув-стрит")
			elseif(PLText == "BALS 228") then
				fract="Баллас"	
				color=getTeamVariable("Баллас")
			elseif(PLText == "RUSM 228") then
				fract="Русская мафия"
				color=getTeamVariable("Баллас")
			elseif(PLText == "COKA 228") then
				fract="Колумбийский картель"
				color=getTeamVariable("Баллас")
			elseif(PLText == "NEWS 228") then
				fract="СМИ"
				color=getTeamVariable("Мирные жители")
			elseif(ps == "I" and pe == "228") then
				fract="Служебный"
			elseif(ps == "M" and pe == "228") then
				fract="МЧС"
			elseif(ps == "P" and pe == "228" or PLText == "_CUFFS__") then
				fract="Полиция"
				color=getTeamVariable("Полиция")
			elseif(ps == "A" and pe == "228") then
				fract="Военные"
				color=getTeamVariable("Полиция")
			elseif(getElementData(Targets["theVehicle"], "owner")) then
				fract="Частная собственность"
			elseif(ps == "U" and pe == "228") then
				fract="Учебная"
			elseif(PLText == "KOLHZ228") then
				fract="Деревенщины"
				color=getTeamVariable("Уголовники")
			else
				color=getTeamVariable("Мирные жители")
				fract="Мирные жители"
			end
			
			if(color) then
				if(color >= 0) then
					color = tocolor(54, 192, 44, 255)
				else
					color = tocolor(204, 0, 0, 255)
				end
			else
				color = tocolor(200, 200, 200, 255)
			end
			MemText(Text(fract), (screenWidth/2)+(60*scalex), (screenHeight/2)-(70*scaley), color, NewScale*1.5, "default-bold", NewScale*1.5, 0, true)
						
			
			if(getVehiclePlateText(Targets["theVehicle"]) == "SELL 228") then
				local x,y,z = getElementPosition(Targets["theVehicle"])
				local price = false
				if(getElementData(Targets["theVehicle"], "price")) then
					price = getElementData(Targets["theVehicle"], "price")
				else
					price = getVehicleHandlingProperty(Targets["theVehicle"], "monetary")
				end
				create3dtext("$"..price, x,y,z+1, scale*2, 60, tocolor(228, 54, 70, 180), "default-bold")
			end
		elseif(Targets["thePlayer"]) then		
			local skin = getElementModel(Targets["thePlayer"])
			local color = getTeamVariable(SkinData[skin][2])

			if(color) then
				if(color >= 0) then
					color=tocolor(54, 192, 44, 255)
				else
					color=tocolor(204, 0, 0, 255)
				end
			else
				color=tocolor(200, 200, 200, 255)
			end
			MemText(Text(getTeamGroup(SkinData[skin][2])), (screenWidth/2)+(60*scalex), (screenHeight/2)-(70*scaley), color, NewScale*1.5, "default-bold", NewScale*1.5, 0, true)
						
			CreateTarget(Targets["thePlayer"])
		elseif(Targets["thePed"]) then
			local team = getElementData(Targets["thePed"], "team")
			local color = getTeamVariable(team)
			if(color) then
				if(color >= 0) then
					color=tocolor(54, 192, 44, 255)
				else
					color=tocolor(204, 0, 0, 255)
				end
			else
				color=tocolor(200, 200, 200, 255)
			end
			if(team) then
				MemText(Text(getTeamGroup(team)), (screenWidth/2)+(60*scalex), (screenHeight/2)-(70*scaley), color, NewScale*1.5, "default-bold", NewScale*1.5, 0, true)
			end
			
			CreateTarget(Targets["thePed"])
		end
		
		for _, ped in pairs(getElementsByType("ped", getRootElement(), true)) do
			local text = ""
			
			local x,y,z = getElementPosition(localPlayer)
			local pedx, pedy, pedz = getElementPosition(ped)
			local distance = getDistanceBetweenPoints3D(x,y,z, pedx, pedy, pedz)
			if(distance < 10) then
				--text = "『 В разработке 』\n "
			end
			if(PlayersMessage[ped]) then
				text = text.."#EEEEEE"..PlayersMessage[ped]
			end
			if(text ~= "") then
				local hx,hy,hz = getPedBonePosition(ped, 5)
				create3dtext(text, hx,hy,hz+0.25, NewScale*1.8, 60, tocolor(255,255,255, 220), "default-bold")
			end
		end
		
		local x,y,z = getElementPosition(localPlayer)
		local zone = getZoneName(x,y,z, false)
		if(zone == "Restricted Area") then
			for obj, dat in pairs(ObjectInStream) do
				if(isElement(dat["attach_searchlight"])) then
					local sx, sy, sz = getPositionFromElementOffset(obj, 0, 1.181, 0.768)
					local ex, ey, ez = getPositionFromElementOffset(obj, 0, 30, 0)
					
					setSearchLightStartPosition(dat["attach_searchlight"], sx, sy, sz)
					setSearchLightEndPosition(dat["attach_searchlight"], ex, ey, ez)
				end
			end
		
		
			for key,thePlayer in pairs(getElementsByType "player") do
				local team = getPlayerTeam(thePlayer)
				if(team) then
					local r,g,b = getTeamColor(team)
					local px,py,pz = getElementPosition(thePlayer)
					
					local xp = (px/3000)*1
					local yp = (py/3000)*1
					local zp = (pz/3000)*1
					
					local mx2,my2,mz2 = 220-(1.7*yp), 1822.8+(1.7*xp), 6.5+(zp)
					dxDrawLine3D(220, 1822.8, 12.5,mx2,my2,mz2, tocolor(r,g,b,180))
					
					--create3dtext(getPlayerName(thePlayer), mx2,my2,mz2+0.1, scale, 60, tocolor(r,g,b,180), "default-bold")

				end
			end
		end
		
		for _, thePlayer in pairs(getElementsByType("player", getRootElement(), true)) do
			if(thePlayer) then
				local Team = getPlayerTeam(thePlayer)
				if(Team) then
					local x,y,z = getPedBonePosition(thePlayer, 5)
					local text = {}
					
					local skin = getElementModel(thePlayer)
					if(not skin) then return false end
					
					
					if(isPedDoingTask(thePlayer, "TASK_SIMPLE_USE_GUN")) then
						if(getElementData(thePlayer, "laser")) then
							local wx,wy,wz = getPedWeaponMuzzlePosition(thePlayer)
							local x2,y2,z2 = getPedTargetEnd(thePlayer)
							local arr = fromJSON(getElementData(thePlayer, "laser"))
							dxDrawLine3D(wx,wy,wz,x2,y2,z2, tocolor(arr[1], arr[2], arr[3], arr[4]), 0.8)
						end
					end
					
					if(skin == 285 or skin == 264) then
						text["nickname"] = "『 неизвестно 』"
						local r,g,b = getTeamColor(getTeamFromName(SkinData[skin][2]))
						text["nicknamecolor"] = tocolor(r,g,b, 200)
					else
						--if(thePlayer ~= localPlayer) then
							text["nickname"] = getPlayerName(thePlayer)
							local r,g,b = getTeamColor(getTeamFromName(SkinData[skin][2]))
							text["nicknamecolor"] = tocolor(r,g,b, 200)
						--end
						if(skin == 252) then --CENSORED
							sx, sy, sz = getCameraMatrix()
							local x2,y2,z2 = getPedBonePosition(thePlayer, 1)
							local distance = getDistanceBetweenPoints3D(x2,y2,z2, sx, sy, sz)
							if(isLineOfSightClear(x2,y2,z2, sx, sy, sz, true, true, false, false, false)) then
								sx,sy = getScreenFromWorldPosition(x2,y2,z2)
								if(sx) then
									local CensureColor = {
										tocolor(50,50,50),
										tocolor(25,25,25),
										tocolor(75,75,75),
										tocolor(150, 90, 60),
										tocolor(228, 200, 160),
									}
									for i = 1, 8 do
										for i2 = 1, 8 do
											dxDrawRectangle(sx-(170*scale)/distance+((35*i)*scale/distance), sy-(70*scale)/distance+((35*i2)*scale/distance), (35*scale)/distance,(35*scale)/distance, CensureColor[math.random(#CensureColor)])
										end
									end
								end
							end
						elseif(skin == 145) then
							sx, sy, sz = getCameraMatrix()
							local x2,y2,z2 = getPedBonePosition(thePlayer, 1)
							local distance = getDistanceBetweenPoints3D(x2,y2,z2, sx, sy, sz)
							if(isLineOfSightClear(x2,y2,z2, sx, sy, sz, true, true, false, false, false)) then
								sx,sy = getScreenFromWorldPosition(x2,y2,z2)
								if(sx) then
									local CensureColor = {
										tocolor(50,50,50),
										tocolor(25,25,25),
										tocolor(75,75,75),
										tocolor(150, 90, 60),
										tocolor(228, 200, 160),
									}
									for i = 1, 8 do
										for i2 = 1, 8 do
											dxDrawRectangle(sx-(170*scale)/distance+((35*i)*scale/distance), sy-(90*scale)/distance+((35*i2)*scale/distance), (35*scale)/distance,(35*scale)/distance, CensureColor[math.random(#CensureColor)])
										end
									end
								end
							end
						end
					end
					
					local cx,cy,cz = getCameraMatrix()
					local depth = getDistanceBetweenPoints3D(x,y,z,cx,cy,cz)
					if(depth < 60) then
						local fh = dxGetFontHeight(NewScale*1.8, "clear")/(60/(60-depth))
						local sx,sy = getScreenFromWorldPosition(x,y,z+0.30)
						if(sx and sy) then
							if(PlayersMessage[thePlayer]) then
								x, y, z = getWorldFromScreenPosition(sx, sy-fh, depth)
								create3dtext(PlayersMessage[thePlayer], x,y,z, NewScale*1.8, 60, tocolor(230,230,230,200), "clear")
							end
							
							x, y, z = getWorldFromScreenPosition(sx, sy, depth)
							create3dtext(text["nickname"].."("..getElementData(thePlayer, "id")..")", x,y,z, NewScale*1.8, 60, text["nicknamecolor"], "clear")
							
							if(PlayersAction[thePlayer]) then
								x, y, z = getWorldFromScreenPosition(sx, sy+fh, depth)
								create3dtext(PlayersAction[thePlayer], x,y,z, NewScale*1.8, 60, tocolor(255,0,0,200), "clear")
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, DrawOnClientRender)






function FadeIn(times)
	if(not CameraFade) then
		FadeUpTime = getTickCount()
		CameraFade = {times,0,"in"}
	end
end
addEvent("FadeIn", true)
addEventHandler("FadeIn", localPlayer, FadeIn)


function FadeOut(times)
	if(CameraFade) then
		FadeUpTime = getTickCount()
		CameraFade = {times,times,"out"}
	end
end
addEvent("FadeOut", true)
addEventHandler("FadeOut", localPlayer, FadeOut)





function vp(command, h)
	local x,y,z = getElementPosition(localPlayer)
	triggerServerEvent("vp", localPlayer, localPlayer, h, x, y, z)
end
addCommandHandler("vp", vp)

function vpr(command, h)
	local x,y,z = getElementPosition(localPlayer)
	triggerServerEvent("vpr", localPlayer, localPlayer, h, x, y, z)
end
addCommandHandler("vpr", vpr)


function sc(command, h)
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	setVehicleColor(theVehicle, h, h, h, h)
end
addCommandHandler("sc", sc)





function getTeamGroup(team)
	if(team == "Мирные жители" or team == "МЧС") then
		return "Мирные жители"
	elseif(team == "Вагос" or team == "Da Nang Boys" or team == "Рифа") then
		return "Синдикат Локо"
	elseif(team == "Баллас" or team == "Колумбийский картель" or team == "Русская мафия") then
		return "Наркомафия"
	elseif(team == "Гроув-стрит" or team == "Триады" or team == "Ацтекас") then
	    return "Бандиты"
	elseif(team == "Полиция" or team == "Военные" or team == "ЦРУ" or team == "ФБР") then
		return "Официалы"
	elseif(team == "Уголовники" or team == "Байкеры" or team == "Деревенщины") then
		return "Уголовники"
	end
end


function getTeamGroupColor(team)
	if(team == "Мирные жители" or team == "МЧС") then
		return "#CCCCCC"
	elseif(team == "Вагос" or team == "Da Nang Boys" or team == "Рифа") then
		return "#A00000"
	elseif(team == "Баллас" or team == "Колумбийский картель" or team == "Русская мафия") then
		return "#B7410E"
	elseif(team == "Гроув-стрит" or team == "Триады" or team == "Ацтекас") then
	    return "#4E653D"
	elseif(team == "Полиция" or team == "Военные" or team == "ЦРУ" or team == "ФБР") then
		return "#4169E1"
	elseif(team == "Уголовники" or team == "Байкеры" or team == "Деревенщины") then
		return "#858585"
	end
end




function getTeamVariable(team)
	if(team == "Мирные жители" or team == "МЧС") then
		return tonumber(getElementData(localPlayer, "civilian"))
	elseif(team == "Вагос" or team == "Da Nang Boys" or team == "Рифа") then
		return tonumber(getElementData(localPlayer, "vagos"))
	elseif(team == "Баллас" or team == "Колумбийский картель" or team == "Русская мафия") then
		return tonumber(getElementData(localPlayer, "ballas"))	
	elseif(team == "Гроув-стрит" or team == "Триады" or team == "Ацтекас") then
	    return tonumber(getElementData(localPlayer, "grove"))
	elseif(team == "Полиция" or team == "Военные" or team == "ЦРУ" or team == "ФБР") then
		return tonumber(getElementData(localPlayer, "police"))
	elseif(team == "Уголовники" or team == "Байкеры" or team == "Деревенщины") then
		return tonumber(getElementData(localPlayer, "ugol"))
	end
end


function angle()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	local vx,vy,vz = getElementVelocity(theVehicle)
	local modV = math.sqrt(vx*vx + vy*vy)
	
	if not isVehicleOnGround(theVehicle) then return 0,modV end
	
	local rx,ry,rz = getElementRotation(theVehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	
	local deltaT = tick - (multTime or 0)
	if mult~= 1 and modV <= 0.3 and deltaT > 750 then
		mult = mult-1
		multTime = tick
	elseif deltaT > 1500 then
		local temp = 1
		if score >= 1000 then
			temp = 5
		elseif score >= 500 then
			temp = 4
		elseif score >= 250 then
			temp = 3
		elseif score >= 100 then
			temp = 2
		end
		if temp>mult then
			mult = temp
			multTime = tick
		end
	end
	

	local cosX = (sn*vx + cs*vy)/modV
	if cosX > 0.966 or cosX < 0 then return 0,modV end
	return math.deg(math.acos(cosX))*0.5, modV
end

addEvent("driftCarCrashed", true)
addEventHandler("driftCarCrashed", getRootElement(), function()
	resetTimer(PData["ClearDriving"])
	if score ~= 0 then
		score = 0
		mult = 1
	end
end)




function IsItemForSale(name)
	local state = false
	for _, dat in pairs(PInv["shop"]) do
		if(dat[2] == "Trade") then
			if(dat[1] == name) then
				state = true
			end
		end
	end
	return state
end



function hex2rgb(hex) return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) end 



function findRotation(x1, y1, x2, y2) 
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end




function StopDrag(name, id)
	if(name and id) then
		DragElementName = name
		DragElementId = id
	end
	DragElement = false
	DragX = false
	DragY = false
end




function addLabelOnClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if(state == "down") then
		for name,arr in pairs(PText) do
			for i,el in pairs(arr) do
				local color = el[6]
				local FH = dxGetFontHeight(el[7], el[8])
				local FW = dxGetTextWidth(el[1], el[7], el[8], true)
				if(MouseX-el[2] <= FW and MouseX-el[2] >= 0) then
					if(MouseY-el[3] <= FH and MouseY-el[3] >= 0) then
						triggerEvent(unpack(el[20]))
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), addLabelOnClick)






function DropInvItem(name, id, komu)
	if(backpackid) then
		if(backpackid == id) then
			if(name == "player") then
				return false
			end
		end
	end
	if(name == "backpack") then
		triggerServerEvent("dropinvitem", localPlayer, localPlayer, name, id, backpackid, komu)
	elseif(name == "trunk") then
		return false -- Доделать потом
	else
		triggerServerEvent("dropinvitem", localPlayer, localPlayer, name, id, false, komu)	
	end
	SetInventoryItem(name, id, nil, nil, nil, nil)
end
addEvent("DropInvItem", true)
addEventHandler("DropInvItem", localPlayer, DropInvItem)




function AddButtonData(name, i1, dragname, i2, razdel)
	local oldData = PInv[name][i1][4][razdel]
	local d1,d2,d3,d4 = PInv[dragname][i2][1], PInv[dragname][i2][2], PInv[dragname][i2][3], PInv[dragname][i2][4]
	if(oldData) then
		local o1, o2, o3, o4 = oldData[1], oldData[2], oldData[3], oldData[4]
		PInv[name][i1][4][razdel] = {d1,d2,d3,toJSON(d4)}
		SetInventoryItem(name, i2, o1,o2,o3,o4)
	else
		PInv[name][i1][4][razdel] = {d1,d2,d3,toJSON(d4)}
		SetInventoryItem(dragname, i2, nil,nil,nil,nil)
	end
end
addEvent("AddButtonData", true)
addEventHandler("AddButtonData", localPlayer, AddButtonData)


function RemoveButtonDataNew(name, i, key, count)
	PInv[name][i][4][key][2] = PInv[name][i][4][key][2]+count
	if(PInv[name][i][4][key][2] == 0) then
		PInv[name][i][4][key] = nil
	end	
	
	SetInventoryItem(name, i, PInv[name][i][1],PInv[name][i][2],PInv[name][i][3],toJSON(PInv[name][i][4]))
end
addEvent("RemoveButtonDataNew", true)
addEventHandler("RemoveButtonDataNew", localPlayer, RemoveButtonDataNew)



function RemoveButtonData(name, i1, key)
	local newslot = false
	for i2 = 1, #PInv[name] do
		if(not PInv[name][i2][1]) then
			newslot=i2
			break
		end
	end
	if(newslot) then
		local item = PInv[name][i1][4][key]
		PInv[name][i1][4][key] = nil
		SetInventoryItem(name, newslot, item[1],item[2],item[3],item[4])
	end
end
addEvent("RemoveButtonData", true)
addEventHandler("RemoveButtonData", localPlayer, RemoveButtonData)


function ReplaceInventoryItem(name1, item1, name2, item2)
	if(backpackid) then
		if(name1 == "player") then
			if(item1 == backpackid) then
				return false
			end
		end
		
		if(name2 == "player") then
			if(item2 == backpackid) then
				return false
			end
		end
	end
	local inv = PInv[name1][item1][1]
	local count = PInv[name1][item1][2]
	local quality = PInv[name1][item1][3]
	local data = PInv[name1][item1][4]
	
	local inv2 = PInv[name2][item2][1]
	local count2 = PInv[name2][item2][2]
	local quality2 = PInv[name2][item2][3]
	local data2 = PInv[name2][item2][4]
	SetInventoryItem(name1, item1, inv2, count2, quality2, toJSON(data2))
	SetInventoryItem(name2, item2, inv, count, quality, toJSON(data))
end



function SetInventoryItem(name, i, item, count, quality, data)
	if(not isPedDead(localPlayer)) then
		if(data) then data = fromJSON(data) end
		if(name == "backpack") then
			PInv["player"][backpackid][4]["content"][i][1] = item
			PInv["player"][backpackid][4]["content"][i][2] = count
			PInv["player"][backpackid][4]["content"][i][3] = quality
			PInv["player"][backpackid][4]["content"][i][4] = data
		else
			PInv[name][i][1] = item
			PInv[name][i][2] = count
			PInv[name][i][3] = quality
			PInv[name][i][4] = data
		end
		
		
	end
end





function MoveMouse(x, y, absoluteX, absoluteY)
	if(DragElement) then
		DragX = absoluteX-DragStart[1]
		DragY = absoluteY-DragStart[2]
	end
	MouseX = absoluteX
	MouseY = absoluteY
	local hx,hy,hz = getWorldFromScreenPosition(screenWidth/2, screenHeight/2, 10)
	setPedLookAt(localPlayer, hx,hy,hz)
end
addEventHandler("onClientCursorMove", getRootElement(), MoveMouse)



function useinvslot(val)
	usableslot=val
end
addEvent("useinvslot", true)
addEventHandler("useinvslot", localPlayer, useinvslot)





function GetQualityColor(quality)
	if(not quality or quality <= 99) then
		return "#CC0000"
	elseif(quality <= 199 and quality > 99) then
		return "#CC3300"
	elseif(quality <= 299 and quality > 199) then
		return "#CC6600"
	elseif(quality <= 399 and quality > 299) then
		return "#CC9900"
	elseif(quality <= 499 and quality > 399) then
		return "#CCCC00"
	elseif(quality <= 599 and quality > 499) then
		return "#CCFF00"
	elseif(quality <= 699 and quality > 599) then
		return "#99CC00"
	elseif(quality <= 799 and quality > 699) then
		return "#99FF00"
	elseif(quality <= 899 and quality > 799) then
		return "#9966FF"
	elseif(quality <= 999 and quality > 899) then
		return "#9933FF"
	elseif(quality >= 1000) then
		return "#9900FF"
	end
end


function vibori(arr)
	if(arr) then
		local text = ""
		local i = 1
		for v,k in pairs(fromJSON(arr)) do
			text=text..i..": "..v.." ("..k..")\n"
			BindedKeys[tostring(i)] = {"ServerCall", localPlayer, {"golos", localPlayer, localPlayer, v}}
			i=i+1
		end
		PText["INVHUD"]["golos"] = {text, 0, 430*scaley, screenWidth-(10*scalex), 0, tocolor(255, 255, 255, 255), scale, "clear", "right", "top", false, false, false, true, false, 0, 0, 0, {}}
	else
		PText["INVHUD"]["golos"] = nil
		BindedKeys = {}
	end
end
addEvent("vibori", true)
addEventHandler("vibori", localPlayer, vibori)











--[[
	scale3D - Необходимо для того чтобы уменьшать текст в 3D пространстве, без перерисовки
--]]
function MemText(text, left, top, color, scale, font, border, incline, centerX, centerY, scale3D)
	if(text) then
		local index = text..color
		
		TexturesSize["HUD"][index] = scale
		local w,h = dxGetTextWidth(text, scale, font, true)+(border*2), dxGetFontHeight(scale, font)+(border*2)
		
		
		if(not VideoMemory["HUD"][index]) then
			VideoMemory["HUD"][index] = dxCreateRenderTarget(w+((w*incline)/4),h, true)
			
			dxSetRenderTarget(VideoMemory["HUD"][index], true)
			dxSetBlendMode("modulate_add")
			
			local posx, posy = ((w*incline)/4),0
			if(border) then
				posx = posx+border
				posy = posy+border
			end
			
			
			local textb = string.gsub(text, "#%x%x%x%x%x%x", "")
			for oX = -border, border do 
				for oY = -border, border do 
					dxDrawText(textb, posx+oX, posy+oY, 0+oX, 0+oY, tocolor(0, 0, 0, 255), scale, font, "left", "top", false, false,false,false,not PData["Interface"]["LowPC"])
				end
			end

			dxDrawText(text, posx, posy, 0, 0, color, scale, font, "left", "top", false,false,false,true,not PData["Interface"]["LowPC"])

			
			dxSetBlendMode("blend")
			dxSetRenderTarget()
			
			if(incline > 0) then 
				local pixels = dxGetTexturePixels(VideoMemory["HUD"][index])
				local x, y = dxGetPixelsSize(pixels)
				local texture = dxCreateTexture(x,y, "argb")
				local pixels2 = dxGetTexturePixels(texture)
				local pady = 0
				for y2 = 0, y-1 do
					for x2 = 0, x-1 do
						local colors = {dxGetPixelColor(pixels, x2,y2)}
						if(colors[4] > 0) then
							dxSetPixelColor(pixels2, x2-pady, y2, colors[1],colors[2],colors[3],colors[4])
						end
					end
					pady = pady+incline
				end
				
				dxSetTexturePixels(texture, pixels2)
				VideoMemory["HUD"][index] = texture
			end
		end
		
		if(scale3D) then 
			w = w/scale3D 
			h = h/scale3D
		end
		if(centerX) then 
			if(centerX == "right") then 
				left = left-(w) 
			else
				left = left-(w/2) 
			end
		end
		
		if(centerY) then 
			if(centerY == "bottom") then 
				top = top-(h) 
			else
				top = top-(h/2)
			end
		end
		
		return dxDrawImage(left,top, w,h, VideoMemory["HUD"][index], 0, 0, 0, color) 
	end
end




function GenerateTextureCompleted(textures) 
	if(PEDChangeSkin == "intro") then
		call(getResourceFromName("Draw_Intro"), "StartIntro")
	end
end
addEvent("GenerateTextureCompleted", true)
addEventHandler("GenerateTextureCompleted", localPlayer, GenerateTextureCompleted)



function normalspeed(h,m,weather)
	if(isTimer(DrugsTimer)) then
		killTimer(DrugsTimer)
	end
	if(isTimer(SpunkTimer)) then
		killTimer(SpunkTimer)
	end

	for slot = 1, #DrugsEffect do
		destroyElement(DrugsEffect[slot])
	end
	setWeather(weather)
	setWindVelocity(0,0,0)
	setGameSpeed(1.2)
	setTime(h, m)
end
addEvent("normalspeed", true )
addEventHandler("normalspeed", localPlayer, normalspeed)


function onWasted(killer, weapon, bodypart)
	if(source == localPlayer) then 
		if(getPedOccupiedVehicle(localPlayer)) then
			ClientVehicleExit(localPlayer, getPedOccupiedVehicleSeat(localPlayer))
		end
		
	
		if(getElementData(localPlayer, "fishpos")) then
			triggerServerEvent("StopFish", localPlayer, localPlayer)
		end
		
		if(not DeathMatch) then
			setGameSpeed(0.7)
		end
		RemoveInventory()
		RespawnTimer = true
		PData["wasted"] = Text("ПОТРАЧЕНО")
		if(killer) then
			if(getElementType(killer) == "ped") then
				if(getElementData(killer, "attacker") == getPlayerName(localPlayer)) then
					setPedControlState(killer, "fire", false)
				end
				local KTeam = getElementData(killer, "team")				
				if(KTeam == "Полиция" or KTeam == "ФБР" or KTeam == "Военные") then
					PData["wasted"] = Text("СЛОМАНО")
				end
			elseif(getElementType(killer) == "player") then
				local KTeam = getTeamName(getPlayerTeam(killer))			
				if(KTeam == "Полиция" or KTeam == "ФБР" or KTeam == "Военные") then
					PData["wasted"] = Text("СЛОМАНО")
				end
			end
		end
	end
end
addEvent("onClientWastedLocalPlayer", true)
addEventHandler("onClientWastedLocalPlayer", getRootElement(), onWasted)
addEventHandler("onClientPlayerWasted", getRootElement(), onWasted)




function PlayerNewZone(zone, city, updateweather, interior)
	SetZoneDisplay(zone)
	triggerServerEvent("ZoneInfo", localPlayer, localPlayer, zone)
end
addEventHandler("PlayerNewZone", root, PlayerNewZone)



function PlayerVehicleEnter(theVehicle, seat)
	if(source == localPlayer) then 
		Targets["theVehicle"] = nil
		if(seat == 0) then
			PData["Driver"] = {
				["Handling"] = getVehicleHandling(theVehicle),
				["Distance"] = 0
			}
			PData["Driver"]["drx"], PData["Driver"]["dry"], PData["Driver"]["drz"] = getElementPosition(theVehicle)
			local name = getVehicleName(theVehicle)
			if(getElementData(theVehicle, "name")) then
				name = getElementData(theVehicle, "name")
			end
			if(getElementData(theVehicle, "year")) then
				name = name.." "..getElementData(theVehicle, "year")
			end
			if(getElementData(localPlayer, "City")) then
				SetZoneDisplay("#9b7c52"..name, true)
			else
				SetZoneDisplay("#66935C"..name, true)
			end
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter",getRootElement(),PlayerVehicleEnter)


function PlayerVehicleExit(theVehicle, seat)
	if(source == localPlayer) then 
		ChangeInfo() 
		if(seat == 0) then
			PData["Driver"] = nil
		end
	end
end
addEventHandler("onClientPlayerVehicleExit", getRootElement(), PlayerVehicleExit)



function ChangeInfo(text, ctime)
	if(isTimer(PData["ChangeInfoTimer"])) then
		killTimer(PData["ChangeInfoTimer"])
	end
	
	if(text) then
		PText["HUD"][3] = {text, 10, screenHeight/2, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale, "default-bold", "left", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}
	end
	
	if(ctime) then
		PData["ChangeInfoTimer"] = setTimer(function()
			PText["HUD"][3] = nil
		end, ctime, 1)
	end
end
addEvent("ChangeInfo", true)
addEventHandler("ChangeInfo", localPlayer, ChangeInfo)



function ChangeInfoAdv(text, ctime)
	if(isTimer(PData["ChangeInfoAdvTimer"])) then
		killTimer(PData["ChangeInfoAdvTimer"])
	end
	
	PText["HUD"][4] = {text, 10, screenHeight/1.7, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale, "default-bold", "left", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}
	

	if(ctime) then
		PData["ChangeInfoAdvTimer"] = setTimer(function()
			PText["HUD"][4] = nil
		end, ctime, 1)
	end
end
addEvent("ChangeInfoAdv", true)
addEventHandler("ChangeInfoAdv", localPlayer, ChangeInfoAdv)





function NextRaceMarker()
	table.remove(PData["Race"]["Track"], 1)
	if(PData["Race"]["Marker"]) then destroyElement(PData["Race"]["Marker"]) end
	if(PData["Race"]["Blip"]) then destroyElement(PData["Race"]["Blip"]) end
		
	if(#PData["Race"]["Track"] >= 1) then
		playSoundFrontEnd(43)
		PData["Race"]["Marker"] = createMarker(PData["Race"]["Track"][1][1], PData["Race"]["Track"][1][2], PData["Race"]["Track"][1][3]+2.5, "checkpoint", 20, 255, 0, 0, 170)
		setElementData(PData["Race"]["Marker"], "type", "Race")
		PData["Race"]["Blip"] = createBlipAttachedTo(PData["Race"]["Marker"],0,2,255,0,0, 255,0, 99999)
		if(PData["Race"]["Track"][2]) then
			setMarkerTarget(PData["Race"]["Marker"], PData["Race"]["Track"][2][1], PData["Race"]["Track"][2][2], PData["Race"]["Track"][2][3])
		end
	else	
		triggerServerEvent("RaceFinish", localPlayer, localPlayer, getTickCount()-PData["Race"]["Start"])
	end
end



function GetRacePosition()
	local pos = getArrSize(PData["Race"]["Racers"])
	local x,y,z = getElementPosition(localPlayer)
	local mydist = getDistanceBetweenPoints2D(x,y, PData["Race"]["Track"][#PData["Race"]["Track"]][1], PData["Race"]["Track"][#PData["Race"]["Track"]][2])
	for thePlayer, _ in pairs(PData["Race"]["Racers"]) do
		if(isElement(thePlayer)) then
			if(thePlayer ~= localPlayer) then
				x,y,z = getElementPosition(thePlayer)
				if(mydist < getDistanceBetweenPoints2D(x,y, PData["Race"]["Track"][#PData["Race"]["Track"]][1], PData["Race"]["Track"][#PData["Race"]["Track"]][2])) then
					pos = pos-1
				end
			end
		else
			pos = pos-1
		end
	end
	return pos
end


function StartRace(arr, players)
	PData["Race"] = {
		["Start"] = getTickCount(), 
		["Track"] = arr,
		["Racers"] = players
	}
	NextRaceMarker()
end
addEvent("StartRace", true)
addEventHandler("StartRace", localPlayer, StartRace)





function ToolTipRace(pos, message)
	ToolTipRaceText = {pos, message}
	setTimer(function() ToolTipRaceText = false end, 7000, 1)
end


function EndRace(pos, oldbest)
	if(PData["Race"]) then
		if(oldbest and pos) then
			local seconds = (getTickCount()-PData["Race"]["Start"])/1000
			local hours = math.floor(seconds/3600)
			local mins = math.floor(seconds/60 - (hours*60))
			local secs = math.floor(seconds - hours*3600 - mins *60)
			local msec = math.floor(((getTickCount()-PData["Race"]["Start"])-(secs*1000)-(mins*60000)-(hours*3600000))/10)
	
			
			oldbest = tonumber(oldbest)
			local seconds2 = (oldbest)/1000
			local hours2 = math.floor(seconds2/3600)
			local mins2 = math.floor(seconds2/60 - (hours2*60))
			local secs2 = math.floor(seconds2 - hours2*3600 - mins2 *60)
			local msec2 = math.floor(((oldbest)-(secs2*1000)-(mins2*60000)-(hours2*3600000))/10)
			
			ToolTipRace(pos, "#828FA0Твоё время: #EEEEEE"..string.format("%02.f", mins)..":"..string.format("%02.f", secs)..":"..string.format("%02.f", msec).."\n"..
			"#828FA0Рекорд трассы: #EEEEEE"..string.format("%02.f", mins2)..":"..string.format("%02.f", secs2)..":"..string.format("%02.f", msec2))
		else
			 MissionCompleted("#A2151AМИССИЯ ПРОВАЛЕНА!")
		end
	end
	
	
	for _, element in pairs(PData["Race"]) do
		if(isElement(element)) then
			destroyElement(element)
		end
	end
	PData["Race"] = nil
end
addEvent("EndRace", true)
addEventHandler("EndRace", localPlayer, EndRace)






function outputLoss(attacker)
	if(getElementType(attacker) == "vehicle") then attacker = getVehicleOccupant(attacker) end
	if(attacker) then
		if(attacker == localPlayer) then
			triggerServerEvent("DestroyObject", localPlayer, localPlayer, source)
		end
	end
end
addEventHandler("onClientObjectBreak", root, outputLoss)


function CreatePlayerArmas(thePlayer, model) 
	if(StreamData[thePlayer]["armas"]) then
		if(ModelPlayerPosition[tonumber(model)]) then
			StreamData[thePlayer]["armas"][model] = createObject(model, 0,0,0)
			if(tonumber(model) == 1025 or tonumber(model) == 1453 or tonumber(model) == 2900) then -- Уменьшаем запаску
				setObjectScale(StreamData[thePlayer]["armas"][model], 0.6)
			end
			setElementCollisionsEnabled(StreamData[thePlayer]["armas"][model], false)
			setElementDimension(StreamData[thePlayer]["armas"][model],getElementDimension(thePlayer))
			setElementInterior(StreamData[thePlayer]["armas"][model],getElementInterior(thePlayer))
		end
	end
end


function AddPlayerArmas(thePlayer, model)
	if(StreamData[thePlayer]) then
		StreamData[thePlayer]["armasplus"][model] = true
		UpdateArmas(thePlayer)
	end
end
addEvent("AddPlayerArmas", true)
addEventHandler("AddPlayerArmas", getRootElement(), AddPlayerArmas)


function RemovePlayerArmas(thePlayer, model)
	if(StreamData[thePlayer]) then
		StreamData[thePlayer]["armasplus"][model] = nil
		UpdateArmas(thePlayer)
	end
end
addEvent("RemovePlayerArmas", true)
addEventHandler("RemovePlayerArmas", getRootElement(), RemovePlayerArmas)




function getMatrixFromPoints(x,y,z,x3,y3,z3,x2,y2,z2)
	x3 = x3-x
	y3 = y3-y
	z3 = z3-z
	x2 = x2-x
	y2 = y2-y
	z2 = z2-z
	local x1 = y2*z3-z2*y3
	local y1 = z2*x3-x2*z3
	local z1 = x2*y3-y2*x3
	x2 = y3*z1-z3*y1
	y2 = z3*x1-x3*z1
	z2 = x3*y1-y3*x1
	local len1 = 1/math.sqrt(x1*x1+y1*y1+z1*z1)
	local len2 = 1/math.sqrt(x2*x2+y2*y2+z2*z2)
	local len3 = 1/math.sqrt(x3*x3+y3*y3+z3*z3)
	x1 = x1*len1 y1 = y1*len1 z1 = z1*len1
	x2 = x2*len2 y2 = y2*len2 z2 = z2*len2
	x3 = x3*len3 y3 = y3*len3 z3 = z3*len3
	return x1,y1,z1,x2,y2,z2,x3,y3,z3
end





function getBoneMatrix(ped,bone)
	local x,y,z,tx,ty,tz,fx,fy,fz
	x,y,z = getPedBonePosition(ped,bones[bone][1])
	if bone == 1 then
		local x6,y6,z6 = getPedBonePosition(ped,6)
		local x7,y7,z7 = getPedBonePosition(ped,7)
		tx,ty,tz = (x6+x7)*0.5,(y6+y7)*0.5,(z6+z7)*0.5
	elseif bone == 3 then
		local x21,y21,z21, x31,y31,z31
	
		x21,y21,z21 = getPedBonePosition(ped,21)
		x31,y31,z31 = getPedBonePosition(ped,31)
	
		if math.round(x21, 2) == math.round(x31, 2) and math.round(y21, 2) == math.round(y31, 2) and math.round(z21, 2) == math.round(z31, 2) then
			x21,y21,z21 = getPedBonePosition(ped,21)
			local _,_,rZ = getElementRotation(ped)
	
			tx,ty,tz = getPointInFrontOfPoint(x21, y21, z21, rZ, 0.0001)
		else
			tx,ty,tz = (x21+x31)*0.5,(y21+y31)*0.5,(z21+z31)*0.5
		end        
	else
		tx,ty,tz = getPedBonePosition(ped,bones[bone][2])
	end
	fx,fy,fz = getPedBonePosition(ped,bones[bone][3])
	local xx,xy,xz,yx,yy,yz,zx,zy,zz = getMatrixFromPoints(x,y,z,tx,ty,tz,fx,fy,fz)
	if bone == 1 or bone == 3 then xx,xy,xz,yx,yy,yz = -yx,-yy,-yz,xx,xy,xz end
	return xx,xy,xz,yx,yy,yz,zx,zy,zz
end








function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then return nil end
	if(alpha) then return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else return string.format("#%.2X%.2X%.2X", red,green,blue) end
end

function create3dtext(text,x,y,z,razmer,dist,color,font)
	local px,py,pz = getCameraMatrix()
    local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
    if distance <= dist then
		if(getPedOccupiedVehicle(localPlayer)) then
			if(isLineOfSightClear(x,y,z, px,py,pz, true, false, false, true, false, false, false, localPlayer)) then
				sx,sy = getScreenFromWorldPosition(x, y, z, 0.06)
				if not sx then return end
				MemText(text, sx, sy, color, razmer, font, razmer, 0, true, true, dist/(dist-distance))
			end
		else
			if(isLineOfSightClear(x,y,z, px,py,pz, true, true, false, true, false, false, false, localPlayer)) then
				sx,sy = getScreenFromWorldPosition(x, y, z, 0.06)
				if not sx then return end
				MemText(text, sx, sy, color, razmer, font, razmer, 0, true, true, dist/(dist-distance))
			end
		end
    end
end


function setDoingDriveby()
	detonateSatchels()
	if(getPedOccupiedVehicle(localPlayer)) then
		if not isPedDoingGangDriveby(localPlayer) then
			setPedDoingGangDriveby(localPlayer, true)
		else
			setPedDoingGangDriveby(localPlayer, false)
		end
	end
end


function DrawProgressBar(x,y,count,bool,size)
	local size2 = size-10
	dxDrawRectangle(x, y, size*scalex, 31*scaley , tocolor(0, 0, 0, 255))
	dxDrawRectangle(x+(5*scalex), y+(6*scaley), size2*scalex, 19*scaley , tocolor(100, 100, 100, 255))
	dxDrawRectangle(x+(5*scalex), y+(6*scaley), ((count/1000)*size2)*scalex, 19*scaley, tocolor(255, 255, 255, 255))
	
	if(bool) then
		if(bool == 0) then return true end
		if(bool > 0) then
			if(bool < 100) then
				bool = 100
			end
			
			if(count+bool > 1000) then
				bool = 1000-count
				if(bool == 0) then
					count = 900
					bool = 100
				end
			end
			dxDrawRectangle((x+(5*scalex))+(((count/1000)*size2)*scalex), y+(6*scaley), (((bool)/1000)*size2)*scalex, 19*scaley, tocolor(69, 200, 59, 255))
		else
			if(bool > -100) then
				bool = -100
			end
			
			if(count+bool < 0) then
				bool = -count
				if(bool == 0) then
					count = 100
					bool = -100
				end
			end
			dxDrawRectangle(x+(5*scalex)+(((count/1000)*size2)*scalex), y+(6*scaley), ((bool/1000)*size2)*scalex, 19*scaley, tocolor(255, 0, 0, 255))
		end
	end
end


function PlaySFXSound(event)
	if(event==1) then
		playSFX("script", 146, 4, false)--Вступление в картель
	elseif(event==2) then
		playSFX("script", 16, 3, false)--Вступление в Гроув-стрит
	elseif(event==4) then
		playSFX("script", 150, 0, false)--ремонт
	elseif(event==5) then
		playSFX("script", 144, 1, false)
	elseif(event==6) then
		playSFX("script", 205, 1, false)--Деньги
	elseif(event==7) then
		playSFX("genrl", 52, 19, false)--Гонка
	elseif(event==8) then
		playSFX("script", 61, 0, false)--piss
	elseif(event==9) then
		playSFX("genrl", 131, 2, false)--engine starter
	elseif(event==10) then
	elseif(event==11) then 
		playSFX("script", 151, 0, false) -- Еда
	elseif(event==12) then
		playSFX("script", 8, 0, false) -- Звонок набор
	elseif(event==13) then
		playSFX("script", 105, 0, false) -- Звонок вызов
	elseif(event==14) then
		playSFX("genrl", 52, 15, false)--levelup
	elseif(event==15) then
		playSFX("genrl", 52, 17, false)--инвентарь
	elseif(event==16) then
		playSFX("genrl", 131, 43, false)--Открыть дверь
	elseif(event==17) then
		playSFX("genrl", 131, 38, false)--закрыть дверь
	elseif(event==18) then
		playSFX("genrl", 75, 1, false)--Миссия выполнена
	end
end
addEvent("PlaySFXSoundEvent", true)
addEventHandler("PlaySFXSoundEvent", localPlayer, PlaySFXSound)




addEventHandler("onClientVehicleExplode", getRootElement(), function()
	if(isElementSyncer(source)) then
		local x,y,z = getElementPosition(source)
		local rand = math.random(0, 4)
		if(rand > 0) then
			local arr = {}
			for slot = 1, rand do
				local randx, randy = math.random(-5,5), math.random(-5,5)
				z = getGroundPosition(x+randx,y+randy,z)
				arr[#arr+1] = {x+randx, y+randy, z}
			end
			triggerServerEvent("CreateFire", localPlayer, toJSON(arr))
		end
	end
	if(getElementModel(source) == 592) then
		local x,y,z = getElementPosition(source)
		for slot = 1, 40 do
			createExplosion(x+(math.random(-40,40)), y+(math.random(-40,40)), z, 6)
			createEffect("explosion_large", x+(math.random(-40,40)), y+(math.random(-40,40)), z)
		end
	end
end)


function PlayerSayEvent(message,thePlayer)
	PlayersMessage[thePlayer]=message
	if(isTimer(timers[thePlayer])) then
		killTimer(timers[thePlayer])
	end
	timers[thePlayer] = setTimer(function()
		PlayersMessage[thePlayer]=nil
	end, 1000+(#message*150), 1)
end
addEvent("PlayerSayEvent", true)
addEventHandler("PlayerSayEvent", localPlayer, PlayerSayEvent)




function PlayerActionEvent(message,thePlayer)
	PlayersAction[thePlayer]=message
	if(isTimer(timersAction[thePlayer])) then
		killTimer(timersAction[thePlayer])
	end
	timersAction[thePlayer] = setTimer(function()
		PlayersAction[thePlayer]=nil
	end, 300+(#message*75), 1)
end
addEvent("PlayerActionEvent", true)
addEventHandler("PlayerActionEvent", localPlayer, PlayerActionEvent)





--[Необходимое уважение = {Звание, id скина}
local BandRangs = {
	["Военные"] = {
		[1] = {0, "Призывник", 312},
		[2] = {30, "Контрактник", 287},
	},
	["Гроув-стрит"] = {
		[1] = {0, "Укурыш", 293},
		[2] = {30, "Красавчик Флиззи", 105},
		[3] = {60, "Гангстерлительный", 106},
		[4] = {120, "Джин Рамми", 107},
		[5] = {180, "Big Smoke", 269},
		[6] = {310, "Консильери", 270}
	},
	["Баллас"] = {
		[1] = {0, "Жаба", 102},
		[2] = {30, "Гусь", 103},
		[3] = {60, "Бык", 104}
	},
	["Колумбийский картель"] = {
		[1] = {0, "La Mugre", 222},
		[2] = {50, "Sombras", 95},
		[3] = {75, "Sureno", 30},
		[4] = {120, "Cacos", 242},
		[5] = {180, "Guerrero", 179},
		[6] = {250, "Лейтенант колумбийского картеля", 43}
	},
	["Вагос"] = {
		[1] = {0, "Отмычка", 108},
		[2] = {30, "Браток", 109},
		[3] = {60, "Комендант", 110}
	},
	["Байкеры"] = {
		[1] = {0, "Тусовщик", 181},
		[2] = {30, "Вольный ездок", 247},
		[3] = {75, "Шустрила", 248},
		[4] = {130, "Дорожный капитан", 100}
	},
	["Русская мафия"] = {
		[1] = {0, "Клоп", 111},
		[2] = {30, "Вор", 112},
		[3] = {75, "Пахан", 113},
	},
	["Ацтекас"] = {
		[1] = {0, "Сопляк", 114},
		[2] = {30, "Кирпич", 115},
		[3] = {75, "Башка", 116},
		[4] = {130, "Громоотвод", 292}
	},
	["Триады"] = {
		[1] = {0, "Моль", 117},
		[2] = {30, "Баклан", 118},
		[3] = {75, "Зам. Лидера", 120},
		[4] = {130, "Желтый дракон (Лидер)", 294}
	},
	["Da Nang Boys"] = {
		[1] = {0, "Куми-ин", 121},
		[2] = {30, "Сансита", 122},
		[3] = {75, "Дэката", 123},
		[4] = {130, "Кумитё (Лидер)", 169}
	},
	["Деревенщины"] = {
		[1] = {0, "Опущенный", 162},
		[2] = {50, "Чёрт", 160},
		[3] = {75, "Шнырь", 159},
		[4] = {120, "Блатной", 161},
		[5] = {180, "Папаша", 158}
	},
	["Рифа"] = {
		[1] = {0, "Упырь", 173},
		[2] = {30, "Баклан", 174},
		[3] = {75, "Капореджиме", 175},
	},
	["Уголовники"] = {
		[1] = {0, "Потраченный", 252}, 
		[2] = {25, "Черт", 213}, 
		[3] = {50, "Шпана", 268}, 
		[4] = {100, "Блатной", 62}, 
	}, 
	["Мирные жители"] = {
		[1] = {0, "Житель", 252}
	}, 
}


function GetBandRang(gang,reps)
	local maks = {BandRangs[gang][1]}
	for rang, k in ipairs(BandRangs[gang]) do
		if(k[1] <= reps) then
			maks[1] = k
		else
			if(rang ~= 1) then
				maks[2] = k
				break
			end
		end
	end
	return maks
end















addEventHandler("onClientVehicleCollision", root,
    function(HitElement,force, bodyPart, x, y, z, nx, ny, nz, hitElementForce)
         if(source == getPedOccupiedVehicle(localPlayer)) then
			if(force > 500) then
				--triggerServerEvent("ForceRemoveFromVehicle", localPlayer, localPlayer, force/1000)
			end
         end
    end
)




local PosVar = {
	[1] = "ый",
	[2] = "ой",
	[3] = "ий",
	[4] = "ый",
	[5] = "ый",
	[6] = "ой",
	[7] = "ой",
	[8] = "ой",
}

function DrawPlayerMessage()
	local x,y,z = getElementPosition(localPlayer)
	
	local sx, sy, font, tw, th, color
	
	for key, arr in pairs(PData["MultipleAction"]) do
		local text = arr[2]
		if(text) then
			font = "sans"
			tw = dxGetTextWidth(text, NewScale*1.8, font, true)
			th = dxGetFontHeight(NewScale*1.8, font)

			dxDrawBorderedText(text.." ["..key.."]", arr[3]-tw/2, arr[4]-th/2, screenWidth, screenHeight, tocolor(255, 153, 0 , 255), NewScale*1.8, font, "left", nil, nil, nil, nil, true)		
		end
	end
	PData["MultipleAction"] = {}
		
	if(PEDChangeSkin == "play" and initializedInv and not isPlayerMapForced()) then
		if(tuningList) then
			sx,sy = (screenWidth/2.55), screenHeight-(150*scaley)
		
			if(STPER) then
				local TopSpeed, Power, Acceleration, Brake, Control = 0,0,0,0,0
				if(NEWPER) then
					TopSpeed = GetVehicleTopSpeed(NEWPER["engineAcceleration"], NEWPER["dragCoeff"], NEWPER["maxVelocity"])-GetVehicleTopSpeed(STPER["engineAcceleration"], STPER["dragCoeff"], STPER["maxVelocity"])
					Power = GetVehiclePower(NEWPER["mass"], NEWPER["engineAcceleration"])-GetVehiclePower(STPER["mass"], STPER["engineAcceleration"])
					Acceleration = GetVehicleAcceleration(NEWPER["engineAcceleration"], NEWPER["tractionMultiplier"])-GetVehicleAcceleration(STPER["engineAcceleration"], STPER["tractionMultiplier"])
					Brake = GetVehicleBrakes(NEWPER["brakeDeceleration"], NEWPER["tractionLoss"])-GetVehicleBrakes(STPER["brakeDeceleration"], STPER["tractionLoss"])
					Control = GetVehicleControl(NEWPER["tractionBias"])-GetVehicleControl(STPER["tractionBias"])
				end
				DrawProgressBar(sx, sy, (GetVehicleTopSpeed(STPER["engineAcceleration"], STPER["dragCoeff"], STPER["maxVelocity"]))+TopSpeed,TopSpeed,200)
				DrawProgressBar(sx+(300*scaley), sy, GetVehiclePower(STPER["mass"], STPER["engineAcceleration"])+Power,Power,200) --При максимальной мощности 348 лс.
				DrawProgressBar(sx+(600*scaley), sy, GetVehicleAcceleration(STPER["engineAcceleration"], STPER["tractionMultiplier"])+Acceleration,Acceleration,200)
				DrawProgressBar(sx+(900*scaley), sy, GetVehicleBrakes(STPER["brakeDeceleration"], STPER["tractionLoss"])+Brake,Brake,200)
				DrawProgressBar(sx+(900*scaley), sy-(130*scaley), GetVehicleControl(STPER["tractionBias"])+Control,Control,200)
			
			end
		
			sx,sy = guiGetScreenSize()
			local S = 60
			local PosX=0
			local PosY=sy-((sy/S)*13)

			for slot = 1, #ColorArray do
				local r,g,b = hex2rgb(ColorArray[slot])
				if(slot <= 10) then
					dxDrawRectangle(PosX+((sx/S)*(slot-1)), PosY, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 20) then
					dxDrawRectangle(PosX+((sx/S)*(slot-11)), PosY+(sy/S), sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 30) then
					dxDrawRectangle(PosX+((sx/S)*(slot-21)), PosY+(sy/S)*2, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 40) then
					dxDrawRectangle(PosX+((sx/S)*(slot-31)), PosY+(sy/S)*3, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 50) then
					dxDrawRectangle(PosX+((sx/S)*(slot-41)), PosY+(sy/S)*4, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 60) then
					dxDrawRectangle(PosX+((sx/S)*(slot-51)), PosY+(sy/S)*5, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 70) then
					dxDrawRectangle(PosX+((sx/S)*(slot-61)), PosY+(sy/S)*6, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 80) then
					dxDrawRectangle(PosX+((sx/S)*(slot-71)), PosY+(sy/S)*7, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 90) then
					dxDrawRectangle(PosX+((sx/S)*(slot-81)), PosY+(sy/S)*8, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 100) then
					dxDrawRectangle(PosX+((sx/S)*(slot-91)), PosY+(sy/S)*9, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 110) then
					dxDrawRectangle(PosX+((sx/S)*(slot-101)), PosY+(sy/S)*10, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 120) then
					dxDrawRectangle(PosX+((sx/S)*(slot-111)), PosY+(sy/S)*11, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 130) then
					dxDrawRectangle(PosX+((sx/S)*(slot-121)), PosY+(sy/S)*12, sx/S, sy/S, tocolor(r, g, b, 255))
				end
			end
			
			
			local PosX=0+(sx/S*11)

			for slot = 1, #ColorArray do
				local r,g,b = hex2rgb(ColorArray[slot])
				if(slot <= 10) then
					dxDrawRectangle(PosX+((sx/S)*(slot-1)), PosY, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 20) then
					dxDrawRectangle(PosX+((sx/S)*(slot-11)), PosY+(sy/S), sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 30) then
					dxDrawRectangle(PosX+((sx/S)*(slot-21)), PosY+(sy/S)*2, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 40) then
					dxDrawRectangle(PosX+((sx/S)*(slot-31)), PosY+(sy/S)*3, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 50) then
					dxDrawRectangle(PosX+((sx/S)*(slot-41)), PosY+(sy/S)*4, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 60) then
					dxDrawRectangle(PosX+((sx/S)*(slot-51)), PosY+(sy/S)*5, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 70) then
					dxDrawRectangle(PosX+((sx/S)*(slot-61)), PosY+(sy/S)*6, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 80) then
					dxDrawRectangle(PosX+((sx/S)*(slot-71)), PosY+(sy/S)*7, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 90) then
					dxDrawRectangle(PosX+((sx/S)*(slot-81)), PosY+(sy/S)*8, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 100) then
					dxDrawRectangle(PosX+((sx/S)*(slot-91)), PosY+(sy/S)*9, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 110) then
					dxDrawRectangle(PosX+((sx/S)*(slot-101)), PosY+(sy/S)*10, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 120) then
					dxDrawRectangle(PosX+((sx/S)*(slot-111)), PosY+(sy/S)*11, sx/S, sy/S, tocolor(r, g, b, 255))
				elseif(slot <= 130) then
					dxDrawRectangle(PosX+((sx/S)*(slot-121)), PosY+(sy/S)*12, sx/S, sy/S, tocolor(r, g, b, 255))
				end
			end	
		else -- Не в тюнинге
			for _, thePickup in pairs(getElementsByType("pickup", getRootElement(), true)) do
				local owner = getElementData(thePickup, "bizowner") or ""
				if(owner == getPlayerName(localPlayer)) then
					if(getElementData(thePickup, "money")) then
						local x,y,z = getElementPosition(thePickup)
						create3dtext("$"..getElementData(thePickup, "money"), x,y,z+0.5, NewScale*3, 60, tocolor(54, 228, 70, 150), "pricedown")
					end
				end
			end
		

			if(PData["Interface"]["Inventory"]) then
				local sx, sy, font, tw, th, color
				if(PEDChangeSkin == "play" and initializedInv and not isPedDead(localPlayer) and not isPlayerMapForced()) then
					if(PData["BizControlName"]) then
						dxDrawRectangle(640*scalex, 360*scaley, 950*scalex, 525*scaley, tocolor(20, 25, 20, 245))
						dxDrawBorderedText(PData["BizControlName"][2], 660*scalex, 330*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*2, "default-bold", "left", "top", false, false, false, true)	
					elseif(BANKCTL) then
						dxDrawRectangle(640*scalex, 360*scaley, 950*scalex, 525*scaley, tocolor(25, 20, 20, 245))
						dxDrawBorderedText(BANKCTL, 660*scalex, 330*scaley, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*2, "default-bold", "left", "top", false, false, false, true)	
					end
				end	
			end
			
			
			if(PData['dialogPed']) then
				CreateTarget(PData['dialogPed'])
			end
			
			if(dialogTitle) then
				if(not isTimer(dialogActionTimer)) then
					dxDrawImage(0, 0, screenWidth, screenHeight, VideoMemory["HUD"]["Cinema"])
					dxDrawText(dialogTitle, 0, screenHeight/1.12, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*1.2, "default-bold", "center", "top", nil, nil, nil, true)
				end
			end
					
			if(ToolTipText ~= "") then
				local linecount = 1
				for i in string.gfind(ToolTipText, "\n") do
				   linecount = linecount + 1
				end
				font = "default-bold"
				tw = dxGetTextWidth(ToolTipText, scale, font, true)+(26*scalex)
				th = (dxGetFontHeight(scale, font)*linecount)+(20*scaley)
				dxDrawRectangle(25*scalex, 325*scaley, tw, th, tocolor(0, 0, 0, 180))
				dxDrawText(ToolTipText, 25*scalex+(13*scalex), 325*scaley+(9*scaley), 0, 0, tocolor(255,255,255,255), scale, font, "left", "top", false, false, false, true)
			end
			
			
			if(ToolTipRaceText) then
				local linecount = 1
				for i in string.gfind(ToolTipRaceText[2], "\n") do
				   linecount = linecount + 1
				end
				font = "default-bold"
				tw = dxGetTextWidth(ToolTipRaceText[2], scale*1.5, font, true)+(26*scalex)
				th = (dxGetFontHeight(scale*1.8, font)*linecount)+(20*scaley)
				dxDrawRectangle(screenWidth/2-(tw/2), screenHeight/1.4, tw+(50*scalex), th+(50*scaley), tocolor(0, 0, 0, 180))
				
				dxDrawBorderedText(ToolTipRaceText[1],screenWidth/2-(tw/2)+(15*scalex), screenHeight/1.4-(30*scaley), 0, 0, tocolor(255,255,255,255), scale*2, font, "left", "top", false, false, false, true)
				dxDrawBorderedText(ToolTipRaceText[2],screenWidth/2-(tw/2)+(33*scalex), screenHeight/1.4+(40*scaley), 0, 0, tocolor(130,143,160,255), scale*1.5, font, "left", "top", false, false, false, true)
			end
			
			
			if(PData["Interface"]["Full"]) then
				local line = 1
				for v,k in pairs(GPSObject) do
					local x2,y2,z2 = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)/2
					if(dist >= 1000) then
						dist = math.round((dist/1000), 1).." "..Text("км")
					else
						dist = math.round(dist, 0).." "..Text("м")
					end
					local _,_,rz = getElementRotation(localPlayer)
					local marrot = GetMarrot(findRotation(x,y,x2,y2),rz)
					if(x2 ~= 228 and y2 ~= 228 and z2 ~= 228) then
						if(not PData['Minimize']) then
							dxDrawImage(screenWidth-dxGetTextWidth(getElementData(v, "info").." #A9A9A9"..dist, scale, "default-bold", true)-(40*NewScale), screenHeight/2.7+(dxGetFontHeight(scale, "default-bold")*line), dxGetTextWidth("↑", scale, "default-bold", false), dxGetFontHeight(scale, "default-bold"), DrawArrow(), marrot)
						end
						dist = " #A9A9A9"..dist.."\n"
					else
						dist = ""
					end
					dxDrawBorderedText(getElementData(v, "info")..dist, 0, screenHeight/2.7+(dxGetFontHeight(scale, "default-bold")*line), screenWidth-(10*NewScale), screenHeight, tocolor(200, 200, 200, 255), scale, "default-bold", "right", "top", nil, nil, nil, true)
					line = line+1
				end
				
			end

		
			if(RobAction) then
				DrawProgressBar(screenWidth-430*scalex, 420*scaley, RobAction[1], RobAction[2], 250)
				local advtext = ""
				if(RobAction[2]) then
					advtext = "+"..(RobAction[2]/10).." "
				end
				dxDrawBorderedText(advtext.."ДАВЛЕНИЕ", screenWidth, 455*scaley, screenWidth-200*scalex, screenHeight, tocolor(255, 255, 255, 255), scale, "default-bold", "right", "top", nil, nil, nil, true)
			end
			
			if cameraimage then
				dxDrawImage(25*scale, 150*scale, 150*scale, 100*scale, cameraimage) -- Камера
			end
			
			if(PData["helpmessage"]) then
				dxDrawBorderedText(Text(PData["helpmessage"]), screenWidth, screenHeight-(200*scalex), 0, 0, tocolor(255, 255, 255, 255), NewScale*2.3, "sans", "center", "top", false, false, false, true, true, 0, 0, 0)
			end
			
			if(PData["HarvestDisplay"]) then
				local HS = VehicleSpeed*10
				if(HS > 390) then HS = 390 end
				sx,sy = 400*NewScale, 40*NewScale
				dxDrawRectangle(screenWidth/2-(sx/2)-(2*NewScale), screenHeight/1.2-(sy/2)-(2*NewScale), sx+(4*NewScale),sy+(4*NewScale), tocolor(0, 0, 0, 150))
				dxDrawRectangle(screenWidth/2-(sx/2)+(175*NewScale), screenHeight/1.2-(sy/2), 50*NewScale,sy, tocolor(181, 212, 82, 200))
				
				dxDrawRectangle(screenWidth/2-(sx/2)+(HS*NewScale), screenHeight/1.2-(sy/2), 10*NewScale,sy, tocolor(255, 255, 255, 200))
				dxDrawRectangle(screenWidth/2-(sx/2)+(HS*NewScale), screenHeight/1.2+(sy/2), 10*NewScale, -(NewScale*PData["HarvestDisplay"]), tocolor(255, 153, 0, 255))
			end
			
			local wanted = getElementData(localPlayer, "WantedLevel")
			if(getElementData(localPlayer, "WantedLevelPrison")) then wanted = getElementData(localPlayer, "WantedLevelPrison") end
			local TotalDamage = getElementData(localPlayer, "Damage")
			if(PData["Interface"]["WantedLevel"] and not getElementData(localPlayer, "AEZAKMI")) then
				if(PData["WantedLevel"]) then
					if(PData["WantedLevel"] ~= wanted) then
						VideoMemory["HUD"]["Wanted"] = nil
						PData['WantedFlashing'] = setTimer(function() end, 100, 7)
					end
				end
				PData["WantedLevel"] = wanted
				local posx, posy = screenWidth-(screenWidth/4.5), screenHeight/3
				if(getPedStat(localPlayer, 24) <= 573) then posx, posy = screenWidth-(screenWidth/4.5), screenHeight/3.4 end
				if(tonumber(wanted)) then
					local flash = false
					if(isTimer(PData['WantedFlashing'])) then
						local _, executesRemaining, _ = getTimerDetails(PData['WantedFlashing'])
						if(math.fmod(executesRemaining, 2) ~= 0) then
							flash = true
						end
					end
				
					if(not PData['Minimize']) then
						wanted = tonumber(wanted)
						tw, _ = dxGetTextWidth("★★★★★★", scale, "pricedown", false), dxGetFontHeight(scale, "pricedown")
						
						dxDrawImage(posx, posy, dxGetTextWidth("★★★★★★", scale, "pricedown", false), dxGetFontHeight(scale, "pricedown"), VideoMemory["HUD"]["WantedBackground"])
						if(not flash) then
							dxDrawImage(posx+(tw*((6-wanted)/6)), posy, dxGetTextWidth("★★★★★★", scale, "pricedown", false), dxGetFontHeight(scale, "pricedown"), DrawWanted(wanted))
						end
					end
					if(TotalDamage) then
						--MemText("Ущерб: $"..TotalDamage, posx+dxGetTextWidth("★★★★★★", scale, "pricedown", false), posy+dxGetFontHeight(scale, "pricedown"), tocolor(200, 0, 0, 210), NewScale*1.5, "default-bold", NewScale*1.5, 0, "right", false)
					end
				else
					dxDrawBorderedText(wanted, posx, posy, screenWidth, screenHeight, tocolor(200, 200, 200, 180), scale, "default-bold", "left", "top", nil, nil, nil, true)
				end
			end
		

		
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if(PData["Driver"] and theVehicle and PData["Interface"]["Full"]) then
				tick = getTickCount()
				local angulo,velocidad = angle()
				
				local tempBool = tick - (idleTime or 0) < 750
				if not tempBool and score ~= 0 then
					score = 0
				end
				
				if angulo ~= 0 then
					if tempBool then
						score = score + math.floor(angulo*velocidad)*mult
					else
						score = math.floor(angulo*velocidad)*mult
					end

					idleTime = tick
				end
				

				if tick - (idleTime or 0) < 50 then
					if(score > 500) then
						AddRage(1)
						RageInfo("Дрифт +"..math.round(score/100, 0))
					end
				end

				
				local vx, vy, vz = getElementVelocity(theVehicle)
				VehicleSpeed = (vx^2 + vy^2 + vz^2)^(0.5)*156

				local MaxRPM = GetVehicleMaxRPM(PData["Driver"]["Handling"]["engineAcceleration"])
				local RPMMeter = false
				local RPMDate = false 
				
				if(MaxRPM <= 4000) then
					RPMMeter = 45
					RPMDate = 4000
				elseif(MaxRPM > 4000 and MaxRPM <= 6000) then
					RPMMeter = 37.5
					RPMDate = 6000
				elseif(MaxRPM > 6000 and MaxRPM <= 7000) then
					RPMMeter = 32.1
					RPMDate = 7000
				elseif(MaxRPM > 7000 and MaxRPM <= 8000) then
					RPMMeter = 28
					RPMDate = 8000
				elseif(MaxRPM > 8000 and MaxRPM <= 10000) then
					RPMMeter = 22.5
					RPMDate = 10000
				elseif(MaxRPM > 10000 and MaxRPM <= 12000) then
					RPMMeter = 18.7
					RPMDate = 12000
				elseif(MaxRPM > 12000 and MaxRPM <= 14000) then
					RPMMeter = 16
					RPMDate = 14000
				elseif(MaxRPM > 14000 and MaxRPM <= 16000) then
					RPMMeter = 14
					RPMDate = 16000
				elseif(MaxRPM > 16000 and MaxRPM <= 18000) then
					RPMMeter = 12.5
					RPMDate = 18000
				elseif(MaxRPM > 18000 and MaxRPM <= 20000) then
					RPMMeter = 11.2
					RPMDate = 20000
				end
				
				if(RPMDate) then
					local RPM = (225*(getVehicleRPM(theVehicle, PData["Driver"]["Handling"]["engineAcceleration"], PData["Driver"]["Handling"]["dragCoeff"], PData["Driver"]["Handling"]["numberOfGears"])/RPMDate))
					local RedRPMZone = 225*((MaxRPM/RPMDate))
					if(SlowTahometer < RPM) then
						SlowTahometer = SlowTahometer+(RPM-SlowTahometer)/20
					elseif(SlowTahometer > RPM) then
						SlowTahometer = SlowTahometer-(SlowTahometer-RPM)/20
					end
					sx = screenWidth-(150*scalex)
					sy = screenHeight-(247*scaley)
					local TS = NewScale
					dxDrawCircle(sx,sy, 108*TS, 0, 360, tocolor(0,0,0,50))
					dxDrawCircleCustom(sx,sy, 100*TS, 5*TS, 4, 120, 120+RedRPMZone, tocolor(0,0,0,200))
					dxDrawCircleCustom(sx,sy, 100*TS, 5*TS, 4, 120+RedRPMZone, 345, tocolor(255,51,51,200))
					dxDrawCircleCustom(sx,sy, 100*TS, 5*TS, 4, 120, 120+math.floor(SlowTahometer), tocolor(255,255,255,255))
					if(getVehicleNitroCount(theVehicle)) then
						dxDrawCircleCustom(sx,sy, 120*TS, 9*TS, 1, 118, 158, tocolor(0,0,0,20))
						dxDrawCircleCustom(sx,sy, 120*TS, 5*TS, 4, 120, 157, tocolor(100,100,100,200))
						dxDrawCircleCustom(sx,sy, 120*TS, 5*TS, 4, 120, 120+(3.7*getVehicleNitroCount(theVehicle)), tocolor(40,200,255,160))
					end
					
					dxDrawCircleCustom(sx,sy, 120*TS, 9*TS, 1, 158, 345, tocolor(0,0,0,20))
					dxDrawCircleCustom(sx,sy, 120*TS, 5*TS, 4, 160, 344, tocolor(100,100,100,200))
					dxDrawCircleCustom(sx,sy, 120*TS, 5*TS, 4, 160, 160+(184*(PData['rage']/1000)), tocolor(255,200,40,160))
					
					dxDrawCircleCustom(sx,sy, 90*TS, 2*TS, RPMMeter, 120, 345, tocolor(255,255,255,255), nil, true)
					dxDrawCircleCustom(sx,sy, 87*TS, 1*TS, 0.8, 120, 345, tocolor(255,255,255,255))
					
					dxDrawCircle(sx,sy, 65*TS, 0, 360, tocolor(0,0,0,150))
					dxDrawText(getVehicleGear(theVehicle, PData["Driver"]["Handling"]["engineAcceleration"], PData["Driver"]["Handling"]["dragCoeff"], PData["Driver"]["Handling"]["numberOfGears"]), sx,sy-(30*scaley),sx,sy-(30*scaley), tocolor(255,255,255,255), scale*2.5, "default-bold", "center", "center")

					if(getElementData(theVehicle, "Fuel")) then
						local handlingTable = getOriginalHandling(getElementModel(theVehicle))
						dxDrawCircleCustom(sx,sy, 90*TS, 4*TS, 1, 10, 90, tocolor(0,0,0,60))
						local maxfuel = math.floor(handlingTable["mass"]/30)
						dxDrawCircleCustom(sx,sy, 90*TS, 4*TS, 1, 10+math.floor(80-(80*(getElementData(theVehicle, "Fuel")/maxfuel))), 90, tocolor(255,255,255,60))
					end

					dxDrawText(string.format("%03.f", VehicleSpeed), sx,sy+(15*scaley),sx,sy+(15*scaley), tocolor(120,120,120,255), scale*1.25, "default-bold", "center", "center")
					dxDrawText(Text("КМ/Ч"), sx,sy+(45*scaley),sx,sy+(45*scaley), tocolor(120,120,120,255), scale/1.5, "default-bold", "center", "center")
				
					if(PData["Race"]) then
						local pos = GetRacePosition()
						dxDrawRectangle(sx-(327*scalex),sy-(82*scaley), 139*NewScale, 154*NewScale, tocolor(0,0,0))
						dxDrawRectangle(sx-(325*scalex),sy-(80*scaley), 135*NewScale, 150*NewScale, tocolor(121,137,153))
						dxDrawRectangle(sx-(320*scalex),sy-(75*scaley), 125*NewScale, 140*NewScale, tocolor(0,0,0))
						dxDrawText(pos, sx-(305*scalex),sy-(82*scaley),0,0, tocolor(121,137,153,255), NewScale*7, "default-bold", "left", "top")
						dxDrawText(PosVar[pos] or "ый", sx-(255*scalex),sy-(70*scaley),0,0, tocolor(121,137,153,255), NewScale*3, "default-bold", "left", "top")
						dxDrawText("/"..getArrSize(PData["Race"]["Racers"]), sx-(255*scalex),sy-(35*scaley),0,0, tocolor(121,137,153,255), NewScale*3, "default-bold", "left", "top")
						
						local seconds = (getTickCount()-PData["Race"]["Start"])/1000
						local hours = math.floor(seconds/3600)
						local mins = math.floor(seconds/60 - (hours*60))
						local secs = math.floor(seconds - hours*3600 - mins *60)
						local msec =  math.floor(((getTickCount()-PData["Race"]["Start"])-(secs*1000)-(mins*60000)-(hours*3600000))/10)
						dxDrawText(string.format("%02.f", mins)..":"..string.format("%02.f", secs), sx-(257*scalex), sy+(5*scaley), sx-(257*scalex), sy+(5*scaley), tocolor(121,137,153,255), NewScale*3, "default-bold", "center", "top")

					end
				end
				
				local hardtruck = theVehicle
				if(getVehicleTowedByVehicle(theVehicle)) then
					hardtruck = getVehicleTowedByVehicle(theVehicle)
				end
				
				if(getElementData(hardtruck, "product")) then
					ChangeInfo("Груз: "..getElementData(hardtruck, "product").."\nСостояние: "..math.floor(getElementHealth(hardtruck)/10).."%", 5000)
				end			
			end
		end
	else
		tw = dxGetTextWidth(PlayerChangeSkinTeam, scale*1.4, "bankgothic", true)
		th = dxGetFontHeight(scale*1.4, "bankgothic")
		dxDrawBorderedText(PlayerChangeSkinTeam, screenWidth/2-tw/2.15, screenHeight-(screenHeight-th/10), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*1.4, "bankgothic", nil, nil, nil, nil, nil, true)
		
		
		tw = dxGetTextWidth(PlayerChangeSkinTeamRang, scale/1.2, "bankgothic", true)
		th = dxGetFontHeight(scale*1, "bankgothic")
		dxDrawBorderedText(PlayerChangeSkinTeamRang, screenWidth/2-tw/2.15, screenHeight-(screenHeight-th*1.5), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale/1.2, "bankgothic", nil, nil, nil, nil, nil, true)
		

		th = dxGetFontHeight(scale*2, "sans")
		tw = dxGetTextWidth(PlayerChangeSkinTeamRespect, scale*2, "sans", true)
		dxDrawBorderedText(PlayerChangeSkinTeamRespect, screenWidth/2-tw/2.15, screenHeight-(th*2.5), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*2, "sans", nil, nil, nil, nil, nil, true)
		tw = dxGetTextWidth(PlayerChangeSkinTeamRespectNextLevel, scale*2, "sans", true)
		dxDrawBorderedText(PlayerChangeSkinTeamRespectNextLevel, screenWidth/2-tw/2.15, screenHeight-(th*1.5), screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*2, "sans", nil, nil, nil, nil, nil, true)
	end
	
	if(PING or RespectMsg) then
		local teams = {"Мирные жители", "Вагос", "Баллас", "Уголовники", "Полиция", "Гроув-стрит"}
		
		local FH = dxGetFontHeight(scale, "clear")*1.1
		local idouble = 0
		if(RespectMsg and not PING) then
			for v, key in pairs (RespectMsg) do
				if(tonumber(v)) then
					v=tonumber(v)
					dxDrawBorderedText(Text(SkillName[v]), 0, 530*scaley+(FH*(idouble)), screenWidth-170*scalex, 0, tocolor(255, 255, 255, 255), scale, "clear", "right", "top", false, false, false, true)
					DrawProgressBar(screenWidth-160*scalex, 530*scaley+(FH*(idouble)), getPedStat(localPlayer, v), key, 150)
				else
					dxDrawBorderedText(getTeamGroupColor(v)..Text(getTeamGroup(v)), 0, 530*scaley+(FH*(idouble)), screenWidth-170*scalex, 0, tocolor(255, 255, 255, 255), scale, "clear", "right", "top", false, false, false, true)
					DrawProgressBar(screenWidth-160*scalex, 530*scaley+(FH*(idouble)), 500+(getTeamVariable(v)/2), key, 150)
				end
				idouble=idouble+1
			end
		else
			for i, v in pairs (teams) do
				if(getTeamVariable(v)) then
					dxDrawBorderedText(getTeamGroupColor(v)..Text(getTeamGroup(v)), 0, 530*scaley+(FH*(i-1)), screenWidth-170*scalex, 0, tocolor(255, 255, 255, 255), scale, "clear", "right", "top", false, false, false, true)
					DrawProgressBar(screenWidth-160*scalex, 530*scaley+(FH*(i-1)), 500+(getTeamVariable(v)/2), nil, 150)
				end
			end
		end
		

		if(PING) then
			dxDrawImage(0,0,screenWidth,screenHeight, VideoMemory["HUD"]["TABPanel"])

			
			local team = getTeamName(getPlayerTeam(localPlayer))
			if(team) then
				if(getElementData(localPlayer, "job")) then
					dxDrawBorderedText(Text("Работа"), 1000*scalex, 780*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*4, "default-bold", "left", "top")

					dxDrawText("Название: "..team, 1000*scalex, 840*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)	
					dxDrawText("Текущий ранг: "..getElementData(localPlayer, "job"), 1000*scalex, 875*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)	
				else
					dxDrawBorderedText(Text("Банда"), 1000*scalex, 780*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*4, "default-bold", "left", "top")

					dxDrawText("Название: "..team, 1000*scalex, 840*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)	
					local carrier = GetBandRang(team, getTeamVariable(team))
					dxDrawText("Текущий ранг: "..carrier[1][2], 1000*scalex, 875*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)	
					if(carrier[2]) then
						dxDrawText("До повышения "..(carrier[2][1]-getTeamVariable(team)).." репутации", 1000*scalex, 910*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)	
					end
				end
			end
			local countpl = #getElementsByType("player")
			
			for i, v in pairs(getElementData(root, "ChatOnline")) do
				countpl = countpl + 1
			end
			
			dxDrawBorderedText(Text("Игроков")..": "..countpl, 0, 285*scaley, 510*scalex+(730*NewScale), 0, tocolor(180, 180, 180, 255), NewScale*1.2, "default-bold", "right", "top", false, false, false, true)
		
			dxDrawBorderedText(IDF,510*scalex+(15*NewScale), 335*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*1.2, "default-bold", "left", "top", false, false, false, true)
			dxDrawBorderedText(NF, 510*scalex+(60*NewScale), 335*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*1.2, "default-bold", "left", "top", false, false, false, true)
			dxDrawBorderedText(RANG, 510*scalex+(310*NewScale), 335*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*1.2, "default-bold", "left", "top", false, false, false, true)
			dxDrawBorderedText(PING, 510*scalex+(710*NewScale), 335*scaley, 0, 0, tocolor(255, 255, 255, 255), NewScale*1.2, "default-bold", "left", "top", false, false, false, true)
		
			
			
			if(getTeamVariable("Мирные жители")) then
				local count=0
				if(getCameraShakeLevel() == 0) then
					dxDrawText(Text(SkillName[24]), 490*scalex, 840*scaley+((35*scaley)*count), 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)
					DrawProgressBar(780*scalex,840*scaley+((35*scaley)*count), getPedStat(localPlayer, 24), nil, 150)

				else
					dxDrawText(Text(SkillName[165]), 490*scalex, 840*scaley+((35*scaley)*count), 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)
					
					DrawProgressBar(780*scalex,840*scaley+((35*scaley)*count), getPedStat(localPlayer, 165), nil, 150)
				end
				
				
				count=count+1
				
				local Skill = false
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				if(theVehicle) then
					local VehType = GetVehicleType(theVehicle)
					Skill = VehTypeSkill[VehType]
					if(Skill == 160) then
						if(string.sub(getVehiclePlateText(theVehicle), 0, 1) == "I" and string.sub(getVehiclePlateText(theVehicle), 6, 9) == "228") then
							Skill = 161
						end
					end
					dxDrawText(Text(SkillName[Skill]),  490*scalex, 840*scaley+((35*scaley)*count), 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)
					DrawProgressBar(780*scalex,840*scaley+((35*scaley)*count), getPedStat(localPlayer, Skill), nil, 150)
				else
					if(getElementData(localPlayer, "fishpos")) then
						Skill = 157
					else
						Skill = 22
					end
					dxDrawText(Text(SkillName[Skill]),  490*scalex, 840*scaley+((35*scaley)*count), 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)
					DrawProgressBar(780*scalex,840*scaley+((35*scaley)*count), getPedStat(localPlayer, Skill), nil, 150)
				end
				count=count+1
				
				local weapon = getPedWeapon(localPlayer, slot) 
				if(SkillName[WeaponModel[weapon][2]]) then
					dxDrawText(Text(SkillName[WeaponModel[weapon][2]]), 490*scalex, 840*scaley+((35*scaley)*count), 0, 0, tocolor(255, 255, 255, 255), NewScale*2, "default-bold", "left", "top", false, false, false, true)
					DrawProgressBar(780*scalex, 840*scaley+((35*scaley)*count), getPedStat(localPlayer, WeaponModel[weapon][2]), nil, 150)
				end
				local ServerDate = getRealTime(getElementData(root, "ServerTime"), false)
				dxDrawBorderedText(ServerDate.monthday.." "..Text(Month[ServerDate.month+1]).." "..ServerDate.year+1900, 490*scalex, 960*scaley, 0, 0, tocolor(200, 200, 200, 255), NewScale*2.4, "default-bold", "left", "top", nil, nil, nil, true)		
				

				dxDrawBorderedText(Text(Day[ServerDate.weekday+1]), screenWidth, 960*scaley, 930*scalex, screenHeight, tocolor(200, 200, 200, 255), NewScale*2.4, "default-bold", "right", "top", nil, nil, nil, true)		
			end
		end
	elseif(PEDChangeSkin == "nowTime") then
		dxDrawRectangle(0,0,screenWidth, screenHeight, tocolor(255,255,255,255))
	elseif(PEDChangeSkin == "cinema") then
		dxDrawImage(0, 0, screenWidth, screenHeight, VideoMemory["HUD"]["Cinema"])
	else
		if(PData["wasted"]) then
			local Block, Anim = getPedAnimation(localPlayer)
			if(isPedDoingTask(localPlayer, "TASK_SIMPLE_DEAD") or Anim == "handsup") then
				dxDrawBorderedText(PData["wasted"], 0, 0, screenWidth, screenHeight, tocolor(255, 255, 255, 255), scale*5, "clear", "center", "center", nil, nil, nil, true)

				if(RespawnTimer) then
					if(DeathMatch) then
						setTimer(triggerServerEvent, 2000, 1, "SpawnthePlayer", localPlayer, localPlayer, "death")
					else
						fadeCamera(false, 3.0, 230, 230, 230)
						setTimer(triggerServerEvent, 7000, 1, "SpawnthePlayer", localPlayer, localPlayer, "death")
					end
					RespawnTimer = false
				end
			end
		end
	end

	if(PText["HUD"][8]) then
		dxDrawRectangle(screenWidth/2-(150*scaley), screenHeight-(660*scalex), 300*NewScale, 150*NewScale, tocolor(233, 165, 58, 180))	

		if(BindedKeys["enter"][3][1] == "loginPlayerEvent") then
			local text = ""
			for _ = 1, #BindedKeys["enter"][3][4] do
				text = text.."*"
			end
			dxDrawBorderedText(text.."|", screenWidth/2-(120*scaley), screenHeight-(580*scalex), 0, 0, tocolor(0, 0, 0, 255), NewScale*2, "sans", "left", "top", false, false, false, true, true, 0, 0, 0)
		else
			dxDrawBorderedText(BindedKeys["enter"][3][4].."|", screenWidth/2-(120*scaley), screenHeight-(580*scalex), 0, 0, tocolor(0, 0, 0, 255), NewScale*2, "sans", "left", "top", false, false, false, true, true, 0, 0, 0)
		end
	end
	
	for name,arr in pairs(PText) do
		for i,el in pairs(arr) do
			color = el[6]
			th = dxGetFontHeight(el[7], el[8])
			tw = dxGetTextWidth(el[1], el[7], el[8], true)
			
			if(MouseX-el[2] <= tw and MouseX-el[2] >= 0) then
				if(MouseY-el[3] <= th and MouseY-el[3] >= 0) then
					if(el[20]) then
						color = tocolor(255,0,0,255)
					end
				end
			end
			
			if(el[19]["border"]) then
				dxDrawBorderedText(el[1], el[2], el[3], el[4], el[5], color, el[7], el[8], el[9], el[10], el[11], el[12], el[13], el[14], el[15], el[16], el[17], el[18])
			else
				dxDrawText(el[1], el[2], el[3], el[4], el[5], color, el[7], el[8], el[9], el[10], el[11], el[12], el[13], el[14], el[15], el[16], el[17], el[18])
			end
			
			if(el[19]["line"]) then
				dxDrawLine(el[2], el[3]+th, el[2]+tw, el[3]+th, color, 1, el[13])
			end
		end
	end
end
addEventHandler("onClientHUDRender", getRootElement(), DrawPlayerMessage)



function SmoothCameraMove(x,y,z,x2,y2,z2,times,targetafter)
	PData['CameraMove'] = {}
	local x1, y1, z1, lx1, ly1, lz1 = getCameraMatrix()
	PData['CameraMove']['sourcePosition'] = {x1, y1, z1, lx1, ly1, lz1}
	PData['CameraMove']['needPosition'] = {x,y,z,x2,y2,z2}
	
	PData['CameraMove']['timer'] = setTimer(function(targetafter)
		if(targetafter) then
			setCameraTarget(localPlayer)
		end
		PData['CameraMove'] = nil
	end, times, 1, targetafter)
end




function RageInfo(info)
	if(isTimer(PData['rageinfotimer'])) then killTimer(PData['rageinfotimer']) end
	PText["HUD"][9] = {info, 0, 910*NewScale, screenWidth-230*NewScale, 0, tocolor(255,232,25,200), NewScale*2, "default-bold", "right", "top", false, false, false, true, true, 0, 0, 0, {["border"] = true}}
	PData['rageinfotimer'] = setTimer(function() 
		PText["HUD"][9] = nil
	end, 2000, 1)
end

function AddRage(count)
	if(count < 0) then
		count = count+(count*((1000-getPedStat(localPlayer, 160))/200))
	end
	if(PData['rage']+count < 0) then
		if(isTimer(PData['ragetimer'])) then killTimer(PData['ragetimer']) end
		triggerServerEvent("AccelerationDown", localPlayer, localPlayer)
		PData['rage'] = 0
	elseif(PData['rage'] + count > 1000) then
		PData['rage'] = 1000
	else
		PData['rage'] = PData['rage'] + count
	end
end


function GetMarrot(angle, rz)
	local marrot = 0
	if(angle > rz) then
		marrot = -(angle-rz)
	else
		marrot = rz-angle
	end
	
	if(marrot > 180) then
		marrot = marrot-360
	elseif(marrot < -180) then
		marrot = marrot+360
	end
	return marrot
end


--[Имя] = {id модели, {scale, vehx, vehy, vehz, vehrx, vehry, vehrz}}
local itemsData = {
	["Запаска"] = {1025, {0.6, 0, 0, 0, 180, 90, 0}}, 
	["АК-47"] = {355, {0.7, -0.1, -0.15, -0.05, 270, 0, 30}}, 
	["М16"] = {356, {0.7, -0.1, -0.15, -0.05, 270, 0, 30}},	
	["Пакет"] = {2663, {1, 0, 0, 0, 90, 180, 0}}, 
	["Зерно"] = {1453, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Огнетушитель"] = {366, {0.7, -0.1, -0.15, -0.05, 270, 0, 30}}, 
	["Нефть"] = {3632, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Пропан"] = {1370, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Химикаты"] = {1218, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Удобрения"] = {1222, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Бензин"] = {1225, {0.6, 0, 0, -0.1, 90, 90, 90}}, 
	["Алкоголь"] = {2900, {0.5, 0, 0, -0.1, 90, 90, 90}}, 
}


--{+x,+y,+z}
local VehicleTrunks = {
	[400] = {{-0.6, -1.4, 0.1, 60, 0, 0}, {0, -1.4, 0.1, 60, 0, 0}, {0.6, -1.4, 0.1, 60, 0, 0}, {-0.6, -1.9, -0.08, 10, 0, 0}, {0, -1.9, -0.08, 10, 0, 0}, {0.6, -1.9, -0.08, 10, 0, 0}},
	[401] = {{-0.4, -2.1, 0.15, 10, 0, 0}, {0.4, -2.1, 0.15, 10, 0, 0}},
	[402] = {{-0.6, -2.2, 0.15, 0, 0, 0}, {0, -2.2, 0.15, 0, 0, 0}, {0.6, -2.2, 0.15, 0, 0, 0}},
	[403] = false,
	[404] = {{-0.6, -1.7, 0.2, 0, 0, 0}, {0, -1.7, -0.07, 0, 0, 0}, {0.6, -1.7, 0.2, 0, 0, 0}, {-0.6, -2.2, -0.07, 0, 0, 0}, {0, -2.2, -0.07, 0, 0, 0}, {0.6, -2.2, -0.07, 0, 0, 0}},
	
	[412] = {{-0.6, -2.4, -0.05, 10, 0, 0}, {0, -2.4, -0.05, 10, 0, 0}, {0.6, -2.4, -0.05, 10, 0, 0}, {-0.6, -3.0, -0.05, 10, 0, 0}, {0, -3.0, -0.05, 10, 0, 0}, {0.6, -3.0, -0.05, 10, 0, 0}},

	[419] = {{-0.6, -2.4, -0.05, 10, 0, 0}, {0, -2.4, -0.05, 10, 0, 0}, {0.6, -2.4, -0.05, 10, 0, 0}},
	
	[422] = {
		{-0.6, -0.7, -0.1, 0, 0, 0}, {0, -0.7, -0.1, 0, 0, 0}, {0.6, -0.7, -0.1, 0, 0, 0}, 
		{-0.6, -1.3, -0.1, 0, 0, 0}, {0, -1.3, -0.1, 0, 0, 0}, {0.6, -1.3, -0.1, 0, 0, 0},
		{-0.6, -2, -0.1, 0, 0, 0}, {0, -2, -0.1, 0, 0, 0}, {0.6, -2, -0.1, 0, 0, 0},
	},
	
	[439] = {{-0.6, -2.2, -0.05, 10, 0, 0}, {0, -2.2, -0.05, 10, 0, 0}, {0.6, -2.2, -0.05, 10, 0, 0}},
	
	[442] = false,
	[443] = false,
	[444] = false,
	[445] = {{-0.6, -2.5, -0.05, 10, 0, 0}, {0, -2.5, -0.05, 10, 0, 0}, {0.6, -2.5, -0.05, 10, 0, 0}},
	[446] = false, 
	[447] = false, 
	[448] = false, 
	[449] = false,
	[450] = false, 
	[451] = false, 
	[452] = false, 
	[453] = false,
	[454] = false, 
	[455] = {
		{-1, -0.2, 0.2, 0, 0, 0}, {-0.5, -0.2, 0.2, 0, 0, 0}, {0.5, -0.2, 0.2, 0, 0, 0}, {1, -0.2, 0.2, 0, 0, 0}, 
		{-1, -0.9, 0.2, 0, 0, 0}, {-0.5, -0.9, 0.2, 0, 0, 0}, {0.5, -0.9, 0.2, 0, 0, 0}, {1, -0.9, 0.2, 0, 0, 0}, 
		{-1, -1.6, 0.2, 0, 0, 0}, {-0.5, -1.6, 0.2, 0, 0, 0}, {0.5, -1.6, 0.2, 0, 0, 0}, {1, -1.6, 0.2, 0, 0, 0}, 
		{-1, -2.2, 0.2, 0, 0, 0}, {-0.5, -2.2, 0.2, 0, 0, 0}, {0.5, -2.2, 0.2, 0, 0, 0}, {1, -2.2, 0.2, 0, 0, 0}, 
		{-1, -2.9, 0.2, 0, 0, 0}, {-0.5, -2.9, 0.2, 0, 0, 0}, {0.5, -2.9, 0.2, 0, 0, 0}, {1, -2.9, 0.2, 0, 0, 0}, 
		{-1, -3.6, 0.2, 0, 0, 0}, {-0.5, -3.6, 0.2, 0, 0, 0}, {0.5, -3.6, 0.2, 0, 0, 0}, {1, -3.6, 0.2, 0, 0, 0}, 
		{-1, -4.1, 0.2, 0, 0, 0}, {-0.5, -4.1, 0.2, 0, 0, 0}, {0.5, -4.1, 0.2, 0, 0, 0}, {1, -4.1, 0.2, 0, 0, 0}, 
		
	},
	[456] = {
		{-0.6, -0.3, 0.25, 0, 0, 0}, {0, -0.3, 0.25, 0, 0, 0}, {0.6, -0.3, 0.25, 0, 0, 0}, 
		{-0.6, -1, 0.25, 0, 0, 0}, {0, -1, 0.25, 0, 0, 0}, {0.6, -1, 0.25, 0, 0, 0}, 
		{-0.6, -1.7, 0.25, 0, 0, 0}, {0, -1.7, 0.25, 0, 0, 0}, {0.6, -1.7, 0.25, 0, 0, 0}, 
		{-0.6, -2.2, 0.25, 0, 0, 0}, {0, -2.2, 0.25, 0, 0, 0}, {0.6, -2.2, 0.25, 0, 0, 0}
	}, 
	[457] = false,
	[458] = {{-0.6, -1.7, 0, 0, 0, 0}, {0, -1.7, 0, 0, 0, 0}, {0.6, -1.7, 0, 0, 0, 0}, {-0.6, -2.3, 0, 0, 0, 0}, {0, -2.3, 0, 0, 0, 0}, {0.6, -2.3, 0, 0, 0, 0}},
	[459] = {
		{-0.6, -0.3, -0.07, 0, 0, 0}, {0, -0.3, -0.07, 0, 0, 0}, {0.6, -0.3, -0.07, 0, 0, 0}, 
		{-0.6, -1, -0.07, 0, 0, 0}, {0, -1, -0.07, 0, 0, 0}, {0.6, -1, -0.07, 0, 0, 0}, 
		{-0.6, -1.7, -0.07, 0, 0, 0}, {0, -1.7, -0.07, 0, 0, 0}, {0.6, -1.7, -0.07, 0, 0, 0}, 
		{-0.6, -2.2, -0.07, 0, 0, 0}, {0, -2.2, -0.07, 0, 0, 0}, {0.6, -2.2, -0.07, 0, 0, 0}
	}, 
	[460] = false,
	[461] = false,
	[462] = false, 
	[463] = false, 
	[464] = false, 
	[465] = false, 
	[466] = {{-0.6, -2.3, -0.05, 0, 0, 0}, {0, -2.3, -0.05, 0, 0, 0}, {0.6, -2.3, -0.05, 0, 0, 0}},
	[467] = {{-0.5, -2.3, -0.05, 0, 0, 0}, {0, -2.3, -0.05, 0, 0, 0}, {0.5, -2.3, -0.05, 0, 0, 0}},
	[468] = false,
	[469] = false,
	[470] =  {{-0.8, -2, 0.25, 10, 0, 0}, {0, -2, 0.1, 10, 0, 0}, {0.8, -2, 0.25, 10, 0, 0}},
	[471] = false, 
	[472] = false,
	[473] = false,
	[474] = {{-0.6, -2.5, -0.15, 10, 0, 0}, {0, -2.5, -0.15, 10, 0, 0}, {0.6, -2.5, -0.15, 10, 0, 0}},
	[475] = {{-0.6, -2.3, -0.05, 10, 0, 0}, {0, -2.3, -0.05, 10, 0, 0}, {0.6, -2.3, -0.05, 10, 0, 0}},
	
	[478] = {{-0.6, -0.9, 0, 0, 0, 0}, {0, -0.9, -0, 0, 0, 0}, {0.6, -0.9, 0, 0, 0, 0}, {-0.6, -1.6, 0, 0, 0, 0}, {0, -1.6, 0, 0, 0, 0}, {0.6, -1.6, 0, 0, 0, 0}, {-0.6, -2.2, 0, 0, 0, 0}, {0, -2.2, 0, 0, 0, 0}, {0.6, -2.2, 0, 0, 0, 0}},

	[480] = {{-0.5, -1.8, 0, 10, 0, 0}, {0, -1.8, 0, 10, 0, 0}, {0.5, -1.8, 0, 10, 0, 0}},

	[489] = {{-0.6, -1.7, 0.2, 0, 0, 0}, {0, -1.7, -0.07, 0, 0, 0}, {0.6, -1.7, 0.2, 0, 0, 0}, {-0.6, -2.2, -0.07, 0, 0, 0}, {0, -2.2, -0.07, 0, 0, 0}, {0.6, -2.2, -0.07, 0, 0, 0}},
	[490] = {{-0.5, -1.7, -0.05, 10, 0, 0}, {0, -1.7, -0.05, 10, 0, 0}, {0.5, -1.7, -0.05, 10, 0, 0}},
	
	[495] = {{-0.6, -1, -0.1, 0, 0, 0}, {0, -1, -0.1, 0, 0, 0}, {0.6, -1, -0.1, 0, 0, 0}, {-0.6, -1.7, -0.1, 0, 0, 0}, {0, -1.7, -0.1, 0, 0, 0}, {0.6, -1.7, -0.1, 0, 0, 0}},
	[496] = {{-0.5, -1.7, -0.05, 10, 0, 0}, {0, -1.7, -0.05, 10, 0, 0}, {0.5, -1.7, -0.05, 10, 0, 0}},
	
	[505] = {{-0.5, -1.7, -0.05, 10, 0, 0}, {0, -1.7, -0.05, 10, 0, 0}, {0.5, -1.7, -0.05, 10, 0, 0}},
	
	[517] = {{-0.5, -2.3, -0.05, 0, 0, 0}, {0, -2.3, -0.05, 0, 0, 0}, {0.5, -2.3, -0.05, 0, 0, 0}},
	[518] = {{-0.5, -2.3, -0.05, 0, 0, 0}, {0, -2.3, -0.05, 0, 0, 0}, {0.5, -2.3, -0.05, 0, 0, 0}},
	
	[533] = {{-0.6, -2, 0.1, 10, 0, 0}, {0, -2, 0.1, 10, 0, 0}, {0.6, -2, 0.1, 10, 0, 0}},
	[534] = {{-0.6, -2.3, -0, 10, 0, 0}, {0, -2.3, 0, 10, 0, 0}, {0.6, -2.3, 0, 10, 0, 0}},
	[535] = false, 
	[536] = {{-0.6, -2.6, -0, 10, 0, 0}, {0, -2.6, 0, 10, 0, 0}, {0.6, -2.6, 0, 10, 0, 0}},
	
	[542] = {{-0.6, -2.5, 0.1, 10, 0, 0}, {0, -2.5, 0.1, 10, 0, 0}, {0.6, -2.5, 0.1, 10, 0, 0}},
	[543] = {{-0.6, -0.9, 0, 0, 0, 0}, {0, -0.9, -0, 0, 0, 0}, {0.6, -0.9, 0, 0, 0, 0}, {-0.6, -1.6, 0, 0, 0, 0}, {0, -1.6, -0, 0, 0, 0}, {0.6, -1.6, 0, 0, 0, 0}, {-0.6, -2.2, 0, 0, 0, 0}, {0, -2.2, 0, 0, 0, 0}, {0.6, -2.2, 0, 0, 0, 0}},
	
	[549] = {{-0.5, -2.1, 0.06, 0, 0, 0}, {0, -2.1, 0.06, 0, 0, 0}, {0.5, -2.1, 0.06, 0, 0, 0}},
	
	[554] = {{-0.6, -0.9, 0, 0, 0, 0}, {0, -0.9, -0, 0, 0, 0}, {0.6, -0.9, 0, 0, 0, 0}, {-0.6, -1.6, 0, 0, 0, 0}, {0, -1.6, -0, 0, 0, 0}, {0.6, -1.6, 0, 0, 0, 0}, {-0.6, -2.2, 0, 0, 0, 0}, {0, -2.2, 0, 0, 0, 0}, {0.6, -2.2, 0, 0, 0, 0}}, 
	[555] = {{-0.5, -1.9, -0.08, 0, 0, 0}, {0, -1.9, -0.08, 0, 0, 0}, {0.5, -1.9, -0.08, 0, 0, 0}},

	[558] = {{-0.5, -2.1, 0.3, 0, 0, 0}, {0, -2.1, 0.3, 0, 0, 0}, {0.5, -2.1, 0.3, 0, 0, 0}},
	[559] = {{-0.5, -1.8, 0.2, 0, 0, 0}, {0, -1.8, 0.2, 0, 0, 0}, {0.5, -1.8, 0.2, 0, 0, 0}},
	[560] = {{-0.5, -1.9, 0.2, 0, 0, 0}, {0, -1.9, 0.2, 0, 0, 0}, {0.5, -1.9, 0.2, 0, 0, 0}},
	[561] = {{-0.5, -1.9, 0, 0, 0, 0}, {0, -1.9, 0, 0, 0, 0}, {0.5, -1.9, 0, 0, 0, 0}},
	[562] = {{-0.5, -1.9, 0.2, 0, 0, 0}, {0, -1.9, 0.2, 0, 0, 0}, {0.5, -1.9, 0.2, 0, 0, 0}},
	
	[576] = {{-0.6, -2.1, -0.05, 10, 0, 0}, {0, -2.1, -0.05, 10, 0, 0}, {0.6, -2.1, -0.05, 10, 0, 0}, {-0.6, -2.7, -0.05, 10, 0, 0}, {0, -2.7, -0.05, 10, 0, 0}, {0.6, -2.7, -0.05, 10, 0, 0}},

	[603] = {{-0.6, -2.2, 0.1, 10, 0, 0}, {0, -2.2, 0.1, 10, 0, 0}, {0.6, -2.2, 0.1, 10, 0, 0}},
	[604] = {{-0.6, -2.3, -0.05, 0, 0, 0}, {0, -2.3, -0.05, 0, 0, 0}, {0.6, -2.3, -0.05, 0, 0, 0}},
	[605] = {{-0.6, -0.9, 0, 0, 0, 0}, {0, -0.9, -0, 0, 0, 0}, {0.6, -0.9, 0, 0, 0, 0}, {-0.6, -1.6, 0, 0, 0, 0}, {0, -1.6, -0, 0, 0, 0}, {0.6, -1.6, 0, 0, 0, 0}, {-0.6, -2.2, 0, 0, 0, 0}, {0, -2.2, 0, 0, 0, 0}, {0.6, -2.2, 0, 0, 0, 0}},
}






addEventHandler("onClientMinimize", root, function()
	PData['Minimize'] = true
	VideoMemory["HUD"]["ArrowTarget"] = nil
	VideoMemory["HUD"]["LocationTarget"] = nil
	VideoMemory["HUD"]["Wanted"] = nil
end)
 
addEventHandler("onClientRestore", root, function ()
	PData['Minimize'] = nil
end)


function DrawArrow(rotation)
	if(not VideoMemory["HUD"]["ArrowTarget"]) then
		VideoMemory["HUD"]["ArrowTarget"] = dxCreateRenderTarget(dxGetTextWidth("↑", TexturesSize["HUD"]["ArrowTarget"], "default-bold", false), dxGetFontHeight(TexturesSize["HUD"]["ArrowTarget"], "default-bold"), true)
		dxSetRenderTarget(VideoMemory["HUD"]["ArrowTarget"], true)
		dxSetBlendMode("modulate_add")
		dxDrawBorderedText("↑", 0, 0, 0, 0, tocolor(200, 0, 0, 255), TexturesSize["HUD"]["ArrowTarget"], "default-bold", "left", "top", nil, nil, nil, true, false)
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
	return VideoMemory["HUD"]["ArrowTarget"]
end


function DrawWanted(level)
	if(not VideoMemory["HUD"]["Wanted"]) then
		if(level > 0) then
			local rand = math.random(6)
			if(rand == 1) then playSFX("script", 0, math.random(0, 163), false)
			elseif(rand == 2) then playSFX("script", 1, math.random(0, 14), false)
			elseif(rand == 3) then playSFX("script", 2, math.random(0, 4), false)
			elseif(rand == 4) then playSFX("script", 3, math.random(0, 8), false)
			elseif(rand == 5) then playSFX("script", 4, math.random(0, 13), false)
			elseif(rand == 6) then playSFX("script", 5, math.random(0, 57), false) end
		end
		VideoMemory["HUD"]["Wanted"] = dxCreateRenderTarget(dxGetTextWidth("★★★★★★", TexturesSize["HUD"]["Wanted"], "pricedown", false), dxGetFontHeight(TexturesSize["HUD"]["Wanted"], "pricedown"), true)
		dxSetRenderTarget(VideoMemory["HUD"]["Wanted"], true)
		dxSetBlendMode("modulate_add")

		dxDrawBorderedText("★★★★★★", 0-(dxGetTextWidth("★★★★★★", TexturesSize["HUD"]["Wanted"], "pricedown", false)*((6-level)/6)), 0, 0, 0, tocolor(255,165,0, 200),TexturesSize["HUD"]["Wanted"], "pricedown", "left", "top", nil, nil, nil, true, false)
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
	return VideoMemory["HUD"]["Wanted"]
end




function DrawLocation(location)
	if(not VideoMemory["HUD"]["LocationTarget"]) then
		VideoMemory["HUD"]["LocationTarget"] = dxCreateRenderTarget(dxGetTextWidth(location, TexturesSize["HUD"]["LocationTarget"], "diploma", true)+(20*scalex), dxGetFontHeight(TexturesSize["HUD"]["LocationTarget"], "diploma"), true)
		dxSetRenderTarget(VideoMemory["HUD"]["LocationTarget"], true)
		
		dxSetBlendMode("modulate_add")
		
		dxDrawBorderedText(location, dxGetTextWidth(location, TexturesSize["HUD"]["LocationTarget"], "diploma", true)+(10*scalex), 0, 0, 0, tocolor(147, 160, 168, 255),  TexturesSize["HUD"]["LocationTarget"], "diploma", "center", "top", nil, nil, nil, true)

		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
	return VideoMemory["HUD"]["LocationTarget"]
end



function DrawLocationLiberty(location) 
	if(not VideoMemory["HUD"]["LocationTarget"]) then
		VideoMemory["HUD"]["LocationTarget"] = dxCreateRenderTarget((dxGetTextWidth(location, NewScale*6, "default-bold", true)*1.3), dxGetFontHeight(NewScale*6, "default-bold")+4, true)
		dxSetRenderTarget(VideoMemory["HUD"]["LocationTarget"], true)
		
		dxSetBlendMode("modulate_add")
		
		dxDrawText(location:gsub('#%x%x%x%x%x%x', ''), (dxGetTextWidth(location, NewScale*6, "default-bold", true)*1.3)+1.5, 4, 0, 0, tocolor(0, 0, 0, 255), NewScale*6, "default-bold", "center", "top", nil, nil, nil, false)
		dxDrawText(location, (dxGetTextWidth(location, NewScale*6, "default-bold", true)*1.3), 0, 0, 0, tocolor(147, 148, 78, 255), NewScale*6, "default-bold", "center", "top", nil, nil, nil, true)

		dxSetBlendMode("blend")
		dxSetRenderTarget()
				

		local pixels = dxGetTexturePixels(VideoMemory["HUD"]["LocationTarget"])
		local x, y = dxGetPixelsSize(pixels)
		local texture = dxCreateTexture(x,y, "argb")
		local pixels2 = dxGetTexturePixels(texture)
		local pady = 0
		for y2 = 0, y-1 do
			for x2 = 0, x-1 do
				local colors = {dxGetPixelColor(pixels, x2,y2)}
				if(colors[4] > 0) then
					dxSetPixelColor(pixels2, x2-pady, y2, colors[1],colors[2],colors[3],colors[4])
				end
			end
			pady = pady+0.15
		end
		
		dxSetTexturePixels(texture, pixels2)
		VideoMemory["HUD"]["LocationTarget"] = texture
	end
	return VideoMemory["HUD"]["LocationTarget"]
end





function initTrunk(theVehicle)
	local trunkobj = getElementData(theVehicle, "trunk")
	if(trunkobj) then
		if(VehicleTrunk[theVehicle]) then
			for _, obj in pairs(VehicleTrunk[theVehicle]) do
				destroyElement(obj)
			end
		end
		VehicleTrunk[theVehicle] = {}
		trunkobj = fromJSON(trunkobj)
		for i, v in pairs(trunkobj) do
			if(itemsData[v[1]]) then
				local x,y,z,rx,ry,rz = unpack(VehicleTrunks[getElementModel(theVehicle)][i])
				local vx, vy, vz = getElementPosition(theVehicle)
				local vrx, vry, vrz = getElementRotation(theVehicle)
				if(itemsData[v[1]][2]) then
					x,y,z,rx,ry,rz = x+itemsData[v[1]][2][2],y+itemsData[v[1]][2][3],z+itemsData[v[1]][2][4],rx+itemsData[v[1]][2][5],ry+itemsData[v[1]][2][6],rz+itemsData[v[1]][2][7]
					VehicleTrunk[theVehicle][i] = createObject(itemsData[v[1]][1], vx+x, vy+y, vz+z, vrx+rx, vry+ry, vrz+rz)
					setObjectScale(VehicleTrunk[theVehicle][i], itemsData[v[1]][2][1])
					attachElements(VehicleTrunk[theVehicle][i], theVehicle, x,y,z,rx,ry,rz)
				end
				
			end
		end
	end
end






function GetItemQuality(item)
	return item["quality"] or 550
end




function StreamIn(restream)
	if(getElementType(source) == "player") then
		if(not StreamData[source]) then
			StreamData[source] = {["armas"] = {}}
		end
		UpdateArmas(source)
	elseif(getElementType(source) == "marker") then
		if(getMarkerType(source) == "arrow") then
			if(not PData["AnimatedMarker"][source]) then
				local mx,my,mz = getElementPosition(source)
				if(isElementAttached(source)) then
					mx,my,mz = getElementAttachedOffsets(source)
				end
				PData["AnimatedMarker"][source] = {"up", 0, mx,my,mz}
			end
		end
	elseif(getElementType(source) == "vehicle") then
		local occupant = getVehicleOccupant(source)
		VehiclesInStream[source] = {}
		if(not getElementData(source, "owner") and not getVehicleOccupant(source)) then
			VehiclesInStream[source]["blip"] = createBlipAttachedTo(source, 0, 1, 170,170,170,170,1)
		end
		if(getElementData(source, "type")) then
			if(getElementData(source, "type") == "jobtruck") then
				if(GetVehicleType(source) == "Trailer") then
					if(not getVehicleTowingVehicle(source)) then
						triggerEvent("onClientTrailerDetach", source, source)
					end
				else
					if(not occupant) then
						triggerEvent("onClientTrailerDetach", source, source)
					end		
				end
			end
		end
		initTrunk(source)

		
		if(occupant) then
			if(getElementType(occupant) == "ped") then
				if(getElementModel(source) == 488 or getElementModel(source) == 497) then
					setHelicopterRotorSpeed(source, 0.2)
					if(getElementModel(source) == 497) then
						VehiclesInStream[source]["attach_searchlight"] = createSearchLight(0,0,0, 0,0,0, 0.25, 3.5)
					end
				end
			end
		end
	elseif(getElementType(source) == "object") then
		if(getElementModel(source) == 1362) then
			local x,y,z = getElementPosition(source)
			ObjectInStream[source] = {}
			ObjectInStream[source]["fire"] = createEffect("fire", x,y,z+0.7,x,y,z+2,500)
			ObjectInStream[source]["light"] = createLight(0, x,y,z+0.7, 6, 255, 165, 0, nil, nil, nil, true)
			ObjectInStream[source]["collision"] = createColSphere(x,y,z+1, 1)
			attachElements(ObjectInStream[source]["collision"], source)
			setElementAttachedOffsets(ObjectInStream[source]["collision"], 0,0,1)
		elseif(getElementModel(source) == 2887) then
			ObjectInStream[source] = {}
			ObjectInStream[source]["attach_searchlight"] = createSearchLight(0,0,0, 0,0,0, 0.5, 10.5)
		elseif(getElementData(source, "gates")) then
			local gates = fromJSON(getElementData(source, "gates"))
			local x,y,z = getElementPosition(source)
			ObjectInStream[source] = {}
			if(getElementData(source,  "NativePos")) then
				local datCord = fromJSON(getElementData(source, "NativePos"))
				x,y,z = datCord[1], datCord[2], datCord[3]
			end
			ObjectInStream[source]["collision"] = createMarker(x,y,z, "corona", getElementRadius(source)*2, 0,0,0,0)
			setElementInterior(ObjectInStream[source]["collision"], getElementInterior(source))
			setElementDimension(ObjectInStream[source]["collision"], getElementDimension(source))
			setElementParent(ObjectInStream[source]["collision"], source)	
		elseif(GetObjectType(source) == "Графити") then
			ObjectInStream[source] = {}
			local x,y,z = getElementPosition(source)
			ObjectInStream[source]["collision"] = createColSphere(x,y,z, 1)
			attachElements(ObjectInStream[source]["collision"], source)
		end
	elseif(getElementType(source) == "pickup") then
		if(getElementData(source, "arr")) then
			local arr = fromJSON(getElementData(source, "arr"))
			local r,g,b = hex2rgb(GetQualityColor(GetItemQuality(arr)):sub(2,7))
			local x,y,z = getElementPosition(source)
			ObjectInStream[source] = {}
			ObjectInStream[source]["light"] = createMarker(x,y,z,"corona",1, r,g,b,30)
			setElementInterior(ObjectInStream[source]["light"], getElementInterior(source))
			setElementDimension(ObjectInStream[source]["light"], getElementDimension(source))
		end
	elseif(getElementType(source) == "ped") then
		local x,y,z = getElementPosition(source)
		local zone = getZoneName(x,y,z,false)
		exports["vehicle_node"]:LoadZone(getPlayerCity(source), zone)
		
		
		StreamData[source] = {["armas"] = {}, ["UpdateRequest"] = true}
		UpdateArmas(source)
		
		UpdateBot()
		
		if(getElementData(source, "dialog")) then
			if(getElementData(source, "dialogrz")) then
				local px,py,pz = getElementPosition(source)
				local rz = tonumber(getElementData(source, "dialogrz"))
				local x,y,z = getPointInFrontOfPoint(px,py,pz, rz-270, 2)
				StreamData[source]["ActionMarker"] = createMarker(x,y,z-1,  "corona", 2, 255, 10, 10, 0)
				setElementInterior(StreamData[source]["ActionMarker"], getElementInterior(source))
				setElementDimension(StreamData[source]["ActionMarker"], getElementDimension(source))
				setElementData(StreamData[source]["ActionMarker"], "TriggerBot", getElementData(source, "TINF"))
			else
				local x,y,z = getElementPosition(source)
				StreamData[source]["ActionMarker"] = createMarker(x,y,z,  "corona", 1, 255, 10, 10, 0)
				setElementInterior(StreamData[source]["ActionMarker"], getElementInterior(source))
				setElementDimension(StreamData[source]["ActionMarker"], getElementDimension(source))
				attachElements(StreamData[source]["ActionMarker"], source)
				setElementData(StreamData[source]["ActionMarker"], "TriggerBot", getElementData(source, "TINF"))
			end
		else
			local x,y,z = getElementPosition(source)
			StreamData[source]["ActionMarker"] = createMarker(x,y,z,  "corona", 1, 255, 10, 10, 0)
			setElementInterior(StreamData[source]["ActionMarker"], getElementInterior(source))
			setElementDimension(StreamData[source]["ActionMarker"], getElementDimension(source))
			attachElements(StreamData[source]["ActionMarker"], source)
			setElementData(StreamData[source]["ActionMarker"], "TriggerBot", getElementData(source, "TINF"))
		end
		
		if(getElementData(source, "anim")) then
			local arr = fromJSON(getElementData(source, "anim"))
			local block, anim, times, loop, updatePosition, interruptable, freezeLastFrame = arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7]
			setPedAnimation(source, block, anim, times, loop, updatePosition, interruptable, freezeLastFrame)
			local rz = tonumber(getElementData(source, "dialogrz"))
			if(rz) then --Костыль
				setElementRotation(source, 0, 0, rz, "default", true)
			end
		end
	end
	
end
addEvent("onClientElementStreamIn", true)
addEventHandler("onClientElementStreamIn", getRootElement(), StreamIn)


--Для работы дальнобойщиком без прицепа

function ClientVehicleEnter(thePlayer, seat)
	if(thePlayer == localPlayer) then
		if(seat == 0) then
			PData["ClearDriving"] = setTimer(function() 
				AddRage(150)
				RageInfo("Чистое вождение +150")
			end, 25000, 0)

			if(getElementModel(source) == 532 or getElementModel(source) == 531) then
				onAttach(source)
			end
			if(getElementData(source, "type")) then
				if(getElementData(source, "type") == "jobtruck") then
					triggerEvent("onClientTrailerAttach", source)
				end
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), ClientVehicleEnter)

function ClientVehicleExit(thePlayer, seat)
	if(thePlayer == localPlayer) then
		if(seat == 0) then
			killTimer(PData["ClearDriving"])
			if(getElementModel(source) == 532 or getElementModel(source) == 531) then
				deAttach(source)
			end
			if(getElementData(source, "type")) then
				if(getElementData(source, "type") == "jobtruck") then
					triggerEvent("onClientTrailerDetach", source, source)
				end
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), ClientVehicleExit)


function onAttach(theVehicle)
	if(getElementModel(theVehicle) == 531 or getElementModel(theVehicle) == 532) then
		if(getElementModel(theVehicle) == 531) then 
			if(not getVehicleTowedByVehicle(theVehicle)) then return false end 
		end
		PData["Harvest"] = setTimer(function(theVehicle)
			local x,y,z = getElementPosition(theVehicle)
			local gz = getGroundPosition(x,y,z)
			local _,_,_,_,_,_,_,_,material = processLineOfSight(x,y,z,x,y,gz-1, true,false,false,false,false,true,true,true,localPlayer, true)
			if(material) then
				if(material == 40) then
					if(not PData["HarvestDisplay"]) then
						PData["HarvestDisplay"] = 0
						ToolTip("Для сбора урожая удерживай\nскорость в пределах зеленой зоны")
					end
					
					if(VehicleSpeed >= 18 and VehicleSpeed <= 22) then
						PData["HarvestDisplay"] = PData["HarvestDisplay"]+0.25
						if(PData["HarvestDisplay"] == 40) then
							PData["HarvestDisplay"] = 0
							playSFX("genrl", 131, 2, false)
							triggerServerEvent("DropHarvest", localPlayer, x, y, gz+1)
						end
					end
				else
					PData["HarvestDisplay"] = false
				end
			end
		end, 50, 0, source)
	
	else
		destroyElement(VehiclesInStream[source]["info"]) -- Для дальнобойщиков
	end
end
addEventHandler("onClientTrailerAttach", getRootElement(), onAttach)


function deAttach(theVehicle)
	if(getElementModel(theVehicle) == 532 or getElementModel(theVehicle) == 531) then
		killTimer(PData["Harvest"])
		PData["HarvestDisplay"] = false
	else
		local x,y,z = getElementPosition(source)
		VehiclesInStream[source]["info"] = createMarker(x,y,z, "corona", 15, 255, 10, 10, 0)

		local x,y,z,resx,resy,resz = getElementData(source, "x"),getElementData(source, "y"),getElementData(source, "z"),getElementData(source, "resx"),getElementData(source, "resy"),getElementData(source, "resz")
		local dist = getDistanceBetweenPoints3D(x,y,z,resx,resy,resz)/2
		if(dist >= 1000) then
			dist=math.round((dist/1000), 1).." км"
		else
			dist=math.round(dist, 0).." м"
		end
		
		local money = getElementData(source, "money")
		local rl = fromJSON(getElementData(source, "BaseDat"))
		setElementData(VehiclesInStream[source]["info"], "TrailerInfo", "Груз: #FF0000"..getElementData(source, "product").."\n#FFFFFFКуда: "..rl[1].."\nРасстояние: "..dist.."\n#FFFFFFОплата: #3B7231$"..money)
		
		attachElements(VehiclesInStream[source]["info"], source)
	end
end
addEventHandler("onClientTrailerDetach", getRootElement(), deAttach)



function clientPickupHit(thePlayer, matchingDimension)
	if(thePlayer == localPlayer) then
		local x,y,z = getElementPosition(thePlayer)
		local zone = getZoneName(x,y,z)
		local model = getElementModel(source)
		if(model == 954 or model == 1276 or model == 953) then
			if(getElementData(source, "id")) then
				triggerServerEvent("AddCollections", localPlayer, localPlayer, model, getElementData(source, "id"))
				destroyElement(source)
			end
		end
	end
end
addEventHandler("onClientPickupHit", getRootElement(), clientPickupHit)

function StreamOut(restream)
	if(StreamData[source]) then 
		for v,k in pairs(StreamData[source]["armas"]) do
			destroyElement(StreamData[source]["armas"][v])
		end
		if(isElement(StreamData[source]["ActionMarker"])) then
			destroyElement(StreamData[source]["ActionMarker"])
		end
		StreamData[source] = nil
	end

	if(getElementType(source) == "object" or getElementType(source) == "pickup")then
		if(ObjectInStream[source]) then
			for _, obj in pairs(ObjectInStream[source]) do
				destroyElement(obj)
			end
		end
	elseif(getElementType(source) == "vehicle") then
		if(VehiclesInStream[source]) then
			for _, obj in pairs(VehiclesInStream[source]) do
				if(isElement(obj)) then
					destroyElement(obj)
				end
			end
		end
	end
	
	if(restream) then 
		if isElementStreamedIn(source) then
			triggerEvent("onClientElementStreamIn", source, true) 
			return false
		end
	end
	
end
addEventHandler("onClientElementStreamOut", getRootElement(), StreamOut)
addEventHandler("onClientElementDestroy", getRootElement(), StreamOut)
			




function getPositionInFront(element,meters)
	local x, y, z = getElementPosition(element)
	local a,b,r = getElementRotation(element)
	x = x - math.sin ( math.rad(r) ) * meters
	y = y + math.cos ( math.rad(r) ) * meters
	return x,y,z
end

function getPositionInBack(element,meters)
   local x, y, z = getElementPosition(element)
   local a,b,r = getElementRotation(element)
   x = x + math.sin ( math.rad(r) ) * meters
   y = y - math.cos ( math.rad(r) ) * meters
   return x,y,z
end

function getPositionInLeft(element,meters)
   local x, y, z = getElementPosition(element)
   local a,b,r = getElementRotation(element)
   x = x+math.cos(math.rad(r))*meters
   y = y-math.sin(math.rad(r))*meters
   return x,y,z
end

function getPositionInRight(element,meters)
   local x, y, z = getElementPosition(element)
   local a,b,r = getElementRotation(element)
   x = x-math.cos(math.rad(r))*meters
   y = y+math.sin(math.rad(r))*meters
   return x,y,z
end


function getPositionInFR(element,meters)
   local x, y, z = getElementPosition(element)
   local a,b,r = getElementRotation(element)
   x = x - math.sin ( math.rad(r-45) ) * meters
   y = y + math.cos ( math.rad(r-45) ) * meters
   return x,y,z
end


function getPositionInFL(element,meters)
   local x, y, z = getElementPosition(element)
   local a,b,r = getElementRotation(element)
   x = x - math.sin ( math.rad(r+45) ) * meters
   y = y + math.cos ( math.rad(r+45) ) * meters
   return x,y,z
end










function onQuitGame(reason)
	if(isTimer(timers[source])) then
		PlayersMessage[source] = nil
	end
	if(isTimer(timersAction[source])) then
		PlayersAction[source] = nil
	end
end
addEventHandler("onClientPlayerQuit", getRootElement(), onQuitGame)



bindKey("M", "down", openmap)
bindKey("tab", "down", OpenTAB)
bindKey("tab", "up", CloseTAB)
bindKey("h", "down", handsup)
bindKey("p", "down", park)
bindKey('mouse2', 'down', setDoingDriveby)
bindKey("F1", "down", ShowInfoKey)
bindKey("F11", "down", openmap)
bindKey("F12", "down", hideinv)
bindKey("F9", "down", lowPcMode)
bindKey("2", "down", StartMission)





function SwitchNick()
	RemoveInventory()
	LoginClient(true)
end

addEventHandler("onClientPlayerChangeNick", getLocalPlayer(), SwitchNick)




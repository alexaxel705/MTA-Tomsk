local ids = {}

-- Хранит исходные значения, которые в дальнейшем будут отфильтрованы в SData
local SourceData = {
	["PriceAuto"] = {434, 461, 494, 495, 502, 503, 504, 521, 522, 568, 573, 581, 429, 587, 602},
	["TeamVehicle"] = {
		["Гроув-стрит"] = {{567,"GRST 228",{86, 86, 86, 86}}, {492 ,"GROVE4L_",{59,34,86,86}}, {412,"GRST 228",{86, 86, 86, 86}}},
		["Баллас"] = {{517,"BALS 228",{30, 30, 30, 30}}, {412,"BALS 228",{30, 30, 30, 30}}, {566 ,"BALS 228",{30, 30, 30, 30}}},
		["Ацтекас"] = {{466,"AZTC 228",{93, 71, 0, 0}}, {576,"AZTC 228",{93, 71, 0, 0}}, {474 ,"AZTC 228",{93, 71, 0, 0}}},
		["Байкеры"] = {{468,"METAL228"}, {463,"METAL228"}, {586 ,"METAL228"}},
		--{для всех}, {такси}, {эксклюзивы}, {полиция}
		["Полиция"] = {
			["Los Santos"] = {{596, "POLS 228"}, {523, "PBKE 228"}},
			["Red County"] = {{599, "PORC"}, {523, "PBKE 228"}},
			["Whetstone"] = {{599, "POWS 228"}, {523, "PBKE 228"}},
			["Flint County"] = {{599, "POFC 228"}, {523, "PBKE 228"}},
			["San Fierro"] = {{597, "POSF 228"}, {523, "PBKE 228"}},
			["Bone County"] = {{598, "POBC 228"}, {523, "PBKE 228"}},
			["Tierra Robada"] = {{598, "POTR 228"}, {523, "PBKE 228"}},
			["Las Venturas"] = {{598, "POLV 228"}, {523, "PBKE 228"}},
		},
		["Мирные жители"] = {
			["Los Santos"] = {{404},{419},{421},{439},{496},{475}, {420}, {603}, {467},{436},{585},{462},{602},{458},{526},{527},{529},{566},{540},{547},{546},{466},{491},{507},{516},{426}}, -- Phoenix эксклюзив
			["Red County"] = {{404},{419},{439},{496},{475}, {477}, {478},{489},{554},{483},{468}}, -- ZR-350 эксклюзив
			["Whetstone"] = {{404},{419},{439},{496},{475}, {506}, {478},{483},{489},{554},{468}}, -- Super GT эксклюзив
			["Flint County"] = {{404},{419},{439},{496},{475}, {402}, {478},{483},{489},{554},{468}}, -- Buffalo эксклюзив
			["San Fierro"] = {{404},{419},{439},{496},{475}, {415}, {438},{579},{554},{468},{550},{580},{405},{421},{426},{445},{507},{540},{551},{418}}, -- Cheetah эксклюзив
			["Bone County"] = {{404},{419},{439},{496},{475}, {480}, {549},{554},{500},{586},{505},{518},{542},{543},{604},{605},{508}}, -- Comet эксклюзив
			["Tierra Robada"] = {{404},{419},{439},{496},{475}, {533}, {549},{500},{586},{505},{518},{542},{543},{604},{605},{508}}, -- Feltzer эксклюзив
			["Las Venturas"] = {{404},{419},{439},{496},{475}, {420}, {541}, {400},{555},{587},{589},{463},{561},{560},{559},{558},{562},{400},{565},{575}}, -- Bullet эксклюзив
			["Unknown"] = {{404},{419},{439},{496},{475}}
		},
		["Вагос"] = {{474,"VAGOS228",{6, 6, 0, 0}}, {467,"VAGOS228",{6, 6, 0, 0}}, {576 ,"VAGOS228",{6, 6, 0, 0}}},
		["Колумбийский картель"] = {{422,"COKA 228",{116, 116, 116, 116},{2, 2}}, {440,"COKA 228",{116, 116, 116, 116},{1, 1}}, {600 ,"COKA 228",{116, 116, 116, 116},{2, 2}}, {543 ,"COKA 228",{116, 116, 116, 116},{4, 4}}},
		["Русская мафия"] = {{404,"RUSM 228",{1,1,1,1},nil,"createRusMaf"}, {560,"RUSM 228",{1,1,1,1},nil,"createRusMaf"}, {445,"RUSM 228",{1,1,1,1},nil,"createRusMaf"}, {581,"RUSM 228",{1,1,1,1},nil,"createRusMaf"}, {409,"RUSM 228",{1,1,1,1},nil,"createRusMaf"}},
		["Триады"] = {{466,"TRIA 228",{0,0,0,0}}, {560,"TRIA 228",{0,0,0,0}}, {445,"TRIA 228",{0,0,0,0}}, {414,"TRIA 228",{83,83,83,83},{5,5}}},
		["Якудзы"] = {{439,"YAZA 228",{177,15,11, 255,255,255}, nil, "createYakuza"}, {482,"YAZA 228",{177,15,11, 255,255,255}, nil, "createYakuza"}, {467,"YAZA 228",{177,15,11, 255,255,255}, {0, 0}, "createYakuza"}},
		["Рифа"] = {{536,"RIFA 228",{94, 94, 0, 0}}, {439,"RIFA 228",{94, 94, 0, 0}}, {475 ,"RIFA 228",{94, 94, 0, 0}}},
		["Деревенщины"] = {{478,"KOLHZ228",{61, 61, 0, 0}}, {543 ,"KOLHZ228",{61, 61, 0, 0}}, {531,"KOLHZ228",{61, 61, 0, 0}}}
	},
}
local PData = {}
local SData = {
	['Chat Message'] = {},
	["VehAccData"] = {},
	["DriverBot"] = {},
	["PlayerElementSync"] = {},
	["TrunkUsed"] = {}, 
	["Vibori"] = false
}
local TimersAgain = {}
local kandidats = {}
local disableVoice = {}
local hFile = fileOpen("serverdata/time.txt")
local timebuffer = fileRead(hFile, 500)
fileClose(hFile)
local ServerDate = getRealTime(timebuffer) -- Сюда записывается виртуальное время игры
local NowTime = getRealTime()
local CYear = NowTime.year+1900
local OpenGates = {}
local OpenGatesTimer = {}
local PathNodes = exports["vehicle_node"]:GetVehicleNodes()
local PedNodes = exports["vehicle_node"]:GetPedNodes()


function GeneratePlayerScore(arr)
	local count = 0
	local arr = fromJSON(arr)
	for skill, val in pairs(arr) do
		count=count+val
	end
	return count
end


function getPlayerID(thePlayer)
	local id = getElementData(thePlayer, "id")
	if(id) then
		return tonumber(id)
	else
		return false
	end
end

function getPlayerByID(id)
	local player = ids[id]
	return player or false
end


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
	},
}



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





local vending = {
	{955, 0, -862.82, 1536.60, 21.98, 180},
	{956, 0, 2271.72, -76.46, 25.96, 0},
	{955, 0, 1277.83, 372.51, 18.95, 64},
	{956, 0, 662.42, -552.16, 15.71, 180},
	{955, 0, 201.01, -107.61, 0.89, 270},
	{955, 0, -253.73, 2597.95, 62.24, 90},
	{956, 0, -253.73, 2599.75, 62.24, 90},
	{956, 0, -76.03, 1227.99, 19.12, 90},
	{955, 0, -14.70, 1175.36, 18.95, 180},
	{1977, 7, 316.87, -140.35, 998.58, 270},
	{956, 0, -1455.11, 2591.665, 55.23, 180},
	{955, 0, 2352.18, -1357.15, 23.77, 90},
	{955, 0, 2325.97, -1645.14, 14.21, 0},
	{956, 0, 2139.52, -1161.48, 23.35, 87},
	{956, 0, 2153.23, -1016.14, 62.23, 127},
	{955, 0, 1928.74, -1772.44, 12.94, 90},
	{1776, 1, 2222.36, 1602.64, 1000.06, 90},
	{1775, 1, 2222.20, 1606.77, 1000.05, 90},
	{1775, 1, 2155.90, 1606.77, 1000.05, 90},
	{1775, 1, 2209.90, 1607.19, 1000.05, 270},
	{1776, 1, 2155.84, 1607.87, 1000.06, 90},
	{1776, 1, 2202.45, 1617, 1000.06, 180},
	{1776, 1, 2209.24, 1621.21, 1000.06, 0},
	{1776, 3, 330.67, 178.50, 1020.07, 0},
	{1776, 3, 331.92, 178.50, 1020.07, 0},
	{1776, 3, 350.91, 206.08, 1008.47, 90},
	{1776, 3, 361.56, 158.61, 1008.47, 180},
	{1776, 3, 371.59, 178.45, 1020.07, 0},
	{1776, 3, 374.89, 188.97, 1008.47, 0},
	{1775, 2, 2576.70, -1284.43, 1061.09, 270},
	{1775, 15, 2225.20, -1153.42, 1025.90, 270},
	{955, 0, 1154.72, -1460.89, 15.15, 270},
	{956, 0, 2480.85, -1959.27, 12.96, 180},
	{955, 0, 2060.11, -1897.65, 12.92, 0},
	{955, 0, 1729.78, -1943.05, 12.94, 0},
	{956, 0, 1634.10, -2237.53, 12.89, 0},
	{955, 0, 1789.21, -1369.26, 15.16, 270},
	{956, 0, -2229.18, 286.41, 34.70, 180},
	{955, 0, -1980.79, 142.66, 27.07, 270},
	{955, 0, -2118.96, -423.64, 34.72, 255},
	{955, 0, -2118.61, -422.41, 34.72, 255},
	{955, 0, -2097.27, -398.33, 34.72, 180},
	{955, 0, -2092.08, -490.05, 34.72, 0},
	{955, 0, -2063.27, -490.05, 34.72, 0},
	{955, 0, -2005.64, -490.05, 34.72, 0},
	{955, 0, -2034.46, -490.05, 34.72, 0},
	{955, 0, -2068.56, -398.33, 34.72, 180},
	{955, 0, -2039.85, -398.33, 34.72, 180},
	{955, 0, -2011.14, -398.33, 34.72, 180},
	{955, 0, -1350.11, 492.28, 10.58, 90},
	{956, 0, -1350.11, 493.85, 10.58, 90},
	{955, 0, 2319.99, 2532.85, 10.21, 0},
	{956, 0, 2845.72, 1295.04, 10.78, 0},
	{955, 0, 2503.14, 1243.70, 10.21, 180},
	{956, 0, 2647.69, 1129.66, 10.21, 0},
	{1209, 0, -2420.21, 984.57, 44.29, 90},
	{1302, 0, -2420.17, 985.94, 44.29, 90},
	{955, 0, 2085.77, 2071.35, 10.45,90},
	{956, 0, 1398.84, 2222.60, 10.42, 180},
	{956, 0, 1659.46, 1722.85, 10.21, 0},
	{955, 0, 1520.14, 1055.26, 10, 270},
	{1775, 6, -19.03, -57.83, 1003.63, 180},
	{1776, 6, -36.14, -57.87, 1003.63, 180}
}


function CreateVending(model, x,y,z,rz,i,d)
	local col = createColCuboid(x-1,y-1,z-1, 2, 2, 3)
	setElementInterior(col, i)
	setElementDimension(col, d)
	setElementData(col, "vending", model)
end

for key,theVend in pairs(vending) do
	CreateVending(theVend[1], theVend[3], theVend[4], theVend[5], theVend[6], 0,0)
end

-- Дата основания, название, торговля, уровень
local BizInfo = {
	["SANFI"] = {1339, "San Fierro", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.45},
	["PALOM"] = {1639, "Palomino Creek", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.23},
	["MONTG"] = {1587, "Montgomery", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.17},
	["LASVE"] = {1861, "Las Venturas", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.5},
	["BLUEB"] = {1788, "Blueberry", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.15},
	["DILLI"] = {1852, "Dillimore", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.05},
	["LOSSA"] = {1609, "Los Santos", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.3},
	["BAYSA"] = {1871, "Bayside", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.05},
	["FORCA"] = {1778, "Fort Caston", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.19},
	["LASBA"] = {1210, "Las Barricadas", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.025},
	["ELQUE"] = {1448, "El Quebrados", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.075},
	["ANLPI"] = {1651, "Angel Pine", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.135},
	["LASPA"] = {1709, "Las Payasadas", {{"Пропан", "Trade"}, {"Алкоголь", "Trade"}, {"Зерно", "Trade"}, {"Мясо", "Trade"}, {"Бензин", "Trade"}}, 0.1},
	["FLEIS"] = {1869, "Спиртзавод", {{"Зерно", "Trade"}, {"Алкоголь", "Sell"}}, 1},
	["MARIH"] = {1966, "Наркопритон", {{"Косяк", "Sell"}, {"Конопля", "Trade"}}, 1},
	["SPUNK"] = {1956, "Наркопритон", {{"Спанк", "Sell"}, {"Кока", "Trade"}}, 1},
	["FARMFR"] = {1837, "Ферма", {{"Зерно", "Sell"}, {"Удобрения", "Trade"}}, 0.3},
	["FARMPK"] = {1861, "Ферма", {{"Зерно", "Sell"}, {"Удобрения", "Trade"}}, 0.2},
	["FARMBA"] = {1809, "Ферма", {{"Зерно", "Sell"}, {"Удобрения", "Trade"}}, 0.32},
	["FARMWS"] = {1855, "Скотный двор", {{"Скот", "Sell"}, {"Зерно", "Trade"}}, 0.12},
	["MEATFA"] = {1908, "Мясокомбинат", {{"Мясо", "Sell"}, {"Скот", "Trade"}}, 0.25},
	["ELSF"] = {1924, "Электростанция", {}},
	["PLSPD"] = {1955, "Полицейский участок", {}},
	["MEDLV"] = {1966, "Скорая помощь", {}},
	["MEDLS"] = {1921, "Скорая помощь", {}},
	["BIOEN"] = {1939, "Химический завод", {{"Удобрения", "Sell"}, {"Химикаты", "Trade"}}, 1},
	["PETLV"] = {1859, "Нефтяные скважины", {{"Нефть", "Sell"}}},
	["NPZSF"] = {1901, "Химический завод", {{"Пропан", "Sell"}, {"Бензин", "Sell"}, {"Химикаты", "Sell"}, {"Нефть", "Trade"}}, 1},
	["FOSOI"] = {1918, "Химический завод", {{"Пропан", "Sell"}, {"Бензин", "Sell"}, {"Химикаты", "Sell"}, {"Нефть", "Trade"}}, 1},
	["SPRAYSA"] = {1974, "Pay'n'Spray", {}},
	["SPRUNK"] = {1932, "Sprunk", {}},
	["MEDRA"] = {1922, "Психиатрическая больница SA", {}},
	["SOLIN"] = {1929, "Solarin Industries", {{"Бензин", "Trade"}}, 1},
	["SANNEWS"] = {1969, "San News", {}},
	["MEDBC"] = {1955, "Скорая помощь Bone County", {}},
	["MEDTR"] = {1943, "Скорая помощь Tierra Robada", {}},
	["MEDRC"] = {1970, "Скорая помощь Red County", {}},
	["MEDUN"] = {1965, "Отделение травматологии", {}},
	["MEDWS"] = {1933, "Скорая помощь Whetstone", {}},
	["MEDSF"] = {1918, "Скорая помощь San Fierro", {}},
	["AMMOLS"] = {1962, "Ammunation LS", {}},
	["MERLS"] = {1844, "Мэрия LS", {}},
	["MERSF"] = {1800, "Мэрия SF", {}},
	["MERLV"] = {1912, "Мэрия LV", {}},
	["CIASA"] = {1935, "Штаб квартира ЦРУ", {}},
	["PSFPD"] = {1952, "Полицейский участок", {}},
	["PLVPD"] = {1944, "Полицейский участок", {}},
	["PRCPD"] = {1967, "Полицейский участок", {}},
	["PBCPD"] = {1951, "Полицейский участок", {}},
	["PTRPD"] = {1921, "Полицейский участок", {}},
	["PWSPD"] = {1966, "Полицейский участок", {}},
	["FBISF"] = {1952, "ФБР", {}},
	["BANBC"] = {1960, "Банк", {}},
	["BANSF"] = {1936, "Банк", {}},
	["BANTR"] = {1914, "Банк", {}},
	["BANLV"] = {1942, "Банк", {}},
	["BANLS"] = {1903, "Банк", {}},
	["CERBC"] = {1805, "Церковь Tierra Robada", {}},
	["CERLV"] = {1835, "Свадебная часовня Las Venturas", {}},
	["CERLV2"] = {1877, "Свадебная часовня Las Venturas", {}},
	["CERLV3"] = {1825, "Свадебная часовня Las Venturas", {}},
	["CERSF"] = {1877, "Церковь San Fierro", {}},
	["CERRC"] = {1903, "Церковь Red County", {}},
	["CERLS"] = {1793, "Церковь Los Santos", {}},
	["DALBC"] = {1939, "База дальнобойщиков", {}},
}




function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then return nil end
	if(alpha) then return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else return string.format("#%.2X%.2X%.2X", red,green,blue) end
end


function setCameraOnPlayerJoin()
	for i=1,getMaxPlayers() do--Даем ID
		if not ids[i] then
			ids[i] = source
			setElementData(source, "id", i)
		break
		end
	end
	PData[source] = {
		['radar'] = createBlipAttachedTo(source, 0, 2, 0, 0, 0, 0, 2),
		['lang'] = "Русский",
		['PayDay'] = 0, -- С каждой зарплатой множитель растет (Продолжительность игры на сервере)
		['CONTROLS'] = {
			['fire'] = {},
			['action'] = {},
			['vehicle_fire'] = {},
			['vehicle_secondary_fire'] = {},
			['jump'] = {},
			['sprint'] = {},
			['aim_weapon'] = {},
			['enter_exit'] = {},
			['enter_passenger'] = {}
		}
	}

	setCameraMatrix(source,1698.9, -1538.9, 13.4, 1694.2, -1529, 13.5)
	for i, msg in pairs(SData['Chat Message']) do
		outputChatBox(msg, source, 255, 255, 255,true)
	end


	local webplay = ''
	for theKey,thePlayer in ipairs(getElementsByType("player")) do
		webplay = webplay..getPlayerName(thePlayer)..'<br />'
	end
	callRemote("http://109.227.228.4/engine/include/MTA/online.php", ResultGet, webplay)
end
addEventHandler("onPlayerJoin", getRootElement(), setCameraOnPlayerJoin)




local Lang = {
	["Русский"] = "Ru_ru.po",
	["English"] = "Ru_en.po",
	["Азербайджанский"] = "Ru_az.po",
}

local LangArr = {}



function Text(thePlayer, text, repl)
	if(LangArr[PData[thePlayer]['lang']][text]) then
		if(LangArr[PData[thePlayer]['lang']][text] ~= "") then
			text = LangArr[PData[thePlayer]['lang']][text]
		end
	end
	if(repl) then
		for i, dat in pairs(repl) do
			text = string.gsub(text, dat[1], dat[2])
		end
	end
	return text
end



for lng, name in pairs(Lang) do
	local hFile = fileOpen("lang/"..name, true)

	local ft = fileRead(hFile, 2500)
	while not fileIsEOF(hFile) do
		ft = ft .. fileRead(hFile, 2500)
	end


	LangArr[lng] = {}
	local Lines = split (ft, "\n")
	for i = 1, #Lines do
		if(string.sub(Lines[i], 0, 5) == "msgid") then
			LangArr[lng][string.sub(Lines[i], 8, #Lines[i]-1)] = string.sub(Lines[i+1], 9, #Lines[i+1]-1)
		end
	end
	fileClose(hFile)
end




function SetLang(thePlayer, lang)
	PData[source]["lang"] = lang
	triggerClientEvent(thePlayer, "SetLang", thePlayer, Lang[lang])

end
addEvent("SetLang", true)
addEventHandler("SetLang", root,SetLang)




function spairs(t, order) --Для сортировки таблицы по высокому значению
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end




PlayerNode = xmlLoadFile("serverdata/playerdata.xml")
CarNode = xmlLoadFile("serverdata/car.xml")
HouseNode = xmlLoadFile("serverdata/house.xml")
BizNode = xmlLoadFile("serverdata/biz.xml")
FishesNode = xmlLoadFile("serverdata/fish.xml")
ZoneNode = xmlLoadFile("serverdata/zones.xml")
ThreesNode = xmlLoadFile("serverdata/threes.xml")

local tmpv
local benztimer={}
local FuelTimer={}
local TruckMarker={}
local PetrolFuelMarker = {}
local Teams = {
	['Мирные жители'] = createTeam('Мирные жители', 204, 204, 204),
	['Уголовники'] = createTeam('Уголовники', 133, 133, 133),
	['Колумбийский картель'] = createTeam('Колумбийский картель', 54, 61, 90),
	['Баллас'] = createTeam('Баллас', 108, 62, 111),
	['Гроув-стрит'] = createTeam('Гроув-стрит', 78, 101, 61),
	['МЧС'] = createTeam('МЧС', 220, 20, 60),
	['Полиция'] = createTeam('Полиция', 65, 105, 225),
	['ЦРУ'] = createTeam('ЦРУ', 1, 1, 1),
	['Военные'] = createTeam('Военные', 75, 83, 32),
	['Триады'] = createTeam('Триады', 0, 0, 0),
	['Якудзы'] = createTeam('Якудзы', 168, 0, 0),
	['Русская мафия'] = createTeam('Русская мафия', 255, 255, 255),
	['Байкеры'] = createTeam('Байкеры', 102, 66, 32),
	['Вагос'] = createTeam('Вагос', 255, 255, 0),
	['ФБР'] = createTeam('ФБР', 1, 38, 117),
	['Рифа'] = createTeam('Рифа', 38, 163, 150),
	['Деревенщины'] = createTeam('Деревенщины', 255, 157, 75),
	['Ацтекас'] = createTeam('Ацтекас', 48, 213, 200)
}
local MPPlayerList = {}
local DMPlayerList = {}
local racePlayerBlip = {}
local racePlayerFinish = {}
local raceGlobalTimer = false
local MPTimer = false
local EndRaceInfoTimer = false
local PlayersEnteredPickup = {}
local Threes = {}
local ThreesPickup = {}



function CreateInventory(h,w)
	local out = {}
	for x = 1, h do
		out[x] = {}
		for y = 1, w do
			out[x][y] = {}
		end
	end
	return out
end
local StandartInventory = toJSON(CreateInventory(7,10))
local Collections = toJSON({[953] = {}, [954] = {}, [1276] = {}})
local PlayersPickups = {}
local VehicleBand = {} -- Заспауненые автомобили фракций
local DynamicBlip = {}
local DynamicMar = {}
local ThreesNames = {
	[782] = "Кока",
	[823] = "Конопля", 
	[870] = "Роза", 
}
local BotCreated = {}
local CapZone = {}
local BizControls = {}
local VacancyList = {}
local BusinessPickup = {}


local Month = {
	[1] = "Январь",
	[2] = "Февраль",
	[3] = "Март",
	[4] = "Апрель",
	[5] = "Май",
	[6] = "Июнь",
	[7] = "Июль",
	[8] = "Август",
	[9] = "Сентябрь",
	[10] = "Октябрь",
	[11] = "Ноябрь",
	[12] = "Декабрь"
}

function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end



-- Interior, x,y,z,rz, {["OtherData"] = }
local Interiors = {
	["Sweet's House"] = {1, 2524, -1679.4, 1015.5,270},
	["Wu Zi Mu's Betting place"] = {1, -2170.4, 640.4, 1057.6,0},
	["Denise's Place"] = {1, 243.7, 305, 999.1,270},
	["Burglary House 1"] = {1, 223.2, 1287.1, 1082.1,360},
	["Safe House 4"] = {1, 2218.4, -1076.3, 1050.5,90},
	["Safe House 228"] = {2, 2237.5, -1081.6, 1049,0},
	["Ryder House"] = {2, 2468.8, -1698.3, 1013.5,90},
	["Angel Pine Trailer"] = {2, 2.1, -3.1, 999.4,90},
	["BDups Crack Palace"] = {2, 1520.7, -47.9, 1002.1,270},
	["Big Smoke's Crack Palace"] = {2, 2541.5, -1304, 1025.1,270},
	["Burglary House 2"] = {2, 226.8, 1240, 1082.1,90},
	["Burglary House 3"] = {2, 447, 1397.1, 1084.3,0},
	["Burglary House 4"] = {2, 491.2, 1398.5, 1080.3,0},
	["Katie's Place"] = {2, 266.5, 305, 999.1,270},
	["Loco Low Co."] = {2, 620.1, -70.9, 998,180},
	["Johnson House"] = {3, 2495.9, -1692.1, 1014.7,180},
	["Big bear apartament"] = {3, 1531.4, -6.6, 1002.1,180},
	["OG Loc's House"] = {3, 516.7, -15.2, 1001.6,360},
	["Burglary House 5"] = {3, 235.3, 1186.7, 1080.3,0},
	["Helena's Place"] = {3, 293.2, 310, 999.1,90},
	["Burglary House 6"] = {4, -260.5, 1456.7, 1084.4,90},
	["Burglary House 8"] = {4, 261, 1284.3, 1080.3,0},
	["Burglary House 7"] = {4, 221.8, 1140.2, 1082.6,0},
	["Michelle's Place"] = {4, 300.2, 312.7, 999.1,0},
	["Michelle's Garage"] = {4, 300.2, 311.5, 999.1,180},
	["Burglary House 11"] = {5, 140.3, 1365.9, 1083.9,0},
	["Burning Desire House"] = {5, 2352.9, -1181, 1028,90},
	["The Crack Den"] = {5, 318.5, 1114.5, 1083.9,0},
	["Safe House 10"] = {5, 2233.6, -1115.3, 1050.9,0},
	["Mad Doggs Manson 2"] = {5, 1298.9, -797, 1084,0},
	["Burglary House 9"] = {5, 22.9, 1403.3, 1084.4,0},
	["Burglary House 10"] = {5, 226.3, 1114.3, 1081,270},
	["Millie's Bedroom"] = {6, 343.7, 305, 999.1,270},
	["Safe House 3"] = {6, 2333, -1077.4, 1049,0},
	["Safe House 5"] = {6, 2196.9, -1204.3, 1049,90},
	["Safe House 6"] = {6, 2308.8, -1212.9, 1049,0},
	["Burglary House 16"] = {6, -68.8, 1351.2, 1080.2,360},
	["Burglary House 15"] = {6, 234.1, 1063.7, 1084.2,0},
	["Colonel Fuhrberger's House"] = {8, 2807.6, -1174.8, 1025.6,0},
	["Burglary House 22"] = {8, -42.6, 1405.5, 1084.4,0},
	["Safe House 11"] = {8, 2365.3, -1135.6, 1050.9,0},
	["Burglary House 12"] = {9, 83.1, 1322.3, 1083.9,0},
	["Safe House 18"] = {9, 2317.8, -1026.8, 1050.2,0},
	["Unknown safe house"] = {9, 2251.4, -1143.2, 1050.6,0},
	["Burglary House 13"] = {9,260.7, 1237.2, 1084.3,0},
	["Abandonded AC Woter"] = {10, 422.6, 2536.5, 10,90},
	["Safe House 14"] = {10, 2270.4, -1210.5, 1047.6,90},
	["Burglary House 14"] = {10, 24, 1340.2, 1084.4,359},
	["Safe House 12"] = {11, 2283, -1140.3, 1050.9,0},
	["Budget Inn Motel Room"] = {12, 446.7, 506.3, 1001.4,0},
	["Modern safe house"] = {12, 2324.5, -1149.5, 1050.7,0},

	["Burglary House 17"] = {15, -283.4, 1471.1, 1084.4,90},
	["Jeffeson Motel"] = {15, 2214.4, -1150.5, 1025.8,270},
	["Burglary House 18"] = {15, 327.9, 1477.7, 1084.4,0},
	["Burglary House 19"] = {15, 377, 1417.3, 1081.3,90},
	["Burglary House 20"] = {15, 387.2, 1471.8, 1080.2,90},
	["Burglary House 21"] = {15, 295.1, 1472.3, 1080.3,358}, 
}


local InteriorsObject = {
	["Angel Pine Trailer"] = {{1567, -0.76, 3.1, 998.5, 0, 0, 90}},
	["Big bear apartament"] = {{1567, 1525.1, -10.2, 1001, 0, 0, 270}}, 
	["Abandonded AC Woter"] = {{1567, 413.1, 2536, 9, 0, 0, 90}},
	["BDups Crack Palace"] = {{1567, 1528, -47.2, 1001.1, 0, 0, 270}, {1504, 1520.2, -47.2, 1001.1, 0, 0, 270}},
	["OG Loc's House"] = {{1567, 514.63, -6.8, 1000.6, 0, 0, 180}},
	["Wu Zi Mu's Betting place"] = {{1504, -2171.1, 640, 1056.6, 0, 0, 0}, {1567, -2171.65, 644.5, 1056.6, 0, 0, 90}},
	["Unknown safe house"] = {{1567, 2255.5, -1139.2, 1049.6, 0, 0, 270}},
	["Ryder House"] = {{1567, 2456.4, -1707.1, 1012.5, 0, 0, 180}}, 
}


--x, y, z, rotz, камера угол, владелец, i, d, инфа для тюрьмы
local SpawnPoint = {
	["AREA51"] = {212, 1865, 13, 90, false, false,0, 0, "#FFA500Психиатрическая больница", "До выписки"},
	["LSPD"] = {264.5, 77.6, 1001, 90, false, false, 6, 1, "#FFA500Тюрьма Los Santos", "До освобождения"},
	["SFPD"] = {219.5, 110, 999, 0, false, false, 10, 1, "#FFA500Тюрьма San Fierro", "До освобождения"},
	["LVPD"] = {193.5, 174.8, 1003, 0, false, false, 3, 1, "#FFA500Тюрьма Las Venturas", "До освобождения"},
	["RCPD"] = {318.5, 316.2, 999.1, 270, false, false, 5, 4, "#FFA500Тюрьма Red County", "До освобождения"},
	["WSPD"] = {318.5, 316.2, 999.1, 270, false, false, 5, 1, "#FFA500Тюрьма Whetstone", "До освобождения"},
	["FCPD"] = {318.5, 316.2, 999.1, 270, false, false, 5, 1, "#FFA500Тюрьма Flint County", "До освобождения"},
	["BCPD"] = {318.5, 316.2, 999.1, 270, false, false, 5, 2, "#FFA500Тюрьма Bone County", "До освобождения"},
	["TRPD"] = {318.5, 316.2, 999.1, 270, false, false, 5, 3, "#FFA500Тюрьма Tierra Robada", "До освобождения"},

	["Ganton"] = {2512, -1671, 13.51, 0, 270, false, 0, 0},
	["Zone 51 Prison"] = {212, 1865,13, 0, false, false, 0, 0},
	["Zone 51 Army"] = {133.8, 1920.1,19.1, 0, false, false, 0, 0},
	["Zone 51 Medic"] = {287.5, 1833.3, 8, 0, false, false, 0, 0},
	["Zone 51 CIA"] = {226.9, 1822.8, 7.4, 90, false, false, 0, 0},
	["Army"] = {-1310.1, 493, 18.2, 0, false, false, 0, 0},
	["Unity Station"] = {1714.4, -1942.6, 13.6, 180, false, false, 0, 0},
	["Market Station"] = {824.5, -1361.5, -0.5, 134, false, false, 0, 0},
	["Cranberry Station"] = {-1984.5, 137.8, 27.7, 90, false, false, 0, 0},
	["Linden Station"] = {2857.3, 1290, 11.4, 180, false, false, 0, 0},
	["Koyoen Station"] = {1433.9, 2617.6, 11.4, 180, false, false, 0, 0},
	["Las Payasadas"] = {-214, 2602, 62, 270, 90, false, 0, 0},
	["El Corona"] = {1774, -1896, 13.6, 270, 180, false, 0, 0},
	["Willowfield"] = {2466, -1953, 16.8, 270, 180, false, 0, 0},
	["Chinatown"] = {-2176, 655, 49.4, 90, 180, false, 0, 0},
	["Glen Park"] = {2001, -1121, 26.73, 180, 90, false, 0, 0},
	["Calton Heights"] = {-2188, 1019, 79.9, 0, 90, false, 0, 0},
	["East Beach"] = {2777.5, -1622.1, 10.9, 0, 360, false, 0, 0},
	["Whitewood Estates"] = {1063.5, 2085.8, 10.8, 0, false, false, 0, 0},
	["Los Santos Police"] = {1542, -1675, 13.6, 90, false, false, 0, 0},
	["San Fierro Police"] = {-1589, 716, -5.3, 270, false, false, 0, 0},
	["Las Venturas Police"] = {2272, 2446, 3.52, 180, false, false, 0, 0},
	["Verdant Bluffs"] = {1209, -2037, 69, 270, false, false, 0, 0},
	["Caligula's Palace"] = {2170.6, 1684, 10.8, 0, false, false, 0, 0},
	["Pershing Square Meria"] = {1481.6, -1765.4, 18.8, 0, false, false, 0, 0}, 
	["Avispa Country Club"] = {-2724.2, -314.4, 7.2, 48, false, false, 0, 0}
}

local ClinicSpawn = {
	["Los Santos"] = {1183, -1323.7, 13.6, 270, 0, "MEDLS"},
	["Red County"] = {1224.4, 306.8, 19.7, 180, 0, "MEDRC"},
	["Whetstone"] = {-2198.6, -2309.4, 30.6, 0, 0, "MEDWS"},
	["Flint County"] = {-2198.6, -2309.4, 30.6, 0, 0, "MEDWS"},
	["San Fierro"] = {-2659, 627, 14.5, 180, 0, "MEDSF"},
	["Bone County"] = {-316.1, 1056.8, 19.79, 0, 0, "MEDBC"},
	["Tierra Robada"] = {-1514, 2528, 55.7, 0, 0, "MEDTR"},
	["Las Venturas"] = {1605, 1820,  10.9, 0, 0, "MEDLV"},
	["Unknown"] = {2033, -1415, 17, 180, 0, "MEDUN"}, 
	
	["Liberty City"] = {1055.7, 405.2, 14.9, 90, 1, "MEDUN"}, 
	["Portland"] = {1055.7, 405.2, 14.9, 90, 1, "MEDUN"}, 
	["Staunton Island"] = {99.3, 978, 16.2, 180, 1, "MEDUN"}, 
	["Shoreside Vale"] = {-1340.6, 855.3, 58.8, 90, 1, "MEDUN"}, 
	
	["Vice City"] = {319.3, -188, 0, 90, 2, "MEDUN"}, 
}




local BotSkin = {
	["Полиция"] = {7,9,10,12,13, 280 ,14,15,17,18,19, 281 ,20,21,22,23,44, 282 ,48,72,236,56},  --Каждые 5 педов охраняет 1 коп
	["Баллас"] = {102,103,104,28},  --Доп. Наркодиллер
	["Гроув-стрит"] = {105,106,107}, 
	["Вагос"] = {108,109,110,29},  --Доп. Наркодиллер
	["Рифа"] = {173,174,175}, 
	["Деревенщины"] = {159,160,161,162}, 
	["Триады"] = {117,118,120,32},  --Доп. Оружие
	["Якудзы"] = {121,122,123}, 
	["Ацтекас"] = {114,115,116}, 
	["Байкеры"] = {181,247,248,100,261, 64},  --Доп. Шлюха
	["Русская мафия"] = {111,112,113}, 
	["Колумбийский картель"] = {222,221,95,30,242,179}, 
}

-- Старухи, итд
local BotSkinSpecific = {
	["Мирные жители"] = {
		["Las Venturas"] = {
			["Starfish Casino"] = {27,153,260},
			["Yellow Bell Golf Course"] = {36,37},
			["The Four Dragons Casino"] = {82,83,84,85,141,150,147,233},
			["The Strip"] = {82,83,84,85,141,150,147,233},
			["Greenglass College"] = {23, 56, 60, 72, 93, 141, 150, 181, 190, 188, 193, 195, 211, 226},
			["all"] = {7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,90,92,99,236,56}
		},
		["Tierra Robada"] = {
			["all"] = {38,89, 198, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56,128}
		},
		["Bone County"] = {
			["all"] = {39,129, 198, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56,128}
		},
		["San Fierro"] = {
			["all"] = {196, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,92,99,236,56}
		},
		["Red County"] = {
			["all"] = {130,199, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Whetstone"] = {
			["all"] = {218, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Flint County"] = {
			["all"] = {197, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Los Santos"] = {
			["all"] = {10, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,90,92,99,236,56,243}
		},
		["Unknown"] = {
			["all"] = {10,38,39,89,129,130,196,197,199,218, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Unknown Bar"] = {
			["Unknown Bar"] = {102,103,104, 105,106,107, 108,109,110, 173,174,175, 159,160,161,162, 117,118,120, 121,122,123, 114,115,116, 181,247,248,100, 111,112,113, 222,95,30,242,179}
		}
	},
	["Полиция"] = {
		["Las Venturas"] = {
			["all"] = {282}
		},
		["Tierra Robada"] = {
			["all"] = {283}
		},
		["Bone County"] = {
			["all"] = {283}
		},
		["San Fierro"] = {
			["all"] = {284}
		},
		["Red County"] = {
			["all"] = {288}
		},
		["Whetstone"] = {
			["all"] = {288}
		},
		["Flint County"] = {
			["all"] = {288}
		},
		["Los Santos"] = {
			["all"] = {280}
		},
		["Unknown"] = {
			["all"] = {280, 281, 282, 283, 284, 288}
		},
		["Unknown Bar"] = {
			["Unknown Bar"] = {280, 281, 282, 283, 284, 288}
		}
	}
}


local VehicleRegionSpecific = {
	["Red County"] = {431,437},
	["Los Santos"] = {431,437},
	["San Fierro"] = {431,437},
	["Las Payasadas"] = {431,437},
	["Whetstone"] = {431,437},
	["Las Venturas"] = {431,437},
	["Flint County"] = {431,437},
	["Tierra Robada"] = {431,437},
	["Bone County"] = {431,437},
	["Julius Thruway South"] = {443, 431,437},
	["Julius Thruway West"] = {443, 431,437},
	["Julius Thruway North"] = {443, 431,437},
	["Julius Thruway East"] = {443, 431,437},
	["Las Venturas Airport"] = {431,437},
	["Easter Bay Airport"] = {431,437},
	["Ocean Docks"] = {515, 514, 403, 499, 524, 609, 498, 455, 414, 456, 440},
}


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
	[49] = {nil, nil},
	[50] = {nil, nil},
	[51] = {nil, nil},
	[160] = {nil, 160}
}






local ZonesRegion = {
	["Unknown Bar"] = "Unknown Bar",
	["Unknown"] = "Unknown",
	["Linden Side"] = "Las Venturas",
	["Las Venturas Airport"] = "Las Venturas",
	["Harry Gold Parkway"] = "Las Venturas",
	["Los Santos International"] = "Los Santos",
	["Come-A-Lot"] = "Las Venturas",
	["Juniper Hill"] = "San Fierro",
	["City Hall"] = "San Fierro",
	["Julius Thruway North"] = "Las Venturas",
	["Montgomery"] = "Red County",
	["El Corona"] = "Los Santos",
	["Queens"] = "San Fierro",
	["The High Roller"] = "Las Venturas",
	["K.A.C.C. Military Fuels"] = "Las Venturas",
	["Pilson Intersection"] = "Las Venturas",
	["Vinewood"] = "Los Santos",
	["Mulholland Intersection"] = "Los Santos",
	["The Emerald Isle"] = "Las Venturas",
	["Flint County"] = "Flint County",
	["El Quebrados"] = "Tierra Robada",
	["Tierra Robada"] = "Tierra Robada",
	["Linden Station"] = "Las Venturas",
	["Blackfield Chapel"] = "Las Venturas",
	["San Andreas Sound"] = "Red County",
	["Conference Center"] = "Los Santos",
	["Roca Escalante"] = "Las Venturas",
	["The Camel's Toe"] = "Las Venturas",
	["El Castillo del Diablo"] = "Bone County",
	["Lil' Probe Inn"] = "Bone County",
	["Martin Bridge"] = "Red County",
	["Beacon Hill"] = "Flint County",
	["Battery Point"] = "San Fierro",
	["Missionary Hill"] = "San Fierro",
	["The Pink Swan"] = "Las Venturas",
	["Easter Tunnel"] = "San Fierro",
	["Red County"] = "Red County",
	["Commerce"] = "Los Santos",
	["Palomino Creek"] = "Red County",
	["Blueberry"] = "Red County",
	["Montgomery Intersection"] = "Red County",
	["Santa Maria Beach"] = "Los Santos",
	["Las Barrancas"] = "Tierra Robada",
	["Regular Tom"] = "Bone County",
	["Shady Creeks"] = "Whetstone",
	["Kincaid Bridge"] = "Tierra Robada",
	["Los Flores"] = "Los Santos",
	["Valle Ocultado"] = "Tierra Robada",
	["Julius Thruway West"] = "Las Venturas",
	["Jefferson"] = "Los Santos",
	["Hashbury"] = "San Fierro",
	["'The Big Ear'"] = "Bone County",
	["Back o Beyond"] = "Flint County",
	["Los Santos"] = "Los Santos",
	["Playa del Seville"] = "Los Santos",
	["Last Dime Motel"] = "Las Venturas",
	["Temple"] = "Los Santos",
	["San Fierro"] = "San Fierro",
	["Rockshore East"] = "Las Venturas",
	["The Mako Span"] = "Red County",
	["Hilltop Farm"] = "Red County",
	["Avispa Country Club"] = "San Fierro",
	["The Sherman Dam"] = "Tierra Robada",
	["Ganton"] = "Los Santos",
	["Fisher's Lagoon"] = "Red County",
	["Pirates in Men's Pants"] = "Las Venturas",
	["Ocean Flats"] = "San Fierro",
	["Rockshore West"] = "Las Venturas",
	["Cranberry Station"] = "San Fierro",
	["Hankypanky Point"] = "Red County",
	["The Clown's Pocket"] = "Las Venturas",
	["Doherty"] = "San Fierro",
	["Esplanade North"] = "San Fierro",
	["North Rock"] = "Red County",
	["Bayside Marina"] = "Tierra Robada",
	["The Four Dragons Casino"] = "Las Venturas",
	["Richman"] = "Red County",
	["Calton Heights"] = "San Fierro",
	["The Strip"] = "Las Venturas",
	["Yellow Bell Golf Course"] = "Las Venturas",
	["Spinybed"] = "Las Venturas",
	["Verona Beach"] = "Los Santos",
	["King's"] = "San Fierro",
	["Garver Bridge"] = "Tierra Robada",
	["Easter Basin"] = "San Fierro",
	["LVA Freight Depot"] = "Las Venturas",
	["Restricted Area"] = "Bone County",
	["Greenglass College"] = "Las Venturas",
	["San Fierro Bay"] = "Tierra Robada",
	["Prickle Pine"] = "Las Venturas",
	["Redsands East"] = "Las Venturas",
	["Royal Casino"] = "Las Venturas",
	["Aldea Malvada"] = "Tierra Robada",
	["Verdant Meadows"] = "Bone County",
	["Randolph Industrial Estate"] = "Las Venturas",
	["Arco del Oeste"] = "Tierra Robada",
	["Willowfield"] = "Los Santos",
	["Bayside"] = "Tierra Robada",
	["Julius Thruway East"] = "Las Venturas",
	["Las Brujas"] = "Bone County",
	["Old Venturas Strip"] = "Las Venturas",
	["Leafy Hollow"] = "Flint County",
	["Flint Intersection"] = "Flint County",
	["Redsands West"] = "Las Venturas",
	["Starfish Casino"] = "Las Venturas",
	["Bone County"] = "Bone County",
	["The Visage"] = "Las Venturas",
	["Yellow Bell Station"] = "Las Venturas",
	["Flint Range"] = "Flint County",
	["Sherman Reservoir"] = "Tierra Robada",
	["Fern Ridge"] = "Red County",
	["Sobell Rail Yards"] = "Las Venturas",
	["Hampton Barns"] = "Red County",
	["Caligula's Palace"] = "Las Venturas",
	["Los Santos Inlet"] = "Flint County",
	["Bayside Tunnel"] = "Tierra Robada",
	["Idlewood"] = "Los Santos",
	["Green Palms"] = "Bone County",
	["East Beach"] = "Los Santos",
	["Chinatown"] = "San Fierro",
	["Whitewood Estates"] = "Las Venturas",
	["Rodeo"] = "Los Santos",
	["Garcia"] = "San Fierro",
	["Verdant Bluffs"] = "Los Santos",
	["Downtown Los Santos"] = "Los Santos",
	["Foster Valley"] = "San Fierro",
	["Fallen Tree"] = "Red County",
	["Marina"] = "Los Santos",
	["Las Venturas"] = "Las Venturas",
	["Esplanade East"] = "San Fierro",
	["Gant Bridge"] = "Tierra Robada",
	["Blackfield"] = "Las Venturas",
	["Market Station"] = "Los Santos",
	["Pilgrim"] = "Las Venturas",
	["Financial"] = "San Fierro",
	["Little Mexico"] = "Los Santos",
	["Mulholland"] = "Red County",
	["Angel Pine"] = "Whetstone",
	["Julius Thruway South"] = "Las Venturas",
	["Fort Carson"] = "Bone County",
	["Glen Park"] = "Los Santos",
	["Robada Intersection"] = "Tierra Robada",
	["Mount Chiliad"] = "San Fierro",
	["Juniper Hollow"] = "San Fierro",
	["East Los Santos"] = "Los Santos",
	["Las Payasadas"] = "Bone County",
	["Shady Cabin"] = "Whetstone",
	["Frederick Bridge"] = "Red County",
	["Octane Springs"] = "Bone County",
	["The Panopticon"] = "Red County",
	["Blackfield Intersection"] = "Las Venturas",
	["Paradiso"] = "San Fierro",
	["Flint Water"] = "Red County",
	["Easter Bay Chemicals"] = "Red County",
	["Hunter Quarry"] = "Bone County",
	["Creek"] = "Las Venturas",
	["Las Colinas"] = "Los Santos",
	["Santa Flora"] = "San Fierro",
	["Palisades"] = "San Fierro",
	["Market"] = "Los Santos",
	["Blueberry Acres"] = "Red County",
	["Dillimore"] = "Red County",
	["Pershing Square"] = "Los Santos",
	["Fallow Bridge"] = "Red County",
	["Easter Bay Airport"] = "Red County",
	["Ocean Docks"] = "Los Santos",
	["Whetstone"] = "Whetstone",
	["Unity Station"] = "Los Santos",
	["Downtown"] = "San Fierro"
}

--Модель, номер, цвет, вариант, команда (если есть)







function createYakuza(theVehicle)
	if(not theVehicle) then theVehicle = source end
	setVehicleVariant(theVehicle, 0, 0)
	addVehicleUpgrade(theVehicle, 1158)
	addVehicleUpgrade(theVehicle, 1098)
	if(getElementModel(theVehicle) == 439) then
		setElementData(theVehicle, "name", "Yakuza Stinger")
	end
end
addEvent("createYakuza", true)
addEventHandler("createYakuza", root, createYakuza)


function createRusMaf(theVehicle)
	if(not theVehicle) then theVehicle = source end
	setVehicleColor(theVehicle, 1,1,1,1)
end
addEvent("createRusMaf", true)
addEventHandler("createRusMaf", root, createRusMaf)






--[Скин] = [Стиль походки, команда, пол, оружие, диалоги, {возможные имена ботов},]
local SkinData = {
	[0] = {0, Teams['Мирные жители'], "Мужчина"},
	[7] = {118, Teams['Мирные жители'], "Мужчина"},
	[9] = {129, Teams['Мирные жители'], "Женщина"},
	[10] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[11] = {129, Teams['Мирные жители'], "Женщина"},
	[12] = {132, Teams['Мирные жители'], "Женщина"},
	[13] = {129, Teams['Мирные жители'], "Женщина"},
	[14] = {118, Teams['Мирные жители'], "Мужчина"},
	[15] = {118, Teams['Мирные жители'], "Мужчина"},
	[16] = {118, Teams['Мирные жители'], "Мужчина"},
	[17] = {118, Teams['Мирные жители'], "Мужчина"},
	[18] = {118, Teams['Мирные жители'], "Мужчина"},
	[19] = {118, Teams['Мирные жители'], "Мужчина"},
	[20] = {118, Teams['Мирные жители'], "Мужчина"},
	[21] = {118, Teams['Мирные жители'], "Мужчина"},
	[22] = {118, Teams['Мирные жители'], "Мужчина"},
	[23] = {118, Teams['Мирные жители'], "Мужчина"},
	[24] = {118, Teams['Мирные жители'], "Мужчина"},
	[25] = {118, Teams['Мирные жители'], "Мужчина"},
	[26] = {118, Teams['Мирные жители'], "Мужчина"},
	[27] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Строитель"}},
	[28] = {118, Teams['Мирные жители'], "Мужчина"},
	[29] = {118, Teams['Мирные жители'], "Мужчина"},
	[30] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[31] = {129, Teams['Мирные жители'], "Женщина"},
	[32] = {118, Teams['Мирные жители'], "Мужчина"},
	[33] = {118, Teams['Мирные жители'], "Мужчина"},
	[34] = {118, Teams['Мирные жители'], "Мужчина"},
	[35] = {118, Teams['Мирные жители'], "Мужчина"},
	[36] = {118, Teams['Мирные жители'], "Мужчина", 2},
	[37] = {118, Teams['Мирные жители'], "Мужчина", 2},
	[38] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[39] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[40] = {131, Teams['Мирные жители'], "Женщина"},
	[41] = {129, Teams['Мирные жители'], "Женщина"},
	[43] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[44] = {118, Teams['Мирные жители'], "Мужчина"},
	[45] = {118, Teams['Мирные жители'], "Мужчина"},
	[46] = {121, Teams['Мирные жители'], "Мужчина"},
	[47] = {118, Teams['Мирные жители'], "Мужчина"},
	[48] = {118, Teams['Мирные жители'], "Мужчина"},
	[49] = {120, Teams['Мирные жители'], "Мужчина"},
	[50] = {118, Teams['Мирные жители'], "Мужчина"},
	[51] = {118, Teams['Мирные жители'], "Мужчина"},
	[52] = {118, Teams['Мирные жители'], "Мужчина"},
	[53] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[54] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[55] = {129, Teams['Мирные жители'], "Женщина"},
	[56] = {129, Teams['Мирные жители'], "Женщина"},
	[57] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[58] = {118, Teams['Мирные жители'], "Мужчина"},
	[59] = {118, Teams['Мирные жители'], "Мужчина"},
	[60] = {118, Teams['Мирные жители'], "Мужчина"},
	[61] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Пилот"}},
	[62] = {0, Teams['Уголовники'], "Мужчина"},
	[63] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[64] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[66] = {118, Teams['Мирные жители'], "Мужчина"},
	[67] = {118, Teams['Мирные жители'], "Мужчина"},
	[68] = {118, Teams['Мирные жители'], "Мужчина"},
	[69] = {129, Teams['Мирные жители'], "Женщина"},
	[70] = {128, Teams['МЧС'], "Мужчина"},
	[71] = {128, Teams['Мирные жители'], "Мужчина", 22},
	[72] = {118, Teams['Мирные жители'], "Мужчина"},
	[73] = {118, Teams['Мирные жители'], "Мужчина"},
	[75] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[76] = {129, Teams['Мирные жители'], "Женщина"},
	[77] = {135, Teams['Мирные жители'], "Женщина", nil, "Бомж", {"Бездомная", "Бомжиха"}},
	[78] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[79] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[80] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Боксер"}},
	[81] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Боксер"}},
	[82] = {118, Teams['Мирные жители'], "Мужчина"},
	[83] = {118, Teams['Мирные жители'], "Мужчина"},
	[84] = {118, Teams['Мирные жители'], "Мужчина"},
	[85] = {132, Teams['Мирные жители'], "Женщина"},
	[87] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Стриптизерша"}},
	[88] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[89] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[90] = {132, Teams['Мирные жители'], "Женщина"},
	[91] = {132, Teams['Мирные жители'], "Женщина"},
	[92] = {138, Teams['Мирные жители'], "Женщина", nil, nil, {"Девушка на роликах"}},
	[93] = {132, Teams['Мирные жители'], "Женщина"},
	[94] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[95] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[96] = {132, Teams['Мирные жители'], "Женщина"},
	[97] = {132, Teams['Мирные жители'], "Женщина"},
	[98] = {132, Teams['Мирные жители'], "Женщина"},
	[99] = {138, Teams['Мирные жители'], "Мужчина", nil, nil, {"Парень на роликах"}},
	[100] = {121, Teams['Байкеры'], "Мужчина", 22},
	[101] = {132, Teams['Мирные жители'], "Женщина"},
	[102] = {121, Teams['Баллас'], "Мужчина", 5},
	[103] = {121, Teams['Баллас'], "Мужчина", 22},
	[104] = {121, Teams['Баллас'], "Мужчина", 22},
	[105] = {122, Teams['Гроув-стрит'], "Мужчина", 4},
	[106] = {122, Teams['Гроув-стрит'], "Мужчина", 22},
	[107] = {122, Teams['Гроув-стрит'], "Мужчина", 22},
	[108] = {121, Teams['Вагос'], "Мужчина", 22},
	[109] = {121, Teams['Вагос'], "Мужчина", 22},
	[110] = {121, Teams['Вагос'], "Мужчина", 22},
	[111] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[112] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[113] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[114] = {122, Teams['Ацтекас'], "Мужчина", 28},
	[115] = {122, Teams['Ацтекас'], "Мужчина", 28},
	[116] = {122, Teams['Ацтекас'], "Мужчина", 28},
	[117] = {122, Teams['Триады'], "Мужчина", 22},
	[118] = {122, Teams['Триады'], "Мужчина", 29},
	[120] = {122, Teams['Триады'], "Мужчина", 30},
	[121] = {121, Teams['Якудзы'], "Мужчина", 22, nil, {"Якудза", "Куми-ин"}},
	[122] = {121, Teams['Якудзы'], "Мужчина", 28, nil, {"Якудза", "Сансита"}},
	[123] = {121, Teams['Якудзы'], "Мужчина", 25, nil, {"Якудза", "Дэката"}},
	[124] = {118, Teams['Мирные жители'], "Мужчина"},
	[125] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[126] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[127] = {121, Teams['Русская мафия'], "Мужчина", 25},
	[128] = {118, Teams['Мирные жители'], "Мужчина"},
	[129] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[130] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[131] = {132, Teams['Мирные жители'], "Женщина"},
	[132] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[133] = {118, Teams['Мирные жители'], "Мужчина"},
	[134] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[135] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[136] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[137] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[138] = {132, Teams['Мирные жители'], "Женщина"},
	[139] = {132, Teams['Мирные жители'], "Женщина"},
	[140] = {132, Teams['Мирные жители'], "Женщина"},
	[141] = {129, Teams['Мирные жители'], "Женщина"},
	[142] = {118, Teams['Мирные жители'], "Мужчина"},
	[143] = {118, Teams['Мирные жители'], "Мужчина"},
	[144] = {118, Teams['Мирные жители'], "Мужчина"},
	[145] = {133, Teams['Мирные жители'], "Женщина"},
	[146] = {133, Teams['Мирные жители'], "Женщина"},
	[147] = {118, Teams['Мирные жители'], "Мужчина"},
	[148] = {129, Teams['Мирные жители'], "Женщина"},
	[150] = {129, Teams['Мирные жители'], "Женщина"},
	[151] = {129, Teams['Мирные жители'], "Женщина"},
	[152] = {132, Teams['Мирные жители'], "Женщина"},
	[153] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Строитель"}},
	[154] = {118, Teams['Мирные жители'], "Мужчина"},
	[155] = {118, Teams['Мирные жители'], "Мужчина"},
	[158] = {122, Teams['Деревенщины'], "Мужчина", 33},
	[159] = {119, Teams['Деревенщины'], "Мужчина", 33},
	[160] = {119, Teams['Деревенщины'], "Мужчина", 33},
	[161] = {119, Teams['Деревенщины'], "Мужчина", 33},
	[162] = {126, Teams['Деревенщины'], "Мужчина", 33},
	[163] = {118, Teams['ЦРУ'], "Мужчина", 31},
	[164] = {118, Teams['ЦРУ'], "Мужчина", 31},
	[165] = {118, Teams['ЦРУ'], "Мужчина", 31},
	[166] = {118, Teams['ЦРУ'], "Мужчина", 31},
	[167] = {118, Teams['Мирные жители'], "Мужчина"},
	[168] = {118, Teams['Мирные жители'], "Мужчина"},
	[169] = {129, Teams['Якудзы'], "Женщина", 31, nil, {"Якудза", "Кумитё"}},
	[170] = {118, Teams['Мирные жители'], "Мужчина"},
	[171] = {118, Teams['Мирные жители'], "Мужчина"},
	[172] = {129, Teams['Мирные жители'], "Женщина"},
	[173] = {121, Teams['Рифа'], "Мужчина", 32},
	[174] = {121, Teams['Рифа'], "Мужчина", 32},
	[175] = {121, Teams['Рифа'], "Мужчина", 32},
	[176] = {118, Teams['Мирные жители'], "Мужчина"},
	[177] = {118, Teams['Мирные жители'], "Мужчина"},
	[178] = {132, Teams['Мирные жители'], "Женщина"},
	[179] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[180] = {118, Teams['Мирные жители'], "Мужчина"},
	[181] = {121, Teams['Байкеры'], "Мужчина", 22},
	[182] = {118, Teams['Мирные жители'], "Мужчина"},
	[183] = {118, Teams['Мирные жители'], "Мужчина"},
	[184] = {118, Teams['Мирные жители'], "Мужчина"},
	[185] = {118, Teams['Мирные жители'], "Мужчина"},
	[186] = {118, Teams['Мирные жители'], "Мужчина"},
	[187] = {118, Teams['Мирные жители'], "Мужчина"},
	[188] = {118, Teams['Мирные жители'], "Мужчина"},
	[189] = {118, Teams['Мирные жители'], "Мужчина"},
	[190] = {132, Teams['Мирные жители'], "Женщина"},
	[191] = {121, Teams['Мирные жители'], "Женщина"},
	[192] = {121, Teams['Мирные жители'], "Женщина"},
	[193] = {132, Teams['Мирные жители'], "Женщина"},
	[194] = {132, Teams['Мирные жители'], "Женщина"},
	[195] = {132, Teams['Мирные жители'], "Женщина"},
	[196] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[197] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[198] = {129, Teams['Мирные жители'], "Женщина"},
	[199] = {134, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[200] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[201] = {129, Teams['Мирные жители'], "Женщина"},
	[202] = {118, Teams['Мирные жители'], "Мужчина"},
	[203] = {118, Teams['Мирные жители'], "Мужчина"},
	[204] = {118, Teams['Мирные жители'], "Мужчина"},
	[205] = {135, Teams['Мирные жители'], "Женщина"},
	[206] = {118, Teams['Мирные жители'], "Мужчина"},
	[207] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[209] = {118, Teams['Мирные жители'], "Мужчина"},
	[210] = {118, Teams['Мирные жители'], "Мужчина"},
	[211] = {132, Teams['Мирные жители'], "Женщина"},
	[212] = {118, Teams['Мирные жители'], "Мужчина"},
	[213] = {0, Teams['Уголовники'], "Мужчина"},
	[214] = {132, Teams['Мирные жители'], "Женщина"},
	[215] = {134, Teams['Мирные жители'], "Женщина"},
	[216] = {132, Teams['Мирные жители'], "Женщина"},
	[217] = {118, Teams['Мирные жители'], "Мужчина"},
	[218] = {132, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[219] = {132, Teams['Мирные жители'], "Женщина"},
	[220] = {118, Teams['Мирные жители'], "Мужчина"},
	[221] = {118, Teams['Колумбийский картель'], "Мужчина"},
	[222] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[223] = {121, Teams['Мирные жители'], "Мужчина"},
	[224] = {134, Teams['Мирные жители'], "Женщина"},
	[225] = {134, Teams['Мирные жители'], "Женщина"},
	[226] = {135, Teams['Мирные жители'], "Женщина"},
	[227] = {118, Teams['Мирные жители'], "Мужчина"},
	[228] = {118, Teams['Мирные жители'], "Мужчина"},
	[229] = {118, Teams['Мирные жители'], "Мужчина"},
	[230] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[231] = {132, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[232] = {132, Teams['Мирные жители'], "Женщина", 16, "Бабка", {"Старуха", "Бабка"}},
	[233] = {129, Teams['Мирные жители'], "Женщина"},
	[234] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[235] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[236] = {120, Teams['Мирные жители'], "Мужчина", nil, nil, {"Дед", "Старик"}},
	[237] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[238] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[239] = {118, Teams['Мирные жители'], "Мужчина", nil, "Бомж", {"Бездомный", "Бродяга", "Бомж"}},
	[240] = {118, Teams['Мирные жители'], "Мужчина"},
	[241] = {124, Teams['Мирные жители'], "Мужчина"},
	[242] = {121, Teams['Колумбийский картель'], "Мужчина", 29},
	[243] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[244] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Шлюха"}},
	[245] = {135, Teams['Мирные жители'], "Женщина"},
	[246] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Стриптизерша"}},
	[247] = {121, Teams['Байкеры'], "Мужчина", 22},
	[248] = {121, Teams['Байкеры'], "Мужчина", 22},
	[249] = {118, Teams['Мирные жители'], "Мужчина"},
	[250] = {118, Teams['Мирные жители'], "Мужчина"},
	[251] = {132, Teams['Мирные жители'], "Женщина"},
	[252] = {133, Teams['Уголовники'], "Мужчина"},
	[253] = {118, Teams['Мирные жители'], "Мужчина"},
	[254] = {121, Teams['Байкеры'], "Мужчина", 22},
	[255] = {118, Teams['Мирные жители'], "Мужчина"},
	[256] = {132, Teams['Мирные жители'], "Женщина"},
	[257] = {132, Teams['Мирные жители'], "Женщина", nil, nil, {"Стриптизерша"}},
	[258] = {124, Teams['Мирные жители'], "Мужчина"},
	[259] = {124, Teams['Мирные жители'], "Мужчина"},
	[260] = {118, Teams['Мирные жители'], "Мужчина", nil, nil, {"Строитель"}},
	[261] = {118, Teams['Байкеры'], "Мужчина"},
	[262] = {118, Teams['Мирные жители'], "Мужчина"},
	[263] = {132, Teams['Мирные жители'], "Женщина"},
	[264] = {128, Teams['Мирные жители'], "Мужчина"},
	[265] = {128, Teams['Полиция'], "Мужчина", 22},
	[266] = {128, Teams['Полиция'], "Мужчина", 22},
	[267] = {128, Teams['Полиция'], "Мужчина", 22},
	[268] = {0, Teams['Уголовники'], "Мужчина"},
	[269] = {122, Teams['Гроув-стрит'], "Мужчина", 22},
	[270] = {122, Teams['Гроув-стрит'], "Мужчина", 30},
	[271] = {122, Teams['Гроув-стрит'], "Мужчина", 30},
	[272] = {118, Teams['Мирные жители'], "Мужчина"},
	[274] = {128, Teams['МЧС'], "Мужчина"},
	[275] = {128, Teams['МЧС'], "Мужчина"},
	[276] = {128, Teams['МЧС'], "Мужчина"},
	[277] = {118, Teams['МЧС'], "Мужчина", nil, nil, {"Пожарный"}},
	[278] = {118, Teams['МЧС'], "Мужчина", nil, nil, {"Пожарный"}},
	[279] = {118, Teams['МЧС'], "Мужчина", nil, nil, {"Пожарный"}},
	[280] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[281] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[282] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Полицейский", "Мент"}},
	[283] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Шериф"}},
	[284] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Патрульный"}},
	[285] = {128, Teams['Полиция'], "Мужчина", 32, nil, {"SWAT"}},
	[286] = {128, Teams['ФБР'], "Мужчина", 30, nil, {"ФБР"}},
	[287] = {0, Teams['Военные'], "Мужчина", 31, nil, {"Военный"}},
	[288] = {128, Teams['Полиция'], "Мужчина", 22, nil, {"Шериф"}},
	[290] = {118, Teams['Мирные жители'], "Мужчина"},
	[291] = {118, Teams['Мирные жители'], "Мужчина"},
	[292] = {122, Teams['Ацтекас'], "Мужчина", 30},
	[293] = {122, Teams['Гроув-стрит'], "Мужчина", 22},
	[294] = {122, Teams['Триады'], "Мужчина", 30},
	[295] = {118, Teams['Мирные жители'], "Мужчина"},
	[296] = {118, Teams['Мирные жители'], "Мужчина"},
	[297] = {118, Teams['Мирные жители'], "Мужчина"},
	[298] = {132, Teams['Мирные жители'], "Женщина"},
	[299] = {0, Teams['Мирные жители'], "Мужчина"},
	[300] = {122, Teams['Гроув-стрит'], "Мужчина", 30},
	[301] = {122, Teams['Гроув-стрит'], "Мужчина", 30},
	[302] = {118, Teams['Мирные жители'], "Мужчина"},
	[303] = {118, Teams['Мирные жители'], "Мужчина"},
	[304] = {132, Teams['Мирные жители'], "Женщина"},
	[305] = {118, Teams['Мирные жители'], "Мужчина"},
	[306] = {118, Teams['Мирные жители'], "Мужчина"},
	[307] = {118, Teams['Мирные жители'], "Мужчина"},
	[308] = {118, Teams['Мирные жители'], "Мужчина"},
	[309] = {118, Teams['Мирные жители'], "Мужчина"},
	[310] = {118, Teams['Мирные жители'], "Мужчина"},
	[311] = {122, Teams['Гроув-стрит'], "Мужчина", 22},
	[312] = {0, Teams['Военные'], "Мужчина"}
}

local SkinList = {}
for model, _ in pairs(SkinData) do
	SkinList[#SkinList+1] = model
end





-- Звезды розыска
createPickup(2743.0, 1316.0, 8.0, 3, 1247, 60000)
createPickup(2168.66, 2267.96, 15.34, 3, 1247, 60000)
createPickup(2408.0, 1389.0, 22.0, 3, 1247, 60000)
createPickup(2034.0, 842.0, 10.0, 3, 1247, 60000)
createPickup(2096.0, 1287.0, 10.8, 3, 1247, 60000)
createPickup(1987.0, 1543.0, 16.0, 3, 1247, 60000)
createPickup(1854.0, 912.0, 10.8, 3, 1247, 60000)
createPickup(2540.38, 2527.85, 10.39, 3, 1247, 60000)
createPickup(1548.02, 1024.47, 10.39, 3, 1247, 60000)
createPickup(1592.91, 2053.83, 10.26, 3, 1247, 60000)
createPickup(1971.29, 2330.26, 10.41, 3, 1247, 60000)
createPickup(1700.74, 1792.7, 10.41, 3, 1247, 60000)
createPickup(2581.0, -1491.0, 24.0, 3, 1247, 60000)
createPickup(2296.0, -1696.0, 14.0, 3, 1247, 60000)
createPickup(2273.0, -1099.0, 38.0, 3, 1247, 60000)
createPickup(2716.0, -1048.0, 66.0, 3, 1247, 60000)
createPickup(2614.0, -2496.0, 33.0, 3, 1247, 60000)
createPickup(1183.85, -1250.68, 14.7, 3, 1247, 60000)
createPickup(1970.0, -1158.0, 21.0, 3, 1247, 60000)
createPickup(734.0, -1137.0, 18.0, 3, 1247, 60000)
createPickup(2553.76, -2464.31, 13.62, 3, 1247, 60000)
createPickup(1204.06, -1613.89, 13.28, 3, 1247, 60000)
createPickup(611.21, -1459.63, 14.01, 3, 1247, 60000)
createPickup(1116.67, -719.91, 100.17, 3, 1247, 60000)
createPickup(-1903.1, -466.44, 25.18, 3, 1247, 60000)
createPickup(-2657.0, -144.0, 4.0, 3, 1247, 60000)
createPickup(-2454.0, -166.0, 35.0, 3, 1247, 60000)
createPickup(-2009.0, 1227.0, 32.0, 3, 1247, 60000)
createPickup(-2120.0, 96.39, 39.0, 3, 1247, 60000)
createPickup(-2411.0, -334.0, 37.0, 3, 1247, 60000)
createPickup(-1690.0, 450.0, 13.0, 3, 1247, 60000)
createPickup(-1991.26, -1144.13, 29.69, 3, 1247, 60000)
createPickup(-2636.13, -492.83, 70.09, 3, 1247, 60000)
createPickup(-2022.68, 345.98, 35.17, 3, 1247, 60000)
createPickup(-2683.2, 784.13, 49.98, 3, 1247, 60000)
createPickup(-1820.67, -154.12, 9.4, 3, 1247, 60000)
createPickup(-736.0, 66.0, 24.0, 3, 1247, 60000)
createPickup(262.33, -149.12, 1.58, 3, 1247, 60000)
createPickup(1643.0, 264.0, 20.0, 3, 1247, 60000)
createPickup(601.98, 2150.38, 39.41, 3, 1247, 60000)
createPickup(-1407.0, -2039.0, 1.0, 3, 1247, 60000)
createPickup(-2156.0, -2371.0, 31.0, 3, 1247, 60000)
createPickup(-419.25, 1362.36, 12.21, 3, 1247, 60000)
createPickup(629.04, 2842.83, 25.21, 3, 1247, 60000)
createPickup(690.49, -209.59, 25.6, 3, 1247, 60000)
createPickup(88.82, -125.1, 0.85, 3, 1247, 60000)
createPickup(215.69, 1089.1, 16.4, 3, 1247, 60000)
createPickup(-2305.24, 2310.11, 4.98, 3, 1247, 60000)
createPickup(-213.61, 2717.44, 62.68, 3, 1247, 60000)



SData["DialogBot"] = 1
function CreateDialogBot(skin,x,y,z,rz,i,d,dialog,name)
	local ped = createPed(skin, x,y,z,rz, true)
	setElementInterior(ped, i)
	setElementDimension(ped, d)
	setElementData(ped, "dialog", dialog)
	setElementData(ped, "dialogrz", rz)
	setElementData(ped, "TINF", "DialogBot"..SData["DialogBot"])

	if(not name) then
		name = SkinData[skin][3]
		if(SkinData[skin][6]) then
			name = SkinData[skin][6][math.random(#SkinData[skin][6])]
		end
	end
	setElementData(ped, "name", name)

	SData["DialogBot"] = SData["DialogBot"]+1
	return ped
end





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
		[2] = {25, "Diego", 221}, 
		[3] = {50, "Sombras", 95},
		[4] = {75, "Sureno", 30},
		[5] = {120, "Cacos", 242},
		[6] = {180, "Guerrero", 179},
		[7] = {250, "Лейтенант колумбийского картеля", 43}
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
		[4] = {130, "Дорожный капитан", 100}, 
		[5] = {160, "Железная задница", 261}, 
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
	["Якудзы"] = {
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
	["Полиция"] = {
		[1] = {0, "Рядовой", 280},
		[2] = {25, "Инспектор ДПС", 284},
		[3] = {100, "Сержант", 281},
		[4] = {250, "Лейтенант", 282},
		[5] = {300, "SWAT", 285},
		[6] = {400, "Офицер 1 класса", 267},
		[7] = {500, "Офицер 2 класса", 266},
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
	["ЦРУ"] = {
		[1] = {0, "Сотрудник ЦРУ #1", 163}, 
		[2] = {30, "Сотрудник ЦРУ #2", 164}, 
		[3] = {60, "Сотрудник ЦРУ #3", 165}, 
		[4] = {90, "Сотрудник ЦРУ #4", 166}
	}
}




function GetBandRangSkin(gang,reps)
	local maks = {BandRangs[gang][1]}
	for rang, k in ipairs(BandRangs[gang]) do
		if(k[1] <= reps) then
			maks[1] = k
		end
	end
	return maks[1][3]
end





--[[
 *** Некоторые запчасти RC и Вертолетов, лодок совпадают.
 *** Будут конфликты создай дубликаты с указанием VehicleType для каждого отдельно
--]]
local VComp = {
	["Tires"] = {--tractionMultiplier, tractionLoss, tractionBias
		["Michelin 51"] = {"Automobile", 0.75, 0.80000001192093, 0.5},
		["Michelin 8"] = {"Automobile", 0.64999997615814, 0.85000002384186, 0.34999999403954},
		["Michelin 121"] = {"Automobile", 0.6700000166893, 0.75, 0.51999998092651},
		["Michelin 109"] = {"Automobile", 0.60000002384186, 0.85000002384186, 0.51999998092651},
		["Michelin 110"] = {"Automobile", 0.94999998807907, 0.64999997615814, 0.40000000596046},
		["Michelin 118"] = {"Automobile", 0.75, 0.85000002384186, 0.40000000596046},
		["Michelin 15"] = {"Bike", 1.5, 0.89999997615814, 0.46000000834465},
		["Michelin 25"] = {"Automobile", 0.55000001192093, 0.80000001192093, 0.5},
		["Michelin 81"] = {"Boat", 1.5, 15, 0.64999997615814},
		["Michelin 114"] = {"Automobile", 0.64999997615814, 0.80000001192093, 0.5},
		["Michelin 88"] = {"Automobile", 0.64999997615814, 0.85000002384186, 0.51999998092651},
		["Michelin 6"] = {"Automobile", 0.64999997615814, 0.75, 0.5},
		["Michelin 111"] = {"Automobile", 0.62000000476837, 0.88999998569489, 0.5},
		["Michelin 87"] = {"Bike", 1.2000000476837, 0.81999999284744, 0.50999999046326},
		["Michelin 56"] = {"Automobile", 0.87999999523163, 0.69999998807907, 0.46000000834465},
		["Michelin 22"] = {"Automobile", 0.5799999833107, 0.80000001192093, 0.5},
		["Michelin 90"] = {"Automobile", 0.55000001192093, 0.80000001192093, 0.47999998927116},
		["Michelin 124"] = {"Automobile", 0.60000002384186, 0.86000001430511, 0.54000002145767},
		["Michelin 58"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.46000000834465},
		["Michelin 133"] = {"Boat", 2.5, 15, 0.64999997615814},
		["Michelin 50"] = {"Automobile", 0.75, 0.85000002384186, 0.51999998092651},
		["Michelin 37"] = {"Boat", 2, 4.1999998092651, 0.69999998807907},
		["Michelin 68"] = {"Automobile", 0.64999997615814, 0.89999997615814, 0.50999999046326},
		["Michelin 43"] = {"RC", 0.80000001192093, 0.89999997615814, 0.49000000953674},
		["Michelin 89"] = {"Automobile", 0.75, 0.88999998569489, 0.5},
		["Michelin 53"] = {"Automobile", 0.69999998807907, 0.75, 0.50999999046326},
		["ANNAITE"] = {"Automobile", 0.85000002384186, 0.69999998807907, 0.46000000834465},
		["Michelin 78"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.47999998927116},
		["Michelin 67"] = {"Automobile", 0.64999997615814, 0.69999998807907, 0.46000000834465},
		["Michelin 49"] = {"Automobile", 0.89999997615814, 0.85000002384186, 0.5},
		["Michelin 16"] = {"Monster Truck", 0.77999997138977, 0.80000001192093, 0.55000001192093},
		["Michelin 18"] = {"Boat", 2.2000000476837, 12, 0.44999998807907},
		["Michelin 134"] = {"Boat", -3.5, 25, 0.40000000596046},
		["Michelin 41"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.51999998092651},
		["Michelin 44"] = {"Automobile", 0.55000001192093, 0.85000002384186, 0.5},
		["Michelin 122"] = {"Automobile", 0.60000002384186, 0.80000001192093, 0.46000000834465},
		["Michelin 98"] = {"Automobile", 0.94999998807907, 0.80000001192093, 0.44999998807907},
		["Michelin 96"] = {"Automobile", 0.85000002384186, 0.85000002384186, 0.5},
		["Michelin 71"] = {"Boat", 2, 15, 0.5},
		["Michelin 48"] = {"RC", 0.60000002384186, 0.89999997615814, 0.49000000953674},
		["КАМА-505"] = {"Automobile", 0.64999997615814, 0.80000001192093, 0.51999998092651},
		["Michelin 106"] = {"Automobile", 0.60000002384186, 0.85000002384186, 0.5},
		["Brigestone"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.5},
		["SAVA"] = {"Automobile", 0.75, 0.75, 0.51999998092651},
		["Michelin 104"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.49000000953674},
		["Michelin 76"] = {"Boat", 3, 15, 0.64999997615814},
		["Michelin 62"] = {"Automobile", 0.62000000476837, 0.69999998807907, 0.46000000834465},
		["Michelin 32"] = {"Automobile", 0.69999998807907, 0.86000001430511, 0.5},
		["Michelin 86"] = {"Automobile", 0.64999997615814, 0.69999998807907, 0.5},
		["Michelin 35"] = {"Automobile", 0.60000002384186, 0.75, 0.51999998092651},
		["Michelin 80"] = {"Automobile", 0.64999997615814, 0.80000001192093, 0.49000000953674},
		["Michelin 26"] = {"Automobile", 0.75, 0.89999997615814, 0.49000000953674},
		["Michelin 39"] = {"Automobile", 0.64999997615814, 0.85000002384186, 0.54000002145767},
		["Michelin 100"] = {"Plane", 1.5, 0.89999997615814, 0.85000002384186},
		["Michelin 5"] = {"Bike", 1.5, 0.89999997615814, 0.47999998927116},
		["Michelin 59"] = {"Automobile", 0.75, 0.80000001192093, 0.56000000238419},
		["Michelin 119"] = {"Automobile", 0.55000001192093, 0.87999999523163, 0.51999998092651},
		["Michelin 69"] = {"Bike", 1.6000000238419, 0.89999997615814, 0.47999998927116},
		["Michelin 30"] = {"Automobile", 0.69999998807907, 0.83999997377396, 0.52999997138977},
		["Michelin 40"] = {"Automobile", 0.80000001192093, 0.80000001192093, 0.5},
		["Michelin 61"] = {"Plane", 0.8299999833107, 45, 0.5},
		["Michelin 47"] = {"Automobile", 0.80000001192093, 0.85000002384186, 0.5},
		["Michelin 115"] = {"Automobile", 0.64999997615814, 0.9200000166893, 0.5},
		["Yokohama"] = {"Automobile", 0.85000002384186, 0.80000001192093, 0.47999998927116},
		["Michelin 13"] = {"Automobile", 0.60000002384186, 0.80000001192093, 0.40000000596046},
		["Matador 66"] = {"Automobile", 0.55000001192093, 0.89999997615814, 0.5},
		["Michelin 52"] = {"Automobile", 0.75, 0.80000001192093, 0.51999998092651},
		["Michelin 64"] = {"Automobile", 0.69999998807907, 0.87999999523163, 0.55000001192093},
		["Michelin 9"] = {"Boat", -1.5, 15, 0.44999998807907},
		["Michelin 101"] = {"Automobile", 0.64999997615814, 0.69999998807907, 0.46999999880791},
		["Michelin 125"] = {"Automobile", 0.89999997615814, 0.85000002384186, 0.47999998927116},
		["Michelin 45"] = {"Boat", 3.5, 3.5, 1},
		["Michelin 11"] = {"RC", 1.1000000238419, 0.75, 0.5},
		["Michelin 54"] = {"Automobile", 0.80000001192093, 0.80000001192093, 0.51999998092651},
		["Michelin 57"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.52999997138977},
		["Michelin 127"] = {"Automobile", 0.75, 0.89999997615814, 0.5},
		["Michelin 79"] = {"Automobile", 0.60000002384186, 0.83999997377396, 0.51999998092651},
		["Michelin 105"] = {"Automobile", 0.64999997615814, 0.80000001192093, 0.40000000596046},
		["Michelin 82"] = {"Automobile", 0.75, 0.64999997615814, 0.51999998092651},
		["Michelin 126"] = {"Automobile", 0.80000001192093, 0.89999997615814, 0.5},
		["Michelin 29"] = {"Quad", 0.69999998807907, 0.89999997615814, 0.49000000953674},
		["Hankook"] = {"Plane", 0.64999997615814, 0.89999997615814, 0.5},
		["Michelin 132"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.44999998807907},
		["Michelin 19"] = {"Automobile", 0.69999998807907, 0.85000002384186, 0.5},
		["ANNAITE TR"] = {"Trailer", 0.44999998807907, 0.75, 0.5},
		["Michelin 84"] = {"Automobile", 0.75, 0.89999997615814, 0.47999998927116},
		["Michelin 120"] = {"Automobile", 0.75, 0.85000002384186, 0.44999998807907},
		["Michelin 113"] = {"Automobile", 0.81999999284744, 0.69999998807907, 0.46000000834465},
		["Michelin 77"] = {"Automobile", 0.69999998807907, 0.69999998807907, 0.5},
		["Michelin 130"] = {"Automobile", 0.69999998807907, 0.89999997615814, 0.47999998927116},
		["Michelin 23"] = {"Monster Truck", 0.64999997615814, 0.85000002384186, 0.55000001192093},
		["Michelin 38"] = {"Automobile", 0.75, 0.69999998807907, 0.51999998092651},
		["Michelin 91"] = {"Automobile", 0.69999998807907, 0.89999997615814, 0.51999998092651},
		["Michelin 33"] = {"Automobile", 0.60000002384186, 0.89999997615814, 0.5},
		["Michelin 95"] = {"Automobile", 0.69999998807907, 0.89999997615814, 0.5},
		["Michelin 99"] = {"Automobile", 0.64999997615814, 0.75, 0.46000000834465},
		["Matador 74"] = {"Automobile", 0.55000001192093, 0.85000002384186, 0.46000000834465},
		["Michelin 102"] = {"Train", 0.97000002861023, 0.76999998092651, 0.50999999046326},
		["Michelin 60"] = {"Automobile", 0.69999998807907, 0.83999997377396, 0.55000001192093},
		["Michelin 107"] = {"Automobile", 0.69999998807907, 0.80000001192093, 0.54000002145767},
		["Michelin 103"] = {"Automobile", 0.85000002384186, 0.75, 0.40000000596046},
		["Michelin 34"] = {"Automobile", 0.75, 0.85000002384186, 0.5},
		["Michelin 10"] = {"Automobile", 1, 0.85000002384186, 0.5},
		["Michelin 55"] = {"Automobile", 0.75, 0.86000001430511, 0.47999998927116},
		["Michelin 117"] = {"Automobile", 0.64999997615814, 0.85000002384186, 0.56999999284744},
		["Michelin 42"] = {"Automobile", 0.60000002384186, 0.80000001192093, 0.5},
		["Michelin 36"] = {"Automobile", 0.55000001192093, 0.69999998807907, 0.47999998927116},
		["Michelin 14"] = {"Bike", 1.3999999761581, 0.85000002384186, 0.47999998927116},
		["Michelin 12"] = {"Bike", 1.7999999523163, 0.89999997615814, 0.47999998927116},
		["Michelin 108"] = {"Bike", 1.3999999761581, 0.89999997615814, 0.47999998927116},
		["Michelin 65"] = {"Automobile", 0.64999997615814, 0.69999998807907, 0.51999998092651},
		["Michelin 75"] = {"Boat", 2.2999999523163, 15, 0.5799999833107},
		["Michelin 46"] = {"Automobile", 0.69999998807907, 0.85000002384186, 0.54000002145767},
		["Michelin 128"] = {"Automobile", 0.5, 0.69999998807907, 0.46000000834465},
		["Michelin 85"] = {"Monster Truck", 0.64999997615814, 0.85000002384186, 0.5},
		["Michelin 131"] = {"Automobile", 0.85000002384186, 0.80000001192093, 0.46000000834465},
		["Michelin 112"] = {"Automobile", 0.60000002384186, 0.87000000476837, 0.50999999046326},
		["Michelin 123"] = {"Automobile", 0.75, 0.69999998807907, 0.46000000834465},
		["Michelin 17"] = {"Automobile", 0.75, 0.85000002384186, 0.50999999046326},
		["Michelin 20"] = {"Automobile", 0.85000002384186, 0.80000001192093, 0.60000002384186},
		["Michelin 28"] = {"Automobile", 0.69999998807907, 0.69999998807907, 0.46000000834465},
		["Michelin 63"] = {"Automobile", 0.75, 0.83999997377396, 0.52999997138977},
		["Michelin 94"] = {"RC", 0.20000000298023, 0.89999997615814, 0.5},
		["Michelin 129"] = {"Plane", 0.55000001192093, 0.80000001192093, 0.69999998807907},
		["Michelin 73"] = {"Plane", 0.050000000745058, 1, 0.5},
		["Michelin 27"] = {"Automobile", 0.80000001192093, 0.75, 0.55000001192093},
		["Michelin 72"] = {"Automobile", 0.80000001192093, 0.75, 0.44999998807907},
		["Michelin 24"] = {"Automobile", 0.72000002861023, 0.69999998807907, 0.46000000834465},
		["Michelin 93"] = {"Automobile", 2.5, 0.80000001192093, 0.5},
		["Michelin 70"] = {"Automobile", 0.80000001192093, 0.80000001192093, 0.50999999046326},
		["Michelin 83"] = {"Automobile", 0.85000002384186, 0.80000001192093, 0.5},
		["Michelin 31"] = {"Automobile", 0.80000001192093, 0.85000002384186, 0.46999999880791},
		["Michelin 116"] = {"Automobile", 0.75, 0.75, 0.5},
		["Michelin 92"] = {"Automobile", 0.75, 0.80000001192093, 0.46999999880791}
	},
	["Brakes"] = { -- VehicleType, brakeDeceleration brakeBias
		["Wilwood 245mm"] = {"Automobile", 8.5, 0.30000001192093},
		["Wilwood 120mm"] = {"Automobile", 3.5, 0.40000000596046},
		["Brembo 170mm"] = {"Automobile", 5, 0.5},
		["Brembo 57"] = {"Boat", 0.019999999552965, 0},
		["Endless 200mm"] = {"Automobile", 6.1999998092651, 0.60000002384186},
		["Brembo 210mm"] = {"Automobile", 7, 0.5},
		["Wilwood 212mm"] = {"Monster Truck", 7, 0.44999998807907},
		["Wilwood 200mm"] = {"Automobile", 6.4000000953674, 0.44999998807907},
		["Endless 230mm"] = {"Automobile", 8, 0.5799999833107},
		["Brembo 12"] = {"RC", 5.5, 0.5},
		["Endless 160mm"] = {"Automobile", 4.5, 0.80000001192093},
		["Brembo 15"] = {"Monster Truck", 3.1700000762939, 0.40000000596046},
		["Brembo 5"] = {"Bike", 15, 0.5},
		["Wilwood 240mm"] = {"Automobile", 8.3999996185303, 0.44999998807907},
		["Endless 260mm"] = {"Automobile", 10, 0.51999998092651},
		["Endless 180mm"] = {"Automobile", 5.4000000953674, 0.60000002384186},
		["Endless 165mm"] = {"Automobile", 4.5, 0.60000002384186},
		["Brembo 205mm"] = {"Automobile", 6.5, 0.5},
		["Wilwood 230mm"] = {"Automobile", 8, 0.44999998807907},
		["Endless 245mm"] = {"Automobile", 8.5, 0.51999998092651},
		["Brembo 79"] = {"Plane", 1.5, 0.15000000596046},
		["Endless 150mm"] = {"Automobile", 4, 0.60000002384186},
		["Endless 195mm"] = {"Automobile", 6.0999999046326, 0.55000001192093},
		["Wilwood 175mm"] = {"Automobile", 5, 0.51999998092651},
		["Endless 205mm"] = {"Automobile", 6.1999998092651, 0.55000001192093},
		["Brembo 81"] = {"Boat", 0.03999999910593, 0.0099999997764826},
		["Endless 250mm"] = {"Automobile", 9, 0.55000001192093},
		["Endless 120mm"] = {"Automobile", 3.5, 0.60000002384186},
		["Brembo 61"] = {"Plane", 1, 0.5},
		["Brembo 69"] = {"Plane", 0.5, 0.5},
		["Wilwood 260mm"] = {"Automobile", 10, 0.40000000596046},
		["Brembo 260mm"] = {"Automobile", 10, 0.5},
		["Endless 190mm"] = {"Automobile", 6, 0.55000001192093},
		["Endless 215mm"] = {"Automobile", 7, 0.55000001192093},
		["Wilwood 155mm"] = {"Automobile", 4.1700000762939, 0.40000000596046},
		["Wilwood 150mm"] = {"Automobile", 4, 0.40000000596046},
		["Brembo 10"] = {"Helicopter", 5, 0.44999998807907},
		["Endless 155mm"] = {"Automobile", 4.1700000762939, 0.80000001192093},
		["Wilwood 170mm"] = {"Automobile", 5, 0.40000000596046},
		["Brembo 230mm"] = {"Automobile", 8, 0.5},
		["Wilwood 190mm"] = {"Automobile", 6, 0.40000000596046},
		["Brembo 245mm"] = {"Automobile", 8.5, 0.5},
		["Wilwood 340mm"] = {"Automobile", 15, 0.20000000298023},
		["Wilwood 210mm"] = {"Automobile", 7, 0.43999999761581},
		["Wilwood 275mm"] = {"Automobile", 11.10000038147, 0.47999998927116},
		["Brembo 52"] = {"Plane", 0.0099999997764826, 0.050000000745058},
		["Brembo 33"] = {"Plane", 1, 0.44999998807907},
		["Brembo 37"] = {"Boat", 0.070000000298023, 0.0099999997764826},
		["Endless 255mm"] = {"Automobile", 9.1000003814697, 0.60000002384186},
		["Ferodo GT"] = {"BMX", 19, 0.5},
		["Endless 275mm"] = {"Automobile", 11.10000038147, 0.51999998092651},
		["Endless 185mm"] = {"Automobile", 5.5, 0.44999998807907},
		["Wilwood 185mm"] = {"Automobile", 5.5, 0.60000002384186},
		["Brembo 62"] = {"Bike", 14, 0.5},
		["Endless 235mm"] = {"Automobile", 8, 0.51999998092651},
		["Endless 175mm"] = {"Automobile", 5, 0.60000002384186},
		["Endless 153mm"] = {"Automobile", 4, 0.80000001192093},
		["Wilwood 270mm"] = {"Automobile", 11, 0.44999998807907},
		["Brembo 82"] = {"Boat", 0.03999999910593, 0.029999999329448},
		["Endless 210mm"] = {"Automobile", 7, 0.51999998092651},
		["Endless 236mm"] = {"Automobile", 8.1700000762939, 0.51999998092651},
		["Brembo 9"] = {"Boat", 0.019999999552965, 0.019999999552965},
		["Brembo 2"] = {"Plane", 1.5, 0.44999998807907},
		["Brembo 71"] = {"Train", 8.5, 0.44999998807907},
		["Brembo 18"] = {"Boat", 0.050000000745058, 0.0099999997764826},
		["Endless 220mm"] = {"Automobile", 7.5, 0.64999997615814},
		["Endless 231mm"] = {"Automobile", 8, 0.60000002384186},
		["Endless 234mm"] = {"Automobile", 8, 0.64999997615814},
		["Wilwood 262mm"] = {"Automobile", 10, 0.44999998807907},
		["Endless 232mm"] = {"Automobile", 8, 0.55000001192093},
		["Brembo 300mm"] = {"Automobile", 13, 0.5},
		["Brembo 4"] = {"Trailer", 8, 0.30000001192093},
		["Brembo 64"] = {"Boat", 0.029999999329448, 0.0099999997764826},
		["Endless 233mm"] = {"Automobile", 8, 0.80000001192093},
		["Brembo 190mm"] = {"Automobile", 6, 0.5},
		["Wilwood 187mm"] = {"Automobile", 5.6999998092651, 0.34999999403954},
		["Endless 170mm"] = {"Automobile", 5, 0.55000001192093},
		["Endless 193mm"] = {"Automobile", 6, 0.80000001192093},
		["Endless 265mm"] = {"Automobile", 10, 0.52999997138977},
		["Brembo 270mm"] = {"Automobile", 11, 0.50999999046326},
		["Brembo 14"] = {"Bike", 10, 0.55000001192093},
		["Wilwood 180mm"] = {"Automobile", 5.4000000953674, 0.44999998807907},
	},
	["Suspension"] = { --VehicleType, suspensionForceLevel suspensionDamping suspensionHighSpeedDamping suspensionUpperLimit suspensionLowerLimit suspensionFrontRearBias suspensionAntiDiveMultiplier
		["Macpherson V61"] = {"Automobile", 1.2000000476837, 0.10000000149012, 0, 0.46999999880791, -0.10999999940395, 0.5, 0},
		["Macpherson TR"] = {"Trailer", 1.5, 0.050000000745058, 0, 0.30000001192093, -0.15000000596046, 0.5, 0},
		["Macpherson V155"] = {"Automobile", 1.2999999523163, 0.12999999523163, 0, 0.27000001072884, -0.15000000596046, 0.5, 0.30000001192093},
		["Lower Suspension Kit 2"] = {"Automobile", 1.2000000476837, 0.18999999761581, 0, 0.25, -0.10000000149012, 0.5, 0.40000000596046},
		["Macpherson V52"] = {"RC", 3, 0.30000001192093, 0, 0.15000000596046, -0.15000000596046, 0.5, 0},
		["Macpherson V23"] = {"Monster Truck", 1.5, 0.070000000298023, 0, 0.44999998807907, -0.30000001192093, 0.5, 0.30000001192093},
		["Macpherson V58"] = {"Automobile", 1, 0.050000000745058, 0, 0.34999999403954, -0.20000000298023, 0.5799999833107, 0},
		["Macpherson V90"] = {"Automobile", 1.2000000476837, 0.11999999731779, 0, 0.30000001192093, -0.15000000596046, 0.5, 0.40000000596046},
		["Macpherson V82"] = {"Automobile", 0.80000001192093, 0.079999998211861, 2, 0.25, -0.15000000596046, 0.40000000596046, 0.40000000596046},
		["Macpherson V78"] = {"Automobile", 1.1000000238419, 0.11999999731779, 5, 0.31999999284744, -0.20000000298023, 0.5, 0},
		["Macpherson V64"] = {"Automobile", 1.1000000238419, 0.090000003576279, 0, 0.30000001192093, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V87"] = {"Boat", 0.75, 4, 0, 0.10000000149012, 0.30000001192093, 1.5, 0},
		["Macpherson V128"] = {"Automobile", 0.80000001192093, 0.070000000298023, 0, 0.30000001192093, -0.14000000059605, 0.5, 0.25},
		["Macpherson V8"] = {"Automobile", 1.5, 0.03999999910593, 0, 0.44999998807907, -0.25, 0.5, 0},
		["Macpherson V144"] = {"Automobile", 1.2000000476837, 0.11999999731779, 0, 0.28000000119209, -0.23999999463558, 0.5, 0.40000000596046},
		["Macpherson V9"] = {"Boat", 1, 3, 0, 0.10000000149012, 0.10000000149012, 0, 0},
		["Macpherson V93"] = {"Helicopter", 1.5, 0.10000000149012, 0, 0.20000000298023, -0.15000000596046, 0.5, 0},
		["Macpherson V50"] = {"Automobile", 2, 0.14000000059605, 0, 0.25, -0.20000000298023, 0.5, 0},
		["Macpherson V123"] = {"Automobile", 1.3999999761581, 0.14000000059605, 3, 0.28000000119209, -0.15000000596046, 0.5, 0.30000001192093},
		["Macpherson V137"] = {"Automobile", 1, 0.090000003576279, 0, 0.31999999284744, -0.15000000596046, 0.54000002145767, 0},
		["Macpherson V164"] = {"Automobile", 1.2999999523163, 0.070000000298023, 0, 0.34999999403954, -0.15000000596046, 0.44999998807907, 0},
		["Macpherson V25"] = {"Automobile", 1.6000000238419, 0.070000000298023, 0, 0.34999999403954, -0.15000000596046, 0.25, 0},
		["Macpherson V46"] = {"Plane", 1.5, 0.15000000596046, 0, 0.5, -0.050000000745058, 0.20000000298023, 0},
		["Macpherson V6"] = {"Automobile", 1, 0.079999998211861, 0, 0.30000001192093, -0.20000000298023, 0.5, 0.30000001192093},
		["Macpherson V161"] = {"Automobile", 1.2000000476837, 0.20000000298023, 0, 0.34999999403954, -0.15000000596046, 0.44999998807907, 0},
		["Macpherson V41"] = {"Automobile", 1, 0.059999998658895, 3, 0.34999999403954, -0.23999999463558, 0.5, 0},
		["Macpherson V101"] = {"Automobile", 1, 0.15000000596046, 0, 0.15000000596046, -0.050000000745058, 0.5, 0},
		["Macpherson V44"] = {"Automobile", 1.1000000238419, 0.15000000596046, 0, 0.31999999284744, -0.14000000059605, 0.5, 0},
		["Macpherson V95"] = {"Plane", 0.5, 0.050000000745058, 0, 0.33000001311302, -0.25, 0.5, 0.019999999552965},
		["Offroad Suspension Kit"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.44999998807907, -0.25, 0.44999998807907, 0.30000001192093},
		["Macpherson V26"] = {"Automobile", 1.2000000476837, 0.079999998211861, 0, 0.46999999880791, -0.17000000178814, 0.5, 0},
		["Macpherson V63"] = {"Automobile", 1, 0.11999999731779, 0, 0.28000000119209, -0.11999999731779, 0.55000001192093, 0},
		["Macpherson V40"] = {"Boat", 1, 3, 0, 3.2000000476837, 0.10000000149012, 2.5, 0},
		["Macpherson V31"] = {"Helicopter", 2, 0.15000000596046, 0, 0.5, -0.20000000298023, 0.5, 0},
		["Macpherson V19"] = {"Automobile", 1.5, 0.079999998211861, 4, 0.34999999403954, -0.34999999403954, 0.5, 0},
		["Macpherson V76"] = {"Automobile", 0.69999998807907, 0.059999998658895, 1, 0.30000001192093, -0.25, 0.5, 0.25},
		["Macpherson V94"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.25, -0.15000000596046, 0.54000002145767, 0},
		["Macpherson V162"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.20000000298023, -0.20000000298023, 0.54000002145767, 0.40000000596046},
		["Macpherson V97"] = {"Boat", 0.44999998807907, 5, 0, 0.10000000149012, 0.050000000745058, 0, 0},
		["Macpherson V150"] = {"Automobile", 1.1000000238419, 0.10000000149012, 0, 0.27000001072884, -0.21999999880791, 0.5, 0.30000001192093},
		["Macpherson V139"] = {"Automobile", 1.1000000238419, 0.14000000059605, 0, 0.31999999284744, -0.14000000059605, 0.5, 0},
		["Macpherson V89"] = {"Train", 1.3999999761581, 0.059999998658895, 0, 0.44999998807907, -0.10000000149012, 0.55000001192093, 0},
		["Macpherson V45"] = {"Automobile", 1.1000000238419, 0.070000000298023, 0, 0.34999999403954, -0.20000000298023, 0.5, 0},
		["Macpherson V159"] = {"Automobile", 1, 0.10000000149012, 0, 0.34999999403954, -0.17000000178814, 0.5, 0.5},
		["Macpherson V34"] = {"Train", 1.3999999761581, 0.059999998658895, 0, 0.44999998807907, 0, 0.55000001192093, 0},
		["Macpherson V132"] = {"Automobile", 0.44999998807907, 0.10000000149012, 0, 0.10000000149012, -0.15000000596046, 0.5, 0.5},
		["Macpherson V165"] = {"Automobile", 1.5, 0.20000000298023, 0, 0.25, -0.03999999910593, 0.5, 0},
		["Macpherson V98"] = {"Bike", 1, 0.15000000596046, 0, 0.11999999731779, -0.17000000178814, 0.5, 0},
		["Macpherson V20"] = {"Automobile", 1.3999999761581, 0.15000000596046, 0, 0.25, -0.20000000298023, 0.34999999403954, 0},
		["Macpherson V140"] = {"Bike", 0.85000002384186, 0.15000000596046, 0, 0.15000000596046, -0.20000000298023, 0.5, 0},
		["Macpherson V160"] = {"Automobile", 1.1000000238419, 0.079999998211861, 0, 0.34999999403954, -0.10000000149012, 0.40000000596046, 0.5},
		["Macpherson V156"] = {"Automobile", 1.6000000238419, 0.059999998658895, 0, 0.40000000596046, -0.20000000298023, 0.5, 0},
		["Macpherson V111"] = {"Automobile", 1, 0.10000000149012, 0, 0.27000001072884, -0.17000000178814, 0.5, 0.20000000298023},
		["Macpherson V120"] = {"Automobile", 1, 0.070000000298023, 0, 0.40000000596046, -0.20000000298023, 0.5, 0},
		["Macpherson V43"] = {"Automobile", 1.2000000476837, 0.15000000596046, 0, 0.28000000119209, -0.20000000298023, 0.5, 0.30000001192093},
		["Macpherson V173"] = {"Automobile", 1.1000000238419, 0.079999998211861, 2, 0.31000000238419, -0.18000000715256, 0.55000001192093, 0.30000001192093},
		["Macpherson V36"] = {"Automobile", 1, 0.059999998658895, 0, 0.44999998807907, -0.25, 0.55000001192093, 0.30000001192093},
		["Macpherson V130"] = {"Helicopter", 1, 0.050000000745058, 0, 0.5, -0.20000000298023, 0.89999997615814, 0},
		["Macpherson V70"] = {"Automobile", 1, 0.10000000149012, 0, 0.34999999403954, -0.15000000596046, 0.5, 0.30000001192093},
		["Macpherson V113"] = {"Plane", 2, 0.15000000596046, 0, 1, -0.10000000149012, 0.34999999403954, 0},
		["Macpherson V149"] = {"Helicopter", 0.60000002384186, 0.050000000745058, 0, 0.5, -0.10000000149012, 0.30000001192093, 0},
		["Macpherson V91"] = {"Plane", 1, 0.10000000149012, 0, 0.40000000596046, -0.30000001192093, 0.5, 0},
		["Macpherson V143"] = {"Automobile", 0.69999998807907, 0.10000000149012, 0, 0.20000000298023, -0.17000000178814, 0.5, 0},
		["Macpherson V154"] = {"Automobile", 1.2000000476837, 0.070000000298023, 0, 0.44999998807907, -0.25, 0.44999998807907, 0},
		["Macpherson V138"] = {"Unknown", 1, 0.10000000149012, 0, 0.25, -0.10000000149012, 0.5, 0},
		["Macpherson V151"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.34999999403954, -0.15000000596046, 0.55000001192093, 0},
		["Macpherson V71"] = {"Automobile", 0.5, 0.10000000149012, 0, 0, -0.20000000298023, 0.40000000596046, 0.60000002384186},
		["Macpherson V55"] = {"Automobile", 1.2999999523163, 0.11999999731779, 0, 0.28000000119209, -0.11999999731779, 0.37999999523163, 0},
		["Macpherson V104"] = {"Helicopter", 1, 0.050000000745058, 0, 0.20000000298023, -0.15000000596046, 0.85000002384186, 0},
		["Macpherson V167"] = {"Automobile", 0.80000001192093, 0.20000000298023, 0, 0.10000000149012, -0.15000000596046, 0.5, 0.60000002384186},
		["Macpherson V53"] = {"Automobile", 2, 0.11999999731779, 0, 0.25, -0.050000000745058, 0.5, 0},
		["Macpherson V17"] = {"Automobile", 0.69999998807907, 0.059999998658895, 2, 0.25, -0.30000001192093, 0.5, 0.5},
		["Macpherson V33"] = {"Automobile", 1.2999999523163, 0.15000000596046, 0, 0.28000000119209, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V117"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.40000000596046, -0.25, 0.5, 0},
		["Macpherson V83"] = {"Automobile", 2.5999999046326, 0.070000000298023, 0, 0.34999999403954, -0.15000000596046, 0.25, 0},
		["Macpherson V27"] = {"Automobile", 1.7000000476837, 0.10000000149012, 0, 0.28000000119209, -0.11999999731779, 0.5, 0},
		["Macpherson V116"] = {"Automobile", 1.6000000238419, 0.10000000149012, 5, 0.30000001192093, -0.15000000596046, 0.5, 0.30000001192093},
		["Macpherson V2"] = {"Plane", 1, 0.15000000596046, 0, 0.5, -0.20000000298023, 0.80000001192093, 0},
		["Macpherson V54"] = {"Automobile", 1.2000000476837, 0.10000000149012, 5, 0.31000000238419, -0.15000000596046, 0.5, 0.20000000298023},
		["Macpherson V99"] = {"Automobile", 1.6000000238419, 0.11999999731779, 0, 0.34999999403954, -0.18000000715256, 0.40000000596046, 0},
		["Macpherson V166"] = {"Automobile", 1, 0.15000000596046, 0, 0.28000000119209, -0.15999999642372, 0.5, 0.30000001192093},
		["Macpherson V28"] = {"Automobile", 1.2000000476837, 0.10000000149012, 0, 0.30000001192093, -0.20000000298023, 0.5, 0},
		["Macpherson V103"] = {"Automobile", 1.1000000238419, 0.15000000596046, 0, 0.27000001072884, -0.079999998211861, 0.54000002145767, 0.30000001192093},
		["Macpherson V114"] = {"Automobile", 1, 0.10000000149012, 0, 0.30000001192093, -0.10000000149012, 0.5, 0.25},
		["Macpherson V51"] = {"Automobile", 1, 0.20000000298023, 0, 0.28000000119209, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V14"] = {"Bike", 0.64999997615814, 0.20000000298023, 0, 0.090000003576279, -0.10999999940395, 0.55000001192093, 0},
		["Macpherson V121"] = {"Automobile", 0.40000000596046, 0.019999999552965, 0, 0.34999999403954, -0.10000000149012, 0.5, 0},
		["Macpherson V69"] = {"Automobile", 0.80000001192093, 0.10000000149012, 0, 0.31000000238419, -0.15000000596046, 0.5, 0.5},
		["Macpherson V77"] = {"Plane", 1.5, 0.75, 0, 0.10000000149012, 0, 2, 0},
		["Macpherson V10"] = {"Helicopter", 2, 0.10000000149012, 0, 0.5, -0.20000000298023, 0.5, 0},
		["Macpherson V5"] = {"Bike", 0.85000002384186, 0.15000000596046, 0, 0.15000000596046, -0.15999999642372, 0.5, 0},
		["Macpherson V168"] = {"Automobile", 1.3999999761581, 0.15000000596046, 0, 0.28000000119209, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V84"] = {"Automobile", 0.69999998807907, 0.079999998211861, 1, 0.30000001192093, -0.18000000715256, 0.5, 0},
		["Macpherson V170"] = {"Plane", 4, 0.15000000596046, 0, 1, 0, 0.30000001192093, 0},
		["Macpherson V57"] = {"Automobile", 1.2000000476837, 0.10000000149012, 0, 0.27000001072884, -0.17000000178814, 0.5, 0.20000000298023},
		["Macpherson V172"] = {"Automobile", 1.2000000476837, 0.15000000596046, 0, 0.34000000357628, -0.10000000149012, 0.5, 0},
		["Macpherson V157"] = {"Automobile", 1, 0.050000000745058, 1, 0.34999999403954, -0.18000000715256, 0.5, 0},
		["Macpherson V136"] = {"Automobile", 1, 0.10000000149012, 0, 0.25, -0.20000000298023, 0.5, 0},
		["Macpherson V110"] = {"Automobile", 0.80000001192093, 0.079999998211861, 3, 0.25, -0.15000000596046, 0.40000000596046, 0.40000000596046},
		["Macpherson V107"] = {"Automobile", 1.1000000238419, 0.10000000149012, 0, 0.28000000119209, -0.15000000596046, 0.5, 0.30000001192093},
		["Macpherson V147"] = {"Automobile", 0.89999997615814, 0.079999998211861, 0, 0.25, -0.25, 0.34999999403954, 0.60000002384186},
		["Macpherson V108"] = {"Automobile", 1, 0.12999999523163, 5, 0.25, -0.10000000149012, 0.44999998807907, 0.30000001192093},
		["Macpherson V115"] = {"Automobile", 1.6000000238419, 0.15000000596046, 0, 0.34000000357628, -0.10000000149012, 0.5, 0},
		["Macpherson V109"] = {"Monster Truck", 0.80000001192093, 0.10000000149012, 0, 0.40000000596046, -0.40000000596046, 0.5, 0.30000001192093},
		["Macpherson V122"] = {"RC", 0.60000002384186, 0.10000000149012, 0, 0.25, 0, 0.80000001192093, 0},
		["Macpherson V7"] = {"Automobile", 0.89999997615814, 0.12999999523163, 3, 0.30000001192093, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V11"] = {"Automobile", 2, 0.090000003576279, 0, 0.25, -0.10000000149012, 0.5, 0},
		["Macpherson V21"] = {"Automobile", 1.5, 0.10000000149012, 10, 0.28999999165535, -0.15999999642372, 0.60000002384186, 0.40000000596046},
		["Macpherson V60"] = {"Automobile", 1, 0.20000000298023, 0, 0.25, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V73"] = {"Automobile", 0.89999997615814, 0.079999998211861, 0, 0.28000000119209, -0.17000000178814, 0.55000001192093, 0},
		["Macpherson V72"] = {"Automobile", 1, 0.079999998211861, 0, 0.28000000119209, -0.20000000298023, 0.44999998807907, 0.30000001192093},
		["Macpherson V86"] = {"Automobile", 1.2000000476837, 0.10000000149012, 0, 0.31000000238419, -0.15000000596046, 0.5, 0.30000001192093},
		["Macpherson V92"] = {"Automobile", 0.64999997615814, 0.070000000298023, 0, 0.15000000596046, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V112"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.34999999403954, -0.31000000238419, 0.5, 0},
		["Macpherson V1"] = {"Automobile", 1.2000000476837, 0.079999998211861, 0, 0.31999999284744, -0.20000000298023, 0.34999999403954, 0.40000000596046},
		["Macpherson V29"] = {"Automobile", 1.2000000476837, 0.050000000745058, 0, 0.46999999880791, -0.17000000178814, 0.5, 0},
		["Macpherson V118"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.28000000119209, -0.23999999463558, 0.58999997377396, 0.40000000596046},
		["Macpherson V148"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.27000001072884, -0.10000000149012, 0.5799999833107, 0.30000001192093},
		["Macpherson V126"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.30000001192093, -0.15000000596046, 0.5, 0.25},
		["Macpherson V24"] = {"Automobile", 0.60000002384186, 0.079999998211861, 0, 0.30000001192093, -0.23999999463558, 0.40000000596046, 0.60000002384186},
		["Macpherson V80"] = {"Automobile", 1, 0.10000000149012, 0, 0.30000001192093, -0.15000000596046, 0.43999999761581, 0.25},
		["Macpherson V66"] = {"Automobile", 1.1000000238419, 0.11999999731779, 0, 0.28000000119209, -0.17000000178814, 0.55000001192093, 0},
		["Macpherson V59"] = {"Automobile", 0.69999998807907, 0.15000000596046, 0, 0.34000000357628, -0.20000000298023, 0.5, 0.5},
		["Macpherson V67"] = {"Automobile", 1.5, 0.070000000298023, 2, 0.34999999403954, -0.15000000596046, 0.40000000596046, 0},
		["Macpherson V30"] = {"Quad", 0.80000001192093, 0.10000000149012, 0, 0.15000000596046, -0.15000000596046, 0.5, 0},
		["Macpherson V13"] = {"Automobile", 1, 0.11999999731779, 0, 0.23999999463558, -0.20000000298023, 0.5, 0.5},
		["Macpherson V163"] = {"Automobile", 1, 0.090000003576279, 0, 0.30000001192093, -0.11999999731779, 0.55000001192093, 0},
		["Macpherson V102"] = {"Automobile", 0.80000001192093, 0.070000000298023, 0, 0.34999999403954, -0.21999999880791, 0.5, 0.5},
		["Macpherson V38"] = {"Automobile", 1.3999999761581, 0.050000000745058, 0, 0.43000000715256, -0.10999999940395, 0.5, 0},
		["Macpherson V131"] = {"Plane", 2, 0.15000000596046, 0, 0.5, -0.10000000149012, 0.89999997615814, 0},
		["Macpherson V74"] = {"Automobile", 1.6000000238419, 0.11999999731779, 0, 0.34999999403954, -0.14000000059605, 0.5, 0.30000001192093},
		["Macpherson V133"] = {"Plane", 1.5, 0.15000000596046, 0, 0.5, -0.20000000298023, 0.30000001192093, 0},
		["Macpherson V100"] = {"Automobile", 1, 0.090000003576279, 0, 0.31999999284744, -0.15999999642372, 0.56000000238419, 0},
		["Macpherson V47"] = {"Automobile", 1, 0.090000003576279, 0, 0.28000000119209, -0.12999999523163, 0.5, 0},
		["Lower Suspension Kit 1"] = {"Automobile", 1.2000000476837, 0.12999999523163, 0, 0.15000000596046, -0.20000000298023, 0.5, 0.40000000596046},
		["Macpherson V134"] = {"Train", 1.2999999523163, 0.079999998211861, 0, 0, -1, 0.40000000596046, 0.5},
		["Macpherson V18"] = {"Boat", 1.7999999523163, 3, 0, 0.10000000149012, 0.10000000149012, 0, 0},
		["Macpherson V75"] = {"Automobile", 1, 0.10000000149012, 0, 0.30000001192093, -0.15000000596046, 0.30000001192093, 0.25},
		["Macpherson V106"] = {"Automobile", 1, 0.20000000298023, 0, 0.27000001072884, -0.20000000298023, 0.5, 0.34999999403954},
		["Macpherson V135"] = {"BMX", 0.80000001192093, 0.15000000596046, 0, 0.20000000298023, -0.10000000149012, 0.5, 0},
		["Macpherson V15"] = {"Monster Truck", 0.80000001192093, 0.059999998658895, 0, 0.20000000298023, -0.30000001192093, 0.55000001192093, 0},
		["Macpherson V142"] = {"Automobile", 0.80000001192093, 0.079999998211861, 0, 0.28000000119209, -0.20000000298023, 0.40000000596046, 0.30000001192093},
		["Macpherson V153"] = {"Automobile", 1.5, 0.10000000149012, 5, 0.34999999403954, -0.18000000715256, 0.40000000596046, 0},
		["Macpherson V96"] = {"Automobile", 2, 0.070000000298023, 5, 0.30000001192093, -0.15000000596046, 0.5, 0},
		["Macpherson V145"] = {"Automobile", 1, 0.050000000745058, 0, 0.44999998807907, -0.20999999344349, 0.44999998807907, 0.30000001192093},
		["Macpherson V68"] = {"Automobile", 1.2999999523163, 0.079999998211861, 5, 0.30000001192093, -0.20000000298023, 0.5, 0.25},
		["Macpherson V141"] = {"Automobile", 0.69999998807907, 0.079999998211861, 3, 0.30000001192093, -0.15999999642372, 0.5, 0.5},
		["Macpherson V12"] = {"RC", 1.6000000238419, 0.10000000149012, 0, 0.28000000119209, -0.079999998211861, 0.5, 0},
		["Macpherson V152"] = {"Automobile", 1.2000000476837, 0.10000000149012, 0, 0.34999999403954, -0.15000000596046, 0.5, 0},
		["Macpherson V85"] = {"Automobile", 1, 0.15000000596046, 0, 0.27000001072884, -0.18999999761581, 0.5, 0.55000001192093},
		["Macpherson V119"] = {"Automobile", 2.4000000953674, 0.079999998211861, 0, 0.28000000119209, -0.14000000059605, 0.5, 0.25},
		["Macpherson V32"] = {"Automobile", 1.2000000476837, 0.15000000596046, 0, 0.30000001192093, -0.10000000149012, 0.5, 0.25},
		["Macpherson V146"] = {"Automobile", 1.2999999523163, 0.070000000298023, 2, 0.40000000596046, -0.25, 0.40000000596046, 0.5},
		["Macpherson V169"] = {"Automobile", 1, 0.059999998658895, 0, 0.34999999403954, -0.15000000596046, 0.5, 0},
		["Macpherson V22"] = {"Automobile", 1.3999999761581, 0.059999998658895, 0, 0.44999998807907, -0.25, 0.55000001192093, 0},
		["Macpherson V88"] = {"BMX", 0.85000002384186, 0.15000000596046, 0, 0.20000000298023, -0.10000000149012, 0.5, 0},
		["Macpherson V16"] = {"Automobile", 1.2000000476837, 0.15000000596046, 0, 0.30000001192093, -0.10000000149012, 0.5, 0.30000001192093},
		["Macpherson V125"] = {"Plane", 2, 0.15000000596046, 0, 0.55000001192093, -0.050000000745058, 0.5, 0},
		["Macpherson V105"] = {"Boat", 1, 3, 0, 0.10000000149012, 0.5, 2, 0},
		["Macpherson V81"] = {"Automobile", 1, 0.10000000149012, 5, 0.25, -0.20000000298023, 0.34999999403954, 0},
		["Macpherson V62"] = {"RC", 1.6000000238419, 0.10000000149012, 0, 0.28000000119209, -0.14000000059605, 0.5, 0},
		["Macpherson V171"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.37000000476837, -0.17000000178814, 0.5, 0},
		["Macpherson V39"] = {"Automobile", 1.7999999523163, 0.11999999731779, 0, 0.30000001192093, -0.25, 0.5, 0},
		["Macpherson V3"] = {"Automobile", 1.7999999523163, 0.070000000298023, 0, 0.34999999403954, -0.18000000715256, 0.25, 0},
		["Macpherson V175"] = {"Boat", 1, 3, 0, 0.10000000149012, 0, 1, 0},
		["Macpherson V127"] = {"Automobile", 1, 0.079999998211861, 0, 0.20000000298023, -0.25, 0.5, 0.60000002384186},
		["Macpherson V42"] = {"Automobile", 0.80000001192093, 0.10000000149012, 0, 0.30000001192093, -0.15000000596046, 0.5, 0},
		["Macpherson V56"] = {"Automobile", 1, 0.10000000149012, 0, 0.34999999403954, -0.15000000596046, 0.40000000596046, 0},
		["Macpherson V35"] = {"Automobile", 1.3999999761581, 0.11999999731779, 0, 0.30000001192093, -0.079999998211861, 0.5, 0},
		["Macpherson V124"] = {"Automobile", 1.3999999761581, 0.10000000149012, 0, 0.28000000119209, -0.11999999731779, 0.5, 0},
		["Macpherson V79"] = {"Automobile", 1.5, 0.10999999940395, 0, 0.30000001192093, -0.15000000596046, 0.5, 0},
		["Macpherson V129"] = {"Automobile", 1.2999999523163, 0.079999998211861, 0, 0.31000000238419, -0.15000000596046, 0.56999999284744, 0},
		["Macpherson V48"] = {"Boat", 1, 4.5, 0, 3.5, 0.10000000149012, 0.69999998807907, 0},
		["Macpherson V174"] = {"Boat", 1.2999999523163, 3, 0, 0.10000000149012, 0.5, 2, 0},
		["Macpherson V37"] = {"Automobile", 1, 0.070000000298023, 5, 0.20000000298023, -0.15000000596046, 0.44999998807907, 0}
	},
	["Transmission"] = {-- VehicleType, Количество передач, привод, макс.скорость
		["A5 140"] = {"Automobile", 5, "awd", 140},
		["F5 180"] = {"Automobile", 5, "fwd", 180},
		["R3 60"] = {"Automobile", 3, "rwd", 60},
		["A5 160"] = {"Automobile", 5, "awd", 160},
		["R4 190"] = {"Bike", 4, "rwd", 190},
		["R5 200"] = {"Automobile", 5, "rwd", 200},
		["F3 160"] = {"Automobile", 3, "fwd", 160},
		["R4 70"] = {"Automobile", 4, "rwd", 70},
		["A5 165"] = {"Automobile", 5, "awd", 165},
		["A3 160"] = {"Automobile", 3, "awd", 160},
		["R5 180"] = {"Automobile", 5, "rwd", 180},
		["F3 60"] = {"Automobile", 3, "fwd", 60},
		["A4 150"] = {"Automobile", 4, "awd", 150},
		["R4 140"] = {"BMX", 4, "rwd", 140},
		["R4 130"] = {"Automobile", 4, "rwd", 130},
		["A5 170"] = {"Automobile", 5, "awd", 170},
		["R5 160"] = {"Automobile", 5, "rwd", 160},
		["F4 165"] = {"Automobile", 4, "fwd", 165},
		["F5 160"] = {"Automobile", 5, "fwd", 160},
		["R4 165"] = {"Automobile", 4, "rwd", 165},
		["R5 230"] = {"Automobile", 5, "rwd", 230},
		["A4 80"] = {"Automobile", 4, "awd", 80},
		["R3 160"] = {"Automobile", 3, "rwd", 160},
		["A5 180"] = {"Automobile", 5, "awd", 180},
		["R5 110"] = {"Automobile", 5, "rwd", 110},
		["R5 190"] = {"Bike", 5, "rwd", 190},
		["A4 160"] = {"Quad", 4, "awd", 160},
		["R4 170"] = {"Automobile", 4, "rwd", 170},
		["R3 190"] = {"Bike", 3, "rwd", 190},
		["A5 200"] = {"Automobile", 5, "awd", 200},
		["A5 155"] = {"Automobile", 5, "awd", 155},
		["A5 100"] = {"Automobile", 5, "awd", 100},
		["A5 110"] = {"Monster Truck", 5, "awd", 110},
		["F1 75"] = {"Plane", 1, "fwd", 75},
		["A1 75"] = {"Helicopter", 1, "awd", 75},
		["R5 170"] = {"Automobile", 5, "rwd", 170},
		["A5 240"] = {"Automobile", 5, "awd", 240},
		["A1 60"] = {"Automobile", 1, "awd", 60},
		["R5 120"] = {"Trailer", 5, "rwd", 120},
		["F5 200"] = {"Automobile", 5, "fwd", 200},
		["R4 90"] = {"Automobile", 4, "rwd", 90},
		["R4 160"] = {"Automobile", 4, "rwd", 160},
		["F5 165"] = {"Automobile", 5, "fwd", 165},
		["R5 140"] = {"Automobile", 5, "rwd", 140},
		["R5 220"] = {"Automobile", 5, "rwd", 220},
		["F4 160"] = {"Automobile", 4, "fwd", 160},
		["R5 165"] = {"Automobile", 5, "rwd", 165},
		["A1 200"] = {"Plane", 1, "awd", 200},
		["R4 110"] = {"Monster Truck", 4, "rwd", 110},
		["F5 150"] = {"Automobile", 5, "fwd", 150},
		["R5 150"] = {"Automobile", 5, "rwd", 150},
		["R5 145"] = {"Automobile", 5, "rwd", 145}
	},
	["Turbo"] = { -- VehicleType, +Engine acceleration, -Drag Coeff
		["Ticso 365"] = {"Automobile", 2, 1},
		["Twin Turbo C"] = {"Automobile", 0, 0.7000000476837}
	},
	["Engines"] = { -- VehicleType, Engine acceleration, Drag Coeff, EngineType, при весе авто, количество лс
		["LPE 2.2 L"] = {"Automobile", 7.1999998092651, 1.7999999523163, "petrol", 2200, 114},
		["BMX 1"] = {"BMX", 10, 5, "petrol", 100, 8},
		["SFP 2.0 L"] = {"Automobile", 9.6000003814697, 2, "petrol", 1500, 103},
		["RC Tiger Engine"] = {"RC", 14, 5, "electric", 100, 10},
		["TF D 1.7 L v2"] = {"Automobile", 10, 2.7000000476837, "diesel", 1700, 122},
		["ODL 1.7 L"] = {"Automobile", 11.199999809265, 2.4000000953674, "petrol", 1400, 112},
		["HLR 1.7 L"] = {"Automobile", 8, 2.5, "petrol", 1600, 92},
		["RR 500"] = {"Helicopter", 6.4000000953674, 0.10000000149012, "petrol", 3000, 138},
		["SFP D 1.7 L"] = {"Automobile", 9.6000003814697, 2.5, "diesel", 2600, 179},
		["RR 700"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 5000, 229},
		["TF D 2.0 L v2"] = {"Automobile", 10, 2, "diesel", 5000, 358},
		["SAF 1.5 L"] = {"Automobile", 12, 2.7999999523163, "petrol", 1400, 120},
		["HRL Engine"] = {"Automobile", 16, 4, "petrol", 1950, 223},
		["HLR GT 2.2 L"] = {"Automobile", 8.8000001907349, 1.7999999523163, "petrol", 1600, 101},
		["LPE 2.0 L"] = {"Automobile", 7.1999998092651, 2, "petrol", 1800, 93},
		["RR 300"] = {"Helicopter", 6.4000000953674, 0.10000000149012, "petrol", 15000, 686},
		["IAE V500"] = {"Plane", 0.68000000715256, 12, "petrol", 5000, 25},
		["HLR 1.8 L"] = {"Automobile", 8, 2.2000000476837, "petrol", 1200, 69},
		["SAF 1.3 L"] = {"Automobile", 12, 3, "petrol", 1500, 129},
		["TR 1"] = {"Train", 8, 3, "diesel", 5500, 315},
		["BE 500 CC"] = {"Boat", 0.28000000119209, 1, "petrol", 5000, 11},
		["HLR 2.2 L"] = {"Automobile", 8, 1.7999999523163, "petrol", 2200, 126},
		["RR 1200"] = {"Helicopter", 6.4000000953674, 0.050000000745058, "petrol", 10000, 458},
		["HLR 2.0 L v2"] = {"Automobile", 8, 2, "petrol", 1400, 80},
		["RR 1000"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 4500, 206},
		["HRD 750 CC"] = {"Bike", 16, 4, "petrol", 800, 92},
		["SFP D 1.3 L"] = {"Automobile", 9.6000003814697, 3, "diesel", 1300, 90},
		["TRAIN ENGINE"] = {"Automobile", 4.8000001907349, 5, "petrol", 800, 28},
		["TESLA 2"] = {"Unknown", 8, 5, "electric", 400, 23},
		["SAF D 1.3 L"] = {"Automobile", 12, 3, "diesel", 2500, 215},
		["HLR GL 1.8 L"] = {"Automobile", 8.3999996185303, 2.2000000476837, "petrol", 1850, 111},
		["TF D 1.8 L v2"] = {"Automobile", 10, 2.5, "diesel", 3500, 250},
		["SAF 1.1 L"] = {"Automobile", 12, 4, "petrol", 1200, 103},
		["BE 600 CC"] = {"Boat", 0.56000000238419, 1, "petrol", 2200, 9},
		["HRD 110 CC"] = {"Bike", 12, 5, "petrol", 350, 30},
		["SFP D 1.7 L v2"] = {"Automobile", 9.6000003814697, 2.5, "diesel", 5000, 343},
		["LPE 1.7 L"] = {"Automobile", 7.1999998092651, 2.5, "petrol", 1200, 62},
		["IAE V2900"] = {"Plane", 6.4000000953674, 4, "petrol", 40000, 1829},
		["HLR D 2.2 L"] = {"Automobile", 8, 1.7999999523163, "diesel", 4000, 229},
		["HLR GL 1.8 L v2"] = {"Automobile", 8.3999996185303, 2.2000000476837, "petrol", 1800, 108},
		["TF 1.3 L"] = {"Automobile", 10, 3, "petrol", 3000, 215},
		["MT 3"] = {"Monster Truck", 14, 2, "petrol", 10000, 1000},
		["RR 400"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 10000, 458},
		["TF D 2.0 L"] = {"Automobile", 10, 2, "diesel", 4000, 286},
		["SFP GLE 1.8 L v2"] = {"Automobile", 9.6000003814697, 2.2000000476837, "petrol", 1400, 97},
		["SAF 2.4 L"] = {"Automobile", 12, 2.2000000476837, "petrol", 1400, 120},
		["IAE V2700"] = {"Plane", 6.4000000953674, 10, "petrol", 25000, 1143},
		["RR 1100"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 20000, 915},
		["Trailer"] = {"Trailer", 7.1999998092651, 2, "diesel", 3800, 196},
		["BE 900 CC"] = {"Boat", 0.20000000298023, 1, "petrol", 5000, 8},
		["BE 200 CC"] = {"Boat", 0.68000000715256, 1, "petrol", 2200, 11},
		["LPE GT 1.8 L"] = {"Automobile", 7.5999999046326, 2.2000000476837, "petrol", 1450, 79},
		["RST GLE 1.7 L"] = {"Automobile", 6.4000000953674, 2.5999999046326, "petrol", 1900, 87},
		["RST 2.2 L"] = {"Automobile", 6, 1.7000000476837, "petrol", 1300, 56},
		["HRD 950 CC"] = {"Bike", 20, 4.5, "petrol", 500, 72},
		["HLR D 2.0 L"] = {"Automobile", 8, 2, "diesel", 5500, 315},
		["IAE V300"] = {"Plane", 6.4000000953674, 12, "petrol", 5000, 229},
		["IAE V2600"] = {"Plane", 6.4000000953674, 20, "petrol", 9000, 412},
		["SAF 2.0 L v2"] = {"Automobile", 12, 2, "petrol", 1200, 103},
		["RST D 2.4 L"] = {"Automobile", 6, 1.5, "diesel", 7000, 300},
		["TF D GLE 1.3 L"] = {"Automobile", 10.800000190735, 3, "diesel", 6500, 502},
		["LPE D 1.2 L"] = {"Automobile", 7.1999998092651, 4, "diesel", 3500, 180},
		["LPE 1.2 L"] = {"Automobile", 7.1999998092651, 5, "petrol", 300, 16},
		["SFP GLE 1.8 L"] = {"Automobile", 9.6000003814697, 2.2000000476837, "petrol", 1700, 117},
		["TF D 1.1 L"] = {"Automobile", 10, 5, "diesel", 3800, 272},
		["IAE V700"] = {"Plane", 6.4000000953674, 14, "petrol", 10000, 458},
		["SAF 2.0 L"] = {"Automobile", 12, 2, "petrol", 1400, 120},
		["TESLA 1"] = {"Unknown", 8, 5, "electric", 1000, 58},
		["SFP 1.5 L"] = {"Automobile", 9.6000003814697, 2.9000000953674, "petrol", 1750, 121},
		["HLR D 1.8 L"] = {"Automobile", 8, 2.5, "diesel", 1700, 98},
		["TF GLE 2.6 L"] = {"Automobile", 10.39999961853, 2, "petrol", 1400, 104},
		["TR 3"] = {"Train", 10, 1, "petrol", 1900, 136},
		["TRBD 2.0 L"] = {"Automobile", 5.5999999046326, 2, "diesel", 5500, 220},
		["SFP LX 2.0 L"] = {"Automobile", 9.1999998092651, 2, "petrol", 1500, 99},
		["HLR E GLE"] = {"Automobile", 8, 2, "electric", 1000, 58},
		["TF GLE 2.2 L"] = {"Automobile", 10.39999961853, 2.4000000953674, "petrol", 1000, 75},
		["TRBD 1.8 L"] = {"Automobile", 5.5999999046326, 2.2999999523163, "diesel", 3500, 140},
		["HRD 1000 CC"] = {"Bike", 20, 4, "petrol", 500, 72},
		["HLR 2.0 L"] = {"Automobile", 8, 2, "petrol", 1700, 98},
		["УЗАМ 412 1.5 L"] = {"Automobile", 8, 3, "diesel", 2000, 115},
		["BE 100 CC"] = {"Boat", 0.60000002384186, 1, "petrol", 2200, 10},
		["HLR 1.7 L v2"] = {"Automobile", 8, 2.5, "petrol", 2500, 143},
		["2JZ GTE 3.0 L"] = {"Automobile", 11.199999809265, 2.2000000476837, "petrol", 1500, 120},
		["TR 2"] = {"Train", 8, 1, "diesel", 5500, 315},
		["SFP LX 2.0 L v3"] = {"Automobile", 9.1999998092651, 2, "petrol", 1800, 119},
		["IAE V2500"] = {"Plane", 6.4000000953674, 8, "petrol", 15000, 686},
		["ODL 2.0 L v2"] = {"Automobile", 11.199999809265, 2, "petrol", 1400, 112},
		["TF 1.7 L v2"] = {"Automobile", 10, 2.5, "petrol", 1900, 136},
		["LPE 2.4 L"] = {"Automobile", 7.1999998092651, 2.4000000953674, "petrol", 2000, 103},
		["SFP GLE 1.8 L v3"] = {"Automobile", 9.6000003814697, 2.2000000476837, "petrol", 1600, 110},
		["SFP 2.0 L v2"] = {"Automobile", 9.6000003814697, 2, "petrol", 2100, 145},
		["IAE V1500"] = {"Plane", 6.4000000953674, 14, "petrol", 5000, 229},
		["HLR GT 1.7 L"] = {"Automobile", 8.8000001907349, 2.5, "petrol", 1700, 107},
		["TF GLE 2.4 L"] = {"Automobile", 10.39999961853, 2.2000000476837, "petrol", 1500, 112},
		["RC Bandit Engine"] = {"RC", 14, 6, "electric", 100, 10},
		["ODL 1.6 L v2"] = {"Automobile", 11.199999809265, 2.5, "petrol", 1600, 128},
		["TRBD 1.3 L"] = {"Automobile", 5.5999999046326, 3, "diesel", 3500, 140},
		["HLR GT 1.7 L v2"] = {"Automobile", 8.8000001907349, 2.5, "petrol", 1600, 101},
		["BE 800 CC"] = {"Boat", 0.47999998927116, 1, "petrol", 800, 3},
		["LPE GT 1.6 L"] = {"Automobile", 7.5999999046326, 2.7999999523163, "petrol", 1000, 55},
		["RST 1.2 L"] = {"Automobile", 6, 5, "petrol", 800, 35},
		["TF GLE 4.0 L"] = {"Automobile", 10.39999961853, 1.3999999761581, "petrol", 1600, 119},
		["BMX 2"] = {"BMX", 7.1999998092651, 6, "petrol", 100, 6},
		["TRBD 1.7 L"] = {"Automobile", 5.5999999046326, 2.5, "diesel", 1850, 74},
		["TRBD 1.2 L"] = {"Automobile", 5.5999999046326, 3.5, "diesel", 1700, 68},
		["RST E"] = {"Automobile", 6, 4, "electric", 1000, 43},
		["Dozer Engine"] = {"Automobile", 14, 20, "diesel", 10000, 1000},
		["RST GLE 2.0 L v2"] = {"Automobile", 6.4000000953674, 2, "petrol", 1900, 87},
		["RST GLE 2.0 L v3"] = {"Automobile", 6.4000000953674, 2, "petrol", 2500, 115},
		["BE 400 CC"] = {"Boat", 1, 1, "petrol", 2200, 16},
		["BMX 3"] = {"BMX", 7.1999998092651, 7, "petrol", 100, 6},
		["RC CAM ENGINE"] = {"RC", 20, 20, "electric", 100, 15},
		["Bandito Engine"] = {"Automobile", 14, 4, "petrol", 1000, 100},
		["TRBD LX 2.0 L"] = {"Automobile", 5.1999998092651, 2, "diesel", 8000, 298},
		["TF 2.0 L"] = {"Automobile", 10, 2, "petrol", 1600, 115},
		["ODL 2.0 L"] = {"Automobile", 11.199999809265, 2, "petrol", 1500, 120},
		["SAF 2.2 L"] = {"Automobile", 12, 1.7999999523163, "petrol", 1200, 103},
		["LPE 1.8 L"] = {"Automobile", 7.1999998092651, 2.2000000476837, "petrol", 1600, 83},
		["TF D 1.8 L"] = {"Automobile", 10, 2.5, "diesel", 1700, 122},
		["HLR GLE 1.8 L"] = {"Automobile", 8, 2.0999999046326, "petrol", 1800, 103},
		["BE 300 CC"] = {"Boat", 1.2000000476837, 1, "petrol", 2200, 19},
		["BE 700 CC"] = {"Boat", 0.63999998569489, 1, "petrol", 1200, 6},
		["LPE 2.0 L v3"] = {"Automobile", 7.1999998092651, 2, "petrol", 1950, 101},
		["RST D 2.0 L"] = {"Automobile", 6, 2, "diesel", 1900, 82},
		["IAE V1400"] = {"Plane", 6.4000000953674, 15, "petrol", 5000, 229},
		["LPE D 2.2 L"] = {"Automobile", 7.1999998092651, 1.7999999523163, "diesel", 9500, 489},
		["BE 1000 CC"] = {"Boat", 1.2000000476837, 1, "petrol", 3000, 26},
		["HLR GT 1.8 L"] = {"Automobile", 8.8000001907349, 2.2000000476837, "petrol", 1800, 114},
		["RST GLE 2.0 L"] = {"Automobile", 6.4000000953674, 2, "petrol", 1500, 69},
		["HLR GT 1.8 L v2"] = {"Automobile", 8.8000001907349, 2.2000000476837, "petrol", 1400, 89},
		["TF D 2.0 L v3"] = {"Automobile", 10, 2, "diesel", 3800, 272},
		["HRD 1200 CC"] = {"Bike", 24, 4, "petrol", 400, 69},
		["TF D 1.7 L"] = {"Automobile", 10, 2.7000000476837, "diesel", 1600, 115},
		["RR 600"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 2500, 115},
		["SFP 1.7 L"] = {"Automobile", 9.6000003814697, 2.5, "petrol", 1700, 117},
		["IAE V3000"] = {"Plane", 6.4000000953674, 4, "petrol", 60000, 2743},
		["SFP 2.0 L v3"] = {"Automobile", 9.6000003814697, 2, "petrol", 1700, 117},
		["HRD 500 CC"] = {"Quad", 10, 5, "petrol", 400, 29},
		["MT 2"] = {"Monster Truck", 10, 4, "diesel", 20000, 1429},
		["RR 100"] = {"RC", 14, 0.20000000298023, "petrol", 100, 10},
		["2JZ GTE 3.2 L"] = {"Automobile", 11.199999809265, 2.2000000476837, "petrol", 2000, 160},
		["IAE V1000"] = {"Plane", 6.4000000953674, 10, "petrol", 5000, 229},
		["BSHEE 3.0 L"] = {"Automobile", 13.199999809265, 2, "petrol", 1400, 132},
		["MT 1"] = {"Monster Truck", 18, 3, "petrol", 5000, 643},
		["TRBD 1.3 L v2"] = {"Automobile", 5.5999999046326, 3, "diesel", 5500, 220},
		["SFP 1.7 L v2"] = {"Automobile", 9.6000003814697, 2.5, "petrol", 2200, 151},
		["HRD 900 CC"] = {"Bike", 20, 5, "petrol", 500, 72},
		["RR 800"] = {"Helicopter", 6.4000000953674, 0.20000000298023, "petrol", 3500, 161},
		["Chevy V8 Military Edition"] = {"Automobile", 16, 5, "diesel", 25000, 2858},
		["RST GT 2.0 L"] = {"Automobile", 6.8000001907349, 2, "petrol", 1600, 78},
		["RST D 1.6 L"] = {"Automobile", 6, 2.7999999523163, "diesel", 2000, 86},
		["LPE 2.0 L v4"] = {"Automobile", 7.1999998092651, 2, "petrol", 1700, 88},
		["HLR D 1.1 L"] = {"Automobile", 8, 4, "diesel", 10500, 600},
		["SFP LX 2.0 L v2"] = {"Automobile", 9.1999998092651, 2, "petrol", 1600, 106},
		["RST D 1.3 L"] = {"Automobile", 6, 3, "diesel", 2600, 112},
		["IAE V100"] = {"Plane", 0.80000001192093, 20, "petrol", 1900, 11},
		["TF 1.7 L"] = {"Automobile", 10, 2.5, "petrol", 2500, 179},
		["IAE V2800"] = {"RC", 0.40000000596046, 120, "petrol", 100, 1},
		["LPE D 1.3 L"] = {"Automobile", 7.1999998092651, 3, "diesel", 2600, 134},
		["ODL 1.6 L"] = {"Automobile", 11.199999809265, 2.5, "petrol", 1400, 112},
		["HLR D 1.0 L"] = {"Automobile", 8, 5, "diesel", 5500, 315},
		["SFP 1.8 L"] = {"Automobile", 9.6000003814697, 2.2999999523163, "petrol", 1800, 124},
		["HLR GT 2.0 L"] = {"Automobile", 8.8000001907349, 2, "petrol", 1650, 104},
		["LPE 2.0 L v2"] = {"Automobile", 7.1999998092651, 2, "petrol", 1400, 72},
		["HLR 2.0 L v3"] = {"Automobile", 8, 2, "petrol", 2000, 115},
	}
}

--local WriteDat = {}
--for name, dat in pairs(VComp) do
--	if(name == "Brakes") then
--		WriteDat[name] = {}
--		for i,v in pairs(dat) do
--			if(not WriteDat[name][v[1]]) then WriteDat[name][v[1]] = {[1] = {-100000, 100000}} end
--			if(v[2] > WriteDat[name][v[1]][1][1]) then
--				WriteDat[name][v[1]][1][1] = v[2]
--			end
--			if(v[2] < WriteDat[name][v[1]][1][2]) then
--				WriteDat[name][v[1]][1][2] = v[2]
--			end
--		end
--	elseif(name == "Tires") then
--		WriteDat[name] = {}
--		for i,v in pairs(dat) do
--			if(not WriteDat[name][v[1]]) then
--				WriteDat[name][v[1]] = {
--					[1] = {-100000, 100000},
--					[2] = {-100000, 100000},
--					[3] = {-100000, 100000}
--				}
--			end
--			if(v[2] > WriteDat[name][v[1]][1][1]) then
--				WriteDat[name][v[1]][1][1] = v[2]
--			end
--			if(v[2] < WriteDat[name][v[1]][1][2]) then
--				WriteDat[name][v[1]][1][2] = v[2]
--			end
--
--
--			if(v[3] > WriteDat[name][v[1]][2][1]) then
--				WriteDat[name][v[1]][2][1] = v[3]
--			end
--			if(v[3] < WriteDat[name][v[1]][2][2]) then
--				WriteDat[name][v[1]][2][2] = v[3]
--			end
--
--			if(v[4] > WriteDat[name][v[1]][3][1]) then
--				WriteDat[name][v[1]][3][1] = v[4]
--			end
--			if(v[4] < WriteDat[name][v[1]][3][2]) then
--				WriteDat[name][v[1]][3][2] = v[4]
--			end
--		end
--	elseif(name == "Engines" or name == "Turbo") then
--		WriteDat[name] = {}
--		for i,v in pairs(dat) do
--			if(not WriteDat[name][v[1]]) then
--				WriteDat[name][v[1]] = {
--					[1] = {-100000, 100000},
--					[2] = {-100000, 100000},
--				}
--			end
--			if(v[2] > WriteDat[name][v[1]][1][1]) then
--				WriteDat[name][v[1]][1][1] = v[2]
--			end
--			if(v[2] < WriteDat[name][v[1]][1][2]) then
--				WriteDat[name][v[1]][1][2] = v[2]
--			end
--
--
--			if(v[3] > WriteDat[name][v[1]][2][1]) then
--				WriteDat[name][v[1]][2][1] = v[3]
--			end
--			if(v[3] < WriteDat[name][v[1]][2][2]) then
--				WriteDat[name][v[1]][2][2] = v[3]
--			end
--		end
--	end
--end
--
--
--
--datess = ""
--for name, dat in pairs(WriteDat) do
--	datess = datess..'\n	["'..name..'"] = {'
--	for name2, dat2 in pairs(dat) do
--		datess = datess..'\n		["'..name2..'"] = {'
--		local count = 0
--		for i, dat3 in pairs(dat2) do
--			if(count >= 1) then
--				datess = datess..", "
--			end
--			datess = datess.."["..i.."] = {"..dat3[2]..", "..dat3[1].."}"
--			count = count+1
--		end
--		datess = datess..'}, '
--	end
--	datess = datess..'\n	}, '
--end
--fileDelete("save.txt")
--local hFile = fileCreate("save.txt")
--fileWrite(hFile, datess) -- write a text line
--fileClose(hFile)





















-- Высота от земли, Двигатель, турбо, трансмиссия, подвеска, тормоза, резина, бензобак, год выпуска, прекращение выпуска (CYear - наши дни), завод (Export - Неизвестные)
local VehicleSystem = {
	[500] = {1.1, "SFP D 1.3 L", "", "A5 160", "Macpherson V1", "Brembo 230mm", "Brigestone", 43, {11, 1987}, {10, 1995}, "Canis"},
	[520] = {1.93, "IAE V2600", "", "A1 200", "Macpherson V2", "Brembo 2", "Hankook", 300, {11, 2006}, {0, CYear}, "Mammoth"},
	[552] = {0.69, "LPE D 1.3 L", "", "R5 160", "Macpherson V3", "Endless 193mm", "ANNAITE", 86, {7, 1998}, {6, CYear}, "Vapid"},
	[584] = {2, "Trailer", "", "R5 120", "Macpherson TR", "Brembo 4", "ANNAITE TR", 126, {1, 1930}, {5, CYear}, "Export"},
	[521] = {0.67, "HRD 1000 CC", "", "R5 190", "Macpherson V5", "Brembo 5", "Michelin 5", 16, {7, 1985}, {5, CYear}, "Export"},
	[553] = {2.3, "IAE V2700", "", "A1 200", "Macpherson V91", "Brembo 33", "Hankook", 833, {2, 1936}, {1, 1942}, "Export"},
	[585] = {0.59, "HLR GL 1.8 L v2", "", "R5 165", "Macpherson V7", "Wilwood 230mm", "КАМА-505", 60, {0, 1990}, {2, 1993}, "Albany"},
	[437] = {1.14, "LPE D 2.2 L", "", "R5 160", "Macpherson V8", "Wilwood 187mm", "Michelin 8", 316, {5, 1986}, {1, 1994}, "Export"},
	[453] = {0.93, "BE 500 CC", "", "R5 190", "Macpherson V9", "Brembo 9", "Michelin 9", 166, {8, 1975}, {5, CYear}, "Export"},
	[469] = {1.03, "RR 600", "", "A1 200", "Macpherson V10", "Brembo 10", "Hankook", 83, {7, 1946}, {9, 1974}, "Export"},
	[485] = {0.66, "HLR E GLE", "", "R3 160", "Macpherson V11", "Brembo 170mm", "Michelin 10", 33, {3, 1930}, {11, CYear}, "Export"},
	[501] = {0.43, "RR 100", "", "A1 75", "Macpherson V12", "Brembo 12", "Michelin 11", 3, {2, 1992}, {8, CYear}, "RC"},
	[522] = {0.67, "HRD 1200 CC", "", "R5 190", "Macpherson V5", "Brembo 5", "Michelin 12", 13, {2, 1984}, {7, 2002}, "Export"},
	[554] = {1.08, "TF 1.3 L", "", "R5 170", "Macpherson V13", "Wilwood 245mm", "Michelin 13", 100, {6, 1988}, {2, 1999}, "Export"},
	[586] = {0.72, "HRD 750 CC", "", "R4 190", "Macpherson V14", "Brembo 14", "Michelin 14", 26, {3, 1941}, {3, CYear}, "Western Motorcycle Company"},
	[523] = {0.57, "HRD 950 CC", "", "R5 190", "Macpherson V5", "Brembo 5", "Michelin 15", 16, {4, 1966}, {10, CYear}, "Export"},
	[406] = {2.52, "MT 2", "", "R4 110", "Macpherson V15", "Brembo 15", "Michelin 16", 666, {1, 1974}, {8, CYear}, "DUDE"},
	[422] = {0.99, "HLR D 1.8 L", "", "A5 165", "Macpherson V153", "Brembo 245mm", "Michelin 117", 56, {1, 1983}, {1, 1988}, "Vapid"},
	[438] = {1, "SFP 1.5 L", "", "R4 160", "Macpherson V17", "Wilwood 210mm", "Michelin 17", 58, {4, 1947}, {0, 1982}, "Export"},
	[454] = {1.24, "BE 600 CC", "", "R5 190", "Macpherson V18", "Brembo 18", "Michelin 18", 73, {9, 1982}, {4, CYear}, "Grotti"},
	[470] = {0.99, "TF 1.7 L", "", "A5 170", "Macpherson V19", "Brembo 230mm", "Michelin 19", 83, {10, 1985}, {3, 2006}, "Mammoth"},
	[486] = {1.22, "Dozer Engine", "", "A5 100", "Macpherson V20", "Wilwood 170mm", "Michelin 20", 333, {4, 1950}, {3, CYear}, "DUDE"},
	[502] = {0.9, "TF GLE 4.0 L", "", "R5 220", "Macpherson V21", "Endless 260mm", "Yokohama", 53, {9, 1981}, {0, 1992}, "Export"},
	[524] = {1.94, "HLR D 2.0 L", "", "R4 110", "Macpherson V22", "Brembo 15", "Michelin 22", 183, {11, 1978}, {9, 1986}, "DUDE"},
	[556] = {1.38, "MT 1", "", "A5 110", "Macpherson V23", "Wilwood 212mm", "Michelin 23", 166, {0, 1994}, {9, 2004}, "Cheval"},
	[588] = {0.91, "TRBD 1.3 L v2", "", "R5 140", "Macpherson V24", "Endless 165mm", "Michelin 24", 183, {6, 1964}, {1, 1970}, "Export"},
	[525] = {0.88, "TF D 1.8 L v2", "", "R5 160", "Macpherson V25", "Endless 193mm", "ANNAITE", 116, {10, 1960}, {3, 1998}, "Vapid"},
	[557] = {1.38, "MT 1", "", "A5 110", "Macpherson V23", "Wilwood 212mm", "Michelin 23", 166, {5, 1994}, {0, 2004}, "Cheval"},
	[423] = {1, "TRBD 1.2 L", "", "R5 145", "Macpherson V152", "Endless 155mm", "Michelin 116", 56, {9, 1978}, {7, 1993}, "Brute"},
	[439] = {0.9, "SFP LX 2.0 L v2", "", "R4 160", "Macpherson V28", "Endless 236mm", "Michelin 27", 53, {6, 1964}, {5, 1973}, "Vapid"},
	[455] = {1.45, "TF D 1.8 L", "", "R5 140", "Macpherson V29", "Wilwood 262mm", "Michelin 28", 283, {8, 1967}, {9, CYear}, "MTL"},
	[471] = {0.48, "HRD 500 CC", "", "A4 160", "Macpherson V30", "Brembo 230mm", "Michelin 29", 13, {11, 1986}, {3, CYear}, "Export"},
	[487] = {1.17, "RR 700", "", "A1 200", "Macpherson V31", "Brembo 10", "Hankook", 166, {1, 1962}, {2, CYear}, "Buckingham"},
	[503] = {0.9, "TF GLE 4.0 L", "", "R5 220", "Macpherson V21", "Endless 260mm", "Yokohama", 53, {1, 1980}, {5, 1982}, "Export"},
	[526] = {0.77, "HLR 2.0 L", "", "R4 160", "Macpherson V32", "Endless 236mm", "Michelin 30", 56, {11, 1989}, {7, 1993}, "Vapid"},
	[558] = {0.63, "HLR 2.0 L v2", "", "R5 200", "Macpherson V33", "Wilwood 230mm", "Michelin 31", 46, {0, 1989}, {11, 2011}, "Vapid"},
	[590] = {0, "TR 2", "", "R4 110", "Macpherson V34", "Brembo 15", "Michelin 22", 183, {6, 1930}, {4, CYear}, "Export"},
	[527] = {0.72, "HLR 1.8 L", "", "R4 160", "Macpherson V35", "Endless 231mm", "Michelin 32", 40, {6, 1991}, {6, 1994}, "Export"},
	[408] = {1.54, "HLR D 1.0 L", "", "R4 110", "Macpherson V36", "Wilwood 120mm", "Michelin 33", 183, {3, 1984}, {0, CYear}, "Jobuilt"},
	[424] = {0.77, "SAF 1.1 L", "", "R4 170", "Macpherson V37", "Brembo 190mm", "Michelin 34", 40, {2, 1930}, {4, CYear}, "Export"},
	[440] = {1.14, "LPE 2.4 L", "", "F5 160", "Macpherson V38", "Endless 185mm", "Michelin 35", 66, {2, 1971}, {11, 2003}, "Bravado"},
	[456] = {1.17, "TRBD 1.3 L", "", "R5 160", "Macpherson V39", "Endless 160mm", "Michelin 36", 150, {7, 1982}, {6, CYear}, "Vapid"},
	[472] = {0.77, "BE 700 CC", "", "R5 190", "Macpherson V40", "Brembo 18", "Michelin 37", 40, {7, 1978}, {4, CYear}, "Export"},
	[488] = {1.21, "RR 800", "", "A1 200", "Macpherson V10", "Brembo 10", "Hankook", 116, {4, 1962}, {4, CYear}, "Buckingham"},
	[504] = {0.78, "SFP 2.0 L v2", "", "R5 160", "Macpherson V41", "Endless 205mm", "Michelin 38", 70, {4, 1959}, {3, 1973}, "Benefactor"},
	[528] = {1.05, "TF D 2.0 L", "", "A5 170", "Macpherson V42", "Wilwood 190mm", "Michelin 39", 133, {0, 1981}, {8, CYear}, "Export"},
	[560] = {0.7, "ODL 1.7 L", "", "A5 200", "Macpherson V43", "Brembo 260mm", "Michelin 40", 46, {10, 1992}, {7, 2000}, "Karin"},
	[592] = {2.2, "IAE V2900", "", "A1 200", "Macpherson V31", "Brembo 33", "Hankook", 1333, {9, 1965}, {6, 2006}, "Export"},
	[529] = {0.63, "LPE 2.0 L", "", "R4 160", "Macpherson V44", "Endless 180mm", "Michelin 41", 60, {3, 1988}, {9, 1993}, "Willard"},
	[561] = {0.81, "HLR GLE 1.8 L", "", "R5 200", "Macpherson V166", "Brembo 210mm", "Michelin 106", 60, {8, 1994}, {5, 1997}, "Zirconium"},
	[425] = {1.53, "RR 400", "", "A1 200", "Macpherson V104", "Brembo 10", "Hankook", 333, {4, 1984}, {9, 1997}, "Export"},
	[441] = {0.11, "RC Bandit Engine", "", "A1 75", "Macpherson V12", "Brembo 12", "Michelin 43", 3, {10, 1992}, {5, CYear}, "RC"},
	[457] = {0.63, "RST E", "", "A3 160", "Macpherson V47", "Brembo 300mm", "Michelin 44", 33, {2, 1965}, {0, CYear}, "ProLaps"},
	[473] = {0.26, "BE 800 CC", "", "R5 190", "Macpherson V48", "Brembo 37", "Michelin 45", 26, {9, 1969}, {9, CYear}, "Nagasaki"},
	[489] = {1.14, "HLR 1.7 L v2", "", "A5 170", "Offroad Suspension Kit", "Wilwood 212mm", "Michelin 46", 83, {1, 1970}, {7, 1996}, "Export"},
	[505] = {1.14, "HLR 1.7 L v2", "", "A5 170", "Offroad Suspension Kit", "Wilwood 212mm", "Michelin 46", 83, {5, 1970}, {2, 1996}, "Export"},
	[530] = {0.76, "HLR E GLE", "", "F3 60", "Macpherson V50", "Brembo 190mm", "Michelin 47", 33, {6, 1965}, {5, CYear}, "DUDE"},
	[562] = {0.66, "2JZ GTE 3.0 L", "", "R5 200", "Macpherson V51", "Brembo 230mm", "Hankook", 50, {5, 1988}, {6, 1994}, "Export"},
	[594] = {0.17, "RC CAM ENGINE", "", "A1 60", "Macpherson V52", "Brembo 12", "Michelin 48", 3, {9, 1992}, {6, CYear}, "RC"},
	[531] = {0.96, "УЗАМ 412 1.5 L", "", "R4 70", "Macpherson V53", "Wilwood 340mm", "Michelin 49", 66, {6, 1930}, {6, 1970}, "Export"},
	[563] = {1.68, "RR 1200", "", "A1 200", "Macpherson V93", "Brembo 10", "Hankook", 333, {11, 1970}, {6, CYear}, "Export"},
	[426] = {0.74, "HLR GT 2.2 L", "", "R5 200", "Macpherson V55", "Endless 265mm", "Michelin 50", 53, {1, 1992}, {5, 1994}, "Declasse"},
	[442] = {0.83, "RST GLE 2.0 L v3", "", "R5 150", "Macpherson V56", "Endless 153mm", "Michelin 51", 83, {0, 1977}, {10, 1984}, "Albany"},
	[458] = {0.88, "HLR 2.0 L v3", "", "R4 165", "Macpherson V57", "Endless 175mm", "Michelin 52", 66, {4, 2000}, {10, 2003}, "Willard"},
	[474] = {0.76, "LPE 2.0 L v3", "", "F5 160", "Macpherson V58", "Endless 120mm", "Michelin 53", 65, {9, 1950}, {3, 1957}, "Export"},
	[490] = {1.13, "HLR GT 1.8 L", "", "A5 170", "Macpherson V59", "Brembo 245mm", "Michelin 54", 116, {1, 1970}, {0, 1996}, "Export"},
	[506] = {0.71, "TF GLE 2.6 L", "", "R5 230", "Macpherson V60", "Endless 235mm", "Michelin 55", 46, {3, 1990}, {3, 2001}, "Dewbauchee"},
	[532] = {1.96, "TF D 1.1 L", "", "A5 140", "Macpherson V61", "Wilwood 262mm", "Michelin 56", 283, {11, 1930}, {0, CYear}, "Export"},
	[564] = {0.17, "RC Tiger Engine", "", "A1 75", "Macpherson V62", "Brembo 170mm", "Michelin 29", 3, {5, 1992}, {11, CYear}, "RC"},
	[596] = {0.72, "TF 2.0 L", "", "R5 200", "Macpherson V63", "Endless 265mm", "Michelin 34", 53, {4, 1964}, {4, 1994}, "Declasse"},
	[533] = {0.71, "ODL 1.6 L v2", "", "R5 200", "Macpherson V64", "Endless 210mm", "Hankook", 53, {3, 1971}, {8, 1989}, "Benefactor"},
	[565] = {0.63, "SFP GLE 1.8 L v2", "", "F5 200", "Macpherson V168", "Endless 232mm", "Michelin 127", 46, {7, 1990}, {9, 1995}, "Export"},
	[597] = {0.77, "TF 2.0 L", "", "R5 200", "Macpherson V66", "Endless 265mm", "Michelin 50", 53, {2, 1964}, {0, 1994}, "Declasse"},
	[443] = {1.67, "TRBD LX 2.0 L", "", "R5 150", "Macpherson V8", "Wilwood 187mm", "Michelin 8", 266, {8, 1987}, {4, 2007}, "MTL"},
	[459] = {1.05, "RST D 2.0 L", "", "R5 160", "Macpherson V67", "Endless 193mm", "ANNAITE", 63, {4, 1979}, {6, 1992}, "Export"},
	[475] = {0.8, "SFP 2.0 L v3", "", "R4 160", "Macpherson V68", "Endless 235mm", "Michelin 57", 56, {7, 1968}, {2, 1972}, "Declasse"},
	[491] = {0.76, "LPE 2.0 L v4", "", "R4 160", "Macpherson V69", "Brembo 210mm", "Michelin 32", 56, {7, 1977}, {9, 1979}, "Albany"},
	[507] = {0.82, "HLR 2.2 L", "", "R5 165", "Macpherson V70", "Endless 190mm", "Michelin 58", 73, {1, 1991}, {0, 1996}, "Willard"},
	[534] = {0.72, "SFP LX 2.0 L v3", "", "R5 160", "Macpherson V71", "Brembo 205mm", "Michelin 59", 60, {0, 1977}, {6, 1978}, "Export"},
	[566] = {0.78, "SFP 1.8 L", "", "R5 160", "Macpherson V72", "Brembo 210mm", "Michelin 50", 60, {0, 1981}, {9, 1986}, "Export"},
	[598] = {0.74, "TF 2.0 L", "", "R5 200", "Macpherson V73", "Endless 265mm", "Michelin 50", 53, {8, 1981}, {6, 1990}, "Export"},
	[535] = {0.76, "HRL Engine", "", "R5 160", "Macpherson V74", "Brembo 260mm", "Hankook", 65, {7, 1988}, {6, 1998}, "Vapid"},
	[412] = {0.83, "SFP LX 2.0 L v3", "", "R5 160", "Macpherson V127", "Brembo 205mm", "Michelin 98", 60, {8, 1959}, {3, 1960}, "Declasse"},
	[428] = {1.12, "RST D 2.4 L", "", "R5 170", "Macpherson V169", "Wilwood 240mm", "Michelin 128", 233, {8, 1980}, {1, 2009}, "Brute"},
	[444] = {1.37, "MT 1", "", "A5 110", "Macpherson V23", "Wilwood 212mm", "Michelin 23", 166, {8, 1994}, {0, 2004}, "Cheval"},
	[460] = {2.2, "IAE V500", "", "A1 200", "Macpherson V77", "Brembo 52", "Michelin 61", 166, {10, 1930}, {3, CYear}, "Export"},
	[476] = {1.74, "IAE V1000", "", "A1 200", "Macpherson V31", "Brembo 2", "Hankook", 166, {3, 1942}, {4, 1986}, "Export"},
	[492] = {0.78, "HLR 1.7 L", "", "R4 160", "Macpherson V78", "Endless 180mm", "Michelin 41", 53, {4, 1983}, {5, 1993}, "Export"},
	[508] = {1.37, "TRBD 1.3 L", "", "R5 140", "Macpherson V79", "Endless 165mm", "Michelin 62", 116, {1, 1973}, {0, CYear}, "Zirconium"},
	[536] = {0.74, "SFP 2.0 L", "", "R4 160", "Macpherson V80", "Endless 236mm", "Michelin 63", 50, {3, 1965}, {9, 1968}, "Vapid"},
	[568] = {0.82, "Bandito Engine", "", "R4 170", "Macpherson V81", "Endless 195mm", "Michelin 64", 33, {4, 1930}, {3, CYear}, "Export"},
	[600] = {0.72, "TF D 1.7 L", "", "R5 165", "Macpherson V82", "Brembo 245mm", "Michelin 65", 53, {8, 1970}, {2, 1972}, "Cheval"},
	[401] = {0.79, "RST 2.2 L", "", "F5 160", "Macpherson V129", "Endless 233mm", "КАМА-505", 43, {2, 1989}, {6, 1995}, "Export"},
	[537] = {0, "TR 1", "", "R4 110", "Macpherson V34", "Brembo 15", "Michelin 22", 183, {7, 1975}, {0, 1992}, "Export"},
	[413] = {1.09, "RST D 1.3 L", "", "R5 160", "Macpherson V83", "Endless 193mm", "Matador 66", 86, {11, 1986}, {6, 1993}, "Brute"},
	[601] = {0.76, "SFP D 1.7 L v2", "", "A5 110", "Macpherson V84", "Wilwood 200mm", "Michelin 67", 166, {7, 1982}, {6, 1999}, "Export"},
	[445] = {0.83, "HLR GT 2.0 L", "", "F5 165", "Macpherson V85", "Endless 245mm", "Michelin 68", 55, {1, 1982}, {0, 1993}, "Dundreary"},
	[461] = {0.68, "HRD 1000 CC", "", "R5 190", "Macpherson V5", "Brembo 5", "Michelin 69", 16, {7, 1992}, {0, CYear}, "Shitzu"},
	[477] = {0.76, "ODL 2.0 L v2", "", "R5 200", "Macpherson V86", "Endless 275mm", "Michelin 70", 46, {10, 1989}, {11, 1995}, "Export"},
	[493] = {1.29, "BE 1000 CC", "", "R5 190", "Macpherson V87", "Brembo 57", "Michelin 71", 100, {0, 1990}, {11, CYear}, "Grotti"},
	[509] = {0.51, "BMX 2", "", "R5 120", "Macpherson V88", "Ferodo GT", "Michelin 69", 3, {3, 1970}, {7, CYear}, "Export"},
	[538] = {0, "TR 1", "", "R4 110", "Macpherson V89", "Brembo 15", "Michelin 22", 183, {9, 1975}, {10, 1992}, "Export"},
	[570] = {0, "TR 2", "", "R4 110", "Macpherson V89", "Brembo 15", "Michelin 22", 183, {11, 1988}, {2, 1998}, "Export"},
	[602] = {0.8, "SFP LX 2.0 L", "", "R5 200", "Macpherson V90", "Endless 215mm", "Brigestone", 50, {11, 1990}, {8, 2000}, "Albany"},
	[417] = {1.08, "RR 300", "", "A1 200", "Macpherson V130", "Brembo 10", "Hankook", 500, {4, 1959}, {9, 1979}, "Export"},
	[609] = {1, "TRBD 1.3 L", "", "R5 140", "Macpherson V147", "Endless 165mm", "Michelin 113", 183, {1, 1978}, {10, 1993}, "Brute"},
	[414] = {1.09, "LPE D 1.2 L", "", "R5 140", "Macpherson V96", "Endless 165mm", "Matador 74", 116, {4, 1989}, {0, CYear}, "Maibatsu Corporation"},
	[420] = {0.78, "LPE GT 1.8 L", "", "F5 180", "Macpherson V94", "Endless 255mm", "Michelin 72", 48, {7, 1992}, {3, 1994}, "Declasse"},
	[551] = {0.8, "HLR GT 1.8 L", "", "R5 165", "Macpherson V103", "Endless 250mm", "Michelin 80", 60, {6, 1991}, {8, 1996}, "Declasse"},
	[539] = {0.36, "IAE V100", "", "R5 150", "Macpherson V95", "Brembo 61", "Michelin 73", 63, {3, 1975}, {8, CYear}, "Export"},
	[571] = {0.28, "LPE 1.2 L", "", "R4 90", "Macpherson V165", "Wilwood 340mm", "Michelin 125", 10, {4, 1970}, {2, CYear}, "Export"},
	[430] = {0.8, "BE 200 CC", "", "R5 190", "Macpherson V9", "Brembo 18", "Michelin 75", 73, {10, 1980}, {8, CYear}, "Export"},
	[446] = {1.01, "BE 300 CC", "", "R5 190", "Macpherson V97", "Brembo 57", "Michelin 76", 73, {9, 1989}, {1, CYear}, "Shitzu"},
	[462] = {0.7, "HRD 110 CC", "", "R3 190", "Macpherson V98", "Brembo 62", "Michelin 12", 11, {8, 1973}, {10, CYear}, "Pegassi"},
	[478] = {1, "TRBD 1.7 L", "", "A4 150", "Macpherson V99", "Brembo 205mm", "Michelin 77", 61, {8, 1955}, {1, 1960}, "Export"},
	[494] = {0.9, "TF GLE 4.0 L", "", "R5 220", "Macpherson V21", "Endless 260mm", "Yokohama", 53, {7, 1978}, {9, 1988}, "Export"},
	[510] = {0.61, "BMX 1", "", "R4 140", "Macpherson V88", "Ferodo GT", "Michelin 69", 3, {5, 1992}, {0, CYear}, "Export"},
	[540] = {0.81, "LPE 2.0 L", "", "F4 160", "Macpherson V100", "Endless 180mm", "Brigestone", 60, {10, 1987}, {2, 1996}, "Maibatsu"},
	[572] = {0.58, "TRAIN ENGINE", "", "R3 60", "Macpherson V101", "Endless 195mm", "Michelin 78", 26, {7, 1992}, {7, CYear}, "Jacksheepe"},
	[604] = {0.74, "HLR GT 1.7 L v2", "", "R5 160", "Macpherson V102", "Endless 205mm", "Michelin 79", 53, {4, 1959}, {10, 1973}, "Benefactor"},
	[603] = {0.84, "TF GLE 2.4 L", "", "R5 200", "Macpherson V118", "Endless 190mm", "Michelin 91", 50, {8, 1982}, {10, 1992}, "Imponte"},
	[595] = {0.54, "BE 100 CC", "", "R5 190", "Macpherson V105", "Brembo 64", "Michelin 81", 73, {4, 1973}, {5, 1998}, "Export"},
	[421] = {0.88, "HLR GL 1.8 L", "", "R5 180", "Macpherson V106", "Endless 220mm", "Michelin 82", 61, {6, 1982}, {2, 1987}, "Albany"},
	[559] = {0.66, "2JZ GTE 3.0 L", "", "F5 200", "Macpherson V107", "Wilwood 262mm", "Michelin 83", 50, {9, 1983}, {4, 1989}, "Dinka"},
	[429] = {0.68, "BSHEE 3.0 L", "", "R5 200", "Macpherson V116", "Endless 235mm", "Michelin 89", 46, {3, 1992}, {3, 1995}, "Bravado"},
	[541] = {0.62, "SAF 2.2 L", "", "R5 230", "Macpherson V108", "Endless 230mm", "Michelin 84", 40, {11, 1964}, {9, 1969}, "Vapid"},
	[415] = {0.77, "SAF 2.0 L v2", "", "R5 230", "Macpherson V167", "Wilwood 275mm", "Michelin 126", 40, {4, 1984}, {0, 1996}, "Grotti"},
	[431] = {1.1, "TRBD 2.0 L", "", "R4 130", "Macpherson V154", "Wilwood 155mm", "Michelin 118", 183, {1, 1970}, {8, CYear}, "Brute"},
	[447] = {1.03, "RR 500", "", "A1 200", "Macpherson V10", "Brembo 10", "Hankook", 100, {7, 1946}, {8, 1974}, "Export"},
	[463] = {0.67, "HRD 750 CC", "", "R4 190", "Macpherson V14", "Brembo 14", "Michelin 87", 26, {8, 1968}, {1, CYear}, "Western Motorcycle Company"},
	[479] = {0.8, "RST GLE 2.0 L", "", "F4 165", "Macpherson V111", "Endless 175mm", "Michelin 88", 50, {5, 1984}, {4, 1988}, "Dundreary"},
	[495] = {1.35, "2JZ GTE 3.2 L", "", "A5 170", "Macpherson V112", "Brembo 230mm", "Michelin 34", 66, {8, 2007}, {0, CYear}, "Export"},
	[511] = {2.5, "IAE V700", "", "A1 200", "Macpherson V113", "Brembo 2", "Hankook", 333, {4, 1965}, {2, CYear}, "Export"},
	[542] = {0.74, "SFP GLE 1.8 L v3", "", "R4 160", "Macpherson V114", "Brembo 230mm", "КАМА-505", 53, {0, 1971}, {10, 1976}, "Export"},
	[574] = {0.73, "TRAIN ENGINE", "", "R3 60", "Macpherson V115", "Endless 195mm", "Michelin 58", 26, {10, 1983}, {10, CYear}, "Export"},
	[606] = {1.4, "TESLA 1", "", "R3 160", "Macpherson V11", "Brembo 170mm", "Michelin 10", 33, {0, 1930}, {6, CYear}, "Export"},
	[427] = {1.13, "HLR D 2.2 L", "", "R5 170", "Macpherson V117", "Wilwood 180mm", "Michelin 90", 133, {10, 1983}, {4, 1990}, "Brute"},
	[569] = {0, "TR 2", "", "R4 110", "Macpherson V34", "Brembo 15", "Michelin 22", 183, {5, 1975}, {8, CYear}, "Export"},
	[567] = {0.87, "SFP 2.0 L", "", "R4 160", "Macpherson V75", "Endless 236mm", "Michelin 60", 50, {1, 1961}, {8, 1964}, "Export"},
	[599] = {1.18, "SAF D 1.3 L", "", "A5 160", "Macpherson V76", "Endless 200mm", "Michelin 23", 83, {5, 1970}, {4, 1996}, "Export"},
	[411] = {0.73, "SAF 2.4 L", "Twin Turbo C", "A5 240", "Lower Suspension Kit 2", "Brembo 270mm", "Brigestone", 46, {1, 1990}, {10, 1992}, "Pegassi"},
	[543] = {0.81, "TF D 1.7 L v2", "", "A5 165", "Macpherson V110", "Brembo 245mm", "Michelin 86", 56, {7, 1973}, {7, 1977}, "Vapid"},
	[416] = {1.1, "SFP D 1.7 L", "", "A5 155", "Macpherson V120", "Endless 215mm", "Michelin 92", 86, {2, 1961}, {1, 1995}, "Brute"},
	[432] = {1, "Chevy V8 Military Edition", "", "A4 80", "Macpherson V121", "Brembo 170mm", "Michelin 93", 833, {9, 1980}, {1, CYear}, "Export"},
	[448] = {0.8, "HRD 110 CC", "", "R3 190", "Macpherson V98", "Brembo 62", "Michelin 12", 11, {3, 1973}, {10, CYear}, "Export"},
	[464] = {0.29, "IAE V2800", "", "F1 75", "Macpherson V122", "Brembo 69", "Michelin 94", 3, {5, 1992}, {4, CYear}, "RC"},
	[480] = {0.77, "SAF 2.4 L", "", "A5 200", "Macpherson V123", "Wilwood 270mm", "Michelin 95", 46, {6, 1976}, {3, 1983}, "Pfister"},
	[496] = {0.7, "TF GLE 2.2 L", "", "F5 200", "Macpherson V124", "Wilwood 270mm", "Michelin 96", 33, {2, 1983}, {1, 1991}, "Dinka"},
	[512] = {1.28, "IAE V1400", "", "A1 200", "Macpherson V125", "Brembo 2", "Hankook", 166, {1, 1957}, {0, CYear}, "Export"},
	[544] = {1.24, "TF D GLE 1.3 L", "", "R5 170", "Macpherson V26", "Wilwood 262mm", "Michelin 25", 216, {4, 1979}, {9, CYear}, "MTL"},
	[576] = {0.6, "HLR 2.0 L", "", "R4 160", "Macpherson V126", "Endless 190mm", "SAVA", 56, {10, 1958}, {10, 1958}, "Declasse"},
	[608] = {1.4, "TESLA 1", "", "R3 160", "Macpherson V11", "Brembo 170mm", "Michelin 10", 33, {4, 1930}, {2, CYear}, "Export"},
	[409] = {0.8, "LPE 2.2 L", "", "R5 180", "Macpherson V45", "Wilwood 260mm", "Michelin 42", 73, {7, 1981}, {6, 1989}, "Albany"},
	[593] = {1.46, "IAE V300", "", "A1 200", "Macpherson V46", "Brembo 2", "Hankook", 166, {9, 1977}, {7, 1985}, "Mammoth"},
	[410] = {0.65, "LPE GT 1.6 L", "", "F3 160", "Macpherson V54", "Endless 233mm", "Michelin 40", 33, {11, 1981}, {5, 1989}, "Albany"},
	[607] = {1.4, "TESLA 1", "", "R3 160", "Macpherson V11", "Brembo 170mm", "Michelin 10", 33, {3, 1930}, {1, CYear}, "Export"},
	[513] = {1.55, "IAE V1500", "", "A1 200", "Macpherson V131", "Brembo 2", "Hankook", 166, {6, 1944}, {1, CYear}, "Export"},
	[545] = {0.81, "HLR GT 1.7 L", "", "R5 160", "Macpherson V132", "Brembo 230mm", "SAVA", 56, {4, 1936}, {11, 1955}, "Export"},
	[577] = {2.2, "IAE V3000", "", "A1 200", "Macpherson V133", "Brembo 33", "Michelin 100", 2000, {7, 1981}, {3, CYear}, "Export"},
	[433] = {1.44, "HLR D 1.1 L", "", "A5 180", "Macpherson V29", "Wilwood 150mm", "Michelin 101", 350, {0, 1982}, {5, CYear}, "DUDE"},
	[449] = {1.46, "TR 3", "", "R5 150", "Macpherson V134", "Brembo 71", "Michelin 102", 63, {4, 1869}, {1, CYear}, "Export"},
	[465] = {0.45, "RR 100", "", "A1 75", "Macpherson V12", "Brembo 12", "Michelin 11", 3, {11, 1992}, {8, CYear}, "RC"},
	[481] = {0.72, "BMX 3", "", "R5 120", "Macpherson V135", "Ferodo GT", "Michelin 69", 3, {1, 1971}, {0, CYear}, "Export"},
	[497] = {1.18, "RR 1000", "", "A1 200", "Macpherson V10", "Brembo 10", "Hankook", 150, {10, 1962}, {5, CYear}, "Buckingham"},
	[514] = {1.6, "TF D 2.0 L v3", "", "R5 120", "Macpherson V136", "Brembo 4", "Michelin 103", 126, {8, 1966}, {0, 2005}, "Export"},
	[546] = {0.71, "LPE 2.0 L", "", "R5 160", "Macpherson V137", "Endless 180mm", "Michelin 104", 60, {0, 1986}, {7, 1991}, "Karin"},
	[578] = {1.63, "HLR D 2.0 L", "", "R5 110", "Macpherson V22", "Wilwood 120mm", "Michelin 105", 183, {1, 1984}, {6, CYear}, "Export"},
	[610] = {1.4, "TESLA 2", "", "R3 160", "Macpherson V138", "Brembo 170mm", "Michelin 106", 13, {2, 1930}, {5, CYear}, "Export"},
	[611] = {1.4, "TESLA 1", "", "R3 160", "Macpherson V11", "Brembo 170mm", "Michelin 10", 33, {5, 1930}, {11, CYear}, "Export"},
	[581] = {0.69, "HRD 950 CC", "", "R5 190", "Macpherson V140", "Brembo 5", "Michelin 108", 16, {11, 1975}, {5, 1981}, "Nagasaki"},
	[591] = {2, "Trailer", "", "R5 120", "Macpherson TR", "Brembo 4", "ANNAITE TR", 126, {3, 1930}, {0, CYear}, "Export"},
	[405] = {0.87, "SFP GLE 1.8 L v3", "", "R5 165", "Macpherson V6", "Brembo 260mm", "Michelin 6", 53, {8, 1990}, {7, 1999}, "Übermacht"},
	[515] = {2.02, "TF D 2.0 L v2", "", "R5 120", "Macpherson V143", "Brembo 4", "Michelin 110", 166, {10, 1992}, {11, CYear}, "Export"},
	[402] = {0.83, "ODL 2.0 L", "", "R5 200", "Macpherson V144", "Wilwood 270mm", "Michelin 95", 50, {6, 1982}, {3, 1988}, "Bravado"},
	[579] = {0.93, "TF 1.7 L", "", "A5 160", "Macpherson V145", "Wilwood 212mm", "Michelin 111", 83, {11, 1970}, {3, 1996}, "Enus"},
	[434] = {0.98, "ODL 1.6 L", "", "R5 200", "Macpherson V142", "Wilwood 270mm", "Michelin 51", 46, {9, 1927}, {2, 1931}, "Vapid"},
	[450] = {2, "Trailer", "", "R5 120", "Macpherson TR", "Brembo 4", "ANNAITE TR", 126, {6, 1930}, {0, CYear}, "Export"},
	[466] = {0.74, "HLR GT 1.7 L v2", "", "R5 160", "Macpherson V102", "Endless 205mm", "Michelin 79", 53, {5, 1959}, {8, 1973}, "Benefactor"},
	[482] = {1.11, "TF 1.7 L v2", "", "R5 150", "Macpherson V146", "Brembo 71", "Michelin 112", 63, {7, 1979}, {6, 1993}, "Declasse"},
	[498] = {1.07, "TRBD 1.3 L v2", "", "R5 140", "Macpherson V147", "Endless 165mm", "Michelin 113", 183, {10, 1978}, {6, 1993}, "Brute"},
	[516] = {0.83, "HLR 2.0 L v2", "", "F5 165", "Macpherson V148", "Endless 232mm", "Michelin 114", 46, {10, 1982}, {8, 1996}, "Export"},
	[548] = {2.55, "RR 1100", "", "A1 200", "Macpherson V149", "Brembo 10", "Hankook", 666, {6, 1962}, {5, CYear}, "Western Company"},
	[580] = {0.8, "SFP 1.7 L v2", "", "R5 165", "Macpherson V150", "Endless 170mm", "Michelin 115", 73, {4, 1965}, {4, 1980}, "Export"},
	[549] = {0.7, "SFP 1.7 L", "", "R4 160", "Macpherson V141", "Endless 236mm", "Michelin 109", 56, {0, 1965}, {11, 1969}, "Declasse"},
	[555] = {0.69, "SAF 1.3 L", "", "R5 180", "Macpherson V92", "Wilwood 230mm", "Michelin 44", 50, {10, 1964}, {3, 1966}, "Enus"},
	[589] = {0.66, "SAF 1.5 L", "", "F5 200", "Macpherson V27", "Wilwood 270mm", "Michelin 26", 46, {10, 1987}, {0, 1989}, "Export"},
	[407] = {1.24, "TF D GLE 1.3 L", "", "R5 170", "Macpherson V26", "Wilwood 262mm", "Michelin 25", 216, {9, 1979}, {10, CYear}, "MTL"},
	[587] = {0.72, "SFP GLE 1.8 L v2", "", "A5 200", "Macpherson V16", "Endless 232mm", "Brigestone", 46, {10, 1983}, {9, 1989}, "Export"},
	[517] = {0.85, "HLR GT 1.8 L v2", "", "R5 165", "Macpherson V155", "Endless 215mm", "Michelin 52", 46, {6, 1982}, {7, 1987}, "Export"},
	[403] = {1.62, "TF D 1.1 L", "", "R5 120", "Macpherson V156", "Brembo 4", "Michelin 110", 126, {6, 1989}, {3, CYear}, "Export"},
	[419] = {0.8, "LPE 2.0 L", "", "R5 160", "Macpherson V157", "Endless 150mm", "Michelin 119", 60, {9, 1975}, {5, 1978}, "Albany"},
	[435] = {2, "Trailer", "", "R5 120", "Macpherson TR", "Brembo 4", "ANNAITE TR", 126, {11, 1930}, {1, CYear}, "Export"},
	[451] = {0.71, "SAF 2.0 L", "", "A5 240", "Lower Suspension Kit 1", "Brembo 270mm", "Michelin 120", 46, {0, 2004}, {6, 2009}, "Grotti"},
	[467] = {0.74, "RST GLE 2.0 L v2", "", "R5 160", "Macpherson V159", "Endless 170mm", "Michelin 121", 63, {4, 1961}, {5, 1962}, "Export"},
	[483] = {0.99, "RST GLE 1.7 L", "", "R5 120", "Macpherson V160", "Brembo 71", "Michelin 122", 63, {8, 1950}, {7, 1967}, "Brute"},
	[499] = {0.99, "TRBD 1.8 L", "", "R5 140", "Macpherson V161", "Endless 165mm", "Michelin 123", 116, {1, 1972}, {9, 1979}, "Vapid"},
	[518] = {0.67, "SFP GLE 1.8 L", "", "R4 160", "Macpherson V162", "Wilwood 175mm", "Michelin 124", 56, {6, 1970}, {0, 1972}, "Albany"},
	[550] = {0.82, "RST GT 2.0 L", "", "F5 160", "Macpherson V163", "Endless 180mm", "Michelin 41", 53, {2, 1996}, {0, 2000}, "Export"},
	[582] = {1.08, "RST D 2.0 L", "", "R5 160", "Macpherson V164", "Endless 193mm", "ANNAITE", 63, {1, 1979}, {8, 1993}, "Declasse"},
	[418] = {1.09, "RST D 1.6 L", "", "R5 150", "Macpherson V151", "Wilwood 185mm", "Michelin 42", 66, {2, 1985}, {1, 1994}, "Declasse"},
	[547] = {0.74, "LPE 1.8 L", "", "R4 160", "Macpherson V139", "Endless 180mm", "Michelin 107", 53, {2, 1986}, {9, 1990}, "Albany"},
	[575] = {0.6, "HLR 2.0 L", "", "R4 160", "Macpherson V128", "Endless 190mm", "Michelin 99", 56, {4, 1946}, {10, 1948}, "Export"},
	[400] = {1.09, "TF D 1.8 L", "", "A5 160", "Macpherson V119", "Endless 200mm", "Michelin 34", 56, {4, 1997}, {1, 2014}, "Dundreary"},
	[605] = {0.81, "TF D 1.7 L v2", "", "A5 165", "Macpherson V110", "Brembo 245mm", "Michelin 86", 56, {6, 1973}, {7, 1977}, "Vapid"},
	[519] = {1.92, "IAE V2500", "", "A1 200", "Macpherson V170", "Brembo 79", "Michelin 129", 500, {8, 1979}, {9, 1987}, "Buckingham"},
	[404] = {0.74, "LPE 1.7 L", "", "F5 150", "Macpherson V171", "Endless 153mm", "Michelin 130", 40, {1, 1962}, {6, 1979}, "Dinka"},
	[583] = {0.54, "RST 1.2 L", "", "R4 170", "Macpherson V172", "Endless 195mm", "Michelin 131", 26, {0, 1950}, {2, CYear}, "Export"},
	[436] = {0.73, "LPE 2.0 L v2", "", "F4 160", "Macpherson V173", "Endless 234mm", "Michelin 132", 46, {2, 1980}, {9, 2006}, "Export"},
	[452] = {0.51, "BE 400 CC", "", "R5 190", "Macpherson V174", "Brembo 81", "Michelin 133", 73, {3, 1994}, {0, CYear}, "Pegassi"},
	[468] = {0.77, "HRD 900 CC", "", "R5 190", "Macpherson V5", "Brembo 62", "Michelin 69", 16, {2, 1989}, {8, 1999}, "Maibatsu Corporation"},
	[484] = {0.54, "BE 900 CC", "", "R5 190", "Macpherson V175", "Brembo 82", "Michelin 134", 166, {9, 1965}, {10, 1987}, "Dinka"},
	[573] = {1.65, "MT 3", "", "A5 110", "Macpherson V109", "Wilwood 212mm", "Michelin 85", 333, {2, 2002}, {8, CYear}, "MTL"},
}

--[[
-- [Год][Месяц+1] = {{"Событие 1"}, {"Событие 2"}}
local Style = {
	['head'] = "<div class='collumn'><div class='head'><span class='headline hl3'>",
	['/head'] = "</span></div>",
	['content'] = "<p>",
	['/content'] = "</p></div>",
	['img'] = "<figure class='figure'><img class='media' src='img/",
	['/img'] = "'></figure>"
}


local News = {
	[1962] = {
		[1] = {{Style['head'].."Защищай свои права!"..Style['/head']..Style['content']..Style['img'].."Ammu-Nation.gif"..Style['/img'].."Открылась сеть оружейных магазинов Ammu-Nation"..Style['/content']}}
	},
	[1970] = {
		[1] = {{Style['head']..""..Style['/head']..Style['content']..Style['img'].."K-DST.jpg."..Style['/img']..'Новая радиостанция К-DST запускает вещание, диджеем выступит Томми «The Nightmare» Смит, жанр ротаций классический рок.'..Style['/content']}}
	},
	[1974] = {
		[1] = {{Style['head'].."По штату открылись автомастерские Pay'n'Spray"..Style['/head']..Style['content']..''..Style['/content']}}
	},
	[1982] = {
		[5] = {{Style['head'].."Charles K. Bell Основывает сеть быстрого питания Cluckin' Bell"..Style['/head']..Style['content']..''..Style['/content']}}
	},
	[1984] = {
		[6] = {{Style['head'].."В штате Флорида города Vice City убит один из основателей банды «Картель Мендеса» наркобарон Армандо Мендес"..Style['/head']..Style['content']..''..Style['/content']}},
		[7] = {{Style['head'].."В штате Флорида города Vice City убит наркобарон Диего Мендес. «Картель Мендеса» прекращает своё существование"..Style['/head']..Style['content']..''..Style['/content']}}
	},
	[1985] = {
		[3] = {{Style['head'].."Игровой автомат DEGENATRON появился в штате"..Style['/head']..Style['content']..''..Style['/content']}},
	},
	[1986] = {
		[9] = {{Style['head'].."Харвудский Мясник"..Style['/head']..Style['content']..'Томми Версетти, выпущен из тюрьмы в Либерти-Сити'..Style['/content']}}
	},
	[1987] = {
		[8] = {{Style['head'].."В Либерти-Сити произошел разлив нефти"..Style['/head']..Style['content']..''..Style['/content']}},
	},
	[1988] = {
		[2] = {{Style['head'].."Район San Fierro — Doherty разрушен в результате землетрясения"..Style['/head']..Style['content']..''..Style['/content']}}

	},
	[1990] = {
		[1] = {{Style['head'].."В Лос-Сантосе открылся магазин «...And Cut!»"..Style['/head']..Style['content']..''..Style['/content']}},
		[2] = {{Style['head'].."Рэпер Мэдд Догг выпустил два альбома - «Hustlin' Like Gangstaz» и «Still Madd»"..Style['/head']..Style['content']..''..Style['/content']}},
		[4] = {{Style['head'].."Роджер С. Хоул Официально приведен к присяге мэра Либерти-Сити"..Style['/head']..Style['content']..''..Style['/content']}},
	},
	[1991] = {
		[4] = {
				{Style['head'].."Рэп-певица Рочелли выпустила свой первый альбом «Leg$»"..Style['/head']..Style['content']..''..Style['/content']},
				{Style['head'].."One Eyed Monster War вышел на карманную консоль EXsorbeo"..Style['/head']..Style['content']..''..Style['/content']}
			},
		[7] = {{Style['head'].."Мэдд Догг выпустил свой третий альбом «24 Carat Dogg»"..Style['/head']..Style['content']..''..Style['/content']}}

	},
	[1993] = {
		[3] = {{Style['head'].."Рэпер Мэдд Догг выпустил альбом «Forty Dogg», четвертый по счету"..Style['/head']..Style['content']..''..Style['/content']}},
		[11] = {{Style['head'].."Известный актер Джек Ховитцер приговорен к 15 годам лишения свободы за расстрел Билли Декстера"..Style['/head']..Style['content']..''..Style['/content']}}
	}

}

--]]




--	for model, arr in pairs(VehicleSystem) do
--		if(not News[arr[9][2]]) then News[arr[9][2]] = {} end
--		if(not News[arr[10][2]]) then News[arr[10][2]] = {} end
--		if(not News[arr[9][2]][arr[9][1]+1]) then News[arr[9][2]][arr[9][1]+1] = {} end
--		if(not News[arr[10][2]][arr[10][1]+1]) then News[arr[10][2]][arr[10][1]+1] = {} end
--
--		News[arr[9][2]][arr[9][1]+1][#News[arr[9][2]][arr[9][1]+1]+1] = {Style['head']..
--		getVehicleNameFromModel(model).." от "..arr[11]..Style['/head']..Style['content']..
--		Style['img'].."car"..model..".png"..Style['/img']..'Автомобильный завод '..arr[11].." запускает производство автомобиля "..
--		getVehicleNameFromModel(model).."."..Style['/content']}
--
--		News[arr[10][2]][arr[10][1]+1][#News[arr[10][2]][arr[10][1]+1]+1] = {Style['head']..
--		getVehicleNameFromModel(model).." от "..arr[11]..Style['/head']..Style['content']..
--		Style['img'].."car"..model..".png"..Style['/img']..'Автомобильный завод '..arr[11].." прекращает производство автомобиля "..
--		getVehicleNameFromModel(model).."."..Style['/content']}
--	end
--
--
--
--
--	local hFile = fileCreate("news.php")
--	local newsphp = "<? \n$news = array(\n"
--
--	for y, arr in pairs(News) do
--		newsphp = newsphp..'	"'..y..'" => array(\n'
--		for m, arr2 in pairs(arr) do
--			newsphp = newsphp..'		"'..m..'" => array('
--			for _, text in pairs(arr2) do
--				newsphp = newsphp..'\n			"'..text[1]..'",'
--			end
--			newsphp = newsphp..'\n		),\n'
--		end
--
--		newsphp = newsphp..'	),\n'
--	end
--	newsphp = newsphp..')\n?>'
--
--	fileWrite(hFile, newsphp)
--	fileClose(hFile)





function usearmor(thePlayer, slot)
	setPedArmor(thePlayer, 100)
end
addEvent("usearmor", true)
addEventHandler("usearmor", root, usearmor)



function SetTeam(thePlayer, team)
	local r, g, b = getTeamColor(getTeamFromName(team))
	setElementData(thePlayer, "color", RGBToHex(r,g,b))
	setBlipColor(PData[thePlayer]['radar'], r,g,b, 0)
	SetDatabaseAccount(thePlayer, "team", team)
	setPlayerTeam(thePlayer, getTeamFromName(team))
end


function CreateObject(modelid, x, y, z, rx, ry, rz, isLowLOD, i, d)
	local o = createObject(modelid, x, y, z, rx, ry, rz, isLowLOD)
	if(i) then setElementInterior(o, i) end
	if(d) then setElementDimension(o, d) end
	return o
end


function CreatePickup(x, y, z, theType, model, respawnTime, ammo, i, d)
	local o = createPickup(x, y, z, theType, model, respawnTime, ammo)
	if(i) then setElementInterior(o, i) end
	if(d) then setElementDimension(o, d) end
	return o
end



-- Просто копировать сюда обновления из клиента

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














function CreateVehicle(model, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	if(model == 522) then
		bDirection, variant1, variant2 = false, 4, 4
	end
	local theVehicle = createVehicle(model, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	setVehicleFuelTankExplodable(theVehicle, true)
	local comp = {VehicleSystem[model][2], VehicleSystem[model][3], VehicleSystem[model][4], VehicleSystem[model][5], VehicleSystem[model][6], VehicleSystem[model][7]}
	UpdateVehicleHandling(theVehicle, comp)


	if(VehicleTrunks[model]) then
		local arr = {}
		for slot = 1, #VehicleTrunks[model] do
			arr[slot] = {}
			for slot2 = 1, 2 do
				arr[slot][slot2] = {}
			end
		end
		setElementData(theVehicle, "trunk", toJSON(arr))
	end

	--[[local h = getVehicleHandling(theVehicle)
	local hh = getModelHandling(model)
	for k in pairs(hh) do
		if(tonumber(h[k])) then
			if(h[k] ~= hh[k]) then
				outputChatBox(h[k].." ~= "..hh[k].." "..k.." "..model)
				fileDelete("save.txt")
				local hFile = fileCreate("save.txt")
				fileWrite(hFile, h[k].." ~= "..hh[k].." "..k.." "..model) -- write a text line
				fileClose(hFile)
			end
		end
	end--]]
	return theVehicle
end



function AddPlayerArmas(thePlayer, model)
	if(getElementData(thePlayer, "armasplus")) then
		local arr = fromJSON(getElementData(thePlayer, "armasplus"))
		arr[model] = true
		setElementData(thePlayer, "armasplus", toJSON(arr))
		triggerClientEvent(thePlayer, "AddPlayerArmas", thePlayer, thePlayer, model)
	end
end


function RemovePlayerArmas(thePlayer, model)
	if(getElementData(thePlayer, "armasplus")) then
		local arr = fromJSON(getElementData(thePlayer, "armasplus"))
		arr[tostring(model)] = nil
		setElementData(thePlayer, "armasplus", toJSON(arr))
		triggerClientEvent(thePlayer, "RemovePlayerArmas", thePlayer, thePlayer, model)
	end
end




function UpdateVehicleHandling(theVehicle, arr)
	setElementData(theVehicle, "handl", toJSON(arr), false)
	local engine,turbo,transmission,suspension,brakes,tires = arr[1], arr[2], arr[3], arr[4], arr[5], arr[6]

	local model = getElementModel(theVehicle)
	local NewEngineMass = VComp["Engines"][engine][5]/14
	local OldEngineMass = VComp["Engines"][VehicleSystem[model][2]][5]/14
	local HT = getModelHandling(model)
	local NewMass = HT["mass"]+(NewEngineMass-OldEngineMass)
	setVehicleHandling(theVehicle, "mass", NewMass)

	local TotalEnginePower = VComp["Engines"][engine][3]/(VComp["Engines"][engine][5]/NewMass)--Мощность

	setVehicleHandling(theVehicle, "engineAcceleration", VComp["Engines"][engine][2])--Ускорение *трансмиссия
	setVehicleHandling(theVehicle, "dragCoeff", TotalEnginePower)
	setVehicleHandling(theVehicle, "engineType", VComp["Engines"][engine][4])

	setVehicleHandling(theVehicle, "numberOfGears", VComp["Transmission"][transmission][2])
	setVehicleHandling(theVehicle, "driveType", VComp["Transmission"][transmission][3])
	setVehicleHandling(theVehicle, "maxVelocity", VComp["Transmission"][transmission][4])

	if(VComp["Turbo"][turbo]) then
		setVehicleHandling(theVehicle, "engineAcceleration", VComp["Engines"][engine][2]+VComp["Turbo"][turbo][2])
		setVehicleHandling(theVehicle, "dragCoeff", TotalEnginePower-VComp["Turbo"][turbo][3])
		setElementData(theVehicle, "turbo", true)
	end

	setVehicleHandling(theVehicle, "suspensionForceLevel", VComp["Suspension"][suspension][2])
	setVehicleHandling(theVehicle, "suspensionDamping", VComp["Suspension"][suspension][3])
	setVehicleHandling(theVehicle, "suspensionHighSpeedDamping", VComp["Suspension"][suspension][4])
	setVehicleHandling(theVehicle, "suspensionUpperLimit", VComp["Suspension"][suspension][5])
	setVehicleHandling(theVehicle, "suspensionLowerLimit", VComp["Suspension"][suspension][6])
	setVehicleHandling(theVehicle, "suspensionFrontRearBias", VComp["Suspension"][suspension][7])
	setVehicleHandling(theVehicle, "suspensionAntiDiveMultiplier", VComp["Suspension"][suspension][8])

	setVehicleHandling(theVehicle, "brakeDeceleration", VComp["Brakes"][brakes][2])
	setVehicleHandling(theVehicle, "brakeBias", VComp["Brakes"][brakes][3])

	setVehicleHandling(theVehicle, "tractionMultiplier", VComp["Tires"][tires][2])
	setVehicleHandling(theVehicle, "tractionLoss", VComp["Tires"][tires][3])
	setVehicleHandling(theVehicle, "tractionBias", VComp["Tires"][tires][4])
end



--[[
local vs = CreateVehicle(576, -217, 2603.3, 62.7, 0, 0, 81, "test", true, 3, 3)
setElementData(vs, "trunk", toJSON({{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Зерно", 1, 1, toJSON({})}, {"Зерно", 1, 1, toJSON({})}, {"Зерно", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},
{"Запаска", 1, 1, toJSON({})}, {"АК-47", 1, 1, toJSON({})}, {"Пакет", 1, 1, toJSON({})},

}))

setVehicleDoorOpenRatio(vs, 1, 1)
--]]



--FARMLS2
tmpv = CreateVehicle(543, 1905, 175, 37.2, 0, 0, 320, "IL20 228")
setVehicleVariant(tmpv, 4, 4, 4, 4)




--Автошкола SF
CreateVehicle(439, -2062.2, -108.7, 35.3, 0, 0, 180, "USF0 228", true, 1, 1)
CreateVehicle(419, -2072.2, -108.7, 35.3, 0, 0, 180, "USF1 228", true, 1, 1)
CreateVehicle(426, -2082, -108.7, 35.3, 0, 0, 180, "USF2 228", true, 1, 1)
CreateVehicle(496, -2091.2, -108.7, 35.3, 0, 0, 180, "USF3 228", true, 1, 1)



--SF Garage
createObject(11388, -2048.216796875, 166.73092651367, 34.468391418457, 0,0,0)
createObject(11389, -2048.1174316406, 166.71966552734, 30.975694656372, 0,0,0)
createObject(11390, -2048.1791992188, 166.76277160645, 32.235980987549, 0,0,0)
createObject(11392, -2047.8289794922, 167.54446411133, 27.835615158081, 0,0,0)
createObject(11393, -2043.5166015625, 161.337890625, 29.320350646973, 0,0,0)



local ItemsTrade = {
	["24/7"] = {{"Газета", "Sell", 450, {}}, {"Роза", "Sell", 350, {}}, {"Трость", "Sell", 350, {}}, {"Цветы", "Sell", 650, {}}, {"Пакет", "Sell", 750, {["content"] = {{},{},{},{},{},{},{},{}}}}, {"CoK", "Sell", 450, {["сигареты"] = {"Сигарета", 20, 450, toJSON({})}}}, {"Pissh", "Sell", 350, {["hp"] = {"hp", 100, 0, {}}}}, {"Pissh Gold", "Sell", 350, {["hp"] = {"hp", 100, 0, {}}}}, {"isabella", "Sell", 350, {["hp"] = {"hp", 100, 0, {}}}}, {"Канистра", "Sell", 450, {}}, {"Спрей", "Sell", 450, {}}},
	["Zip"] = {{"Чемодан", "Sell", 550, {["content"] = {{},{},{},{},{},{},{},{},{},{},{},{}}}}},
	["ProLaps"] = {{"Бита", "Sell", 450, {}}, {"Клюшка", "Sell", 450, {}}, {"Парашют", "Sell", 250, {}}},
	["Binco"] = {{"Рюкзак", "Sell", 450, {["content"] = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}}}},
	["AMMO1"] = {{"Deagle", "Sell", 450, {}}, {"MP5", "Sell", 450, {}}, {"АК-47", "Sell", 450, {}}, {"М16", "Sell", 450, {}}, {"M40", "Sell", 450, {}}, {"ИЖ-12", "Sell", 450, {}}, {"9-мм", "Sell", 450, {}}, {"5.56-мм", "Sell", 450, {}}, {"7.62-мм", "Sell", 450, {}}, {"18.5-мм", "Sell", 450, {}},{"Граната", "Sell", 550, {}}, {"Молотов", "Sell", 550, {}}, {"Бронежилет", "Sell", 650, {}}, {"Лазерный прицел", "Sell", 350, {}}},
	["AMMO2"] = {{"Кастет", "Sell", 450, {}}, {"USP-S", "Sell", 450, {}}, {"Tec-9", "Sell", 450, {}}, {"АК-47", "Sell", 450, {}}, {"М16", "Sell", 450, {}}, {"M40", "Sell", 450, {}}, {"ИЖ-12", "Sell", 450, {}}, {"9-мм", "Sell", 450, {}}, {"5.56-мм", "Sell", 450, {}}, {"7.62-мм", "Sell", 450, {}}, {"18.5-мм", "Sell", 450, {}}, {"Бронежилет", "Sell", 450, {}}, {"Лазерный прицел", "Sell", 450, {}}},
	["AMMO3"] = {{"Кольт 45", "Sell", 450, {}}, {"Огнемет", "Sell", 450, {}}, {"Узи", "Sell", 450, {}}, {"Mossberg", "Sell", 450, {}}, {"Sawed-Off", "Sell", 450, {}}, {"SPAS-12", "Sell", 450, {}}, {"ИЖ-12", "Sell", 450, {}}, {"9-мм", "Sell", 450, {}}, {"5.56-мм", "Sell", 450, {}}, {"7.62-мм", "Sell", 450, {}}, {"18.5-мм", "Sell", 450, {}}, {"Бронежилет", "Sell", 550, {}}, {"Лазерный прицел", "Sell", 350, {}}},
	["AMMO4"] = {{"Кольт 45", "Sell", 450, {}}, {"Базука", "Sell", 450, {}}, {"Узи", "Sell", 450, {}}, {"АК-47", "Sell", 450, {}}, {"М16", "Sell", 450, {}}, {"Mossberg", "Sell", 450, {}}, {"Sawed-Off", "Sell", 450, {}}, {"SPAS-12", "Sell", 450, {}}, {"ИЖ-12", "Sell", 450, {}}, {"9-мм", "Sell", 450, {}}, {"5.56-мм", "Sell", 450, {}}, {"7.62-мм", "Sell", 450, {}}, {"18.5-мм", "Sell", 450, {}}, {"Ракета", "Sell", 450, {}}, {"Бронежилет", "Sell", 550, {}}, {"Лазерный прицел", "Sell", 350, {}}},
	["Electronics Shop"] = {{"Телефон", "Sell", 650, {}}, {"Камера", "Sell", 450, {}}, {"Бензопила", "Sell", 450, {}}},
	["Sex Shop"] = {{"Dildo XXL", "Sell", 450, {}}, {"Dildo", "Sell", 450, {}}, {"Вибратор", "Sell", 450, {}}},
	["Bait Shop"] = {{"Нож", "Sell", 250, {}}, {"Удочка", "Sell", 150, {}}, {"Лопата", "Sell", 450, {}}},
	["Liquor Shop"] = {{"CoK", "Sell", 650, {["сигареты"] = {"Сигарета", 20, 450, toJSON({})}}}, {"KBeer", "Sell", 550, {["hp"] = {"hp", 100, 0, {}}}}, {"KBeer Dark", "Sell", 550, {["hp"] = {"hp", 100, 0, {}}}}, {"Pissh", "Sell", 650, {["hp"] = {"hp", 100, 0, {}}}}, {"Pissh Gold", "Sell", 650, {["hp"] = {"hp", 100, 0, {}}}}, {"isabella", "Sell", 350, {["hp"] = {"hp", 100, 0, {}}}}},
}



local CarsForSaleModel = {
	["HARD TRUCK"] = {515, 514, 403, 499, 524, 609, 498, 455, 414, 456, 440},
	["WANG CARS"] = {560, 561, 565, 558, 562, 559, 429},
	["Coutt And Schutz"] = {412, 534, 535, 536, 566, 567, 576, 545, 466, 462, 467, 483},
	["SF ELITE"] = {415, 451, 411, 477, 506, 541, 603},
	["Mr. Grant's"] = {510, 509, 481, 462, 471, 468},
	["GROTTI"] = {401, 404, 410, 540, 585, 436, 439, 458, 475, 418, 589, 550, 479, 547, 546, 551, 491, 496, 507, 516, 517, 526, 527, 529, 492},
	["LV Center"] = {400, 422, 402, 405, 419, 421, 426, 445, 580},
	["LV Center 2"] = {489, 480, 533, 554, 579, 409, 586, 463},
	["LV Trash"] = {474, 500, 518, 542, 549, 575, 600, 404, 555, 478},
	["LS AERO"] = {487}, 
}



-- {theVehicle, x, y, z, rx,ry,rz}
local CarsForSale = {
	["LS AERO"] = {
		[1] = {false, 1892.5, -2628.7, 12.5, 0,0,0},
	}, 
	["HARD TRUCK"] = {
		[1] = {false, 2782.6, -2392.4, 12.6, 0,0,180},
		[2] = {false, -26.1, -1125.1, 0.1, 0,0,156},
		[3] = {false, 1760.4, -2056.2, 13.3, 0,0,250},
		[4] = {false, -320, 2686, 61.7, 0,0,0},
		[5] = {false, 2400.2, 2753.4, 9.8, 0,0,180},
		[6] = {false, 2368, 2755.1, 9.8, 0,0,180},
		[7] = {false, 2399.9, 2802, 9.8, 0,0,0},
	},
	["WANG CARS"] = {
		[1] = {false, -1957.7, 277.0, 34.5, 0,0,133},
		[2] = {false, -1950.5, 259.7, 34.5, 0,0,53},
		[3] = {false, -1948, 267.5, 34.5, 0,0,90},
		[4] = {false, -1956.3, 297.7, 34.5, 0,0,64},
		[5] = {false, -1952.6, 265.7, 40, 0,0,292},
		[6] = {false, -1952.8, 258.8, 40, 0,0,259},
		[7] = {false, -1954.7, 302.7, 40, 0,0,180}
	},
	["Coutt And Schutz"] = {
		[1] = {false, 2120, -1124, 24.4, 0, 0, 270},
		[2] = {false, 2120, -1128, 24.4, 0, 0, 270},
		[3] = {false, 2120, -1132, 24.3, 0, 0, 270},
		[4] = {false, 2120, -1136, 24.2, 0, 0, 270},
		[5] = {false, 2120, -1140, 23.9, 0, 0, 270},
		[6] = {false, 2120, -1144, 23.6, 0, 0, 270},
		[7] = {false, 2120, -1148, 23.3, 0, 0, 270},
		[8] = {false, 2135, -1128, 24.6, 0, 0, 90},
		[9] = {false, 2135, -1132, 24.7, 0, 0, 90},
		[10] = {false, 2135, -1136, 24.7, 0, 0, 90},
		[11] = {false, 2135, -1140, 24.3, 0, 0, 90},
		[12] = {false, 2135, -1144, 23.9, 0, 0, 90},
		[13] = {false, 2135, -1148, 23.4, 0, 0, 90}
	},
	["SF ELITE"] = {
		[1] = {false, -1661.9, 1213.8, 6.3, 0,0,260},
		[2] = {false, -1665, 1223.6, 12.7, 0,0,220},
		[3] = {false, -1661, 1212, 12.7, 0,0,0},
		[4] = {false, -1655.5, 1212, 12.7, 0,0,0},
		[5] = {false, -1665, 1223.6, 20.2, 0,0,220},
		[6] = {false, -1661, 1212, 20.2, 0,0,0},
		[7] = {false, -1655.5, 1212, 20.2, 0,0,0}
	},
	["Mr. Grant's"] = {
		[1] = {false, 695, -521.9, 15.3, 0,0,220},
		[2] = {false, 696.5, -521.9, 15.3, 0,0,220},
		[3] = {false, 698, -521.9, 15.3, 0,0,220},
		[4] = {false, 705.5, -521.9, 15.3, 0,0,140},
		[5] = {false, 707.75, -521.9, 15.3, 0,0,140},
		[6] = {false, 710, -521.9, 15.3, 0,0,140}
	},
	["LV Center"] = {
		[1] = {false, 1941, 2042, 9.8, 0,0,0},
		[2] = {false, 1946, 2042, 9.8, 0,0,0},
		[3] = {false, 1941, 2063, 9.8, 0,0,0},
		[4] = {false, 1946, 2063, 9.8, 0,0,0},
		[5] = {false, 1941, 2074, 9.8, 0,0,0},
		[6] = {false, 1946, 2074, 9.8, 0,0,0},
		[7] = {false, 1941, 2095, 9.8, 0,0,0},
		[8] = {false, 1946, 2095, 9.8, 0,0,0}
	},
	["LV Center 2"] = {
		[1] = {false, 2175, 1386.5, 9.8, 0,0,90},
		[2] = {false, 2175, 1392, 9.8, 0,0,90},
		[3] = {false, 2195, 1386.5, 9.8, 0,0,90},
		[4] = {false, 2195, 1392, 9.8, 0,0,90},
		[5] = {false, 2206, 1386.5, 9.8, 0,0,90},
		[6] = {false, 2206, 1392, 9.8, 0,0,90},
		[7] = {false, 2226, 1386.5, 9.8, 0,0,90},
		[8] = {false, 2226, 1392, 9.8, 0,0,90}
	},
	["LV Trash"] = {
		[1] = {false, 529, 2367, 29.4, 0,0,120},
		[2] = {false, 524, 2370, 29.3, 0,0,120},
		[3] = {false, 520, 2373, 29.3, 0,0,120},
		[4] = {false, 516, 2376, 29.3, 0,0,120},
		[5] = {false, 512, 2379, 29.2, 0,0,120},
		[6] = {false, 509, 2382, 29.1, 0,0,120},
		[7] = {false, 506, 2385, 29, 0,0,120}
	},
	["GROTTI"] = {
		[1] = {false, 560, -1291, 16.2, 0,0,0},
		[2] = {false, 556, -1291, 16.2, 0,0,0},
		[3] = {false, 552, -1291, 16.2, 0,0,0},
		[4] = {false, 548, -1291, 16.2, 0,0,0},
		[5] = {false, 544, -1291, 16.2, 0,0,0},
		[6] = {false, 540, -1291, 16.2, 0,0,0},
		[7] = {false, 536, -1291, 16.2, 0,0,0},
		[8] = {false, 532, -1291, 16.2, 0,0,0},
		[9] = {false, 552, -1264, 16.2, 0,0,210},
		[10] = {false, 549, -1266, 16.2, 0,0,210},
		[11] = {false, 546, -1268, 16.2, 0,0,210},
		[12] = {false, 543, -1270, 16.2, 0,0,210},
		[13] = {false, 540, -1272, 16.2, 0,0,210},
		[14] = {false, 537, -1275, 16.2, 0,0,210},
		[15] = {false, 534, -1278, 16.2, 0,0,210},
		[16] = {false, 531, -1281, 16.2, 0,0,210},
	}
}


-- {название, множитель}
local TrailersVaritans = {
	[435] = {
		[1] = {"Хлопья", 1},
		[2] = {"Сок", 1},
		[3] = {"Одежда", 1},
		[4] = {"Одежда", 1},
		[5] = {"Неизвестный груз", 1},
		[6] = {"Скот", 1.5}
	},
	[450] = {
		[1] = {"Уголь", 1.5},
	},
	[591] = {
		[1] = {"Товары", 1.2}
	},
	[584] = {
		[1] = {"Бензин", 2},
	},
	[499] = {
		[1] = {"Инструменты", 1.5},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Садовые растения", 1},
		[4] = {"Мебель", 1.2}
	},
	[524] = {
		[1] = {"Цемент", 1.5}
	},
	[609] = {
		[1] = {"Неизвестный груз", 1}
	},
	[498] = {
		[1] = {"Химикаты", 2}
	},
	[455] = {
		[1] = {"Неизвестный груз", 1},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Неизвестный груз", 1}
	},
	[414] = {
		[1] = {"Игрушки", 1},
		[2] = {"Одежда", 1},
		[3] = {"Одежда", 1},
		[4] = {"Электроника", 1},
	},
	[456] = {
		[1] = {"Пропан", 1.5},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Неизвестный груз", 1},
		[4] = {"Удобрения", 1},
	},
	[440] = {
		[1] = {"Хлопья", 1},
		[2] = {"Фрукты", 1},
		[3] = {"Продукты", 1.5},
		[4] = {"Строительные материалы", 1.5},
		[5] = {"Автомобильные запчасти", 1},
		[6] = {"Автомобильные запчасти", 1}
	},
}



local BrokenVehicleHandlingPrototype = {404, 604, 467, 401, 543, 478, 474} -- Запчасти с перечисленных авто используются рандомно в б\у авто
function SpawnCarForSale(update)
	if(update) then
		for CompanyName, models in pairs(CarsForSale) do
			for i, arr in pairs(models) do
				if(arr[1] ~= false) then
					destroyElement(arr[1])
					arr[1] = false
				end
			end
		end
	end

	local VCL = {}
	for CompanyName, models in pairs(CarsForSaleModel) do
		for i, model in pairs(models) do
			local block = false
			if(VehicleSystem[model][9][2] <= ServerDate.year+1900) then -- Начало производства авто
				if(VehicleSystem[model][9][2] == ServerDate.year+1900) then -- Производство текущего года
					if(VehicleSystem[model][9][1] > ServerDate.month) then -- Зависимость от месяца
						block = true
					end
				end
				if(VehicleSystem[model][10][2] >= ServerDate.year+1900) then -- Конец производства авто
					if(VehicleSystem[model][10][2] == ServerDate.year+1900) then -- Производство текущего года
						if(VehicleSystem[model][10][1] < ServerDate.month) then -- Зависимость от месяца
							if(CompanyName ~= "LV Trash" and CompanyName ~= "Coutt And Schutz") then -- Для рынка б\у авто
								block = true
							end
						end
					end
				else
					if(CompanyName ~= "LV Trash" and CompanyName ~= "Coutt And Schutz") then -- Для рынка б\у авто
						block = true
					end
				end
				if(not block) then
					if(not VCL[CompanyName]) then VCL[CompanyName] = {} end
					VCL[CompanyName][#VCL[CompanyName]+1] = model
				end
			end
		end
	end

	for CompanyName, slots in pairs(CarsForSale) do
		if(VCL[CompanyName]) then
			for _, arr in pairs(slots) do
				local model = VCL[CompanyName][math.random(#VCL[CompanyName])]
				local var = nil -- Для грузовиков
				if(TrailersVaritans[model]) then
					var = math.random(#TrailersVaritans[model])-1
				end

				arr[1] = CreateVehicle(model, arr[2], arr[3], arr[4]+VehicleSystem[model][1], arr[5], arr[6], arr[7], "SELL 228", true, var, var)

				if(CompanyName == "LV Trash" or CompanyName == "Coutt And Schutz") then -- Для рынка б\у авто
				  local HT = getVehicleHandling(arr[1])
					for slot = 0, 5 do
						setVehicleDoorState(arr[1], slot, math.random(0,3))
					end
					local maxyear = VehicleSystem[model][10][2]
					if(maxyear > ServerDate.year+1900) then maxyear = ServerDate.year+1900 end

					setElementData(arr[1], "year", math.random(VehicleSystem[model][9][2], maxyear))
					setElementData(arr[1], "price", math.round((HT["monetary"]/2)+math.random(-2000, 2000), 0))

					local comp = { -- Выдаем случайные запчасти
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][2],
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][3],
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][4],
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][5],
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][6],
						VehicleSystem[BrokenVehicleHandlingPrototype[math.random(#BrokenVehicleHandlingPrototype)]][7]
					}
					UpdateVehicleHandling(arr[1], comp)
				else
					setElementData(arr[1], "year", ServerDate.year+1900)
				end

			end
		end
	end


end


--SF Airport
CreateVehicle(476, -1374.1, -503.1, 14.9, 0, 0, 249)
CreateVehicle(520, -1286, 501.5, 18, 0, 0, 270)
CreateVehicle(487, -1244.6, -599.2, 13.9, 0, 0, 48)

--LV Airport
CreateVehicle(577, 1586.941, 1190.642, 10.863, 0, 0, 180)
CreateVehicle(487, 1544.0, -1352.0, 329.0, 0, 0, 95)
CreateVehicle(487, 2092.0, 2415.0, 75.0, 0, 0, 260)
CreateVehicle(548, 2619.0, 2721.0, 37.0, 0, 0, 90)
CreateVehicle(447, -2227.0, 2329.0, 8.0, 0, 0, 180)


--UNKNOWN
CreateVehicle(553, -1180.865, -351.9529, 13.948, 0, 0, 0)
CreateVehicle(417, -1215.1, -6.14, 13.9, 0, 0, 95)
CreateVehicle(469, -1963.0, 628.0, 151.0, 0, 0, 182)
CreateVehicle(563, -2726.0, 682.0, 72.0, 0, 0, 90)
CreateVehicle(563, -1190.1, 22.14, 13.9, 0, 0, 45)
CreateVehicle(460, -637.1, 1811.953, 1.7, 0, 0, 180)
CreateVehicle(460, -959.0813, 2629.206, 43.229, 0, 0, 110)




--[Должность], необходимая репутация, фракция, скин
local VacancyDATA = {
	["Патриарх"] = {250, "Мирные жители", 0, 68},
	["Рядовой"] = {10, "Полиция", 0, 280},
	["Инспектор ДПС"] = {25, "Полиция", 0, 284},
	["Сержант"] = {100, "Полиция", 0, 281},
	["Лейтенант"] = {250, "Полиция", 0, 282},
	["SWAT"] = {300, "Полиция", 0, 285},
	["Офицер 1 класса"] = {400, "Полиция", 0, 267},
	["Офицер 2 класса"] = {500, "Полиция", 0, 266},
	["Шериф округа Red County"] = {600, "Полиция", 0, 283},
	["Помощник шерифа"] = {700, "Полиция", 0, 288},
	["Начальник LSPD"] = {0, "Полиция", 0, 265},
	["Начальник SFPD"] = {0, "Полиция", 0},
	["Начальник LVPD"] = {0, "Полиция", 0},
	["ФБР"] = {250, "ФБР", 0, 286},
	["Директор ЦРУ"] = {0, "ЦРУ", 0, 166},
	["Санитар"] = {0, "МЧС", 0, 276},
	["Репортер"] = {500, "Мирные жители", 0},
	["Ученик"] = {70, "МЧС", 0, 275},
	["Врач"] = {120, "МЧС", 0, 274},
	["Учёный CPC"] = {200, "ЦРУ", 0, 70},
	["Тайный агент по борьбе с наркотиками"] = {400, "ЦРУ", 0, 295},
}






--Байкеры LV
CreateVehicle(463, 2624, 2334.2, 10.3,0,0,180,"METAL228", true)
CreateVehicle(586, 2642.3, 2315.4, 10.2, 0,0,265,"METAL228", true)
CreateVehicle(468, 2657.6, 2336, 10.2, 0,0,20,"METAL228", true)
CreateVehicle(463, 2592.2, 2279, 10.4,0,0,270,"METAL228", true)
CreateVehicle(463, 2613.2, 2275.3, 10.4,0,0,90,"METAL228", true)
CreateVehicle(468, 2594.2, 2248.7, 10.4,0,0,0,"METAL228", true)


--Байкеры стадион
tmpv = CreateVehicle(468, -1469, 1558, 1052.5,0,0,20,"METAL228", true)
setElementInterior(tmpv, 14)
tmpv = CreateVehicle(468, -1471, 1558, 1052.5,0,0,20,"METAL228", true)
setElementInterior(tmpv, 14)
tmpv = CreateVehicle(468, -1473, 1558, 1052.5,0,0,20,"METAL228", true)
setElementInterior(tmpv, 14)







local tmpv = CreateVehicle(534, -416.1, 1350.1, 12.7, 0, 0, 0, " THECAR", true,1,1)
setVehicleColor(tmpv, 13,13,13)
addVehicleUpgrade(tmpv, 1123)


local tining = createObject(3094, -416.1, 1350.1, 12.7, 0,0,0)
setObjectScale(tining, 0.8)
setElementCollisionsEnabled(tining, false)
attachElements(tining, tmpv,0,0,0.58,0,180,0)
local tining2 = createObject(3094, -416.1, 1350.1, 12.7, 0,0,0)
setObjectScale(tining2, 0.7)
setElementCollisionsEnabled(tining2, false)
attachElements(tining2, tmpv,0,-0.1,-0.13,0,0,0)











--Контрактники
CreateVehicle(520, -1310.2, 507.6, 18.2,  0, 0, 90, "ABC3 228")
CreateVehicle(470, -1340, 458.7, 7.2, 0, 0, 0, "ABC4 228")
CreateVehicle(470, -1345, 458.7, 7.2, 0, 0, 0, "ABC5 228")
CreateVehicle(433, -1350, 458.7, 7.2, 0, 0, 0, "ABC6 228")







--Зона 51 лаборатория
local o = createObject(17058, 280, 1829,7,0,180,0)--Пол
setObjectScale(o, 0)
createObject(1556, 280, 1828.3, 7,0,0,90)--Дверь вход LAB 1
createObject(1556, 283.4, 1828.3, 7,0,0,90)--Дверь выход LAB 1








local EsperGTA3 = CreateVehicle(419, -758.5, 500.1, 1373.1, 0, 0, 270, "GTA III", true)
setElementInterior(EsperGTA3, 1)



CreateVehicle(471, -2213.556, 112.7671, 34.9203, 0, 0, 88.472)--KART
CreateVehicle(471, -810.5599, 2430.363, 156.9649, 0, 0, 336.533)
CreateVehicle(471, -1693.441, 432.2852, 6.9914, 0, 0, 300.903)
CreateVehicle(471, -1483.69, 2614.835, 58.2812, 0, 0, 337.9383)
CreateVehicle(471, 2615.317, 1939.701, 10.129, 0, 0, 148.1757)
CreateVehicle(471, 1074.964, 1395.418, 5.303, 0, 0, 36.7673)
CreateVehicle(471, 2615.239, -1731.225, 5.9486, 0, 0, 140.8213)
CreateVehicle(573, 1091.89, 1612.63, 13.0, 0, 0, 206.7583)
CreateVehicle(577, 1901, -2390, 12, 0, 0, 90)
CreateVehicle(539, -2294.926, 2546.978, 5.9175, 0, 0, 290.9339)
CreateVehicle(539, 714.3436, -1488.273, 0.9343, 0, 0, 270.0)
CreateVehicle(539, -1426.412, 506.8391, 2.9463, 0, 0, 144.61)
CreateVehicle(539, 1971.92, 1560.665, 10.9635, 0, 0, 262.615)
CreateVehicle(539, -535.4126, -60.8884, 63.5922, 0, 0, 276.9756)
CreateVehicle(592, 350.6, 2457.8, 17.6, 0, 0, 0)




CreateVehicle(504, -2151.0, -409.1, 35.1, 0, 0, 307.2)
CreateVehicle(471, 1045.5, -302.1, 74, 0, 0, 172)
CreateVehicle(402, 888.4, -25.8, 64.5, 0, 0, 155)
CreateVehicle(605, 200.2, -264.8, 1.3, 0, 0, 186)
CreateVehicle(498, 204, -174.5, 1.1, 0, 0, 34)







tmpv = CreateVehicle(536, 1864.7, -1363.8, 13.3, 0, 0, 180, " BUMBEE", true,1,1)
setVehicleColor(tmpv, 13,193,210)
addVehicleUpgrade(tmpv, 1107)
addVehicleUpgrade(tmpv, 1181)
addVehicleUpgrade(tmpv, 1183)



-- veh, x,y,z,rz
local Parkings = { -- Доработать потом, добавить спауны взорванных не припаркованных тачек, призовые тачки тоже сюда парковать
	["Los Santos"] = {
		["LS North Parking"] = {
			[1] = {false, 306.9, -1481.8, 23.6, 235},
			[2] = {false, 303.9, -1486.5, 23.6, 235},
			[3] = {false, 300.9, -1491.1, 23.6, 235},
			[4] = {false, 297.7, -1535.9, 23.6, 55},
			[5] = {false, 294.3, -1540, 23.6, 55},
			[6] = {false, 291.1, -1544.6, 23.6, 55},
			[7] = {false, 279, -1536, 23.6, 235},
			[8] = {false, 282.1, -1531.6, 23.6, 235},
			[9] = {false, 285.6, -1527.3, 23.6, 235},
			[10] = {false, 288.8, -1522.7, 23.6, 235},
			[11] = {false, 291.7, -1518.2, 23.6, 235},
			[12] = {false, 295.1, -1513.9, 23.6, 235},
			[13] = {false, 298.3, -1509.3, 23.6, 235},
			[14] = {false, 301.4, -1504.8, 23.6, 235},
			[15] = {false, 304.2, -1500.4, 23.6, 235},
		},
		["LS West Parking"] = {
			[1] = {false, 2454.2, 1327.3, 9.8, 0},
			[2] = {false, 2451, 1327.5, 9.8, 0},
			[3] = {false, 2447.8, 1327.5, 9.8, 0},

			[4] = {false, 2452.1, 1336.4, 9.8, 0},
			[5] = {false, 2455.3, 1336.4, 9.8, 0},
			[6] = {false, 2458.5, 1336.4, 9.8, 0},
			[7] = {false, 2461.7, 1336.4, 9.8, 0},
			[8] = {false, 2464.9, 1336.4, 9.8, 0},

			[9] = {false, 2452.1, 1345.7, 9.8, 0},
			[10] = {false, 2455.3, 1345.7, 9.8, 0},
			[11] = {false, 2458.5, 1345.7, 9.8, 0},
			[12] = {false, 2461.7, 1345.7, 9.8, 0},
			[13] = {false, 2464.9, 1345.7, 9.8, 0},

			[14] = {false, 2452.1, 1357.6, 9.8, 0},
			[15] = {false, 2455.3, 1357.6, 9.8, 0},
			[16] = {false, 2458.5, 1357.6, 9.8, 0},
			[17] = {false, 2461.7, 1357.6, 9.8, 0},
			[18] = {false, 2464.9, 1357.6, 9.8, 0},
			[19] = {false, 2468.1, 1357.6, 9.8, 0},
			[20] = {false, 2471.3, 1357.6, 9.8, 0},
			[21] = {false, 2474.5, 1357.6, 9.8, 0},

			[22] = {false, 2441.5, 1332.6, 9.8, 90},
			[23] = {false, 2441.5, 1335.9, 9.8, 90},
			[24] = {false, 2441.5, 1339, 9.8, 90},
			[25] = {false, 2441.5, 1342.3, 9.8, 90},
			[26] = {false, 2441.5, 1345.5, 9.8, 90},
			[27] = {false, 2441.5, 1348.6, 9.8, 90},
			[28] = {false, 2441.5, 1351.8, 9.8, 90},
			[29] = {false, 2441.5, 1355.1, 9.8, 90},
		}
	},
	["San Fierro"] = {
		["SF West Parking"] = {
			[1] = {false, -1835.4, 1288, 30.9, 21},
			[2] = {false, -1829.6, 1289.5, 30.9, 21},
			[3] = {false, -1824, 1291.6, 30.9, 21},
			[4] = {false, -1817.1, 1293.6, 30.9, 2},
			[5] = {false, -1811.2, 1293.5, 30.9, 2},
			[6] = {false, -1804.7, 1294, 30.9, 357},
			[7] = {false, -1799, 1293.5, 30.9, 357},
			[8] = {false, -1793.1, 1292.9, 30.9, 357},
			[9] = {false, -1779.4, 1310.6, 30.9, 177},
			[10] = {false, -1785.2, 1311.4, 30.9, 177},
			[11] = {false, -1791.1, 1311.5, 30.9, 177},
			[12] = {false, -1797, 1312.1, 30.9, 177},
			[14] = {false, -1802.9, 1312.5, 30.9, 186},
			[15] = {false, -1810.6, 1311.9, 30.9, 186},
			[16] = {false, -1816.3, 1311.3, 30.9, 186},
			[17] = {false, -1822.1, 1310.7, 30.9, 186},
			[18] = {false, -1831, 1308.8, 30.9, 200},
			[19] = {false, -1836.4, 1307, 30.9, 200},
			[20] = {false, -1842.1, 1304.8, 30.9, 200},
			[21] = {false, -1847.5, 1302.6, 30.9, 200},
			[22] = {false, -1853.2, 1300.5, 30.9, 200},

			[23] = {false, -1835.4, 1288, 40.1, 21},
			[24] = {false, -1829.6, 1289.5, 40.1, 21},
			[25] = {false, -1824, 1291.6, 40.1, 21},
			[26] = {false, -1817.1, 1293.6, 40.1, 2},
			[27] = {false, -1811.2, 1293.5, 40.1, 2},
			[28] = {false, -1804.7, 1294, 40.1, 357},
			[29] = {false, -1799, 1293.5, 40.1, 357},
			[30] = {false, -1793.1, 1292.9, 40.1, 357},
			[31] = {false, -1779.4, 1310.6, 40.1, 177},
			[32] = {false, -1785.2, 1311.4, 40.1, 177},
			[33] = {false, -1791.1, 1311.5, 40.1, 177},
			[34] = {false, -1797, 1312.1, 40.1, 177},
			[35] = {false, -1802.9, 1312.5, 40.1, 186},
			[36] = {false, -1810.6, 1311.9, 40.1, 186},
			[37] = {false, -1816.3, 1311.3, 40.1, 186},
			[38] = {false, -1822.1, 1310.7, 40.1, 186},
			[39] = {false, -1831, 1308.8, 40.1, 200},
			[40] = {false, -1836.4, 1307, 40.1, 200},
			[41] = {false, -1842.1, 1304.8, 40.1, 200},
			[42] = {false, -1847.5, 1302.6, 40.1, 200},
			[43] = {false, -1853.2, 1300.5, 40.1, 200},

			[44] = {false, -1835.4, 1288, 49.4, 21},
			[45] = {false, -1829.6, 1289.5, 49.4, 21},
			[46] = {false, -1824, 1291.6, 49.4, 21},
			[47] = {false, -1817.1, 1293.6, 49.4, 2},
			[48] = {false, -1811.2, 1293.5, 49.4, 2},
			[49] = {false, -1804.7, 1294, 49.4, 357},
			[50] = {false, -1799, 1293.5, 49.4, 357},
			[51] = {false, -1793.1, 1292.9, 49.4, 357},
			[52] = {false, -1779.4, 1310.6, 49.4, 177},
			[53] = {false, -1785.2, 1311.4, 49.4, 177},
			[54] = {false, -1791.1, 1311.5, 49.4, 177},
			[55] = {false, -1797, 1312.1, 49.4, 177},
			[56] = {false, -1802.9, 1312.5, 49.4, 186},
			[57] = {false, -1810.6, 1311.9, 49.4, 186},
			[58] = {false, -1816.3, 1311.3, 49.4, 186},
			[59] = {false, -1822.1, 1310.7, 49.4, 186},
			[60] = {false, -1831, 1308.8, 49.4, 200},
			[61] = {false, -1836.4, 1307, 49.4, 200},
			[62] = {false, -1842.1, 1304.8, 49.4, 200},
			[63] = {false, -1847.5, 1302.6, 49.4, 200},
			[64] = {false, -1853.2, 1300.5, 49.4, 200},

			[65] = {false, -1835.4, 1288, 58.7, 21},
			[66] = {false, -1829.6, 1289.5, 58.7, 21},
			[67] = {false, -1824, 1291.6, 58.7, 21},
			[68] = {false, -1817.1, 1293.6, 58.7, 2},
			[69] = {false, -1811.2, 1293.5, 58.7, 2},
			[70] = {false, -1804.7, 1294, 58.7, 357},
			[71] = {false, -1799, 1293.5, 58.7, 357},
			[72] = {false, -1793.1, 1292.9, 58.7, 357},
			[73] = {false, -1779.4, 1310.6, 58.7, 177},
			[74] = {false, -1785.2, 1311.4, 58.7, 177},
			[75] = {false, -1791.1, 1311.5, 58.7, 177},
			[76] = {false, -1797, 1312.1, 58.7, 177},
			[77] = {false, -1802.9, 1312.5, 58.7, 186},
			[78] = {false, -1810.6, 1311.9, 58.7, 186},
			[79] = {false, -1816.3, 1311.3, 58.7, 186},
			[80] = {false, -1822.1, 1310.7, 58.7, 186},
			[81] = {false, -1831, 1308.8, 58.7, 200},
			[82] = {false, -1836.4, 1307, 58.7, 200},
			[83] = {false, -1842.1, 1304.8, 58.7, 200},
			[84] = {false, -1847.5, 1302.6, 58.7, 200},
			[85] = {false, -1853.2, 1300.5, 58.7, 200},
		},
	}, 
	["Las Venturas"] = {
		["Big Parking"] = {
			[1] = {false, 2351.8, 1405, 9.8, 90}, 
			[2] = {false, 2351.8, 1408.57, 9.8, 90}, 
			[3] = {false, 2351.8, 1412.15, 9.8, 90}, 
			[4] = {false, 2351.8, 1415.72, 9.8, 90}, 
			[5] = {false, 2351.8, 1419.3, 9.8, 90}, 
			
			[6] = {false, 2351.8, 1426.45, 9.8, 90}, 
			[7] = {false, 2351.8, 1430.025, 9.8, 90}, 
			[8] = {false, 2351.8, 1433.6, 9.8, 90}, 
			[9] = {false, 2351.8, 1437.17, 9.8, 90}, 
			[10] = {false, 2351.8, 1440.75, 9.8, 90}, 
			[11] = {false, 2351.8, 1444.35, 9.8, 90}, 
			[12] = {false, 2351.8, 1447.9, 9.8, 90}, 
			[13] = {false, 2351.8, 1451.47, 9.8, 90}, 
			[14] = {false, 2351.8, 1455.04, 9.8, 90}, 
			[15] = {false, 2351.8, 1458.62, 9.8, 90}, 
			[16] = {false, 2351.8, 1462.2, 9.8, 90}, 
			[17] = {false, 2351.8, 1465.77, 9.8, 90}, 
			[18] = {false, 2351.8, 1469.35, 9.8, 90}, 
			[19] = {false, 2351.8, 1472.92, 9.8, 90}, 
			[20] = {false, 2351.8, 1476.5, 9.8, 90}, 
			[21] = {false, 2351.8, 1480.07, 9.8, 90}, 
			
			[22] = {false, 2351.8, 1487.22, 9.8, 90}, 
			[23] = {false, 2351.8, 1490.8, 9.8, 90}, 
			[24] = {false, 2351.8, 1494.37, 9.8, 90}, 
			[25] = {false, 2351.8, 1497.95, 9.8, 90}, 
			[26] = {false, 2351.8, 1501.52, 9.8, 90}, 
			
			
			[27] = {false, 2332.1, 1405, 9.8, 90}, 
			[28] = {false, 2332.1, 1408.57, 9.8, 90}, 
			[29] = {false, 2332.1, 1412.15, 9.8, 90}, 
			[30] = {false, 2332.1, 1415.72, 9.8, 90}, 
			[31] = {false, 2332.1, 1419.3, 9.8, 90}, 
			[32] = {false, 2332.1, 1422.875, 9.8, 90}, 
			[33] = {false, 2332.1, 1426.45, 9.8, 90}, 
			[34] = {false, 2332.1, 1430.025, 9.8, 90}, 
			[35] = {false, 2332.1, 1433.6, 9.8, 90}, 
			[36] = {false, 2332.1, 1437.17, 9.8, 90}, 
			[37] = {false, 2332.1, 1440.75, 9.8, 90}, 
			[38] = {false, 2332.1, 1444.35, 9.8, 90}, 
			[39] = {false, 2332.1, 1447.9, 9.8, 90}, 
			[40] = {false, 2332.1, 1451.47, 9.8, 90}, 
			[41] = {false, 2332.1, 1455.04, 9.8, 90}, 
			[42] = {false, 2332.1, 1458.62, 9.8, 90}, 
			[43] = {false, 2332.1, 1462.2, 9.8, 90}, 
			[44] = {false, 2332.1, 1465.77, 9.8, 90}, 
			[45] = {false, 2332.1, 1469.35, 9.8, 90}, 
			[46] = {false, 2332.1, 1472.92, 9.8, 90}, 
			[47] = {false, 2332.1, 1476.5, 9.8, 90}, 
			[48] = {false, 2332.1, 1480.07, 9.8, 90}, 
			[49] = {false, 2332.1, 1483.64, 9.8, 90}, 
			[50] = {false, 2332.1, 1487.22, 9.8, 90}, 
			[51] = {false, 2332.1, 1490.8, 9.8, 90}, 
			[52] = {false, 2332.1, 1494.37, 9.8, 90}, 
			[53] = {false, 2332.1, 1497.95, 9.8, 90}, 
			[54] = {false, 2332.1, 1501.52, 9.8, 90}, 
			
			[55] = {false, 2302.7, 1405, 9.8, 90}, 
			[56] = {false, 2302.7, 1408.57, 9.8, 90}, 
			[57] = {false, 2302.7, 1412.15, 9.8, 90}, 
			[58] = {false, 2302.7, 1415.72, 9.8, 90}, 
			[59] = {false, 2302.7, 1419.3, 9.8, 90}, 
			[60] = {false, 2302.7, 1422.875, 9.8, 90}, 
			[61] = {false, 2302.7, 1426.45, 9.8, 90}, 
			[62] = {false, 2302.7, 1430.025, 9.8, 90}, 
			[63] = {false, 2302.7, 1433.6, 9.8, 90}, 
			[64] = {false, 2302.7, 1437.17, 9.8, 90}, 
			[65] = {false, 2302.7, 1440.75, 9.8, 90}, 
			[66] = {false, 2302.7, 1444.35, 9.8, 90}, 
			[67] = {false, 2302.7, 1447.9, 9.8, 90}, 
			[68] = {false, 2302.7, 1451.47, 9.8, 90}, 
			[69] = {false, 2302.7, 1455.04, 9.8, 90}, 
			[70] = {false, 2302.7, 1458.62, 9.8, 90}, 
			[71] = {false, 2302.7, 1462.2, 9.8, 90}, 
			[72] = {false, 2302.7, 1465.77, 9.8, 90}, 
			[73] = {false, 2302.7, 1469.35, 9.8, 90}, 
			[74] = {false, 2302.7, 1472.92, 9.8, 90}, 
			[75] = {false, 2302.7, 1476.5, 9.8, 90}, 
			[76] = {false, 2302.7, 1480.07, 9.8, 90}, 
			[77] = {false, 2302.7, 1483.64, 9.8, 90}, 
			[78] = {false, 2302.7, 1487.22, 9.8, 90}, 
			[79] = {false, 2302.7, 1490.8, 9.8, 90}, 
			[80] = {false, 2302.7, 1494.37, 9.8, 90}, 
			[81] = {false, 2302.7, 1497.95, 9.8, 90}, 
			[82] = {false, 2302.7, 1501.52, 9.8, 90}, 
		},
	}, 
}

--[[
for name, dat in pairs(Parkings) do
	for name2, dat2 in pairs(dat) do
		for name3, dat3 in pairs(dat2) do
			local randz = dat3[5]
			if(math.random(0,1) == 1) then
				randz = randz+180
			end
			CreateVehicle(475, dat3[2], dat3[3], dat3[4]+VehicleSystem[475][1], 0, 0, randz)
		end
	end

end--]]




local LibertyVeh = {
	{416, 1054.9, 370.6, 14.9, 0,0,0}, 
	{416, 113.2, 958.9, 16.3, 0,0,0}, 
	{416, -1331.7, 905.3, 58.8, 0,0,90}, 
	{419, 127.4, 958, 16, 0,0,180}, 
	{429, 1148.4, 871.8, 14.6, 0,0,33}, 
	{429, 392.4, 266.4, 15.8, 0,0,90}, 
	{429, 382.9, -501, 18.3, 0,0,180}, 
	{429, -840, 1204.3, 28.4, 0,0,180}, 
	{424, 845.7, 731, 4.7, 0,0,0}, 
	{422, 1261.9, 551.2, 49.8, 0,0,0}, 
	{422, 1056.7, 904.3, 7.4, 0,0,180}, 
	{422, 1130.6, 929.4, 11.1, 0,0,0}, 
	{422, 1375.7, 665.7, 13, 0,0,267}, 
	{438, 1156.8, 270.1, 15.1, 0,0,315}, 
	{419, 921.6, 161.5, 14.7, 0,0,90}, 
	{407, 1021.9, 942.3, 7.7, 0,0,270}, 
	{585, 1198.7, 379.2, 11.8, 0,0,0}, 
	{566, 771.6, 6, 4.8, 0,0,0}, 
	{566, 1341.7, 200.3, 11.6, 0,0,270}, 
	{566, 1139.1, 673.9, 25.9, 0,0,180}, 
	{566, 1143.6, 932.3, 10.7, 0,0,0}, 
	{566, 897.5, 962.6, 7.2, 0,0,90}, 
	{403, 813, 3.5, 5.6, 0,0,90}, 
	{403, 1282.3, -26.7, 12.5, 0,0,0}, 
	{426, 1327.6, 822, 50.3, 0,0,151}, 
	{426, 1325.2, 843.9, 52.9, 0,0,265}, 
	{426, 1200.1, 692.6, 39.6, 0,0,270},
	{418, 789.3, 16.3, 5.1, 0,0,90},
	{418, 1124.1, 741.6, 25, 0,0,270},
	{418, 888.6, 942.6, 7.4, 0,0,270}, 
	{423, 781.1, 334.4, 15, 0,0, 270}, 
	{414, 1322.9, 209.1, 11.9, 0,0,270}, 
	{414, 1410.7, 189.3, 11.9, 0,0,180}, 
	{470, 1212.4, 357, 12.2, 0,0,0}, 
	{404, 1033.8, 230.3, 14.5, 0,0,180}, 
	{404,  887.9, 587.6, 14.7, 0,0,0}, 
	{404, 1144.2, 903, 13.5, 0,0,0}, 
	{404, 1340.4, 213, 11.5, 0,0,90}, 
	{413, 1140.5, 117, 15.1, 0,0,313}, 
	{413, 1282.2, 388.5, 12.4, 0,0,180}, 
	{413, 772.4, 196.8, 15, 0,0,0}, 
	{596, 1054.4, 318.5, 14.7, 0,0,270},
	{596, 1054.4, 346.6, 14.6, 0,0,90}, 
	{440, 1017.2, 14.8, 15, 0,0,270}, 
	{405, 1250.9, 547.8, 49.6, 0,0,270}, 
	{439, 1136.1, 101.7, 15, 0,0,177}, 
	{439, 901.6, 853, 4.8, 0,0,270}, 
	{420, 1253.6, 743.2, 49.4, 0,0,270}, 
	{414, 902.5, -96.8, 13.2, 0,0,0}, 
	{456, 1460.2, 155.6, 12, 0,0,270}, 
	{456, 1490.4, 285.1, 12, 0,0,90}, 
}

for _, v in pairs(LibertyVeh) do
	local veh = CreateVehicle(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
	setElementDimension(veh, 1)
	
	if(v[1] == 426) then
		setVehicleColor(veh, 0,0,0,0,0,0)
	end
end








-- theVehicle, model, x,y,z,rx,ry,rz, plateNumber, {характеристики}, "название"
local NonRandVeh = {
-- San Fierro
	-- Электростанция
	{false, 552, -2520.6, -602.3, 131.6, 0,0,180, "IEL0 228"},

	-- Аэропорт
	{false, 519, -1289.1, -353.9,13.1, 0,0,219},
	{false, 519, -1253.1, -347.9,13.1, 0,0,219},
	{false, 519, -1220.1, -150.9,13.1, 0,0,159},
	{false, 511, -1629.2, -236.1, 13.1,0,0,129},
	{false, 593, -1443, -523.2, 13.1,0,0,267},
	{false, 593, -1363, -484, 13.1,0,0,200},
	{false, 553, -1387.1, -227.9, 13.1,0,0,312},

	-- Пожарные
	{false, 544, -2057, 58, 27.4, 0,0,90, "IFSF 228"},
	{false, 407, -2057, 64, 27.4, 0,0,90, "IFSF 228"},
	{false, 407, -2022.2, 84.3, 27, 0,0,270, "IFSF 228"},

	-- Военные
	{false, 425, -1608.7, 286.1, 6.2,0,0,55},

	-- Полиция
	{false, 497, -1681, 705, 29.6,0,0,90},

	-- Скорая
	{false, 416, -2639, 592.9, 13.5,0,0,270, "MCSF 228"},
	{false, 416, -2677.1, 592.9, 13.5,0,0,270, "MCSF 228"},

	{false, 429, -2273.2, -130.8, 34.3,0,0,270, "__DBP___", false, 1, 1, {79, 0, 0, 0}},
	{false, 556, -1778.2, 1207, 24.1,0,0,92, "__NOS___"},

	{false, 587, -2477.7, 741.2, 34,0,0,0, "IMPEXP__"},
	{false, 518, -1720, 1028.5, 16.6,0,0,90, " FRISCO", false, 1, 1, {19,19,19}},
	{false, 537, -1948, 142.3, 25.7,0,0,325}, -- Поезд
	{false, 449, -2006.6, 154.9, 27.5,0,0,325}, -- Трамвай
	{false, 597, -1575, 718.2, -6.2,0,0,90, "PSF0 228"},
	{false, 597, -1575, 706.2, -6.2,0,0,90, "PSF1 228"},
	{false, 438, -2460.7, -23.8, 31.8,0,0,270, "BORGNINE", false, 1, 1, {30, 30, 30, 30}, {VehicleSystem[504][2], VehicleSystem[504][3], VehicleSystem[504][4], VehicleSystem[504][5], VehicleSystem[504][6], VehicleSystem[504][7]}, "Borgnine"},
	{false, 541, -2354.6, 983.0, 49.7,0,0,190, "_CHUNKY_", false, nil, nil, {24, 40, 0, 0}},
	{false, 434, -2064.4, -83.7, 34.2,0,0,0, "__GOLD__", false, nil, nil, {15, 15, 0, 0}},


-- Bone County
	--Призывники
	{false, 432, 275, 1990.5, 16.6, 0,0,270, "ARMY 228"},
	{false, 432, 275, 1956.5, 16.6, 0,0,270, "ARMY 228"},
	{false, 432, 275, 2023.5, 16.6, 0,0,270, "ARMY 228"},
	{false, 470, 302, 2050, 16.6, 0,0,180, "ARMY 228"},
	{false, 470, 269, 1937, 16.6, 0,0,270, "ARMY 228"},
	{false, 470, 158.5, 1843.5, 16.6, 0,0,0, "ARMY 228"},
	{false, 470, 226, 1822.6, 16.6, 0,0,180, "ARMY 228"},
	{false, 433, 141.7, 1829.1, 16.6, 0,0,90, "ARMY 228"},
	{false, 490, 131, 1891.5, 17.4, 0,0,90, "ARMY 228", false, nil, nil, {120, 120, 0, 0}},
	{false, 428, 211.4, 1919.8, 16.6, 0,0,180, "ARMY 228", false, nil, nil, {120, 120, 0, 0}},
	
	
	
	-- Аэропорт
	{false, 476, 325, 2537.1, 15.7,0,0,180},
	{false, 513, 348, 2537.1, 15.7,0,0,180},
	{false, 425, 365.5, 2537.1, 15.7,0,0,180},
	{false, 417, 383.1, 2538.9, 15.7,0,0,180},

	-- Скорая

	{false, 416, -1507.1, 2525.5, 54.7,0,0,0, "MCTR 228"},
	{false, 416, -303.8, 1032.3, 18.6,0,0,268, "MCBC 228"},
	{false, 416, -305, 1020, 18.6,0,0,270, "MCBC 228"},

	-- Полиция
	{false, 598, -1400, 2647, 54.7,0,0,90,"POLICEBC"},
	{false, 599, -1400.5, 2637.6, 54.7,0,0,270, "POLICEBC"},
	{false, 427, -1399.7, 2628.6, 54.7,0,0,272, "_CUFFS__"},
	{false, 598, -1400.5, 2631.6, 54.7,0,0,270, "POLICEBC"},
	{false, 523, -1400, 2644, 54.7,0,0,90,"POLICEBC"},
	{false, 523, -226, 992, 18.7,0,0,270, "POLICETR"},
	{false, 523, -226, 994, 18.7,0,0,270, "POLICETR"},
	{false, 523, -226, 996, 18.7,0,0,270, "POLICETR"},
	{false, 523, -226, 998, 18.7,0,0,270, "POLICETR"},
	{false, 599, -211, 999, 18.7,0,0,90, "POLICETR", false, nil, nil, {29,8,0,0}},
	{false, 596, -211, 995, 18.7,0,0,90, "POLICETR", false, nil, nil, {29,8,0,0}},
	{false, 598, -211, 991, 18.7,0,0,90, "POLICETR", false, nil, nil, {29,8,0,0}},



-- Las Venturas
	-- Пожарные
	{false, 407, 1757.1, 2073.3, 9.8, 0,0,180, "IFLV 228"},
	{false, 407, 1763.6, 2073.3, 9.8, 0,0,180, "IFLV 228"},
	{false, 407, 1770.2, 2073.3, 9.8, 0,0,180, "IFLV 228"},

	-- Мотошкола
	{false, 463, 1174.8, 1364.8, 9.8,0,0,280},
	{false, 521, 1176, 1366.6, 9.8,0,0,282},
	{false, 522, 1174.5, 1368.5, 9.8,0,0,283},

	-- Скорая
	{false, 416, 1612.7, 1839.8, 9.8,0,0,0, "MCLV 228"},
	{false, 416, 1600.1, 1831.2, 9.8,0,0,180, "MCLV 228"},

	{false, 475, 2471.1, 2529.1, 9.8,0,0,0, "MFU  842", false, 1, 1, {10,16,32}},
	{false, 537, 2864.5, 1289.8, 10.8,0,0, 325}, -- Поезд
	{false, 421, 169.8, 1934.4, 17.4,0,0,180, "_OMEGA__", false, nil, nil, {84, 84, 1, 1}},
	{false, 589, 686.6, 1947.6, 4.5,0,0,180, "_SPANK__", false, nil, nil, {126, 1, 1, 1}},
	{false, 568, 1036.3, 2907.4, 45.8,0,0,160, "FULLAUTO"},
	{false, 545, -866.2, 1550.9, 22.5,0,0,270, "HOMEGIRL"},
	{false, 424, 1104.9, 1614.8, 11.5,0,0,86},


	-- Полиция
	{false, 598, 2273.5, 2477.8, 9.8,0,0,180, "POLICELV"},
	{false, 598, 2277.9, 2443.6, 9.8,0,0,180, "POLICELV"},
	{false, 598, 2251.8, 2476.1, 9.8,0,0,0, "POLICELV"},
	{false, 598, 2276.9, 2432.1, 2.3,0,0,0, "POLICELV"},
	{false, 598, 2260, 2432.1, 2.3,0,0,0, "POLICELV"},

	 -- Зона 51
	{false, 520, 307.3, 2031.3, 16.6,0,0,215},
	{false, 520, 308.5, 1990.1, 16.6,0,0,215},

	 -- Bait Shop Bike
	{false, 463, -1350.4, 2054.5, 51.8,0,0,103},
	{false, 468, -1350.3, 2060.2, 51.4,0,0,98},
	{false, 586, -1350.3, 2055.9, 51.7,0,0,278},

	{false, 484, -2227.1, 2445.78, 0,0,0,229},
	{false, 446, -2223.9, 2409.87, 0,0,0,49},
	{false, 493, -2247.8, 2425.67, 0,0,0,220},
	{false, 406, 687.1, 890.7, -40.4,0,0,35},
	{false, 486, 620.9, 861.2, -44,0,0,298},
	{false, 468, 623.3, 887.1, -43.6,0,0,347},

-- Flint County
	-- Ферма
	{false, 532, -376.9, -1449.3, 24.7,0,0,0},
	{false, 478, -366.7, -1437.7, 24.7, 0,0,90, "ILS0 228", false, 3, 3},
	{false, 531, -366.7, -1441.7, 24.7, 0,0,90},
	{false, 610, -363.8, -1410.9, 24.7, 0,0,87},

-- Los Santos
	-- Пожарные
	{false, 407, 1751.5, -1455.1, 12.5, 0,0,263, "IFLS 228"},

	-- Полиция
	{false, 596, 1545.3, -1676.2, 4.9, 0,0,90, "POLICELS"},
	{false, 596, 1574.5, -1710.5, 4.9, 0,0,0, "POLICELS"},
	{false, 601, 1558.8, -1711.5, 4.9, 0,0,0, "POLICELS"},
	{false, 596, 1529, -1688, 4.9, 0,0,270, "POLICELS", false, nil, nil, {1,0,0,0}},
	{false, 596, 1529, -1684, 4.9, 0,0,270, "POLICELS", false, nil, nil, {1,0,0,0}},
	{false, 427, 1545, -1659.1, 4.9, 0,0,90, "POLICELS"},
	{false, 427, 1587.5, -1710.6, 4.9, 0,0,180, "POLICELS"},
	{false, 497, 1552, -1643.5, 27.4, 0,0,90, "POLICELS"},
	{false, 497, 1552, -1707, 27.4, 0,0,90, "POLICELS"},

	-- SAN NEWS
	{false, 457, 927.7, -1185, 16,0,0,123},
	{false, 457, 927.5, -1182.3, 16,0,0,123},
	{false, 457, 926.9, -1178.9, 16,0,0,123},
	{false, 457, 861.4, -1240.7, 13.8,0,0,180},
	{false, 582, 837.7, -1206.6, 16,0,0,153, "NEWS 228"},
	{false, 582, 897.5, -1208, 16,0,0,87, "NEWS 228"},
	{false, 582, 736.2, -1334.1, 12.5,0,0,268, "NEWS 228"},
	{false, 582, 737, -1343.9, 12.5,0,0,274, "NEWS 228"},
	{false, 488, 741.5, -1339.4, 12.5,0,0,270, "NEWS 228"},

	-- Скорая
	{false, 416, 1177.5, -1308.5, 12.8,0,0,270, "MCLS 228"},
	{false, 416, 1177.5, -1339, 12.8,0,0,270, "MCLS 228"},
	{false, 416, 2033.9, -1432.67, 16.2,0,0,180, "MCLS 228"},

	-- Автобусы
	{false, 431, 1172.8, -1795.5, 12.4,0,0,0},
	{false, 437, 1182, -1795.5, 12.4,0,0,0},

	-- Эвакуаторы
	{false, 525, 1362.5, -1658.8, 12.4,0,0,270, "IEV0 228"},
	{false, 525, 1362.5, -1651, 12.4,0,0,270, "IEV1 228"},
	{false, 525, 1362.5, -1643.5, 12.4,0,0,270, "IEV2 228"},
	{false, 525, 1375.4, -1634.1, 12.4,0,0,180, "IEV3 228"},


	{false, 481, 2412.52, -1326.49, 23.7,0,0,177},
	{false, 588, -492.174, 292.808, 1.4,0,0,90},
	{false, 473, -529.6, 313.3, 1.1,0,0,180},
	{false, 600, 2473.53, -1690.2, 12.5,0,0,0, "_SHERM__", false, nil, nil, {84, 84, 84, 84}},
	{false, 537, 1738, -1953, 13.5,0,0,325}, -- Поезд
	{false, 467, 2658, -1696.8, 8.3,0,0,90, nil, false, nil, nil, {3,1,0,0}},
	{false, 444, 2692, -1674, 8.4,0,0,180},
	{false, 494, 2676.7, -1673.7,8.4,0,0,180},
	{false, 567, 1802.8, -2116.6,13.4,0,0,270, " VLA4L", false, nil, nil, {3,3,3,3}},
	{false, 468, -1460.8, -1566.7, 100.8,0,0,2},
	{false, 478, -1446.2, -1494.7, 100.8,0,0,6},
	{false, 531, -1439.6, -1576.8, 100.8,0,0,264},
	{false, 442, 931.2, -1081.9, 23.3,0,0,180},

-- Red County
	{false, 604, -472.8, -179.2, 77.2, 0,0,0}, 

	{false, 431, 658.8, -452.8, 15.3, 0, 0, 90}, -- Автобус
	
	-- Ферма
	{false, 532, -104.6, -22.2, 2.1,0,0,70},
	{false, 531, -126.8, -77.7, 2.1, 0,0,11}, 
	{false, 610, -126.1, -81.7, 2.1, 0,0,11}, 
	{false, 531, -22.5, 95.4, 2.1, 0,0,90}, 
	{false, 610, -19.7, 95.5, 2.1, 0,0,90}, 
	
	-- Ферма 2
	{false, 532, 1995.1, 228.3, 26.3,0,0,85},

	-- Полиция
	{false, 599, -2166, -2390, 29.6,0,0,50},

	-- Скорая
	{false, 416, 1229.6, 297.7, 18.6,0,0,155, "MCMG 228"},
	{false, 416, -2202.5, -2316, 29.6,0,0,319, "MCAP 228"},

	{false, 578, -1969.8, -2437.9, 29.6,0,0,278},
	{false, 515, -2000.2, -2415.5, 29.6,0,0,228},
	{false, 530, -1969.8, -2443.9, 29.6,0,0,-19},
	{false, 468, -2085.2, -2437.5, 29.6,0,0,142},
	{false, 468, -2408.5, -2186, 32.3,0,0,322},
	{false, 510, -2407.6, -2177, 32.3,0,0,322},
	{false, 500, -2406.2, -2180.8, 32.3,0,0,180},
	{false, 600, 1408.6, 458.6, 19.2,0,0,130},
	{false, 605, 1380.7, 476.6, 19,0,0,244},
	{false, 509, 1391.8, 464.1, 19.2,0,0,144},
	{false, 422, 1544.3, 38.4, 23.1,0,0,250, "COKA 228", false, 2, 2},
	{false, 600, 1545.5, 16.8, 23.1,0,0,278, "COKA 228", false, 2, 2},
	{false, 440, 1587, 39, 23.9,0,0,100, "COKA 228", false, 1, 1},
	{false, 543, 1550, 7, 22.7,0,0,300, "COKA 228", false, 4, 4},
	{false, 440, 1346, 286.6, 18.6,0,0,65, "ILS3 228", false, 1, 1, {86,0,0,0}},
	{false, 442, 2241.2, -48.7,26.2,0,0,90, "_TRAUMA_"}
}




local RandVeh = {
	{-529.65, -472, 24.5, 0,0,180},
	{-545, -487.5, 24.5, 0,0,0},
	{-2426, 518.6, 28.9, 0,0,41},
	{879.2, -1658.1, 12.5,0,0,180},
	{2103.2, 2072.6, 9.8,0,0,90},
	{2166.8, 2727.4, 9.8,0,0,270},
	{2167, 2750.9, 9.8,0,0,90},
	{1368.5, 2256.2, 9.8,0,0,270},
	{2080.6, 2468.7, 9.8,0,0,0},
	{2103.2, 2480.4, 9.8,0,0,180},
	{2153.1, 2494.4, 9.8,0,0,270},
	{1529.8, 2818.3, 9.8,0,0,90},
	{1509.3, 2101.5, 9.8,0,0,90},
	{1525.8, 2291.6, 9.8,0,0,0},
	{1502.2, 2258.1, 9.8,0,0,0},
	{1613.3, 2210.5, 9.8,0,0,90},
	{825.1, -1331.2, 12.4,0,0,270},
	{-1567.3, -2735.4, 47.5,0,0,325},
	{-1994.1, 146.5, 26.5,0,0,180},
	{-1994.1, 163.5, 26.5,0,0,180},
	{-2656.8, -55.4, 3.3,0,0,0},
	{-2682.9, -22.4, 3.3,0,0,180},
	{2453.9, 1990.8, 9.8,0,0,180},
	{2534.3, 2021, 9.8,0,0,90},
	{2511, 936.6, 9.8,0,0,180},
	{2534.1, 929.5, 9.8,0,0,90},
	{2460.1, 922, 9.8,0,0,270},
	{1434.1, 2603.4, 9.8,0,0,270},
	{1420.9, 2610.1, 9.8,0,0,90},
	{1705.7, -1530, 12.4,0,0,0},
	{1705.7, -1520, 12.4,0,0,0},
	{1705.7, -1510, 12.4,0,0,0},
	{1696.3, -1510, 12.4,0,0,180},
	{1696.3, -1500, 12.4,0,0,180},
	{1696.3, -1533, 12.4,0,0,180},
	{1365.6, -2323.3, 12.5, 0, 0, 90},
	{1542.9, -2360.7, 12.6, 0, 0, 0},
	{1560.3, -2257.5, 12.5, 0, 0, 270},
	{1400.6, -2262, 12.5, 0, 0, 180},
	{1508.8, -2212.1, 12.5, 0, 0, 0},
	{-2578.8, 626.4, 26.8, 0, 0, 180},
	{-2545.8, 648.9, 26.8, 0, 0, 90},
	{2588, 2063.9, 9.8, 0, 0, 270},
	{2578.2, 1979.4, 9.8, 0, 0, 270},
	{-1675.9, -618.74, 13.86, 0, 0, 256},
	{1290.2, 342.1, 19.5, 0, 0, 245},
	{-1897.3, -948.5, 32.2, 0, 0, 270},
	{-1872.5, -781, 31, 0, 0, 90},
	{-2149.5, -853.9, 31, 0, 0, 270},
	{172.9, -7.4, 1.1, 0, 0, 180},
	{-2124.6, -923.2, 31, 0, 0, 90},
	{-1872.2, -936.7, 31, 0, 0, 90},
	{651.3, 1700.5, 6, 0, 0, 130},
	{-1897.6, -775, 31, 0, 0, 90},
	{186.4, -7.7, 0.6, 0, 0, 0},
	{198, -139.8, 0.6, 0, 0, 0},
	{203.6, -148.7, 0.6, 0, 0, 180},
	{783, 1900.3, 4.8, 0, 0, 90},
	{2172.9, 1788.4, 9.8, 0, 0, 0},
	{211.9, -140.1, 0.6, 0, 0, 0},
	{218.9, -173.3, 0.6, 0, 0, 90},
	{2186.8, 1979.2, 9.8, 0, 0, 90},
	{2188.7, 1856.8, 9.8, 0, 0, 0},
	{2229, 1878.7, 9.8, 0, 0, 180},
	{-1887.5, -833.8, 31, 0, 0, 270},
	{311.1, -46.9, 0.6, 0, 0, 0},
	{315, -46.8, 0.6, 0, 0, 0},
	{695.1, -464, 15.3, 0, 0 , 90},
	{1395.8, 395.9, 18.8, 0, 0, 68},
	{1403.4, 411.8, 18.8, 0, 0, 68},
	{1419.4, 279.8, 18.6, 0, 0, 338},
	{-1.5, -343.5, 4.4, 0, 0, 270},
	{-1.8, -332.8, 4.4, 0, 0, 270},
	{-30.9, -286.8, 4.4, 0, 0, 270},
	{-42.3, -217.1, 4.4, 0, 0, 180},
	{-43.2, -378.3, 4.4, 0, 0, 180},
	{-60.8, -307.2, 4.4, 0, 0, 90},
	{-580.5, -178.7, 77.9, 0, 0, 180},
	{2254.3, -83.9, 25.5, 0, 0, 0},
	{2264.7, -83.8, 25.5, 0, 0, 0},
	{2359.2, -654.5, 127.8, 0, 0, 270},
	{-16.7, -2521.2, 36.4, 0, 0, 210},
	{-2093.9, -83.7, 34.2, 0, 0, 0},
	{-2076.8, -84, 34.2, 0, 0, 0},
	{-2068.7, -83.7, 34.2, 0, 0, 0},
	{2216.9, -1162, 24.7, 0, 0, 270},
	{2229, -1173.8, 24.7, 0, 0, 90},
	{-2118.2, -4.1, 35, 0, 0, 270},
	{2596.7, 1444.2, 9.8, 0, 0, 178},
	{-1673.9, 439, 6.2, 0, 0, 136},
	{-2516.6, 1228.9, 36.4, 0, 0, 211},
	{1122.3, -1699.8, 12.5, 0, 0, 270},
	{-1006.4, -628.2, 31, 0, 0, 270},
	{-112.4, -41.82, 3.26, 0, 0, 160},
	{-2456.1, 741.65, 34, 0, 0, 180},
	{-1951.8, 2393.8, 50, 0, 0, 292},
	{-2751.9, -281.5, 6, 0, 0, 0},
	{1923.9, -2118.9, 12.6, 0, 0, 0},
	{-2430.2, 320.8, 34.2, 0, 0, 245},
	{-2265.3, 200.6, 34.2, 0, 0, 270},
	{2282.7, 2535.9, 9.8, 0, 0, 180},
	{2133, 1009.75, 9.8, 0, 0, 270},
	{682.2, -1867.5, 4, 0, 0, 180},
	{2163.8, 1810.2, 9.8, 0, 0, 180},
	{2207.43, 1286.13, 10.57, 0, 0, 180},
	{-2338.6, -1593.8, 482.9, 0, 0, 20},
	{-2343.4, -1613.9, 483, 0, 0, 105},
	{-2151.3, -2440.1, 29.8, 0, 0, 324},
	{-2147, -2443.8, 29.6, 0, 0, 324},
	{-2141, -2448.7, 29.6, 0, 0, 144},
	{2788.4, 1295.2, 9.8, 0, 0, 180},
	{2765.2, 1281.6, 9.8, 0, 0, 90},
	{2765.1, 1272, 9.8, 0, 0, 270},
	{2775.6, 1295.4, 9.8, 0, 0, 180},
	{2794.8, 1295.1, 9.8, 0, 0, 0},
	{2785.1, 2436.5, 9.8, 0, 0, 135},
	{2841.2, 2353.3, 9.8, 0, 0, 270},
	{-231.8, 2595.8, 61.7, 0, 0, 0},
	{-216.9, 2595.6, 61.7, 0, 0, 0},
	{-198.3, 2595.2, 61.7, 0, 0, 0},
	{-210, 2609.1, 61.7, 0, 0, 180},
	{-240.1, 2609.3, 61.7, 0, 0, 0},
	{-519.4, 2604.8, 52.4, 0, 0, 90},
	{-508.8, 2618.2, 52.4, 0, 0, 270},
	{-539.5, 2570.7, 52.4, 0, 0, 90},
	{-538.4, 2618.3, 52.4, 0, 0, 90},
	{-743.6, 2751.2, 47.1, 0, 0, 186},
	{-1276.1, 2705.9, 49.8, 0, 0, 30},
	{-1258.2, 2714.4, 50, 0, 0, 210},
	{-1269.9, 2708.5, 50.1, 0, 0, 30},
	{-1197, 1820.6, 40.7, 0, 0, 45},
	{-1200.7, 1817.2, 40.7, 0, 0, 210},
	{-865.9, 1557.4, 24, 0, 0, 90},
	{-865.6, 1569.4, 24.8, 0, 0, 270},
	{-204.2, 1224.2, 18.7, 0, 0, 0},
	{-177.3, 1219.9, 18.7, 0, 0, 270},
	{-177.6, 1225.5, 18.7, 0, 0, 90},
	{-81.9, 1340.3, 9.9, 0, 0, 5},
	{-302.2, 1753.1, 42.7, 0, 0, 90},
	{-290.2, 1772.8, 42.7, 0, 0, 90},
	{-91.6, 1339.3, 9.5, 0, 0, 185},
	{-94.7, 1338.6, 9.4, 0, 0, 0},
	{-80.8, 1078.1, 18.7, 0, 0, 0},
	{-37.7, 1166.3, 18.5, 0, 0, 0},
	{-44.8, 1166.7, 18.5, 0, 0, 0},
	{-86.7, 1221.7, 18.7, 0, 0, 0},
	{-77.3, 1221.2, 18.7, 0, 0, 180},
	{12.6, 1166, 18.6, 0, 0, 0},
	{19.4, 1165.4, 18.6, 0, 0, 0},
	{2.5, 1165.5, 18.6, 0, 0, 180},
	{-289.6, 1312.8, 53.2, 0, 0, 81},
	{-508.3, 2630.4, 52.4, 0, 0, 90},
	{-539, 2583, 52.4, 0, 0, 90},
	{-539.7, 2558.5, 52.4, 0, 0, 270},
	{-520.8, 2564.2, 52.4, 0, 0, 90},
	{-519.7, 2582.3, 52.4, 0, 0, 90},
	{-508.8, 2578, 52.4, 0, 0, 270},
	{667.9, -546.2, 15.3, 0, 0, 90},
	{-36.4, -2497.4, 36.5, 0, 0, 35},
	{1106.2, -1136.9, 22.7, 0, 0, 90},
	{886.6, -1153.1, 22.7, 0, 0, 270},
	{782.7, -1616, 12.4, 0, 0, 270},
	{782.5, -1630.3, 12.4, 0, 0, 90},
	{1939.1, -2086.4, 12.6, 0, 0, 90},
	{2059.2, -1904.4, 12.5, 0, 0, 0},
	{2107, -1363.8, 23, 0, 0, 150},
	{2338.3, -1371.4, 23, 0, 0, 170},
	{1796.9, -1590.3, 12.5, 0, 0, 130},
	{2401.7, -1537.9, 23, 0, 0, 0},
	{2391.5, -1493.8, 22.8, 0, 0, 90},
	{-1938.5, 2390.1, 49.4, 0, 0, 292},
	{-1934.4, 2381, 49.9, 0, 0, 292},
	{-1927.8, 2361.3, 48.9, 0, 0, 113},
	{2132.2, 987.5, 9.7, 0, 0, 0},
	{2132.6, 1019.4, 9.7, 0, 0, 90},
	{2038.5, 1005.8, 9.7, 0, 0, 0},
	{2038.5, 994.7, 9.7, 0, 0, 0},
	{2038.5, 1015.6, 9.7, 0, 0, 0},
	{2229.4, -1353.9, 23, 0, 0, 90},
	{2228.7, -1162.6, 24.7, 0, 0, 90},
	{2206.3, -1169.1, 24.7, 0, 0, 270},
	{2002.4, -1275.6, 22.8, 0, 0, 0},
	{1987.7, -1275, 22.8, 0, 0, 180},
	{1062, -1763.8, 12.4, 0, 0, 90},
	{1098.3, -1760.9, 12.4, 0, 0, 89},
	{-93.2, -1194.8, 1.3, 355, 0, 344},
	{-2265.7, 208.4, 34.2, 0, 0, 90},
	{2076.3, 1402.3, 9.7, 0, 0, 0},
	{2038.5, 1579, 9.7, 0, 0, 180},
	{2361.9, 2079.3, 9.7, 0, 0, 0},
	{1463.7, 2773, 9.7, 0, 0, 0},
	{-896.7, 2005.8, 59.9, 0, 0, 313},
	{-911.5, 2022.3, 59.9, 0, 0, 313},
	{-929.8, 2015.6, 59.9, 0, 0, 130},
	{-1528.3, 2526.5, 54.7, 0, 0, 0},
	{-1519.4, 2526, 54.7, 0, 0, 180}
}

local RandomVehicles = {}
function SpawnAllVehicle()
	SData["PriceAuto"] = {}
	for _, model in pairs(SourceData["PriceAuto"]) do
		if(VehicleSystem[model][9][2] <= ServerDate.year+1900) then
			SData["PriceAuto"][#SData["PriceAuto"]+1] = model
		end
	end


	SData["TeamVehicle"] = {}
	for team, arr in pairs(SourceData["TeamVehicle"]) do
		for region, arr2 in pairs(arr) do
			if(tonumber(region)) then -- Если не указана местность
				local skip = false
				if(VehicleSystem[arr2[1]][9][2] <= ServerDate.year+1900) then
					if(ServerDate.year+1900 == VehicleSystem[arr2[1]][9][2]) then -- Проверка на месяц
						if(VehicleSystem[arr2[1]][9][1] >= ServerDate.month) then
							skip = true
						end
					end

					if(not skip) then
						if(not SData["TeamVehicle"][team]) then SData["TeamVehicle"][team] = {} end
						SData["TeamVehicle"][team][#SData["TeamVehicle"][team]+1] = arr2
					end
				end
			else
				for i, arr3 in pairs(arr2) do
					local skip = false
					if(VehicleSystem[arr3[1]][9][2] <= ServerDate.year+1900) then
						if(ServerDate.year+1900 == VehicleSystem[arr3[1]][9][2]) then -- Проверка на месяц
							if(VehicleSystem[arr3[1]][9][1] >= ServerDate.month) then
								skip = true
							end
						end
						if(not skip) then
							if(not SData["TeamVehicle"][team]) then SData["TeamVehicle"][team] = {} end
							if(not SData["TeamVehicle"][team][region]) then SData["TeamVehicle"][team][region] = {} end
							SData["TeamVehicle"][team][region][#SData["TeamVehicle"][team][region]+1] = arr3
						end
					end
				end
			end
		end
	end


	for _, theVehicle in pairs(RandomVehicles) do
		local occ = false
		for _, thePlayer in pairs(getVehicleOccupants(theVehicle)) do
			if(thePlayer) then
				occ = thePlayer
				break
			end
		end
		if(not occ) then destroyElement(theVehicle) end
	end
	for _,k in pairs(RandVeh) do
		local region = getZoneName(k[1], k[2], k[3], true)
		local vehinfo = SData["TeamVehicle"]["Мирные жители"][region][math.random(#SData["TeamVehicle"]["Мирные жители"][region])]
		RandomVehicles[#RandomVehicles+1] = CreateVehicle(vehinfo[1], k[1], k[2], k[3]+VehicleSystem[vehinfo[1]][1], k[4], k[5], k[6], vehinfo[2], true)

		--if(getElementData(RandomVehicles[#RandomVehicles], "trunk")) then
		--	local arr = fromJSON(getElementData(RandomVehicles[#RandomVehicles], "trunk"))
		--	if(arr[1]) then arr[1] = {"Запаска", 1, math.random(250,550), {}} end
		--	if(arr[2]) then arr[2] = {"Огнетушитель", 1, math.random(250,550), {}} end
		--	setElementData(RandomVehicles[#RandomVehicles], "trunk", toJSON(arr))
		--end
	end


	for _, k in pairs(NonRandVeh) do
		local skip = false
		if(VehicleSystem[k[2]][9][2] <= ServerDate.year+1900) then
			if(ServerDate.year+1900 == VehicleSystem[k[2]][9][2]) then -- Проверка на месяц
				if(VehicleSystem[k[2]][9][1] >= ServerDate.month) then
					skip = true
				end
			end
			if(not skip) then
				if(not k[1]) then
					k[1] = CreateVehicle(k[2], k[3], k[4], k[5]+VehicleSystem[k[2]][1], k[6], k[7], k[8], k[9], k[10], k[11], k[12])
					if(k[13]) then
						setVehicleColor(k[1], unpack(k[13]))
					end
					if(k[14]) then
						UpdateVehicleHandling(k[1], k[14])
					end
					if(k[15]) then
						setElementData(k[1], 'name', k[15])
					end

					--if(getElementData(k[1], "trunk")) then
					--	local arr = fromJSON(getElementData(k[1], "trunk"))
					--	if(arr[1]) then arr[1] = {"Запаска", 1, math.random(250,550), {}} end
					--	if(arr[2]) then arr[2] = {"Огнетушитель", 1, math.random(250,550), {}} end
					--	setElementData(k[1], "trunk", toJSON(arr))
					--end
				end
			end
		end
	end
end




local WARGANGPURE = {
	["Linden Side"] = {{2749, 943, 174, 255}},
	["Las Venturas Airport"] = {{1236, 1203, 221, 680}, {1457, 1203, 320, 680}, {1457, 1143, 320, 60}, {1515, 1586, 214, 128}},
	["Harry Gold Parkway"] = {{1777, 863, 40, 1479}},
	["Los Santos International"] = {{1249, -2394, 603, 215}, {1852, -2394, 237, 215}, {1382, -2730, 819, 336}, {1974, -2394, 115, 138}, {1400, -2669, 789, 72}, {2051, -2597, 101, 203}},
	["Come-A-Lot"] = {{2087, 943, 536, 260}},
	["Juniper Hill"] = {{-2533, 578, 259, 390}},
	["City Hall"] = {{-2867, 277, 274, 181}},
	["Julius Thruway North"] = {{2498, 2542, 187, 84}, {2237, 2542, 261, 121}, {2121, 2508, 116, 155}, {1938, 2508, 183, 116}, {1534, 2433, 314, 150}, {1848, 2478, 90, 75}, {1704, 2342, 144, 91}, {1377, 2433, 157, 74}},
	["Montgomery"] = {{1119, 119, 332, 374}, {1451, 347, 131, 73}},
	["El Corona"] = {{1812, -2179, 158, 327}, {1692, -2179, 120, 337}},
	["Queens"] = {{-2533, 458, 204, 120}, {-2593, 54, 182, 404}, {-2411, 373, 158, 85}},
	["The High Roller"] = {{1817, 1283, 210, 186}},
	["K.A.C.C. Military Fuels"] = {{2498, 2626, 251, 235}},
	["Pilson Intersection"] = {{1098, 2243, 279, 264}},
	["Vinewood"] = {{787, -1310, 165, 180}, {787, -1130, 165, 176}, {647, -1227, 140, 109}, {647, -1416, 140, 189}},
	["Mulholland Intersection"] = {{1463, -1150, 349, 382}},
	["The Emerald Isle"] = {{2011, 2202, 226, 306}},
	["Flint County"] = {{-1213, -2892, 1257, 2124}},
	["El Quebrados"] = {{-1645, 2498, 273, 279}},
	["Tierra Robada"] = {{-2997, 1659, 2517, 1334}, {-1213, 596, 733, 1063}},
	["Linden Station"] = {{2749, 1198, 174, 350}, {2811, 1229, 50, 178}},
	["Little Mexico"] = {{1701, -1842, 111, 120}, {1758, -1722, 54, 145}},
	["San Andreas Sound"] = {{2450, 385, 309, 177}},
	["Conference Center"] = {{1046, -1804, 277, 82}, {1073, -1842, 250, 38}},
	["Roca Escalante"] = {{2237, 2202, 299, 340}, {2536, 2202, 89, 240}},
	["The Camel's Toe"] = {{2087, 1203, 553, 180}},
	["El Castillo del Diablo"] = {{-464, 2217, 256, 363}, {-208, 2123, 322, 214}, {-208, 2337, 216, 150}},
	["Lil' Probe Inn"] = {{-90, 1286, 243, 268}},
	["Martin Bridge"] = {{-222, 293, 100, 183}},
	["Market"] = {{787, -1416, 285, 106}, {952, -1310, 120, 180}, {1072, -1416, 298, 286}, {926, -1577, 444, 161}},
	["Battery Point"] = {{-2741, 1268, 208, 222}},
	["Missionary Hill"] = {{-2994, -811, 816, 381}},
	["The Pink Swan"] = {{1817, 1083, 210, 200}},
	["Easter Tunnel"] = {{-1709, -833, 263, 103}},
	["Red County"] = {{-1213, -768, 4210, 1364}},
	["Commerce"] = {{1323, -1842, 378, 120}, {1323, -1722, 117, 145}, {1370, -1577, 93, 193}, {1463, -1577, 204, 147}, {1583, -1722, 175, 145}, {1667, -1577, 145, 147}},
	["Palomino Creek"] = {{2160, -149, 416, 377}},
	["Blueberry"] = {{104, -220, 245, 372}, {19, -404, 330, 184}},
	["Montgomery Intersection"] = {{1546, 208, 199, 139}, {1582, 347, 82, 54}},
	["Santa Maria Beach"] = {{342, -2173, 305, 489}, {72, -2173, 270, 489}},
	["Las Barrancas"] = {{-926, 1398, 207, 236}},
	["Regular Tom"] = {{-405, 1712, 129, 180}},
	["Shady Creeks"] = {{-1820, -2643, 594, 872}, {-2030, -2174, 210, 403}},
	["Financial"] = {{-1871, 744, 170, 432}},
	["Los Flores"] = {{2581, -1454, 51, 61}, {2581, -1393, 166, 258}},
	["Valle Ocultado"] = {{-936, 2611, 221, 236}},
	["Julius Thruway West"] = {{1197, 1163, 39, 1080}, {1236, 2142, 61, 101}},
	["Jefferson"] = {{1996, -1449, 60, 99}, {2124, -1494, 142, 45}, {2056, -1372, 225, 162}, {2056, -1210, 129, 84}, {2185, -1210, 96, 56}, {2056, -1449, 210, 77}},
	["Hashbury"] = {{-2593, -222, 182, 276}},
	["'The Big Ear'"] = {{-410, 1403, 273, 278}},
	["Back o Beyond"] = {{-1166, -2641, 845, 785}},
	["Los Santos"] = {{44, -2892, 2953, 2124}},
	["Dillimore"] = {{580, -674, 281, 270}},
	["Last Dime Motel"] = {{1823, 596, 174, 227}},
	["Temple"] = {{1252, -1130, 126, 104}, {1252, -1026, 139, 100}, {1252, -926, 105, 16}, {952, -1130, 144, 193}, {1096, -1130, 156, 104}, {1096, -1026, 156, 116}},
	["San Fierro"] = {{-2997, -1115, 1784, 2774}},
	["Rockshore East"] = {{2537, 676, 365, 267}},
	["The Mako Span"] = {{1664, 401, 121, 166}},
	["Hilltop Farm"] = {{967, -450, 209, 233}},
	["Avispa Country Club"] = {{-2646, -355, 376, 133}, {-2831, -430, 185, 208}, {-2361, -417, 91, 62}},
	["The Sherman Dam"] = {{-968, 1929, 487, 226}},
	["Verdant Bluffs"] = {{930, -2488, 319, 482}, {1073, -2006, 176, 164}, {1249, -2179, 443, 337}},
	["Fisher's Lagoon"] = {{1916, -233, 215, 246}},
	["Pirates in Men's Pants"] = {{1817, 1469, 210, 234}},
	["Ocean Flats"] = {{-2994, 277, 127, 181}, {-2994, -222, 401, 499}, {-2994, -430, 163, 208}},
	["Starfish Casino"] = {{2437, 1783, 248, 229}, {2437, 1858, 58, 112}, {2162, 1883, 275, 129}},
	["Cranberry Station"] = {{-2007, 56, 85, 168}},
	["Hankypanky Point"] = {{2576, 62, 183, 323}},
	["The Clown's Pocket"] = {{2162, 1783, 275, 100}},
	["Doherty"] = {{-2270, -324, 476, 102}, {-2173, -222, 379, 487}},
	["Esplanade North"] = {{-2533, 1358, 537, 143}, {-1996, 1358, 472, 234}, {-1982, 1274, 458, 84}},
	["North Rock"] = {{2285, -768, 485, 499}},
	["Bayside Marina"] = {{-2353, 2275, 200, 200}},
	["The Four Dragons Casino"] = {{1817, 863, 210, 220}},
	["Julius Thruway South"] = {{1457, 823, 920, 40}, {2377, 788, 160, 109}},
	["Playa del Seville"] = {{2703, -2126, 256, 274}},
	["Calton Heights"] = {{-2274, 744, 292, 614}},
	["The Strip"] = {{2027, 863, 60, 840}, {2106, 1863, 56, 339}, {2027, 1783, 135, 80}, {2027, 1703, 110, 80}},
	["Beacon Hill"] = {{-399, -1075, 80, 98}},
	["Yellow Bell Golf Course"] = {{1117, 2723, 340, 140}, {1457, 2723, 77, 140}},
	["Verona Beach"] = {{647, -2173, 283, 369}, {930, -2006, 143, 202}, {851, -1804, 195, 227}, {1161, -1722, 162, 145}, {1046, -1722, 115, 145}},
	["King's"] = {{-2329, 458, 336, 120}, {-2411, 265, 418, 108}, {-2253, 373, 260, 85}},
	["Garver Bridge"] = {{-1339, 828, 126, 229}, {-1213, 950, 126, 228}, {-1499, 696, 160, 229}},
	["Easter Basin"] = {{-1794, 249, 552, 329}, {-1794, -50, 295, 299}},
	["LVA Freight Depot"] = {{1457, 863, 320, 280}, {1375, 919, 82, 284}, {1277, 1087, 98, 116}, {1315, 1044, 60, 43}, {1236, 1163, 41, 40}},
	["Mount Chiliad"] = {{-2178, -1771, 242, 521}, {-2997, -1115, 819, 144}, {-2994, -2189, 816, 1074}, {-2178, -2189, 148, 418}},
	["Flint Intersection"] = {{-187, -1596, 204, 320}},
	["Robada Intersection"] = {{-1119, 1178, 257, 173}},
	["Restricted Area"] = {{-91, 1655, 512, 468}},
	["Arco del Oeste"] = {{-901, 2221, 309, 350}},
	["Royal Casino"] = {{2087, 1383, 350, 160}},
	["San Fierro Bay"] = {{-2616, 1501, 620, 158}, {-2616, 1659, 620, 516}},
	["Old Venturas Strip"] = {{2162, 2012, 523, 190}},
	["Randolph Industrial Estate"] = {{1558, 596, 265, 227}},
	["Market Station"] = {{787, -1410, 79, 100}},
	["Willowfield"] = {{1970, -2179, 119, 327}, {2089, -2235, 112, 246}, {2089, -1989, 235, 137}, {2201, -2095, 123, 106}, {2541, -1941, 162, 89}, {2324, -2059, 217, 207}, {2541, -2059, 162, 118}},
	["Palisades"] = {{-2994, 458, 253, 881}},
	["Julius Thruway East"] = {{2623, 943, 126, 112}, {2685, 1055, 64, 1571}, {2536, 2442, 149, 100}, {2625, 2202, 60, 240}},
	["Chinatown"] = {{-2274, 578, 196, 166}},
	["Bayside"] = {{-2741, 2175, 388, 547}},
	["Leafy Hollow"] = {{-1166, -1856, 351, 254}},
	["Sherman Reservoir"] = {{-789, 1659, 190, 270}},
	["Greenglass College"] = {{964, 1044, 233, 159}, {964, 930, 202, 114}},
	["Kincaid Bridge"] = {{-1339, 599, 126, 229}, {-1213, 721, 126, 229}, {-1087, 855, 126, 131}},
	["Spinybed"] = {{2121, 2663, 377, 198}},
	["Prickle Pine"] = {{1534, 2583, 314, 280}, {1117, 2507, 417, 216}, {1848, 2553, 90, 310}, {1938, 2624, 183, 237}},
	["Yellow Bell Station"] = {{1377, 2600, 115, 87}},
	["Flint Range"] = {{-594, -1648, 407, 372}},
	["Blackfield Chapel"] = {{1375, 596, 183, 227}, {1325, 596, 50, 199}},
	["Fern Ridge"] = {{508, -139, 798, 258}},
	["Rockshore West"] = {{1997, 596, 380, 227}, {2377, 596, 160, 192}},
	["Hampton Barns"] = {{603, 264, 158, 102}},
	["Blackfield"] = {{964, 1203, 233, 200}, {964, 1403, 233, 323}},
	["Los Santos Inlet"] = {{-321, -2224, 365, 500}},
	["Bayside Tunnel"] = {{-2290, 2548, 340, 175}},
	["Paradiso"] = {{-2741, 793, 208, 475}},
	["Bone County"] = {{-480, 596, 1349, 2397}},
	["Blackfield Intersection"] = {{1197, 1044, 80, 119}, {1166, 795, 209, 249}, {1277, 1044, 38, 43}, {1375, 823, 82, 96}},
	["Juniper Hollow"] = {{-2533, 968, 259, 390}},
	["Whitewood Estates"] = {{883, 1726, 215, 781}, {1098, 1726, 99, 517}},
	["Foster Valley"] = {{-2270, -430, 92, 106}, {-2178, -599, 384, 275}, {-2178, -1115, 384, 516}, {-2178, -1250, 384, 135}},
	["Garcia"] = {{-2411, -222, 238, 487}, {-2395, -222, 41, 18}},
	["Redsands West"] = {{1236, 1883, 541, 259}, {1297, 2142, 480, 101}, {1377, 2243, 327, 190}, {1704, 2243, 73, 99}},
	["Downtown Los Santos"] = {{1463, -1430, 261, 140}, {1724, -1430, 88, 180}, {1463, -1290, 261, 140}, {1370, -1384, 93, 214}, {1724, -1250, 88, 100}, {1370, -1170, 93, 40}, {1378, -1130, 85, 104}, {1391, -1026, 72, 100}},
	["Redsands East"] = {{1817, 2011, 289, 191}, {1817, 2202, 194, 140}, {1848, 2342, 163, 136}},
	["Fallen Tree"] = {{-792, -698, 340, 318}},
	["Marina"] = {{647, -1804, 204, 227}, {647, -1577, 160, 161}, {807, -1577, 119, 161}},
	["Hunter Quarry"] = {{337, 710, 523, 321}},
	["Esplanade East"] = {{-1620, 1176, 40, 98}, {-1580, 1025, 81, 249}, {-1499, 578, 160, 696}},
	["Gant Bridge"] = {{-2741, 1659, 125, 516}, {-2741, 1490, 125, 169}},
	["Las Brujas"] = {{-365, 2123, 157, 94}},
	["Fort Carson"] = {{-376, 826, 499, 394}},
	["Pilgrim"] = {{2437, 1383, 187, 400}, {2624, 1383, 61, 400}},
	["Richman"] = {{647, -1118, 140, 164}, {647, -954, 121, 94}, {225, -1369, 109, 77}, {225, -1292, 241, 57}, {72, -1404, 153, 169}, {72, -1235, 249, 227}, {321, -1235, 326, 191}, {321, -1044, 326, 184}, {321, -860, 366, 92}, {321, -768, 379, 94}},
	["Sobell Rail Yards"] = {{2749, 1548, 174, 389}},
	["Aldea Malvada"] = {{-1372, 2498, 95, 117}},
	["Angel Pine"] = {{-2324, -2584, 360, 372}},
	["Fallow Bridge"] = {{434, 366, 169, 189}},
	["Idlewood"] = {{1812, -1852, 159, 110}, {1812, -1742, 139, 140}, {1951, -1742, 173, 140}, {1812, -1602, 312, 153}, {2124, -1742, 98, 248}, {1971, -1852, 251, 110}},
	["Glen Park"] = {{1812, -1449, 184, 99}, {1812, -1100, 182, 127}, {1812, -1350, 244, 250}},
	["Caligula's Palace"] = {{2087, 1543, 350, 160}, {2137, 1703, 300, 80}},
	["The Visage"] = {{1817, 1863, 289, 148}, {1817, 1703, 210, 160}},
	["Mulholland"] = {{1414, -768, 253, 316}, {1281, -452, 360, 162}, {1269, -768, 145, 316}, {1357, -926, 106, 158}, {1318, -910, 39, 142}, {1169, -910, 149, 142}, {768, -954, 184, 94}, {687, -860, 224, 92}, {737, -768, 405, 94}, {1096, -910, 73, 142}, {952, -937, 144, 77}, {911, -860, 185, 92}, {861, -674, 295, 74}},
	["East Los Santos"] = {{2421, -1628, 211, 174}, {2222, -1628, 199, 134}, {2266, -1494, 115, 122}, {2381, -1494, 40, 40}, {2281, -1372, 100, 237}, {2381, -1454, 81, 319}, {2462, -1454, 119, 319}},
	["Las Payasadas"] = {{-354, 2580, 221, 236}},
	["Shady Cabin"] = {{-1632, -2263, 31, 32}},
	["Frederick Bridge"] = {{2759, 296, 15, 298}},
	["Octane Springs"] = {{338, 1228, 326, 427}},
	["The Panopticon"] = {{-947, -304, 628, 631}},
	["Rodeo"] = {{72, -1684, 153, 140}, {72, -1544, 153, 140}, {225, -1684, 87, 183}, {225, -1501, 109, 132}, {334, -1501, 88, 95}, {312, -1684, 110, 183}, {422, -1684, 136, 114}, {558, -1684, 89, 300}, {466, -1570, 92, 185}, {422, -1570, 44, 164}, {466, -1385, 181, 150}, {334, -1406, 132, 114}},
	["Whetstone"] = {{-2997, -2892, 1784, 1777}},
	["Flint Water"] = {{-314, -753, 208, 290}},
	["Easter Bay Chemicals"] = {{-1132, -768, 176, 190}, {-1132, -787, 176, 19}},
	["Verdant Meadows"] = {{37, 2337, 398, 340}},
	["Creek"] = {{2749, 1937, 172, 732}},
	["Las Colinas"] = {{1994, -1100, 62, 180}, {2056, -1126, 70, 206}, {2185, -1154, 96, 220}, {2126, -1126, 59, 192}, {2747, -1120, 212, 175}, {2632, -1135, 115, 190}, {2281, -1135, 351, 190}},
	["Santa Flora"] = {{-2741, 458, 208, 335}},
	["Blueberry Acres"] = {{-319, -220, 423, 513}},
	["East Beach"] = {{2632, -1852, 327, 184}, {2632, -1668, 115, 275}, {2747, -1668, 212, 170}, {2747, -1498, 212, 378}},
	["Ganton"] = {{2222, -1852, 410, 130}, {2222, -1722, 410, 94}},
	["Green Palms"] = {{176, 1305, 162, 215}},
	["Pershing Square"] = {{1440, -1722, 143, 145}},
	["The Farm"] = {{-1209, -1317, 301, 530}},
	["Easter Bay Airport"] = {{-1499, -50, 257, 299}, {-1794, -730, 581, 680}, {-1213, -730, 81, 680}, {-1242, -50, 29, 628}, {-1213, -50, 266, 628}, {-1315, -405, 51, 196}, {-1354, -287, 39, 78}, {-1490, -209, 226, 61}},
	["Ocean Docks"] = {{2373, -2697, 436, 367}, {2201, -2418, 123, 323}, {2324, -2302, 379, 157}, {2089, -2394, 112, 159}, {2201, -2730, 123, 312}, {2703, -2302, 256, 176}, {2324, -2145, 379, 86}},
	["Las Venturas"] = {{869, 596, 2128, 2397}},
	["Unity Station"] = {{1692, -1971, 120, 39}},
	["Downtown"] = {{-1982, 744, 111, 530}, {-1871, 1176, 251, 98}, {-1700, 744, 120, 432}, {-1580, 744, 81, 281}, {-2078, 578, 579, 166}, {-1993, 265, 199, 313}},
}



local WARGANG = {}






-- Первая обычная, вторая символ банды, третья грузовая, четвертая большая
local VehicleSpawnPoint = {
	["Avispa Country Club"] = {{-2763.2, -312, 6,0,0,3}}, 
	["Ganton"] = {{2486.5, -1654.9, 12.3, 0, 0, 90}, {2489.9, -1682.9, 12.3, 0, 0, 270}, {2298.8, -1646.1, 13.7, 0, 0, 270}, {2508.2, -1672.5, 12.3, 0, 0, 347}},
	["El Corona"] = {{1803.4, -1931, 12.4, 0, 0, 0}, {1782.2, -1886.1, 12.4, 0, 0, 270}, {1834.9, -1871.3, 12.4, 0, 0, 0}, {1775.5, -1907.9, 12.4, 0, 0, 180}, {1752.8, -1858.9, 12.4, 0, 0, 270}},
	["Willowfield"] = {{2479.5, -1953.9, 12.4,0,0,0}, {2489, -1953.9, 12.4,0,0,0}, {2492.4, -1953.9, 12.4,0,0,0}, {2483, -1944.5, 12.4,0,0,270}, {2495.6, -1953.9, 12.4,0,0,0}, {2502, -1953.9, 12.4,0,0,0}},
	["East Beach"] = {{2772.7, -1615, 9.9, 0, 0, 270}, {2772.7, -1606.5, 9.9, 0, 0, 270}, {2792.8, -1623.5, 9.9, 0, 0, 350}},
	["Chinatown"] = {{-2176, 638, 48.4, 0, 0, 70}, {-2213, 637.5, 48.4, 0, 0, 270}, {-2180, 702, 52.9, 0, 0, 230}, {-2219.4, 608.3, 34.2, 0, 0, 250}},
	["Calton Heights"] = {{-2182.6, 1032.8, 79, 0, 0, 180}, {-2190, 1032.8, 79, 0, 0, 180}, {-2197.8, 996.3, 79, 0, 0, 270}, {-2187.7, 976, 79, 0, 0, 30}, {-2197.8, 1032.8, 79, 0, 0, 180}},
	["Whitewood Estates"] = {{1052, 2080.75, 10.83,  0, 0, 40}, {1042, 2080.75, 10.83,  0, 0, 320}, {1032.9, 2098, 10.4, 0, 0, 270}, {1047, 2080.75, 10.83,  0, 0, 0}},
	["Idlewood"] = {{1925.9, -1788.6, 12.4, 0, 0, 270}},
	["Verdant Bluffs"] = {{1245.5, -2028, 58.8,  0, 0, 270}, {1245.5, -2024, 58.8,  0, 0, 270}, {1246, -2044, 58.8, 0, 0, 270}, {1274.9, -2044.7, 58.8,  0, 0, 90}, {1245.5, -2020, 58.8, 0, 0, 270}},
	["Caligula's Palace"] = {{2160, 1676.6, 9.7, 0, 0, 350}, {2160.2, 1683.5, 9.7, 0, 0, 6}, {2159.6, 1644.7, 10.1, 0, 0, 20}, {2153.4, 1683.6, 9.7, 0, 0, 185}, {2158.8, 1689.7, 9.7,  0, 0, 20}},
	["El Castillo del Diablo"] = {{-26, 2347, 23.1, 0, 0, 180}, {-12, 2343, 23.1, 0, 0, 90}, {-40, 2344, 23.1, 0, 0, 230}, {-34, 2325, 23.1, 0, 0, 120}},
	["King's"] = {{-2175.8, 293.2, 34.1, 0, 0, 0}, {-2222.6, 306.2, 34.1, 0, 0, 180}},
	["The High Roller"] = {{1943.4, 1342.7, 8.1, 0, 0, 180}, {1943.4, 1349.4, 8.1, 0, 0, 180}},
	["Santa Maria Beach"] = {{343.7, -1809.6, 3.5, 0, 0, 0}},
	["Little Mexico"] = {{1809, -1718.2, 12.5, 0, 0 ,0}}
}


local ModificationVehicle = {
	["Engines"] = 1,
	["Turbo"] = 2,
	["Transmission"] = 3,
	["Suspension"] = 4,
	["Brakes"] = 5,
	["Tires"] = 6
}

function UpgradePreload(thePlayer, name, upgr)
	local comp = fromJSON(PData[thePlayer]["theVehicleTuningHandl"])
	if(upgr and name) then
		local oldpart = comp[ModificationVehicle[upgr]]
		comp[ModificationVehicle[upgr]] = name
		UpdateVehicleHandling(PData[thePlayer]["theVehicleTuning"], comp)
		triggerClientEvent(thePlayer, "UpgradeServerPreload", thePlayer)
		PData[thePlayer]["ShowUpgrade"] = {upgr, name, oldpart}
	else
		UpdateVehicleHandling(PData[thePlayer]["theVehicleTuning"], comp)
	end
end
addEvent("UpgradePreload", true)
addEventHandler("UpgradePreload", root, UpgradePreload)









local hg = createObject(17566, 2783.3, -1245.6, 48, 0,0,90)
setElementData(hg, "house", "h398")
setElementData(hg, "gates", toJSON({2783.3, -1245.6, 50, 0,60,0}))

local hg = createObject(17566, 2805.1, -1245.7, 46.7, 0,0,90)
setElementData(hg, "house", "h399")
setElementData(hg, "gates", toJSON({2805.1, -1245, 48.5, 0,30,0}))

local hg = createObject(17566, 2809.4, -1288.3, 42.2, 0,0,0)
setElementData(hg, "house", "h400")
setElementData(hg, "gates", toJSON({2809.4, -1288.3, 44.2, 0,60,0}))

local hg = createObject(17566, 2809.4, -1310.2, 37.2, 0,0,0)
setElementData(hg, "house", "h401")
setElementData(hg, "gates", toJSON({2809.3, -1310.2, 39.2, 0,60,0}))

local hg = createObject(17566,2809.4, -1332.2, 32.2, 0,0,0)
setElementData(hg, "house", "h402")
setElementData(hg, "gates", toJSON({2809.4, -1332.2, 34.2, 0,60,0}))

local hg = createObject(17566,2783, -1288.5, 42.6, 0,0,0)
setElementData(hg, "house", "h407")
setElementData(hg, "gates", toJSON({2783, -1288.5, 44.6, 0,-60,0}))

local hg = createObject(17566,2783, -1313.7, 37, 0,0,0)
setElementData(hg, "house", "h408")
setElementData(hg, "gates", toJSON({2783, -1313.7, 39, 0,-60,0}))

local hg = createObject(17566,2783, -1340.6, 30.7, 0,0,0)
setElementData(hg, "house", "h409")
setElementData(hg, "gates", toJSON({2783, -1340.6, 32.7, 0,-60,0}))

local hg = createObject(17566,2783, -1365.8, 24.7, 0,0,0)
setElementData(hg, "house", "h410")
setElementData(hg, "gates", toJSON({2783, -1365.8, 26.7, 0,-60,0}))

local hg = createObject(975,263.7, -1332.6, 53.92, 0,-1.7,38)
setElementData(hg, "house", "h280")
setElementData(hg, "gates", toJSON({270, -1327.8, 54.15, 0,0,0}))


local hg = createObject(10184,1535.1, -1451.8, 14.9, 0,0,270)
setElementData(hg, "house", "h544")
setElementData(hg, "gates", toJSON({1535.1, -1451.8, 18.4, 0,0,0}))

local hg = createObject(975,832.5, -866.4, 69.1, 0,0,200)
setElementData(hg, "house", "h56")
setElementData(hg, "gates", toJSON({827, -868.6, 69.1, 0,0,0}))

local hg = createObject(975, 200.4, -1386.5, 49.3, 0,354,46)
setElementData(hg, "house", "h281")
setElementData(hg, "gates", toJSON({206, -1380.7, 50.1, 0,2,0}))

local hg = createObject(988, 284.3, -1318.1, 54, 0,1,216)
setElementData(hg, "house", "h279")
setElementData(hg, "gates", toJSON({287.7, -1315.6, 54, 0,0,0}))

local hg = createObject(988, 279.8, -1321.2, 53.9, 0,1,214)
setElementData(hg, "house", "h279")
setElementData(hg, "gates", toJSON({276, -1323.8, 53.7, 0,0,0}))

local hg = createObject(2990, 321.3, -1188.3, 79.3, 0,359,38)
setElementData(hg, "house", "h261")
setElementData(hg, "gates", toJSON({328, -1183.1, 79.3, 0,0,0}))














local StreetGates = createObject(975, 777.5, -1385.1, 14.4, 0,0,180)
setElementData(StreetGates, "gates", toJSON({770.5, -1385.1, 14.4, 0,0,0}))
setElementData(StreetGates, "team",  toJSON({"Мирные жители"}))



local StreetGates = createObject(975, 777.5, -1330.2, 14.2, 0,0,0)
setElementData(StreetGates, "gates", toJSON({770.5, -1330.2, 14.2, 0,0,0}))
setElementData(StreetGates, "team",  toJSON({"Мирные жители"}))







local PoliceLSGates = createObject(2930, 245.5, 72.5, 1005.2, 0,0,90)
setObjectScale(PoliceLSGates,1.1)
setElementInterior(PoliceLSGates, 6)
setElementDimension(PoliceLSGates, 1)
setElementData(PoliceLSGates, "gates", toJSON({247, 72.5, 1005.2, 0,0,0}))
setElementData(PoliceLSGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

local PoliceLSGates2 = createObject(2930, 248.1, 76.8, 1005.2, 0,0,0)
setObjectScale(PoliceLSGates2,1.1)
setElementInterior(PoliceLSGates2, 6)
setElementDimension(PoliceLSGates2, 1)
setElementData(PoliceLSGates2, "gates", toJSON({248.1, 78.3, 1005.2, 0,0,0}))
setElementData(PoliceLSGates2, "team",  toJSON({"Военные", "Полиция", "ФБР"}))


local ArmourPickup = createPickup(253.9, 79.6, 1003.69, 3, 1275, 0)
setElementData(ArmourPickup, "type", "armour")
setElementInterior(ArmourPickup, 6)
setElementDimension(ArmourPickup, 1)


local StreetGates = createObject(11327, 1587.5, -1638, 14.9, 0,0,90)
setElementData(StreetGates, "gates", toJSON({1587.5, -1638, 17, 0,-60,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))


StreetGates = createObject(968, 1544.7,-1630.8, 13.1, 0,90,90)
setElementData(StreetGates, "gates", toJSON({1544.7,-1630.8, 13.1, 0,-90,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

StreetGates = createObject(968, -1701.43,687.6, 24.7, 0,270,90) -- Police SF
setElementData(StreetGates, "gates", toJSON({-1701.43,687.6, 24.7, 0,90,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

StreetGates = createObject(968, -1572.2,658.8, 6.9, 0,90,90) -- Police SF
setElementData(StreetGates, "gates", toJSON({-1572.2,658.8, 6.9, 0,-90,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

StreetGates = createObject(10184, 2336.7, 2446.5, 7.2, 0,0,330) -- Police LV
setElementData(StreetGates, "gates", toJSON({2336.7, 2446.5, 11.3, 0,0,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

StreetGates = createObject(10184, 2294.1, 2499.6, 4.7, 0,0,0) -- Police LV
setElementData(StreetGates, "gates", toJSON({2294.1, 2499.6, 7.2, 0,0,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))

StreetGates = createObject(968, 2238.2, 2450.4, 10.6, 0,90,90) -- Police LV
setElementData(StreetGates, "gates", toJSON({2238.2, 2450.4, 10.6, 0,-90,0}))
setElementData(StreetGates, "team",  toJSON({"Военные", "Полиция", "ФБР"}))




local CIAGATES = createObject(10149, 233.6, 1822.7, 7.8, 0,0,90)
setElementData(CIAGATES, "gates", toJSON({233.6, 1822.7, 10, 0,0,0}))
setElementData(CIAGATES, "team", toJSON({"ЦРУ"}))



local Zone51GateMCHS = createObject(975, 245.8, 1842.1, 9, 0,0,0)
setElementData(Zone51GateMCHS, "gates", toJSON({244, 1842.1, 9, 0,0,0}))
setElementData(Zone51GateMCHS, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

local Zone51GateMCHS2 = createObject(975, 256, 1845.2, 9, 0,0,90)
setElementData(Zone51GateMCHS2, "gates", toJSON({256, 1839, 9, 0,0,0}))
setElementData(Zone51GateMCHS2, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))


local CrackDoor1 = createObject(18553,2522.5, -1301.9, 1048.5)
setElementInterior(CrackDoor1,2)
local CrackDoor2 = createObject(18553,2571.2, -1301.9, 1044.3)
setElementInterior(CrackDoor2,2)

local LainOS = createPickup(213.9, 1827.5, 6.41, 3, 1239, 0)
setElementData(LainOS, "type", "function")
setElementData(LainOS, "funcname", "StartLainOS")
setElementData(LainOS, "funcinfo", "Управление "..COLOR["TEXT"]["HEX"].."компьютером#FFFFFF")



local MakeSpirt = createPickup(276.4, 1854, 8.8, 3, 1239, 0)
setElementData(MakeSpirt, "type", "function")
setElementData(MakeSpirt, "funcname", "CreateSpirt")
setElementData(MakeSpirt, "funcinfo", "Дистиллятор фекалий")






function SetPlayerPosition(thePlayer,x,y,z,i,d,rz,anim,name)
	if(anim) then
		local Speed = 1000
		if(getControlState(thePlayer, "sprint")) then
			StartAnimation(thePlayer, "POLICE","Door_Kick",false,false,false,false)
			Speed = 700
		else
			PData[thePlayer]["TPTimer"] = setTimer(function() StartAnimation(thePlayer, "ped","Walk_DoorPartial",false,false,false,false)	end, 200, 1)
		end
		if(name) then
			triggerClientEvent(thePlayer, "SetZoneDisplay", thePlayer, name)
		end
		triggerClientEvent(thePlayer, "FadeIn", thePlayer, Speed)
		UnBindAllKey(thePlayer)
		PData[thePlayer]["TPTimer"] = setTimer(function()
			triggerClientEvent(thePlayer, "FadeOut", thePlayer, Speed)
			BindAllKey(thePlayer)
			triggerClientEvent(thePlayer, "ChangeInfo", thePlayer)
			setElementPosition(thePlayer,x,y,z)
			if(rz) then setElementRotation(thePlayer, 0,0,rz,"default",true) end--asd
			if(i and d) then
				setElementDimension(thePlayer, d)
				setElementInterior(thePlayer, i)
				local attachedElements = getAttachedElements(thePlayer)
				for ElementKey, ElementValue in ipairs(attachedElements) do
					setElementPosition(ElementValue,x,y,z)
					setElementDimension(ElementValue, d)
					setElementInterior(ElementValue, i)
				end
			end
		end, Speed, 1)
	else
		if(name) then
			triggerClientEvent(thePlayer, "SetZoneDisplay", thePlayer, name)
		end
		triggerClientEvent(thePlayer, "ChangeInfo", thePlayer)
		setElementPosition(thePlayer,x,y,z)
		if(rz) then setElementRotation(thePlayer, 0,0,rz,"default",true) end
		if(i and d) then
			setElementDimension(thePlayer, d)
			setElementInterior(thePlayer, i)
			local attachedElements = getAttachedElements(thePlayer)
			for ElementKey, ElementValue in ipairs(attachedElements) do
				setElementPosition(ElementValue,x,y,z)
				setElementDimension(ElementValue, d)
				setElementInterior(ElementValue, i)
			end
		end
	end
end


function GetPlayerLocation(thePlayer)
	if(getElementInterior(thePlayer) == 0) then
		return getElementPosition(thePlayer)
	else
		if(PlayersEnteredPickup[thePlayer]) then
			return getElementPosition(PlayersEnteredPickup[thePlayer])
		else
			return getElementPosition(thePlayer)
		end
	end
end





local zone = {}

-- x,y,z,rz,curi,curd,types,x2,y2,z2,rz2,i,d,Название локации, Информация о локации на клиенте
function CreateEnter(x,y,z,rz,curi,curd,types,x2,y2,z2,rz2,i,d,name,clientside)
	local exitpic = false
	local pic = false
	if(x2) then
		exitpic = createMarker(x2, y2, z2+0.9, "arrow", 1.5, 255, 255, 0, 170)
		setElementData(exitpic, "type", "exit", false)
		setElementData(exitpic, "x", x, false)
		setElementData(exitpic, "y", y, false)
		setElementData(exitpic, "z", z, false)
		setElementData(exitpic, "rz", rz, false)
		setElementData(exitpic, "i", curi, false)
		setElementData(exitpic, "d", curd, false)
		setElementInterior(exitpic, i)
		setElementDimension(exitpic, d)
	end

	if(types) then
		if(types[1] == "clinic") then
			pic = createMarker(x, y, z+0.9, "arrow", 1.5, 255, 255, 0, 170)
			setElementData(pic, "text", "Клиника #CC99EE"..getZoneName(x,y,z, true).."#FFFFFF идет прием спермы #A0A0A0/wank#FFFFFF", false)
		elseif(types[1] == "24/7") then
			pic = createMarker(x, y, z+0.9, "arrow", 1.5, 255, 255, 0, 170)
		elseif(types[1] == "house") then
			if(types[3] == "") then
				pic = createPickup(x, y, z, 3, 1273, 0)
			else
				pic = createMarker(x, y, z+0.9, "arrow", 1.5, 255, 255, 0, 170)
			end
			if(not zone[getZoneName(x,y,z)]) then
				zone[getZoneName(x,y,z)] = 1
			else
				zone[getZoneName(x,y,z)] = zone[getZoneName(x,y,z)]+1
			end
			setElementData(pic, "zone", zone[getZoneName(x,y,z)])
			setElementData(pic, "price", types[4], false)
			setElementData(pic, "house", types[2]) --Для GPS
			setElementData(pic, "owner", types[3]) --Для GPS
			setElementData(pic, "locked", types[5], false)
			setElementID(pic, types[2])
		elseif(types[1] == "garage") then
			pic = createPickup(x, y, z, 3, 1277, 0)
			if(not zone[getZoneName(x,y,z)]) then
				zone[getZoneName(x,y,z)] = 1
			else
				zone[getZoneName(x,y,z)] = zone[getZoneName(x,y,z)]+1
			end
			setElementData(pic, "zone", zone[getZoneName(x,y,z)])
			setElementData(pic, "price", types[4], false)
			setElementData(pic, "house", types[2]) --Для GPS
			setElementData(pic, "owner", types[3]) --Для GPS
			setElementData(pic, "locked", types[5], false)
			setElementID(pic, types[2])
		end
	end
	if(not pic) then pic = createMarker(x, y, z+0.9, "arrow", 1.5, 255, 255, 0, 170) end
	setElementData(pic, "type", "enter", false)
	setElementData(pic, "x", x2, false)
	setElementData(pic, "y", y2, false)
	setElementData(pic, "z", z2, false)
	setElementData(pic, "rz", rz2, false)
	setElementData(pic, "i", i, false)
	setElementData(pic, "d", d, false)
	setElementData(pic, "name", name, clientside)
	setElementInterior(pic, curi)
	setElementDimension(pic, curd)
end










local InteriorsClass = {
	["Трейлер"] = {
		"Angel Pine Trailer"
	},
	["Маленькая комната"] = {
		"Millie's Bedroom",
		"Denise's Place",
		"Katie's Place",
		"Big bear apartament",
		"Abandonded AC Woter",
		"Safe House 4",
		"Safe House 10",
		"BDups Crack Palace",
		"OG Loc's House",
	},
	["Дом 1 этаж (бедный)"] = {
		"The Crack Den",
		"Burglary House 1",
		"Unknown safe house",
		"Burglary House 18",
	},
	["Дом 1 этаж (нормальный)"] = {
		"Wu Zi Mu's Betting place",
		"Burglary House 21",
		"Burglary House 20",
		"Burglary House 19",
		"Budget Inn Motel Room",
		"Safe House 12",
		"Safe House 3",
		"Burglary House 16",
		"Safe House 6",
		"Burglary House 22",
		"Sweet's House",
		"Ryder House",
		"Burglary House 2",
		"Burglary House 8",
		"Burglary House 9",
		"Burglary House 13",
		"Burglary House 7",
	},
	["Дом 1 этаж (богатый)"] = {
		"Safe House 11",
		"Safe House 14",
		"Safe House 228",
		"Safe House 5",
		"Burglary House 3",
	},
	["Дом 2 этажа (бедный)"] = {
		"Michelle's Place", 
		"Helena's Place", 
	},
	["Дом 2 этажа (нормальный)"] = {
		"Johnson House",
		"Colonel Fuhrberger's House",
		"Burglary House 6",
		"Burglary House 14",
		"Burglary House 12",
		"Burglary House 4",
		"Burglary House 5",
		"Burglary House 10",
	},
	["Дом 2 этаж (богатый)"] = {
		"Burglary House 11",
		"Safe House 18",
		"Burglary House 15",
		"Modern safe house"
		--"Burglary House 17" --Забагованный
	},
	["Особые (связанные с историей)"] = {
		"Mad Doggs Manson 2",
		"Burning Desire House",
		"Jeffeson Motel",
		"Big Smoke's Crack Palace"
	}
}




local Tags = {
	["Glen Park"] = {
		[1] = {false, 1974.1, -1351.2, 24.6, 90},
		[2] = {false, 1969.6, -1289.7, 24.6, 0},
		[3] = {false, 1967, -1174.8, 20, 90},
		[4] = {false, 1911.9, -1064.4, 25.2, 180},
	},
	["Vinewood"] = {
		[1] = {false, 944.3, -985.8, 39.3, 280},
	},
	["East Los Santos"] = {
		[1] = {false, 2536.2, -1352.8, 31.1, 180},
		[2] = {false, 2580.9, -1274.1, 46.6, 0},
		[3] = {false, 2542.9, -1363.3, 31.8, 0},
		[4] = {false, 2462.4, -1541.5, 25.4, 90},
		[5] = {false, 2522.4, -1478.7, 24.2, 0},
		[6] = {false, 2346.5, -1350.8, 24.3, 90},
		[7] = {false, 2322.4, -1254.4, 22.9, 180},
		[8] = {false, 2576.8, -1143.3, 48.2, 90},
		[9] = {false, 2399.4, -1552, 28.8, 270},
		[10] = {false, 2353.5, -1508.2, 24.8, 0},
		[11] = {false, 2394.1, -1468.2, 24.8, 90},
	},
	["Los Flores"] = {
		[1] = {false, 2612.9, -1390.8, 35.4, 90},
		[2] = {false, 2603.2, -1197.8, 61, 270},
	},
	["Mulholland Intersection"] = {
		[1] = {false, 1732.7, -963, 41.4, 6},
		[2] = {false, 1519.5, -1010.9, 24.6, 180},
	},
	["Idlewood"] = {
		[1] = {false, 2066.4, -1652.6, 14.3, 180},
		[2] = {false, 1837.7, -1640.4, 13.8, 0},
		[3] = {false, 1959.5, -1577.8, 13.8, 134},
		[4] = {false, 2074.2, -1579.2, 14.1, 0},
		[5] = {false, 2102.2, -1648.7, 13.6, 0},
		[6] = {false, 2046.4, -1635.8, 13.6, 0},
		[7] = {false, 2162.8, -1786.1, 14.2, 90},
		[8] = {false, 2034.4, -1801.7, 14.6, 90},
		[9] = {false, 1910.1, -1779.7, 18.8, 270},
		[10] = {false, 1837.2, -1814.2, 4.3, 257},
	},
	["Jefferson"] = {
		[1] = {false, 2182.2, -1467.9, 25.6, 270},
		[2] = {false, 2132.2, -1258.1, 24.1, 90},
		[3] = {false, 2234, -1367.6, 24.5, 180},
		[4] = {false, 2224.8, -1193.1, 25.8, 90},
		[5] = {false, 2119.2, -1196.6, 24.6, 270},
		[6] = {false, 2093.7, -1413.5, 24.1, 90},
	},
	["Las Colinas"] = {
		[1] = {false, 2621.5, -1092.2, 69.8, 90},
		[2] = {false, 2797.9, -1097.7, 31.1, 270},
		[3] = {false, 2281.5, -1119, 27, 180},
		[4] = {false, 2239.8, -999.8, 59.8, 232},
		[5] = {false, 2122.7, -1060.9, 25.4, 329},
		[6] = {false, 2062.7, -996.5, 48.3, 345},
		[7] = {false, 2076.7, -1071.1, 27.6, 322},
	},
	["Rodeo"] = {
		[1] = {false, 583.4, -1502.1, 16, 180},
		[2] = {false, 467, -1283.1, 16.3, 36},
	},
	["Santa Maria Beach"] = {
		[1] = {false, 482.6, -1761.6, 5.9, 90},
		[2] = {false, 399, -2066.9, 11.2, 180},
	},
	["Los Santos International"] = {
		[1] = {false, 1624.6, -2296.3, 14.3, 90},
		[2] = {false, 1574.7, -2691.9, 13.6, 0},
	},
	["Market"] = {
		[1] = {false, 1295.2, -1465.2, 10.2, 270},
		[2] = {false, 947.5, -1466.5, 17.2, 180},
		[3] = {false, 1098.8, -1292.5, 17.1, 0},
		[4] = {false, 1206.3, -1162, 23.9, 180},
	},
	["Commerce"] = {
		[1] = {false, 1448.2, -1755.9, 14.5, 270},
		[2] = {false, 1332.1, -1722.3, 14.1, 90},
	},
	["Downtown Los Santos"] = {
		[1] = {false, 1498.6, -1207.3, 24.7, 270},
		[2] = {false, 1746.8, -1359.6, 16.2, 270},
		[3] = {false, 1687.2, -1239.1, 15.8, 270},
	},
	["Verona Beach"] = {
		[1] = {false, 1271.5, -1662.3, 20.3, 90},
		[2] = {false, 1071.1, -1864.8, 14.1, 0},
	},
	["Little Mexico"] = {
		[1] = {false, 1724.7, -1741.5, 14.1, 270},
		[2] = {false, 1767.2, -1617.5, 15, 250},
		[3] = {false, 1799.2, -1708.8, 14.1, 180},
	},
	["Marina"] = {
		[1] = {false, 810.6, -1797.6, 13.6, 227},
		[2] = {false, 730.4, -1482, 2.3, 90},
	},
	["Willowfield"] = {
		[1] = {false, 2065.4, -1897.2, 13.6, 90},
		[2] = {false, 2392.4, -1914.6, 14.7, 90},
		[3] = {false, 2430.3, -1997.9, 14.7, 90},
		[4] = {false, 2489.2, -1959, 13.7, 270},
		[5] = {false, 2173.6, -2165.2, 15.3, 137},
		[6] = {false, 2134.4, -2011.2, 10.5, 135},
	},
	["Ocean Docks"] = {
		[1] = {false, 2379.3, -2166.2, 24.9, 44},
		[2] = {false, 2273.9, -2265.8, 14.5, 136},
		[3] = {false, 2704.2, -2144.3, 11.8, 180},
		[4] = {false, 2273.2, -2529.1, 8.5, 180},
		[5] = {false, 2587.3, -2063.5, 4.6, 180},
	},
	["Pershing Square"] = {
		[1] = {false, 1549.9, -1714.5, 15.1, 90},
	},
	["El Corona"] = {
		[1] = {false, 1784, -2156.6, 14.3, 90},
		[2] = {false, 1850, -1876.9, 14.4, 90},
		[3] = {false, 1889.2, -1982.5, 15.8, 0},
		[4] = {false, 1936.9, -2134.9, 14.2, 90},
		[5] = {false, 1808.4, -2092.3, 14.2, 180},
		[6] = {false, 1950.7, -2034.4, 14.1, 180},
	},
	["Verdant Bluffs"] = {
		[1] = {false, 1118.9, -2008.2, 75, 123},
	},
	["Playa del Seville"] = {
		[1] = {false, 2763, -2012.1, 14.1, 180},
		[2] = {false, 2794.5, -1906.8, 14.7, 270},
		[3] = {false, 2813, -1942.1, 11.1, 180},
		[4] = {false, 2874.5, -1909.4, 8.4, 180},
		[5] = {false, 2704.2, -1966.7, 13.7, 180},
	},
	["East Beach"] = {
		[1] = {false, 2766.1, -1197.2, 69.1, 180},
		[2] = {false, 2756, -1388.1, 39.5, 0},
		[3] = {false, 2821.2, -1465.1, 16.5, 0},
		[4] = {false, 2767.8, -1621.2, 11.2, 180},
		[5] = {false, 2767.8, -1819.9, 12.2, 113},
		[6] = {false, 2667.9, -1469.1, 31.7, 180},
		[7] = {false, 2841.4, -1313, 18.8, 100},
		[8] = {false, 2820.4, -1191, 25.7, 270},
	},
	["Temple"] = {
		[1] = {false, 1072.9, -1012.8, 35.5, 180},
	},
	["Ganton"] = {
		[1] = {false, 2273, -1687.4, 15, 90},
		[2] = {false, 2422.9, -1682.3, 14, 0},
	},
}



function GetDatabaseZoneNode(zone)
	for i,node in ipairs(xmlNodeGetChildren(ZoneNode)) do
		if(zone == xmlNodeGetValue(node)) then
			return xmlNodeGetAttribute(node, "owner")
		end
	end
end

local TeamTag = {
	["Баллас"] = {1524, 1525, 1529},
	["Колумбийский картель"] = {1524, 1525, 1529},
	["Русская мафия"] =  {1524, 1525, 1529},
	["Вагос"] = {1530},
	["Якудзы"] = {1530},
	["Ацтекас"] = {1531},
	["Гроув-стрит"] = {1528},
	["Триады"] = {1528},
	["Рифа"] = {1526},
	["Полиция"] = {1528},
}





for name, dat in pairs(Tags) do
	for i, v in pairs(dat) do
		local zoneowner = GetDatabaseZoneNode(name)
		if(zoneowner) then
			if(not TeamTag[zoneowner]) then
				zoneowner = "Полиция"
			end
			local model = TeamTag[zoneowner][math.random(#TeamTag[zoneowner])]

			Tags[name][i][1] = createObject(model, v[2],v[3],v[4], 0, 0, v[5])
		end
	end
end










local cs = 96
function tp(thePlayer, command, h)
	if(getServerPort() == 22013) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		cs = cs+1

		--local x,y,z,i,d = tags[cs][1], tags[cs][2], tags[cs][3], 0,0
		--outputChatBox(cs)

		local x,y,z,i,d  = 		1527.229980,-11.574499,1002.097106, 3, 1 -- 8152, -9143, 6.3

		if(theVehicle) then
			SetPlayerPosition(theVehicle, x,y,z,i,d)
		else
			SetPlayerPosition(thePlayer, x,y,z,i,d)
		end
		--SetPlayerPosition(thePlayer, 240.3, 77.7, 1005.2, 6, 1)
	end
end
addCommandHandler("tp", tp)


function StopAnimation(thePlayer, key)
	if(getElementHealth(thePlayer) > 20) then
		setPedAnimation(thePlayer, nil,nil)
	end
end



local ReplaceVehicleAnimation = {
	["smoking"] = {
		["M_smklean_loop"] = {

			["theVehicle"] = {"ped", "Smoke_in_car", false, false, false, false, false}
		}
	},
	["VENDING"] = {
		["VEND_Drink2_P"] = {
			["theVehicle"] = {"VENDING","VEND_Drink2_P", false, false, false, false, false}
		}
	},
	["INT_OFFICE"] = {
		["OFF_Sit_Bored_Loop"] = {["DisableCollision"] = true},
		["OFF_Sit_Read"] = {["DisableCollision"] = true},
		["OFF_Sit_Watch"] = {["DisableCollision"] = true},
		["OFF_Sit_Type_Loop"] = {["DisableCollision"] = true},
		["OFF_Sit_Crash"] = {["DisableCollision"] = true},
	},
	["FOOD"] = {
		["EAT_Vomit_P"] = {
			["theVehicle"] = {false}
		}
	},
	["ped"] = {
		["cower"] = {
			["theVehicle"] = {false}
		}
	}
}

-- Добавить потом blendTime
function StartAnimation(thePlayer, block, anim, times, loop, updatePosition, interruptable, freezeLastFrame, forced)
	if(ReplaceVehicleAnimation[block]) then
		if(ReplaceVehicleAnimation[block][anim]) then
			if(ReplaceVehicleAnimation[block][anim]["DisableCollision"]) then
				setElementCollisionsEnabled(thePlayer, false)
			end
			if(ReplaceVehicleAnimation[block][anim]["theVehicle"]) then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				if(theVehicle) then
					if(ReplaceVehicleAnimation[block][anim]["theVehicle"][1]) then -- Для блокировки анимации в автомобиле
						block, anim, times, loop, updatePosition, interruptable, freezeLastFrame = ReplaceVehicleAnimation[block][anim]["theVehicle"][1], ReplaceVehicleAnimation[block][anim]["theVehicle"][2], ReplaceVehicleAnimation[block][anim]["theVehicle"][3], ReplaceVehicleAnimation[block][anim]["theVehicle"][4], ReplaceVehicleAnimation[block][anim]["theVehicle"][5], ReplaceVehicleAnimation[block][anim]["theVehicle"][6], ReplaceVehicleAnimation[block][anim]["theVehicle"][7]
					else
						return false
					end
				end
			end
		end
	end
	if(getElementType(thePlayer) == "ped") then
		if(loop) then
			setElementData(thePlayer, "anim", toJSON({block, anim, times, loop, updatePosition, interruptable, freezeLastFrame}))
		end
	end

	if(getElementHealth(thePlayer) < 20 and not forced) then
		return false
	end
	setPedAnimation(thePlayer, block, anim, times, loop, updatePosition, interruptable, freezeLastFrame)
	
	
	if(block == "FOOD" and anim == "EAT_Vomit_P") then
		for key,thePlayers in pairs(getElementsByType "player") do
			triggerClientEvent(thePlayers, "PlayerPuke", thePlayers, thePlayer)
		end
	elseif(block == "PAULNMAC" and anim == "Piss_out") then
		for key,thePlayers in pairs(getElementsByType "player") do
			triggerClientEvent(thePlayers, "PlayerPiss", thePlayers, thePlayer)
		end
	end
	
	
	
	
	return true
end
addEvent("StartAnimation", true)
addEventHandler("StartAnimation", root, StartAnimation)




CreateEnter(-1749.2, 868.7, 25.1, 180, 0, 0, false, -1753.7, 883.9, 295.6, 0, 0, 0, "Крыша") -- Крыша SF
CreateEnter(1570.7, -1337.2, 16.5, 312, 0, 0, false, 1548.6, -1363.7, 326.2, 180, 0, 0, "Крыша") -- Крыша LS
CreateEnter(2495.35, -1690.85, 14.75, 0, 0, 0, false, 2496, -1692.3, 1014.75, 180, 3, 0) -- CJ
CreateEnter(2459.5, -1691.3, 13.5, 0, 0, 0, false, 2468.5, -1698.2, 1013.5, 180, 2, 0) -- Ryder
CreateEnter(279.5, 1829, 8.14, 90, 0, 0, false, 283.9, 1829, 8.14, 270, 0, 0) -- Zone 51 кабинет ученого
CreateEnter(193.4, 1931.4, 17.6, 270, 0, 0, false, 264.3, 1857.9, 8.86, 0, 0, 0) -- Zone 51 вход к ученым
CreateEnter(-2026.7, -102.1, 35.2, 270, 0, 0, false, -2026.9, -103.6, 1035.2, 180, 3, 0) -- Автошкола SF
CreateEnter(-2029.7, -120.5, 35.2, 270, 0, 0, false, -2029.7, -119.4, 1035.2, 0, 3, 0) -- Автошкола SF 2
CreateEnter(2019.4, 1007.8, 10.8, 270, 0, 0, false, 2018.9, 1017.8, 996.9, 90, 10, 0, "Казино «The Four Dragons»")
CreateDialogBot(194, 1964.8, 1010.5, 992.5, 90, 10, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 1960.5, 1010.5, 992.5, 90, 10, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 1964.8, 1026, 992.5, 90, 10, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 1960.5, 1026.1, 992.5, 90, 10, 0, "Крупье казино", "Крупье")

CreateEnter(2197, 1677.1, 12.4, 90, 0, 0, false, 2233.9, 1714.7, 1012.4, 180, 1, 0, "Казино «Caligulas»")
CreateDialogBot(194, 2230.2, 1620.7, 1006.2, 180, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2231, 1613.5, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2241, 1620.7, 1006.2, 180, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2241.9, 1613.5, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2231, 1593.7, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2231, 1588.1, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2242.8, 1588.1, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")
CreateDialogBot(194, 2242.8, 1593.7, 1006.2, 0, 1, 0, "Крупье казино", "Крупье")

CreateEnter(1658.5, 2250, 11.1, 0, 0, 0, false, 1133.1, -15.8, 1000.7, 0, 12, 0, "Казино")




CreateDialogBot(71, 1717.4, 1617.1, 10, 165, 0, 0, "Охранник LV Airport", "Охранник КПП")
CreateDialogBot(71, -1544.6, -443.5, 6.1, 46, 0, 0, "Охранник SF Airport", "Охранник КПП")
CreateDialogBot(71, 1956, -2181.5, 13.5, 270, 0, 0, "Охранник LS Airport", "Охранник КПП")


CreateDialogBot(280, 1543.8, -1632, 13.4, 82, 0, 0, "Полиция", "Полицейский")
CreateDialogBot(281, -1701.2, 688.9, 24.9, 90, 0, 0, "Полиция", "Полицейский")
CreateDialogBot(282, 2238.2, 2449.4, 11, 90, 0, 0, "Полиция", "Полицейский")




CreateEnter(2233.3, -1159.8, 25.9, 90, 0, 0, false, 2214.4, -1150.5, 1025.8, 270, 15, 0, "Отель «Jefferson»")
CreateEnter(1689.6, -1518.4, 13.5, 270, 0, 0, false, -787.6, 445.4, 1362.4, 90, 1, 0, "Liberty City")
CreateEnter(966.2, 2160.7, 10.8, 270, 0, 0, false, 965.4, 2107.8, 1011, 90, 1, 0, "Sindacco Abattoir")
CreateEnter(931, 2129.6, 10.8, 90, 0, 0, false, 964.9, 2160.1, 1011, 90, 1, 0, "Sindacco Abattoir")






local CopsBiz = {
	["Шериф Angel Pine"] = "WSPD BIZ",
	["Шериф округа Bone County"] = "BCPD BIZ",
	["Шериф El Quebrados"] = "TRPD BIZ",
	["Шериф округа Red County"] = "RCPD BIZ",
}

function CreateCop(x,y,z,rz, types, id)
	CreateEnter(x, y, z, rz, 0, 0, false, 322.2, 302.3, 999.2, 0, 5, id, types)
	local o = createObject(2930, 320.9, 316.1, 1000.7)
	setElementDimension(o, id)
	setElementInterior(o, 5)

	local o = createObject(2930, 320.9, 318, 1000.7)
	setElementDimension(o, id)
	setElementInterior(o, 5)

	local o = createObject(1536, 321.45, 301.9, 998.2)
	setElementDimension(o, id)
	setElementInterior(o, 5)

	local ped = CreateDialogBot(280, 325.4, 308.9, 999.2,170, 5, id, CopsBiz[types], "HR-менеджер")
	StartAnimation(ped,"INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true)
end
CreateCop(-2161.3, -2384.8, 30.9, 0, "Шериф Angel Pine", 1)
CreateCop(-217.8, 979.2, 19.5, 270, "Шериф округа Bone County", 2)
CreateCop(-1390, 2638.5, 56, 0, "Шериф El Quebrados", 3)
CreateCop(627, -571.8, 17.9, 270, "Шериф округа Red County", 4)




CreateEnter(-2624.6, 1412.65, 7.1, 180, 0, 0, false, -2636.7, 1402.5, 906.5, 0, 3, 0) -- Синдикат локо
CreateEnter(-2661.3, 1423.8, 23.9, 190, 0, 0, false, -2661, 1417.6, 922.2, 0, 3, 0) -- Синдикат локо крыша





CreateEnter(2229.9, -1721.2, 13.6, 270, 0, 0, false, 772.3, -5.1, 1000.7, 0, 5, 0) -- Качалка LS
CreateEnter(-2270.6, -155.9, 35.3, 0, 0, 0, false, 774.1, -50.5, 1000.6, 0, 6, 0) -- Качалка SF
CreateDialogBot(49, 774.4, -16.5, 1000.6, 180, 6, 0, "SF Kung FU", "Мастер Kung FU")
CreateEnter(1968.8, 2295.8, 16.5, 0, 0, 0, false, 773.9, -78.8, 1000.7, 0, 7, 0) -- Качалка LV


CreateEnter(1481, -1772.2, 18.8, 0, 0, 0, false, 390.7, 173.8, 1008.48, 90, 3, 0, "Мэрия Los Santos")
local ss = CreateDialogBot(150, 359.1, 173.6, 1008.4, 270, 3, 0, "MERIA Los Santos")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Watch", -1, true)
ss = CreateDialogBot(240, 363.9, 210, 1008.4, 10, 3, 0)
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Type_Loop", -1, true)
ss = CreateDialogBot(240, 354.2, 171.6, 1025.8,142, 3, 0, "MER LS")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Read", -1, true)

CreateEnter(-2766.6, 375.6, 6.3, 0, 0, 0, false, 390.7, 173.8, 1008.48, 90, 3, 1, "Мэрия San Fierro")
ss = CreateDialogBot(150, 359.1, 173.6, 1008.4, 270, 3, 1, "MERIA San Fierro")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Watch", -1, true)
ss = CreateDialogBot(240, 363.9, 210, 1008.4, 10, 3, 1)
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Type_Loop", -1, true)
ss = CreateDialogBot(240, 354.2, 171.6, 1025.8,142, 3, 1, "MER SF")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Read", -1, true)


CreateEnter(2389, 2466.1, 10.8, 0, 0, 0, false, 390.7, 173.8, 1008.48, 90, 3, 2, "Мэрия Las Venturas")
ss = CreateDialogBot(150, 359.1, 173.6, 1008.4, 270, 3, 2, "MERIA Las Venturas")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Watch", -1, true)
ss = CreateDialogBot(240, 363.9, 210, 1008.4, 10, 3, 2)
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Type_Loop", -1, true)
ss = CreateDialogBot(240, 354.2, 171.6, 1025.8,142, 3, 2, "MER LV")
StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Read", -1, true)






CreateDialogBot(158, -371.4, -1432.7, 25.7, 90, 0, 0, "FARM FR", "Управляющий фермой")


CreateEnter(1097.9, 1598.1, 12.5, 0, 0, 0, false, -1464.8, 1556, 1052.5, 90, 14, 0) -- Стадион LV
CreateEnter(1243.3, 217.4, 23.1, 0, 0, 0, false, 2523.2, -1301.9, 1048.3, 90, 2, 0) -- Притон 1
CreateEnter(1257.3, 241.9, 19.9, 0, 0, 0, false, 2570.8, -1301.8, 1044.1, 90, 2, 0) -- Притон 2

CreateEnter(2696.2, -1707.1, 11.8, 0, 0, 0, false, -1406, -261.4, 1043.7, 351, 7, 0) -- 8-Track Stadium
CreateEnter(1122.7, -2037, 69.9, 270, 0, 0, false, 2548.8, -1294.6, 1061, 270, 2, 1) -- База Verdant Bluffs
CreateEnter(-2719.4, -319.2, 7.8, 270, 0, 0, false, 2548.8, -1294.6, 1061, 270, 2, 2) -- База Avispa Country Club
CreateEnter(-2172.4, 679.9, 55.2, 270, 0, 0, false, 2548.8, -1294.6, 1061, 270, 2, 3) -- База Chinatown



-- [Зона] = {{Модель авто, модель скина}, {Модель авто 2, модель скина 2}}
local PoliceSpecificZone = {
	["Los Santos"] = {{523, 284}, {596, 280}},
	["San Fierro"] = {{597, 281}},
	["Las Venturas"] = {{598, 282}},
	["Red County"] = {{523, 284}, {599, 283}},
	["Whetstone"] = {{523, 284}, {599, 283}},
	["Flint County"] = {{523, 284}, {599, 283}},
	["Bone County"] = {{599, 283}},
	["Tierra Robada"] = {{599, 283}},
	["UNDERWATER"] = {{596, 280}},
	["Unknown"] = {{596, 280}},
}

function WantedLevel(thePlayer, count)
	if(getElementData(thePlayer, "AEZAKMI") or PData[thePlayer]["DeathMatch"]) then
		if(count == "AEZAKMI") then
			removeElementData(thePlayer, "AEZAKMI")
		end
	else
		if(count == "AEZAKMI") then
			setElementData(thePlayer, "AEZAKMI", "true")
			count = -6
		end
		local x,y,z = getElementPosition(thePlayer)
		local zone = getZoneName(x,y,z, true)
	
		local wanted = GetDatabaseAccount(thePlayer, "wanted")
	
		
		if(count == 0.01) then
			if(wanted == 0) then count = 1 
			else count = 0 end
		end
		wanted = wanted+(count)
	
		if(wanted > 6) then wanted = 6
		elseif(wanted < 0) then wanted = 0 end
	
	
		if(wanted > 0) then
			if(wanted >= 5) then
			local rand = math.random(1,6)
			if(rand == 1 or rand == 2) then
				kr(thePlayer, 433, 287) -- Армия
			elseif(rand == 3 or rand == 4) then
				kr(thePlayer, 470, 287) -- Армия
			elseif(rand == 5) then
				kr(thePlayer, 488, 170) -- San News
			elseif(rand == 6) then
				kr(thePlayer, 497, 280) -- Вертолет
			end
			
			elseif(wanted >= 4) then
				kr(thePlayer, 490, 286) -- ФБР
			elseif(wanted >= 3) then
				kr(thePlayer, 427, 285) -- SWAT
			elseif(wanted < 3) then
				local rand = PoliceSpecificZone[zone][math.random(#PoliceSpecificZone[zone])]
				kr(thePlayer, rand[1], rand[2]) -- Выезжает полиция
			end
		end
		SetDatabaseAccount(thePlayer, "wanted", wanted)
		setElementData(thePlayer, "WantedLevel", wanted)
	end
end
addEvent("WantedLevel", true)
addEventHandler("WantedLevel", root, WantedLevel)




-- [скин] = цена
local wardrobeShop = {
	["Binco"] = {
		[10] = 500,
		[77] = 300,
		[78] = 300,
		[79] = 300,
		[212] = 450,
		[230] = 450,
		[239] = 500,
		[264] = 1250
	},
	["Zip"] = {
		[18] = 4000,
		[19] = 4500,
		[12] = 3300,
		[13] = 3000,
		[14] = 3100,
		[15] = 3400,
		[7] = 1000,
	},
	["Sub Urban"] = {
		[20] = 4200,
		[21] = 4250,
		[22] = 5450,
		[23] = 6100,
		[24] = 5600,
		[25] = 7200,
		[28] = 7600,
		[29] = 8400,
		[31] = 7500,
		[44] = 5500,
		[48] = 3500,
		[56] = 3500,
		[72] = 5300,
		[90] = 4200,
		[299] = 9800,
	},
	["ProLaps"] = {
		[26] = 3500,
		[92] = 6500,
		[99] = 6500,
	},
	["Victim"] = {
		[9] = 9500,
		[40] = 11000,
	},
	["Didier Sachs"] = {
		[17] = 35000,
		[91] = 27000,
		[227] = 45000,
		[228] = 50000
	}
}
wardrobeShop["BOBO"] = wardrobeShop["Sub Urban"]


local RobAnimation = {"SHP_Rob_GiveCash", "SHP_Rob_HandsUp", "SHP_Rob_React"}
local RobVoice = {2,5,7,8}

local RobTimers = {}
local RobPresure = {}
function RobShop(thePlayer, thePed)
	if(not RobPresure[thePed]) then
		RobPresure[thePed] = {}
		RobPresure[thePed]["player"] = thePlayer
		RobPresure[thePed]["presure"] = 10
		PData[thePlayer]["RobPed"] = thePed
		AddRobPresure(thePed, math.random(1,10))

		local mar = PlayersEnteredPickup[thePlayer]
		if(mar) then setMarkerColor(mar, 255, 0, 0, 170) end
		RobTimers[thePed] = setTimer(function(thePed, mar)
			if(mar) then setMarkerColor(mar, 255, 255, 0, 170) end
			StartAnimation(thePed, nil,nil)
		end, 120000, 1, thePed, mar)

		triggerClientEvent(thePlayer, "PlaySFXClient", thePlayer, "script", 25, math.random(53,54))
		StartAnimation(thePlayer, "SHOP", "SHP_Serve_End",false,false,false,false)
	end
end
addEvent("RobShop", true)
addEventHandler("RobShop", root, RobShop)


function AddRobPresure(thePed, count)
	local thePlayer = RobPresure[thePed]["player"]
	RobPresure[thePed]["presure"]=RobPresure[thePed]["presure"]+count
	if(RobPresure[thePed]["presure"] < 0) then RobPresure[thePed]["presure"] = 0
	elseif(RobPresure[thePed]["presure"] > 100) then RobPresure[thePed]["presure"] = 100 end


	if(RobPresure[thePed]["presure"] == 100) then
		WantedLevel(thePlayer, 1)
		AddPlayerMoney(thePlayer, math.random(1,5000), "МАГАЗИН ОГРАБЛЕН!")

		setTimer(function(thePlayer) triggerClientEvent(thePlayer, "PlaySFXClient", thePlayer, "script", 80, RobVoice[math.random(1,#RobVoice)]) end, 1000, 1, thePlayer)
		StartAnimation(thePed, "SHOP", RobAnimation[math.random(1,#RobAnimation)],-1,false,false,false)

		local x,y,z = GetPlayerLocation(thePlayer)
		PoliceCallRemove(x,y,z,"Ограбление")
		StopRob(thePlayer, thePed)
		return true
	end
	triggerClientEvent(thePlayer, "RobEvent", thePlayer, count)
end



function StopRob(thePlayer, thePed)
	if(thePlayer) then
		triggerClientEvent(thePlayer, "RobEvent", thePlayer)
		RobPresure[PData[thePlayer]["RobPed"]] = nil
		PData[thePlayer]["RobPed"] = nil
	elseif(thePed) then
		triggerClientEvent(RobPresure[thePed]["player"], "RobEvent", RobPresure[thePed]["player"])
		PData[RobPresure[thePed]["player"]]["RobPed"] = nil
		RobPresure[thePed] = nil
	end
end




function PetrolFuelColEnter(thePlayer, Colshape)
	PData[thePlayer]["FuelCol"] = Colshape
end
addEvent("PetrolFuelColEnter", true)
addEventHandler("PetrolFuelColEnter", root, PetrolFuelColEnter)


function ThreeColEnter(thePlayer, Colshape)
	PData[thePlayer]["ThreeCol"] = Colshape
	local Node = xmlFindChild(ThreesNode, getElementData(Colshape, "Three"), 0)
	local t = tonumber(xmlNodeGetAttribute(Node, "t"))
	local name = tonumber(xmlNodeGetAttribute(Node, "model"))
	if(t > 0) then
		triggerClientEvent(thePlayer, "ChangeInfo", thePlayer, ThreesNames[name].." созреет через #CCCCCC"..math.round(t/60, 0)+(1).." мин.\nНажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы уничтожить", 3000)
	else
		triggerClientEvent(thePlayer, "ChangeInfo", thePlayer, ThreesNames[name].." созрела\nНажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы собрать", 3000)
	end
end
addEvent("ThreeColEnter", true)
addEventHandler("ThreeColEnter", root, ThreeColEnter)



function VendingColEnter(thePlayer, Colshape)
	PData[thePlayer]["VendingCol"] = Colshape
end
addEvent("VendingColEnter", true)
addEventHandler("VendingColEnter", root, VendingColEnter)



function vending(thePlayer)
	if(PData[thePlayer]["VendingCol"]) then
		if(isElementWithinColShape(thePlayer, PData[thePlayer]["VendingCol"])) then
			DrinkSprunk(thePlayer, getElementData(PData[thePlayer]["VendingCol"], "vending"))
		end
	end
end




function GarageColEnter(thePlayer, Colshape)
	PData[thePlayer]["GarageCol"] = Colshape
end
addEvent("GarageColEnter", true)
addEventHandler("GarageColEnter", root, GarageColEnter)






function laltEnteredPickup(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	if(theVehicle) then
		if(PData[thePlayer]["GarageCol"]) then
			if(isElementWithinColShape(thePlayer, PData[thePlayer]["GarageCol"])) then
				if(getElementData(PData[thePlayer]["GarageCol"], "type") == "GEnter") then
					if(getElementData(PData[thePlayer]["GarageCol"], "locked")) then
						if(getElementData(PData[thePlayer]["GarageCol"], "locked") == 1) then
							HelpMessage(thePlayer, "Дверь закрыта!")
							return false
						end
					end
					local x,y,z = getElementPosition(theVehicle)
					local rx,ry,rz = getElementRotation(theVehicle)
					EnterGarage(thePlayer, getElementData(PData[thePlayer]["GarageCol"], "h"), getElementData(PData[thePlayer]["GarageCol"], "number"),x,y,z,rz)
				elseif(getElementData(PData[thePlayer]["GarageCol"], "type") == "GExit") then
					EnterGarage(thePlayer, getElementData(PData[thePlayer]["GarageCol"], "h"), getElementData(PData[thePlayer]["GarageCol"], "number"))
				end
			end
		end
		
	
		if(isTimer(FuelTimer[theVehicle])) then
			killTimer(FuelTimer[theVehicle])
			triggerEvent("onPlayerVehicleEnter", thePlayer, theVehicle, 0, 0, true)
		else
			if(PData[thePlayer]["FuelCol"]) then
				if(isElementWithinColShape(thePlayer, PData[thePlayer]["FuelCol"])) then
					local model = getElementModel(theVehicle)
					if(GetVehicleType(model) ~= "BMX") then
						if(not isTimer(FuelTimer[theVehicle])) then
							triggerEvent("onPlayerVehicleExit", thePlayer, theVehicle, 0, 0, true)
							ToolTip(thePlayer, Text(thePlayer, "Нажми {key} чтобы остановить заправку", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}}))
							FuelTimer[theVehicle] = setTimer(function(thePlayer, theVehicle)

								if(VehicleSystem[model][8] <= getElementData(theVehicle, "Fuel")+0.5) then
									setElementData(theVehicle, "Fuel", VehicleSystem[model][8])
								else
									if(AddPlayerMoney(thePlayer, -2)) then
										setElementData(theVehicle, "Fuel", getElementData(theVehicle, "Fuel")+0.5)
									end
								end
							end, 100, 0, thePlayer, theVehicle)
						end
					end
				end
			end

			if(PetrolFuelMarker[thePlayer]) then
				local xd,yd,zd = getElementPosition(PetrolFuelMarker[thePlayer])
				local size = getMarkerSize(PetrolFuelMarker[thePlayer])
				if(getDistanceBetweenPoints3D(x, y, z, xd,yd,zd) < size) then
					if(getElementData(PetrolFuelMarker[thePlayer], "type") == "siren") then
						triggerEvent("VehicleUpgrade", thePlayer, 8, 35000)
					elseif(getElementData(PetrolFuelMarker[thePlayer], "type") == "recyclels") then
						local CarNodes = xmlNodeGetChildren(CarNode)
						for i,node in ipairs(CarNodes) do
							if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
								xmlDestroyNode(node)
								if(getElementData(theVehicle, "owner") ~= getPlayerName(thePlayer)) then
									WantedLevel(thePlayer, 1.5)
									local x2,y2,z2 = getElementPosition(thePlayer)
									PoliceCallRemove(x2,y2,z2 "Продажа угнанного автомобиля")
								end
								local vmodelH = getVehicleHandling(theVehicle)
								AddPlayerMoney(thePlayer, vmodelH["monetary"]/4, "Транспорт продан!")
								removePedFromVehicle(thePlayer)
								destroyElement(theVehicle)
								break
							end
						end
					end
				end
			end
		end
	else
		
		
		if(PData[thePlayer]["GarageCol"]) then
			if(isElementWithinColShape(thePlayer, PData[thePlayer]["GarageCol"])) then
				local pic = PData[thePlayer]["GarageCol"]
				SetPlayerPosition(thePlayer, getElementData(pic, "x"), getElementData(pic, "y"), getElementData(pic, "z"), getElementData(pic, "i"), getElementData(pic, "d"), getElementData(pic, "rz"), true, getElementData(pic, "name"))
			end
		end
		
		
		if(PData[thePlayer]["ThreeCol"]) then
			if(isElementWithinColShape(thePlayer, PData[thePlayer]["ThreeCol"])) then
				HarvestThree(thePlayer, PData[thePlayer]["ThreeCol"])
			end
		end
		
		
		local target = getPedTarget(thePlayer)
		if(target) then
			if(getElementType(target) == "vehicle") then
				if(getElementData(target, "owner") == getPlayerName(thePlayer)) then
					if(getElementData(target, "siren") == "false") then
						setElementData(target, "siren", "true")
						HelpMessage(thePlayer, "Сигнализация включена!")
					elseif(getElementData(target, "siren") == "true") then
						setElementData(target, "siren", "false")
						HelpMessage(thePlayer, "Сигнализация выключена!")
					end
				end
			end
		end


		if(PlayersEnteredPickup[thePlayer]) then
			local pic = PlayersEnteredPickup[thePlayer]
			local x,y,z = getElementPosition(pic)
			local px,py,pz = getElementPosition(thePlayer)
			local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			local size = 3
			if(getElementType(pic) == "marker") then size = getMarkerSize(pic) end
			if(distance <= size) then
				if(getElementData(pic, "text")) then
					outputChatBox(getElementData(pic, "text"), thePlayer, 255,255,255, true)
				end
				if(getElementData(pic, "type") == "function") then
					local data = {}
					if(getElementData(pic, "funcdata")) then
						data = fromJSON(getElementData(pic, "funcdata"))
					end
					triggerEvent(getElementData(pic, "funcname"), thePlayer, unpack(data))
				elseif(getElementData(pic, "house")) then
					if(getElementData(pic, "locked")) then
						if(getElementData(pic, "locked") == 1) then
							HelpMessage(thePlayer, "Дверь закрыта!")
							return false
						end
					end
					triggerEvent("EnterHouse", thePlayer, getElementData(pic, "house"))
				else
					if(getElementData(pic, "type") == "exit") then
						if(PData[thePlayer]["RobPed"]) then StopRob(thePlayer) end
					end

					SetPlayerPosition(thePlayer, getElementData(pic, "x"), getElementData(pic, "y"), getElementData(pic, "z"), getElementData(pic, "i"), getElementData(pic, "d"), getElementData(pic, "rz"), true, getElementData(pic, "name"))
				end
			end
		end


		local pic = PlayersPickups[thePlayer]
		if(isElement(pic)) then
			local x,y,z = getElementPosition(PlayersPickups[thePlayer])
			local px,py,pz = getElementPosition(thePlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, px, py ,pz)
			if(distance < 2) then
				if(getElementData(pic, "biz")) then
					local owner = getElementData(BusinessPickup[getElementData(pic, "name")], "bizowner")
					if(owner == getPlayerName(thePlayer)) then
						StartLookBiz(thePlayer, false, getElementData(pic, "name"), "nachalnik")
					else
						StartLookBiz(thePlayer, false, getElementData(pic, "name"), "otdelK")
					end
				elseif(getElementData(pic, "wardrobeShop")) then
					local x,y,z = getElementPosition(thePlayer)
					local i = getElementInterior(thePlayer)
					local d = getElementDimension(thePlayer)
					PData[thePlayer]["oldposition"] = {x,y,z,i,d}
					setElementPosition(thePlayer, 258.3, -41.8, 1002)
					setElementRotation(thePlayer, 0, 0, 90)
					setElementInterior(thePlayer, 14)
					setElementDimension(thePlayer, getPlayerID(thePlayer))
					triggerClientEvent(thePlayer, "wardrobe", thePlayer, toJSON(wardrobeShop[getElementData(pic, "wardrobeShop")]), "shop")
				end
			end
		end
	end
end


function EnterWardrobe(thePlayer, house)
	local HouseNodes = xmlNodeGetChildren(HouseNode)
	local node = xmlFindChild(HouseNode, "h"..house, 0)
	if(xmlNodeGetValue(node) == "") then
		ToolTip(thePlayer, "Гардероб пуст")
		return false
	end
	local x,y,z = getElementPosition(thePlayer)
	local i = getElementInterior(thePlayer)
	local d = getElementDimension(thePlayer)
	PData[thePlayer]["oldposition"] = {x,y,z,i,d,xmlNodeGetValue(node)}
	setElementPosition(thePlayer, 258.3, -41.8, 1002)
	setElementRotation(thePlayer, 0, 0, 90)
	setElementInterior(thePlayer, 14)
	setElementDimension(thePlayer, getPlayerID(thePlayer))
	local arr = GetDatabaseAccountFromName(xmlNodeGetValue(node), "wardrobe")
	triggerClientEvent(thePlayer, "wardrobe", thePlayer, arr, "house")
end
addEvent("EnterWardrobe", true)
addEventHandler("EnterWardrobe", root, EnterWardrobe)




function GetQuality(quality)
	local out = ""
	if(not quality or quality <= 99) then
		out = "отвратительное"
	elseif(quality <= 199 and quality > 99) then
		out =  "мерзкое"
	elseif(quality <= 299 and quality > 199) then
		out =  "гадкое"
	elseif(quality <= 399 and quality > 299) then
		out =  "плохое"
	elseif(quality <= 499 and quality > 399) then
		out =  "обычное"
	elseif(quality <= 599 and quality > 499) then
		out =  "хорошее"
	elseif(quality <= 699 and quality > 599) then
		out =  "очень хорошее"
	elseif(quality <= 799 and quality > 699) then
		out =  "отличное"
	elseif(quality <= 899 and quality > 799) then
		out =  "высокое"
	elseif(quality <= 999 and quality > 899) then
		out =  "великолепное"
	elseif(quality >= 1000) then
		out =  "превосходное"
	end
	return GetQualityColor(quality)..out
end


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


function GetBizGeneration(biz)
	local out = {["Sell"] = {}, ["Trade"] = {}}
	for name, dat in pairs(BizInfo[biz][3]) do
		out[dat[2]][#out[dat[2]]+1] = dat[1]
	end
	return out
end


-- Коэффициент продуктов к уровню
local ItemProdsCoeff = {
	["Зерно"] = 1,
	["Скот"] = 0.88,
	["Мясо"] = 0.73,
	["Алкоголь"] = 0.68,
	["Кока"] = 1,
	["Спанк"] = 0.21,
	["Конопля"] = 1,
	["Косяк"] = 0.4,
	["Нефть"] = 1,
	["Удобрения"] = 0.30,
	["Химикаты"] = 0.25,
	["Бензин"] = 0.45,
	["Пропан"] = 0.3
}


function GetBizMaxProds(biz, prod)
	return math.round((BizInfo[biz][4]*100)*ItemProdsCoeff[prod], 0)
end


function UpdateProductCost()
	local Products = {}
	for name, dat in pairs(BizInfo) do
		local Prods = GetBizGeneration(name)
		for types, items in pairs(Prods) do
			for _, item in pairs(items) do
				local maxProds = GetBizMaxProds(name, item)
				if(Products[item]) then -- Множитель растет от количества предприятий
					Products[item] = Products[item]+1
				else
					Products[item] = 1
				end
				if(types == "Sell") then
					Products[item] = Products[item]-(AddBizProduct(name, item)/maxProds) -- Уменьшаем если заполненны у потребителей
				elseif(types == "Trade") then
					Products[item] = Products[item]-(AddBizProduct(name, item)/maxProds) -- Уменьшает множитель если заполненные склады
				end
			end
		end
	end

	setElementData(root, "Economics", toJSON(Products))
end






function AddBizProduct(biz, item, count, withoutsave)
	local node = xmlFindChild(BizNode, biz, 0)
	local arr = xmlNodeGetAttribute(node, "var")
	local out = 0
	if(arr) then
		arr = fromJSON(arr)
		if(count) then
			arr[item] = arr[item]+count
			if(arr[item] > GetBizMaxProds(biz, item)) then return false -- Переполнен
			elseif(arr[item] < 0) then return false end -- Кончился продукт
			if(not withoutsave) then
				if(count < 0) then
					arr["lvl"] = arr["lvl"]+0.00025
					BizInfo[biz][4] = arr["lvl"]
				end
				xmlNodeSetAttribute(node, "var", toJSON(arr))
				UpdateProductCost()
			end
		end
		out = arr[item]
	end
	return out
end




function StartLookBiz(thePlayer,thePed,biz,control)
	if(thePlayer) then
		--Баланс, Прибыль, Убыток
		local node = xmlFindChild(BizNode, biz, 0)
		local owner = xmlNodeGetAttribute(node, "owner")
		local array = {
			["name"] = BizInfo[biz][2],
			["var"] = {}
		}


		if(control == "nachalnik") then
			if(owner ~= getPlayerName(thePlayer)) then
				if(thePed) then
					DialogBreak(thePlayer, "Это конфиденциальная информация", thePed)
				end
				return false
			end
			array["Nachalnik"] = true


			local vacancy = xmlNodeGetChildren(node)
			for i, ChildNode in pairs(vacancy) do
				if(not array["vacancy"]) then array["vacancy"] = {} end
				local name = xmlNodeGetAttribute(ChildNode, "name")
				array["vacancy"][i] = {biz, name, xmlNodeGetValue(ChildNode)}
			end
		end

		if(control == "map") then
			if(BizInfo[biz][4]) then array["var"]["Уровень"] = math.round(BizInfo[biz][4]) end
			array["var"]["Дата основания"] = BizInfo[biz][1]
			array["var"]["Владелец"] = xmlNodeGetAttribute(node, "owner")



			if(xmlNodeGetAttribute(node, "var")) then
				arr = fromJSON(xmlNodeGetAttribute(node, "var"))
				for name, val in pairs(arr) do
					if(name == "Качество земли") then
						--array["var"][#array["var"]+1] = {name, GetQuality(val)}
					elseif(name == "lvl") then
						--array["var"][#array["var"]+1] = {"Уровень", math.round(val, 0)}
					else
						array["var"][name] = val.."/"..GetBizMaxProds(biz, name)
					end
				end
			end
		elseif(control == "otdelK") then
			local vacancy = xmlNodeGetChildren(node)
			for i, ChildNode in pairs(vacancy) do
				if(not array["vacancy"]) then array["vacancy"] = {} end
				local name = xmlNodeGetAttribute(ChildNode, "name")
				array["vacancy"][i] = {biz, name, xmlNodeGetValue(ChildNode)}
			end
		end


		local TradeArr = {}
		if(BizInfo[biz][3]) then
			for _, item in pairs(BizInfo[biz][3]) do
				TradeArr[#TradeArr+1] = {
					["txd"] = item[1],
					["name"] = item[1],
					["quality"] = item[3],
					["ForSale"] = true,
					["Biz"] = biz
				}
			end
		end

		if(#TradeArr > 0) then
			triggerClientEvent(thePlayer, "TradeWindow", thePlayer, TradeArr, "Магазин")
		else
			triggerClientEvent(thePlayer, "bizControl", thePlayer, biz, array)
		end
		BizControls[biz][thePlayer] = control
	end
end
addEvent("StartLookBiz", true)
addEventHandler("StartLookBiz", root, StartLookBiz)





function Travel(thePlayer, thePed, City)
	if(thePlayer) then
		if(City == "San Andreas") then
			if(not getElementData(thePlayer, "City")) then
				DialogBreak(thePlayer, "Мы уже находимся в "..City, thePed)
			else
				triggerEvent("sa", thePlayer, thePlayer)
			end
		elseif(City == "Liberty City") then
			if(getElementData(thePlayer, "City") == City) then
				DialogBreak(thePlayer, "Мы уже находимся в "..City, thePed)
			else
				triggerEvent("lc", thePlayer, thePlayer)
				setElementPosition(thePlayer, 1.8, 26.7, 1199.6)
				setElementInterior(thePlayer, 1)
				setElementDimension(thePlayer, 1)
			end
		elseif(City == "Vice City") then
			if(getElementData(thePlayer, "City") == City) then
				DialogBreak(thePlayer, "Мы уже находимся в "..City, thePed)
			else
				DialogBreak(thePlayer, "К сожалению рейс "..City.." в данный момент не доступен", thePed)
			end
		end
	end
end
addEvent("Travel", true)
addEventHandler("Travel", root, Travel)




function sa(thePlayer, thePed, City)
	if(thePlayer) then
		setElementFrozen(thePlayer, true)
		triggerClientEvent(thePlayer, "restoreWorld", thePlayer)
	end
end
addEvent("sa", true)
addEventHandler("sa", root, sa)


function LeaveLC(thePlayer, thePed, City)
	if(thePlayer) then
		setElementFrozen(thePlayer, false)
		removeElementData(thePlayer, "City")
		setElementInterior(thePlayer, 0)
		setElementDimension(thePlayer, 0)
		setElementPosition(thePlayer, 1642.3, -2286.5, -1.2)
	end
end
addEvent("LeaveLC", true)
addEventHandler("LeaveLC", root, LeaveLC)


function WhoBizOwner(thePlayer,thePed,biz,vibori)
	if(thePlayer) then
		local node = xmlFindChild(BizNode, biz, 0)
		if(vibori) then
			local srok = tonumber(xmlNodeGetAttribute(node, "srok"))
			local times = getRealTime()
			local dates = getRealTime(times.timestamp+((srok*24)*60)-10800)
			outputChatBox("Выборы состоятся "..("%02d"):format(dates.monthday).."."..("%02d"):format(dates.month+1).."."..(dates.year+1900).." в "..("%02d"):format(dates.hour)..":"..("%02d"):format(dates.minute).." (МСК)", thePlayer)
		else
			local val = xmlNodeGetAttribute(node, "owner")
			if(val ~= "") then
				DialogBreak(thePlayer, val, thePed)
			else
				DialogBreak(thePlayer, "В настоящее время владелец отсутствует", thePed)
			end
		end
	end
end
addEvent("WhoBizOwner", true)
addEventHandler("WhoBizOwner", root, WhoBizOwner)





function StopBizControl(biz)
	BizControls[biz][source] = nil
end
addEvent("StopBizControl", true)
addEventHandler("StopBizControl", root, StopBizControl)



local Garages = {}
function CreateGarage(x,y,z,rz,locked,house,owner)
	local d = string.gsub(house, "h", "")
	if(not Garages[house]) then Garages[house] = {} end
	local n = #Garages[house]+1
	if(n == 1) then
		local o = createObject(10671, 609, -76.5, 998.8, 0,0,180)
		setElementInterior(o, 2)
		setElementDimension(o, d)
		Garages[house][n] = {}
		Garages[house][n]["enter"] = createColCuboid(x-2.5,y-2.5,z-1.5, 5.0, 5.0, 3.0)
		setElementData(Garages[house][n]["enter"], "type", "GEnter")
		setElementData(Garages[house][n]["enter"], "x", 611, false)
		setElementData(Garages[house][n]["enter"], "y", -72.3, false)
		setElementData(Garages[house][n]["enter"], "z", 998, false)
		setElementData(Garages[house][n]["enter"], "rz", 90, false)
		setElementData(Garages[house][n]["enter"], "locked", locked, false)
		setElementData(Garages[house][n]["enter"], "i", 2, false)
		setElementData(Garages[house][n]["enter"], "d", d, false)
		setElementData(Garages[house][n]["enter"], "owner", owner, false)
		setElementData(Garages[house][n]["enter"], "h", house, false)
		setElementData(Garages[house][n]["enter"], "number", n, false)

		Garages[house][n]["exit"] = createColCuboid(610-5, -76.5-5,997.5-1.5, 10.0, 10.0, 3.0)
		setElementInterior(Garages[house][n]["exit"], 2)
		setElementDimension(Garages[house][n]["exit"], d)
		setElementData(Garages[house][n]["exit"], "type", "GExit")
		setElementData(Garages[house][n]["exit"], "x", x, false)
		setElementData(Garages[house][n]["exit"], "y", y, false)
		setElementData(Garages[house][n]["exit"], "z", z, false)
		setElementData(Garages[house][n]["exit"], "i", 0, false)
		setElementData(Garages[house][n]["exit"], "d", 0, false)
		setElementData(Garages[house][n]["exit"], "rz", rz, false)
		setElementData(Garages[house][n]["exit"], "h", house, false)
		setElementData(Garages[house][n]["exit"], "number", n, false)
	elseif(n == 2) then
		local o = createObject(10671, 609.4, -125.6, 999, 0,0,180)
		setElementInterior(o, 3)
		setElementDimension(o, d)

		Garages[house][n] = {}
		Garages[house][n]["enter"] = createColCuboid(x-2.5,y-2.5,z-1.5, 5.0, 5.0, 3.0)
		setElementData(Garages[house][n]["enter"], "type", "GEnter")
		setElementData(Garages[house][n]["enter"], "x", 610.7, false)
		setElementData(Garages[house][n]["enter"], "y", -120.8, false)
		setElementData(Garages[house][n]["enter"], "z", 998, false)
		setElementData(Garages[house][n]["enter"], "rz", 90, false)
		setElementData(Garages[house][n]["enter"], "locked", locked, false)
		setElementData(Garages[house][n]["enter"], "i", 3, false)
		setElementData(Garages[house][n]["enter"], "d", d, false)
		setElementData(Garages[house][n]["enter"], "owner", owner, false)
		setElementData(Garages[house][n]["enter"], "h", house, false)
		setElementData(Garages[house][n]["enter"], "number", n, false)

		Garages[house][n]["exit"] = createColCuboid(609.9-5, -126-5,998-1.5, 10.0, 10.0, 3.0)
		setElementInterior(Garages[house][n]["exit"], 3)
		setElementDimension(Garages[house][n]["exit"], d)
		setElementData(Garages[house][n]["exit"], "type", "GExit")
		setElementData(Garages[house][n]["exit"], "x", x, false)
		setElementData(Garages[house][n]["exit"], "y", y, false)
		setElementData(Garages[house][n]["exit"], "z", z, false)
		setElementData(Garages[house][n]["exit"], "i", 0, false)
		setElementData(Garages[house][n]["exit"], "d", 0, false)
		setElementData(Garages[house][n]["exit"], "rz", rz, false)
		setElementData(Garages[house][n]["exit"], "h", house, false)
		setElementData(Garages[house][n]["exit"], "number", n, false)
	elseif(n == 3) then
		local o = createObject(10671, 302.4, 300.4, 999.1, 0,0,180)
		setElementInterior(o, 4)
		setElementDimension(o, d)

		Garages[house][n] = {}
		Garages[house][n]["enter"] = createColCuboid(x-2.5,y-2.5,z-1.5, 5.0, 5.0, 3.0)
		setElementData(Garages[house][n]["enter"], "type", "GEnter")
		setElementData(Garages[house][n]["enter"], "x", 610.7, false)
		setElementData(Garages[house][n]["enter"], "y", -120.8, false)
		setElementData(Garages[house][n]["enter"], "z", 998, false)
		setElementData(Garages[house][n]["enter"], "rz", 90, false)
		setElementData(Garages[house][n]["enter"], "locked", locked, false)
		setElementData(Garages[house][n]["enter"], "i", 4, false)
		setElementData(Garages[house][n]["enter"], "d", d, false)
		setElementData(Garages[house][n]["enter"], "owner", owner, false)
		setElementData(Garages[house][n]["enter"], "h", house, false)
		setElementData(Garages[house][n]["enter"], "number", n, false)

		Garages[house][n]["exit"] = createColCuboid(302.4-5, 300.4-5,999.1-1.5, 10.0, 10.0, 3.0)
		setElementInterior(Garages[house][n]["exit"], 4)
		setElementDimension(Garages[house][n]["exit"], d)
		setElementData(Garages[house][n]["exit"], "type", "GExit")
		setElementData(Garages[house][n]["exit"], "x", x, false)
		setElementData(Garages[house][n]["exit"], "y", y, false)
		setElementData(Garages[house][n]["exit"], "z", z, false)
		setElementData(Garages[house][n]["exit"], "i", 0, false)
		setElementData(Garages[house][n]["exit"], "d", 0, false)
		setElementData(Garages[house][n]["exit"], "rz", rz, false)
		setElementData(Garages[house][n]["exit"], "h", house, false)
		setElementData(Garages[house][n]["exit"], "number", n, false)
	end
end



function EnterGarage(thePlayer, house, n, gx,gy,gz,grz)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local x,y,z,rz,i = 616.9, -75, 997+VehicleSystem[getElementModel(theVehicle)][1], 90, 2
	if(n == 2) then x,y,z,rz,i = 615.4, -125.1, 997+VehicleSystem[getElementModel(theVehicle)][1], 90, 3 end
	if(gx) then
		local i = getElementData(Garages[house][n]["enter"], "i")
		local d = getElementData(Garages[house][n]["enter"], "d")
		setElementData(theVehicle, "gx", gx, false)
		setElementData(theVehicle, "gy", gy, false)
		setElementData(theVehicle, "gz", gz, false)
		setElementData(theVehicle, "grz", grz, false)
		setTimer(function()
			BindAllKey(thePlayer)
			fadeCamera(thePlayer, true, 1, 0, 0, 0)
			setElementRotation(theVehicle,0,0,rz)
			setElementInterior(theVehicle, i, x, y, z)
			setElementDimension(theVehicle, d)
			setElementInterior(thePlayer, i, x, y, z)
			setElementDimension(thePlayer, d)
		end, 1000, 1)
	else -- Выход из гаража
		local x = getElementData(theVehicle, "gx")
		local y = getElementData(theVehicle, "gy")
		local z = getElementData(theVehicle, "gz")+VehicleSystem[getElementModel(theVehicle)][1]
		local rz = getElementData(theVehicle, "grz")
		setTimer(function()
			BindAllKey(thePlayer)
			fadeCamera(thePlayer, true, 1, 0, 0, 0)
			if(theVehicle) then
				setElementRotation(theVehicle,0,0,rz)
				setElementInterior(theVehicle, 0, x,y,z)
				setElementDimension(theVehicle, 0)
			end
			setElementInterior(thePlayer, 0,x,y,z)
			setElementDimension(thePlayer, 0)
		end, 1000, 1)
	end
	fadeCamera(thePlayer, false, 1, 0, 0, 0)
	UnBindAllKey(thePlayer)
end
addEvent("EnterGarage", true)
addEventHandler("EnterGarage", root, EnterGarage)








function StartLainOS()
	triggerClientEvent(source, "StartLainOS", source)
end
addEvent("StartLainOS", true)
addEventHandler("StartLainOS", root, StartLainOS)


local ShmalTimer = {}
function CreateSpirt()
	if(not isTimer(ShmalTimer[source])) then
		local arr = FoundItemsCount(source, "Фекалии")
		if(arr) then
			setElementRotation(source, 0,0,180)
			StartAnimation(source, "RIFLE", "RIFLE_load")
			UnBindAllKey(source)
			ShmalTimer[source] = setTimer(function(thePlayer)
				RemoveInventoryItemCount(thePlayer, arr[1], arr[2])
				AddInventoryItem(thePlayer, {["txd"] = "Pissh Gold", ["name"] = "Pissh Gold"})
				StopAnimation(thePlayer)
				BindAllKey(thePlayer)
			end, 10000, 1, source)
		else
			ToolTip(thePlayer, "Тебе нужны #CC3300фекалии")
		end
	end
end
addEvent("CreateSpirt", true)
addEventHandler("CreateSpirt", root, CreateSpirt)





SData["Donuts"] = 1
function CreateDonuts(x,y,z, types)
	CreateEnter(x,y,z, 0, 0, 0, false, 377, -193.3, 1000.6, 0, 17, SData["Donuts"], types)

	CreateVending(1775, 373.83, -178.15, 1000.73, 0, 17, SData["Donuts"])
	CreateVending(1776, 379.03, -178.88, 1000.73, 270, 17, SData["Donuts"])

	SData["Donuts"]=SData["Donuts"]+1
end
CreateDonuts(1038.2, -1340.7, 13.7, "Jim's Sticky Ring") -- LS
CreateDonuts(-2767.9, 788.8, 52.8, "Tuff Nut Donuts") -- SF
CreateDonuts(-144.1, 1225.2, 19.9, "King Ring") -- LV

SData["Cluckin"] = 1
function CreateCluckin(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, 365.2, -11.7, 1001.8, 0, 9, SData["Cluckin"], "Cluckin' Bell")

	CreateDialogBot(167, 369.5, -4.5, 1001.8, 180, 9, SData["Cluckin"], "Cluckin' Bell", "Продавец")

	SData["Cluckin"] = SData["Cluckin"]+1
end

CreateCluckin(-1213.8, 1830.4, 41.9) -- BC
CreateCluckin(172.9, 1176.9, 14.7) -- BC
CreateCluckin(2397.8, -1899.2, 13.5) -- LS
CreateCluckin(928.8, -1352.9, 13.3) -- LS
CreateCluckin(2420, -1508.9, 24) -- LS
CreateCluckin(2393.2, 2041.6, 10.8) -- LV
CreateCluckin(2638.27, 1671.9, 11) -- LV
CreateCluckin(2838.3, 2407.5, 11) -- LV
CreateCluckin(2101.9, 2228.8, 11) -- LV
CreateCluckin(-2672.2, 258.1, 4.6) -- SF
CreateCluckin(-2155.3, -2460.1, 30.8) -- SF
CreateCluckin(-1816.5, 618.0, 35.1) -- SF



SData["pump"] = 1
function CreatePump(x,y,z,rz)
	CreateEnter(x,y,z, rz, 0, 0, false, 681.6, -446.4, -25.6, 180, 1, SData["pump"], "The Welcome Pump")

	SData["pump"] = SData["pump"]+1
end

CreatePump(681.6, -473.3, 16.5, 180)





SData["Barber"] = 1
function CreateBarber(x,y,z,types)
	if(types == 2) then
		CreateEnter(x,y,z, 0, 0, 0, false, 411.6, -23, 1001.8, 0, 2, SData["Barber"], "Barber Shop")
	elseif(types == 3) then
		CreateEnter(x,y,z, 0, 0, 0, false, 418.6, -84.4, 1001.8, 0, 3, SData["Barber"], "Barber Shop")
	elseif(types == 12) then
		CreateEnter(x,y,z, 0, 0, 0, false, 412, -54.4, 1001.9, 0, 12, SData["Barber"], "Barber Shop")
	end
	SData["Barber"] = SData["Barber"]+1
end

CreateBarber(2070.6, -1793.8, 13.5, 2) -- LS
CreateBarber(824, -1588.3, 13.5, 3) -- LS
CreateBarber(672.1, -496.9, 16.3, 12) -- LS
CreateBarber(2080.3, 2122.9, 10.8, 12) -- LV
CreateBarber(-1449.8, 2591.9, 55.8, 12) -- LV
CreateBarber(-2571.3, 246.8, 10.5, 2) -- SF




SData["Tatto"] = 1
function CreateTatto(x,y,z,types)
	if(types == 16) then
		CreateEnter(x,y,z, 0, 0, 0, false, -204.4, -27.3, 1002.3, 0, 16, SData["Tatto"], "Tatoo parlour")
	elseif(types == 17) then
		CreateEnter(x,y,z, 0, 0, 0, false, -204.3, -8.9, 1002.3, 0, 17, SData["Tatto"], "Tatoo parlour")
	elseif(types == 3) then
		CreateEnter(x,y,z, 0, 0, 0, false, -204.3, -44.3, 1002.3, 0, 3, SData["Tatto"], "Tatoo parlour")
	end
	SData["Tatto"] = SData["Tatto"]+1
end

CreateTatto(2068.6, -1779.8, 13.6, 16) -- LS
CreateTatto(2094.7, 2122.9, 10.8, 3) -- LV
CreateTatto(-2491, -38.9, 25.6, 17) -- SF







SData["Airport"] = 10
function CreateAirport(x,y,z,rz,name)
	CreateEnter(x, y, z, rz, 0, 0, false, 367.4, 162.2, 1025.8, 90, 3, SData["Airport"], name)
	local o = createObject(5422, 368.7, 162.3, 1025.8, 0,0,0)
	setElementInterior(o, 3)
	setElementDimension(o, SData["Airport"])
	
	local ss = CreateDialogBot(240, 354.2, 171.6, 1025.8,142, 3, SData["Airport"], "Airport", "Продавец билетов")
	StartAnimation(ss, "INT_OFFICE", "OFF_Sit_Read", -1, true)
	
	SData["Airport"] = SData["Airport"]+1
end
CreateAirport(1642.4, -2288.2, -1.2, 180, "Airport Los Santos") 
CreateAirport(-1421.2, -286.9, 14.1, 140, "Airport San Fierro")
CreateAirport(1672.8, 1447.8, 10.8, 270, "Airport Las Venturas")



ped = CreateDialogBot(223, -853.7, 394.6, 11.3,270, 0, 1, "Airport", "Продавец билетов")
StartAnimation(ped,"smoking", "m_smk_loop", -1, true, false,false,true)



SData["Pizza"] = 1
function CreatePizza(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, 372.4, -133.5, 1001.5, 0, 5, SData["Pizza"], "The Well Stacked Pizza Co.")
	CreateDialogBot(155, 373.7, -117, 1001.5, 180, 5, SData["Pizza"], "The Well Stacked Pizza Co.", "Продавец")
	SData["Pizza"] = SData["Pizza"]+1
end

CreatePizza(2105.5, -1806.5, 13.6) --LS
CreatePizza(2331.8, 75, 26.6) --Laguna
CreatePizza(1367.5, 248.4, 19.5)--LS
CreatePizza(-1721.1, 1359.7, 7.2)--SF
CreatePizza(2638.6, 1849.8, 11)--LV
CreatePizza(2541, 2148, 10.8)--LV
CreatePizza(2351.9, 2533.6, 10.8)--LV
CreatePizza(2083.4, 2224.7, 11)--LV
CreatePizza(-1808.7, 945.9, 24.9)--SF
CreatePizza(203.5, -202, 1.6)--LS
CreatePizza(2756.8, 2477.3, 11.1)--lV


local DancingArr = {"bd_clap",
"bd_clap1",
"dance_loop",
"DAN_Down_A",
"DAN_Left_A",
"DAN_Loop_A",
"DAN_Right_A",
"DAN_Up_A",
"dnce_M_a",
"dnce_M_b",
"dnce_M_c",
"dnce_M_d",
"dnce_M_e"}



SData["Strip"] = 1
function CreateStrip(x,y,z,rz)
	CreateEnter(x,y,z,rz, 0, 0, false, 1204.8, -13.8, 1000.9, 0, 2, SData["Strip"], "The Pig Pen")


	local ped = CreateDialogBot(87, 1214, -4.2, 1001.3,180, 2, SData["Strip"], "Стриптизерша", "Стриптизерша")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	ped = CreateDialogBot(87, 1208.4, -6.4, 1001.3,90, 2, SData["Strip"], "Стриптизерша", "Стриптизерша")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	CreateDialogBot(188, 1215.1, -15.3, 1000.9, 0, 2, SData["Strip"], "Liquor Shop", "Бармен")

	SData["Strip"] = SData["Strip"]+1
end
CreateStrip(2421.6, -1219.2, 25.6, 0)
CreateStrip(693.7, 1967.7, 5.5, 180)



SData["Burger"] = 1
function CreateBurger(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, 362.9, -75.2, 1001.5, 0, 10, SData["Burger"], "Burger Shot")

	CreateDialogBot(205, 377.8, -65.8, 1001.5, 180, 10, SData["Burger"], "Burger Shot", "Продавец")

	local ped = CreateDialogBot(299, 369, -57.6, 1001.5,0, 10, SData["Burger"], "empty", "『 неизвестно 』")
	StartAnimation(ped,"PAULNMAC", "piss_loop", -1, true, false,false,true)

	SData["Burger"] = SData["Burger"]+1
end

CreateBurger(810.5, -1616.2, 13.4) --LS
CreateBurger(1199.3, -918.3, 43.1) --LS
CreateBurger(-2336.9, -166.8, 35.5) --SF
CreateBurger(-1912.4, 827.9, 35.2) --SF
CreateBurger(-2355.8, 1008.1, 50.94) --SF
CreateBurger(2169.5, 2795.9, 10.894) --LV
CreateBurger(1157.9, 2072.3, 11.1) --LV
CreateBurger(2472.9, 2034.2, 11.1) --LV
CreateBurger(1872.3, 2071.9, 11.1) --LV
CreateBurger(2367.1, 2071, 10.8) --LV




SData["Electronics"] = 1
function CreateElectronics(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, -2240.5, 128.4, 1035.4, 0, 6, SData["Electronics"], "Zero RC")

	CreateDialogBot(217, -2237.3, 128.6, 1035.4, 0, 6, SData["Electronics"], "Electronics Shop", "Продавец")

	SData["Electronics"] = SData["Electronics"]+1
end
CreateElectronics(-2241.8, 128.6, 35.3)
CreateElectronics(1041.4, -943.6, 42.8)
CreateElectronics(2861.8, -1478.8, 10.9)
CreateElectronics(1026.5, -1230.4, 16.9)
CreateElectronics(2710.4, -1095.6, 69.5)
CreateElectronics(1597.1, -1862.6, 13.5)
CreateElectronics(1679.9, -1826.6, 13.5)
CreateElectronics(1445.1, -1408, 13.5)
CreateElectronics(1559.9, -1856, 13.5)
CreateElectronics(1445.1, -1283.3, 13.5)



function CreateChilliDogs(x,y,z,rz,model)
	CreateDialogBot(model,x,y,z,rz, 0, 0, "Chilli Dogs", "Продавец")
end
CreateChilliDogs(-198.5, 2659.9, 62.9, 270, 168)-- Las Payasadas
CreateChilliDogs(1030.9, 1362, 10.8, 0, 264) -- Las Venturas (come on Kids)
CreateChilliDogs(2175.5, 1522.5, 10.8,0, 264) -- Las Venturas (come on Kids)
CreateChilliDogs(1557.2, 979.4, 10.8,270, 168) -- Las Venturas
CreateChilliDogs(-2145.6, -425.2, 35.3,64, 168) -- San Fierro
CreateChilliDogs(-2036.1, -397.7, 35.5,11, 168) -- San Fierro
CreateChilliDogs(-2093.6, -397.2, 35.5,38, 168) -- San Fierro
CreateChilliDogs(-2384.8, -584.4, 132.1, 270, 264) -- San Fierro (come on Kids)
CreateChilliDogs(-2151, -436.2, 35.3,41, 168) -- San Fierro Roodle Exchange
CreateChilliDogs(-2692.4, 385.2, 4.4,225, 168) -- San Fierro
CreateChilliDogs(-2516.5, -16.4, 25.6,304, 168) -- San Fierro Roodle Exchange
CreateChilliDogs(2537.2, 2291.1, 10.8,90, 168) -- Las Venturas Roodle Exchange
CreateChilliDogs(1589.7, -1286.2, 17.5, 180, 168) -- Los Santos
CreateChilliDogs(388.9, -2070.7, 7.8,180, 168) -- Los Santos
CreateChilliDogs(-2201, -2386.6, 30.6,250, 168) -- AngelPine
CreateChilliDogs(2144.6, 1442.9, 10.8,180, 168) -- Las Venturas
CreateChilliDogs(2125.5, 1443.2, 10.8,180, 264) -- Las Venturas (come on Kids)
CreateChilliDogs(2538.8, 2137.1, 10.8,90, 168) -- Las Venturas
CreateChilliDogs(2538.9, 2154.1, 10.8,90, 264) -- Las Venturas (come on Kids)
CreateChilliDogs(2296.6, 2250.6, 10.8,90, 264) -- Las Venturas (come on Kids)
CreateChilliDogs(2327.8, 2422.3, 10.8,180, 168) -- Las Venturas
CreateChilliDogs(-800.1, 1625.2, 27.1,198, 168) -- Las Venturas



SData["Bait"] = 50
function CreateBait(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, 316.4, -170.3, 999.6, 0, 6, SData["Bait"], "Bait Shop")
	CreateDialogBot(133, 312.6, -167.8, 999.63, 0, 6, SData["Bait"], "Bait Shop", "Продавец")

	SData["Bait"] = SData["Bait"]+1
end
CreateBait(-2057.3, -2464.6, 31.2)
CreateBait(-1354.1, 2057.7, 53.1)




SData["InsideTrack"] = 50
function CreateInsideTrack(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, 834.7, 7.4, 1004.2, 90, 3, SData["InsideTrack"], "Inside Track")

	SData["InsideTrack"] = SData["InsideTrack"]+1
end
CreateInsideTrack(1288.7, 271.2, 19.6)
CreateInsideTrack(1631.9, -1172.9, 24.1)











SData["Medic"] = 1
function CreateMedic(x,y,z,rz,types)
	CreateEnter(x,y,z,rz, 0, 0, {"clinic"}, 354.1, 168.1, 1020, 0, 3, SData["Medic"], types)

	local door = createObject(1556, 353.37, 168.5, 1019,0,0,0)
	setElementInterior(door, 3)
	setElementDimension(door, SData["Medic"])

	local bed = createObject(1812, 351, 161, 1019,0,0,90)
	setElementInterior(bed, 3)
	setElementDimension(bed, SData["Medic"])

	SData["Medic"] = SData["Medic"]+1
end
CreateMedic(-320, 1048, 20, 0, "Медицинский центр Fort Caston")
CreateMedic(-2655.1, 640, 14.5, 0, "Медицинский центр San Fierro")
CreateMedic(2034, -1401.7, 17.32, 0)
CreateMedic(1607.4, 1815.2, 10.8, 0, "Госпиталь Las Venturas")
CreateMedic(-1514.8, 2518.9, 56.1, 0)
CreateMedic(1172.1, -1323.4, 15.4, 0)
CreateMedic(1225.1, 313.4, 19.8, 0)
CreateMedic(-2204.1, -2309.5, 31.4, 0)









local InLabTimer = {}
function InLab(Doctor, thePlayer)
	if(getElementModel(Doctor) == 70) then
		if(getTeamName(getPlayerTeam(thePlayer)) == "Уголовники") then
			if(not isTimer(InLabTimer[thePlayer])) then
				fadeCamera(thePlayer, false, 1.0, 0, 0, 0)
				Pain(thePlayer)
				setTimer(function()
					local x,y,z=getElementPosition(thePlayer)
					--setElementCollisionsEnabled(thePlayer, false)
					toggleAllControls(thePlayer, false)
					if(setElementRotation(thePlayer, 0,0,35,"default",true)) then
						SetPlayerPosition(thePlayer, 289.9, 1831.1, 9.14,0, 0)
						StartAnimation(thePlayer, "CRACK", "crckidle4", -1, true, true, true)
					end
					triggerClientEvent(thePlayer, "ShakeLevel", thePlayer, 100)
					fadeCamera(thePlayer, true, 2.0, 0, 0, 0)
					setElementData(thePlayer, "sleep", "true")
					UnBindAllKey(thePlayer)
					InLabTimer[thePlayer] = setTimer(function()
						OutLab(thePlayer)
					end, 30000, 1)
				end, 1000, 1)
				outputChatBox("Ожидай пациента!", Doctor, 255,255,255,true)
			end
		else
			outputChatBox("Можно использовать только заключенных!", Doctor, 255,255,255,true)
		end
	else
		outputChatBox("Ты не ученый!", Doctor, 255,255,255,true)
	end
end


function OutLab(thePlayer)
	fadeCamera(thePlayer, false, 1.0, 0, 0, 0)
	setTimer(function()
		--setElementCollisionsEnabled(thePlayer, true)
		toggleAllControls(thePlayer, true)
		removeElementData(thePlayer, "sleep")
		BindAllKey(thePlayer)
		SetPlayerPosition(thePlayer, SpawnPoint["AREA51"][1]+math.random(-2,2), SpawnPoint["AREA51"][2]+math.random(-2,2), SpawnPoint["AREA51"][3],0, 0)
		StartAnimation(thePlayer, "FOOD", "EAT_Vomit_P", false,false,false,false)
		fadeCamera(thePlayer, true, 2.0, 0, 0, 0)
	end, 2000, 1)
end



function Labfunc(thePlayer, command, h)
	if(h) then
		local Player = getPlayerByID(tonumber(h))
		if(Player) then
			InLab(thePlayer, Player)
		end
	else
		outputChatBox("Используй /inlab id заключенного", thePlayer, 255,255,255,true)
	end
end
addCommandHandler("inlab", Labfunc)







function sms(thePlayer, _, h, ...)
	if(h) then
		if(AddPlayerMoney(thePlayer, -100)) then
			local stringWithAllParameters = table.concat({...}, " ")
			for key,thePlayers in pairs(getElementsByType "player") do
				if(tostring(getElementData(thePlayers, "id")) == tostring(h)) then
					outputChatBox("(СМС) от ["..getElementData(thePlayer, "id").."] "..getPlayerName(thePlayer)..": "..stringWithAllParameters, thePlayers, 255,255,0,true)
					outputChatBox("(СМС) для ["..getElementData(thePlayers, "id").."] "..getPlayerName(thePlayers)..": "..stringWithAllParameters, thePlayer, 255,255,0,true)
				end
			end
		end
	else
		outputChatBox("Используй /sms id игрока текст", thePlayer, 255,255,255,true)
	end
end
addCommandHandler("sms", sms)
addCommandHandler("pm", sms)



function ad(thePlayer, _, ...)
	if(...) then
		if(AddPlayerMoney(thePlayer, -#...*500)) then
			local stringWithAllParameters = table.concat({...}, " ")
			outputChatBox("* Объявление "..stringWithAllParameters.." от "..getPlayerName(thePlayer).."["..getElementData(thePlayer, "id").."]", getRootElement(), 0,255,0,true)
		end
	else
		outputChatBox("Используй /ad текст чтобы дать рекламу, стоимость "..COLOR["DOLLAR"]["HEX"].."$500#FFFFFF за символ", thePlayer, 255,255,255,true)
	end
end
addCommandHandler("ad", ad)



function vpc(thePlayer, model, x,y,z)
	if(not model) then model = 439 end
	local i, d = getElementInterior(thePlayer), getElementDimension(thePlayer)
	local v = CreateVehicle(tonumber(model), x,y,z+1)
	setElementInterior(v, i)
	setElementDimension(v, d)

	warpPedIntoVehicle(thePlayer, v)
	setElementData(v, "destroy", "true", false)
end
addEvent("vpc", true)
addEventHandler("vpc", root, vpc)



function vp(thePlayer, model, x,y,z)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		if(not model) then model = 439 end
		local i, d = getElementInterior(thePlayer), getElementDimension(thePlayer)
		local v = CreateVehicle(tonumber(model), x,y,z+1)
		setElementInterior(v, i)
		setElementDimension(v, d)

		warpPedIntoVehicle(thePlayer, v)
		setElementData(v, "destroy", "true", false)
	end
end
addEvent("vp", true)
addEventHandler("vp", root, vp)




function vpr(thePlayer, model, x,y,z)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		if(not model) then model = 439 end
		local i, d = getElementInterior(thePlayer), getElementDimension(thePlayer)
		local v = CreateVehicle(tonumber(model), x,y,z+1)
		setElementInterior(v, i)
		setElementDimension(v, d)

		warpPedIntoVehicle(thePlayer, v)
		setElementData(v, "year", "Limited Edition")

		setElementData(v, "price", 1)
		setVehiclePlateText(v, "SELL 228")
	end
end
addEvent("vpr", true)
addEventHandler("vpr", root, vpr)












function RandomDance(thePlayer, thePed)
	StartAnimation(thePlayer, "DANCING", DancingArr[math.random(#DancingArr)],-1,true,false,false)
	StartAnimation(thePed, "DANCING", DancingArr[math.random(#DancingArr)],-1,true,false,false)
end
addEvent("RandomDance", true)
addEventHandler("RandomDance", root, RandomDance)


function dance(thePlayer, command, h)
	if(h) then
		StartAnimation(thePlayer, "DANCING", DancingArr[tonumber(h)],-1,true,false,false)
	else
		outputChatBox("Используй /dance [1-13]",thePlayer,255,255,255,true)
	end
end
addCommandHandler("dance", dance)



function CreateThree(model, x,y,z, name, quality)
	if(not quality) then quality = 0 end
	if(not Threes[name]) then
		if(model == 823) then
			Threes[name] = createObject(model,x,y,z+0.7, 0,0,0, true)
			setObjectScale(Threes[name], 0.25)
		else
			Threes[name] = createObject(model,x,y,z, 0,0,0, false)
		end
		ThreesPickup[name] = createColCuboid(x-1,y-1,z+0.5, 2.0, 2.0, 2.0)
		
		setElementData(ThreesPickup[name], "Three", name)
		setElementData(ThreesPickup[name], "quality", quality)
		return true
	else
		return false
	end
end
addEvent("CreateThree", true)
addEventHandler("CreateThree", root, CreateThree)








function BankEvent(thePlayer, thePed, biz, update)
	local Node = xmlFindChild(BizNode, biz, 0)
	if(update) then
		triggerClientEvent(thePlayer, "bankControlUpdate", thePlayer, biz, toJSON({GetDatabaseAccount(thePlayer, "bank"), BizInfo[biz][2]}))
	else
		triggerClientEvent(thePlayer, "BankControl", thePlayer, biz, toJSON({GetDatabaseAccount(thePlayer, "bank"), BizInfo[biz][2]}))
	end

end
addEvent("BankEvent", true)
addEventHandler("BankEvent", root, BankEvent)






function CreateThreePlayer(thePlayer, ix, iy, x,y,z)
	x,y = math.round(x, 0),math.round(y, 0)
	local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))
	local model = false

	if(arr[ix][iy]["name"] == "Конопля") then
		model = 823
	elseif(arr[ix][iy]["name"] == "Кока") then
		model = 782
	elseif(arr[ix][iy]["name"] == "Роза") then
		model = 870
	else
		return false
	end

	arr[ix][iy]["count"] = 1
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		local name = "T"..md5(tostring(x..y..z))
		StartAnimation(thePlayer, "BOMBER","BOM_Plant", false,false,false,false)
		PData[thePlayer]["ActionTimer"] = setTimer(function()
			if(CreateThree(model, x,y,z, name, GetItemQuality(arr[ix][iy]))) then
				if(arr[ix][iy]["name"] == "Конопля") then
					RemoveInventoryItemCount(thePlayer, ix,iy)

					HelpMessage(thePlayer, "Ты посадил #558833коноплю")
					local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
					if(PlayerTeam == "Баллас") then
						if(GetDatabaseAccount(thePlayer, "BTUT") == 1) then
							SetDatabaseAccount(thePlayer, "BTUT", 2)
							MissionCompleted(thePlayer, "СООБРАЗИТЕЛЬНОСТЬ +", "МИССИЯ ВЫПОЛНЕНА")
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
							UpdateTutorial(thePlayer)
						end
					end
					times = 3480
				elseif(arr[ix][iy]["name"] == "Роза") then
					RemoveInventoryItemCount(thePlayer, ix,iy)

					HelpMessage(thePlayer, "Ты посадил #B90000розы")
					times = 6480
				elseif(arr[ix][iy]["name"] == "Кока") then
					RemoveInventoryItemCount(thePlayer, ix,iy)

					HelpMessage(thePlayer, "Ты посадил коку")
					local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
					if(PlayerTeam == "Колумбийский картель") then
						if(GetDatabaseAccount(thePlayer, "KTUT") == 1) then
							SetDatabaseAccount(thePlayer, "KTUT", 2)
							MissionCompleted(thePlayer, "СООБРАЗИТЕЛЬНОСТЬ +", "МИССИЯ ВЫПОЛНЕНА")
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
							UpdateTutorial(thePlayer)
						end
					end
					times = 10440
				end
				local ThreesNodes = xmlNodeGetChildren(ThreesNode)
				local NewNode = xmlCreateChild(ThreesNode, name)
				xmlNodeSetAttribute(NewNode, "x", x)
				xmlNodeSetAttribute(NewNode, "y", y)
				xmlNodeSetAttribute(NewNode, "z", z)
				xmlNodeSetAttribute(NewNode, "model", model)
				xmlNodeSetAttribute(NewNode, "stage", 1)
				xmlNodeSetAttribute(NewNode, "quality", GetItemQuality(arr[ix][iy]))
				xmlNodeSetAttribute(NewNode, "t", times)
			else
				HelpMessage(thePlayer, "Тут уже посажено растение!")
			end
		end, 2200, 1)
	end
end
addEvent("CreateThreePlayer", true)
addEventHandler("CreateThreePlayer", root, CreateThreePlayer)


function RemoveThree(name)
	for thePlayer, dat in pairs(PData) do
		if(dat["ThreeCol"]) then 
			if(getElementData(dat["ThreeCol"], "Three") == name) then
				dat["ThreeCol"] = nil
			end
		end
	end
	destroyElement(ThreesPickup[name])
	destroyElement(Threes[name])
	Threes[name] = nil

	local Node = xmlFindChild(ThreesNode, name, 0)
	xmlDestroyNode(Node)
end

function HarvestThree2(thePlayer, pic)
	local Node = xmlFindChild(ThreesNode, getElementData(pic, "Three"), 0)
	local t = tonumber(xmlNodeGetAttribute(Node, "t"))
	local model = tonumber(xmlNodeGetAttribute(Node, "model"))
	local NewQuality = tonumber(getElementData(pic, "quality"))+100
	if(NewQuality > 1000) then NewQuality = 1000 end
	if(t == 0) then
		AddInventoryItem(thePlayer, {["txd"] = "Конопля", ["name"] = "Конопля", ["count"] = math.random(1,3), ["quality"] = NewQuality})
		if(model == 823) then
			if(xmlNodeGetAttribute(Node, "stage") == "1") then
				xmlNodeSetAttribute(Node, "stage", 2)
				xmlNodeSetAttribute(Node, "t", 3480)
			else
				RemoveThree(getElementData(pic, "Three"))
			end
			local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
			if(PlayerTeam == "Баллас") then
				if(GetDatabaseAccount(thePlayer, "BTUT") == 2) then
					SetDatabaseAccount(thePlayer, "BTUT", 3)
					UpdateTutorial(thePlayer)
				end
			end
		elseif(model == 782) then
			AddInventoryItem(thePlayer, {["txd"] = "Кока", ["name"] = "Кока", ["count"] = math.random(2,3), ["quality"] = NewQuality})
	
			RemoveThree(getElementData(pic, "Three"))
			local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
			if(PlayerTeam == "Колумбийский картель") then
				if(GetDatabaseAccount(thePlayer, "KTUT") == 2) then
					SetDatabaseAccount(thePlayer, "KTUT", 3)
					UpdateTutorial(thePlayer)
				end
			end
			
		elseif(model == 870) then
			AddInventoryItem(thePlayer, {["txd"] = "Роза", ["name"] = "Роза", ["count"] = math.random(2,3), ["quality"] = NewQuality})
	
			RemoveThree(getElementData(pic, "Three"))
		end
	else
	
		AddInventoryItem(thePlayer, {["txd"] = ThreesNames[model], ["name"] = ThreesNames[model], ["count"] = 1, ["quality"] = tonumber(getElementData(pic, "quality"))})
	
		RemoveThree(getElementData(pic, "Three"))
	end
end



function HarvestThree(thePlayer, pic, isVeh)
	if(isVeh) then
		HarvestThree2(thePlayer, pic)
	else
		if(not isTimer(PData[thePlayer]["ActionTimer"])) then
			StartAnimation(thePlayer, "BOMBER","BOM_Plant_Crouch_Out", false,false,false,false)
			PData[thePlayer]["ActionTimer"] = setTimer(function()
				HarvestThree2(thePlayer, pic)
			end, 1000, 1)
		end
	end
end
addEvent("HarvestThree", true)
addEventHandler("HarvestThree", root, HarvestThree)





function usekanistra(thePlayer, slot)
	local tar = getPedTarget(thePlayer)
	if(tar) then
		if(getElementType(tar) == "vehicle") then
			if(not getElementData(tar, "Fuel")) then
				setElementData(tar, "Fuel", 25)
			end
			local model = getElementModel(tar)
			if(VehicleSystem[model][8] <= getElementData(tar, "Fuel")+10) then
				setElementData(tar, "Fuel", VehicleSystem[model][8])
			else
				setElementData(tar, "Fuel", getElementData(tar, "Fuel")+10)
			end
			ToolTip(thePlayer, "Ты заправил автомобиль на 10 литров!")
			return true
		end
	end
	ToolTip(thePlayer, "Подойди к машине")
end
addEvent("usekanistra", true)
addEventHandler("usekanistra", root, usekanistra)




function usezapaska(thePlayer, slot)
	local tar = getPedTarget(thePlayer)
	if(tar) then
		if(getElementType(tar) == "vehicle") then
			local wheels = {getVehicleWheelStates(tar)}
			for wheel, state in pairs(wheels) do
				if(state == 1) then
					wheels[wheel] = 0
					setVehicleWheelStates(tar, wheels[1], wheels[2], wheels[3], wheels[4])

					ToolTip(thePlayer, "Ты заменил колесо!")
					return true
				end
			end

			ToolTip(thePlayer, "Транспорт не нуждается в замене колеса!")
			return false
		end
	end
	ToolTip(thePlayer, "Подойди к машине")
end
addEvent("usezapaska", true)
addEventHandler("usezapaska", root, usezapaska)












function usesmoke(thePlayer, slot)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
    if(not PData[thePlayer]["smoke"]) then
		StartAnimation(thePlayer, "smoking","M_smk_in", false,false,false,false)
		PData[thePlayer]["smoke"] = setTimer(function()
			AddPlayerArmas(thePlayer, 3027)
			setElementHealth(thePlayer, getElementHealth(thePlayer)+5)
			triggerClientEvent(thePlayer, "ShakeLevel", thePlayer, 5)
			setTimer(function()
				StartAnimation(thePlayer, "smoking","M_smk_out", false,false,false,false)
				setTimer(function()
					PData[thePlayer]["smoke"] = nil
					RemovePlayerArmas(thePlayer, 3027)
				end, 1500, 1, thePlayer)
			end, 60000, 1, thePlayer)
		end, 1500, 1, thePlayer)
	else
		StartAnimation(thePlayer, "smoking","M_smklean_loop", false,false,false,false)
    end
end
addEvent("usesmoke", true)
addEventHandler("usesmoke", root, usesmoke)




function usedrink(thePlayer)
	StartAnimation(thePlayer, "VENDING","VEND_Drink2_P", 1500, false, true, true, false)
	setElementHealth(thePlayer, getElementHealth(thePlayer)+5)
	triggerClientEvent(thePlayer, "ShakeLevel", thePlayer, 25)
	setPedWalkingStyle(thePlayer, 126)

	local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
	if(PlayerTeam == "Военные") then
		if(GetDatabaseAccount(thePlayer, "ATUT") == 1) then
			SetDatabaseAccount(thePlayer, "ATUT", 2)
			setTimer(function()
				triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
				triggerClientEvent(thePlayer, "RemoveGPSMarker", thePlayer, "Служба: найди способ нажраться")
				MissionCompleted(thePlayer, "Полиция +", "МИССИЯ ВЫПОЛНЕНА")
				Respect(thePlayer, "police", 5)
				triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 228, 228, 228, "Посади заключенного на бутылку")
			end, 1500, 1, thePlayer)
		end
	end
end
addEvent("usedrink", true)
addEventHandler("usedrink", root, usedrink)





function eatcrap(thePlayer)
	StartAnimation(thePlayer, "FOOD", "EAT_Burger",false,false,false,false)
	triggerEvent("onPlayerChat", thePlayer, "жрет говно", 1)
	local rand = math.random(1,2)
	if(rand == 1) then
		addPlayerBolezn(thePlayer, "Дизентерия", 1)
	end
end
addEvent("eatcrap", true)
addEventHandler("eatcrap", root, eatcrap)





local DrugsTimer = {}
function usedrugs(thePlayer)
	setElementHealth(thePlayer, getElementHealth(thePlayer)+50)
	StartAnimation(thePlayer,"SMOKING", "M_smk_in",false,false,false,false)
	triggerClientEvent(thePlayer, "ShakeLevel", thePlayer, 100)
	triggerClientEvent(thePlayer, "DrugsPlayerEffect", thePlayer)
	if(isTimer(DrugsTimer[thePlayer])) then
		resetTimer(DrugsTimer[thePlayer])
	else
		DrugsTimer[thePlayer] = setTimer(function()
			SyncTime(thePlayer)
		end, 60000, 1)
	end
end
addEvent("usedrugs", true)
addEventHandler("usedrugs", root, usedrugs)




local SpunkTimer = {}
function usespunk(thePlayer)
	setElementHealth(thePlayer, getElementHealth(thePlayer)+50)
	StartAnimation(thePlayer,"SMOKING", "M_smk_in",false,false,false,false)
	triggerClientEvent(thePlayer, "SpunkPlayerEffect", thePlayer)
	if(isTimer(SpunkTimer[thePlayer])) then
		resetTimer(SpunkTimer[thePlayer])
	else
		SpunkTimer[thePlayer] = setTimer(function()
			SyncTime(thePlayer)
		end, 60000, 1)
	end
end
addEvent("usespunk", true)
addEventHandler("usespunk", root, usespunk)



WeaponNamesArr = {
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
	["Нож"] = 4,
	["Катана"] = 8,
	["Удочка"] = 7,
	["Клюшка"] = 2,
	["Лопата"] = 6,
	["Кастет"] = 1,
	["Миниган"] = 38,
	["Цветы"] = 14,
	["Трость"] = 15,
	["Бита"] = 5,
	["Дубинка"] = 3,
	["Парашют"] = 46,
	["Камера"] = 43,
	["Огнетушитель"] = 42,
	["Спрей"] = 41,
	["Базука"] = 35,
	["Ракетная установка"] = 36,
	["Огнемет"] = 37,
	["Бензопила"] = 9,
}

local ItemsNamesArr = {
	["Телефон"] = 330,
	["Подкова"] = 954,
	["Ракушка"] = 953,
	["Реликвия"] = 1276,
	["KBeer"] = 1950,
	["KBeer Dark"] = 1951,
	["isabella"] = 1669,
	["Pissh"] = 1543,
	["Pissh Gold"] = 1544,
	["Сигарета"] = 3027,
	["Черепаха"] = 1609,
	["Акула"] = 1608,
	["Дельфин"] = 1607,
	["Пакет"] = 2663,
	["Чемодан"] = 1210,
	["Рюкзак"] = 3026,
	["Канистра"] = 1650,
	["Запаска"] = 1025,
	["Нефть"] = 3632,
	["Пропан"] = 1370,
	["Алкоголь"] = 2900,
	["Мясо"] = 2805,
	["Химикаты"] = 1218,
	["Зерно"] = 1453,
	["CoK"] = 2670,
	["Деньги"] = 1212,
	["Бронежилет"] = 1242,
}


function FoundWName(id)
	for v,k in pairs(WeaponNamesArr) do
		if(k == id) then
			return v
		end
	end
	return false
end





function SetControls(thePlayer, ctlrname, arr)
	for name, val in pairs(arr) do
		if(val) then
			PData[thePlayer]["CONTROLS"][name][ctlrname] = val
		else
			PData[thePlayer]["CONTROLS"][name][ctlrname] = nil
		end
		if(getArrSize(PData[thePlayer]["CONTROLS"][name]) == 0) then
			toggleControl(thePlayer, name, true)
		else
			toggleControl(thePlayer, name, false)
		end
	end
end






local WeaponAmmo = {
	[30] = "7.62-мм",
	[31] = "5.56-мм",
	[16] = "Граната",
	[18] = "Молотов",
	[22] = "9-мм",
	[23] = "9-мм",
	[24] = "9-мм",
	[25] = "18.5-мм",
	[26] = "18.5-мм",
	[27] = "18.5-мм",
	[28] = "9-мм",
	[29] = "9-мм",
	[32] = "9-мм",
	[33] = "18.5-мм",
	[34] = "7.62-мм",
	[35] = "Ракета", 
	[38] = "7.62-мм",
	[46] = "Парашют",
}




function isAmmo(name)
	for _,k in pairs(WeaponAmmo) do
		if(k == name) then return true end
	end
	return false
end







function useinvweapon(thePlayer, slots)
	if(slots) then
		PData[thePlayer]["WeaponSlot"] = slots
	end

	SetControls(thePlayer, "ammo", {["fire"] = false, ["action"] = false, ["vehicle_fire"] = false, ["vehicle_secondary_fire"] = false})

	if(PData[thePlayer]["AdvArmasItem"]) then
		RemovePlayerArmas(thePlayer, PData[thePlayer]["AdvArmasItem"])
		PData[thePlayer]["AdvArmasItem"] = nil
	end

	takeAllWeapons(thePlayer)
	local arr = fromJSON(getElementData(thePlayer, "inv"))

	local carry = false
	for x, data in pairs(arr) do
		for y, dat in pairs(data) do
			if(dat["name"]) then
				if(dat["name"] == "Запаска" or dat["name"] == "Зерно" or dat["name"] == "Нефть" or dat["name"] == "Химикаты" or dat["name"] == "Алкоголь" or dat["name"] == "Пропан") then
					carry = true
				end
			end
		end
	end
	if(carry) then
		StartAnimation(thePlayer, "CARRY", "crry_prtial", 1, false, true, true, true, false)
		SetControls(thePlayer, "carry", {["fire"] = true, ["action"] = true, ["jump"] = true, ["aim_weapon"] = true, ["enter_exit"] = true, ["enter_passenger"] = true})
	else
		SetControls(thePlayer, "carry", {["fire"] = false, ["action"] = false, ["jump"] = false, ["aim_weapon"] = false, ["enter_exit"] = false, ["enter_passenger"] = false})
	end

	if(PData[thePlayer]["WeaponSlot"]) then
		local WM = false
		if(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]["name"]) then
			WM = WeaponNamesArr[arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]["name"]]
		end
		if(WM) then
			if(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]["Лазерный прицел"]) then
				setElementData(thePlayer, "laser", toJSON(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]["Лазерный прицел"]["color"]))
			else
				removeElementData(thePlayer, "laser")
			end
			if(WM == 16 or WM == 18 or WM == 46 or WM == 7) then -- Граната, молотов, Парашют, удочка
				giveWeapon(thePlayer, WM, GetItemCount(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]), true)
			else
				giveWeapon(thePlayer, WM, 10000, true)
				giveWeapon(thePlayer, WM, 10000, true)
				local WNA = WeaponAmmo[WM]
				if(WNA) then
					if(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]][WNA]) then
						setWeaponAmmo(thePlayer, WM, arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]][WNA]["count"])
					else
						SetControls(thePlayer, "ammo", {["fire"] = true, ['action'] = true, ["vehicle_fire"] = true, ["vehicle_secondary_fire"] = true})
					end
				end
			end
			
			
			if(getElementData(thePlayer, "FullClip")) then
				giveWeapon(thePlayer, WM, 10000, true)
				SetControls(thePlayer, "ammo", {["fire"] = false, ["action"] = false, ["vehicle_fire"] = false, ["vehicle_secondary_fire"] = false})
			end
		end
	end
	if(PData[thePlayer]["WeaponSlot"]) then
		setElementData(thePlayer, "WeaponSlot", toJSON(PData[thePlayer]["WeaponSlot"]))
	else
		removeElementData(thePlayer, "WeaponSlot")
	end
end
addEvent("useinvweapon", true)
addEventHandler("useinvweapon", root, useinvweapon)




function JetPack(thePlayer)
	setPedWearingJetpack(thePlayer, not isPedWearingJetpack(thePlayer))
end
addEvent("JetPack", true)
addEventHandler("JetPack", root, JetPack)







function FoundItemsCount(thePlayer, itemname)
	local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))
	local count = {}

	for x, datas in pairs(arr) do
		for y, data in pairs(datas) do
			if(data["name"]) then
				if(data["name"] == itemname) then
					count[#count+1] = {x,y}
				end
			end
		end
	end
	if(#count > 0) then	return count[math.random(#count)]
	else return false end
end






function MinusToPlus(var)
	if(var < 0) then
		var = var-var-var
	end
	return var
end


function nextweapon(thePlayer, n)
	local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))

	if(n == "next_weapon") then
		if(not PData[thePlayer]["WeaponSlot"]) then PData[thePlayer]["WeaponSlot"] = {1,1, true} end
		for x = PData[thePlayer]["WeaponSlot"][1], #arr do
			local StartedInd = 1
			if(x == PData[thePlayer]["WeaponSlot"][1]) then
				StartedInd = PData[thePlayer]["WeaponSlot"][2]
			end
			for y = StartedInd, #arr[x] do
				if(arr[x][y]["name"]) then
					if(WeaponNamesArr[arr[x][y]["name"]]) then
						if(x ~= PData[thePlayer]["WeaponSlot"][1] or y ~= PData[thePlayer]["WeaponSlot"][2] or PData[thePlayer]["WeaponSlot"][3]) then
							PData[thePlayer]["WeaponSlot"] = {x,y}
							if(not getControlState(thePlayer, "aim_weapon")) then -- В прицеле
								useinvweapon(thePlayer)
							end
							return
						end
					end
				end
			end
		end

		PData[thePlayer]["WeaponSlot"] = false
		useinvweapon(thePlayer)
	elseif(n == "previous_weapon") then
		if(not PData[thePlayer]["WeaponSlot"]) then PData[thePlayer]["WeaponSlot"] = {#arr,#arr[#arr], true} end

		for x = -PData[thePlayer]["WeaponSlot"][1], -1 do
			local StartedInd = #arr[MinusToPlus(x)]
			if(MinusToPlus(x) == PData[thePlayer]["WeaponSlot"][1]) then
				StartedInd = PData[thePlayer]["WeaponSlot"][2]
			end
			for y = -StartedInd, -1 do
				if(arr[MinusToPlus(x)][MinusToPlus(y)]["name"]) then
					if(WeaponNamesArr[arr[MinusToPlus(x)][MinusToPlus(y)]["name"]]) then
						if(MinusToPlus(x) ~= PData[thePlayer]["WeaponSlot"][1] or MinusToPlus(y) ~= PData[thePlayer]["WeaponSlot"][2] or PData[thePlayer]["WeaponSlot"][3]) then
							PData[thePlayer]["WeaponSlot"] = {MinusToPlus(x),MinusToPlus(y)}
							if(not getControlState(thePlayer, "aim_weapon")) then -- В прицеле
								useinvweapon(thePlayer)
							end
							return
						end
					end
				end
			end
		end

		PData[thePlayer]["WeaponSlot"] = false
		useinvweapon(thePlayer)
	end
end



function Drop(item, x,y,z,i,d)
	local pic = false
	if(WeaponNamesArr[item["name"]]) then
		pic = createPickup(x, y, z, 2, WeaponNamesArr[item["name"]],0, 0)
	elseif(isAmmo(item["name"])) then
		pic = createPickup(x, y, z, 3, 2061,0, 0)
	elseif(item["name"] == "Спанк") then
		pic = createPickup(x, y, z, 3, 1279, 0)
	elseif(item["name"] == "Кровь") then
		pic = createPickup(x, y, z, 3, 1580, 0)
	elseif(ItemsNamesArr[item["name"]]) then
		pic = createPickup(x, y, z, 3, ItemsNamesArr[item["name"]], 0)
	else
		if(item["name"]) then
			pic = createPickup(x, y, z, 3, 2037, 0)
		end
	end
	if(pic) then
		setElementData(pic, "arr", toJSON(item))
		setElementInterior(pic, i)
		setElementDimension(pic, d)
		setTimer(function(pic)
			if(isElement(pic)) then
				destroyElement(pic)
			end
		end, 600000, 1, pic)
	end
end



function DropHarvest(x,y,z)
	Drop({["txd"] = "Зерно", ["name"] = "Зерно"}, x,y,z,0,0)
end
addEvent("DropHarvest", true)
addEventHandler("DropHarvest", root, DropHarvest)




function NewDropItem(thePlayer, item)
	local x,y,z = getElementPosition(thePlayer)
	x,y = (x-1)+(math.random()*2), (y-1)+(math.random()*2)
	Drop(item, x, y, z, getElementInterior(thePlayer), getElementDimension(thePlayer))
end
addEvent("NewDropItem", true)
addEventHandler("NewDropItem", root, NewDropItem)





local WargangGates = {
	-- model[obj], x,y,z, rx,ry,rz, OpenX, OpenY, OpenZ, OpenRX, OpenRY, OpenRZ
	["Chinatown"] = {
		[1] = {2957, -2184.415,711.556,54.523,0,0,0, -2184.415,711.556,57.523,0,0,0},
		[2] = {2957, -2178.87,711.556,54.523,0,0,0, -2178.87,711.556,57.523,0,0,0}, 
		[3] = {3036, -2179.353,661.232,50.214,0,0,0, -2175.353,661.232,50.214,0,0,0}, 
	},
	["Ocean Docks"] = {
		[1] = {2909, 2720.623,-2504.023,13.989,0,0,0, 2720.623,-2494.023,13.989,0,0,0}, 
		[2] = {2909, 2720.623,-2405.432,13.989,0,0,0, 2720.623,-2395.432,13.989,0,0,0}, 
		[3] = {3037, 2774.361,-2493.922,14.675,0,0,0, 2774.361,-2493.922,17.675,0,0,0}, 
		[4] = {3037, 2774.361,-2455.925,14.675,0,0,0, 2774.361,-2455.925,17.675,0,0,0}, 
		[5] = {3037, 2774.361,-2417.829,14.675,0,0,0, 2774.361,-2417.829,17.675,0,0,0}, 
	}, 
}


function preLoad(name)
	setGameType("SAxVCxLC Stories")
	setElementData(root, "ChatOnline", {})
	setServerConfigSetting("ped_sync_interval", 50, true)
	Createkickstart()
	setGarageOpen(44, true) -- Наркомафия
	setGarageOpen(40, true)
	setGarageOpen(41, true)
	setGarageOpen(8, true)
	setGarageOpen(11, true)
	setGarageOpen(12, true)
	setGarageOpen(19, true)
	setGarageOpen(27, true)
	setGarageOpen(36, true)
	setGarageOpen(47, true)
	setGarageOpen(22, true) -- SF
	setGarageOpen(7, true)
	setGarageOpen(10, true)
	setGarageOpen(18, true)
	setGarageOpen(33, true)
	setGarageOpen(15, true)
	setGarageOpen(2, true)
	setGarageOpen(4, true)
	setGarageOpen(24, true)
	setGarageOpen(46, true)
	setGameSpeed(1.2)
	setMinuteDuration(1000)
	local players = getElementsByType("player") -- Даем ID
	for theKey,thePlayer in ipairs(players) do
		triggerEvent("onPlayerJoin", thePlayer)
	end


	setTime(ServerDate.hour, ServerDate.minute)
	setElementData(root, "ServerTime", ServerDate.timestamp)


	if(ServerDate.year+1900 >= 1988) then
		if(ServerDate.month >= 1) then
			DestroyDoherty()
		end
	end

	SpawnAllVehicle()
	SpawnCarForSale()
	InitDynamicBot()



	local webplay = ''
	for _, thePlayer in ipairs(getElementsByType("player")) do
		webplay = webplay..getPlayerName(thePlayer)..'<br />'
	end
	callRemote("http://109.227.228.4/engine/include/MTA/online.php", ResultGet, webplay)
	callRemote("http://109.227.228.4/engine/include/MTA/get_online.php", ResultGet)

	setTimer(function()
		for theVehicle, _ in pairs(benztimer) do
			if(isElement(theVehicle)) then
				if(getElementData(theVehicle, "Fuel")) then
					local handlingTable = getVehicleHandling(theVehicle)
					local rashod=(handlingTable["engineAcceleration"]*handlingTable["mass"])/4000000
					if(getVehicleOccupant(theVehicle)) then
						if(getControlState(getVehicleOccupant(theVehicle), "accelerate")) then
							rashod=rashod*2
						end
					end
					if(getElementData(theVehicle, "Fuel")-(rashod) <= 0) then
						setElementData(theVehicle, "Fuel", 0)
						setVehicleEngineState(theVehicle, false)
					else
						setElementData(theVehicle, "Fuel", getElementData(theVehicle, "Fuel")-(rashod))
					end
				else
					benztimer[theVehicle] = nil
				end
			else
				benztimer[theVehicle] = nil
			end
		end
	end, 500, 0)

	for name,zones in pairs(WARGANGPURE) do
		if(not WARGANG[name]) then WARGANG[name] = {} end
		local zoneowner = GetDatabaseZoneNode(name)
		if(zoneowner) then
			local r,g,b = getTeamColor(getTeamFromName(zoneowner))
			for v,k in pairs(zones) do
				WARGANG[name][#WARGANG[name]+1] = createRadarArea(WARGANGPURE[name][v][1], WARGANGPURE[name][v][2], WARGANGPURE[name][v][3], WARGANGPURE[name][v][4], r, g, b, 160)
			end
			
			if(WargangGates[name]) then
				for _, dat in pairs(WargangGates[name]) do
					dat[1] = createObject(dat[1], dat[2], dat[3], dat[4], dat[5], dat[6], dat[7])
					
					setElementData(dat[1], "gates", toJSON({dat[8], dat[9], dat[10], dat[11], dat[12], dat[13]}))
					setElementData(dat[1], "team",  toJSON({zoneowner}))
				end
			end
			

			if(SpawnPoint[name]) then
				SpawnPoint[name][6] = zoneowner
			else
				SpawnPoint[name] = {false,false,false,false,false,zoneowner}
			end
			if(VehicleSpawnPoint[name] and SData["TeamVehicle"][zoneowner]) then
				VehicleBand[name] = {}
				local VehicleCount = 1
				for v,k in pairs(VehicleSpawnPoint[name]) do
					local vehinfo = false
					if(zoneowner == "Полиция" or zoneowner == "Мирные жители") then
						local region = getZoneName(k[1], k[2], k[3], true)
						vehinfo = SData["TeamVehicle"]["Мирные жители"][region][math.random(#SData["TeamVehicle"]["Мирные жители"][region])]
					else
						if(not SData["TeamVehicle"][zoneowner][VehicleCount]) then
							VehicleCount = 1
						end
						vehinfo = SData["TeamVehicle"][zoneowner][VehicleCount]
					end

					local theVehicle = CreateVehicle(vehinfo[1], k[1], k[2], k[3]+VehicleSystem[vehinfo[1]][1], k[4], k[5], k[6])

					if(vehinfo[2]) then
						setVehiclePlateText(theVehicle, vehinfo[2])
					end

					if(vehinfo[3]) then
						if(#vehinfo[3] == 4) then
							setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4])
						else
							setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4], vehinfo[3][5], vehinfo[3][6])
						end
					end
					if(vehinfo[4]) then
						setVehicleVariant(theVehicle, vehinfo[4][1], vehinfo[4][2], vehinfo[4][3], vehinfo[4][4])
					end
					if(vehinfo[5]) then
						triggerEvent(vehinfo[5], theVehicle)
					end
					VehicleBand[name][#VehicleBand[name]+1]=theVehicle
					VehicleCount=VehicleCount+1
				end
			end
		end
	end



	local ThreesNodes = xmlNodeGetChildren(ThreesNode)
	for i,node in ipairs(ThreesNodes) do
		CreateThree(tonumber(xmlNodeGetAttribute(node, "model")), xmlNodeGetAttribute(node, "x"),xmlNodeGetAttribute(node, "y"),xmlNodeGetAttribute(node, "z"), xmlNodeGetName(node), xmlNodeGetAttribute(node, "quality"))
	end

	local HouseNodes = xmlNodeGetChildren(HouseNode)
	for i,node in ipairs(HouseNodes) do
		CreateInterior(xmlNodeGetName(node), xmlNodeGetAttribute(node, "int"), xmlNodeGetAttribute(node, "x"), xmlNodeGetAttribute(node, "y"), xmlNodeGetAttribute(node, "z"), xmlNodeGetValue(node), GetHousePrice(node), xmlNodeGetAttribute(node, "locked"))
		if(xmlNodeGetAttribute(node, "Garage")) then
			local arr = fromJSON(xmlNodeGetAttribute(node, "Garage"))
			for slot = 1, #arr do
				CreateGarage(arr[slot][1], arr[slot][2], arr[slot][3], arr[slot][4], arr[slot][5], xmlNodeGetName(node), xmlNodeGetValue(node))
			end
		end
	end

	local CarNodes = xmlNodeGetChildren(CarNode) -- tut
	for i,node in ipairs(CarNodes) do
		local v = CreateVehicle(tonumber(xmlNodeGetAttribute(node, "vmodel")), xmlNodeGetAttribute(node, "vx"), xmlNodeGetAttribute(node, "vy"), xmlNodeGetAttribute(node, "vz"), xmlNodeGetAttribute(node, "vrx"), xmlNodeGetAttribute(node, "vry"), xmlNodeGetAttribute(node, "vrz"), xmlNodeGetValue(node), true, 0, 0)
		setVehicleColor(v, xmlNodeGetAttribute(node, "vc1"), xmlNodeGetAttribute(node, "vc2"), xmlNodeGetAttribute(node, "vc3"), xmlNodeGetAttribute(node, "vc4"))
		setElementData(v, "owner", xmlNodeGetValue(node))
		setElementData(v, "year", xmlNodeGetAttribute(node, "year"))
		setElementData(v, "x", xmlNodeGetAttribute(node, "vx"), false)
		setElementData(v, "y", xmlNodeGetAttribute(node, "vy"), false)
		setElementData(v, "z", xmlNodeGetAttribute(node, "vz"), false)
		setElementData(v, "i", xmlNodeGetAttribute(node, "i"), false)
		setElementData(v, "d", xmlNodeGetAttribute(node, "d"), false)
		setElementInterior(v, xmlNodeGetAttribute(node, "i"))
		setElementDimension(v, xmlNodeGetAttribute(node, "d"))
		if(xmlNodeGetAttribute(node, "gx")) then
			setElementData(v, "gx", xmlNodeGetAttribute(node, "gx"), false)
			setElementData(v, "gy", xmlNodeGetAttribute(node, "gy"), false)
			setElementData(v, "gz", xmlNodeGetAttribute(node, "gz"), false)
			setElementData(v, "grz", xmlNodeGetAttribute(node, "grz"), false)
		end
		if(xmlNodeGetAttribute(node, "upgrades")) then
			local upgr = fromJSON(xmlNodeGetAttribute(node, "upgrades"))
			for upgradeKey, upgradeValue in ipairs (upgr) do addVehicleUpgrade(v, upgradeValue) end
		end


		if(xmlNodeGetAttribute(node, "vinyl")) then
			setVehiclePaintjob(v, xmlNodeGetAttribute(node, "vinyl"))
		end
		if(xmlNodeGetAttribute(node, "siren")) then setElementData(v, "siren", xmlNodeGetAttribute(node, "siren")) end
		if(xmlNodeGetAttribute(node, "trunk")) then setElementData(v, "trunk", xmlNodeGetAttribute(node, "trunk")) end


		local comp = fromJSON(xmlNodeGetAttribute(node, "handl"))
		UpdateVehicleHandling(v, comp)
	end



	local bizNode = xmlNodeGetChildren(BizNode)
	for c,node in ipairs(bizNode) do
		local NodeName = xmlNodeGetName(node)
		if(xmlNodeGetAttribute(node, "xyz")) then
			local x,y,z,i,d = fromJSON(xmlNodeGetAttribute(node, "xyz"))
			BusinessPickup[NodeName] = createPickup(x,y,z, 3, 1274, 0)
			if(xmlNodeGetAttribute(node, "owner") ~= "") then
				setElementData(BusinessPickup[NodeName], "bizowner", xmlNodeGetAttribute(node, "owner"))
			end
			if(i) then setElementInterior(BusinessPickup[NodeName], i) end
			if(d) then setElementDimension(BusinessPickup[NodeName], d) end
			setElementData(BusinessPickup[NodeName], "biz", BizInfo[NodeName][2])
			setElementData(BusinessPickup[NodeName], "price", xmlNodeGetAttribute(node, "price"), false)
			setElementData(BusinessPickup[NodeName], "name", NodeName)
			setElementData(BusinessPickup[NodeName], "money", xmlNodeGetAttribute(node, "money"))
		end


		local arr = xmlNodeGetAttribute(node, "var")

		if(arr) then
			arr = fromJSON(arr)
			if(arr["lvl"]) then
				BizInfo[NodeName][4] = arr["lvl"]
			end
		end

		BizControls[NodeName] = {}
	end

	UpdateProductCost()
	UpdateVacancyList()
	StartMP()


	-- Пешеходы
	local CountRandomBot = 500
	local availzones = {}
	for name, dat in pairs(PedNodes) do
		for _, dat2 in pairs(dat) do
			for slot = 1, dat2[4]-dat2[1]+dat2[5]-dat2[2] do
				availzones[#availzones+1] = dat2
			end
		end
	end
	
	for slot = 1, CountRandomBot do
		local rand = math.random(#availzones)
		local randx = math.random(availzones[rand][1], availzones[rand][4])
		local randy = math.random(availzones[rand][2], availzones[rand][5])
		local randz = GetZCoord(randx, randy, availzones[rand])+1
	
		local rot = availzones[rand][7]
		local randrot = math.random(1,2)
		if(randrot == 1) then rot = rot+180 end
		CreateRandomBot(randx,randy,randz,rot,nil,nil, getZoneName(randx,randy,randz, false))
		table.remove(availzones, rand)
	end

	setTimer(worldtime, 1000, 0)
end
addEventHandler("onResourceStart", getResourceRootElement(), preLoad)


function GetZCoord(x,y,dat)
	local z = dat[6]
	if(dat[7] >= 135 and dat[7] <= 225 or dat[7] <= 45 or dat[7] >= 315) then
		local razy = dat[5]-y
		local maxy = dat[5]-dat[2]
		local razz = dat[6]-dat[3]
		z = z-(razz*(razy/maxy))
	else
		local razx = dat[4]-x
		local maxx = dat[4]-dat[1]
		local razz = dat[6]-dat[3]
		z = z-(razz*(razx/maxx))
	end
	return z
end






function CreateBot(skin,x,y,z,rz,i,d,zone,ind)
	if(not BotCreated[zone]) then BotCreated[zone] = {} end

	if(not ind) then ind = #BotCreated[zone]+1 end
	if(not rz) then rz = math.random(0,360) end
	BotCreated[zone][ind] = createPed(skin, x, y, z, rz, true)
	setElementData(BotCreated[zone][ind], "TINF", toJSON({zone,ind,x,y,z,rz}))
	setElementData(BotCreated[zone][ind], "team", getTeamName(SkinData[skin][2]))

	setPedWalkingStyle(BotCreated[zone][ind], SkinData[skin][1])
	if(i) then setElementInterior(BotCreated[zone][ind], i) end
	if(d) then setElementDimension(BotCreated[zone][ind], d) end

	local name = SkinData[skin][3]
	if(SkinData[skin][6]) then
		name = SkinData[skin][6][math.random(#SkinData[skin][6])]
	end

	local botinv = {}
	if(SkinData[skin][4]) then
		botinv[#botinv+1] = {["txd"] = FoundWName(SkinData[skin][4]), ["name"] = FoundWName(SkinData[skin][4])}
		giveWeapon(BotCreated[zone][ind], SkinData[skin][4], 9999, true)
	end

	local randitem = math.random(20)

	if(randitem == 1) then
		if(SkinData[skin][2] == Teams['Мирные жители']) then
			botinv[#botinv+1] = {["txd"] = "Пакет", ["name"] = "Пакет"}
			name=name.." с пакетом"
		end
	elseif(randitem == 2) then
		if(SkinData[skin][2] == Teams['Мирные жители']) then
			botinv[#botinv+1] = {["txd"] = "Чемодан", ["name"] = "Чемодан"}
			name=name.." с чемоданом"
		end
	elseif(randitem == 3) then
		if(SkinData[skin][3] == "Мужчина") then
			name="Пьяный "..utf8.lower(name)
		elseif(SkinData[skin][3] == "Женщина") then
			name="Пьяная "..utf8.lower(name)
		end

		local DrunkObj = {1543, 1544, 1669, 1950, 1951}
		setElementData(BotCreated[zone][ind], "armasplus", toJSON({[DrunkObj[math.random(#DrunkObj)]] = true}))
		setPedWalkingStyle(BotCreated[zone][ind], 126)
	elseif(randitem == 4) then
		name=name.." с сигаретой"
		setElementData(BotCreated[zone][ind], "armasplus", toJSON({[3027] = true}))
	end


	setElementData(BotCreated[zone][ind], "inv", toJSON({botinv}))
	setElementData(BotCreated[zone][ind], "name", name)
	return BotCreated[zone][ind]
end


function CreateRandomBot(x,y,z,rz,i,d,zone,ind)
	local skin = 299

	local team = GetDatabaseZoneNode(zone)
	if(not team) then team = "Полиция" end


	local rand = math.random(1,4)
	if(rand > 1) then
		team = "Мирные жители"
	end

	if(BotSkin[team]) then
		skin = BotSkin[team][math.random(#BotSkin[team])]
	end

	if(BotSkinSpecific[team]) then
		if(BotSkinSpecific[team][ZonesRegion[zone]]) then
			if(BotSkinSpecific[team][ZonesRegion[zone]][zone]) then
				skin = BotSkinSpecific[team][ZonesRegion[zone]][zone][math.random(#BotSkinSpecific[team][ZonesRegion[zone]][zone])]
			else
				if(BotSkinSpecific[team][ZonesRegion[zone]]["all"]) then
					skin = BotSkinSpecific[team][ZonesRegion[zone]]["all"][math.random(#BotSkinSpecific[team][ZonesRegion[zone]]["all"])]
				end
			end
		end
	end
	return CreateBot(skin,x,y,z,rz,i,d,zone,ind)
end






function WastedPed(totalAmmo, killer, weapon, bodypart, stealth)
	local x,y,z = getElementPosition(source)
	if(getElementData(source, "CurNode")) then
		local dat = fromJSON(getElementData(source, "CurNode"))
		PathNodes[dat[1]][dat[2]][1] = true
	end

	if(RobPresure[source]) then
		StopRob(false, source)
	end
	if(killer) then
		if(getElementType(killer) == "player") then
			local PTeam = getElementData(source, "team")
			local KTeam = getTeamName(getPlayerTeam(killer))

			if(WeaponModel[weapon][2]) then
				AddSkill(killer, WeaponModel[weapon][2])
			end
			local dropWeapon = getPedWeapon(source)
			if(WeaponModel[dropWeapon][1]) then
				local weaponName = FoundWName(dropWeapon)
				if(weaponName) then
					local pic = createPickup(x+((math.random(-1000,1000))/1000), y+((math.random(-1000,1000)/1000)), z, 2, dropWeapon,0, 0)
					if(WeaponAmmo[dropWeapon]) then
						setElementData(pic, "arr", toJSON({["txd"] = weaponName, ["name"] = weaponName, ["quality"] = math.random(0,600), [WeaponAmmo[dropWeapon]] = {["txd"] = WeaponAmmo[dropWeapon], ["name"] = WeaponAmmo[dropWeapon], ["quality"] = 450, ["count"] = math.random(1,100)}}))
					else
						setElementData(pic, "arr", toJSON({["txd"] = weaponName, ["name"] = weaponName, ["quality"] = math.random(0,600)}))
					end
					setElementDimension(pic, getElementDimension(source))
					setElementInterior(pic, getElementInterior(source))
					setTimer(function(pic)
						if(isElement(pic)) then
							destroyElement(pic)
						end
					end, 30000, 1, pic)
				end
			end
			if(PTeam) then
				if(PTeam == "Мирные жители") then
					Respect(killer, "civilian", -1)
					WantedLevel(killer, 1)
					local randmoney = math.random(-4,8)
					local amount = math.random(1000)
					if(randmoney > 0) then
						for i = 1, randmoney do
							local p = createPickup(x+((math.random(-1000,1000))/1000), y+((math.random(-1000,1000)/1000)), z, 3, 1212)
							setElementData(p, "arr", toJSON({["txd"] = "Деньги", ["name"] = "Деньги", ["count"] = amount}))
						end
					end
				elseif(PTeam == "Баллас" or PTeam == "Колумбийский картель" or PTeam == "Русская мафия") then
					Respect(killer, "grove", 1)
					Respect(killer, "ballas", -1)
				elseif(PTeam == "Гроув-стрит" or PTeam == "Триады" or PTeam == "Ацтекас") then
					Respect(killer, "grove", -1)
					Respect(killer, "ballas", 1)
					Respect(killer, "vagos", 1)
				elseif(PTeam == "Вагос" or PTeam == "Якудзы" or PTeam == "Рифа") then
					Respect(killer, "vagos", -1)
					Respect(killer, "grove", 1)
				elseif(getTeamGroup(PTeam) == "Официалы") then
					Respect(killer, "ugol", 3)
					Respect(killer, "police", -3)
					Respect(killer, "civilian", -3)
					WantedLevel(killer, 1)
				elseif(PTeam == "Уголовники" and KTeam == "Уголовники") then
					Respect(killer, "ugol", 1)
					SetDatabaseAccount(killer, "PrisonTime", GetDatabaseAccount(killer, "PrisonTime")+100)
					MissionCompleted(killer, "СРОК +", "ПЛОХОЕ ПОВЕДЕНИЕ")
				elseif(PTeam == "Деревенщины" and KTeam == "Деревенщины") then
					Respect(killer, "ugol", 1)
					WantedLevel(killer, 1)
				elseif(PTeam == "Байкеры" and KTeam == "Байкеры") then
					Respect(killer, "ugol", 1)
					WantedLevel(killer, 1)
				end
			end
		end
	end
	setTimer(function(ped)
		if(isElement(ped)) then
			if(getElementData(ped, "SpawnBlock")) then
				destroyElement(ped)
			else
				local TINF = getElementData(ped, "TINF")
				local i, d = getElementInterior(ped), getElementDimension(ped)
				if(TINF) then
					TINF = fromJSON(TINF)
					if(tostring(TINF)) then
						local data = getAllElementData(ped)
						data["anim"] = nil
						local x,y,z = getElementPosition(ped)
						local _,_,rz = getElementRotation(ped)
						local model = getElementModel(ped)
						destroyElement(ped)
						ped = createPed(model,x,y,z,rz, true)
						setElementInterior(ped, i)
						setElementDimension(ped, d)
						for k, v in pairs (data) do
							if(k ~= "attacker") then
								setElementData(ped, k, v)--tut2
							end
						end
					else
						destroyElement(BotCreated[zone][TINF[2]])
						CreateRandomBot(TINF[3], TINF[4], TINF[5],TINF[6],i,d,TINF[1],TINF[2])
					end
				end
			end
		end
	end, 20000, 1, source)
end
addEvent("OnPedWasted", true)
addEventHandler("onPedWasted", root, WastedPed)





local Dialogs = {
	["FARM FR"] = {
		[1] = {
			["dialog"] = {"Здарова"},
			[1] = {
				["text"] = "Я по делу",
				["action"] = {"StartLookBiz", {"FARMFR", "otdelK"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Охранник LV Airport"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Как попасть в аэропорт?",
				["next"] = {
					["dialog"] = {"Никак"},
					[1] = {
						["text"] = "[промолчать]"
					},
				}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Охранник SF Airport"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Как попасть в аэропорт?",
				["next"] = {
					["dialog"] = {"Никак"},
					[1] = {
						["text"] = "[промолчать]"
					},
				}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Охранник LS Airport"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Как попасть в аэропорт?",
				["next"] = {
					["dialog"] = {"Никак"},
					[1] = {
						["text"] = "[промолчать]"
					},
				}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["SF Kung FU"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу научиться Kung FU",
				["action"] = {"fightstyle", {6}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["GROTTI"] = {
		[1] = {
			["dialog"] = {"Здарова"},
			[1] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["empty"] = {
		[1] = {
			["dialog"] = {"..."},
			[1] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Club Malibu"] = {
		[1]  = {
			["dialog"] = {"бочка, бас, колбасит соло"}
		}
	},
	["MER LV"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"MERLV", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	["MERIA Las Venturas"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Кто мэр Las Venturas?",
				["action"] = {"WhoBizOwner", {"MERLV"}}
			},
			[2] = {
				["text"] = "Когда будут выборы?",
				["action"] = {"WhoBizOwner", {"MERLV", true}}
			},
			[3] = {
				["text"] = "До свидания"
			}
		},
	},
	["MER SF"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"MERSF", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	["MERIA San Fierro"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Кто мэр San Fierro?",
				["action"] = {"WhoBizOwner", {"MERSF"}}
			},
			[2] = {
				["text"] = "Когда будут выборы?",
				["action"] = {"WhoBizOwner", {"MERSF", true}}
			},
			[3] = {
				["text"] = "До свидания"
			}
		},
	},
	["MER LS"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"MERLS", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	
	["Airport"] = {
		[1] = {
			["dialog"] = {"Какой рейс вас интересует?"},
			[1] = {
				["text"] = "San Andreas",
				["action"] = {"Travel", {"San Andreas"}}
			},
			[2] = {
				["text"] = "Vice City",
				["action"] = {"Travel", {"Vice City"}}
			},
			[3] = {
				["text"] = "Liberty City",
				["action"] = {"Travel", {"Liberty City"}}
			},
			[4] = {
				["text"] = "Никакой"
			}
		},
	},
	
	["MERIA Los Santos"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Кто мэр Los Santos?",
				["action"] = {"WhoBizOwner", {"MERLS"}}
			},
			[2] = {
				["text"] = "Когда будут выборы?",
				["action"] = {"WhoBizOwner", {"MERLS", true}}
			},
			[3] = {
				["text"] = "До свидания"
			}
		},
	},
	["RCPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PRCPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Кто шериф округа Red County",
				["action"] = {"WhoBizOwner", {"PRCPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["TRPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PTRPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Кто шериф El Quebrados",
				["action"] = {"WhoBizOwner", {"PTRPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["BCPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PBCPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Кто шериф округа Bone County?",
				["action"] = {"WhoBizOwner", {"PBCPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["WSPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PWSPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Кто шериф Angel Pine?",
				["action"] = {"WhoBizOwner", {"PWSPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["LVPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PLVPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	["LVPD"] = {
		[1] = {
			["dialog"] = {"Есть вопросы?"},
			[1] = {
				["text"] = "Я хочу работать у вас",
				["action"] = {"StartLookBiz", {"PLVPD", "otdelK"}}
			},
			[2] = {
				["text"] = "Кто начальник LVPD?",
				["action"] = {"WhoBizOwner", {"PLVPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["SFPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PSFPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	["SFPD"] = {
		[1] = {
			["dialog"] = {"Есть вопросы?"},
			[1] = {
				["text"] = "Я хочу работать у вас",
				["action"] = {"StartLookBiz", {"PSFPD", "otdelK"}}
			},
			[2] = {
				["text"] = "Кто начальник SFPD?",
				["action"] = {"WhoBizOwner", {"PSFPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["LSPD BIZ"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Покажи мне список рабочих",
				["action"] = {"StartLookBiz", {"PLSPD", "nachalnik"}}
			},
			[2] = {
				["text"] = "Нет"
			}
		},
	},
	["LSPD"] = {
		[1] = {
			["dialog"] = {"Есть вопросы?"},
			[1] = {
				["text"] = "Я хочу работать у вас",
				["action"] = {"StartLookBiz", {"PLSPD", "otdelK"}}
			},
			[2] = {
				["text"] = "Кто начальник LSPD?",
				["action"] = {"WhoBizOwner", {"PLSPD"}}
			},
			[3] = {
				["text"] = "Нет"
			}
		},
	},
	["Телефон"] = {
		[1] = {
			["dialog"] = {" "},
			[1] = {
				["text"] = "[Набрать номер]",
				["action"] = {"StartClientEvent", {"CallPhoneInput"}},

			},
			[2] = {
				["text"] = "[Убрать]"
			}
		}
	},
	["Игрок МЧС"] = {
		[1] = {
			["dialog"] = {" "},
			[1] = {
				["text"] = "[Вылечить]",
				["action"] = {"MCHSEventHealth", {}}
			},
			[2] = {
				["text"] = "[Выразить уважение]",
				["action"] = {"UpReputation", {}}
			},
			[3] = {
				["text"] = "[Понизить уважение]",
				["action"] = {"DownReputation", {}}

			},
			[4] = {
				["text"] = "[ничего не делать]"
			}
		},
		[2] = {
			["dialog"] = {" "},
			[1] = {
				["text"] = "[Взять кровь]",
				["action"] = {"MCHSEventHealth", {}}
			},
			[2] = {
				["text"] = "[ничего не делать]"
			}
		},
	},
	["Игрок полиция"] = {
		[1] = {
			["dialog"] = {" "},
			[1] = {
				["text"] = "[Арестовать]",
				["action"] = {"PoliceArrest", {}}
			},
			[2] = {
				["text"] = "[ничего не делать]"
			}
		}
	},
	["Игрок в корячке"] = {
		[1] = {
			["dialog"] = {" "},
			[1] = {

				["text"] = "[Раздеть]",
				["action"] = {"razd", {}}
			},
			[2] = {
				["text"] = "[Изнасиловать]",
				["action"] = {"iznas", {}}
			},
			[3] = {
				["text"] = "[Дать в рот]",
				["action"] = {"blowjob", {}}
			},
			[4] = {
				["text"] = "[Выебать]",
				["action"] = {"iznas2", {}}
			},
			[5] = {
				["text"] = "[Выебать раком]",
				["action"] = {"iznas3", {}}
			},
			[6] = {
				["text"] = "[ничего не делать]"
			}
		}
	},
	["Игрок обычный"] = {
		[1] = {
			["dialog"] = {" "},
			[1] = {
				["text"] = "[Выразить уважение]",
				["action"] = {"UpReputation", {}}
			},
			[2] = {
				["text"] = "[Понизить уважение]",
				["action"] = {"DownReputation", {}}

			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Рифа"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в банду Рифа",
				["action"] = {"BandInvite", {"Рифа"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Деревенщины"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу стать Деревенщиной",
				["action"] = {"BandInvite", {"Деревенщины"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Якудзы"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Якудзы",
				["action"] = {"BandInvite", {"Якудзы"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Триады"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Триады",
				["action"] = {"BandInvite", {"Триады"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Ацтекас"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Ацтекас",
				["action"] = {"BandInvite", {"Ацтекас"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Русская мафия"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Русскую мафию",
				["action"] = {"BandInvite", {"Русская мафия"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Байкеры"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу присоедениться к Байкерам",
				["action"] = {"BandInvite", {"Байкеры"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Колумбийский картель"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Колумбийский картель",
				["action"] = {"BandInvite", {"Колумбийский картель"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Вагос"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в Вагос",
				["action"] = {"BandInvite", {"Вагос"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Гроув-стрит"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в гроув-стрит",
				["action"] = {"BandInvite", {"Гроув-стрит"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		},
		[2] = {
			["dialog"] = {"эй брат"},
			[1] = {
				["text"] = "Чего тебе?",
				["next"] = {
					["dialog"] = {"Займи деньжат ($150)"},
					[1] = {
						["text"] = "Держи",
						["action"] = {"DialogMoney", {-150, "grove"}},
						["end"] = {"Спасибо друг"}
					},
					[2] = {
						["text"] = "Отвали!",
						["end"] = {"пфф..."},
						["action"] = {},
						["timer"] = 5000
					}
				}
			},
			[2] = {
				["text"] = "Не брат ты мне, гнида черножопая!"
			},
			[3] = {
				["text"] = "[промолчать]",
				["timer"] = 5000
			}
		}
	},
	["Баллас"] = {
		[1] = {
			["dialog"] = {"Чего тебе?"},
			[1] = {
				["text"] = "Я хочу вступить в баллас",
				["action"] = {"BandInvite", {"Баллас"}}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		},
		[2] = {
			["dialog"] = {"эй брат"},
			[1] = {
				["text"] = "Чего тебе?",
				["next"] = {
					["dialog"] = {"Займи на пивас ($100)"},
					[1] = {
						["text"] = "Держи",
						["action"] = {"DialogMoney", {-100, "ballas"}},
						["end"] = {"Спасибо друг"}
					},
					[2] = {
						["text"] = "Отвали!",
						["end"] = {"тварь..."},
						["action"] = {},
						["timer"] = 5000
					}
				}
			},
			[2] = {
				["text"] = "Не брат ты мне, гнида черножопая!"
			},
			[3] = {
				["text"] = "[промолчать]",
				["timer"] = 5000
			}
		}
	},
	["Полиция"] = {
		[1] = {
			["dialog"] = {"Да?", "Всё в порядке?", "Я вас слушаю"},
			[1] = {
				["text"] = "Я хочу работать в полиции",
				["action"] = {"GPSFoundShop", {"marker", "name", "Полицейский участок Los Santos", "Полицейский участок"}},
				["end"] = {"не благодари"},
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Бабка"] = {
		[1] = {
			["dialog"] = {"наркоман наверное", "вот я в твои годы", "куда катится мир", "какая молодежь пошла"}
		}
	},
	["Haruhi Suzumiya"] = {
		[1] = {
			["dialog"] = {"Отвали!"},
			[1] = {
				["text"] = "Почему так грубо?",
				["next"] = {
					["dialog"] = {"Меня не интересуют обычные люди! только пришельцы, гости из будущего, телепаты"},
					[1] = {
						["text"] = "Почему ты повернута на чем-то нечеловеческом?",
						["next"] = {
							["dialog"] = {"Потому что так интересней! разве нет!?"},
							[1] = {
								["text"] = "[промолчать]"
							}
						}
					},
					[2] = {
						["text"] = "Я не обычный человек!",
						["next"] = {
							["dialog"] = {"тогда кто ты?"},
							[1] = {
								["text"] = "Экстрасенс",
								["end"] = {"Отвали!"}
							},
							[2] = {
								["text"] = "Телепат",
								["end"] = {"Отвали!"}
							},
							[3] = {
								["text"] = "Я из будущего",
								["end"] = {"Отвали!"}
							},
							[4] = {
								["text"] = "[промолчать]",
								["timer"] = 5000
							}
						}
					},
					[3] = {
						["text"] = "[промолчать]",
						["timer"] = 5000
					}
				}
			},
			[2] = {
				["text"] = "[пройти мимо]",
				["timer"] = 5000
			}
		}
	},
	["Zip"] = {
		[1] = {
			["dialog"] = {"Шесть этажей лохмотьев!"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Справа от вас гардероб, в нем вы можете посмотреть ассортимент"}
			},
			[2] = {
				["text"] = "Я хочу купить аксессуары",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Zip"], ""}}},
			},
			[3] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Мы продаем недорогую одежду для отдыха"}
			},

			[4] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[5] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["ProLaps"] = {
		[1] = {
			["dialog"] = {"Усердно тренироваться!"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Слева от вас гардероб, в нем вы можете примерить одежду"}
			},
			[2] = {
				["text"] = "Я хочу купить снаряжение",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["ProLaps"], ""}}},
			},
			[3] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Мы продаем спортивную одежду и снаряжение"}
			},

			[4] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[5] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Didier Sachs"] = {
		[1] = {
			["dialog"] = {"Высокая мода для высоких людей"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Справа от вас гардероб, в нем вы можете примерить одежду"}
			},
			[2] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Мы продаем элитную одежду для тех, кто готов потратить много денег, чтобы скрыть свои недостатки. Мода еще никогда не стоила так дорого"}
			},
			[3] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[4] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Victum"] = {
		[1] = {
			["dialog"] = {"Умереть для"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Справа от вас гардероб, в нем вы можете примерить одежду"}
			},
			[2] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Если Вы не выборочная жертва, то Victim магазин для вас. Замечательный розничный магазин, где люди могут повысить свою самооценку, благодаря огромному спектру модельер одежды"}
			},
			[3] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[4] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["SubUrban"] = {
		[1] = {
			["dialog"] = {"Хочешь быть рэпером, но живёшь в пригороде и сидишь на шее у мамы?"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Справа от вас гардероб, в нем вы можете примерить одежду"}
			},
			[2] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Мы продаем пригородную одежду и снаряжение"}
			},
			[3] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[4] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Binco"] = {
		[1] = {
			["dialog"] = {"Больше хлама за меньшие бабки!"},
			[1] = {
				["text"] = "Я хочу купить одежду",
				["end"] = {"Справа от вас гардероб, в нем вы можете примерить одежду"}
			},
			[2] = {
				["text"] = "Я хочу купить аксессуары",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Binco"], ""}}},
			},
			[3] = {
				["text"] = "Какую одежду вы продаете?",
				["end"] = {"Мы продаем секонд-хенд одежду"}
			},

			[4] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[5] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Ammo Shop 1"] = {
		[1] = {
			["dialog"] = {"Да?", "Выбрал?", "Ну?", "Будешь что-то брать?", "Защищай свои права!"},
			[1] = {
				["text"] = "Хочу купить оружие",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["AMMO1"], "AMMOLS"}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Ammo Shop 2"] = {
		[1] = {
			["dialog"] = {"Да?", "Выбрал?", "Ну?", "Будешь что-то брать?", "Защищай свои права!"},
			[1] = {
				["text"] = "Да",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["AMMO2"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Ammo Shop 3"] = {
		[1] = {
			["dialog"] = {"Да?", "Выбрал?", "Ну?", "Будешь что-то брать?", "Защищай свои права!"},
			[1] = {
				["text"] = "Показывай товар",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["AMMO3"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Ammo Shop 4"] = {
		[1] = {
			["dialog"] = {"Да?", "Выбрал?", "Ну?", "Будешь что-то брать?", "Защищай свои права!"},
			[1] = {
				["text"] = "Да",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["AMMO4"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Electronics Shop"] = {
		[1] = {
			["dialog"] = {"Говорите"},
			[1] = {
				["text"] = "Покажите что у вас есть в наличии",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Electronics Shop"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Sex Shop"] = {
		[1] = {
			["dialog"] = {"Да?"},
			[1] = {
				["text"] = "Я хочу посмотреть на ассортимент",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Sex Shop"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Bait Shop"] = {
		[1] = {
			["dialog"] = {"Интересует что-то?"},
			[1] = {
				["text"] = "Показывай что у тебя есть",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Bait Shop"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["BANLS"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу посмотреть свой счет",
				["action"] = {"BankEvent", {"BANLS"}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["BANLV"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу посмотреть свой счет",
				["action"] = {"BankEvent", {"BANLV"}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["BANTR"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу посмотреть свой счет",
				["action"] = {"BankEvent", {"BANTR"}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["BANSF"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу посмотреть свой счет",
				["action"] = {"BankEvent", {"BANSF"}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["BANBC"] = {
		[1] = {
			["dialog"] = {"Здравствуйте"},
			[1] = {
				["text"] = "Я хочу посмотреть свой счет",
				["action"] = {"BankEvent", {"BANBC"}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Liquor Shop"] = {
		[1] = {
			["dialog"] = {"Я вас категорически приветствую!"},
			[1] = {
				["text"] = "Показывай что у тебя есть",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["Liquor Shop"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Стриптизерша"] = {
		[1] = {
			["dialog"] = {"[отводит взгляд]"},
			[1] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Cluckin' Bell"] = {
		[1] = {
			["dialog"] = {"Cluckin' Bell: Страдание ещё никогда не было таким вкусным!", "Здравствуйте", "Кукареку – время для курицы!", "Кукареку – время пировать!", "Съешь баскет из девяноста крылышек, и по тебе будет видно: Он был в Cluckin' Bell!"}, 
			[1] = {
				["text"] = "Бургер с курицей ($25)",
				["action"] = {"EatCluckin", {"Cluckin' Bell", -25}},
				["end"] = {"Приходите к нам еще", "Если вам понравилось - цыпленок умер не напрасно!"}
			},
			[2] = {
				["text"] = "Расскажите, как вы готовите курицу?",
				["next"] = {
					["dialog"] = {"Мы сворачиваем их головы и быстро разводим, Шесть крыльев, сорок грудок - и на газ!"},
					[1] = {
						["text"] = "Но это же так жестоко",
						["end"] = {"Курица – птица с крошечным мозгом, Поэтому мы можем сказать, что она совсем не чувствует боли."}
					},
					[2] = {
						["text"] = "[промолчать]",
						["action"] = {},
						["timer"] = 5000
					}
				}
			},
			[3] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[4] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Burger Shot"] = {
		[1] = {
			["dialog"] = {"Здравствуйте", "Умри с улыбкой на лице!", "Убей свой ​​голод!", "Это кровотеченски вкусно!"},
			[1] = {
				["text"] = "Гамбургер Bleeder",
				["action"] = {"EatCluckin", {"Burger Shot", -3}},
				["end"] = {"Всегда рады вам"}
			},
			[2] = {
				["text"] = "Огромный гамбургер Heart Stopper",
				["action"] = {"EatCluckin", {"Burger Shot", -6}},
				["end"] = {"Всегда рады вам"}
			},
			[3] = {
				["text"] = "Гамбургер Money Shot Meal",
				["action"] = {"EatCluckin", {"Burger Shot", -6}},
				["end"] = {"Всегда рады вам"}
			},
			[4] = {
				["text"] = "Гамбургер Torpedo Meal",
				["action"] = {"EatCluckin", {"Burger Shot", -6}},
				["end"] = {"Всегда рады вам"}
			},
			[5] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[6] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["The Well Stacked Pizza Co."] = {
		[1] = {
			["dialog"] = {"Чего желаете?"},
			[1] = {
				["text"] = "Пицца <Двойной люкс> ($35)",
				["action"] = {"EatCluckin", {"The Well Stacked Pizza Co.", -35}},
				["end"] = {"Приятного аппетита"}
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Chilli Dogs"] = {
		[1] = {
			["dialog"] = {"Буррито всего 10$"},
			[1] = {
				["text"] = "Беру",
				["action"] = {"EatCluckin", {"Chilli Dogs", -10}},
				["end"] = {"Приятного аппетита"}
			},
			[2] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["24/7"] = {
		[1] = {
			["dialog"] = {"я вас слушаю"},
			[1] = {
				["text"] = "Я хочу кое что купить",
				["action"] = {"TradePlayerWindow", {{ItemsTrade["24/7"], ""}}},
			},
			[2] = {
				["text"] = "[ограбить]",
				["action"] = {"RobShop", {}},
			},
			[3] = {
				["text"] = "[промолчать]"
			}
		}
	},
	["Мирные жители"] = {
		[1] = {
			["dialog"] = {"Вам чем нибудь помочь?", "а?", "Ты что-то хочешь?", "Заблудился?"},
			[1] = {
				["text"] = "Где поблизости есть магазин?",
				["action"] = {"GPSFoundShop", {"marker", "name", "24/7", "Местный магазин"}},
				["end"] = {"не благодари"},
			},
			[2] = {
				["text"] = "Где поблизости можно заправиться?",
				["action"] = {"GPSFoundShop", {"marker", "type", "PetrolFuelCol", "Местная заправка"}},
				["end"] = {"не благодари"}
			},
			[3] = {
				["text"] = "Где можно найти работу?",
				["action"] = {"GPSFoundShop", {"vehicle", "type", "jobtruck", "База грузоперевозок"}},
				["end"] = {"знаю только базу дальнобойщиков неподалёку"}
			},
			[4] = {
				["text"] = "Как тут играть?",
				["next"] = {
					["dialog"] = {"Сервер еще находится в разработке"},
					[1] = {
						["text"] = "ОК",
					},
					[2] = {
						["text"] = "[заплакать]",
						["end"] = {"ска лол"},
						["timer"] = 5000
					}
				}
			},
			[5] = {
				["text"] = "[промолчать]",
				["end"] = {"Как хотите"},
				["timer"] = 5000,
			}
		},
		[2] = {
			["dialog"] = {"эй ты"},
			[1] = {
				["text"] = "Что?",
				["next"] = {
					["dialog"] = {"Займи на пузырь ($100)"},
					[1] = {
						["text"] = "Держи",
						["action"] = {"DialogMoney", {-100, "civilian"}},
						["end"] = {"Спасибо друг"}
					},
					[2] = {
						["text"] = "Отвали!",
						["end"] = {"козел..."},
						["action"] = {},
						["timer"] = 5000
					}
				}
			},
			[2] = {
				["text"] = "[игнорировать]",
				["timer"] = 5000
			}
		}, 
	}
}

function GPSFoundShop(thePlayer, thePed, bytype, varname, varval, name)
	triggerClientEvent(thePlayer, "GPSFoundShop", thePlayer, bytype, varname, varval, name)
end
addEvent("GPSFoundShop", true)
addEventHandler("GPSFoundShop", getRootElement(), GPSFoundShop)


function StartClientEvent(thePlayer, thePed, event)
	triggerClientEvent(thePlayer, event, thePlayer)
end
addEvent("StartClientEvent", true)
addEventHandler("StartClientEvent", getRootElement(), StartClientEvent)




function DialogMoney(thePlayer, thePed, count, team)
	AddPlayerMoney(thePlayer, count)
	Respect(thePlayer, team, 1)
end
addEvent("DialogMoney", true)
addEventHandler("DialogMoney", getRootElement(), DialogMoney)




function TradePlayerWindow(thePlayer, thePed, arg)
	local TradeArr = {}
	for _, item in pairs(arg[1]) do
		TradeArr[#TradeArr+1] = {
			["txd"] = item[1],
			["name"] = item[1],
			["quality"] = item[3],
			["ForSale"] = true,
			["Biz"] = arg[2]
		}
	end

	triggerClientEvent(thePlayer, "TradeWindow", thePlayer, TradeArr, arg[2])
end
addEvent("TradePlayerWindow", true)
addEventHandler("TradePlayerWindow", getRootElement(), TradePlayerWindow)




local BannedSkin = {
	[77] = true, 
	[78] = true, 
	[79] = true, 
	[145] = true, 
	[212] = true, 
	[213] = true, 
	[230] = true, 
	[239] = true, 
	[252] = true, 
	[264] = true, 
}

function BandInvite(thePlayer, thePed, arg)
	if(BannedSkin[getElementModel(thePlayer)]) then
		triggerClientEvent(thePlayer, "PlayerDialog", thePlayer, false, thePed, "Если кто-то выглядит как черт, ходит как черт и разговаривает как черт, то это, вероятно, и есть черт")
		HelpMessage(thePlayer, "Для вступления в "..RGBToHex(getTeamColor(getTeamFromName(arg)))..arg.."\n#FFFFFFНужно быть одетым по приличнее")	
		return false
	end
	
	
	
	if(arg == "Триады" or arg == "Колумбийский картель" or arg == "Полиция") then
		if(GetDatabaseAccount(thePlayer, "ATUT") ~= 3) then
			triggerClientEvent(thePlayer, "PlayerDialog", thePlayer, false, thePed, "Для вступления в "..arg.." тебе нужно сначала отлужить в армии")
			HelpMessage(thePlayer, "Для вступления в армию\n#FFFFFFНапиши /arm")	
			return false
		end
	end
	
	triggerClientEvent(thePlayer, "PlayerDialog", thePlayer, false, thePed, "Ты принят")
	SetTeam(thePlayer, arg)
	outputChatBox("Поздравляю, теперь ты являешься членом "..RGBToHex(getTeamColor(getTeamFromName(arg)))..arg, thePlayer, 255,255,255,true)
	outputChatBox("Боевая форма выдается в 12:30 по игровому времени..", thePlayer, 255,255,255,true)
	
	if(BandRangs[arg]) then
		local new = tostring(GetBandRangSkin(arg, GetDatabaseAccount(thePlayer, getTeamVariable(arg))))
		local arr = fromJSON(GetDatabaseAccount(thePlayer, "wardrobe"))
	
		if(not arr[new]) then
			arr[new] = 1
		elseif(arr[new] < 999) then
			arr[new] = arr[new]+1
		end
		triggerClientEvent(thePlayer, "InformTitle", thePlayer, new, "wardrobe")
		SetDatabaseAccount(thePlayer, "wardrobe", toJSON(arr))
	end
	
	UpdateTutorial(thePlayer)
	F4_Load(thePlayer)
end
addEvent("BandInvite", true)
addEventHandler("BandInvite", getRootElement(), BandInvite)



function DialogStart(thePlayer, dial, thePed)
	if(not getElementData(thePlayer, "anim")) then
		StartAnimation(thePlayer, "ped", "factalk", 1, false, true, true, true)
	end
	triggerClientEvent(thePlayer, "PlayerDialog", thePlayer, dial, thePed)
	PData[thePlayer]["dialog"] = dial
end


function DialogBreak(thePlayer, title, thePed)
	triggerClientEvent(thePlayer, "PlayerDialog", thePlayer, false, thePed, title)
	PData[thePlayer]["dialog"] = nil
	if(isTimer(PData[thePlayer]["dialogActionTimer"])) then
		killTimer(PData[thePlayer]["dialogActionTimer"])
	end
end
addEvent("DialogBreak", true)
addEventHandler("DialogBreak", getRootElement(), DialogBreak)



function CheckVoice(voice, voicebank)
	if(string.sub(voice, 0, 1) ~= "[") then
		callRemote("http://109.227.228.4/engine/include/MTA/govorilka.php", ResultGet, voice, voicebank)
	end
end
addEvent("CheckVoice", true)
addEventHandler("CheckVoice", getRootElement(), CheckVoice)





function DialogRelease(thePlayer, release, thePed)
	local timing = 50
	if(string.sub(PData[thePlayer]["dialog"][release]["text"], 0, 1) ~= "[") then
		triggerEvent("onPlayerChat", thePlayer, PData[thePlayer]["dialog"][release]["text"], 0, true)
		timing = #PData[thePlayer]["dialog"][release]["text"]*50
	end
	
	triggerClientEvent(thePlayer, "MyVoice", thePlayer, PData[thePlayer]["dialog"][release]["text"], 'gg')
	
	if(not getElementData(thePlayer, "anim")) then
		StartAnimation(thePlayer, "ped", "factalk", 1, false, true, true, true)
	end
	PData[thePlayer]["dialogActionTimer"] = setTimer(function()
		if(PData[thePlayer]["dialog"][release]["action"]) then
			if(PData[thePlayer]["dialog"][release]["action"][1]) then
				triggerEvent(PData[thePlayer]["dialog"][release]["action"][1], thePlayer, thePlayer, thePed, unpack(PData[thePlayer]["dialog"][release]["action"][2]))
			end
		end
		if(PData[thePlayer]["dialog"]) then -- Если после Action диалог продолжается
			if(PData[thePlayer]["dialog"][release]["next"]) then
				DialogStart(thePlayer, PData[thePlayer]["dialog"][release]["next"], thePed)
			else
				local title = false
				if(PData[thePlayer]["dialog"][release]["end"]) then title = PData[thePlayer]["dialog"][release]["end"][math.random(#PData[thePlayer]["dialog"][release]["end"])] end
				DialogBreak(thePlayer, title, thePed)
			end
		end
	end, timing, 1)
end
addEvent("DialogRelease", true)
addEventHandler("DialogRelease", getRootElement(), DialogRelease)




function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function PedDialog(thePlayer, thePed)
	if(not isPedDead(thePed) and not isPedDead(thePlayer)) then
		if(getElementHealth(thePed) > 20) then
			if(getElementType(thePed) == "ped") then
				if(getElementData(thePed, "dialog")) then
					if(not Dialogs[getElementData(thePed, "dialog")]) then return false end
					local rand = math.random(1, tablelength(Dialogs[getElementData(thePed, "dialog")]))
					DialogStart(thePlayer, Dialogs[getElementData(thePed, "dialog")][rand], thePed)
				else
					local model = getElementModel(thePed)
					if(SkinData[model][5]) then
						local rand = math.random(1, tablelength(Dialogs[SkinData[model][5]]))
						DialogStart(thePlayer, Dialogs[SkinData[model][5]][rand], thePed)
					else
						local team = getElementData(thePed, "team")
						if(team) then
							if(Dialogs[team]) then
								local rand = math.random(1, tablelength(Dialogs[team]))
								for i, k in pairs(Dialogs[team]) do
									if(i == rand) then
										DialogStart(thePlayer, Dialogs[team][rand], thePed)
										break
									end
								end
							end
						end
					end
				end
			elseif(getElementType(thePed) == "player") then
				if(GetDatabaseAccount(thePlayer, "team") == "МЧС") then
					if(getElementData(thePed, "sleep")) then
						DialogStart(thePlayer, Dialogs["Игрок МЧС"][2], thePed)
					else
						DialogStart(thePlayer, Dialogs["Игрок МЧС"][1], thePed)
					end
				elseif(GetDatabaseAccount(thePlayer, "team") == "Полиция") then
					if(GetDatabaseAccount(thePed, "wanted") ~= 0) then
						DialogStart(thePlayer, Dialogs["Игрок полиция"][1], thePed)
					end
				else
					DialogStart(thePlayer, Dialogs["Игрок обычный"][1], thePed)
				end
			end
		else
			DialogStart(thePlayer, Dialogs["Игрок в корячке"][1], thePed)
		end
	end
end
addEvent("PedDialog", true)
addEventHandler("PedDialog", root, PedDialog)




function PedDamage(ped, weapon, bodypart, loss)
	local theVehicle = getPedOccupiedVehicle(ped)
	local Team = getElementData(ped, "team")

	if(source and weapon) then
		if(getElementType(source) == "player") then
			if(getPedOccupiedVehicle(ped) and Team == "Полиция") then 
				WantedLevel(source, 0.01)
				setVehicleSirensOn(getPedOccupiedVehicle(ped), true)
			end
			setElementData(ped, "attacker", getPlayerName(source))
			if(weapon >= 0 and weapon <=9) then
				AddSkill(source, 177)
				if(weapon == 6) then
					local rand = math.random(4)
					if(rand == 4) then
						bodypart = 9
						loss = 1000
					end
				end
			end

			if(PData[source]["RobPed"]) then
				if(ped == PData[source]["RobPed"]) then
					AddRobPresure(PData[source]["RobPed"], math.floor(loss))
				else
					AddRobPresure(PData[source]["RobPed"], math.floor(loss/2.5))
				end
			end
		end
	end


	if(Team) then
		if(SkinData[getElementModel(ped)][4]) then
			if(getPedWeapon(ped) == 0) then
				giveWeapon(ped, SkinData[getElementModel(ped)][4], 9999, true)
			end
		else
			local rand = math.random(1,2)
			if(rand == 1) then
				StartAnimation(ped, "ped", "cower",1000,true,true,true)
			elseif(rand == 2) then
				setElementData(ped, "attacker", nil)
			end
		end
	end



	if(weapon == 49) then
		if(loss) then
			loss = loss*11
		end
	end
	
	if(getElementHealth(ped)-loss <= 0) then
		if(bodypart == 9) then
			setPedHeadless(ped, true)
		end
		killPed(ped, source, weapon, bodypart, false)
	else
		setElementHealth(ped, getElementHealth(ped)-loss)
		if(getElementHealth(ped) < 20) then
			Koryachka(ped)
		end
	end
end
addEvent("PedDamage", true)
addEventHandler("PedDamage", getRootElement(), PedDamage)


function Koryachka(thePlayer)
	if(getElementHealth(thePlayer) < 20) then
		if(getPedOccupiedVehicle(thePlayer)) then
			if(getElementType(thePlayer) == "ped") then
				RemovePedFromVehicle(thePlayer)
			else
				removePedFromVehicle(thePlayer)
			end
		end

		if(getElementHealth(thePlayer) > 15) then
			StartAnimation(thePlayer, "CRACK", "crckidle1", -1, true, true, true, false, true)
		elseif(getElementHealth(thePlayer) > 7) then
			StartAnimation(thePlayer, "CRACK", "crckidle2", -1, true, true, true, false, true)
		elseif(getElementHealth(thePlayer) > 0) then
			StartAnimation(thePlayer, "CRACK", "crckidle4", -1, true, true, true, false, true)
		end
	end
end

function InviteBot(ped)
	local Team = getElementData(ped, "team")
	if(Team) then
		if(Team == getTeamName(getPlayerTeam(source))) then
			if(getElementData(ped, "GROUP")) then
				removeElementData(ped, "GROUP")
			else
				setElementData(ped, "GROUP", getPlayerName(source))
			end
		end
	end
end
addEvent("InviteBot", true)
addEventHandler("InviteBot", getRootElement(), InviteBot)



addEventHandler("onPlayerWeaponFire", root, function(weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
   	local x,y,z = getElementPosition(source)
	local zone = getZoneName(x,y,z, false)
	if(GetDatabaseZoneNode(zone)) then
		cap(source, zone)
	end
end)


function cap(thePlayer, zone)
	if(WARGANG[zone]) then
		if(not CapZone[zone]) then
			local x,y,z = getElementPosition(thePlayer)
			if(zone == getZoneName(x,y,z)) then
				local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
				if(PlayerTeam == "Байкеры" or PlayerTeam == "Вагос" or PlayerTeam == "Рифа" or PlayerTeam == "Деревенщины" or PlayerTeam == "Баллас" or PlayerTeam == "Гроув-стрит" or PlayerTeam == "Полиция" or PlayerTeam == "Колумбийский картель" or PlayerTeam == "Якудзы" or PlayerTeam == "Триады" or PlayerTeam == "Русская мафия" or PlayerTeam == "Ацтекас") then
					local r,g,b,_ = getRadarAreaColor(WARGANG[zone][1])
					local tr,tg,tb = getTeamColor(getPlayerTeam(thePlayer))
					if(tr ~= r or tg ~= g or tb ~= b) then
						if(VehicleBand[zone]) then
							for slot = 1, #VehicleBand[zone] do
								setElementData(VehicleBand[zone][slot], "destroy", "true", false)
							end
						end
						if(BotCreated[zone]) then
							for slot = 1, #BotCreated[zone] do
								if(isElement(BotCreated[zone][slot])) then
									setElementData(BotCreated[zone][slot], "SpawnBlock", "true", false)
								end
							end
						end
						CapZone[zone]=PlayerTeam
					end
				end
			end
		end
	end
end





function fzone(thePlayer, command, ...)
	local s = 30
	for y=-100,100 do
		for x=-100,100 do
			local zone = getZoneName(x*s, y*s, 0)
			if(zone == table.concat({...}, " ")) then
				createRadarArea(x*s, y*s-(s), s, s, 255, 0, 0, 200)
			end

		end
	end
end
addCommandHandler("fzone", fzone)






function SetDatabaseZoneNode(zone, team)
	for i,node in ipairs(xmlNodeGetChildren(ZoneNode)) do
		if(zone == xmlNodeGetValue(node)) then
			xmlNodeSetAttribute(node, "owner", team)
		end
	end
end


function GetDatabaseZoneTeamPrice(team)
	local price=0
	for i,node in ipairs(xmlNodeGetChildren(ZoneNode)) do
		if(xmlNodeGetAttribute(node, "owner") == team) then
			price=price+GetZoneSize(xmlNodeGetValue(node))
		end
	end
	return price
end


function GetZoneSize(zone)
	local zonesize = 0
	for i = 1 , #WARGANG[zone] do
		local p1,p2 = getRadarAreaSize(WARGANG[zone][i])
		zonesize=zonesize+math.floor(p1+p2)--Искуственное уменьшение
	end
	return zonesize*2
end



function AddBizMoney(bizname, count)
	local Node = xmlFindChild(BizNode, bizname, 0)
	if(Node) then
		xmlNodeSetAttribute(Node, "money", xmlNodeGetAttribute(Node, "money")+(count))

		setElementData(BusinessPickup[bizname], "money", xmlNodeGetAttribute(Node, "money"))
		UpdateBiz(bizname)
	end
end


function UpdateBiz(bizname)
	for v,k in pairs(BizControls[bizname]) do
		StartLookBiz(v, false, bizname, k)
	end
end


function GetHousePrice(node)
	local dolg = 0
	if(xmlNodeGetAttribute(node, "dolg")) then
		dolg=xmlNodeGetAttribute(node, "dolg")
	end
	return xmlNodeGetAttribute(node, "price")-dolg
end




function buybiz(thePlayer, biz)
	local BPrice = tonumber(getElementData(biz, "price"))
	if(not getElementData(biz, "bizowner")) then
		if(AddPlayerMoney(thePlayer, -BPrice)) then
			if(BPrice ~= 0) then
				local SpawnArr = {}
				local x,y,z = getElementPosition(biz)
				SpawnArr[#SpawnArr+1] = {x,y,z, "", "", 270}
				MissionCompleted(thePlayer, "КУПЛЕНО", getElementData(biz, "biz"), false, toJSON(SpawnArr))
				
				local bizNode = xmlFindChild(BizNode, getElementData(biz, "name"), 0)
				xmlNodeSetAttribute(bizNode, "owner", getPlayerName(thePlayer))
				setElementData(biz, "bizowner", getPlayerName(thePlayer))
				UpdateVacancyList()
			else
				outputChatBox("Нельзя купить! Этот бизнес является федеральной собственностью!", thePlayer, 255,255,255,true)
			end
		end
	else
		if(getElementData(biz, "bizowner") == getPlayerName(thePlayer)) then
			if(BPrice ~= 0) then
				AddPlayerMoney(thePlayer, BPrice/2)
				local SpawnArr = {}
				local x,y,z = getElementPosition(biz)
				SpawnArr[#SpawnArr+1] = {x,y,z, "", "", 270}
				MissionCompleted(thePlayer, "ПРОДАНО", getElementData(biz, "biz"), false, toJSON(SpawnArr))
				
				local bizNode = xmlFindChild(BizNode, getElementData(biz, "name"), 0)
				xmlNodeSetAttribute(bizNode, "owner", "")
				removeElementData(biz, "bizowner")
				UpdateVacancyList()
			else
				outputChatBox("Нельзя продать! Этот бизнес является федеральной собственностью!", thePlayer, 255,255,255,true)
			end
		end
	end

end








function ZoneInfo(thePlayer, zone)
	if(thePlayer) then
		if(isPedDead(thePlayer)) then return false end
		if(getPlayerTeam(thePlayer)) then
			if(GetDatabaseAccount(thePlayer, "wanted") > 0) then
				WantedLevel(thePlayer, 0)
			end
			
			local r,g,b = getTeamColor(getPlayerTeam(thePlayer))

			local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
			if(CapZone[zone]) then
				--setBlipColor(PData[thePlayer]['radar'], r,g,b, 255)
			else
				--setBlipColor(PData[thePlayer]['radar'], r,g,b, 0)
			end

			if(PlayerTeam == "Военные") then
				if(getElementModel(thePlayer) == 312) then
					if(zone ~= "Restricted Area") then
						MissionCompleted(thePlayer, "ДЕЗЕРТИР", "СБЕЖАЛ")
						SetTeam(thePlayer, "Мирные жители")
						WantedLevel(thePlayer, 6)
						removeElementData(thePlayer, "WantedLevelPrison")
					end
				end
			elseif(PlayerTeam == "Уголовники") then
				if(GetDatabaseAccount(thePlayer, "Prison") == "AREA51") then
					if(zone ~= "Restricted Area") then
						local ptime = GetDatabaseAccount(thePlayer, "PrisonTime")
						SetDatabaseAccount(thePlayer, "PrisonTime", nil)
						SetDatabaseAccount(thePlayer, "Prison", nil)
						MissionCompleted(thePlayer, "", "СБЕЖАЛ")
						SetTeam(thePlayer, GetDatabaseAccount(thePlayer, "OldTeam"))
						SetDatabaseAccount(thePlayer, "OldTeam", nil)

						WantedLevel(thePlayer, 6)
						SetDatabaseAccount(thePlayer, "inv", GetDatabaseAccount(thePlayer, "prisoninv"))
						setElementData(thePlayer, "inv", GetDatabaseAccount(thePlayer, "prisoninv"))
						SetDatabaseAccount(thePlayer, "prisoninv", nil)
						triggerClientEvent(thePlayer, "PlayerSpawn", thePlayer)
						removeElementData(thePlayer, "WantedLevelPrison")
					end
				else
					if(getElementDimension(thePlayer) == 0) then
						local ptime = GetDatabaseAccount(thePlayer, "PrisonTime")
						SetDatabaseAccount(thePlayer, "PrisonTime", nil)
						SetDatabaseAccount(thePlayer, "Prison", nil)
						MissionCompleted(thePlayer, "", "СБЕЖАЛ")
						if(GetDatabaseAccount(thePlayer, "OldTeam") ~= 0) then
							SetTeam(thePlayer, GetDatabaseAccount(thePlayer, "OldTeam"))
							SetDatabaseAccount(thePlayer, "OldTeam", nil)
						else
							SetTeam(thePlayer, "Мирные жители")
						end
						WantedLevel(thePlayer, 6)
						SetDatabaseAccount(thePlayer, "inv", GetDatabaseAccount(thePlayer, "prisoninv"))
						setElementData(thePlayer, "inv", GetDatabaseAccount(thePlayer, "prisoninv"))
						SetDatabaseAccount(thePlayer, "prisoninv", nil)
						triggerClientEvent(thePlayer, "PlayerSpawn", thePlayer)
						removeElementData(thePlayer, "WantedLevelPrison")
					end
				end
			end
		end
	end
end
addEvent("ZoneInfo", true)
addEventHandler("ZoneInfo", root, ZoneInfo)



function stopCap(zone,r,g,b, PlayerTeam, spawnveh, spawnbot)
	CapZone[zone] = nil
	for slot = 1, #WARGANG[zone] do
		setRadarAreaColor(WARGANG[zone][slot], r,g,b,140)
	end

	if(VehicleBand[zone]) then
		if(spawnveh) then -- Прервали захват (восстановление)
			for slot = 1, #VehicleBand[zone] do
				if(isElement(VehicleBand[zone][slot])) then
					removeElementData(VehicleBand[zone][slot], "destroy")
				else
					local k = VehicleSpawnPoint[zone][slot]
					local vehinfo = false
					if(PlayerTeam == "Полиция") then
						local region = getZoneName(k[1], k[2], k[3], true)
						vehinfo = SData["TeamVehicle"][PlayerTeam][region][math.random(#SData["TeamVehicle"][PlayerTeam][region])]
					else
						vehinfo = SData["TeamVehicle"][PlayerTeam][math.random(1, #SData["TeamVehicle"][PlayerTeam])]
					end

					local theVehicle = CreateVehicle(vehinfo[1], k[1], k[2], k[3]+VehicleSystem[vehinfo[1]][1], k[4], k[5], k[6], vehinfo[2], true)
					if(vehinfo[3]) then
						if(#vehinfo[3] == 4) then
							setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4])
						else
							setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4], vehinfo[3][5], vehinfo[3][6])
						end
					end
					if(vehinfo[4]) then
						setVehicleVariant(theVehicle, vehinfo[4][1], vehinfo[4][2], vehinfo[4][3], vehinfo[4][4])
					end
					if(vehinfo[5]) then
						triggerEvent(vehinfo[5], theVehicle)
					end
					VehicleBand[zone][slot] = theVehicle
				end
				if(isElement(DynamicBlip[VehicleBand[zone][slot]])) then
					destroyElement(DynamicBlip[VehicleBand[zone][slot]])
					destroyElement(DynamicMar[VehicleBand[zone][slot]])
				end
			end
		else -- Новые автомобили
			for slot = 1, #VehicleBand[zone] do
				if(isElement(DynamicBlip[VehicleBand[zone][slot]])) then
					destroyElement(DynamicBlip[VehicleBand[zone][slot]])
					destroyElement(DynamicMar[VehicleBand[zone][slot]])
				end
			end
			VehicleBand[zone] = {}
			local VehicleCount = 1
			for v,k in pairs(VehicleSpawnPoint[zone]) do
				local vehinfo = false
				if(PlayerTeam == "Полиция") then
					local region = getZoneName(k[1], k[2], k[3], true)
					vehinfo = SData["TeamVehicle"][PlayerTeam][region][math.random(#SData["TeamVehicle"][PlayerTeam][region])]
				else
					if(not SData["TeamVehicle"][PlayerTeam][VehicleCount]) then
						VehicleCount = 1
					end
					vehinfo = SData["TeamVehicle"][PlayerTeam][VehicleCount]
				end

				local theVehicle = CreateVehicle(vehinfo[1], k[1], k[2], k[3]+VehicleSystem[vehinfo[1]][1], k[4], k[5], k[6], vehinfo[2], true)
				if(vehinfo[3]) then
					if(#vehinfo[3] == 4) then
						setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4])
					else
						setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4], vehinfo[3][5], vehinfo[3][6])
					end
				end
				if(vehinfo[4]) then
					setVehicleVariant(theVehicle, vehinfo[4][1], vehinfo[4][2], vehinfo[4][3], vehinfo[4][4])
				end
				if(vehinfo[5]) then
					triggerEvent(vehinfo[5], theVehicle)
				end
				VehicleBand[zone][#VehicleBand[zone]+1]=theVehicle
				VehicleCount=VehicleCount+1
			end
		end
	end

	local availzones = {}
	for name, dat in pairs(PedNodes[zone]) do
		for slotx = dat[1], dat[4] do
			for sloty = dat[2], dat[5] do
				availzones[#availzones+1] = {slotx, sloty, dat[6], dat[7]}
			end
		end
	end


	if(BotCreated[zone]) then
		if(spawnbot) then -- Прервали захват (восстановление)
			for slot = 1, #BotCreated[zone] do
				if(isElement(DynamicBlip[BotCreated[zone][slot]])) then
					destroyElement(DynamicBlip[BotCreated[zone][slot]])
					destroyElement(DynamicMar[BotCreated[zone][slot]])
				end
				local createornot = false
				if(isElement(BotCreated[zone][slot])) then
					if(isPedDead(BotCreated[zone][slot])) then
						createornot = true
					else
						removeElementData(BotCreated[zone][slot], "SpawnBlock")
					end
				else
					createornot = true
				end

				if(createornot) then
					local randnum = math.random(#availzones)
					local rand = availzones[randnum]

					local rot = rand[4]
					local randrot = math.random(1,2)
					if(randrot == 1) then rot = rot+180 end
					CreateRandomBot(rand[1], rand[2], rand[3]+1.1,rot,nil,nil,zone, slot)
					table.remove(availzones, randnum)
				end
			end
		else -- Новые боты
			for slot = 1, #BotCreated[zone] do
				if(isElement(DynamicBlip[BotCreated[zone][slot]])) then
					destroyElement(DynamicBlip[BotCreated[zone][slot]])
					destroyElement(DynamicMar[BotCreated[zone][slot]])
				end
				local createornot = false
				if(isElement(BotCreated[zone][slot])) then
					if(isPedDead(BotCreated[zone][slot])) then
						createornot = true
					else
						removeElementData(BotCreated[zone][slot], "SpawnBlock")
					end
				else
					createornot = true
				end

				if(createornot) then
					local randnum = math.random(#availzones)
					local rand = availzones[randnum]

					local rot = rand[4]
					local randrot = math.random(1,2)
					if(randrot == 1) then rot = rot+180 end
					CreateRandomBot(rand[1], rand[2], rand[3]+1,rot,nil,nil,zone, slot)
					table.remove(availzones, randnum)
				end
			end
		end
	end
end

function okCap(zone,r,g,b, PlayerTeam)
	SetDatabaseZoneNode(zone, PlayerTeam)
	if(SpawnPoint[zone]) then
		SpawnPoint[zone][6] = PlayerTeam
	end
	local players = getPlayersInTeam(getTeamFromName(PlayerTeam))
	for playerKey, thePlayer in ipairs (players) do
		local x,y,z = getElementPosition(thePlayer)
		if(getZoneName(x,y,z) == zone) then
			triggerClientEvent(thePlayer, "ChangeInfoAdv", thePlayer)
			MissionCompleted(thePlayer, "УВАЖЕНИЕ +", "ТЕРРИТОРИЯ ЗАХВАЧЕНА!")
			Respect(thePlayer, getTeamVariable(PlayerTeam), 1)
			triggerEvent("ZoneInfo", thePlayer, thePlayer, zone)
			
			if(WargangGates[zone]) then
				for _, dat in pairs(WargangGates[zone]) do
					setElementData(dat[1], "team", toJSON({PlayerTeam}))
				end
			end
			
		end
		ToolTip(thePlayer, "Зарплата "..RGBToHex(r,g,b)..PlayerTeam.."#FFFFFF\nвыросла на "..COLOR["DOLLAR"]["HEX"].."$"..GetZoneSize(zone))
	end
	stopCap(zone,r,g,b, PlayerTeam)
end


function ToolTip(thePlayer, message)
	triggerClientEvent(thePlayer, "ToolTip", thePlayer, message)
end
addEvent("ToolTip", true)
addEventHandler("ToolTip", root, ToolTip)







function CreateInterior(houseid, interior, x,y,z, owner, price, locked)
	if(interior) then
		local Pos = Interiors[interior]
		CreateEnter(x,y,z, 0, 0, 0, {"house", houseid, owner, price, locked}, Pos[2], Pos[3], Pos[4], Pos[5], Pos[1], string.gsub(houseid, "h", ""))
		if(InteriorsObject[interior]) then
			for i, v in pairs(InteriorsObject[interior]) do
				local o = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
				setElementDimension(o, string.gsub(houseid, "h", ""))
				setElementInterior(o, Pos[1])
			end
		end
	else
		CreateEnter(x,y,z, 0, 0, 0, {"garage", houseid, owner, price, locked})
	end
end


function EnterHouse(buyhouse, spawn)
	if(buyhouse) then
		local HouseNode = xmlFindChild(HouseNode, buyhouse, 0)

		if(xmlNodeGetAttribute(HouseNode, "locked") == "0" or spawn == true or xmlNodeGetValue(HouseNode) == '') then
			local owner = "Дом на продажу"
			if(xmlNodeGetValue(HouseNode) ~= '') then
				owner = "Дом "..xmlNodeGetValue(HouseNode)
			end
			local dolg = getPlayerHouseDolg(source)
			if(dolg > 0) then
				ToolTip(source, "Счет за электричество "..COLOR["DOLLAR"]["HEX"].."$"..dolg.."\n#FFFFFFнапиши #A0A0A0/el#FFFFFF чтобы оплатить")
			end
			local d = string.gsub(xmlNodeGetName(HouseNode), "h", "")
			local anim = true
			if spawn == true then
				anim=false
			end
			if(xmlNodeGetAttribute(HouseNode, "int")) then
				local Pos = Interiors[xmlNodeGetAttribute(HouseNode, "int")]
				SetPlayerPosition(source, Pos[2], Pos[3], Pos[4], Pos[1], d, Pos[5], anim, owner)
				setElementData(source, "EntHouse", buyhouse)
			else
				if(spawn) then --Гаражи
					SetPlayerPosition(source, xmlNodeGetAttribute(HouseNode, "x"), xmlNodeGetAttribute(HouseNode, "y"), xmlNodeGetAttribute(HouseNode, "z"), 0, 0, 0, anim)
				end
			end
		else
			HelpMessage(source, "Дверь закрыта!")
		end
	end
end
addEvent("EnterHouse", true)
addEventHandler("EnterHouse", root, EnterHouse)




function ExitHouse(house)
	local x = getElementData(house, "x")
	local y = getElementData(house, "y")
	local z = getElementData(house, "z")
	SetPlayerPosition(source, x, y, z, 0, 0, nil, true)
	removeElementData(source, "EntHouse")
end
addEvent("ExitHouse", true)
addEventHandler("ExitHouse", root, ExitHouse)




function getPlayerHouseDolg(thePlayer)
	local dolg = 0
	local name = getPlayerName(thePlayer)
	local HouseNodes = xmlNodeGetChildren(HouseNode)
	for i,node in ipairs(HouseNodes) do
		if(name == xmlNodeGetValue(node)) then
			if(xmlNodeGetAttribute(node, "dolg")) then
				dolg = dolg+xmlNodeGetAttribute(node, "dolg")
			end
		end
	end
	return dolg
end


function findRotation3D( x1, y1, z1, x2, y2, z2 )
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end





function opengate(TargetGate, state)
	if(getElementData(TargetGate, "house")) then
		local HouseNodes = xmlNodeGetChildren(HouseNode)
		local node = xmlFindChild(HouseNode, getElementData(TargetGate, "house"), 0)
		if(xmlNodeGetValue(node) ~= "") then
			if(getPlayerName(source) ~= xmlNodeGetValue(node)) then
				return false
			end
		end
	end
	local dat = getElementData(TargetGate, "team")
	if(dat) then
		dat = fromJSON(dat)
		local out = ""
		local op = false
		for _, v in pairs(dat) do
			local r,g,b = getTeamColor(getTeamFromName(v))
			out = out.." "..RGBToHex(r,g,b)..v
			if(GetDatabaseAccount(source, "team") == v or getTeamName(SkinData[getElementModel(source)][2]) == v) then
				op = true
			end
		end
		if(not op) then
			ToolTip(source, "Только"..out.."\n#FFFFFFмогут управлять этими воротами")
			return false
		end
	end

	local x,y,z = getElementPosition(TargetGate)
	local rx,ry,rz = getElementRotation(TargetGate)
	local speed = 2000
	local remaining = 0
	local data = getElementData(TargetGate, "gates")
	local coord = fromJSON(data)
	
	if(state == "Leave") then
		if(isTimer(OpenGatesTimer[TargetGate])) then
			remaining = getTimerDetails(OpenGatesTimer[TargetGate])
		end

		if(GateTrigger(source, TargetGate, state)) then
			local datCord = fromJSON(getElementData(TargetGate, "NativePos"))
			coord[4] = datCord[4]-rx
			coord[5] = datCord[5]-ry
			coord[6] = datCord[6]-rz
			if(coord[4] < -180) then coord[4] = coord[4] + 360 end
			if(coord[5] < -180) then coord[5] = coord[5] + 360 end
			if(coord[6] < -180) then coord[6] = coord[6] + 360 end
	
			if(coord[4] > 180) then coord[4] = coord[4] - 360 end
			if(coord[5] > 180) then coord[5] = coord[5] - 360 end
			if(coord[6] > 180) then coord[6] = coord[6] - 360 end
	
	
			moveObject(TargetGate, speed-remaining, datCord[1], datCord[2], datCord[3], coord[4], coord[5], coord[6], "Linear", 0.0, 0.0, 0.0 )
			
			for key,thePlayers in pairs(getElementsByType "player") do
				triggerClientEvent(thePlayers, "PlaySFX3DforAll", thePlayers, "genrl", 44, 2,x,y,z, false, 25, 50)
			end
		end
	elseif(state == "Enter") then
		if(data) then
			if(isTimer(OpenGatesTimer[TargetGate])) then
				remaining = getTimerDetails(OpenGatesTimer[TargetGate])
			end

			if(GateTrigger(source, TargetGate, state)) then
				if(not getElementData(TargetGate, "NativePos")) then
					setElementData(TargetGate, "NativePos", toJSON({x,y,z,rx,ry,rz}))
				else
					local datCord = fromJSON(getElementData(TargetGate, "NativePos"))
					coord[4] = coord[4]-(rx-datCord[4])
					coord[5] = coord[5]-(ry-datCord[5])
					coord[6] = coord[6]-(rz-datCord[6])
	
					if(coord[4] < -180) then coord[4] = coord[4] + 360 end
					if(coord[5] < -180) then coord[5] = coord[5] + 360 end
					if(coord[6] < -180) then coord[6] = coord[6] + 360 end
	
					if(coord[4] > 180) then coord[4] = coord[4] - 360 end
					if(coord[5] > 180) then coord[5] = coord[5] - 360 end
					if(coord[6] > 180) then coord[6] = coord[6] - 360 end
	
				end
				
				moveObject(TargetGate, speed-remaining, coord[1],coord[2],coord[3],coord[4],coord[5],coord[6], "Linear", 0.0, 0.0, 0.0)
				OpenGatesTimer[TargetGate] = setTimer(function() end, speed-remaining, 1)
			end
		end


		for key,thePlayers in pairs(getElementsByType "player") do
			triggerClientEvent(thePlayers, "PlaySFX3DforAll", thePlayers, "genrl", 44, 2,x,y,z, false, 25, 50)
		end
	end

end
addEvent("opengate", true)
addEventHandler("opengate", root, opengate)





function GateTrigger(thePlayer, gate, state) 
	if(not OpenGates[gate]) then OpenGates[gate] = {} end
	if(state == "Leave") then
		OpenGates[gate][thePlayer] = nil
		if(getArrSize(OpenGates[gate]) ~= 0) then -- Если в воротах до сих пор кто-то стоит
			return false
		end
	else
		OpenGates[gate][thePlayer] = state
		if(getArrSize(OpenGates[gate]) > 1) then -- Если ворота уже открыты другим игроком
			return false
		end
	end
	return true
end



local PoliceVehicles = {
	[497] = true,
	[596] = true,
	[597] = true,
	[598] = true,
	[599] = true,
	[601] = true,
	[523] = true,
	[490] = true,
	[528] = true
}

function PoliceCallRemove(x,y,z,info)
	local city = getZoneName(x,y,z,true)
	for key,thePlayers in pairs(getElementsByType "player") do
		local x2,y2,z2 = getElementPosition(thePlayers)
		local cityPlayer = getZoneName(x2,y2,z2,true)
		if(city == cityPlayer) then
			local theVehicle = getPedOccupiedVehicle(thePlayers)
			if(theVehicle) then
				local model = getElementModel(theVehicle)
				if(PoliceVehicles[model]) then
					triggerClientEvent(thePlayers, "PoliceAddMarker", thePlayers, x, y, z-1, "Ограбление")
				end
			end
		end
	end
end



function GetAvailableSpawn(thePlayer, team)
	local SpawnArr = {}
	local Job = IsPlayerJob(getPlayerName(thePlayer))
	if(team == "Уголовники") then
		local Prison = GetDatabaseAccount(thePlayer, "Prison")
		SpawnArr[1] = {SpawnPoint[Prison][1], SpawnPoint[Prison][2], SpawnPoint[Prison][3], "street", Prison, SpawnPoint[Prison][5]}
		return SpawnArr
	end

	if(team == "Военные") then
		if(GetDatabaseAccount(thePlayer, "ATUT") ~= 2) then
			SpawnArr[1] = {SpawnPoint["Zone 51 Army"][1], SpawnPoint["Zone 51 Army"][2], SpawnPoint["Zone 51 Army"][3], "street", "Zone 51 Army", SpawnPoint["Zone 51 Army"][5]}
			return SpawnArr
		else
			SpawnArr[1] = {SpawnPoint["Army"][1], SpawnPoint["Army"][2], SpawnPoint["Army"][3], "street", "Army", SpawnPoint["Army"][5]}
		end
	end

	for key,thePickups in pairs(getElementsByType "marker") do
		if(getElementData(thePickups, "owner") == getPlayerName(thePlayer)) then
			if(getElementData(thePickups, "zone")) then
				local x,y,z = getElementPosition(thePickups)
				SpawnArr[#SpawnArr+1] = {x,y,z, "house", getElementID(thePickups), 270}
			end
		end
	end
	for v,k in pairs(SpawnPoint) do
		if(SpawnPoint[v][1]) then
			if(SpawnPoint[v][6] == team) then
				SpawnArr[#SpawnArr+1] = {SpawnPoint[v][1], SpawnPoint[v][2], SpawnPoint[v][3], "street", v, SpawnPoint[v][5]}
			end
		end
	end

	if(Job) then
		if(Job == "Начальник LSPD" or Job == "Рядовой" or Job == "Инспектор ДПС" or Job == "Сержант" or Job == "Лейтенант" or Job == "SWAT" or Job == "Офицер 1 класса" or Job == "Офицер 2 класса" or Job == "Шериф округа Red County") then
			SpawnArr[#SpawnArr+1] = {SpawnPoint["Los Santos Police"][1], SpawnPoint["Los Santos Police"][2], SpawnPoint["Los Santos Police"][3], "street", "Los Santos Police", SpawnPoint["Los Santos Police"][5]}
		elseif(Job == "Начальник SFPD" or Job == "ФБР") then
			SpawnArr[#SpawnArr+1] = {SpawnPoint["San Fierro Police"][1], SpawnPoint["San Fierro Police"][2], SpawnPoint["San Fierro Police"][3], "street", "San Fierro Police", SpawnPoint["San Fierro Police"][5]}
		elseif(Job == "Директор ЦРУ" or Job == "Тайный агент по борьбе с наркотиками") then
			SpawnArr[#SpawnArr+1] = {SpawnPoint["Zone 51 CIA"][1], SpawnPoint["Zone 51 CIA"][2], SpawnPoint["Zone 51 CIA"][3], "street", "Zone 51 CIA", SpawnPoint["Zone 51 CIA"][5]}
		elseif(Job == "Учёный CPC") then
			SpawnArr[#SpawnArr+1] = {SpawnPoint["Zone 51 Medic"][1], SpawnPoint["Zone 51 Medic"][2], SpawnPoint["Zone 51 Medic"][3], "street", "Zone 51 Medic", SpawnPoint["Zone 51 Medic"][5]}
		elseif(Job == "Начальник LVPD") then
			SpawnArr[#SpawnArr+1] = {SpawnPoint["Las Venturas Police"][1], SpawnPoint["Las Venturas Police"][2], SpawnPoint["Las Venturas Police"][3], "street", "Las Venturas Police", SpawnPoint["Las Venturas Police"][5]}
		end
	end


	if(team == "Якудзы") then
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Koyoen Station"][1], SpawnPoint["Koyoen Station"][2], SpawnPoint["Koyoen Station"][3], "street", "Koyoen Station", SpawnPoint["Koyoen Station"][5]}
	else
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Unity Station"][1], SpawnPoint["Unity Station"][2], SpawnPoint["Unity Station"][3], "street", "Unity Station", SpawnPoint["Unity Station"][5]}
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Market Station"][1], SpawnPoint["Market Station"][2], SpawnPoint["Market Station"][3], "street", "Market Station", SpawnPoint["Market Station"][5]}
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Cranberry Station"][1], SpawnPoint["Cranberry Station"][2], SpawnPoint["Cranberry Station"][3], "street", "Cranberry Station", SpawnPoint["Cranberry Station"][5]}
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Linden Station"][1], SpawnPoint["Linden Station"][2], SpawnPoint["Linden Station"][3], "street", "Linden Station", SpawnPoint["Linden Station"][5]}
		SpawnArr[#SpawnArr+1] = {SpawnPoint["Las Payasadas"][1], SpawnPoint["Las Payasadas"][2], SpawnPoint["Las Payasadas"][3], "street", "Las Payasadas", SpawnPoint["Las Payasadas"][5]}
	end
	return SpawnArr
end



function buyHouse(thePlayer, buyhouse)
	if(getElementData(getElementByID(buyhouse), "owner") == getPlayerName(thePlayer)) then
		local HouseNode = xmlFindChild(HouseNode, buyhouse, 0)

		xmlNodeSetValue(HouseNode, "")
		setElementData(getElementByID(buyhouse), "owner", "")
		if(not getElementData(getElementByID(buyhouse), "GEnter")) then
			local el = getElementByID(buyhouse)
			local alldata = getAllElementData(el)
			local x,y,z = getElementPosition(el)
			destroyElement(el)
			el = createPickup(x, y, z-0.9, 3, 1273, 0)
			for k, v in pairs (alldata) do
				setElementData(el, k, v)
			end
			setElementID(el, buyhouse)
		end

		AddPlayerMoney(thePlayer, GetHousePrice(HouseNode))
		triggerEvent("onPickupUse", getElementByID(buyhouse), thePlayer)
		triggerClientEvent(thePlayer, "StartLookZones", thePlayer, toJSON(GetAvailableSpawn(thePlayer, GetDatabaseAccount(thePlayer, "team"))), true)
		
		local SpawnArr = {}
		local x,y,z = getElementPosition(getElementByID(buyhouse))
		SpawnArr[#SpawnArr+1] = {x,y,z, "", "", 270}
		MissionCompleted(thePlayer, "ПРОДАНО", false, false, toJSON(SpawnArr))

		if(xmlNodeGetAttribute(HouseNode, "dolg")) then
			xmlNodeSetAttribute(HouseNode, "dolg", nil)
		end
		setElementData(getElementByID(buyhouse), "price", GetHousePrice(HouseNode))
		if(Garages[buyhouse]) then
			for slot = 1, #Garages[buyhouse] do
				setElementData(Garages[buyhouse][slot]["enter"], "owner", "")
			end
		end
	else
		if(getElementData(getElementByID(buyhouse), "owner") == "") then
			if(AddPlayerMoney(thePlayer, -tonumber(getElementData(getElementByID(buyhouse), "price")))) then
				local HouseNodes = xmlNodeGetChildren(HouseNode)
				local HouseNode = xmlFindChild(HouseNode, buyhouse, 0)
				xmlNodeSetValue(HouseNode, getPlayerName(thePlayer))
				setElementData(getElementByID(buyhouse), "owner", getPlayerName(thePlayer))
				if(not getElementData(getElementByID(buyhouse), "GEnter")) then
					local el = getElementByID(buyhouse)
					local alldata = getAllElementData(el)
					local x,y,z = getElementPosition(el)
					destroyElement(el)
					el = createMarker(x, y, z+0.9, "arrow", 1.5, 255, 255, 0, 170)
					for k, v in pairs (alldata) do
						setElementData(el, k, v)
					end
					setElementID(el, buyhouse)
				end
				if(Garages[buyhouse]) then
					for slot = 1, #Garages[buyhouse] do
						setElementData(Garages[buyhouse][slot]["enter"], "owner", getPlayerName(thePlayer))
					end
				end
				triggerEvent("onPickupUse", getElementByID(buyhouse), thePlayer)
				triggerClientEvent(thePlayer, "StartLookZones", thePlayer, toJSON(GetAvailableSpawn(thePlayer, GetDatabaseAccount(thePlayer, "team"))), true)
				
				local SpawnArr = {}
				local x,y,z = getElementPosition(getElementByID(buyhouse))
				SpawnArr[#SpawnArr+1] = {x,y,z, "", "", 270}
				MissionCompleted(thePlayer, "КУПЛЕНО", false, false, toJSON(SpawnArr))
			end
		end
	end
end





function AddGarage(thePlayer, command, h)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		local HouseNodes = xmlNodeGetChildren(HouseNode)
		local node = xmlFindChild(HouseNode, h, 0)
		local arr = {}
		if(xmlNodeGetAttribute(node, "Garage")) then arr = fromJSON(xmlNodeGetAttribute(node, "Garage")) end
		local newgar = #arr+1
		local x,y,z = getElementPosition(thePlayer)
		local rx,ry,rz = getElementRotation(thePlayer)
		--x,y,z,rz,locked
		arr[newgar] = {math.round(x, 1),math.round(y, 1),math.round(z, 1),math.round(rz, 1), 1}
		xmlNodeSetAttribute(node, "Garage", toJSON(arr))
		CreateGarage(arr[newgar][1], arr[newgar][2], arr[newgar][3], arr[newgar][4], arr[newgar][5], xmlNodeGetName(node), xmlNodeGetValue(node))
	end
end
addCommandHandler("garage", AddGarage)





function ReparkEv(theVehicle)
	local CarNodes = xmlNodeGetChildren(CarNode)
	if(getElementData(theVehicle, "x")) then -- Если перепарковывает
		for i,node in ipairs(CarNodes) do
			if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
				return node
			end
		end
	end
	return false
end


function ParkMyCar(theVehicle)
	if(getElementData(theVehicle, "owner")) then
		local x,y,z = getElementPosition(theVehicle)
		local rx,ry,rz = getElementRotation(theVehicle)
		if(rx > 30 and rx < 330 or ry > 30 and ry < 330) then
			outputChatBox("Размести автомобиль ровно!", source, 255,255,255,true)
			return false
		end
		local i = getElementInterior(theVehicle)
		local d = getElementDimension(theVehicle)
		local node = ReparkEv(theVehicle)
		if(not node) then
			node = xmlCreateChild(CarNode, "c")
			xmlNodeSetValue(node, getPlayerName(source))
		end

		xmlNodeSetAttribute(node, "vmodel", getElementModel(theVehicle))
		xmlNodeSetAttribute(node, "year", getElementData(theVehicle, "year"))
		xmlNodeSetAttribute(node, "vx", math.round(x, 1))
		xmlNodeSetAttribute(node, "vy", math.round(y, 1))
		xmlNodeSetAttribute(node, "vz", math.round(z, 1))
		xmlNodeSetAttribute(node, "vrx", math.round(rx, 1))
		xmlNodeSetAttribute(node, "vry", math.round(ry, 1))
		xmlNodeSetAttribute(node, "vrz", math.round(rz, 1))
		xmlNodeSetAttribute(node, "i", i)
		xmlNodeSetAttribute(node, "d", d)
		xmlNodeSetAttribute(node, "handl", getElementData(theVehicle, "handl"))

		setElementData(theVehicle, "x", tostring(math.round(x, 1)), false)
		setElementData(theVehicle, "y", tostring(math.round(y, 1)), false)
		setElementData(theVehicle, "z", tostring(math.round(z, 1)), false)
		setElementData(theVehicle, "i", i, false)
		setElementData(theVehicle, "d", d, false)

		if(d == 0) then
			xmlNodeSetAttribute(node, "gx", nil)
			xmlNodeSetAttribute(node, "gy", nil)
			xmlNodeSetAttribute(node, "gz", nil)
			xmlNodeSetAttribute(node, "grz", nil)
		else
			xmlNodeSetAttribute(node, "gx", getElementData(theVehicle, "gx"))
			xmlNodeSetAttribute(node, "gy", getElementData(theVehicle, "gy"))
			xmlNodeSetAttribute(node, "gz", getElementData(theVehicle, "gz"))
			xmlNodeSetAttribute(node, "grz", getElementData(theVehicle, "grz"))
		end

		local c1,c2,c3,c4 = getVehicleColor(theVehicle)
		xmlNodeSetAttribute(node, "vc1", c1)
		xmlNodeSetAttribute(node, "vc2", c2)
		xmlNodeSetAttribute(node, "vc3", c3)
		xmlNodeSetAttribute(node, "vc4", c4)
		xmlNodeSetAttribute(node, "vinyl", getVehiclePaintjob(theVehicle))
		local upgr={}
		for upgradeKey, upgradeValue in ipairs (getVehicleUpgrades(theVehicle)) do
			upgr[upgradeKey]=upgradeValue
		end
		xmlNodeSetAttribute(node, "upgrades", toJSON(upgr))

		if(getElementData(theVehicle, "siren")) then
			xmlNodeSetAttribute(node, "siren", getElementData(theVehicle, "siren"))
		end


		setVehicleRespawnPosition(theVehicle, x, y, z, rx, ry, rz)
		outputChatBox("#CC9966Транспорт#FFFFFF успешно припаркован!", source,255,255,255,true)
	end
end
addEvent("ParkMyCar", true)
addEventHandler("ParkMyCar", root, ParkMyCar)




function sellcar(thePlayer, command, h)
	local h = tonumber(h)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if(h and theVehicle) then
		if(h > 0) then
			local CarNodes = xmlNodeGetChildren(CarNode)
			for i,node in ipairs(CarNodes) do
				if(getPlayerName(thePlayer) == xmlNodeGetValue(node)) then
					if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
						xmlDestroyNode(node)
						local x,y,z = getElementPosition(theVehicle)
						local rx,ry,rz = getElementRotation(theVehicle)
						setVehicleRespawnPosition(theVehicle, x,y,z)
						removeElementData(theVehicle, "owner")
						removeElementData(theVehicle, "x")
						removeElementData(theVehicle, "y")
						removeElementData(theVehicle, "z")
						removePedFromVehicle(thePlayer)
						setElementData(theVehicle, "price", h)
						setElementData(theVehicle, "seller", getPlayerName(thePlayer))
						setVehiclePlateText(theVehicle, "SELL 228")
						outputChatBox("Транспорт выставлен на продажу!", thePlayer, 255,255,255,true)
						setElementPosition(thePlayer, x,y,z+1)
					end
				end
			end
		else
			outputChatBox("Цена не может быть ниже 0!", thePlayer)
		end
	else
		outputChatBox("/sellcar сумма продажи", thePlayer, 255,255,255,true)
	end
end
addCommandHandler("sellcar", sellcar)



function BuyCar(theVehicle)
	local model = getElementModel(theVehicle)

	if(getElementData(theVehicle, "price")) then
		if(AddPlayerMoney(source, -tonumber(getElementData(theVehicle, "price")))) then
			local Seller = getElementData(theVehicle, "seller")
			if(Seller) then
				Seller = getPlayerFromName(Seller)
				if(Seller ~= source) then
					if(Seller) then
						AddPlayerMoney(Seller, tonumber(getElementData(theVehicle, "price")))
						MissionCompleted(Seller, "", "ТРАНСПОРТ ПРОДАН!")
					end
				end
			end
		else
			return false
		end
	else
		local vmodelH = getOriginalHandling(model)
		if(not AddPlayerMoney(source, -vmodelH["monetary"])) then
			return false
		end
	end
	MissionCompleted(source, "", "ТРАНСПОРТ КУПЛЕН!")


	for CompanyName, models in pairs(CarsForSale) do
		for i, arr in pairs(models) do
			if(arr[1] == theVehicle) then
				arr[1] = false
				break
			end
		end
	end
	setVehiclePlateText(theVehicle, getPlayerName(source))
	setElementData(theVehicle, "owner", getPlayerName(source))
	outputChatBox("Припаркуй транспорт у своего #99FF00дома#FFFFFF или на парковке", source, 255,255,255,true)
	outputChatBox("Иначе его могут #FF0000конфисковать#FFFFFF за парковку в неположеном месте!", source, 255,255,255,true)


	triggerClientEvent(source, "UpdTarget", source)
	if(getElementData(theVehicle, "price")) then
		removeElementData(theVehicle, "price")
	end
end
addEvent("BuyCar", true)
addEventHandler("BuyCar", root, BuyCar)





function el(thePlayer, command, h)
	local HouseNodes = xmlNodeGetChildren(HouseNode)
	local out = 0
	for i,node in ipairs(HouseNodes) do
		if(getPlayerName(thePlayer) == xmlNodeGetValue(node)) then
			if(xmlNodeGetAttribute(node, "dolg")) then
				if(AddPlayerMoney(thePlayer, -xmlNodeGetAttribute(node, "dolg"))) then
					out = out+xmlNodeGetAttribute(node, "dolg")
					AddBizMoney("ELSF", xmlNodeGetAttribute(node, "dolg"))
					xmlNodeSetAttribute(node, "dolg", nil)
					setElementData(getElementByID(xmlNodeGetName(node)), "price", GetHousePrice(node))
				end
			end
		end
	end
	out = "Ты заплатил "..COLOR["DOLLAR"]["HEX"].."$"..out.." #FFFFFFза электричество"
	ToolTip(thePlayer, out)
end
addCommandHandler("el", el)



function ServerSave()
	xmlSaveFile(CarNode)
	xmlSaveFile(HouseNode)
	xmlSaveFile(BizNode)
	xmlSaveFile(FishesNode)
	xmlSaveFile(PlayerNode)
	xmlSaveFile(ZoneNode)
	xmlSaveFile(ThreesNode)


	local hFile = fileOpen("serverdata/time.txt")
	fileWrite(hFile, tostring(ServerDate.timestamp))
    fileClose(hFile)
end


function ServerOff(name)
	ServerSave()

	xmlUnloadFile(CarNode)
	xmlUnloadFile(HouseNode)
	xmlUnloadFile(BizNode)
	xmlUnloadFile(FishesNode)
	xmlUnloadFile(PlayerNode)
	xmlUnloadFile(ZoneNode)
	xmlUnloadFile(ThreesNode)
end
addEventHandler("onResourceStop", getResourceRootElement(), ServerOff)





local DeathMatchs = {-- x,y,z,i,d,rz
	["Aldea_Malvada"] = {
		[1] = {-1311.6, 2512.5, 87, 0,0, 180}, 
		[2] = {-1298.5, 2547.4, 87.7, 0,0, 270}, 
		[3] = {-1287.8, 2514.1, 87.1, 0,0, 180}, 
		[4] = {-1334.3, 2525.6, 87, 0,0, 270}, 
	},
	["Marco's_Bistro"] = {
		[1] = {-823.9, 503.1, 1358.9, 1,0, 270}, 
		[2] = {-834.2, 521.3, 1357.1, 1,0, 180}, 
		[3] = {-782.4, 506.1, 1371.7, 1,0, 90}, 
		[4] = {-788.1, 494.1, 1376.2, 1,0, 0}, 
	}, 
	["Palomino_Creek"] = {
		[1] = {2312.3, -15.7, 32.5, 0,0, 0}, 
		[2] = {2330.9, 52.7, 33, 0,0, 90}, 
		[3] = {2306.4, 79.2, 30.5, 0,0, 270}, 
		[4] = {2330.2, 18.4, 34.5, 0,0, 0}, 
		[5] = {2262.8, 70.1, 32, 0,0, 270}, 
		[6] = {2307.8, -68.6, 34.5, 0,0, 0}, 
	}, 
	["San_Fierro_Bay"] = {
		[1] = {-2308.9, 1544.9, 18.8, 0,0, 90}, 
		[2] = {-2357.4, 1553.1, 26, 0,0, 180}, 
		[3] = {-2473.3, 1544.8, 36.8, 0,0, 270}, 
		[4] = {-2370.5, 1535.4, 10.8, 0,0, 90}, 
		[5] = {-2412.8, 1540.6, 10.8, 0,0, 0}, 
		[6] = {-2474.7, 1548.5, 33.2, 0,0, 270}, 
	}, 
	
}
local ListDeathmatchs = {}
for name, _ in pairs(DeathMatchs) do
	ListDeathmatchs[#ListDeathmatchs+1] = name
end





function SpawnthePlayer(thePlayer, typespawn, zone)
	if(not PData[thePlayer]["auth"]) then kickPlayer(thePlayer) return false end
	toggleAllControls(thePlayer,true)
	toggleControl(thePlayer, "next_weapon", false)
	toggleControl(thePlayer, "previous_weapon", false)
	toggleControl(thePlayer, "enter_exit", true)
	toggleControl(thePlayer, "radar", false)
	setPlayerNametagShowing(thePlayer, false)

	setPlayerMoney(thePlayer, GetPlayerMoney(thePlayer), true)


	local skills = fromJSON(GetDatabaseAccount(thePlayer, "skill"))
	for name, val in pairs(skills) do
		setPedStat(thePlayer, name, val)
	end

	if(not zone) then
		local x,y,z = GetPlayerLocation(thePlayer)
		zone = GetZoneName(x,y,z,true, getElementData(thePlayer, "City"))
	end
	
	local skin = GetDatabaseAccount(thePlayer, "skin")
	local frname = GetDatabaseAccount(thePlayer, "team")


	local job = IsPlayerJob(getPlayerName(thePlayer))
	if(not job) then job = "нет" end
	setElementData(thePlayer, "job", job)

	local About = fromJSON(GetDatabaseAccount(thePlayer, "about"))
	setElementData(thePlayer, "Birthday", About["Birthday"])

	setElementData(thePlayer, "inv", GetDatabaseAccount(thePlayer, "inv"))
	setElementData(thePlayer, "NoFireMePolice", "0")

	if(PData[thePlayer]["DeathMatch"]) then
		local rand = DeathMatchs[SData["DmName"]][math.random(#DeathMatchs[SData["DmName"]])]
		skin = SkinList[math.random(#SkinList)]
		
		local r, g, b = getTeamColor(SkinData[skin][2])
		setBlipColor(PData[thePlayer]['radar'], r,g,b, 255)
		
		spawnPlayer(thePlayer, rand[1], rand[2], rand[3], rand[6], skin, rand[4], rand[5])
	else
		if(frname == "Уголовники") then
			local Prison = GetDatabaseAccount(thePlayer, "Prison")
			spawnPlayer(thePlayer, SpawnPoint[Prison][1]+math.random(-1,1), SpawnPoint[Prison][2]+math.random(-1,1), SpawnPoint[Prison][3], SpawnPoint[Prison][4], skin, SpawnPoint[Prison][7], SpawnPoint[Prison][8])
			SetDatabaseAccount(thePlayer, "wanted", 0)
			setElementData(thePlayer, "WantedLevelPrison", PlayerPrison)
		elseif(frname == "Военные" and GetDatabaseAccount(thePlayer, "ATUT") <= 2) then
			spawnPlayer(thePlayer, SpawnPoint["Zone 51 Army"][1], SpawnPoint["Zone 51 Army"][2], SpawnPoint["Zone 51 Army"][3], SpawnPoint["Zone 51 Army"][4], skin, 0, 0)
			if(GetDatabaseAccount(thePlayer, "ATUT") == 0) then
				SetDatabaseAccount(thePlayer, "ATUT", 1)
				AddInventoryItem(thePlayer, {["name"] = "АК-47", ["txd"] = "АК-47"})
				triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 228, 228, 228, "Служба: найди способ нажраться")
			elseif(GetDatabaseAccount(thePlayer, "ATUT") == 1) then
				triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 228, 228, 228, "Служба: найди способ нажраться")
			elseif(GetDatabaseAccount(thePlayer, "ATUT") == 2) then
				triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 228, 228, 228, "Посади заключенного на бутылку")
			end
		else
			if(typespawn == "death") then
				if(GetPlayerMoney(thePlayer) >= 500) then
					AddPlayerMoney(thePlayer, -500)
					AddBizMoney(ClinicSpawn[zone][6], 500)
					ToolTip(thePlayer, "Клиника #CC99EE"..zone.."\n#FFFFFFСчёт за лечение "..COLOR["DOLLAR"]["HEX"].."$500")
				end
				
				spawnPlayer(thePlayer, ClinicSpawn[zone][1]+math.random(-2,2), ClinicSpawn[zone][2]+math.random(-2,2), ClinicSpawn[zone][3], ClinicSpawn[zone][4], skin, 0, ClinicSpawn[zone][5])
			elseif(typespawn == "house") then
				spawnPlayer(thePlayer, 0, 0, 0, 0, skin, 0, 0)
				triggerEvent("EnterHouse", thePlayer, zone, true)
			elseif(typespawn == "street") then
				spawnPlayer(thePlayer, SpawnPoint[zone][1]+math.random(-2,2), SpawnPoint[zone][2]+math.random(-1,1), SpawnPoint[zone][3], SpawnPoint[zone][4], skin, SpawnPoint[zone][7], SpawnPoint[zone][8])
			end
		end
		
		
		
		UpdateTutorial(thePlayer)
	end


	if(SkinData[skin]) then
		setPedWalkingStyle(thePlayer, SkinData[skin][1])
	end
	setCameraTarget(thePlayer, thePlayer)
	fadeCamera(thePlayer, true, 4.0)
	BindAllKey(thePlayer)

	WantedLevel(thePlayer, 0)
	setPedHeadless(thePlayer, false)
	SyncTime(thePlayer)
	useinvweapon(thePlayer)

	if(not PData[thePlayer]["Timer"]) then
		setElementData(thePlayer, "armasplus", toJSON({}))
		PData[thePlayer]["Timer"] = setTimer(function(thePlayer)
			if(GetDatabaseAccount(thePlayer, "wanted") > 0) then
				WantedLevel(thePlayer, -0.25)
			end
			if(isPlayerBolezn(thePlayer, "СПИД")) then
				setElementHealth(thePlayer, getElementHealth(thePlayer)-5)
				Pain(thePlayer)
			end

			if(isPlayerBolezn(thePlayer, "Порванный анус")) then
				BloodFoot(thePlayer, true)
				setElementHealth(thePlayer, getElementHealth(thePlayer)-3)
				Pain(thePlayer)
			end

			if(isPlayerBolezn(thePlayer, "Дизентерия")) then
				local rand = math.random(1,20)
				if(rand == 1) then
					StartAnimation(thePlayer, "FOOD", "EAT_Vomit_P",false,false,false,false)
				end
			end


			if(getPedStat(thePlayer, 24) < 569) then
				AddSkill(thePlayer, 24, 1)
			end
		end, 60000, 0, thePlayer)
	end


	if(PData[thePlayer]["SkinChange"]) then
		PData[thePlayer]["SkinChange"] = nil
		F4_Load(thePlayer)
	end
end
addEvent("SpawnthePlayer", true)
addEventHandler("SpawnthePlayer", root, SpawnthePlayer)







function UpdateTutorial(thePlayer)
	local team = getTeamName(getPlayerTeam(thePlayer))
	if(team == "Мирные жители") then
		if(GetDatabaseAccount(thePlayer, "CTUT") == 0) then
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, -255, 2603.3, 62.96, "Дойди до магазина", "Зайди в магазин и купи пачку #596289сигарет")
		elseif(GetDatabaseAccount(thePlayer, "CTUT") == 1) then
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 228, 228, 228, "Зайди в бар и вступи в банду")
		end
	elseif(team == "Полиция") then
		outputChatBox("Используй клавишу #A0A0A0B#FFFFFF чтобы вызвать подмогу", thePlayer, 255, 255, 255, true)
		if(GetDatabaseAccount(thePlayer, "COPTUT") == 0) then
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 1568.7, -1690, 6.2, "Посети участок", "Зайди в раздевалку и получи #596289экипировку")
		end
	elseif(team == "МЧС") then
		outputChatBox("Чтобы лечить пациентов тебе нужна донорская #FF0000кровь#FFFFFF", thePlayer, 255, 255, 255, true)
		outputChatBox("Для получения #FF0000крови#FFFFFF тебе нужно положить донора на кушетку в больнице и начать забор #FF0000крови#FFFFFF", thePlayer, 255, 255, 255, true)
	elseif(team == "Якудзы") then
		if(GetDatabaseAccount(thePlayer, "YTUT") == 0) then
			SetDatabaseAccount(thePlayer, "YTUT", 1)
		end
	elseif(team == "Баллас") then
		if(GetDatabaseAccount(thePlayer, "BTUT") == 0) then
			HelpMessage(thePlayer, "Отправляйся на ферму и посади лист #558833конопли#FFFFFF")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, -1107.4, -1094.2, 129.2, "Ферма", "Открой инвентарь #A0A0A0i#FFFFFF и дважды нажми на лист #558833конопли")
			AddInventoryItem(thePlayer, {["txd"] = "Конопля", ["name"] = "Конопля", ["count"] = 1, ["quality"] = 1})
			SetDatabaseAccount(thePlayer, "BTUT", 1)
		elseif(GetDatabaseAccount(thePlayer, "BTUT") == 1) then
			HelpMessage(thePlayer, "Отправляйся на ферму и посади лист #558833конопли#FFFFFF")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, -1107.4, -1094.2, 129.2, "Ферма", "Открой инвентарь #A0A0A0i#FFFFFF и дважды нажми на лист #558833конопли")
		elseif(GetDatabaseAccount(thePlayer, "BTUT") == 2) then
			HelpMessage(thePlayer, "Чтобы продолжить обучение собери урожай #558833конопли")
		elseif(GetDatabaseAccount(thePlayer, "BTUT") == 3) then
			HelpMessage(thePlayer, "Отправляйся в притон и изготовь #558833косяк")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 1257.3, 241.8, 18.9, "Притон", "Зайди в притон и изготовь #558833косяк")
		end
	elseif(team == "Колумбийский картель") then
		if(GetDatabaseAccount(thePlayer, "KTUT") == 0) then
			HelpMessage(thePlayer, "Отправляйся на плантацию и посади лист коки")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 1466.6, -80.4, 19.3, "Плантация", "Открой инвентарь #A0A0A0i#FFFFFF и дважды нажми на лист коки")
			AddInventoryItem(thePlayer, {["txd"] = "Кока", ["name"] = "Кока", ["count"] = 1, ["quality"] = 1})
			SetDatabaseAccount(thePlayer, "KTUT", 1)
		elseif(GetDatabaseAccount(thePlayer, "KTUT") == 1) then
			HelpMessage(thePlayer, "Отправляйся на плантацию и посади лист коки")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, 1466.6, -80.4, 19.3, "Плантация", "Открой инвентарь #A0A0A0i#FFFFFF и дважды нажми на лист коки")
		elseif(GetDatabaseAccount(thePlayer, "KTUT") == 2) then
			HelpMessage(thePlayer, "Чтобы продолжить обучение собери урожай коки")
		elseif(GetDatabaseAccount(thePlayer, "KTUT") == 3) then
			HelpMessage(thePlayer, "Отправляйся в притон и изготовь спанк")
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, -2624.6, 1412.65, 7.1, "Притон", "Зайди в притон и изготовь спанк")
		end
	end
end

local Soviet = {"Никогда не заводи машину во время заправки",
"Закрытую машину можно вскрыть грубой силой (выбить дверь)",
"Используй #A0A0A0ПКМ#FFFFFF для стрельбы из автомобиля",
"Клавишей #A0A0A0Num 0#FFFFFF можно заглушить/завести машину",
"Клавишей #A0A0A0Num 8#FFFFFF можно управлять фарами",
"Клавишами #A0A0A0Num 4,6,1,3#FFFFFF можно управлять дверьми автомобиля",
"Клавишами #A0A0A0Num 7,9#FFFFFF можно управлять магнитолой (музыку слышат все)",
"#A0A0A0/cmd#FFFFFF - узнать список команд",
"Не разгоняйся! от столкновения водителю и его пассажирам наносится урон",
"Уровень розыска падает на 1 звезду каждые 4 игровых часа",
"Используй клавишу #A0A0A0R#FFFFFF для перезарядки",
"Сбежав с принудительного #A0A0A0психиатрического#FFFFFF лечения вы получите x2 розыск",
"Сдавшись #4169E1полиции#FFFFFF мирным путем срок сокращают в 2 раза",
"Вовремя платите по счетам за электричество, иначе у вас конфискуют имущество",
"Занимаясь бегом можно повысить максимальное здоровье и выносливость, умирая максимальное здоровье падает",
"Рейтинг игроков обновляется каждые 00:00 по игровому времени",
"Снятую с игроков одежду можно использовать в личном гардеробе",
"У мирных жителей можно узнать много полезной информации",
"В барах и на улице можно встретить членов различных бандитских группировок, поговорив с которыми есть возможность вступить в банду",
"Используй клавишу #A0A0A0F12#FFFFFF чтобы скрыть интерфейс",
"Используй клавишу #A0A0A0F10#FFFFFF чтобы открыть карту ресурсов",
"Используй клавишу #A0A0A0F9#FFFFFF чтобы выключить режим для слабых компьютеров",
}
function DatSoviet() outputChatBox("#4682B4* Совет#FFFFFF "..Soviet[math.random(1,#Soviet)],getRootElement(), 255, 255, 255, true) end
setTimer(function() DatSoviet() end, 600000, 0)



function GetItemCount(item)
	return item["count"] or 1
end



function GetItemQuality(item)
	return item["quality"] or 550
end


function moneyPickupHit(thePlayer)
	if(getElementData(source, "arr")) then
		PlayersPickups[thePlayer] = source
		if(getPickupRespawnInterval(source) == 0) then
			local item = fromJSON(getElementData(source, "arr"))
			ToolTip(thePlayer, "Подобрать "..COLOR["KEY"]["HEX"].."TAB#FFFFFF \n#4682B4"..item["name"].." #FFFFFF"..GetItemCount(item).." шт")
		else
			TABEvent(thePlayer) -- Сразу подбираем, для выпадаемых с ботов денег
		end
	elseif(getElementData(source, "biz")) then
		local text = "Цена: $"..getElementData(source, "price")
		local advtext = "\nНажми "..COLOR["KEY"]["HEX"].."ALT#FFFFFF чтобы открыть информацию"
		if(getElementData(source, "bizowner")) then
			text = "Владелец: "..getElementData(source, "bizowner")
			if(getElementData(source, "bizowner") == getPlayerName(thePlayer)) then
				advtext = advtext.."\nНажми "..COLOR["KEY"]["HEX"].."TAB#FFFFFF чтобы продать бизнес"

				if(getElementData(source, "money")) then
					AddPlayerMoney(thePlayer, tonumber(getElementData(source, "money")))
					AddBizMoney(getElementData(source, "name"), -getElementData(source, "money"))
				end
			end
		else
			advtext = advtext.."\nНажми "..COLOR["KEY"]["HEX"].."TAB#FFFFFF чтобы купить бизнес"
		end
		HelpMessage(thePlayer, advtext)
		MissionCompleted(thePlayer, text, getElementData(source, "biz"))
		PlayersPickups[thePlayer] = source
	elseif(getElementData(source, "wardrobe")) then
		PlayersPickups[thePlayer] = source
		ToolTip(thePlayer, "Нажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы переодеться")
	elseif(getElementData(source, "wardrobeShop")) then
		PlayersPickups[thePlayer] = source
		ToolTip(thePlayer, "Нажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы купить одежду")
		PlayersEnteredPickup[thePlayer] = source
	elseif(getElementData(source, "type") == "function") then
		triggerClientEvent(thePlayer, "ChangeInfo", thePlayer, getElementData(source, "funcinfo").."\n#FFFFFFНажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы использовать", 3000)
		PlayersEnteredPickup[thePlayer] = source
	elseif(getElementData(source, "type") == "armour") then
		setPedArmor(thePlayer, 100)
		local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
		if(PlayerTeam == "Полиция") then
			if(GetDatabaseAccount(thePlayer, "COPTUT") == 0) then
				SetDatabaseAccount(thePlayer, "COPTUT", 1)
				MissionCompleted(thePlayer, "ЭКИПИРОВКА +", "МИССИЯ ВЫПОЛНЕНА")
				triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
			end
		end
	elseif(getElementData(source, "type") == "enter") then
		PlayersEnteredPickup[thePlayer] = source
		local text = Text(thePlayer, "Нажми {key} чтобы войти", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}})
		if(getElementData(source, "house")) then
			local x,y,z = getElementPosition(source)
			local ZName = getZoneName(x,y,z)
			if(getElementData(source, "owner") == "") then
				MissionCompleted(thePlayer, "$"..getElementData(source, "price"), ZName.." "..getElementData(source, "zone"))
				text = text.."\n"..Text(thePlayer, "Нажми {key} чтобы купить дом", {{"{key}", COLOR["KEY"]["HEX"].."TAB#FFFFFF"}})
			end
		end
		ToolTip(thePlayer, text)
	else
		if(getElementModel(source) == 1247) then
			WantedLevel(thePlayer, -1)
		end
	end
end
addEvent("onPickupUse", true)
addEventHandler("onPickupUse", getRootElement(), moneyPickupHit)



function Udobrenya(thePlayer, x,y) 
	if(PData[thePlayer]["ThreeCol"]) then
		if(isElementWithinColShape(thePlayer, PData[thePlayer]["ThreeCol"])) then
			local Node = xmlFindChild(ThreesNode, getElementData(PData[thePlayer]["ThreeCol"], "Three"), 0)
			local t = tonumber(xmlNodeGetAttribute(Node, "t"))
			if(t > 0 ) then
				local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))
				xmlNodeSetAttribute(Node, "t", t-arr[x][y]["quality"])
				HelpMessage(thePlayer, "Ты сократил рост растения на #ffff00"..arr[x][y]["quality"].."#FFFFFF сек.")
				RemoveInventoryItemCount(thePlayer, x, y)
			else
				HelpMessage(thePlayer, "Растение не нуждается в #ffff00удобрении")
			end
			return true
		end
	end
	return ToolTip(thePlayer, "Для удобрения необходимо находится возле растения")
end
addEvent("Udobrenya", true)
addEventHandler("Udobrenya", getRootElement(), Udobrenya)






function PickupHit(thePlayer)
	if(getElementModel(source) == 1247) then
		usePickup(source, thePlayer)
	end
end
addEventHandler("onPickupHit", getRootElement(), PickupHit)



local SearchLights = {
	[1] = {
		["A51_SPOTBULB"] = createObject(2887, 166.003, 1849.937, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 166.003, 1849.937, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 166.003, 1849.937, 36.246), 
	}, 
	[2] = {
		["A51_SPOTBULB"] = createObject(2887, 262.145, 1807.62, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 262.145, 1807.62, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 262.145, 1807.62, 36.246), 
	},
	[3] = {
		["A51_SPOTBULB"] = createObject(2887, 267.116, 1895.241, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 267.116, 1895.241, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 267.116, 1895.241, 36.246), 
	}, 
	[4] = {
		["A51_SPOTBULB"] = createObject(2887, 233.486, 1934.789, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 233.486, 1934.789, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 233.486, 1934.789, 36.246), 
	}, 
	[5] = {
		["A51_SPOTBULB"] = createObject(2887, 161.962, 1933.043, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 161.962, 1933.043, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 161.962, 1933.043, 36.246), 
	}, 
	[6] = {
		["A51_SPOTBULB"] = createObject(2887, 103.946, 1901.047, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 103.946, 1901.047, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 103.946, 1901.047, 36.246), 
	}, 
	[7] = {
		["A51_SPOTBULB"] = createObject(2887, 113.439, 1814.405, 36.246),
		["A51_SPOTHOUSING"] = createObject(2888, 113.439, 1814.405, 36.246), 
		["A51_SPOTBASE"] = createObject(2889, 113.439, 1814.405, 36.246), 
	}
}


for _, v in pairs(SearchLights) do
	local rx,ry,rz = getElementRotation(v["A51_SPOTBULB"])
	setElementRotation(v["A51_SPOTBULB"], 330,ry,math.random(0,360))
	attachElements(v["A51_SPOTHOUSING"], v["A51_SPOTBULB"])
end




-- [timestamp] = command
local Events = {
	[570556800] = "DestroyDoherty", -- 01/30/1988 @ 4:00pm (UTC)
}



function worldtime()
	for _, v in pairs(SearchLights) do
		local x,y,z = getElementPosition(v["A51_SPOTBULB"])
		moveObject(v["A51_SPOTBULB"], 1000,  x,y,z, 0,0,math.random(-20,20))
	end

	for thePed,_ in pairs(SData["DriverBot"]) do
		if(isElement(thePed)) then
			if(not isPedDead(thePed)) then
				if(SData["PlayerElementSync"][thePed]) then
					if(TimersAgain[thePed]) then
						TimersAgain[thePed] = nil
						SetNextDynamicNode(thePed)
					end
				else
					if(getElementData(thePed, "DynamicBot")) then
					--	SetNextDynamicNode(thePed)
					end
				end
			else
				SData["DriverBot"][thePed] = nil
			end
		else
			SData["DriverBot"][thePed] = nil
		end
	end


	local hour, minutes = getTime()
	ServerDate = getRealTime(ServerDate.timestamp+60)
	if(minutes == 0) then
		callRemote("http://109.227.228.4/engine/include/MTA/get_online.php", ResultGet)

		for name, dat in pairs(BizInfo) do
			local items = GetBizGeneration(name)
			if(#items["Sell"] > 0) then -- Если есть создаваемые товары
				if(#items["Trade"] == 0) then -- Создаваемые без обмена на что либо
					for _, item in pairs(items["Sell"]) do
						AddBizProduct(name, item, 1)
					end
				else
					local status = true
					local bonus = 1
					--[[
						* Удобрения вспомогательный бонус. Ускоряет в 5 раз
					--]]
					for _, item in pairs(items["Trade"]) do -- Проверяем есть ли все товары на обмен
						if(not AddBizProduct(name, item, -1, true)) then -- Без сохранения
							if(item ~= "Удобрения") then
								status = false
							end
						else
							if(item == "Удобрения") then
								bonus = 5
							end
						end
					end

					for _, item in pairs(items["Sell"]) do -- Проверяем нужно ли производить материалы
						if(not AddBizProduct(name, item, 1, true)) then -- Без сохранения
							status = false
						end
					end

					if(status == true) then -- Начинаем обмен
						for _, item in pairs(items["Trade"]) do
							AddBizProduct(name, item, -1)
						end

						for _, item in pairs(items["Sell"]) do
							AddBizProduct(name, item, 1*bonus)
						end
					end
				end
			else
				for _, item in pairs(items["Sell"]) do -- Если потребитель
					AddBizProduct(name, item, -1)
				end
			end
		end



		if(hour == 3 or hour == 9 or hour == 15 or hour == 21) then
			triggerEvent("NewWeather", root)
		end

		if(hour == 0) then
			ServerSave() -- Сохранение данных на диск
			if(ServerDate.monthday == 1) then -- Первый день месяца
				SpawnCarForSale(true)
				SpawnAllVehicle()
			end
			setElementData(root, "ServerTime", ServerDate.timestamp)
		end
		for v,k in pairs(Threes) do
			if(isElement(Threes[v])) then
				local Node = xmlFindChild(ThreesNode, v, 0)
				local t = tonumber(xmlNodeGetAttribute(Node, "t"))
				if(t-60 >= 0) then
					xmlNodeSetAttribute(Node, "t", t-60)
				else
					xmlNodeSetAttribute(Node, "t", 0)
				end
			end
		end
	elseif(minutes == 30) then
		if(hour == 12) then
			PayDay()
		elseif(hour == 17) then
			local bizNode = xmlNodeGetChildren(BizNode)
			for c,node in ipairs(bizNode) do
				local srok = xmlNodeGetAttribute(node, "srok")
				if(srok) then
					srok = tonumber(srok)
					if(srok == 0) then
						if(not SData["Vibori"]) then
							xmlNodeSetAttribute(node, "srok", 420)--Неделя
							outputChatBox("Стартуют выборы на пост "..xmlNodeGetAttribute(node, "biz"), getRootElement(), 255, 255, 255, true)
							outputChatBox("Напиши "..COLOR["KEY"]["HEX"].."/st #FFFFFFчтобы выдвинуть свою кандидатуру", getRootElement(), 255, 255, 255, true)
							SData["Vibori"]=xmlNodeGetName(node)
							setTimer(ststart, 60000, 1)
						end
					else
						xmlNodeSetAttribute(node, "srok", srok-1)
					end
				end
			end
		end
	end

	for zone, team in pairs(CapZone) do
		local r,g,b = getTeamColor(getTeamFromName(GetDatabaseZoneNode(zone)))
		local tr,tg,tb = getTeamColor(getTeamFromName(team))
		local c1,c2,c3,_ = getRadarAreaColor(WARGANG[zone][1])
		if(c1 == r and c2 == g and c3 == b) then
			for slot = 1, #WARGANG[zone] do
				setRadarAreaColor(WARGANG[zone][slot], tr,tg,tb,140)
			end
		else
			for slot = 1, #WARGANG[zone] do
				setRadarAreaColor(WARGANG[zone][slot], r,g,b,140)
			end
		end

		local PlayerInZone = {}
		local players = getPlayersInTeam(getTeamFromName(team))
		for playerKey, playerValue in ipairs (players) do
			local x,y,z = getElementPosition(playerValue)
			if(getZoneName(x,y,z) == zone) then
				PlayerInZone[#PlayerInZone+1]=playerValue
			end
		end

		local TotalVehicle = 0
		if(VehicleBand[zone]) then
			for slot = 1, #VehicleBand[zone] do
				local theVehicle = VehicleBand[zone][slot]
				if(isElement(theVehicle)) then
					local vx,vy,vz = getElementPosition(theVehicle)
					if(zone == getZoneName(vx,vy,vz) and getElementHealth(theVehicle) > 0) then
						if(not isElement(DynamicBlip[theVehicle])) then
							DynamicBlip[theVehicle] = createBlipAttachedTo(theVehicle, 0, 1, r,g,b, 200, 2)
							setElementVisibleTo(DynamicBlip[theVehicle], root, false)
							DynamicMar[theVehicle] = createMarker(vx,vy,vz, "arrow", 1, 255, 0, 0, 200)
							attachElements(DynamicMar[theVehicle], theVehicle, 0, 0, 2)
							setElementVisibleTo(DynamicMar[theVehicle], root, false)

							for _,k in pairs(PlayerInZone) do
								setElementVisibleTo(DynamicBlip[theVehicle], k, true)
								setElementVisibleTo(DynamicMar[theVehicle], k, true)
							end
						else
							setElementVisibleTo(DynamicBlip[theVehicle], root, false)
							setElementVisibleTo(DynamicMar[theVehicle], root, false)
							for _,k in pairs(PlayerInZone) do
								setElementVisibleTo(DynamicBlip[theVehicle], k, true)
								setElementVisibleTo(DynamicMar[theVehicle], k, true)
							end
						end
						TotalVehicle = TotalVehicle+1
					else
						if(isElement(DynamicBlip[theVehicle])) then
							destroyElement(DynamicBlip[theVehicle])
							destroyElement(DynamicMar[theVehicle])
						end
					end
				end
			end
		end

		local TotalBot = 0
		if(BotCreated[zone]) then
			for slot = 1, #BotCreated[zone] do
				local ped = BotCreated[zone][slot]
				if(isElement(ped)) then
					local vx,vy,vz = getElementPosition(ped)
					local team = getElementData(ped, "team")
					if(team == GetDatabaseZoneNode(zone)) then
						if(not getElementData(ped, "NextNode")) then
							if(zone == getZoneName(vx,vy,vz, false) and not isPedDead(ped)) then
								if(not isElement(DynamicBlip[ped])) then
									DynamicBlip[ped] = createBlipAttachedTo(ped, 0, 1, r,g,b, 200, 2)
									setElementVisibleTo(DynamicBlip[ped], root, false)
									DynamicMar[ped] = createMarker(vx,vy,vz, "arrow", 1, 255, 0, 0, 200)
									attachElements(DynamicMar[ped], ped, 0, 0, 2)
									setElementVisibleTo(DynamicMar[ped], root, false)
									for _,k in pairs(PlayerInZone) do
										setElementVisibleTo(DynamicBlip[ped], k, true)
										setElementVisibleTo(DynamicMar[ped], k, false)
									end
								else
									setElementVisibleTo(DynamicBlip[ped], root, false)
									setElementVisibleTo(DynamicMar[ped], root, false)
									for _,k in pairs(PlayerInZone) do
										setElementVisibleTo(DynamicBlip[ped], k, true)
										setElementVisibleTo(DynamicMar[ped], k, true)
									end
								end
								TotalBot = TotalBot + 1
							else
								if(isElement(DynamicBlip[ped])) then
									destroyElement(DynamicBlip[ped])
									destroyElement(DynamicMar[ped])
								end
							end
						end
					end
				end
			end
		end

		if(#PlayerInZone == 0) then
			stopCap(zone,r,g,b, SpawnPoint[zone][6], true, true)
		else
			if(TotalVehicle == 0 and TotalBot == 0) then
				okCap(zone,tr,tg,tb, team)
			else
				local advinfo = "Захват "..RGBToHex(r,g,b)..zone.."\n"
				if(TotalVehicle > 0) then
					advinfo = advinfo.."#FFFFFFУничтожь вражескую технику "..#VehicleBand[zone]-TotalVehicle.."/"..#VehicleBand[zone].."\n"
				end
				if(TotalBot > 0) then
					advinfo = advinfo.."#FFFFFFУбей врагов "..TotalBot.."\n"
				end
				for playerKey, playerValue in ipairs (PlayerInZone) do
					triggerClientEvent(playerValue, "ChangeInfoAdv", playerValue, advinfo, 2000)
					triggerEvent("ZoneInfo", playerValue, playerValue, zone)
				end
			end
		end
	end

	PrisonEvent(hour, minutes)

	if(Events[ServerDate.timestamp]) then
		triggerEvent(Events[ServerDate.timestamp], root)
	end
end








function getPointInFrontOfPoint(x, y, z, rZ, dist)
	local offsetRot = math.rad(rZ)
	local vx = x + dist * math.cos(offsetRot)
	local vy = y + dist * math.sin(offsetRot)
	return vx, vy, z
end




local TotalDamage = {}
function DestroyObject(thePlayer, obj)
	if(not TotalDamage[thePlayer]) then TotalDamage[thePlayer] = 0 end

	if(tonumber(obj)) then
		TotalDamage[thePlayer] = math.floor(TotalDamage[thePlayer]+obj)
		setElementData(thePlayer, "Damage", TotalDamage[thePlayer])
	else
		--if(ObjectCost[getElementModel(obj)]) then
		--	TotalDamage[thePlayer] = TotalDamage[thePlayer]+ObjectCost[getElementModel(obj)]
		--	setElementData(thePlayer, "Damage", TotalDamage[thePlayer])
		--end
	end
end
addEvent("DestroyObject", true)
addEventHandler("DestroyObject", getRootElement(), DestroyObject)




function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end


local PlateNumber = {
	[433] = "ARMY 228", 
	[470] = "ARMY 228", 
	[497] = "POLI 228",
	[490] = "ARMY 228", 
	[427] = "POLI 228", 
	[596] = "POLI 228", 
	[597] = "POLI 228", 
	[598] = "POLI 228", 
	[599] = "POLI 228", 
	[523] = "POLI 228", 
}

function CreateDriverBot(vmodel, pedmodel, x,y,z,i,d, path,attacker)
	path = exports["vehicle_node"]:GetCoordsByGPS(path)  -- Временное, переделывает ноды в координаты, потом доделать
	local rotz = findRotation(path[1][1], path[1][2], path[2][1], path[2][2])
	local v = CreateVehicle(vmodel, x,y,z+VehicleSystem[vmodel][1], 0, 0, rotz, PlateNumber[vmodel])
	local thePed = CreateBot(pedmodel,x,y,z,0,i,d,getZoneName(x,y,z))
	SData["DriverBot"][thePed] = path

	setElementData(thePed, "DynamicBot", toJSON({
		path[1][1], path[1][2], path[1][3], false,
		path[2][1], path[2][2], path[2][3], false
	}))
	if(i) then
		setElementInterior(v, i)
		setElementInterior(thePed, i)
	end
	if(d) then
		setElementDimension(v, d)
		setElementDimension(thePed, d)
	end

	if(attacker) then
		if(getElementType(attacker) == "player") then
			setElementData(thePed, "attacker", getPlayerName(attacker))
		end
	end
	setElementData(thePed, "SpawnBlock", "true", false)
	setElementData(thePed, "DestroyAfterStreamOut", "true", false)
	setPedStat(thePed, 160, 1000)
	setElementData(v, "destroy", "true", false)
	warpPedIntoVehicle(thePed,v)
	setVehicleSirensOn(v, true)
	return v
end




function kr(thePlayer, vmodel, pedmodel)
	if(not isTimer(PData[thePlayer]["PoliceTimer"])) then
		local x,y,z = getElementPosition(thePlayer)
		local i, d = getElementInterior(thePlayer), getElementDimension(thePlayer)
		if(i == 0 and d == 0) then
			local arr = {
				["west"] = exports["vehicle_node"]:NEWGPSFound(x-100,y,z, x,y,z),
				["east"] = exports["vehicle_node"]:NEWGPSFound(x+100,y,z, x,y,z),
				["south"] = exports["vehicle_node"]:NEWGPSFound(x,y+100,z, x,y,z),
				["north"] = exports["vehicle_node"]:NEWGPSFound(x,y-100,z, x,y,z)
			}

			for name, dat in pairs(arr) do
				if(dat) then
					if(#dat < 5) then -- Отсекаем слишком короткие пути
						arr[name] = nil
					end
				else
					arr[name] = nil
				end
			end
			if(getArrSize(arr) > 0) then
				local ind = 0
				local minarrindex = math.random(getArrSize(arr))
				for name, dat in pairs(arr) do
					ind = ind+1
					if(ind == minarrindex) then
						local bx,by,bz = PathNodes[arr[name][1][1]][arr[name][1][2]][2], PathNodes[arr[name][1][1]][arr[name][1][2]][3], PathNodes[arr[name][1][1]][arr[name][1][2]][4]
						if(vmodel == 497 or vmodel == 488) then
							bz = bz+25
						end
						CreateDriverBot(vmodel, pedmodel, bx, by, bz, 0, 0, arr[name], thePlayer)
						PData[thePlayer]["PoliceTimer"] = setTimer(function(thePlayer) end, 5000, 1, thePlayer)
					end
				end
			end
		end
	end
end








local FireTruckModel = {
	["Los Santos"] = 277,
	["San Fierro"] = 279,
	["Las Venturas"] = 278,
	["Red County"] = 277,
	["Whetstone"] = 279,
	["Flint County"] = 277, 
	["Bone County"] = 278,
	["Tierra Robada"] = 278,
}

function FireTruck(x,y,z,i,d)
	local zone = getZoneName(x,y,z, true)
	
	if(FireTruckModel[zone] and d == 0) then
		local arr = {
			["west"] = exports["vehicle_node"]:NEWGPSFound(x-120,y,z, x,y,z),
			["east"] = exports["vehicle_node"]:NEWGPSFound(x+120,y,z, x,y,z),
			["south"] = exports["vehicle_node"]:NEWGPSFound(x,y+120,z, x,y,z),
			["north"] = exports["vehicle_node"]:NEWGPSFound(x,y-120,z, x,y,z)
		}

		for name, dat in pairs(arr) do
			if(dat) then
				if(#dat < 5) then -- Отсекаем слишком короткие пути
					arr[name] = nil
				end
			else
				arr[name] = nil
			end
		end
		if(getArrSize(arr) > 0) then
			local ind = 0
			local minarrindex = math.random(getArrSize(arr))
			for name, dat in pairs(arr) do
				ind = ind+1
				if(ind == minarrindex) then
					local bx,by,bz = PathNodes[arr[name][1][1]][arr[name][1][2]][2], PathNodes[arr[name][1][1]][arr[name][1][2]][3], PathNodes[arr[name][1][1]][arr[name][1][2]][4]
					return CreateDriverBot(407, FireTruckModel[zone], bx, by, bz, 0, 0, arr[name])
				end
			end
		end
	end
end























function FoundNextRandomNode(node, id)
	local nextnodes = {}
	if(PathNodes[node][id][6]) then
		for v,k in pairs(PathNodes[node][id][6]) do
			--if(PathNodes[k[1]][k[2]][1] ~= "Closed") then
				table.insert(nextnodes, {k[1], k[2]})
			--end
		end
	end
	if(PathNodes[node][id+1]) then
		table.insert(nextnodes, {node, id+1})
	end
	return nextnodes[math.random(#nextnodes)]
end




local trafficlight = {
	["0"] = "west",
	["1"] = "west",
	["2"] = false,
	["3"] = "north",
	["4"] = "north"
}





function RemoveDynamicBot(thePed)
	if(thePed) then
		removeElementData(thePed, "DynamicBot")
		SData["DriverBot"][thePed] = nil
	end
end
addEvent("RemoveDynamicBot", true)
addEventHandler("RemoveDynamicBot", root, RemoveDynamicBot)





function SetNextDynamicNode(thePed, forced)
	if(thePed) then
		local dat = getElementData(thePed, "CurNode")
		local theVehicle = getPedOccupiedVehicle(thePed)
		if(dat) then
			local arr = fromJSON(dat)
			local node, id = arr[1], arr[2]
			local oldnode = fromJSON(getElementData(thePed, "NextNode"))
			local nextnode, nextid = oldnode[1], oldnode[2]
			if(PathNodes[nextnode][nextid][4]) then
				if(trafficlight[tostring(getTrafficLightState())] == PathNodes[nextnode][nextid][4]) then
					TimersAgain[thePed] = true
					return true
				end
			end
			if(PathNodes[nextnode][nextid][1] == true) then
				local nextnode2, nextid2 = unpack(FoundNextRandomNode(nextnode, nextid))
				setElementData(thePed, "DynamicBot", toJSON({
					PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3], PathNodes[nextnode][nextid][4], PathNodes[nextnode][nextid][5],
					PathNodes[nextnode2][nextid2][2], PathNodes[nextnode2][nextid2][3], PathNodes[nextnode2][nextid2][4], PathNodes[nextnode2][nextid2][5],

					}))

				PathNodes[node][id][1] = true
				PathNodes[nextnode][nextid][1] = false
				setElementData(thePed, "CurNode", toJSON({nextnode, nextid}), false)
				setElementData(thePed, "NextNode", toJSON({nextnode2, nextid2}), false)
				if(not SData["PlayerElementSync"][thePed] or forced) then
					if(theVehicle) then
						local model = getElementModel(theVehicle)
						local rotz = findRotation(PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3])

						setElementPosition(theVehicle, PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3], PathNodes[nextnode][nextid][4]+VehicleSystem[model][1])
						setElementRotation(theVehicle, 0,0,rotz)
					else
						setElementPosition(thePed, PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3], PathNodes[nextnode][nextid][4])
					end
				end
			else
				TimersAgain[thePed] = true
			end
		else
			if(SData["DriverBot"][thePed]) then
				if(SData["DriverBot"][thePed] ~= "auto") then
					table.remove(SData["DriverBot"][thePed], 1)
					if(#SData["DriverBot"][thePed] > 2) then
						setElementData(thePed, "DynamicBot", toJSON({
							SData["DriverBot"][thePed][1][1], SData["DriverBot"][thePed][1][2], SData["DriverBot"][thePed][1][3], false,
							SData["DriverBot"][thePed][2][1], SData["DriverBot"][thePed][2][2], SData["DriverBot"][thePed][2][3], false
						}))
					else
						RemoveDynamicBot(thePed)
					end
				end
			end
		end
	end
	return true
end
addEvent("SetNextDynamicNode", true)
addEventHandler("SetNextDynamicNode", root, SetNextDynamicNode)



function SetDynamicBot(thePed, x,y,z)
	if(thePed) then
		if(not x) then
			x,y,z = getElementPosition(thePed)
		end
		local node = getZoneName(x,y,z, false)
		local id = false
		local mindist = 3000
		if(PathNodes[node]) then
			for i,v in pairs(PathNodes[node]) do
				if(v[1]) then
					local dist = getDistanceBetweenPoints3D(x,y,z, v[2], v[3], v[4])
					if(dist < mindist) then
						mindist = dist
						id = i
					end
				end
			end
		end
		
		if(id) then
			removeElementData(thePed, "attacker")
			CreateDynamicBot(thePed, node, id)
		else
			destroyElement(thePed)
		end
	end
end
addEvent("SetDynamicBot", true)
addEventHandler("SetDynamicBot", root, SetDynamicBot)








function CreateDynamicBot(thePed, node, id)
	if(PathNodes[node][id][1] == true) then
		PathNodes[node][id][1] = false -- Блокируем ноду
		local x,y,z = PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[node][id][4]
		local nextnode, nextid = unpack(FoundNextRandomNode(node, id))

		local nextnode2, nextid2 = unpack(FoundNextRandomNode(nextnode, nextid))


		if(not thePed) then thePed = CreateRandomBot(x,y,z,0,0,0,getZoneName(x,y,z)) end

		SData["DriverBot"][thePed] = "auto"

		setElementData(thePed, "DynamicBot", toJSON({
			PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3], PathNodes[nextnode][nextid][4], PathNodes[nextnode][nextid][5],
			PathNodes[nextnode2][nextid2][2], PathNodes[nextnode2][nextid2][3], PathNodes[nextnode2][nextid2][4], PathNodes[nextnode2][nextid2][5],
		}))

		setElementData(thePed, "SpawnBlock", "true", false)
		setElementData(thePed, "CurNode", toJSON({node, id}), false)
		setElementData(thePed, "NextNode", toJSON({nextnode2, nextid2}), false)
		--createBlipAttachedTo(thePed,0,2,255,0,0, 255,0, 99999)
	else
		return false
	end
end


function InitDynamicBot()
	for district, arr in pairs(PathNodes) do
		for i, k in pairs(arr) do
			if(k[1] == true) then
				local rand = math.random(1,70)
				if(rand == 1) then
					CreateDynamicBot(false, district, i)
				end
			end
		end
	end
	return true
end

function UpdateBotRequest(thePlayer, thePed)
	SetNextDynamicNode(thePed, true)
end
addEvent("UpdateBotRequest", true)
addEventHandler("UpdateBotRequest", root, UpdateBotRequest)





local Objects = {
	["Doherty"] = { -- Будет разрушен в 1987
		[1] = createObject(10989, -2130.8, 149.10001, 45.6, 0,0,180.2),
		[2] = createObject(10952, -2034.3, 267, 45.8, 0,0,90),
		[3] = createObject(10952, -2033.8, 217.2, 40, 0,0,90.198),
		[4] = createObject(10998, -2033.5996, 135, 38, 0,0,359.797),
		[5] = createObject(10624, -2035, 169.60001, 37.4, 0,0,180),
		[6] = createObject(4576, -2078.7, 146.60001, 56, 0,0,89.3),
		[7] = createObject(10990, -2124.3999, 202, 50, 0,0,180),
		[8] = createObject(10990, -2124.1001, 257.10001, 50, 0,0,179.5),
		[9] = createObject(11001, -2086.5, 298.89999, 46, 0,0,270.5),
		[10] = createObject(9302, -2130.8, 298.5, 41.6, 0,0,270),
		[11] = createObject(3665, -2029.8, 269.89999, 31, 0,180,0),
	}
}


function DestroyDoherty()
	for _, obj in pairs(Objects["Doherty"]) do
		destroyElement(obj)
	end
end

addEvent("DestroyDoherty", true)
addEventHandler("DestroyDoherty", root, DestroyDoherty)



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


function PlayerElementSync(thePlayer, obj, state)
	if(isElement(obj)) then
		if(getElementType(obj) == "ped") then
			if(not SData["PlayerElementSync"][obj]) then
				SData["PlayerElementSync"][obj] = {}
				if(getElementData(obj, "DynamicBot")) then
					if(SData["DriverBot"][obj] == "auto") then
						local arr = fromJSON(getElementData(obj, "CurNode"))
						local node, id = arr[1], arr[2]
						local nextnode, nextid = unpack(FoundNextRandomNode(node, id))
						local team = getElementData(obj, "team")


						local vehinfo = false
						local region = getZoneName(PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[node][id][4], true)
						if(team == "Полиция") then
							local zone = getZoneName(PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[node][id][4], false)
							vehinfo = SData["TeamVehicle"][team][region][math.random(#SData["TeamVehicle"][team][region])]
						elseif(team == "Мирные жители") then
							local arr = table.copy(SData["TeamVehicle"][team][region])
							local zone = getZoneName(PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[node][id][4], false)
							if(VehicleRegionSpecific[zone]) then
								for _, model in pairs(VehicleRegionSpecific[zone]) do
									if(model == 431) then
										if(ServerDate.year+1900 <= 1986) then
											arr[#arr+1] = {model}
										end
									elseif(model == 437) then
										if(ServerDate.year+1900 >= 1986) then
											arr[#arr+1] = {model}
										end
									else
										arr[#arr+1] = {model}
									end
								end
							end
							vehinfo = arr[math.random(#arr)]
						else
							vehinfo = SData["TeamVehicle"][team][math.random(#SData["TeamVehicle"][team])]
						end

						local x,y,z = PathNodes[node][id][2], PathNodes[node][id][3], PathNodes[node][id][4]+VehicleSystem[vehinfo[1]][1]
						local x2,y2,z2 = PathNodes[nextnode][nextid][2], PathNodes[nextnode][nextid][3], PathNodes[nextnode][nextid][4]
						local rotz = findRotation(x,y, x2,y2)

						local theVehicle = CreateVehicle(vehinfo[1], x, y, z, 0, 0, rotz)

						if(vehinfo[2]) then
							setVehiclePlateText(theVehicle, vehinfo[2])
						end

						if(vehinfo[3]) then
							if(#vehinfo[3] == 4) then
								setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4])
							else
								setVehicleColor(theVehicle, vehinfo[3][1], vehinfo[3][2], vehinfo[3][3], vehinfo[3][4], vehinfo[3][5], vehinfo[3][6])
							end
						end
						if(vehinfo[4]) then
							setVehicleVariant(theVehicle, vehinfo[4][1], vehinfo[4][2], vehinfo[4][3], vehinfo[4][4])
						end
						if(vehinfo[5]) then
							triggerEvent(vehinfo[5], theVehicle)
						end


						setElementData(theVehicle, "destroy", "true", false)
						warpPedIntoVehicle(obj,theVehicle)
					end
				end
			end
			
			SData["PlayerElementSync"][obj][getPlayerName(thePlayer)] = state

			if(getArrSize(SData["PlayerElementSync"][obj]) == 0) then
				SData["PlayerElementSync"][obj] = nil
				if(getElementData(obj, "DynamicBot")) then
					if(SData["DriverBot"][obj] == "auto") then
						local theVehicle = getPedOccupiedVehicle(obj)
						if(theVehicle) then
							destroyElement(theVehicle)
						end
					end
				end


				if(getElementData(obj, "DestroyAfterStreamOut")) then
					local theVehicle = getPedOccupiedVehicle(obj)
					if(theVehicle) then
						destroyElement(theVehicle)
					end
					destroyElement(obj)
				end
			end
		elseif(getElementType(obj, "vehicle")) then
			if(getElementData(obj, "DestroyAfterStreamOut")) then
				if(not getElementSyncer(obj)) then
					destroyElement(obj)
				end
			end
		end
	end
end
addEvent("PlayerElementSync", true)
addEventHandler("PlayerElementSync", root, PlayerElementSync)




SData["ClubIds"] = 1
function CreateClub(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, {"club"}, 493.4,-24.7,1000.7, 90, 17, SData["ClubIds"])


	local ped = CreateDialogBot(282, 492, -4.4, 1002,180, 17, SData["ClubIds"],"Club Malibu", "Танцор")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	ped = CreateDialogBot(287, 490, -4.4, 1002,180, 17, SData["ClubIds"],"Club Malibu", "Танцор")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	ped = CreateDialogBot(100, 488, -4.4, 1002,180, 17, SData["ClubIds"],"Club Malibu", "Танцор")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	ped = CreateDialogBot(260, 486, -4.4, 1002,180, 17, SData["ClubIds"],"Club Malibu", "Танцор")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)

	ped = CreateDialogBot(277, 484, -4.4, 1002,180, 17, SData["ClubIds"],"Club Malibu", "Танцор")
	StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)


	for slot = 1, 20 do
		local ped = CreateRandomBot(488+math.random(-5,3.5), -14+math.random(-4,5), 1000.7, 0, 17, SData["ClubIds"],"Unknown Bar",nil)
		if(ped) then
			StartAnimation(ped, "DANCING", DancingArr[math.random(1, #DancingArr)], -1, true)
		end
	end


	CreateVending(1775, 495.97, -24.32, 1000.73, 180, 17, SData["ClubIds"])
	CreateVending(1776, 500.56, -1.37, 1000.73, 0, 17, SData["ClubIds"])
	CreateVending(1775, 501.82, -1.44, 1000.73, 0, 17, SData["ClubIds"])

	CreateDialogBot(188, 501.7, -20.3, 1000.7, 90, 17, SData["ClubIds"], "Liquor Shop", "Бармен")

	SData["ClubIds"]=SData["ClubIds"]+1
end
CreateClub(1836.8, -1682.5, 13.3)
CreateClub(2507.4, 1242.3, 10.8)



SData["DinerIds"] = 1
function CreateDiner(x,y,z, interior)
	if(interior == 4) then
		CreateEnter(x,y,z, 0, 0, 0, false, 460.6, -88.7, 999.66, 90, interior, SData["DinerIds"], "Закусочная")
		CreateDialogBot(201, 450.5, -82.2, 999.6, 180, interior, SData["DinerIds"], "Burger Shot", "Продавщица")
	elseif(interior == 5) then
		CreateEnter(x,y,z, 0, 0, 0, false, 442.3, -107.3, 999.6, 90, interior, SData["DinerIds"], "Закусочная")
		CreateDialogBot(201, 449, -105.5, 999.56, 180, interior, SData["DinerIds"], "Burger Shot", "Продавщица")

		local o = createObject(5154, 451.5, -105.2, 995.3, 0,0,90)
		setElementInterior(o, interior)
		setElementDimension(o, SData["DinerIds"])
		local o = createObject(5154, 438.7, -105, 999.5, 0,90,0)
		setElementInterior(o, interior)
		setElementDimension(o, SData["DinerIds"])
		local o = createObject(5154, 464.3, -105, 999.5, 0,270,0)
		setElementInterior(o, interior)
		setElementDimension(o, SData["DinerIds"])
		local o = createObject(5154, 451.5, -115, 996, 0,90,90)
		setElementInterior(o, interior)
		setElementDimension(o, SData["DinerIds"])
		local o = createObject(5154, 451.5, -100.3, 996, 0,270,90)
		setElementInterior(o, interior)
		setElementDimension(o, SData["DinerIds"])
	end

	SData["DinerIds"]=SData["DinerIds"]+1
end
CreateDiner(875.5, -968.8, 37.3, 5)
CreateDiner(-2524.5, 1216.1, 37.7, 5)
CreateDiner(-1942.1, 2379.4, 49.7, 5)
CreateDiner(387.2, -1817.9, 7.8, 4)
CreateDiner(24.5, -2646.7, 40.5, 4)
CreateDiner(-384.8, 2206.1, 42.4, 4)
CreateDiner(-858, 1535.4, 22.6, 5)
CreateDiner(-187.7, 1210.7, 19.7, 5)
CreateDiner(-53.9, 1188.7, 19.47, 4)


CreateDialogBot(256, -2240.2, -1748.8, 480.9, 180, 0, 0, "Haruhi Suzumiya", "Странная девушка")



CreateEnter(1555.5, -1675.7, 16.1, 90, 0, 0, false, 246.8, 62.3, 1003.8, 0, 6, 1, "Полицейский участок Los Santos", true)
CreateEnter(1568.7, -1690, 6.2, 180, 0, 0, false, 246.4, 88, 1003.6, 180, 6, 1, "Полицейский участок Los Santos")
CreateEnter(1524.5, -1677.9, 6.2, 270, 0, 0, false, 1564.9, -1667, 28.4, 0, 0, 0)
CreateDialogBot(280, 251.3, 67.8, 1003.6, 90, 6, 1, "LSPD")
local ped = CreateDialogBot(280, 230.2, 71.1, 1005,0, 6, 1, "LSPD BIZ", "HR-менеджер")
StartAnimation(ped,"INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true)



CreateEnter(-1605.5, 710.3, 13.9, 270, 0, 0, false, 246.4, 107.3, 1003.2, 0, 10, 1, "Полицейский участок San Fierro", true)
CreateDialogBot(281, 246.5, 120.4, 1003.3,180, 10, 1, "SFPD")
ped = CreateDialogBot(280, 243.7, 120.2, 1010.2,0, 10, 1, "SFPD BIZ", "HR-менеджер")
StartAnimation(ped,"INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true)
CreateRandomBot(268, 125.3, 1004.6,90,10, 1,"Unknown",nil)

CreateEnter(2287.1, 2432.4, 10.8, 270, 0, 0, false, 238.7, 138.7, 1003, 0, 3, 1, "Полицейский участок Las Venturas", true)
CreateEnter(2337.2, 2459.3, 15, 270, 0, 0, false, 288.8, 167.1, 1007.3, 0, 3, 1, "Полицейский участок Las Venturas")
CreateRandomBot(251.4, 194.9, 1008.2,90,3, 1,"Unknown",nil)
CreateRandomBot(284.8, 172.2, 1007.2,58,3, 1,"Unknown",nil)

CreateDialogBot(282, 232.4, 160.7, 1003,237, 3, 1, "LVPD")
CreateDialogBot(282, 293.7, 182.1, 1007.2,148, 3, 1, "LVPD")
ped = CreateDialogBot(280, 217.7, 162.9, 1003,87, 3, 1, "LVPD BIZ", "HR-менеджер")
StartAnimation(ped,"INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true)


ped = CreateDialogBot(223, 563.4, -1293.2, 17.2,0, 0, 0, "GROTTI", "Продавец автомобилей")
StartAnimation(ped,"smoking", "m_smk_loop", -1, true, false,false,true)

ped = CreateDialogBot(32, 539.3, 2362.4, 30.8,9, 0, 0, "GROTTI", "Продавец автомобилей")
StartAnimation(ped,"smoking", "m_smklean_loop", -1, true, false,false,true)


SData["BincoIds"] = 1
function CreateBinco(x,y,z,rz,types)
	if(types == "Binco") then
		CreateRandomBot(201.1, -103.7, 1005.3, 240, 15,SData["BincoIds"],"Unknown",nil)
		CreateDialogBot(233, 209, -98.7, 1005.3, 180, 15, SData["BincoIds"], "Binco", "Продавщица")

		CreateEnter(x,y,z,rz, 0, 0, false, 207.6, -111.3, 1005.1, 0, 15, SData["BincoIds"], types)
		local p = CreatePickup(217.6, -98.5, 1005.3, 3, 1275, 0, 0, 15, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
	elseif(types == "Zip") then
		CreateRandomBot(169.5, -89.5, 1001.8, 90, 18,SData["BincoIds"],"Unknown",nil)
		CreateDialogBot(233, 162.4, -81.2, 1001.8, 180, 18, SData["BincoIds"], "Zip", "Продавщица")

		CreateEnter(x,y,z,rz, 0, 0, false, 161.3, -97.1, 1001.8, 0, 18, SData["BincoIds"], types)
		local p = CreatePickup(181.5, -86.9, 1002, 3, 1275, 0, 0, 18, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
	elseif(types == "Victim") then
		CreateEnter(x,y,z,rz, 0, 0, false, 227.5, -8.2, 1002.2, 0, 5, SData["BincoIds"], types)
		local p = CreatePickup(208.8, -3.9, 1001.2, 3, 1275, 0, 0, 5, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
		
		CreateDialogBot(93, 204.9, -7.8, 1001.2, 270, 5, SData["BincoIds"], "Victum", "Продавец")
	elseif(types == "ProLaps") then
		CreateRandomBot(215.4, -131.6, 1003.5,146, 3,SData["BincoIds"],"Unknown",nil)
		CreateDialogBot(124, 207.1, -127.8, 1003.5, 180, 3, SData["BincoIds"], "ProLaps", "Продавец")

		CreateEnter(x,y,z,rz, 0, 0, false, 206.9, -140.4, 1003.5, 0, 3, SData["BincoIds"], types)
		local p = CreatePickup(200.5, -131, 1003.5, 3, 1275, 0, 0, 3, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
	elseif(types == "Didier Sachs") then
		CreateEnter(x,y,z,rz, 0, 0, false, 204.3, -168.9, 1000.5, 0, 14, SData["BincoIds"], types)
		local p = CreatePickup(216, -155.5, 1000.5, 3, 1275, 0, 0, 14, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
		
		CreateDialogBot(55, 204.3, -157.8, 1000.5, 180, 14, SData["BincoIds"], "Didier Sachs", "Продавец")
	elseif(types == "Sub Urban" or types == "BOBO") then
		CreateEnter(x,y,z,rz, 0, 0, false, 203.7, -50.7, 1001.8, 0, 1, SData["BincoIds"], types)
		local p = CreatePickup(214.9, -40.8, 1002, 3, 1275, 0, 0, 1, SData["BincoIds"])
		setElementData(p, "wardrobeShop", types)
		
		CreateDialogBot(60, 204.1, -41.7, 1001.8, 180, 1, SData["BincoIds"], "SubUrban", "Продавец")
	end


	SData["BincoIds"]=SData["BincoIds"]+1
end


CreateBinco(2244.4, -1665.6, 15.5, 0, "Binco")
CreateBinco(-2373.8, 910.2, 45.4, 0, "Binco")
CreateBinco(2101.9, 2257.4, 11, 0, "Binco")
CreateBinco(1657, 1733.3, 10.8, 0, "Binco")
CreateBinco(-1882.3, 866.5, 35.2, 0, "Zip")
CreateBinco(2090.6, 2224.7, 11, 0, "Zip")
CreateBinco(1456.5, -1137.6, 23.9, 222, "Zip")
CreateBinco(2572.1, 1904.9, 11, 0, "Zip")
CreateBinco(461.7, -1500.8, 31, 0, "Victim")
CreateBinco(2803, 2430.7, 11.1, 0, "Victim")
CreateBinco(454.2, -1478, 30.8, 0, "Didier Sachs")
CreateBinco(2112.8, -1211.5, 24, 0, "Sub Urban")
CreateBinco(823, -1757, 13.7, 136, "BOBO")
CreateBinco(-2489.9, -29.1, 25.6, 0, "Sub Urban")
CreateBinco(2779.8, 2453.9, 11.1, 0, "Sub Urban")
CreateBinco(499.5, -1360.6, 16.4, 0, "ProLaps")
CreateBinco(-2492.5, 2363.1, 10.3, 270, "ProLaps")
CreateBinco(2826.1, 2407.5, 11.1, 0, "ProLaps")
CreateBinco(-1694.2, 951.1, 24.9, 0, "Victim")


local BankIds = 1
function CreateBank(x,y,z,rz,biz,name)
	CreateEnter(x,y,z,rz, 0, 0, false, 2304.8, -16.2, 26.7, 270, 0, BankIds, name)

	local o = createObject(18553, 2304.1, -16.2, 26.9)
	setElementDimension(o, BankIds)

	local o = createObject(1569, 2314.8, 0.5, 25.5)
	setElementDimension(o, BankIds)

	local ped = createPed(240, 2311.1, -11, 26.7, 180, true)
	setElementDimension(ped, BankIds)

	CreateDialogBot(76, 2318.5, -15.4, 26.7, 90, 0, BankIds, biz, "Менеджер")
	CreateDialogBot(9, 2318.5, -7.4, 26.7, 90, 0, BankIds, biz, "Менеджер")

	local ped = createPed(71, 2316.5, -12.8, 26.7, 90, true)
	setElementDimension(ped, BankIds)

	BankIds=BankIds+1
end
CreateBank(-179.2, 1133.2, 19.78, 180, "BANBC", "Банк BC")
CreateBank(-2456.2, 503.9, 30.1, 270, "BANSF", "Банк SF")
CreateBank(-828.2, 1504.4, 19.8, 180, "BANTR", "Банк TR")
CreateBank(2447.7, 2376.3, 12.2, 90, "BANLV", "Банк LV")
CreateBank(593.6, -1251, 18.3, 23, "BANLS", "Credit and Commerce Bank of San Andreas")


--Interior = {x,y,z, x+, y+}
local AmmoTirCoord = {
	[1] = {
		{289.3, -15.6, 1001.5, 0},
		{295.3, -15.6, 1001.5, 0},
		{292.3, -15.6, 1001.5, 0}
	},
	[4] = {
		{328.3, -59.8, 1001.5,90},
		{328.3, -64.2, 1001.5,90},
		{328.3, -69.1, 1001.5,90}
	},
	[6] = {
		{282, -166.4, 999.6,90},
		{282, -164.8, 999.6,90},
		{282, -163.3, 999.6,90},
		{282, -161.8, 999.6,90},
	}
}

local randTarget = {1585, 1584, 1583}

function CreateTir(i, d)
	for v, arr in pairs(AmmoTirCoord[i]) do
		local o = createObject(randTarget[math.random(#randTarget)], arr[1], arr[2], arr[3], 0, 0, arr[4])
		setElementInterior(o, i)
		setElementDimension(o, d)
	end
end



SData["Ammo"] = 1
function CreateAmmo(x,y,z,rz, interior, var)
	local ped = false
	if(interior == 1) then
		CreateEnter(x,y,z,rz, 0, 0, false, 285.4, -41.5, 1001.5, 0, interior, SData["Ammo"], "Ammu-Nation")
		CreateDialogBot(179, 296.5, -40.2, 1001.53, 0, interior, SData["Ammo"], "Ammo Shop 1", "Продавец")
		CreateEnter(286.1, -30, 1001.5, 180, interior, SData["Ammo"], false, 286.1, -28.6, 1001.5, 0, interior, SData["Ammo"])
		CreateTir(interior, SData["Ammo"])
	elseif(interior == 4) then
		CreateEnter(x,y,z,rz, 0, 0, false, 285.8, -86.35, 1001.5, 0, interior, SData["Ammo"], "Ammu-Nation")
		CreateDialogBot(179, 295.6, -82.5, 1001.53, 0, interior, SData["Ammo"], "Ammo Shop 2", "Продавец")
		CreateEnter(301.8, -76.8, 1001.5, 180, interior, SData["Ammo"], false, 301.8, -75.3, 1001.5, 0, interior, SData["Ammo"])

		CreateTir(interior, SData["Ammo"])
	elseif(interior == 6) then
		if(var == 1) then
			CreateEnter(x,y,z,rz, 0, 0, false ,296.91, -111.85, 1001.5, 0, interior, SData["Ammo"], "Ammu-Nation")
			CreateDialogBot(179, 290.2, -111.5, 1001.5, 0, interior, SData["Ammo"], "Ammo Shop 3", "Продавец")
		else
			CreateEnter(x,y,z,rz, 0, 0, false ,316.4, -170.3, 999.6, 0, interior, SData["Ammo"], "Ammu-Nation")
			CreateDialogBot(179, 312, -167.8, 999.61, 0, interior, SData["Ammo"], "Ammo Shop 4", "Продавец")
			CreateEnter(306.7, -159.2, 999.6, 270, interior, SData["Ammo"], false, 304.9, -159.2, 999.6, 90, interior, SData["Ammo"])
			CreateTir(interior, SData["Ammo"])
		end
	elseif(interior == 7) then
		CreateEnter(x,y,z,rz, 0, 0, false, 315.7, -143.7, 999.6, 270, interior, SData["Ammo"], "Ammu-Nation")
		CreateDialogBot(179, 308.2, -143.1, 999.6, 0, interior, SData["Ammo"], "Ammo Shop 2", "Продавец")
		CreateDialogBot(179, 316.1, -133.6, 999.6, 90, interior, SData["Ammo"], "Ammo Shop 3", "Продавец")
		CreateDialogBot(179, 316.2, -138.7, 1004.1, 90, interior, SData["Ammo"], "Ammo Shop 4", "Продавец")
	end

	SData["Ammo"]=SData["Ammo"]+1
end
CreateAmmo(1368.5, -1279.8, 13.5, 90, 1)--LS
CreateAmmo(2400.4, -1981.6, 13.5, 0, 4)--LS
CreateAmmo(-1508.8, 2610.3, 55.8, 180, 6,1)--LS
CreateAmmo(2159.5, 943.2, 10.8, 90, 6,1)--LV
CreateAmmo(776.9, 1871.4, 4.9, 270, 4)--LV
CreateAmmo(-316.2, 829.9, 14.2, 270, 4)--LV
CreateAmmo(-2626.7, 208.4, 4.8, 0, 7)--SF
CreateAmmo(2333.1, 61.6, 26.7, 270, 4)--LS
CreateAmmo(-2093.6, -2464.8, 30.6, 322, 6)--SF
CreateAmmo(2539.5, 2083.9, 10.8, 90, 6)--LV
CreateAmmo(243.3, -178.3, 1.6, 90, 6)--LS


SData["Sex"] = 1
function CreateSex(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false ,-100.4, -24.8, 1000.7, 90, 3, SData["Sex"])

	CreateDialogBot(178, -103.9, -24.2, 1000.7, 0, 3, SData["Sex"], "Sex Shop", "Продавщица")

	SData["Sex"]=SData["Sex"]+1
end
CreateSex(1087.7, -922.9, 43.4)
CreateSex(2085.1, 2074, 11)
CreateSex(1940, -2116, 13.7)
CreateSex(2420.4, 2065.2, 10.8)
CreateSex(2408.4, 2016.2, 10.8)
CreateSex(2515.3, 2297.4, 10.8)
CreateSex(953.9, -1336.8, 13.5)
CreateSex(2213.5, 1433.1, 11.1)





SData["Bar"] = 1
function CreateBar(x,y,z,rz, types)
	CreateRandomBot(510.1, -83.4, 999,180, 11, SData["Bar"],"Unknown Bar",nil)
	CreateRandomBot(506.5, -83.4, 999,180, 11, SData["Bar"],"Unknown Bar",nil)
	CreateRandomBot(510.1, -86.3, 999,0, 11, SData["Bar"],"Unknown Bar",nil)
	CreateRandomBot(506.5, -86.3, 999,360, 11, SData["Bar"],"Unknown Bar",nil)
	CreateRandomBot(489.7, -78.7, 998.8,180, 11, SData["Bar"],"Unknown Bar",nil)
	CreateRandomBot(489.9, -81.7, 998.8,0, 11, SData["Bar"],"Unknown Bar",nil)

	CreateEnter(x,y,z,rz, 0, 0, false, 502, -67.6, 998.8, 180, 11, SData["Bar"], types)

	local ped = CreateDialogBot(11, 496.8, -77.5, 998.8, 0, 11, SData["Bar"], "Liquor Shop", "Бармен")
	StartAnimation(ped, "BAR", "BARman_idle", -1, true)

	triggerEvent("CreatePoolTable", root, 506.48, -84.84, 997.94,270,11, SData["Bar"])
	triggerEvent("CreatePoolTable", root, 510.11, -84.84, 997.94,270,11, SData["Bar"])
	triggerEvent("CreatePoolTable", root, 489.75, -80.21, 997.73,270,11, SData["Bar"])

	SData["Bar"]=SData["Bar"]+1
end
CreateBar(-179.7, 1087.5, 19.7,0, "Attica Bar")
CreateBar(2310, -1643.5, 14.8,0, "Ten Green Bottle")
CreateBar(1945.2, -2042.9, 14.1,180, "Attica Bar")
CreateBar(2441.4, -1376, 24,270, "Attica Bar")
CreateBar(2460.7, -1344, 24,90, "Attica Bar")
CreateBar(2361.4, -1332.5, 24,270, "Attica Bar")
CreateBar(2441.2, 2065.5, 10.8,180, "The Craw Bar")
CreateBar(-2242.1, -88.2, 35.3,180, "Misty's")



SData["Liquor"] = 1
function CreateLiquor(x,y,z)
	CreateEnter(x,y,z, 0, 0, 0, false, -229.3, 1401.2, 27.8, 0, 18, SData["Liquor"], "Liquor Mart")

	CreateDialogBot(44, -223.3, 1404, 27.7, 90, 18, SData["Liquor"], "Liquor Shop", "Продавец")

	CreateRandomBot(-224.3, 1396.3, 28.4, 90, 18, SData["Liquor"],"Unknown Bar",nil)
	CreateRandomBot(-227.2, 1396.2, 28.4, 270, 18, SData["Liquor"],"Unknown Bar",nil)
	triggerEvent("CreatePoolTable", root, -225.745, 1396.245, 27.35,180, 18, SData["Liquor"])	
	SData["Liquor"]=SData["Liquor"]+1
end
CreateLiquor(-180.7, 1034.8, 19.7)
CreateLiquor(2481.75, -1758.0, 13.55)
CreateLiquor(2129.9, -1761.8, 13.56)
CreateLiquor(1978.8, -1761.8, 13.55)
CreateLiquor(1848, -1871.7, 13.5)
CreateLiquor(2091.3, -1905.7, 13.55)
CreateLiquor(2542, 2272.8, 10.8)
CreateLiquor(2348.5, -1372.85, 24.4)
CreateLiquor(875.8, -1565, 13.5)
CreateLiquor(1126.3, -1370, 13.9)
CreateLiquor(1359.6, 205.1, 19.8)
CreateLiquor(1321.8, 352.5, 19.5)
CreateLiquor(2151.4, -1013.9, 62.8)
CreateLiquor(-2103.5, -2431.9, 30.6)
CreateLiquor(-376.9, 2242.3, 42.6)
CreateLiquor(2270.6, 2554.6, 10.8)
CreateLiquor(1556.8, 959.7, 10.8)



SData["Shop"] = 1
function CreateShop(x,y,z, interior)
	if(interior == 6) then
		CreateRandomBot(-28.5, -50, 1003.5,270,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, -27.4, -58.2, 1003.5, 90, interior, SData["Shop"], "24/7", true)

		CreateVending(1775, -19.03, -57.83, 1003.63, 180,interior,SData["Shop"])
		CreateVending(1776, -36.14, -57.87, 1003.63, 180,interior,SData["Shop"])


		CreateDialogBot(147, -23, -57.3, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	elseif(interior == 4) then
		CreateRandomBot(-27.4, -3.8, 1003.6,180,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(-29.9, -25.3, 1003.6,0,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, -27.3, -31.2, 1003.55, 90, interior, SData["Shop"], "24/7", true)

		CreateDialogBot(147, -30.1, -30.6, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	elseif(interior == 16) then
		CreateRandomBot(-24.6, -133.4, 1003.5,0,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(-29, -124.1, 1003.5,270,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, -25.9, -141.3, 1003.55, 90, interior, SData["Shop"], "24/7", true)

		CreateVending(1775, -15.10, -140.22, 1003.63, 180, interior, SData["Shop"])
		CreateVending(1776, -16.53, -140.29, 1003.63, 180, interior, SData["Shop"])
		CreateVending(1775, -35.72, -140.22, 1003.63, 180, interior, SData["Shop"])
		CreateDialogBot(147, -21, -140.3, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	elseif(interior == 18) then
		CreateRandomBot(-32.5, -77, 1003.5,180,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(-24.5, -89.7, 1003.5,270,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, -30.95, -91.55, 1003.55, 90, interior, SData["Shop"], "24/7", true)

		CreateVending(1775, -16.11, -91.64, 1003.63, 180, interior, SData["Shop"])
		CreateVending(1776, -17.54, -91.71, 1003.63, 180, interior, SData["Shop"])

		CreateDialogBot(147, -27, -91.6, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	elseif(interior == 10) then
		CreateRandomBot(7.9, -16.9, 1003.5,0,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(0.4, -28.3, 1003.5,90,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, 6, -31.7, 1003.55, 0, interior, SData["Shop"], "24/7", true)

		CreateDialogBot(147, 3, -30.7, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	elseif(interior == 17) then
		CreateRandomBot(-14.2, -171.9, 1003.5,145,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(-25.1, -170.6, 1003.5,90,interior,SData["Shop"],"Unknown",nil)
		CreateRandomBot(-33.6, -171.7, 1003.5,180,interior,SData["Shop"],"Unknown",nil)
		CreateEnter(x,y,z, 0, 0, 0, {"24/7"}, -25.9, -187.87, 1003.55, 0, interior, SData["Shop"], "24/7", true)

		CreateVending(1775, -32.44, -186.69, 1003.63, 180, interior, SData["Shop"])
		CreateVending(1776, -33.87, -186.76, 1003.63, 180, interior, SData["Shop"])

		CreateDialogBot(147, -28.3, -186.8, 1003.5, 0, interior, SData["Shop"], "24/7", "Продавец")
	end

	SData["Shop"]=SData["Shop"]+1
end

CreateShop(-553.2, 2593.9, 54, 4) --BC
CreateShop(-1271.6, 2713.2, 50.25, 16) --BC
CreateShop(-19.2, 1175.6, 19.56, 17) --BC
CreateShop(-255, 2603.3, 62.8, 10) --BC
CreateShop(-1465.8, 1873.4, 32.6, 18) --BC
CreateShop(-311.3, 1303.5, 53.7,6)--BC
CreateShop(1833.7, -1842.55, 13.5, 17) --LS
CreateShop(1352.3, -1759.16, 13.5, 18) --LS
CreateShop(1315.5, -897.77, 39.5, 10) --LS
CreateShop(1976.65, -2036.7, 13.55, 6) --LS
CreateShop(1000.4, -919.9, 42.3, 17) --LS
CreateShop(-78.6, -1169.9, 2.1, 18) --LS
CreateShop(1383.3, 465.5, 20.2, 6) --LS
CreateShop(1928.7, -1776.3, 13.5, 6) --LS
CreateShop(2751.9, -1461.2, 30.5, 10) --LS
CreateShop(2139.4, -1191.9, 24, 18) --LS
CreateShop(2117.5, 896.8, 11.26, 4)
CreateShop(-1676, 432.2, 7.1, 17) --SF
CreateShop(-2442.65, 755, 35.2, 6) --SF
CreateShop(2194.7, 1990.95, 12.3, 18) --LV
CreateShop(662.8, 1716.5, 7.1, 16) --LV
CreateShop(1937.7, 2307.3, 10.8, 10) --LV
CreateShop(2884.6, 2454.05, 11.05, 6) --LV
CreateShop(-1566.5, -2730.3, 48.7, 6) --SF
CreateShop(2097.7, 2224.5, 11, 18) --LV
CreateShop(2452.5, 2065, 10.8, 10) --LV
CreateShop(2247.7, 2396.2, 10.8, 16) --LV
CreateShop(2150.7, 2733.9, 11.2, 18) --LV
CreateShop(2546.6, 1972.5, 10.8, 17) --LV
CreateShop(1599.2, 2221.8, 11.1, 6) --LV
CreateShop(2187.7, 2469.7, 11.2, 10) --LV
CreateShop(-314.1, 1774.8, 43.6, 4) --LV
CreateShop(-2420.2, 969.9, 45.3, 16) -- SF
CreateShop(2380.7, -1213.6, 27.4, 6) -- LS
CreateShop(-2106, -2480.7, 30.6, 16) -- LS
CreateShop(2292.3, -1722.7, 13.5, 4) -- LS
CreateShop(2502.1, -1319.9, 34.1, 17) -- LS





function PrisonEvent(hour, minutes)
	local PrisonMessage=""
	if(hour >= 0 and hour < 6) then
		PrisonMessage="Отбой еще "..((6-hour)*60)-minutes.." сек."
	elseif(hour == 6 and minutes < 30) then
		PrisonMessage="Подъем еще "..(30-minutes).." сек."
	elseif(hour >= 6 and hour < 11) then
		PrisonMessage="Свободное время еще "..((11-hour)*60)-minutes.." сек."
	elseif(hour >= 11 and hour < 13) then
		PrisonMessage="Обед еще "..((13-hour)*60)-minutes.." сек."
	elseif(hour >= 13 and hour < 20) then
		PrisonMessage="Прогулка еще "..((20-hour)*60)-minutes.." сек."
	elseif(hour >= 20 and hour < 22) then
		PrisonMessage="Ужин еще "..((22-hour)*60)-minutes.." сек."
	elseif(hour >= 22) then
		PrisonMessage="Отбой еще "..((24-hour)*60)+360-minutes.." сек."
	end

	local players = getPlayersInTeam(getTeamFromName("Уголовники"))
	PrisonMessage="#858585Распорядок дня\n#DCDCDC"..PrisonMessage
	for playerKey, playerValue in ipairs (players) do
		if(GetDatabaseAccount(playerValue, "PrisonTime") < 1) then
			SetDatabaseAccount(playerValue, "inv", GetDatabaseAccount(playerValue, "prisoninv"))
			setElementData(playerValue, "inv", GetDatabaseAccount(playerValue, "prisoninv"))
			SetDatabaseAccount(playerValue, "prisoninv", nil)
			SetDatabaseAccount(playerValue, "PrisonTime", nil)
			SetDatabaseAccount(playerValue, "Prison", nil)
			if(GetDatabaseAccount(playerValue, "OldTeam") ~= 0) then
				SetTeam(playerValue, GetDatabaseAccount(playerValue, "OldTeam"))
				SetDatabaseAccount(playerValue, "OldTeam", nil)
			else
				SetTeam(playerValue, "Мирные жители")
			end
			
			removeElementData(playerValue, "WantedLevelPrison")
			SpawnedAfterChange(playerValue)
		else
			if(isTimer(InLabTimer[playerValue])) then
				remaining, executesRemaining, totalExecutes = getTimerDetails(InLabTimer[playerValue])
				setElementData(playerValue, "WantedLevelPrison", "Научные опыты еще "..math.floor(remaining/1000).." сек.")
			else
				SetDatabaseAccount(playerValue, "PrisonTime", GetDatabaseAccount(playerValue, "PrisonTime")-1)
				local Prison = GetDatabaseAccount(playerValue, "Prison")
				if(Prison == "AREA51") then
					setElementData(playerValue, "WantedLevelPrison", SpawnPoint[Prison][9].."\n#FFFFFF"..SpawnPoint[Prison][10].." "..GetDatabaseAccount(playerValue, "PrisonTime").." сек.\n"..PrisonMessage)
				else
					setElementData(playerValue, "WantedLevelPrison", SpawnPoint[Prison][9].."\n#FFFFFF"..SpawnPoint[Prison][10].." "..GetDatabaseAccount(playerValue, "PrisonTime").." сек.")
				end
			end
		end
	end
end







function st(thePlayer)
	if(SData["Vibori"]) then
		if(not kandidats[getPlayerName(thePlayer)]) then
			if(getArrSize(kandidats) < 9) then
				kandidats[getPlayerName(thePlayer)] = 0
				disableVoice[getPlayerName(thePlayer)] = true
				HelpMessage(thePlayer, "Ты предложил свою кандидатуру\nОжидай начала голосования")
			else
				outputChatBox("К сожалению ты не успел, число кандидатов превысило 9 чел.", thePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox("Ты уже участник выборов!", thePlayer, 255, 255, 255, true)
		end
	else
		outputChatBox("В настоящий момент выборы не проходят", thePlayer, 255, 255, 255, true)
	end
end
addCommandHandler("st", st)



function srok(thePlayer, command, h)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		local bizNode = xmlNodeGetChildren(BizNode)
		for c,node in ipairs(bizNode) do
			local srok = xmlNodeGetAttribute(node, "srok")
			if(not h) then
				if(srok) then
					outputChatBox(xmlNodeGetName(node)..": "..srok.." мин", thePlayer)
				end
			else
				if(h == xmlNodeGetName(node)) then
					xmlNodeSetAttribute(node, "srok", 420)--Неделя
					outputChatBox("Стартуют выборы на пост "..xmlNodeGetAttribute(node, "biz"), getRootElement(), 255, 255, 255, true)
					outputChatBox("Напиши "..COLOR["KEY"]["HEX"].."/st #FFFFFFчтобы выдвинуть свою кандидатуру", getRootElement(), 255, 255, 255, true)
					SData["Vibori"] = xmlNodeGetName(node)
					setTimer(ststart, 60000, 1)
				end
			end
		end
	end
end
addCommandHandler("srok", srok)





function arm(thePlayer)
	if(getTeamName(getPlayerTeam(thePlayer)) ~= "Уголовники") then
		if(GetDatabaseAccount(thePlayer, "ATUT") ~= 3) then
			SetTeam(thePlayer, "Военные")
			SetDatabaseAccount(thePlayer, "skin", 312)
			triggerClientEvent(thePlayer, "StartLookZones", thePlayer, toJSON(GetAvailableSpawn(thePlayer, GetDatabaseAccount(thePlayer, "team"))))
		else
			ToolTip(thePlayer, "Ты уже отслужил!")
		end
	else
		ToolTip(thePlayer, "Сначала отсиди!")
	end
end
addCommandHandler("arm", arm)







function golos(thePlayer, vibor)
	if(not disableVoice[getPlayerName(thePlayer)]) then
		disableVoice[getPlayerName(thePlayer)] = true
		kandidats[vibor] = kandidats[vibor]+1
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "vibori", thePlayer, toJSON(kandidats))
		end
	end
end
addEvent("golos", true)
addEventHandler("golos", root, golos)


function ststart()
	if(getArrSize(kandidats) > 0) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "vibori", thePlayer, toJSON(kandidats))
		end
		setTimer(ststop, 60000, 1)
	else
		SData["Vibori"] = false
		outputChatBox("Выборы не состоялись из-за отсутствия кандидатов", getRootElement(), 255, 255, 255, true)
	end
end


function ststop()
	for k,v in spairs(kandidats, function(t,a,b) return t[b] < t[a] end) do
		outputChatBox(k.." победил в выборах!", getRootElement(), 255, 255, 255, true)
		local bizNode = xmlFindChild(BizNode, SData["Vibori"], 0)
		xmlNodeSetAttribute(bizNode, "owner", k)
		setElementData(biz, "bizowner", k)
		UpdateVacancyList()
		SData["Vibori"] = false
		kandidats = {}
		disableVoice = {}
		break
	end
	for theKey,thePlayer in ipairs(getElementsByType("player")) do
		triggerClientEvent(thePlayer, "vibori", thePlayer)
	end
end



function PayDay()
	for theKey,thePlayer in ipairs(getElementsByType("player")) do
		local team = getPlayerTeam(thePlayer)
		if(team) then
			local bankMoney = GetDatabaseAccount(thePlayer, "bank")
			local price = GetDatabaseZoneTeamPrice(getTeamName(team))
			local PTeam = getTeamName(team)
			if(price > 0) then
				AddPlayerMoney(thePlayer, price)
			end

			PData[thePlayer]["PayDay"] = PData[thePlayer]["PayDay"]+math.random(1000, 5000)
			AddPlayerMoney(thePlayer, PData[thePlayer]["PayDay"])

			SetDatabaseAccount(thePlayer, "bank", bankMoney+math.ceil((bankMoney/1000)))

			ToolTip(thePlayer, "#FFFFFFБонус за время проведенное в игре "..COLOR["DOLLAR"]["HEX"].."$"..PData[thePlayer]["PayDay"].."\n"..
			"#FFFFFFБанк "..COLOR["DOLLAR"]["HEX"].."$"..math.ceil((bankMoney/1000)).."#FFFFFF ("..(1/10).."%)\n"..
			"#FFFFFFЗарплата "..COLOR["DOLLAR"]["HEX"].."$"..price)
			if(BandRangs[PTeam]) then
				local new = tostring(GetBandRangSkin(PTeam, GetDatabaseAccount(thePlayer, getTeamVariable(PTeam))))
				local arr = fromJSON(GetDatabaseAccount(thePlayer, "wardrobe"))

				if(not arr[new]) then
					arr[new] = 1
				elseif(arr[new] < 999) then
					arr[new] = arr[new]+1
				end
				
				triggerClientEvent(thePlayer, "InformTitle", thePlayer, new, "wardrobe")
				SetDatabaseAccount(thePlayer, "wardrobe", toJSON(arr))
			end

			local job = IsPlayerJob(getPlayerName(thePlayer))
			if(job) then
				if(VacancyDATA[job]) then
					local new = tostring(VacancyDATA[job][4])
					local arr = fromJSON(GetDatabaseAccount(thePlayer, "wardrobe"))

					if(not arr[new]) then
						arr[new] = 1
					elseif(arr[new] < 999) then
						arr[new] = arr[new]+1
					end
					triggerClientEvent(thePlayer, "InformTitle", thePlayer, new, "wardrobe")
					SetDatabaseAccount(thePlayer, "wardrobe", toJSON(arr))
				end
			end

		end
	end


	local HouseNodes = xmlNodeGetChildren(HouseNode)
	for i,node in ipairs(HouseNodes) do
		if(xmlNodeGetValue(node) ~= "") then
			local dolg = 0
			if(xmlNodeGetAttribute(node, "dolg")) then
				dolg = tonumber(xmlNodeGetAttribute(node, "dolg"))
			end
			local price = tonumber(xmlNodeGetAttribute(node, "price"))
			dolg = dolg+math.round(price/2000, 0)
			xmlNodeSetAttribute(node, "dolg", dolg)
			setElementData(getElementByID(xmlNodeGetName(node)), "price", GetHousePrice(node))
			if(GetHousePrice(node) <= 0) then
				xmlNodeSetValue(node, "")
				setElementData(getElementByID(xmlNodeGetName(node)), "owner", "")
				setPickupType(getElementByID(xmlNodeGetName(node)), 3, 1273)
				xmlNodeSetAttribute(node, "dolg", nil)
				setElementData(getElementByID(xmlNodeGetName(node)), "price", GetHousePrice(node))
			end

		end
	end
end
if(getServerPort() == 22013) then addCommandHandler("payday", PayDay) end

function GetBizOwner(thePlayer)
	local BN = {}
	for i,node in ipairs(xmlNodeGetChildren(BizNode)) do
		if(xmlNodeGetAttribute(node, "owner") == getPlayerName(thePlayer)) then
			BN[#BN+1] = xmlNodeGetName(node)
		end
	end
	return BN
end





local Races = {
	["Backroad_Wanderer"] = {
		[1] = {253, -1249.8, 70.3},
		[2] = {319.9, -1201.6, 75},
		[3] = {448.9, -1187.5, 65.6},
		[4] = {639.5, -1098.5, 46},
		[5] = {752.9, -941.5, 54.4},
		[6] = {873, -860.6, 76.5},
		[7] = {1046.4, -780, 104},
		[8] = {1256.2, -728, 93.3},
		[9] = {1369.4, -677.8, 92.5},
		[10] = {1341.9, -578.2, 90.6},
		[11] = {1171.7, -632.3, 102.8},
		[12] = {970.5, -645.3, 120.8},
		[13] = {800.3, -799.3, 65.7},
		[14] = {620.4, -906.3, 62.1},
		[15] = {449.3, -1014.5, 92},
		[16] = {276.9, -1096.3, 81.7},
		[17] = {139.1, -1254.3, 44.2},
		[18] = {190.1, -1383.4, 47.4},
		[19] = {253, -1249.8, 70.3},
	},
	["Badlands_A"] = {
		[1] = {1558.4, 19.7, 23.2},
		[2] = {1556.2, -103.5, 19.1},
		[3] = {1477.7, -207.6, 10},
		[4] = {1320.2, -195, 16.1},
		[5] = {1216.3, -106.5, 39},
		[6] = {904.6, -90, 20.1},
		[7] = {787.7, -125.4, 21.2},
		[8] = {646, -196.6, 10.3},
		[9] = {423.7, -301.7, 6},
		[10] = {292.7, -381.4, 8},
		[11] = {208.1, -299.7, 0.4},
		[12] = {182.7, -224.8, 0.4},
		[13] = {31.6, -209, 0.5},
		[14] = {-116.9, -131.7, 2.1},
		[15] = {-37.8, 139.2, 2.1},
		[16] = {-146.9, 189.1, 6.9},
		[17] = {-328, 174.9, 5.4},
		[18] = {-519, 226.3, 9.3},
		[19] = {-662.1, 226.1, 16.7},
		[20] = {-621.9, -64, 62.6},
		[21] = {-506.1, -40, 58.6},
		[22] = {-523.1, 78.5, 31.5},
		[23] = {-712.7, 225.9, 1.2},
		[24] = {-753.7, 112, 13.1},
		[25] = {-742.5, 24.4, 32.7},
		[26] = {-887.2, -38.4, 32.9},
		[27] = {-711.8, 8.5, 60.2},
		[28] = {-757.9, -92.6, 64.9},
		[29] = {-824.9, -173.3, 65.1},
		[30] = {-723.4, -171.1, 63.8},
		[31] = {-549.3, -189.5, 77.4},
	},
	["Badlands_B"] = {
		[31] = {1558.4, 19.7, 23.2},
		[30] = {1556.2, -103.5, 19.1},
		[29] = {1477.7, -207.6, 10},
		[28] = {1320.2, -195, 16.1},
		[27] = {1216.3, -106.5, 39},
		[26] = {904.6, -90, 20.1},
		[25] = {787.7, -125.4, 21.2},
		[24] = {646, -196.6, 10.3},
		[23] = {423.7, -301.7, 6},
		[22] = {292.7, -381.4, 8},
		[21] = {208.1, -299.7, 0.4},
		[20] = {182.7, -224.8, 0.4},
		[19] = {31.6, -209, 0.5},
		[18] = {-116.9, -131.7, 2.1},
		[17] = {-37.8, 139.2, 2.1},
		[16] = {-146.9, 189.1, 6.9},
		[15] = {-328, 174.9, 5.4},
		[14] = {-519, 226.3, 9.3},
		[13] = {-662.1, 226.1, 16.7},
		[12] = {-621.9, -64, 62.6},
		[11] = {-506.1, -40, 58.6},
		[10] = {-523.1, 78.5, 31.5},
		[9] = {-712.7, 225.9, 1.2},
		[8] = {-753.7, 112, 13.1},
		[7] = {-742.5, 24.4, 32.7},
		[6] = {-887.2, -38.4, 32.9},
		[5] = {-711.8, 8.5, 60.2},
		[4] = {-757.9, -92.6, 64.9},
		[3] = {-824.9, -173.3, 65.1},
		[2] = {-723.4, -171.1, 63.8},
		[1] = {-549.3, -189.5, 77.4},
	},
	["City_Circuit"] = {
		[1] = {1933.7, -1515.5, 2.3},
		[2] = {2033.5, -1516.3, 2.4},
		[3] = {2181.5, -1561, 1.2},
		[4] = {2379.4, -1619.8, 8},
		[5] = {2578.7, -1619.4, 18},
		[6] = {2748.9, -1657.3, 12},
		[7] = {2912.4, -1544.1, 9.9},
		[8] = {2915.5, -1329, 9.9},
		[9] = {2813.8, -1143.4, 17},
		[10] = {2603, -1152.7, 48.9},
		[11] = {2424.7, -1154.2, 30.7},
		[12] = {2170, -1102.9, 24.4},
		[13] = {1986.8, -1026.8, 33.7},
		[14] = {1831.7, -988.9, 36.2},
		[15] = {1634.1, -1007, 50},
		[16] = {1617.3, -1210.5, 51.4},
		[17] = {1576.4, -1420.7, 27.5},
		[18] = {1734.6, -1522.8, 16.7},
		[19] = {1933.7, -1515.5, 2.3},
	},
	["Little_Loop"] = {
		[1] = {2875.3, -1463.1, 9.8},
		[2] = {2875, -1398.9, 9.9},
		[3] = {2796.9, -1278.8, 43.3},
		[4] = {2608.9, -1256.6, 47.1},
		[5] = {2371.2, -1280.3, 22.8},
		[6] = {2453.2, -1444.3, 22.8},
		[7] = {2621.9, -1444.4, 30.5},
		[8] = {2663.8, -1405.4, 29.3},
		[9] = {2684.1, -1495.9, 29.4},
		[10] = {2755.3, -1488.4, 28.7},
		[11] = {2875.3, -1463.1, 9.8},
	},
	["Lowrider"] = {
		[1] = {1516.1, -1872.3, 12.4},
		[2] = {1389.3, -1872.3, 12.4},
		[3] = {1082.7, -1852.3, 12.4},
		[4] = {650.1, -1734.9, 12.5},
		[5] = {627.7, -1229.8, 17},
		[6] = {489.1, -1289, 14.5},
		[7] = {503.2, -1332.9, 14.9},
		[8] = {401.6, -1403.6, 32.8},
		[9] = {421.5, -1450.6, 29.5},
		[10] = {329, -1629.2, 32.2},
		[11] = {364.2, -1647.2, 31.7},
		[12] = {369.8, -2032.5, 6.7},
	},
	["Vinewood"] = {
		[1] = {1357.6, -1370.5, 12.4},
		[2] = {1357.7, -1180.5, 21.3},
		[3] = {1372.7, -983.5, 29.8},
		[4] = {1494.7, -877.4, 58.8},
		[5] = {1435.5, -697.9, 87.3},
		[6] = {1249.7, -731, 93.6},
		[7] = {1053, -777.6, 104.7},
		[8] = {873.7, -860.3, 76.5},
		[9] = {723.2, -978.4, 52.1},
		[10] = {554.4, -1055.9, 74.1},
		[11] = {376.4, -1072.4, 72.9},
		[12] = {288.4, -1249.7, 72.7},
		[13] = {480.1, -1239.9, 19.8},
		[14] = {521.7, -1389.5, 15},
		[15] = {448.2, -1539.7, 28},
		[16] = {481.7, -1660.5, 21.9},
		[17] = {671.8, -1672.9, 12.2},
		[18] = {864.4, -1586.8, 12.4},
		[19] = {1063.6, -1572.3, 12.4},
		[20] = {1265.7, -1572.3, 12.4},
		[21] = {1357.6, -1370.5, 12.4},
	},
	["Freeway"] = {
		[1] = {820.6, -1405.6, 12.3},
		[2] = {1046.9, -1405.6, 12.3},
		[3] = {1227.7, -1405.7, 12.1},
		[4] = {1440.5, -1440.7, 12.4},
		[5] = {1635.6, -1440.9, 12.4},
		[6] = {1827.8, -1460.8, 12.4},
		[7] = {2028.9, -1463.5, 14.3},
		[8] = {2187.7, -1384.4, 22.8},
		[9] = {2342.6, -1430.4, 22.8},
		[10] = {2334.3, -1564.3, 22.9},
		[11] = {2176.1, -1541.8, 1.2},
		[12] = {1962, -1500.4, 2.4},
		[13] = {1723.3, -1493.5, 18.3},
		[14] = {1628.8, -1416.8, 27.6},
		[15] = {1629.7, -1256.9, 45.9},
		[16] = {1683.2, -1090.7, 56.1},
		[17] = {1572.5, -928.8, 41.9},
		[18] = {1359.3, -932.9, 33.2},
		[19] = {1165.2, -942.3, 41.9},
		[20] = {944.1, -965.7, 37.5},
		[21] = {779.9, -1044.6, 23.5},
		[22] = {666.1, -1180.6, 15.2},
		[23] = {627.7, -1359.7, 12.4},
		[24] = {820.6, -1405.6, 12.3}
	},
	["Into_the_Country"] = {
		[1] = {1331.7, -2288.8, 12.4},
		[2] = {1331.8, -2554.9, 12.4},
		[3] = {1550.6, -2684.8, 6.3},
		[4] = {1964.7, -2684.9, 6.8},
		[5] = {2175, -2547.9, 12.4},
		[6] = {2346.3, -2228.9, 12.4},
		[7] = {2732.9, -2169.7, 9.9},
		[8] = {2842.7, -1831.1, 9.9},
		[9] = {2923.8, -1389.6, 9.9},
		[10] = {2890, -991.5, 9.9},
		[11] = {2896.7, -635, 9.8},
		[12] = {2721.2, -266.8, 27},
		[13] = {2774.2, 112.9, 22.9},
		[14] = {2591.2, 321.4, 26.6},
		[15] = {2207.1, 325, 31.8},
		[16] = {1815.9, 278.6, 20.6},
		[17] = {1611.7, 317.1, 20},
		[18] = {1611.6, 373.9, 26.2},
		[19] = {1655.5, 306.8, 29.3},
		[20] = {1650.5, -65.7, 35.2},
		[21] = {1674.9, -397.9, 35},
		[22] = {1700.2, -658.7, 41.9},
		[23] = {1635.9, -1086.3, 59},
		[24] = {1594.2, -1479.3, 27.6},
		[25] = {1630.2, -1888.6, 24},
		[26] = {1440.1, -2117.7, 12.4},
		[27] = {1331.7, -2288.8, 12.4}
	},
	["Dirtbike_Danger"] = {
		[1] = {-792.9, -2473, 76.8},
		[2] = {-974.2, -2362.2, 64.5},
		[3] = {-1067.4, -2377.1, 46.1},
		[4] = {-1244.5, -2318.8, 19.2},
		[5] = {-1390.4, -2168.3, 19.4},
		[6] = {-1567.1, -2155.1, 11.2},
		[7] = {-1692, -2283.4, 40.8},
		[8] = {-1835.9, -2344.9, 33.6},
		[9] = {-1844, -2451, 28},
		[10] = {-1680.7, -2602.3, 34.9},
		[11] = {-1479.3, -2635.2, 43.1},
		[12] = {-1275.3, -2638.2, 5.8},
		[13] = {-1103.6, -2666.1, 20.4},
		[14] = {-900.1, -2665, 90.2},
		[15] = {-731.5, -2644.2, 81.8},
		[16] = {-656.3, -2472.8, 32.8},
		[17] = {-534.7, -2311.1, 28.9},
		[18] = {-361.1, -2257.3, 42.2},
		[19] = {-277.1, -2188.4, 27.7},
	},
	["Bandito_County"] = {
		[1] = {-1946.3, -2461.3, 29.9},
		[2] = {-1867.3, -2386.9, 30.4},
		[3] = {-1697.1, -2293.3, 42.3},
		[4] = {-1682.5, -2137.1, 35.4},
		[5] = {-1879.2, -2091.4, 58.3},
		[6] = {-1857.7, -1930.1, 87.8},
		[7] = {-1672.5, -1898.4, 92.7},
		[8] = {-1498.5, -1781.5, 51.9},
		[9] = {-1423.1, -1929.3, 21.5},
		[10] = {-1307.4, -2071.6, 22.3},
		[11] = {-1262.4, -2276.8, 21.3},
		[12] = {-1123.1, -2373.6, 30.5},
		[13] = {-960.5, -2296.8, 54.7},
		[14] = {-866.5, -2181.8, 25.4},
		[15] = {-832.8, -2030.4, 22.5},
		[16] = {-751.5, -1861.6, 11.7},
		[17] = {-666.7, -2002.5, 24},
		[18] = {-485.4, -2026.1, 48.2},
		[19] = {-321.5, -1914.9, 11.8 },
	},
	["Go-Go_Karting"] = {
		[1] = {-2731.6, -314.1, 6},
		[2] = {-2658.3, -238.7, 4.5},
		[3] = {-2655.1, -85.3, 3.1},
		[4] = {-2433.9, -70.3, 34},
		[5] = {-2421.1, 56.6, 34},
		[6] = {-2541.6, 137.5, 15.3},
		[7] = {-2604, 141.2, 3.2},
		[8] = {-2559.7, 244, 10.5},
		[9] = {-2582.5, 346.9, 5.8},
		[10] = {-2706.3, 310.7, 3.2},
		[11] = {-2809, 207.5, 6},
		[12] = {-2757.8, 138.5, 5.9},
		[13] = {-2758.2, -47.8, 6},
		[14] = {-2757.5, -195.5, 6},
		[15] = {-2813.1, -304, 6},
		[16] = {-2731.6, -314.1, 6}
	},
	["San_Fierro_Fastlane"] = {
		[1] = {-2670.2, 1140.9, 34},
		[2] = {-2588.7, 1222.3, 34},
		[3] = {-2287.3, 1176.4, 53.40},
		[4] = {-2172.8, 1270.7, 27.60},
		[5] = {-1940.4, 1288.2, 6},
		[6] = {-1739.6, 1323.9, 6},
		[7] = {-1770.8, 1268.2, 9.2},
		[8] = {-1884.2, 1157.6, 44.3},
		[9] = {-1898.3, 952.4, 34},
		[10] = {-1992, 845.6, 44.3},
		[11] = {-2211.4, 808.5, 48.3},
		[12] = {-2386.3, 808.6, 34},
		[13] = {-2566.9, 808.3, 48.8},
		[14] = {-2704.8, 812.9, 48.8},
		[15] = {-2750.9, 892.9, 65.2},
		[16] = {-2670.2, 1140.9, 34},
	},
	["San_Fierro_Hills"] = {
		[1] = {-1584.2, 1044.7, 6},
		[2] = {-1584.1, 1151, 6},
		[3] = {-1671.6, 1284.8, 6},
		[4] = {-1863.1, 1363.2, 6},
		[5] = {-2076, 1271.5, 10.1},
		[6] = {-2264.6, 1255.2, 42.3},
		[7] = {-2143.2, 1071.1, 78.8},
		[8] = {-2143, 903, 78.9},
		[9] = {-2143.4, 701.9, 68.4},
		[10] = {-2143.5, 530, 34},
		[11] = {-2044.3, 504.5, 34},
		[12] = {-1968.4, 605.9, 34},
		[13] = {-1815.4, 484.5, 24.1},
		[14] = {-1864.9, 324.3, 24.4},
		[15] = {-1899.5, 66.8, 37.2},
		[16] = {-1911.4, -213.3, 37.2},
		[17] = {-1911.2, -537.6, 37.2},
		[18] = {-1910.8, -798.8, 44},
		[19] = {-1910.7, -1146, 37.4},
		[20] = {-1910.4, -1353.4, 39.4},
		[21] = {-2012.3, -1266.2, 35.3},
		[22] = {-2142.8, -1040.6, 30.7},
		[23] = {-2207, -866.2, 52.8},
		[24] = {-2241.7, -749.3, 67.4},
		[25] = {-2349.3, -782.9, 93.5},
		[26] = {-2423.2, -608.5, 131.6},
		[27] = {-2627.2, -497.1, 69.3},
		[28] = {-2355.6, -458.2, 79.4},
		[29] = {-2542.1, -367.5, 53.7},
		[30] = {-2683.1, -524.3, 15.6},
		[31] = {-2704.6, -405.9, 6.7},
		[32] = {-2202, -348, 35.7},
		[33] = {-1909.5, -325.2, 47.8},
		[34] = {-1891.7, -23, 37.2},
		[35] = {-1852.1, 221.1, 33.6},
		[36] = {-1762.6, 322.9, 6.3},
		[37] = {-1686.6, 366.5, 6},
		[38] = {-1561.2, 511.6, 6},
		[39] = {-1535.5, 826.3, 6},
		[40] = {-1584.2, 1044.7, 6},
	},
	["Country_Endurance"] = {
		[1] = {-1762.1, -594.3, 15.3},
		[2] = {-1758.2, -697.2, 25.5},
		[3] = {-1492.2, -820.7, 63.2},
		[4] = {-1208.4, -746.2, 59.8},
		[5] = {-1106.3, -500.5, 31.3},
		[6] = {-912, -456.2, 26.1},
		[7] = {-637.5, -396.4, 20.7},
		[8] = {-403.6, -489.7, 18.2},
		[9] = {-361.4, -795.2, 28.4},
		[10] = {-562.1, -1120.3, 21.8},
		[11] = {-665.9, -1622.8, 25.2},
		[12] = {-719.3, -1668.1, 50},
		[13] = {-723.9, -1291.3, 64},
		[14] = {-761.5, -1468.8, 87.7},
		[15] = {-771.5, -1731.6, 95.2},
		[16] = {-1091.8, -2126.6, 38.1},
		[17] = {-1186.3, -2447, 54},
		[18] = {-1008, -2614.6, 83.1},
		[19] = {-720.1, -2355.2, 41.6},
		[20] = {-515.1, -2165.7, 52.2},
		[21] = {-263.4, -2080.9, 36.7},
		[22] = {-261.6, -1786.9, 8.6},
		[23] = {-57.5, -1601.4, 1.7},
		[24] = {-103.9, -1488.9, 1.7},
		[25] = {-143.2, -1269, 1.7},
		[26] = {-114.1, -997.8, 24},
		[27] = {-375.5, -839.8, 46.3},
		[28] = {-607.4, -977.4, 63.4},
		[29] = {-877.7, -1096.3, 95.7},
		[30] = {-930.2, -1396.6, 126.3},
		[31] = {-1190.9, -1340.4, 123.6},
		[32] = {-1416.5, -1413.2, 103.1},
		[33] = {-1572.7, -1173.3, 101.6},
		[34] = {-1625.9, -855.3, 95.2},
		[35] = {-1754.4, -874.2, 75.4},
		[36] = {-1682.9, -1146.5, 71.6},
		[37] = {-1558.4, -1268.4, 58.7},
		[38] = {-1554, -1444.3, 39.2},
		[39] = {-1666.1, -1312.5, 48.1},
		[40] = {-1806.7, -984.6, 49.1},
		[41] = {-1818.2, -597.3, 15.3}
	},
	["SF_to_LV"] = {
		[1] = {-1986.5, 1076.2, 54.6},
		[2] = {-2330.3, 1080.4, 54.6},
		[3] = {-2607.3, 1143.4, 54.4},
		[4] = {-2673.9, 1452, 54.4},
		[5] = {-2673.7, 1774.9, 67.1},
		[6] = {-2674.1, 2067.9, 54.4},
		[7] = {-2733.2, 2328.3, 68.7},
		[8] = {-2599.2, 2606.9, 65.2},
		[9] = {-2301.8, 2638.3, 53.8},
		[10] = {-2016.2, 2579, 54},
		[11] = {-1897.2, 2352.4, 43.8},
		[12] = {-1700.5, 2147.6, 17.2},
		[13] = {-1631.3, 1812, 11.2},
		[14] = {-1358.5, 1706.8, 4.5},
		[15] = {-1137.8, 1584.2, 20.3},
		[16] = {-1001.6, 1210.2, 30.9},
		[17] = {-912.5, 963.4, 16.9},
		[18] = {-724.5, 685.7, 16.3},
		[19] = {-460.4, 570.5, 16.2},
		[20] = {-179.1, 561.2, 14.9},
		[21] = {116.9, 676.9, 4.7},
		[22] = {404.9, 748.3, 5},
		[23] = {642.8, 657.1, 5.7},
		[24] = {1057.9, 777.5, 9.7},
		[25] = {1285.4, 888.7, 15.3},
		[26] = {1226.3, 1158.4, 5.8},
		[27] = {1226.6, 1482.1, 5.7},
	},
	["Dam_Rider"] = {
		[1] = {-881.2, 1960, 59.2},
		[2] = {-855.9, 1867.1, 59.2},
		[3] = {-1016.8, 1855.5, 60.9},
		[4] = {-1125.4, 1765.9, 34.9},
		[5] = {-901.5, 1687.9, 26.3},
		[6] = {-846.6, 1499.6, 17.9},
		[7] = {-780.4, 1301.9, 12.6},
		[8] = {-625.8, 1209.1, 10.5},
		[9] = {-479.3, 1054.8, 10},
		[10] = {-315.5, 922, 10.3},
		[11] = {-276.6, 819.6, 13.4},
		[12] = {-187.8, 1017.6, 18.6},
		[13] = {-165, 1198.1, 18.6},
		[14] = {-136.4, 1251.4, 18.2},
		[15] = {-349.5, 1271.4, 22.3},
		[16] = {-443.6, 1456, 32.9},
		[17] = {-432.8, 1650.6, 35},
		[18] = {-378.7, 1819.9, 49},
		[19] = {-432, 1873.4, 61.2},
		[20] = {-466.5, 1777, 72.6},
		[21] = {-454.1, 1981.5, 78.4},
		[22] = {-428, 2057.9, 60.3},
		[23] = {-597.6, 2044.7, 59.2},
		[24] = {-762.1, 2063.3, 59.2},
		[25] = {-881.2, 1960, 59.2},
	},
	["Desert_Tricks"] = {
		[1] = {-375.8, 2203.6, 41.1},
		[2] = {-391.2, 2266.1, 40.5},
		[3] = {-418.3, 2453.4, 43.8},
		[4] = {-611.9, 2450.3, 72.1},
		[5] = {-715.4, 2540.2, 72.5},
		[6] = {-706.3, 2695.7, 54.3},
		[7] = {-951.5, 2717.5, 44.9},
		[8] = {-1142.1, 2695.4, 44.9},
		[9] = {-1252.1, 2675.1, 46.7},
		[10] = {-1361.3, 2661.7, 50.6},
		[11] = {-1536.7, 2731.4, 62.2},
		[12] = {-1778.2, 2710.1, 57.6},
		[13] = {-1872.5, 2533.6, 47.8},
		[14] = {-2001.2, 2437.3, 34},
		[15] = {-1947.5, 2222.8, 9.1},
		[16] = {-1802, 2089.5, 7.5},
		[17] = {-1781.6, 1899.4, 14.9},
		[18] = {-1576.1, 1838.8, 25.4},
		[19] = {-1378.4, 1854.1, 36},
		[20] = {-1197.1, 1799.1, 40.4},
		[21] = {-1005.8, 1854.9, 61.8},
		[22] = {-858.3, 1877.2, 59.2},
		[23] = {-762.9, 2047.6, 59.2},
		[24] = {-556.7, 2000.2, 59.2},
		[25] = {-468.6, 2056.1, 59.9},
		[26] = {-410.4, 2149.4, 43.1},
		[27] = {-375.8, 2203.6, 41.1}
	},
	["LV_Ringroad"] = {
		[1] = {1444.7, 834.6, 5.8},
		[2] = {1767, 834.7, 9.3},
		[3] = {2058, 833.5, 5.7},
		[4] = {2323.5, 833.5, 5.7},
		[5] = {2627.5, 905.2, 5.7},
		[6] = {2726.7, 1190.6, 5.7},
		[7] = {2726.7, 1521, 5.7},
		[8] = {2727.2, 1825.7, 5.7},
		[9] = {2726.6, 2140.9, 5.7},
		[10] = {2708.3, 2393.3, 5.7},
		[11] = {2496.6, 2611.3, 4},
		[12] = {2156.8, 2602.5, 5.8},
		[13] = {1859.5, 2517.8, 5.8},
		[14] = {1577.2, 2473, 5.8},
		[15] = {1307.4, 2441.3, 5.7},
		[16] = {1208.6, 2150.4, 5.7},
		[17] = {1208.3, 1840.8, 5.7},
		[18] = {1208, 1484.3, 5.7},
		[19] = {1208.6, 1235.8, 5.8},
		[20] = {1224.9, 962.7, 5.8},
		[21] = {1444.7, 834.6, 5.8},
	}
}

































































































function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end





local VCompVehicleTypes = {}
for nameparts, data in pairs(VComp) do
	for name, types in pairs(data) do
		if(not VCompVehicleTypes[types[1]]) then VCompVehicleTypes[types[1]] = {} end
		VCompVehicleTypes[types[1]][#VCompVehicleTypes[types[1]]+1] = {nameparts, name}
	end
end





local datess = ""
local tmpi = 1
local tmpcity = ""
function restartMode(thePlayer)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		local res = getResourceFromName("vehicle_node") -- Interface
		restartResource(res)
		--local res = getResourceFromName("object_image") -- Interface
		--restartResource(res)
		--local res = getResourceFromName("interface") -- Interface
		--restartResource(res)
		PathNodes = exports["vehicle_node"]:GetVehicleNodes()
		PedNodes = exports["vehicle_node"]:GetPedNodes()
		
		datess = ""
		tmpi = 1
		tmpcity = ""
		setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 0, 1, 200)
	end
end


function saveserver(thePlayer, x,y,z,rx,ry,rz, savetype)
	local zone = GetZoneName(x,y,z, false, getElementData(thePlayer, "City"))
	if(savetype == "PedPath") then
		local angle = findRotation(x,y, x,ry)
		if(angle <= 0) then angle = 0 end
		if(tmpcity ~= zone) then
			if(PedNodes[zone]) then
				tmpi = #PedNodes[zone]+1
			else
				PedNodes[zone] = {}
				tmpi = 1
			end

			if(tmpcity ~= "") then
				datess = datess.."\n"
			end
			tmpcity = zone


			datess = datess.."	[\""..zone.."\"] = {\n"
			datess = datess.."		["..tmpi.."] = {"..math.round(x, 0)..", "..math.round(y, 0)..", "..math.round(z, 1)..
			", "..math.round(rx, 0)..", "..math.round(ry, 0)..", "..math.round(rz, 1)..", "..angle.."}, "
			PedNodes[zone][tmpi] = {math.round(x, 0), math.round(y, 0), math.round(z, 1), math.round(rx, 0), math.round(ry, 0), math.round(rz, 1), angle}
		else
			tmpi = tmpi+1
			datess = datess.."\n		["..tmpi.."] = {"..math.round(x, 0)..", "..math.round(y, 0)..", "..math.round(z, 1)..
			", "..math.round(rx, 0)..", "..math.round(ry, 0)..", "..math.round(rz, 1)..", "..angle.."}, "
			PedNodes[zone][tmpi] = {math.round(x, 0), math.round(y, 0), math.round(z, 1), math.round(rx, 0), math.round(ry, 0), math.round(rz, 1), angle}
		end
	else
		if(tmpcity ~= zone) then
			if(PathNodes[zone]) then
				local maxkey = 1
				for i, v in pairs(PathNodes[zone]) do
					if(i > maxkey) then
						maxkey = i
					end
				end
				tmpi = (math.ceil(maxkey/100))*100
			else
				PathNodes[zone] = {}
				tmpi = 1
			end

			if(PathNodes[zone][tmpi]) then tmpi = tmpi+100 end

			if(tmpcity ~= "") then
				datess = datess..", false, {{\""..zone.."\", "..tmpi.."}}}, \n"
			end
			tmpcity = zone


			datess = datess.."	[\""..zone.."\"] = {\n"
			datess = datess.."		["..tmpi.."] = {true, "..math.round(x, 1)..", "..math.round(y, 1)..", "..math.round(z, 1)
			PathNodes[zone][tmpi] = {true, math.round(x, 1), math.round(y, 1), math.round(z, 1), false}
		else
			tmpi = tmpi+1
			datess = datess..", false}, \n		["..tmpi.."] = {true, "..math.round(x, 1)..", "..math.round(y, 1)..", "..math.round(z, 1)
			PathNodes[zone][tmpi] = {true, math.round(x, 1), math.round(y, 1), math.round(z, 1), false}
		end
	end
	fileDelete("save.txt")
	local hFile = fileCreate("save.txt")
	fileWrite(hFile, datess) -- write a text line
	fileClose(hFile)
end
addEvent("saveserver", true)
addEventHandler("saveserver", root, saveserver)





function fightstyle(thePlayer, thePed, id)
	setPedFightingStyle(thePlayer, tonumber(id))
end
addEvent("fightstyle", true)
addEventHandler("fightstyle", root, fightstyle)



function RemovePedFromVehicle(thePed, thePlayer)
	if(thePed) then
		if(not thePlayer) then thePlayer = getElementSyncer(thePed) end
		local theVehicle = getPedOccupiedVehicle(thePed)
		if(theVehicle) then
			local x,y,z = getElementPosition(theVehicle)
			local _,_,rz = getElementRotation(theVehicle)
			setElementSyncer(theVehicle, thePlayer)
			setElementData(theVehicle, "DestroyAfterStreamOut", "true", false)
			setElementSyncer(thePed, thePlayer)
			removePedFromVehicle(thePed)
			
			local x1,y1,z1 = getPointInFrontOfPoint(x, y, z, rz-180, 1)
			setElementPosition(thePed, x1,y1,z1, true)
		end
	end
end
addEvent("RemovePedFromVehicle", true)
addEventHandler("RemovePedFromVehicle", root, RemovePedFromVehicle)




-- 1257 автобусная остановка

function usecellphone(thePlayer, number)
	DialogStart(thePlayer, Dialogs["Телефон"][1], false)
end
addEvent("usecellphone", true)
addEventHandler("usecellphone", root, usecellphone)


function info(thePlayer, command, h)
	if(PlayersEnteredPickup[thePlayer]) then
		if(getElementData(PlayersEnteredPickup[thePlayer], "house")) then
			outputChatBox(getElementData(PlayersEnteredPickup[thePlayer], "house"))
		end
	end
	local x,y,z = getElementPosition(thePlayer)
	local zone = getZoneName(x, y, z)
	outputChatBox(zone, thePlayer)
end
addCommandHandler("inform", info)



function GetVehiclePower(mass, acceleration) return math.ceil(mass/(140)*(acceleration)) end
function saved(thePlayer, command, h)

	local HouseNodes = xmlNodeGetChildren(HouseNode)
	for i,node in ipairs(HouseNodes) do
		local types = xmlNodeGetAttribute(node, "type")
		if(InteriorsClass[types]) then

			xmlNodeSetAttribute(node, "int", InteriorsClass[types][math.random(#InteriorsClass[types])])
		end
	end



	local PlayerNodes = xmlNodeGetChildren(PlayerNode)
	for i,node in ipairs(PlayerNodes) do
		--local arr = fromJSON(xmlNodeGetAttribute(node, "inv"))

		--xmlNodeSetAttribute(node, "Collections", Collections)
		xmlNodeSetAttribute(node, "inv", StandartInventory)
		--[[for i, v in pairs(arr) do
			if(v[1]) then
				if(v[1] == "Redwood") then
					v[1] = "CoK"
				elseif(v[1] == "Slick-O-Greese") then
					v[1] = nil
				end

				xmlNodeSetAttribute(node, "inv", toJSON(arr))
			end
		end--]]

		--xmlNodeSetAttribute(node, "wanted", 0)

		--xmlNodeSetAttribute(node, "Prison", nil)
		--xmlNodeSetAttribute(node, "PrisonTime", 0)
		--local ward = fromJSON(xmlNodeGetAttribute(node, "wardrobe"))
		--ward[145] = 999

		--xmlNodeSetAttribute(node, "wardrobe", toJSON(ward))
	end

	--[[local PlayerNodes = xmlNodeGetChildren(PlayerNode)
	for i,node in ipairs(PlayerNodes) do
		--xmlNodeSetAttribute(node, "armies", nil)
		--xmlNodeSetAttribute(node, "prisoninv", nil)
		--xmlNodeSetAttribute(node, "kresp", nil)
		local arr = fromJSON(xmlNodeGetAttribute(node, "inv"))
		for i = 1, #arr do
			if(arr[i][1] == "Одеколон") then
				arr[i][1] = "Pissh Gold"
			end
		end
		xmlNodeSetAttribute(node, "inv", toJSON(arr))
	end

	local PlayerNodes = xmlNodeGetChildren(PlayerNode)
	for i,node in ipairs(PlayerNodes) do
		local bank = xmlNodeGetAttribute(node, "bank")
		local money = xmlNodeGetAttribute(node, "money")
		if(not bank) then bank = 0 end
		local total = bank+money
		if(total < 50000) then
			xmlDestroyNode(node)
		end
	end

	local CarNodes = xmlNodeGetChildren(CarNode)
	for i,node in ipairs(CarNodes) do
		local nodes = xmlFindChild(PlayerNode, "P"..md5(xmlNodeGetValue(node)), 0)
		if(not nodes) then
			xmlDestroyNode(node)
		end
	end--]]
end
addCommandHandler("saved", saved)

function wipe()
	local CarNodes = xmlNodeGetChildren(CarNode)
	for i,node in ipairs(CarNodes) do
		xmlDestroyNode(node)
	end

	local PlayerNodes = xmlNodeGetChildren(PlayerNode)
	for i,node in ipairs(PlayerNodes) do
		xmlDestroyNode(node)
	end


	local HouseNodes = xmlNodeGetChildren(HouseNode)
	for i,node in ipairs(HouseNodes) do
		xmlNodeSetValue(node, "")
		xmlNodeSetAttribute(node, "dolg", nil)
		xmlNodeSetAttribute(node, "locked", "1")
	end

	local BizNodes =  xmlNodeGetChildren(BizNode)
	for c,node in ipairs(BizNodes) do
		local vacancy = xmlNodeGetChildren(node)
		xmlNodeSetAttribute(node, "owner", "")
		xmlNodeSetAttribute(node, "money", "0")
		for i, ChildNode in pairs(vacancy) do
			xmlNodeSetValue(ChildNode, "")
		end
	end

	local FishHones = xmlNodeGetChildren(FishesNode)
	for c,node in ipairs(FishHones) do
		xmlDestroyNode(node)
	end

	local ThreesNodes = xmlNodeGetChildren(ThreesNode)
	for c,node in ipairs(ThreesNodes) do
		xmlDestroyNode(node)
	end
end

function GetDatabaseAccount(thePlayer, str)
	local node = xmlFindChild(PlayerNode, "P"..md5(getPlayerName(thePlayer)), 0)
	if(node) then
		if(xmlNodeGetAttribute(node, str)) then
			local n = tonumber(xmlNodeGetAttribute(node, str))
			if(n) then return n
			else return xmlNodeGetAttribute(node, str) end
		else
			return 0
		end
	end
end

function GetDatabaseAccountFromName(thePlayer, str)
	local node = xmlFindChild(PlayerNode, "P"..md5(thePlayer), 0)
	if(node) then
		if(xmlNodeGetAttribute(node, str)) then
			local n = tonumber(xmlNodeGetAttribute(node, str))
			if(n) then return n
			else return xmlNodeGetAttribute(node, str) end
		else
			return 0
		end
	end
end


function SetDatabaseAccount(thePlayer, str, count)
	local node = xmlFindChild(PlayerNode, "P"..md5(getPlayerName(thePlayer)), 0)
	xmlNodeSetAttribute(node, str, count)
end


function SetDatabaseAccountFromName(thePlayer, str, count)
	local node = xmlFindChild(PlayerNode, "P"..md5(thePlayer), 0)
	xmlNodeSetAttribute(node, str, count)
end

function AddDatabaseAccount(thePlayer, password)
	local NewNode = xmlCreateChild(PlayerNode, "P"..md5(getPlayerName(thePlayer)))
	xmlNodeSetValue(NewNode, getPlayerName(thePlayer))
	xmlNodeSetAttribute(NewNode, "inv", StandartInventory)
	setElementData(thePlayer, "inv", StandartInventory)

	xmlNodeSetAttribute(NewNode, "prisoninv", StandartInventory)
	xmlNodeSetAttribute(NewNode, "PrisonTime", 500)
	xmlNodeSetAttribute(NewNode, "OldTeam", "Мирные жители")
	xmlNodeSetAttribute(NewNode, "Prison", "AREA51")

	xmlNodeSetAttribute(NewNode, "Collections", Collections)
	xmlNodeSetAttribute(NewNode, "password", md5(password))
	xmlNodeSetAttribute(NewNode, "skill", toJSON({[24] = 569}))
	xmlNodeSetAttribute(NewNode, "wardrobe", toJSON({[252] = 999, [145] = 999, [0] = 999}))
	xmlNodeSetAttribute(NewNode, "bolezni", toJSON({}))
	xmlNodeSetAttribute(NewNode, "skin", 213)
	xmlNodeSetAttribute(NewNode, "about", toJSON({["Birthday"] = ServerDate.timestamp}))
	xmlNodeSetAttribute(NewNode, "team", "Уголовники")
end







function CheckDatabasePlayer(thePlayer)
	local node = xmlFindChild(PlayerNode, "P"..md5(getPlayerName(thePlayer)), 0)
	if(node) then return true
	else return false end
end

function RemoveDatabaseAccount(thePlayerName)
	local node = xmlFindChild(PlayerNode, "P"..md5(thePlayerName), 0)
	xmlDestroyNode(node)
end





function kill(thePlayer) killPed(thePlayer, thePlayer, 0, 8) end
addEvent("kill", true)
addEventHandler("kill", root, kill)
addCommandHandler("kill", kill)


function loginPlayer(thePlayer, password)
	local account = CheckDatabasePlayer(thePlayer)

	if(account) then
		if(GetDatabaseAccount(thePlayer, "password") == md5(password)) then
			Respect(thePlayer)
			SpawnedAfterChange(thePlayer)
			PData[thePlayer]["auth"] = true
			AuthComplete(thePlayer)
		else
			outputChatBox("Неверный пароль", thePlayer, 255, 255, 255, true)
			triggerClientEvent(thePlayer, "LoginWindow", thePlayer, true)
		end
	else
		PData[thePlayer]["auth"] = true
		AddDatabaseAccount(thePlayer, password)
		Respect(thePlayer)
		SpawnedAfterChange(thePlayer)
		PData[thePlayer]["auth"] = true
		AuthComplete(thePlayer)
	end
end
addEvent("loginPlayerEvent", true)
addEventHandler("loginPlayerEvent", root, loginPlayer)










function AddCollections(thePlayer, model, id)
	local dat = fromJSON(GetDatabaseAccount(thePlayer, "Collections"))
	dat[tostring(model)][id] = true
	SetDatabaseAccount(thePlayer, "Collections", toJSON(dat))

	local CollectionNames = {
		[954] = {"Подков", 50, "Подкова"},
		[953] = {"Ракушек", 50, "Ракушка"},
		[1276] = {"Скрытых пакетов", 100, "Реликвия"}
	}
	AddInventoryItem(thePlayer, {["txd"] = CollectionNames[model][3], ["name"] = CollectionNames[model][3]})
	MissionCompleted(thePlayer, "#169AFA"..CollectionNames[model][1].." найдено "..getArrSize(dat[tostring(model)]).." из "..CollectionNames[model][2])
end
addEvent("AddCollections", true)
addEventHandler("AddCollections", root, AddCollections)






function AuthComplete(thePlayer)
	outputChatBox("* ["..getElementData(source, "id").."] "..getElementData(source, "color")..getPlayerName(thePlayer).." #FFFFFFПодключился к серверу", getRootElement(), 255,255,255,true)
	triggerClientEvent(thePlayer, "AuthInterface", thePlayer, GetDatabaseAccount(thePlayer, "inv"))
	triggerClientEvent(thePlayer, "AuthComplete", thePlayer, GetDatabaseAccount(thePlayer, "Collections"))
end


function SaveInventory(thePlayer, arr)
	if(PData[thePlayer]["auth"]) then
		SetDatabaseAccount(thePlayer, "inv", arr)
		setElementData(thePlayer, "inv", arr)
		setPlayerMoney(thePlayer, GetPlayerMoney(thePlayer))
	end
end
addEvent("SaveInventory", true)
addEventHandler("SaveInventory", root, SaveInventory)




function buyshopitem(thePlayer, count, args)
	if(not tonumber(count)) then return false end
	local item, cost, x,y = args[1], args[2]*count, args[3], args[4]
	item["ForSale"] = nil
	
	if(AddPlayerMoney(thePlayer, -cost)) then
		if(item["name"] == "CoK") then
			local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
			if(PlayerTeam == "Мирные жители") then
				if(GetDatabaseAccount(thePlayer, "CTUT") == 0) then
					SetDatabaseAccount(thePlayer, "CTUT", 1)
					MissionCompleted(thePlayer, "СООБРАЗИТЕЛЬНОСТЬ +", "МИССИЯ ВЫПОЛНЕНА")
					triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
					UpdateTutorial(thePlayer)
				end
			end
		elseif(item["name"] == "Газета") then
			item["date"] = {ServerDate.month+1, ServerDate.year+1900}
		elseif(item["name"] == "Лазерный прицел") then
			item["color"] = {math.random(0,255), math.random(0,255), math.random(0,255), math.random(180,255)}
		end

		if(item["Biz"]) then
			AddBizMoney(item["Biz"], math.round((cost/3), 0))
		end
		item["Biz"] = nil

		for i = 1, count do
			AddInventoryItem(thePlayer, item, x,y)
		end
	else
		ToolTip(thePlayer, "Недостаточно средств!")
	end
end
addEvent("buyshopitem", true)
addEventHandler("buyshopitem", root, buyshopitem)




function SellShopItem(thePlayer, count)
	AddPlayerMoney(thePlayer, count)
	--if(AddBizProduct(biz, name, count, true)) then -- Для того чтобы в случае нехватки денег лишний раз не дергать сохранение
	--	if(AddPlayerMoney(thePlayer, price*count)) then
	--		AddBizProduct(biz, name, count)
	--	end
	--else
	--	ToolTip(thePlayer, "Склады с данным товаром уже переполнены")
	--end
end
addEvent("SellShopItem", true)
addEventHandler("SellShopItem", root, SellShopItem)






function DrinkSprunk(thePlayer, model)
	if(not isTimer(PData[thePlayer]["anitimer"])) then
		if(AddPlayerMoney(thePlayer, -20)) then
			if(model == 956) then
				StartAnimation(thePlayer, "VENDING", "VEND_Use",false,false,false,false)
				triggerClientEvent(thePlayer, "PlaySFXClient", thePlayer, "script", 203, 1)

				AddBizMoney("SPRUNK", 20)

				PData[thePlayer]["anitimer"] = setTimer(function(thePlayer)
					AddPlayerArmas(thePlayer, 2769)
					StartAnimation(thePlayer, "VENDING", "vend_eat1_P",false,false,false,false)
					setElementHealth(thePlayer, getElementHealth(thePlayer) + 20)

					PData[thePlayer]["anitimer"] = setTimer(function(thePlayer)
						RemovePlayerArmas(thePlayer, 2769)
					end, 2600, 1, thePlayer)
				end, 2800, 1, thePlayer)

			else
				StartAnimation(thePlayer, "VENDING", "VEND_Use",false,false,false,false)
				triggerClientEvent(thePlayer, "PlaySFXClient", thePlayer, "script", 203, 0)
				AddBizMoney("SPRUNK", 20)

				PData[thePlayer]["anitimer"] = setTimer(function(thePlayer)
					AddPlayerArmas(thePlayer, 1546)
					StartAnimation(thePlayer, "VENDING", "VEND_Drink_P",false,false,false,false)
					setElementHealth(thePlayer, getElementHealth(thePlayer) + 20)

					PData[thePlayer]["anitimer"] = setTimer(function(thePlayer)
						RemovePlayerArmas(thePlayer, 1546)
					end, 1600, 1, thePlayer)
				end, 2800, 1, thePlayer)
			end
		end
	end
end
addEvent("DrinkSprunk", true)
addEventHandler("DrinkSprunk", root, DrinkSprunk)




function PrisonSleep(x,y,z,rz)
	if(x) then
		UnBindAllKey(source)
		if(rz == 0) then
			setElementRotation(source,0,0,rz-270)
			SetPlayerPosition(source,x,y+1.5,z+1.6)
		elseif(rz == 90) then
			setElementRotation(source,0,0,rz-270)
			SetPlayerPosition(source,x-1.5,y,z+1.6)
		else
			setElementRotation(source,0,0,rz-270)
			SetPlayerPosition(source,x,y-1.5,z+1.6)
		end
		StartAnimation(source, "CRACK", "crckidle2",-1,true,false,true)
		setElementData(source, "sleep", "true")
	else
		removeElementData(source, "sleep")
		BindAllKey(source)
		StopAnimation(source)
	end
end
addEvent("PrisonSleep", true)
addEventHandler("PrisonSleep", root, PrisonSleep)



function PrisonGavno(x,y,z,rz)
	if(not isTimer(PData[source]["ActionTimer"])) then
		SetPlayerPosition(source,x,y,z,nil,nil,rz)
		StartAnimation(source,"SILENCED", "SilenceCrouchfire", 1000,false,false,false)
		PData[source]["ActionTimer"] = setTimer(function(thePlayer)
			AddInventoryItem(thePlayer, {["txd"] = "Фекалии", ["name"] = "Фекалии", ["quality"] = math.random(0,1000)})
		end, 1000, 1, source)
	end
end
addEvent("PrisonGavno", true)
addEventHandler("PrisonGavno", root, PrisonGavno)




function piss(thePlayer, command, h)
	StartAnimation(thePlayer, "PAULNMAC", "Piss_out",false,false,false,false)
end
addEvent("PrisonPiss", true)
addEventHandler("PrisonPiss", root, piss)
addCommandHandler("piss", piss)


function addPlayerBolezn(thePlayer, name, count)
	if(thePlayer) then
		local arr = fromJSON(GetDatabaseAccount(thePlayer, "bolezni"))
		if(count > 0) then
			arr[name]=1
			outputChatBox("Ты получил болезнь #FFCCEE'"..name.."'#FFFFFF!", thePlayer, 255,255,255,true)
		else
			arr[name]=nil
			outputChatBox("Ты вылечился от #FFCCEE'"..name.."'#FFFFFF!", thePlayer, 255,255,255,true)
		end
		SetDatabaseAccount(thePlayer, "bolezni", toJSON(arr))
	end
end


function isPlayerBolezn(thePlayer, bol)
	if(thePlayer) then
		local arr = fromJSON(GetDatabaseAccount(thePlayer, "bolezni"))
		for name, val in pairs(arr) do
			if(name == bol) then
				return true
			end
		end
		return false
	end
end

WastedPoliceTimer = {}
function PoliceArrest(thePlayer, thePed)
	if(not WastedPoliceTimer[thePed]) then
		local x,y,z = getElementPosition(thePlayer)
		
		for key,thePlayers in pairs(getElementsByType "player") do
			triggerClientEvent(thePlayers, "PlayerSayEvent", thePlayers, "Руки вверх!", thePlayer)
		end
		WastedPoliceTimer[thePed] = thePlayer
		HelpMessage(thePed, "Нажми "..COLOR["KEY"]["HEX"].."H#FFFFFF чтобы поднять руки")
		setElementData(thePed, "NoFireMePolice", "1")
		setTimer(function()
			removeElementData(thePed, "NoFireMePolice")
			WastedPoliceTimer[thePed] = nil
		end, 5000, 1)
	end
end
addEvent("PoliceArrest", true)
addEventHandler("PoliceArrest", root, PoliceArrest)




Phones = {}
PhonesTo = {}
PhonesWaiting = {}

function CallPhones(thePlayer, _, h)
    if(not Phones[thePlayer]) then
		if(h) then
			if(tostring(getElementData(thePlayer, "id")) ~= tostring(h)) then
				for key,thePlayers in pairs(getElementsByType "player") do
					if(tostring(getElementData(thePlayers, "id")) == tostring(h)) then
						if(not PhonesWaiting[thePlayers]) then
							CallIn(thePlayer)
							PhonesTo[thePlayer] = thePlayers
							PhonesWaiting[thePlayers] = thePlayer
							outputChatBox("Напиши /call чтобы бросить трубку", thePlayer, 255,255,255,true)
							outputChatBox("Напиши /call чтобы взять трубку", thePlayers, 255,255,255,true)
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 12)
							triggerClientEvent(thePlayers, "PlaySFXSoundEvent", thePlayers, 13)
							return true
						else
							outputChatBox("* Абонент занят", thePlayer, 255,255,255,true)
							return true
						end
					end
				end
				outputChatBox("* "..h.." Номер не найден", thePlayer, 255,255,255,true)
			else
				outputChatBox("* Абонент занят", thePlayer, 255,255,255,true) -- сам себе
			end
		else
			if(PhonesWaiting[thePlayer]) then
				CallIn(thePlayer)
				outputChatBox("* Абонент взял трубку", PhonesWaiting[thePlayer], 255,255,255,true)
				PhonesTo[thePlayer] = PhonesWaiting[thePlayer]
			else
				outputChatBox("Используй /call id игрока чтобы позвонить", thePlayer, 255,255,255,true)
				outputChatBox("Напиши /call чтобы бросить трубку", thePlayer, 255,255,255,true)
			end
		end
	else
		CallOut(thePlayer)
		if(Phones[PhonesTo[thePlayer]]) then
			CallOut(PhonesTo[thePlayer])
			outputChatBox("* Абонент положил трубку", PhonesTo[thePlayer], 255,255,255,true)
		end
		if(PhonesWaiting[PhonesTo[thePlayer]]) then
			PhonesWaiting[PhonesTo[thePlayer]] = nil
		end
	end
end
addCommandHandler("call", CallPhones)


function CallIn(thePlayer)
	SetControls(thePlayer, "phone", {["fire"] = true, ["action"] = true, ["jump"] = true, ["sprint"] = true})

	StartAnimation(thePlayer, "ped", "phone_in", 1, false, true, true, true)
	Phones[thePlayer] = true
	AddPlayerArmas(thePlayer, 330)
end


function CallOut(thePlayer)
	SetControls(thePlayer, "phone", {["fire"] = false, ["action"] = false, ["jump"] = false, ["sprint"] = false})

	StartAnimation(thePlayer, "ped", "phone_out", 1, false, true, true, true)
	setTimer(function()
		RemovePlayerArmas(thePlayer, 330)
		Phones[thePlayer] = false
		PhonesTo[thePlayer] = false
		if(PhonesWaiting[thePlayer]) then
			PhonesWaiting[thePlayer] = nil
		end
	end, 2000, 1)
end



function CallPhoneOutput(thePlayer, arg)
	CallPhones(thePlayer, _, arg)
end
addEvent("CallPhoneOutput", true)
addEventHandler("CallPhoneOutput", root, CallPhoneOutput)




function MCHSEventHealth(thePlayer, thePed)
	if(getElementData(thePed, "sleep") == "true") then
		local PlayerHealth = getElementHealth(thePed)-(25)
		if(PlayerHealth >= 1) then
			local health = getPedStat(thePed, 24)-(100)
			if(health >= 1) then
				Respect(thePlayer, "civilian", 1)
				AddInventoryItem(thePlayer, {["txd"] = "Кровь", ["name"] = "Кровь", ["quality"] = math.random(0,1000)})
				outputChatBox("У тебя взяли кровь, кровь в организме со временем восполнится", thePed, 255,255,255,true)
				outputChatBox("Ты взял кровь у "..getPlayerName(thePed), thePlayer, 255,255,255,true)
				AddSkill(thePed, 24, -100)
				setElementHealth(thePed, PlayerHealth)
			else
				ToolTip(thePlayer, "У пациента кончилась кровь!")
			end
		else
			ToolTip(thePlayer, "Пациент в плохом самочувствии!")
		end
	else
		local BLD = FoundItemsCount(thePlayer, "Кровь")
		if(BLD) then
			if(isPlayerBolezn(thePed, "СПИД")) then
				addPlayerBolezn(thePed, "СПИД", -1)
				outputChatBox("Ты вылечил "..getPlayerName(thePed).." от СПИДа",thePlayer ,255,255,255,true)
			elseif(isPlayerBolezn(thePed, "Порванный анус")) then
				addPlayerBolezn(thePed, "Порванный анус", -1)
				BloodFoot(thePed, false)
				outputChatBox("Ты зашил анус "..getPlayerName(thePed),thePlayer ,255,255,255,true)
			elseif(isPlayerBolezn(thePed, "Дизентерия")) then
				addPlayerBolezn(thePed, "Дизентерия", -1)
				outputChatBox("Ты вылечил от дизентерии "..getPlayerName(thePed),thePlayer ,255,255,255,true)
			else
				ToolTip(thePlayer, "Пациент не болен!")
			end
			RemoveInventoryItemCount(thePlayer, BLD[1], BLD[2])
		else
			ToolTip(thePlayer, "У тебя нету донорской крови!")
		end
	end
end
addEvent("MCHSEventHealth", true)
addEventHandler("MCHSEventHealth", root, MCHSEventHealth)



function PoliceArrestCar()
	local theVehicle = getPedOccupiedVehicle(source)
	if(theVehicle) then
		if(getElementModel(theVehicle) == 596 or getElementModel(theVehicle) == 597 or getElementModel(theVehicle) == 598 or getElementModel(theVehicle) == 599 or getElementModel(theVehicle) == 523) then
			local x,y,z = getElementPosition(source)
			for key,thePlayers in pairs(getElementsByType "player") do
				triggerClientEvent(thePlayers, "PlayerSayEvent", thePlayers, "Немедленно остановите машину или мы откроем огонь!", source)
				triggerClientEvent(thePlayers, "PlaySFX3DforAll", thePlayers, "script", 58, math.random(36, 41),x,y,z, false, 25,100,reverb,true)
			end
		end
	end
end
addEvent("PoliceArrestCar", true)
addEventHandler("PoliceArrestCar", root, PoliceArrestCar)






createObject(3749, 135.2, 1941.1, 23.5, 0,0,180)
PrisonMainGate = createObject(10184, 135.2, 1941.1, 20.9, 0,0,90)
setElementData(PrisonMainGate, "gates", toJSON({135.2, 1941.1, 25.1, 0,0,0}))
setElementData(PrisonMainGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))


createObject(3749, 285.6, 1821.3, 21.8, 0,0,270)
PrisonMainGate = createObject(10184, 285.6, 1821.3, 19.1, 0,0,180)
setElementData(PrisonMainGate, "gates", toJSON({285.6, 1821.3, 23.3, 0,0,0}))
setElementData(PrisonMainGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

createObject(1412, 96.7, 1920.9, 18.4, 0,0,90)
createObject(1412, 96.7, 1920.9, 20.4, 0,0,90)


local wall = createObject(3059, 2522, -1272.9301, 35.61, 0,0,0)
setElementFrozen(wall, true)
PrisonMainGate = createObject(10184, 188.9,1919, 19.2, 0,0,0)
setElementData(PrisonMainGate, "gates", toJSON({188.9,1919, 23, 0,0,0}))
setElementData(PrisonMainGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

PrisonStreetGate = createObject(2927, 215.941, 1874.571, 13.903,0,0,0)
setElementData(PrisonStreetGate, "gates", toJSON({217.941, 1874.571, 13.903,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

PrisonStreetGate = createObject(2927,  211.842, 1874.571, 13.903,0,0,0)
setElementData(PrisonStreetGate, "gates", toJSON({209.842, 1874.571, 13.903,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))


PrisonStreetGate = createObject(3115, -1456.719, 501.297, 9.914, 0,0,0) -- SF
setElementData(PrisonStreetGate, "gates", toJSON({-1456.719, 501.297, 16.914,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))


PrisonStreetGate = createObject(3114, -1414.453, 516.453, 16.688, 0,0,0) -- SF
setElementData(PrisonStreetGate, "gates", toJSON({-1414.453, 516.453, 16.688,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))


PrisonStreetGate = createObject(3113, -1465.797, 501.289, 1.145,0,0,0) -- SF
setElementData(PrisonStreetGate, "gates", toJSON({-1468.797, 501.289, 10.145,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))



PrisonStreetGate = createObject(988, -1543.742, -432.703, 6.039, 0,0, -45.0) -- SF Airport
setElementData(PrisonStreetGate, "gates", toJSON({-1540.742, -435.703, 6.039,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))

PrisonStreetGate = createObject(988, -1547.625, -428.82, 6.039, 0,0, -45.0) -- SF Airport
setElementData(PrisonStreetGate, "gates", toJSON({-1550.625, -425.82, 6.039,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))


PrisonStreetGate = createObject(988, -1222.953, 53.826, 14.134, 0,0, -135.0) -- SF Airport
setElementData(PrisonStreetGate, "gates", toJSON({-1225.953, 50.826, 14.134,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))

PrisonStreetGate = createObject(988, -1218.206, 68.883, 14.134, 0,0, -135.0) -- SF Airport
setElementData(PrisonStreetGate, "gates", toJSON({-1221.206, 65.883, 14.134,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))



PrisonStreetGate = createObject(988, 1964.342, -2189.776, 13.533, 0,0, 180) -- LS Airport
setElementData(PrisonStreetGate, "gates", toJSON({1967.342, -2189.776, 13.533,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))

PrisonStreetGate = createObject(988, 1958.851, -2189.777, 13.553, 0,0, 180)  -- LS Airport
setElementData(PrisonStreetGate, "gates", toJSON({1955.851, -2189.777, 13.553,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))




PrisonStreetGate = createObject(988, 1704.777, 1605.165, 10.058, 0,0, 73.0) -- LV Airport
setElementData(PrisonStreetGate, "gates", toJSON({1703.777, 1601.165, 10.058,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))

PrisonStreetGate = createObject(988, 1706.364, 1610.422, 10.058, 0,0, 73.0)  -- LV Airport
setElementData(PrisonStreetGate, "gates", toJSON({1707.364, 1614.422, 10.058,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))


PrisonStreetGate = createObject(3084, 1903.383, 967.62, 11.438, 0,0, 0)  -- Казино
setElementData(PrisonStreetGate, "gates", toJSON({1903.383, 967.62, 14.438,0,0,0}))
setElementData(PrisonStreetGate, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))


PrisonFoodGate2 = createObject(1966, 2178.073, -2254.384, 15.9, 0, 0, 224.0)
setElementData(PrisonFoodGate2, "gates", toJSON({2178.073, -2254.384, 19.9, 0, 0, 0}))
setElementData(PrisonFoodGate2, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР"}))




PrisonFoodGate1 = createObject(2930, 226.6, 1874.1, 15.4)
setElementData(PrisonFoodGate1, "gates", toJSON({226.6, 1875.1,15.4, 0,0,0}))
setElementData(PrisonFoodGate1, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

PrisonFoodGate2 = createObject(2930, 226.6, 1872.4, 15.4)
setElementData(PrisonFoodGate2, "gates", toJSON({226.6, 1871.4, 15.4, 0,0,0}))
setElementData(PrisonFoodGate2, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

PrisonFoodGate2 = createObject(3095, 268.664, 1884.06, 15.925, 0, 0, 90)
setElementData(PrisonFoodGate2, "gates", toJSON({275.664, 1884.06, 15.925, 0, 0, 0}))
setElementData(PrisonFoodGate2, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))

PrisonFoodGate2 = createObject(2951, 268.66, 1864.059, 7.5, 0, 0, 0)
setElementData(PrisonFoodGate2, "gates", toJSON({268.66, 1864.059, 10, 0, 0, 0}))
setElementData(PrisonFoodGate2, "team",  toJSON({"МЧС", "Военные", "Полиция", "ФБР", "ЦРУ"}))



function NoAttack(thePlayer, thePed)
	removeElementData(thePed, "attacker")
end
addEvent("NoAttack", true)
addEventHandler("NoAttack", root, NoAttack)

function handsup(thePlayer)
	if(getElementHealth(thePlayer) > 20 and not getPedOccupiedVehicle(thePlayer)) then
		if(WastedPoliceTimer[thePlayer]) then
			if(GetDatabaseAccount(thePlayer, "wanted") > 0) then
				triggerEvent("onPlayerWasted",thePlayer, 0, WastedPoliceTimer[thePlayer], 0,0)
				triggerClientEvent(thePlayer, "onClientWastedLocalPlayer", thePlayer)
				toggleAllControls(thePlayer,false)
				UnBindAllKey(thePlayer)
			else
				NoAttack(thePlayer, WastedPoliceTimer[thePlayer])
				setElementData(thePlayer, "NoFireMePolice", "0")
			end
		end
		StartAnimation(thePlayer, "ped", "handsup",-1,false,false,true,true)
	else
		return false
	end
end
addEvent("handsup", true)
addEventHandler("handsup", root, handsup)






function CallPolice(Player)
	if(not Phones[source] and getElementHealth(source) > 20) then
		CallIn(source)
		setTimer(PhoneTalk, 1600, 1, source)
		setTimer(PhoneTalkEnd, 10000, 1, source, Player)
	end
end
addEvent("CallPolice", true)
addEventHandler("CallPolice", root, CallPolice)

function PhoneTalk(thePlayer)
	StartAnimation(thePlayer, "ped", "phone_talk", 1)
	local x,y,z = getElementPosition(thePlayer)
	triggerEvent("onPlayerChat", thePlayer, "Алло, полиция? Преступник в "..getZoneName(x, y, z), 1)
end


PoliceCallBandints = {}

function PhoneTalkEnd(thePlayer, bandit)
	CallOut(thePlayer)
	if(not isPedDead(thePlayer)) then
		local x,y,z = GetPlayerLocation(getPlayerFromName(bandit))
		if(PoliceCallBandints[bandit] ~= getZoneName(x,y,z)) then
			PoliceCallBandints[bandit] = getZoneName(x,y,z)
			local banditPlayer = getPlayerFromName(bandit)
			local x,y,z = GetPlayerLocation(banditPlayer)
			StartAnimation(thePlayer, "ped", "phone_out", false,false,false,false)
			Respect(thePlayer, "civilian", 1)
			Respect(thePlayer, "police", 1)
			Respect(thePlayer, "ugol", -1)
			MissionCompleted(thePlayer, "УВАЖЕНИЕ +", "ЗАКОНОПОСЛУШНОСТЬ")
			PoliceCallRemove(x,y,z,"Обнаружен преступник")
		else
			outputChatBox("Полиции уже известно о положении преступника.", thePlayer)
			StartAnimation(thePlayer, "ped", "phone_out", false,false,false,false)
		end
	end
end








function UpReputation(thePlayer, thePed)
	local team = getTeamVariable(getTeamName(getPlayerTeam(thePlayer)))
	if(GetDatabaseAccount(thePlayer, team) > 0) then
		Respect(thePlayer, team, -1)
		Respect(thePed, team, 1)
		MissionCompleted(thePed, "УВАЖЕНИЕ +", getPlayerName(thePlayer), true)
	else
		ToolTip(thePlayer, "Необходимо иметь положительную репутацию!")
	end
end
addEvent("UpReputation", true)
addEventHandler("UpReputation", root, UpReputation)

function DownReputation(thePlayer, thePed)
	local team = getTeamVariable(getTeamName(getPlayerTeam(thePlayer)))
	if(GetDatabaseAccount(thePlayer, team) > 0) then
		Respect(thePlayer, team, -1)
		Respect(thePed, team, -1)
		MissionCompleted(thePed, "УВАЖЕНИЕ -", getPlayerName(thePlayer), true)
	else
		ToolTip(thePlayer, "Необходимо иметь положительную репутацию!")
	end
end
addEvent("DownReputation", true)
addEventHandler("DownReputation", root, DownReputation)







function getTeamVariable(team)
	if(team == "Мирные жители" or team == "МЧС") then
		return "civilian"
	elseif(team == "Вагос" or team == "Якудзы" or team == "Рифа") then
		return "vagos"
	elseif(team == "Баллас" or team == "Колумбийский картель" or team == "Русская мафия") then
		return "ballas"
	elseif(team == "Гроув-стрит" or team == "Триады" or team == "Ацтекас") then
	    return "grove"
	elseif(team == "Полиция" or team == "Военные" or team == "ЦРУ" or team == "ФБР") then
		return "police"
	elseif(team == "Уголовники" or team == "Байкеры" or team == "Деревенщины") then
		return "ugol"
	end
end






function SpawnedAfterChange(thePlayer, typespawn, zone)
	fadeCamera(thePlayer, true, 4.0, 0, 0, 0)
	UnBindAllKey(thePlayer)
	if(not getPlayerTeam(thePlayer)) then
		SetTeam(thePlayer, GetDatabaseAccount(thePlayer, "team"))
	end
	if(typespawn) then
		SpawnthePlayer(thePlayer, typespawn, zone)
		triggerClientEvent(thePlayer, "CloseSkinSwitchEvent", thePlayer)
	else
		triggerClientEvent(thePlayer, "StartLookZones", thePlayer, toJSON(GetAvailableSpawn(thePlayer, GetDatabaseAccount(thePlayer, "team"))))
	end
end
addEvent("SpawnedAfterChangeEvent", true)
addEventHandler("SpawnedAfterChangeEvent", root, SpawnedAfterChange)



function quitPlayer()
	for gate, dat in pairs(OpenGates) do
		for thePlayer, _ in pairs(dat) do
			if(thePlayer == source) then
				triggerEvent("opengate", thePlayer, gate, "Leave")
			end
		end
	end

	local id = getElementData(source,"id")
	if not id then return end
	ids[id] = nil

	if(PData[source]) then
		if(PData[source]["RobPed"]) then
			StopRob(source)
		end
		for name, el in pairs(PData[source]) do
			if(isTimer(el)) then
				killTimer(el)
			elseif(isElement(el)) then
				if(name ~= "LastVehicle") then
					destroyElement(el)
				end
			end
		end
		PData[source] = nil
	end

	local webplay = ''
	for _, thePlayer in ipairs(getElementsByType("player")) do
		if(thePlayer ~= source) then
			webplay = webplay..getPlayerName(thePlayer)..'<br />'
		end
	end
	callRemote("http://109.227.228.4/engine/include/MTA/online.php", ResultGet, webplay)
end
addEventHandler("onPlayerQuit", getRootElement(), quitPlayer)



function changeNick()
	kickPlayer(source)
	--[[
	destroyElement(source)

	if(PData[source]) then
		if(PData[source]["Timer"]) then
			killTimer(PData[source]["Timer"])
		end
		PData[source] = {}
	end
	--]]
end
addEventHandler("onPlayerChangeNick", getRootElement(), changeNick)




local BackupTimers = {}
function callbackup(thePlayer)
	local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
	if(PlayerTeam == "Полиция") then
		if(not isTimer(BackupTimers[thePlayer])) then
			BackupTimers[thePlayer] = setTimer(function() end, 60000, 1)

			local players = getPlayersInTeam(getTeamFromName("Полиция"))
			local x,y,z = GetPlayerLocation(thePlayer)
			for playerKey, playerValue in ipairs (players) do
				if(playerValue ~= thePlayer) then
					triggerClientEvent(playerValue, "PoliceAddMarker", playerValue, x, y, z, "#4169E1"..getPlayerName(thePlayer).." #FFFFFFвызывает подмогу")
				else
					ToolTip(thePlayer, "Ты вызвал подмогу")
				end
			end
		else
			ToolTip(thePlayer, "Ты уже недавно вызывал подмогу")
		end
	end
end



function Acceleration(thePlayer)
	if(not SData["VehAccData"][thePlayer]) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if(theVehicle) then
			if(getPedOccupiedVehicleSeat(thePlayer) == 0) then
				local HT = getVehicleHandling(theVehicle)
				SData["VehAccData"][thePlayer] = {theVehicle, HT}
				setVehicleHandling(theVehicle, "engineAcceleration", HT["engineAcceleration"]*2)
				if(HT["driveType"] == "rwd") then
					setVehicleHandling(theVehicle, "centerOfMass", {0,-1,0})
				end
			end
		end
	end
end
addEvent("Acceleration", true)
addEventHandler("Acceleration", root, Acceleration)



function AccelerationDown(thePlayer)
	if(SData["VehAccData"][thePlayer]) then
		for name, val in pairs(SData["VehAccData"][thePlayer][2]) do
			setVehicleHandling(SData["VehAccData"][thePlayer][1], name, val)
		end
		SData["VehAccData"][thePlayer] = nil
	end
end
addEvent("AccelerationDown", true)
addEventHandler("AccelerationDown", root, AccelerationDown)




function F4_Load(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	local i = getElementInterior(thePlayer)
	local d = getElementDimension(thePlayer)
	PData[thePlayer]["oldposition"] = {x,y,z,i,d,getPlayerName(thePlayer),}
	setElementPosition(thePlayer, 258.3, -41.8, 1002)
	setElementRotation(thePlayer, 0, 0, 90)
	setElementInterior(thePlayer, 14)
	setElementDimension(thePlayer, getPlayerID(thePlayer))
	local arr = GetDatabaseAccountFromName(getPlayerName(thePlayer), "wardrobe")
	triggerClientEvent(thePlayer, "wardrobe", thePlayer, arr, "house")
end


function F4_Loding(thePlayer)
	PData[thePlayer]["SkinChange"] = true
	outputChatBox("Смена скина будет доступна после смерти.", thePlayer, 255, 255, 255, true)
end

local NoAmmoTitle = {"Кончились патроны", "Нет патрон", "Нужно найти патроны"}
function Reload(thePlayer)
	if(PData[thePlayer]["WeaponSlot"]) then
		local arr = fromJSON(getElementData(thePlayer, "inv"))
		WM = WeaponNamesArr[arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]]["name"]]
		if(WM) then
			local WNA = WeaponAmmo[WM]
			if(WNA) then
				if(arr[PData[thePlayer]["WeaponSlot"][1]][PData[thePlayer]["WeaponSlot"][2]][WNA]) then
					reloadPedWeapon(thePlayer)
				else
					local found = FoundItemsCount(thePlayer, WNA)
					if(found) then
						triggerClientEvent(thePlayer, "Equip", thePlayer, PData[thePlayer]["WeaponSlot"][1], PData[thePlayer]["WeaponSlot"][2], found[1], found[2])
						reloadPedWeapon(thePlayer)
					else
						if(getElementData(thePlayer, "FullClip")) then
							reloadPedWeapon(thePlayer)
						else
							triggerClientEvent(thePlayer, "MyVoice", thePlayer, NoAmmoTitle[math.random(#NoAmmoTitle)], 'gg')
						end
					end
				end
			end
		end
	end
end



function BindAllKey(thePlayer)
	if(getElementType(thePlayer) == "player") then
		bindKey(thePlayer, "tab", "down", TABEvent)
		bindKey(thePlayer, 'F2', 'down', spiz)
		bindKey(thePlayer, 'F3', 'down', lockhouse)
		bindKey(thePlayer, 'r', 'down', Reload)
		bindKey(thePlayer, 'b', 'down', callbackup)
		bindKey(thePlayer, "space", "down", StopAnimation)
		bindKey(thePlayer, "lshift", "down", StopAnimation)
		bindKey(thePlayer, "mouse1", "down", StopAnimation)
		bindKey(thePlayer, "mouse2", "down", StopAnimation)
		bindKey(thePlayer, "lalt","down", laltEnteredPickup)
		bindKey(thePlayer, "next_weapon", "down", nextweapon)
		bindKey(thePlayer, "previous_weapon", "down", nextweapon)
		bindKey(thePlayer, "F4", "down", F4_Loding)
		bindKey(thePlayer, "num_5", "down", restartMode)
		bindKey(thePlayer, "f", "down", vending)
	end
end

function UnBindAllKey(thePlayer)
	if(getElementType(thePlayer) == "player") then
		unbindKey(thePlayer, "tab", "down", TABEvent)
		unbindKey(thePlayer, 'F2', 'down', spiz)
		unbindKey(thePlayer, 'F3', 'down', lockhouse)
		unbindKey(thePlayer, 'r', 'down', Reload)
		unbindKey(thePlayer, 'b', 'down', callbackup)
		unbindKey(thePlayer,"lalt","down", laltEnteredPickup)
		unbindKey(thePlayer, "space", "down", StopAnimation)
		unbindKey(thePlayer, "lshift", "down", StopAnimation)
		unbindKey(thePlayer, "mouse1", "down", StopAnimation)
		unbindKey(thePlayer, "mouse2", "down", StopAnimation)
		unbindKey(thePlayer, "next_weapon", "down", nextweapon)
		unbindKey(thePlayer, "previous_weapon", "down", nextweapon)
		unbindKey(thePlayer, "F4", "down", F4_Loding)
		unbindKey(thePlayer,"num_5", "down", restartMode)
		unbindKey(thePlayer, "f", "down", vending)
		UnBindAllVehicleKey(thePlayer)
	end
end


function BindVehicleKey(thePlayer)
	bindKey(thePlayer,"special_control_up", "down",VehicleBindKeyLight)
	bindKey(thePlayer,"vehicle_secondary_fire", "down",VehicleBindKeyEngine)
	bindKey(thePlayer,"num_5","down",VehicleBindKeyHood)
	bindKey(thePlayer,"special_control_down","down",VehicleBindKeyTrunk)
	bindKey(thePlayer,"special_control_left","down",VehicleBindKeyFL)
	bindKey(thePlayer,"special_control_right","down",VehicleBindKeyFR)
	bindKey(thePlayer,"num_1","down",VehicleBindKeyRL)
	bindKey(thePlayer,"num_3","down",VehicleBindKeyRR)
	bindKey(thePlayer,"num_7","down",VehicleBindKeyRadioL)
	bindKey(thePlayer,"num_9","down",VehicleBindKeyRadioR)
end


function UnBindAllVehicleKey(thePlayer)
	unbindKey(thePlayer,"special_control_up", "down",VehicleBindKeyLight)
	unbindKey(thePlayer,"vehicle_secondary_fire", "down",VehicleBindKeyEngine)
	unbindKey(thePlayer,"num_5", "down",VehicleBindKeyHood)
	unbindKey(thePlayer,"special_control_down","down",VehicleBindKeyTrunk)
	unbindKey(thePlayer,"special_control_left","down",VehicleBindKeyFL)
	unbindKey(thePlayer,"special_control_right","down",VehicleBindKeyFR)
	unbindKey(thePlayer,"num_1","down",VehicleBindKeyRL)
	unbindKey(thePlayer,"num_3","down",VehicleBindKeyRR)
	unbindKey(thePlayer,"num_7","down",VehicleBindKeyRadioL)
	unbindKey(thePlayer,"num_9","down",VehicleBindKeyRRadioR)
end






function helpcmd(thePlayer)
	outputChatBox("/piss - обоссать, /wank - подрочить, /dance [1-13] - танцевать", thePlayer)
	outputChatBox("/arm - служить в армии", thePlayer)
	outputChatBox("/changepass старый пароль новый пароль", thePlayer)
	
	if(getPlayerName(thePlayer) == "alexaxel705") then
		outputChatBox("/srok - Досрочные выборы", thePlayer)
	end
end
addCommandHandler("cmd", helpcmd)


local SpizPlayer = {}
function spiz(thePlayer)
	local player2=getPedTarget(thePlayer)
	if(player2 and not SpizPlayer[thePlayer]) then
		local x, y, z = getElementPosition(thePlayer)
		local x2, y2, z2 = getElementPosition(player2)
		local distance = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
		if(getElementHealth(thePlayer) > 20 and distance < 2) then
			if(getElementType(player2) == "player") then
				if(getElementHealth(player2) < 20) then
					SpizPlayer[thePlayer]=player2
					StartAnimation(thePlayer, "CARRY", "crry_prtial", 1)
					setElementCollisionsEnabled(player2, false)
					attachElements(player2, thePlayer, -0.2, 0.2, 1.4,0,0,0)
					setElementAttachedOffsets (player2,-0.2, 0.2, 1.4,0,0,0)
					StartAnimation(player2, "CRACK", "crckidle4", -1, true, true, true )
					bindKey(thePlayer, "F2", "down", spizstop)
					bindKey(thePlayer, "fire", "down", spizstop)

					SetControls(thePlayer, "spiz", {["jump"] = true})
				end
			end
		end
	end
end


function spizstop(thePlayer)
	if(SpizPlayer[thePlayer]) then
		detachElements(SpizPlayer[thePlayer], thePlayer)
		setElementCollisionsEnabled(SpizPlayer[thePlayer], true)
		local x,y,z = getElementPosition(SpizPlayer[thePlayer])
		setElementPosition(SpizPlayer[thePlayer], x,y,z-1)
		unbindKey(thePlayer, "F2", "down", spizstop)
		unbindKey(thePlayer, "fire", "down", spizstop)
		SpizPlayer[thePlayer] = nil
		SetControls(thePlayer, "spiz", {["jump"] = false})
	end
end




local PrisonVariable = {
	["Los Santos"] = "LSPD",
	["San Fierro"] = "SFPD",
	["Las Venturas"] = "LVPD",
	["Red County"] = "RCPD",
	["Whetstone"] = "WSPD",
	["Flint County"] = "FCPD",
	["Bone County"] = "BCPD",
	["Tierra Robada"] = "TRPD",
	["UNDERWATER"] = "AREA51",
	["Unknown"] = "AREA51"
}

local DroppedItem = {
	["Рюкзак"] = true,
	["Чемодан"] = true,
	["Пакет"] = true,
	["Конопля"] = true,
	["Кока"] = true,
	["Косяк"] = true,
	["Спанк"] = true,
	["Парашют"] = true,
	["Запаска"] = true,
	["Алкоголь"] = true,
	["Скот"] = true,
	["Мясо"] = true,
	["Нефть"] = true,
	["Пропан"] = true,
	["Химикаты"] = true,
	["Удобрения"] = true,
	["Бензин"] = true,
	["Зерно"] = true,
}


function player_Wasted(ammo, killer, weapon, bodypart, stealth)
	if(PData[source]["RobPed"]) then
		StopRob(source)
	end

	if(weapon == 63) then
		if(PData[source]["LastVehicle"]) then
			if(getElementData(PData[source]["LastVehicle"], "killer")) then
				killer = getPlayerFromName(getElementData(PData[source]["LastVehicle"], "killer"))
				weapon = getElementData(PData[source]["LastVehicle"], "weapon") or 1337
			end
		end
	end

	UnBindAllKey(source)
	SetControls(source, "crack", {["fire"] = false,  ["action"] = false, ["jump"] = false})
	
	if(not PData[source]["DeathMatch"]) then  
		AddSkill(source, 22, -7)
		if(getPedStat(source, 24) > 5) then AddSkill(source, 24, -5) end
	end


	if(isElement(TruckMarker[source])) then
		DestroyTruckMarker(source)
		TruckMarker[source] = nil
	end
	

	if(killer) then
		if(source ~= killer) then
			if(getElementType(killer) == "ped") then
				for _,ped in pairs(getElementsByType "ped") do
					if(getElementData(ped, "attacker") == getPlayerName(source)) then
						removeElementData(ped, "attacker")
					end
				end
				
				if(PData[source]["DeathMatch"]) then 
					return true
				end

				local KTeam = getElementData(killer, "team")
				local PTeam = getTeamName(getPlayerTeam(source))

				if(PTeam ~= "Уголовники" and KTeam == "Полиция" or KTeam == "ФБР" or KTeam == "Военные") then
					if(GetDatabaseAccount(source, "wanted") > 0) then
						if(GetPlayerMoney(source) >= GetDatabaseAccount(source, "wanted")*100) then
							AddPlayerMoney(source, -(GetDatabaseAccount(source, "wanted")*100))
						end
						SetDatabaseAccount(source, "PrisonTime", GetDatabaseAccount(source, "wanted")*20)
						SetDatabaseAccount(source, "prisoninv", GetDatabaseAccount(source, "inv"))
						SetDatabaseAccount(source, "inv", StandartInventory)
						local x,y,z = GetPlayerLocation(source)
						local zone = getZoneName(x,y,z,true)
						SetDatabaseAccount(source, "OldTeam", PTeam)
						SetDatabaseAccount(source, "Prison", PrisonVariable[zone])
						SetTeam(source, "Уголовники")
					end
				end

			elseif(getElementType(killer) == "player") then
				local PTeam = getTeamName(getPlayerTeam(source))
				local KTeam = getTeamName(getPlayerTeam(killer))

				if(WeaponModel[weapon][2]) then AddSkill(killer, WeaponModel[weapon][2]) end
				if(PData[source]["DeathMatch"]) then 
					if(DMPlayerList[killer]) then
						DMPlayerList[killer] = DMPlayerList[killer] + 1
					end
					return true
				end
				
				if(PTeam ~= "Уголовники" and KTeam == "Полиция" or KTeam == "ФБР" or KTeam == "Военные") then
					if(GetDatabaseAccount(source, "wanted") > 0) then
						Respect(killer, "civilian", 1)
						Respect(killer, "police", 1)
						Respect(killer, "ugol", -1)
						if(GetPlayerMoney(source) >= GetDatabaseAccount(source, "wanted")*100) then
							MissionCompleted(killer, "УВАЖЕНИЕ +", "ПРЕСТУПНИК ПОЙМАН!")
							AddBizMoney("PLSPD", GetDatabaseAccount(source, "wanted")*100)
							AddPlayerMoney(source, -(GetDatabaseAccount(source, "wanted")*100))
						end
						SetDatabaseAccount(source, "PrisonTime", GetDatabaseAccount(source, "wanted")*20)

						SetDatabaseAccount(source, "prisoninv", GetDatabaseAccount(source, "inv"))
						SetDatabaseAccount(source, "inv", StandartInventory)
						local x,y,z = GetPlayerLocation(source)
						local zone = getZoneName(x,y,z,true)
						SetDatabaseAccount(source, "Prison", PrisonVariable[zone])
						SetTeam(source, "Уголовники")
					else
						Respect(killer, "police", -5)
						Respect(killer, "civilian", -5)
						outputChatBox("Вы заплатили "..COLOR["DOLLAR"]["HEX"].."$2500#FFFFFF за невиновного", killer, 255, 255, 255, true)
						AddPlayerMoney(killer, -2500)
						outputChatBox("Вы получили компенсацию в размере "..COLOR["DOLLAR"]["HEX"].."$2500#FFFFFF за невиновность", source, 255, 255, 255, true)
						AddPlayerMoney(source, 2500)
					end
				end

				if(PTeam == "Мирные жители" and KTeam ~= "Полиция") then
					Respect(killer, "civilian", -1)
					WantedLevel(killer, 1)
				elseif(PTeam == "Баллас" or PTeam == "Колумбийский картель" or PTeam == "Русская мафия") then
					Respect(killer, "grove", 1)
					Respect(killer, "ballas", -1)
				elseif(PTeam == "Гроув-стрит" or PTeam == "Триады" or PTeam == "Ацтекас") then
					Respect(killer, "grove", -1)
					Respect(killer, "ballas", 1)
					Respect(killer, "vagos", 1)
				elseif(PTeam == "Вагос" or PTeam == "Якудзы" or PTeam == "Рифа") then
					Respect(killer, "vagos", -1)
					Respect(killer, "grove", 1)
				elseif(PTeam == "Полиция" or PTeam == "ФБР") then
					Respect(killer, "ugol", 3)
					Respect(killer, "police", -3)
					Respect(killer, "civilian", -3)
					WantedLevel(killer, 1)
				elseif(PTeam == "Деревенщины") then
					Respect(killer, "ugol", -1)
				elseif(PTeam == "Уголовники" and KTeam == "Уголовники") then
					Respect(killer, "ugol", 1)
					SetDatabaseAccount(killer, "PrisonTime", GetDatabaseAccount(killer, "PrisonTime")+100)
					MissionCompleted(killer, "СРОК +", "ПЛОХОЕ ПОВЕДЕНИЕ")
				elseif(PTeam == "Деревенщины" and KTeam == "Деревенщины") then
					Respect(killer, "ugol", 1)
					WantedLevel(killer, 1)
				elseif(PTeam == "Байкеры" and KTeam == "Байкеры") then
					Respect(killer, "ugol", 1)
					WantedLevel(killer, 1)
				end
			end
		end
	end

end
addEventHandler("onPlayerWasted", getRootElement(), player_Wasted)




function AttachTrailer(theTruck)
	if(getPedOccupiedVehicleSeat(getVehicleOccupant(theTruck)) == 0) then
		if(getElementModel(theTruck) ~= 525 and getElementModel(theTruck) ~= 531) then
			CreateTruckMarker(getVehicleOccupant(theTruck), getElementData(source, "x"), getElementData(source, "y"), getElementData(source, "z"))
		end
	end
end
addEventHandler("onTrailerAttach", getRootElement(), AttachTrailer)






local SLG = {"Автомобильные запчасти", "Строительные материалы", "Продукты" ,"Фрукты", "Мебель", "Удобрения", "Хлопья", "Сок", "Неизвестный груз", "Пропан", "Электроника", "Одежда", "Игрушки", "Цемент", "Инструменты", "Товары", "Уголь"} -- Генерируемый груз на любых складах
local SUG = {"Автомобильные запчасти", "Строительные материалы" ,"Продукты" ,"Фрукты", "Мебель", "Удобрения", "Хлопья", "Сок", "Неизвестный груз", "Пропан", "Электроника", "Одежда", "Игрушки", "Цемент", "Инструменты", "Товары", "Уголь", "Скот"} -- Принимаемый груз на любых складах






-- theVehicle, x,y,z,rx,ry,rz, {Принимаемый груз (nil - никакой)}, {Генерируемый груз (nil - никакой)},
-- Если false то свободно, если true то в ожидании, если theVehicle то готов к отправке
local TrailersPositions = {
	["Склад «Fallen Tree»"] = {
		[1] = {false, -557.6, -500, 24.1, 0,0,0, SUG, SLG},
		[2] = {false, -529.8, -500, 24.1, 0,0,0, SUG, SLG},
		[3] = {false, -520.5, -500, 24.1, 0,0,0, SUG, SLG},
		[4] = {false, -520.3, -545.5, 24.5, 0,0,180, SUG, SLG},
		[5] = {false, -529.7, -545.5, 24.5, 0,0,180, SUG, SLG},
		[6] = {false, -557.6, -545.5, 24.5, 0,0,180, SUG, SLG},
	},
	["Liberty City"] = {
		[1] = {false, 2786, -2494.6, 12.6, 0,0,90, SUG, SLG},
		[2] = {false, 2786, -2456.2, 12.6, 0,0,90, SUG, SLG},
		[3] = {false, 2786, -2418.1, 12.6, 0,0,90, SUG, SLG},
	},
	["НПЗ «Грин-Палмс»"] = {
		[1] = {false, 283.7, 1380, 9.6, 0,0,90, nil, {"Бензин"}},
		[2] = {false, 283.7, 1385, 9.6, 0,0,90, nil, {"Бензин"}},
		[3] = {false, 283.7, 1390, 9.6, 0,0,90, nil, {"Бензин"}},
		[4] = {false, 283.7, 1395, 9.6, 0,0,90, nil, {"Бензин"}}
	},
	["Easter Bay Chemicals"] = {
		[1] = {false, -1043.5, -696.8, 31, 0,0,0, nil, {"Бензин"}},
		[2] = {false, -992.8, -698.6, 31, 0,0,90, nil, {"Бензин"}},
	},
	["Грузовая станция Los Santos"] = {
		[1] = {false, 1769.5, -2042.6, 12.5, 0,0,270, SUG, SLG},
		[2] = {false, 1769.5, -2038.3, 12.5, 0,0,270, SUG, SLG},
		[3] = {false, 1788.8, -2057, 12.6, 0,0,0, SUG, SLG},
	},
	["RS Haul"] = {
		[1] = {false, -68.6, -1112.5, 0.1, 0,0,90, SUG, SLG},
		[2] = {false, -70, -1121.5, 0.1, 0,0,90, SUG, SLG},
		[3] = {false, -65, -1143, 0.1, 0,0,0, SUG, SLG},
		[4] = {false, -60, -1146, 0.1, 0,0,0, SUG, SLG},
		[5] = {false, -54, -1149, 0.1, 0,0,0, SUG, SLG},
		[6] = {false, -48, -1152, 0.1, 0,0,0, SUG, SLG},
		[7] = {false, -42, -1155, 0.1, 0,0,0, SUG, SLG},
	},
	["Pecker's Feed & Seed"] = {
		[1] = {false, -337, 2682, 62.3, 0,0,90, SUG, {"Скот"}},
		[2] = {false, -337, 2678, 62.3, 0,0,90, SUG, {"Скот"}},
		[3] = {false, -337, 2674, 62.3, 0,0,90, SUG, {"Скот"}},
		[4] = {false, -337, 2670, 62.3, 0,0,90, SUG, {"Скот"}},
		[5] = {false, -286, 2666, 61.7, 0,0,90, SUG, {"Скот"}},
		[6] = {false, -286, 2661, 61.7, 0,0,90, SUG, {"Скот"}},
	},
	["Solarin Industries"] = {
		[1] = {false, -1838, 112.9, 14.1, 0,0,270, nil, nil},
	},
	["Грузовая станция Las Venturas"] = {
		[1] = {false, 2261, 2779.9, 9.8, 0,0,90, SUG, SLG},
		[2] = {false, 2261, 2770.5, 9.8, 0,0,90, SUG, SLG},
		[3] = {false, 2261, 2763.9, 9.8, 0,0,90, SUG, SLG},
		[4] = {false, 2261, 2754.5, 9.8, 0,0,90, SUG, SLG},
		[5] = {false, 2261, 2747.7, 9.8, 0,0,90, SUG, SLG},
		[6] = {false, 2261, 2738.3, 9.8, 0,0,90, SUG, SLG},

		[7] = {false, 2296, 2780, 9.8, 0,0,270, SUG, SLG},
		[8] = {false, 2296, 2770.6, 9.8, 0,0,270, SUG, SLG},
		[9] = {false, 2296, 2763.8, 9.8, 0,0,270, SUG, SLG},
		[10] = {false, 2296, 2754.5, 9.8, 0,0,270, SUG, SLG},
		[11] = {false, 2296, 2747.9, 9.8, 0,0,270, SUG, SLG},
		[12] = {false, 2296, 2738.4, 9.8, 0,0,270, SUG, SLG},

		[13] = {false, 2346.3, 2780, 9.8, 0,0,270, SUG, SLG},
		[14] = {false, 2346.3, 2770.6, 9.8, 0,0,270, SUG, SLG},
		[15] = {false, 2346.3, 2763.8, 9.8, 0,0,270, SUG, SLG},
		[16] = {false, 2346.3, 2754.5, 9.8, 0,0,270, SUG, SLG},
		[17] = {false, 2346.3, 2747.9, 9.8, 0,0,270, SUG, SLG},
		[18] = {false, 2346.3, 2738.4, 9.8, 0,0,270, SUG, SLG},

		[19] = {false, 2311.7, 2780, 9.8, 0,0,90, SUG, SLG},
		[20] = {false, 2311.7, 2770.6, 9.8, 0,0,90, SUG, SLG},
		[21] = {false, 2311.7, 2763.8, 9.8, 0,0,90, SUG, SLG},
		[22] = {false, 2311.7, 2754.5, 9.8, 0,0,90, SUG, SLG},
		[23] = {false, 2311.7, 2747.9, 9.8, 0,0,90, SUG, SLG},
		[24] = {false, 2311.7, 2738.4, 9.8, 0,0,90, SUG, SLG},
	},
	["Склад «Redsands West»"] = {
		[1] = {false, 1638, 2303, 9.3, 0,0,90, SUG, SLG},
		[2] = {false, 1638, 2312.2, 9.2, 0,0,90, SUG, SLG},
		[3] = {false, 1638, 2340.2, 9.3, 0,0,90, SUG, SLG},
		[4] = {false, 1681, 2303, 9.3, 0,0,270, SUG, SLG},
		[5] = {false, 1681, 2312.5, 9.3, 0,0,270, SUG, SLG},
		[6] = {false, 1681, 2340.3, 9.4, 0,0,270, SUG, SLG},
	},
	["Склад №2 Las Venturas"] = {
		[1] = {false, 1133, 1935, 9.8, 0,0,270, SUG, SLG},
		[2] = {false, 1133, 1926.3, 9.8, 0,0,270, SUG, SLG},
		[3] = {false, 1133, 1920.2, 9.8, 0,0,270, SUG, SLG},
		[4] = {false, 1133, 1911.5, 9.8, 0,0,270, SUG, SLG},
		[5] = {false, 1133, 1904, 9.8, 0,0,270, SUG, SLG},
		[6] = {false, 1133, 1896.6, 9.8, 0,0,270, SUG, SLG},

		[7] = {false, 1109, 1935, 9.8, 0,0,90, SUG, SLG},
		[8] = {false, 1109, 1926.3, 9.8, 0,0,90, SUG, SLG},
		[9] = {false, 1109, 1920.2, 9.8, 0,0,90, SUG, SLG},
		[10] = {false, 1109, 1911.5, 9.8, 0,0,90, SUG, SLG},
		[11] = {false, 1109, 1904, 9.8, 0,0,90, SUG, SLG},
		[12] = {false, 1109, 1896.6, 9.8, 0,0,90, SUG, SLG},

		[13] = {false, 1053, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[14] = {false, 1060.4, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[15] = {false, 1067.9, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[16] = {false, 1076.7, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[17] = {false, 1082.8, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[18] = {false, 1091.4, 1915.7, 9.8, 0,0,0, SUG, SLG},

		[19] = {false, 1067.9, 1892, 9.8, 0,0,180, SUG, SLG},
		[20] = {false, 1076.7, 1892, 9.8, 0,0,180, SUG, SLG},
		[21] = {false, 1082.8, 1892, 9.8, 0,0,180, SUG, SLG},
		[22] = {false, 1091.4, 1892, 9.8, 0,0,180, SUG, SLG},
	},
	["Shafted Appliances"] = {
		[1] = {false, 1681, 919.4, 9.7, 0,0,0, nil, {"Электроника"}},
		[2] = {false, 1710.4, 931.4, 9.8, 0,0,90, nil, {"Электроника"}},
	},
	["АЗС «Xoomer»"] = {
		[1] = {false, -1715.1, 394.7, 6.2, 0,0,225, {"Бензин"}, nil}
	},
	["The Uphill Gardener"] = {
		[1] = {false, -2586.8, 304.2, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[2] = {false, -2586.8, 307.7, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[3] = {false, -2586.8, 311.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[4] = {false, -2586.8, 314.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[5] = {false, -2586.8, 318.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[6] = {false, -2586.8, 321.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[7] = {false, -2586.8, 325.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[8] = {false, -2586.8, 328.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[9] = {false, -2586.8, 332.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[10] = {false, -2586.8, 335.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
	},

	["Emerald Mart"] = {
		[1] = {false, 2060, 2238.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
		[2] = {false, 2060, 2251.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
		[3] = {false, 2060, 2264.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
	},
	["LVA Freight Mart"] = {
		[1] = {false, 1528.3, 943.5, 9.8, 0,0,90, {"Продукты", "Игрушки"}, nil},
		[2] = {false, 1528.3, 951.7, 9.8, 0,0,90, {"Продукты", "Игрушки"}, nil},
	},
	["Dillimore Welcome Pump"] = {
		[1] = {false, 680.9, -442.4, 15.3, 0,0,270, {"Продукты"}, nil},
	},
	["Dillimore Watson Automotive"] = {
		[1] = {false, 640, -500.1, 15.3, 0,0,180, {"Автомобильные запчасти"}, nil},
	},
	["Dillimore Big Mike's"] = {
		[1] = {false, 634.4, -514.8, 15.3, 0,0,0, {"Автомобильные запчасти"}, nil},
	},
	["Dillimore Склад"] = {
		[1] = {false, 790, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[2] = {false, 797.7, -617.3, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[3] = {false, 820.1, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[4] = {false, 830.3, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
	},
	["Montgomery BIO Engineering"] = {
		[1] = {false, 1354.7, 363.6, 19, 352,0,66, nil, {"Химикаты"}},
		[2] = {false, 1351.3, 356, 19, 352,0,66, nil, {"Химикаты"}},
		[3] = {false, 1340.9, 333, 19, 352,0,66, nil, {"Химикаты"}},
		[4] = {false, 1337.7, 325.2, 19, 352,0,66, nil, {"Химикаты"}},
	},
	["Склад «Rockshore East»"] = {
		[1] = {false, 2818.1, 895.7, 9.1, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[2] = {false, 2827.3, 896.9, 9.2, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[3] = {false, 2855.1, 895.9, 9.1, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},

		[4] = {false, 2818, 853, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[5] = {false, 2827.3, 853, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[6] = {false, 2855.3, 852.5, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
	},
}

function FoundRandomEmptyTruckLocation(banned) -- Генерирует случайный груз [Возвращает {Имя базы, id трейлера}]
	local AllLoc = {}
	for BaseName, arr in pairs(TrailersPositions) do
		if(BaseName ~= banned) then
			for i, key in pairs (arr) do
				if(key[1] == false) then
					if(key[9]) then -- Если станция генерирует грузы
						AllLoc[#AllLoc+1] = {BaseName, i}
					end
				end
			end
		end
	end
	if(#AllLoc == 0) then
		return {"Грузовая станция Las Venturas", 1}
	end
	return AllLoc[math.random(#AllLoc)]
end



function FoundRandomEmptyTruckLocationOut(banned, gruz) -- Ищет для груза конечную станцию [Возвращает {Имя базы, id трейлера}]
	local AllLoc = {}
	for BaseName, arr in pairs(TrailersPositions) do
		if(BaseName ~= banned) then
			for i, key in pairs (arr) do
				if(key[1] == false) then
					if(key[8]) then -- Если станция принимает грузы
						for _, gr in pairs(key[8]) do
							if(gruz == gr) then
								AllLoc[#AllLoc+1] = {BaseName, i}
								break
							end
						end
					end
				end
			end
		end
	end
	if(#AllLoc == 0) then
		return {"Грузовая станция Las Venturas", 1}
	end
	return AllLoc[math.random(#AllLoc)]
end









function CreateTrailer(BaseDat)
	local arr = TrailersPositions[BaseDat[1]][BaseDat[2]]
	local AllModels = {}
	local randProd = arr[9][math.random(#arr[9])]
	for models, var in pairs(TrailersVaritans) do
		for i, dat in pairs(var) do
			if(dat[1] == randProd) then
				AllModels[#AllModels+1] = {models, i-1}
			end
		end
	end

	local MV = AllModels[math.random(#AllModels)]
	local x,y,z,rx,ry,rz = arr[2], arr[3], arr[4], arr[5], arr[6], arr[7]
	local t = CreateVehicle(MV[1],x,y,z+VehicleSystem[MV[1]][1], rx, ry, rz, nil, true, MV[2], MV[2])
	setElementData(t, "resx", x)
	setElementData(t, "resy", y)
	setElementData(t, "resz", z)
	setElementData(t, "resrx", rx, false)
	setElementData(t, "resry", ry, false)
	setElementData(t, "resrz", rz, false)
	setElementData(t, "product", TrailersVaritans[MV[1]][MV[2]+1][1])
	setElementData(t, "type", "jobtruck")--Для JPS


	local rl = FoundRandomEmptyTruckLocationOut(BaseDat[1], randProd)
	local randLoc = TrailersPositions[rl[1]][rl[2]]
	setElementData(t, "x", randLoc[2])
	setElementData(t, "y", randLoc[3])
	setElementData(t, "z", randLoc[4])
	setElementData(t, "BaseDat", toJSON({rl[1], rl[2]}))
	setElementData(t, "RandLoc", toJSON({BaseDat[1], BaseDat[2]}))

	setElementData(t, "money", math.floor(((getDistanceBetweenPoints3D(randLoc[2],randLoc[3],randLoc[4],x,y,z)*2)*TrailersVaritans[MV[1]][MV[2]+1][2])))


	TrailersPositions[BaseDat[1]][BaseDat[2]][1] = t
	TrailersPositions[rl[1]][rl[2]][1] = true
	return t
end

for slot = 1, 50 do
	CreateTrailer(FoundRandomEmptyTruckLocation())
end

function DeattachTrailer(theTruck)
	local occ = getVehicleOccupant(theTruck)
	if(occ) then
		if(getElementModel(theTruck) ~= 525 and getElementModel(theTruck) ~= 531) then
			if(isElement(TruckMarker[occ])) then
				DestroyTruckMarker(occ)
			end
		else
			triggerEvent("ParkMyCar", occ, source)
		end
	end
end
addEventHandler("onTrailerDetach", getRootElement(), DeattachTrailer)


function DestroyTruckMarker(thePlayer)
	destroyElement(TruckMarker[thePlayer])
	triggerClientEvent(thePlayer, "RemoveGPSMarker", thePlayer, "Отвези груз")
end



function MarkerHit(hitElement, Dimension)
    local elementType = getElementType(hitElement) -- get the hit element's type
	if(elementType == "vehicle" and Dimension) then
		local thePlayer = getVehicleOccupant(hitElement, 0)
		if(GetVehicleType(hitElement) == "Trailer") then
			local truck = getVehicleTowingVehicle(hitElement)
			if(truck) then thePlayer = getVehicleOccupant(truck, 0) end
		end
		if(thePlayer) then
			local theVehicle = hitElement
			if(getElementData(theVehicle, "type") == "jobtruck" and getElementData(source, "type") == "TruckMarker" and getElementData(source, "player") == getPlayerName(thePlayer)) then
				AddPlayerMoney(thePlayer, getElementData(theVehicle, "money"), "РАБОТА ВЫПОЛНЕНА!")
				AddSkill(thePlayer, 161)
				DestroyTruckMarker(thePlayer)
				Respect(thePlayer, "civilian", 1)
				local rl = fromJSON(getElementData(theVehicle, "RandLoc"))
				local bd = fromJSON(getElementData(theVehicle, "BaseDat"))
				destroyElement(theVehicle)
				TrailersPositions[rl[1]][rl[2]][1] = false
				TrailersPositions[bd[1]][bd[2]][1] = false
				CreateTrailer(FoundRandomEmptyTruckLocation())
			elseif(getElementData(source, "type") == "SPRAY") then
				local g = getElementData(source, "id")
				setGarageOpen(g, false)
				setTimer(function(thePlayer, theVehicle)
					if(AddPlayerMoney(thePlayer, -100)) then
						fixVehicle(theVehicle)
						MissionCompleted(thePlayer, "$100", Text(thePlayer, "НОВЫЙ ДВИГАТЕЛЬ И ПОКРАСКА"))
						setVehicleColor(theVehicle, math.random(0,127), math.random(0,127), math.random(0,127), math.random(0,127))
						AddBizMoney("SPRAYSA", 100)
						WantedLevel(thePlayer, -6)
					end
					setGarageOpen(g, true)
				end, 3000, 1, thePlayer, theVehicle)
			elseif(getElementData(source, "type") == "siren") then
				HelpMessage(thePlayer, "Установка сигнализации "..COLOR["DOLLAR"]["HEX"].."$35000\n#FFFFFFНажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы установить")
				PetrolFuelMarker[thePlayer] = source
			elseif(getElementData(source, "type") == "recyclels") then
				HelpMessage(thePlayer, "Авторазбор\nНажми "..COLOR["KEY"]["HEX"].."Alt#FFFFFF чтобы сдать автомобиль")
				PetrolFuelMarker[thePlayer] = source
			elseif(getElementData(source, "type") == "kickstart") then
				local x,y,z = getElementPosition(source)
				local r,g,b,a = getMarkerColor(source)
				if(r == 255 and g == 0 and b == 0) then
					AddPlayerMoney(thePlayer, 1000)
				elseif(r == 255 and g == 255 and b == 0) then
					AddPlayerMoney(thePlayer, 450)
				elseif(r == 0 and g == 255 and b == 0) then
					AddPlayerMoney(thePlayer, 150)
				end
				setTimer(function()
					local p = createMarker(x, y, z, "corona", 1)
					setMarkerColor(p, r,g,b,a)
					setElementInterior(p,14)
					setElementData(p, "type", "kickstart")
				end, 120000, 1)
				destroyElement(source)
			end
		end
	elseif(elementType == "player" and Dimension) then
		thePlayer = hitElement
		if(getElementData(source, "type") == "FIRE") then
			setPedOnFire(thePlayer, true)
		elseif(getElementData(source, "type") == "enter") then
		local r,g,b,a = getMarkerColor(source)
		local text = Text(thePlayer, "Нажми {key} чтобы войти", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}})
		if(r == 255 and g == 255) then
			PlayersEnteredPickup[thePlayer] = source
		else
			text = COLOR["REDDOLLAR"]["HEX"].. Text(thePlayer, "ЗАКРЫТО НА РЕМОНТ")
		end

		if(getElementData(source, "house")) then
			local x,y,z = getElementPosition(source)
			local ZName = getZoneName(x,y,z)
			MissionCompleted(thePlayer, getElementData(source, "owner"), ZName.." "..getElementData(source, "zone"))
			if(getElementData(source, "owner") == getPlayerName(thePlayer)) then
				if(getElementData(source, "locked") == 1) then
					text =  text.."\n"..Text(thePlayer, "Нажми {key} чтобы открыть дом", {{"{key}", COLOR["KEY"]["HEX"].."F3#FFFFFF"}})
				else
					text = text.."\n"..Text(thePlayer, "Нажми {key} чтобы закрыть дом", {{"{key}", COLOR["KEY"]["HEX"].."F3#FFFFFF"}})
				end
				text = text.."\n"..Text(thePlayer, "Нажми {key} чтобы продать дом {money}", {{"{key}", COLOR["KEY"]["HEX"].."TAB#FFFFFF"}, {"{money}", COLOR["DOLLAR"]["HEX"].."$"..getElementData(source, "price")}})
			end
		end

		ToolTip(thePlayer, text)
		elseif(getElementData(source, "type") == "exit") then
			PlayersEnteredPickup[thePlayer] = source
			ToolTip(thePlayer, Text(thePlayer, "Нажми {key} чтобы выйти", {{"{key}", COLOR["KEY"]["HEX"].."Alt#FFFFFF"}}))
		end
	end
end
addEventHandler("onMarkerHit", getRootElement(), MarkerHit)




function wardrobe(thePlayer, new) --тут
	if(not tonumber(new)) then return false end
	local old = tostring(GetDatabaseAccount(thePlayer, "skin"))
	new=tostring(new)
	if(old ~= new) then
		local arr = fromJSON(GetDatabaseAccountFromName(PData[thePlayer]["oldposition"][6], "wardrobe"))
		if(arr[new]) then -- Если одновременно переодеваются 2 человека
			if(not arr[old]) then
				arr[old] = 1
			elseif(arr[old] < 999) then
				arr[old]=arr[old]+1
			end

			if(arr[new] == 1) then
				arr[new] = nil
			elseif(arr[new] < 999) then
				arr[new] = arr[new]-1
			end

			SetDatabaseAccountFromName(PData[thePlayer]["oldposition"][6], "wardrobe", toJSON(arr))
			SetDatabaseAccount(thePlayer, "skin", new)

			SetPlayerModel(thePlayer, new)
		else
			SetPlayerModel(thePlayer, old)
		end
	end
	setCameraTarget(thePlayer, thePlayer)

	setElementPosition(thePlayer, PData[thePlayer]["oldposition"][1], PData[thePlayer]["oldposition"][2], PData[thePlayer]["oldposition"][3])
	setElementInterior(thePlayer, PData[thePlayer]["oldposition"][4])
	setElementDimension(thePlayer, PData[thePlayer]["oldposition"][5])
	PData[thePlayer]["oldposition"] = nil
end
addEvent("wardrobe", true)
addEventHandler("wardrobe", getRootElement(), wardrobe)




function buywardrobe(thePlayer, new, cost)
	local old = GetDatabaseAccount(thePlayer, "skin")
	if(new) then
		new=tonumber(new)
		if(old ~= new) then
			if(AddPlayerMoney(thePlayer, -tonumber(cost))) then
				SetDatabaseAccount(thePlayer, "skin", new)
				old=new
			end
		end
	end
	SetPlayerModel(thePlayer, old)
	setCameraTarget(thePlayer, thePlayer)

	setElementPosition(thePlayer, PData[thePlayer]["oldposition"][1], PData[thePlayer]["oldposition"][2], PData[thePlayer]["oldposition"][3])
	setElementInterior(thePlayer, PData[thePlayer]["oldposition"][4])
	setElementDimension(thePlayer, PData[thePlayer]["oldposition"][5])
	PData[thePlayer]["oldposition"] = nil
end
addEvent("buywardrobe", true)
addEventHandler("buywardrobe", getRootElement(), buywardrobe)



function SetPlayerModel(thePlayer, model)
	model = tonumber(model)
	setElementModel(thePlayer, model)
	setPedWalkingStyle(thePlayer, SkinData[model][1])
end
addEvent("SetPlayerModel", true)
addEventHandler("SetPlayerModel", getRootElement(), SetPlayerModel)




function OpenTuning(thePlayer,x,y,z,rz)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if(theVehicle) then
		if(getPedOccupiedVehicleSeat(thePlayer) == 0) then
			if(GetVehicleType(theVehicle) == "Automobile" or GetVehicleType(theVehicle) == "Bike") then

				setPlayerHudComponentVisible(thePlayer, "radar", false)
				PData[thePlayer]["oldposition"] = {x,y,z,rz}
				PData[thePlayer]["theVehicleTuning"] = theVehicle
				PData[thePlayer]["theVehicleTuningHandl"] = getElementData(theVehicle, "handl")
				local d = getPlayerID(thePlayer)+2000
				setElementDimension(theVehicle, d)
				local occupants = getVehicleOccupants(theVehicle) or {}
				for seat, occupant in pairs(occupants) do
					setElementDimension(occupant, d)
					setElementInterior(occupant, 2, 616.8 , -74.8, 997+VehicleSystem[getElementModel(theVehicle)][1])
				end
				setElementInterior(theVehicle, 2, 616.8, -74.8, 997+VehicleSystem[getElementModel(theVehicle)][1])


				setElementRotation(theVehicle, 0,0,90)

				local vehh = getVehicleHandling(theVehicle)

				triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 5)
				local parts = GetPlayerVehiclePart(thePlayer, theVehicle) -- Только выигранные детали



				fixVehicle(theVehicle)
				triggerClientEvent(thePlayer, "CameraTuning", thePlayer, getElementData(theVehicle, "handl"), toJSON(parts))

			else
				HelpMessage(thePlayer, "Тюнинговать можно только автомобили!")
			end
		end
	end
end
addEvent("OpenTuning", true)
addEventHandler("OpenTuning", getRootElement(), OpenTuning)



function AddPlayerVehiclePart(thePlayer, types, name)
	local parts = GetDatabaseAccount(thePlayer, "tuning")
	if(parts == 0) then parts = {}
	else parts = fromJSON(parts) end

	if(not parts[types]) then parts[types] = {} end

	if(not parts[types][name]) then
		parts[types][name] = 1
	else
		parts[types][name] = parts[types][name]+1
	end

	SetDatabaseAccount(thePlayer, "tuning", toJSON(parts))
end




function RemovePlayerVehiclePart(thePlayer, types, name)
	local parts = GetDatabaseAccount(thePlayer, "tuning")
	if(parts == 0) then parts = {}
	else parts = fromJSON(parts) end

	if(parts[types]) then
		if(parts[types][name]) then
			if(parts[types][name] == 1) then
				parts[types][name] = nil
				if(getArrSize(parts[types]) == 0) then
					parts[types] = nil
				end
			else
				parts[types][name] = parts[types][name]-1
			end
		end
	end

	SetDatabaseAccount(thePlayer, "tuning", toJSON(parts))
end


function GetPlayerVehiclePart(thePlayer, theVehicle)
	--local parts = {} -- Разблокирует весь тюнинг
	--for nameparts, data in pairs(VComp) do
	--	for name, types in pairs(data) do
	--		if(not parts[nameparts]) then parts[nameparts] = {} end
	--		parts[nameparts][name] = types
	--	end
	--end

	local parts = GetDatabaseAccount(thePlayer, "tuning")
	if(parts == 0) then parts = {}
	else parts = fromJSON(parts) end

	for partsname, data in pairs(parts) do
		for name, dat in pairs(data) do
			parts[partsname][name] = VComp[partsname][name]
		end
	end
	return parts
end



function EatCluckin(thePlayer, thePed, name, count)
	if(not isTimer(PData[thePlayer]["anitimer"])) then
		if(AddPlayerMoney(thePlayer, count)) then
			local health = getElementHealth(thePlayer)
			setElementHealth(thePlayer, health+40)
			if(name == "The Well Stacked Pizza Co.") then
				StartAnimation(thePlayer, "FOOD", "EAT_Pizza",false,false,false,false)
				AddPlayerArmas(thePlayer, 2881)
				PData[thePlayer]["anitimer"] = setTimer(RemovePlayerArmas, 3000, 1, thePlayer, 2881)
			elseif(name == "Burger Shot") then
				StartAnimation(thePlayer, "FOOD", "EAT_Burger",false,false,false,false)
				AddPlayerArmas(thePlayer, 2880)
				PData[thePlayer]["anitimer"] = setTimer(RemovePlayerArmas, 3000, 1, thePlayer, 2880)
			elseif(name == "Cluckin' Bell") then
				StartAnimation(thePlayer, "FOOD", "EAT_Chicken",false,false,false,false)
				AddPlayerArmas(thePlayer, 2880)
				PData[thePlayer]["anitimer"] = setTimer(RemovePlayerArmas, 3000, 1, thePlayer, 2880)
			elseif(name == "Chilli Dogs") then
				StartAnimation(thePlayer, "FOOD", "EAT_Chicken",false,false,false,false)
				AddPlayerArmas(thePlayer, 2880)
				PData[thePlayer]["anitimer"] = setTimer(RemovePlayerArmas, 3000, 1, thePlayer, 2880)
			end
		end
	end
end
addEvent("EatCluckin", true)
addEventHandler("EatCluckin", getRootElement(), EatCluckin)





function TABEvent(thePlayer)
	if(PlayersEnteredPickup[thePlayer]) then
		local x,y,z = getElementPosition(PlayersEnteredPickup[thePlayer])
		local px,py,pz = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(x, y, z, px, py ,pz)
		if(distance < 2) then
			if(getElementData(PlayersEnteredPickup[thePlayer], "house")) then
				buyHouse(thePlayer, getElementData(PlayersEnteredPickup[thePlayer], "house"))
			end
		end
	end



	if(isElement(PlayersPickups[thePlayer])) then
		local x,y,z = getElementPosition(PlayersPickups[thePlayer])
		local px,py,pz = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(x, y, z, px, py ,pz)
		if(distance < 2) then
			if(getElementData(PlayersPickups[thePlayer], "biz")) then
				buybiz(thePlayer, PlayersPickups[thePlayer])
			else
				if(getElementData(PlayersPickups[thePlayer], "arr")) then
					local arr = fromJSON(getElementData(PlayersPickups[thePlayer], "arr"))
					destroyElement(PlayersPickups[thePlayer])
					AddInventoryItem(thePlayer, arr)
				end
			end
		end
	end
end



local wanktimers = {}
function iznas2(thePlayer, thePed)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		if(thePed) then
			if(getElementType(thePed) == "player" or getElementType(thePed) == "ped") then
				if(isTimer(wanktimers[thePlayer])) then
					outputChatBox("#FF0033Не встает!", thePlayer, 255,255,255,true)
				else
					setElementCollisionsEnabled(thePed, false)
					local x, y, z = getElementPosition(thePlayer)
					local rx,ry,rz = getElementRotation(thePlayer)
					local x2, y2, z2 = getPointInFrontOfPoint(x, y, z, rz+90, 1)
					setElementPosition(thePed, x2, y2, z2)
					setElementRotation(thePed,rx,ry,rz+180, "default", true)
					StartAnimation(thePlayer, "SEX", "SEX_2_Fail_P", 6800, true, false, false, false, true)
					StartAnimation(thePed, "SEX", "SEX_2_Fail_W", 6800, true, false, false, false, true)
					UnBindAllKey(thePlayer)
					UnBindAllKey(thePed)
					Pain(thePlayer)
					Pain(thePed)
					PData[thePlayer]["ActionTimer"] = setTimer(function()
						BindAllKey(thePlayer)
						BindAllKey(thePed)
						Koryachka(thePed)
						setElementCollisionsEnabled(thePed, true)
						if(isPlayerBolezn(thePlayer, "СПИД") or isPlayerBolezn(thePed, "СПИД")) then
							addPlayerBolezn(thePed, "СПИД", 1)
							addPlayerBolezn(thePlayer, "СПИД", 1)
						else
							local randSpid = math.random(1,10)
							if(randSpid == 1) then
								addPlayerBolezn(thePed, "СПИД", 1)
								addPlayerBolezn(thePlayer, "СПИД", 1)
							elseif(randSpid == 2) then
								BloodFoot(thePed, true)
								addPlayerBolezn(thePed, "Порванный анус", 1)
								outputChatBox("Ты порвал анус "..getPlayerName(thePed), thePlayer, 255,255,255,true)
							end
						end

					end, 5800, 1)
					wanktimers[thePlayer] = setTimer(function() end, 1000, 1) -- 240000
				end
			end
		end
	end
end
addEvent("iznas2", true)
addEventHandler("iznas2", getRootElement(), iznas2)



function BloodFoot(thePlayer, state)
	for key,thePlayers in pairs(getElementsByType "player") do
		triggerClientEvent(thePlayers, "bloodfoot", thePlayers, thePlayer, state)
	end
end


function iznas3(thePlayer, thePed)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		if(thePed) then
			if(getElementType(thePed) == "player" or getElementType(thePed) == "ped") then
				if(isTimer(wanktimers[thePlayer])) then
					outputChatBox("#FF0033Не встает!", thePlayer, 255,255,255,true)
				else
					setElementCollisionsEnabled(thePed, false)
					local x, y, z = getElementPosition(thePlayer)
					local rx,ry,rz = getElementRotation(thePlayer)
					local x2, y2, z2 = getPointInFrontOfPoint(x, y, z, rz+90, 1)
					setElementPosition(thePed, x2, y2, z2)
					setElementRotation(thePed,rx,ry,rz+180, "default", true)
					StartAnimation(thePlayer, "SEX", "SEX_3_Fail_P", 6800, true, false, false, false, true)
					StartAnimation(thePed, "SEX", "SEX_3_Fail_W", 6800, true, false, false, false, true)
					UnBindAllKey(thePlayer)
					UnBindAllKey(thePed)
					Pain(thePlayer)
					Pain(thePed)
					PData[thePlayer]["ActionTimer"] = setTimer(function()
						BindAllKey(thePlayer)
						BindAllKey(thePed)
						Koryachka(thePed)
						setElementCollisionsEnabled(thePed, true)
						BloodFoot(thePed, true)
						addPlayerBolezn(thePed, "Порванный анус", 1)
						outputChatBox("Ты порвал анус "..getPlayerName(thePed), thePlayer, 255,255,255,true)
					end, 5800, 1)
					wanktimers[thePlayer] = setTimer(function() end, 1000, 1) -- 240000
				end
			end
		end
	end
end
addEvent("iznas3", true)
addEventHandler("iznas3", getRootElement(), iznas3)



function iznas(thePlayer, thePed)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		if(thePed) then
			if(getElementType(thePed) == "player" or getElementType(thePed) == "ped") then
				if(isTimer(wanktimers[thePlayer])) then
					outputChatBox("#FF0033Не встает!", thePlayer, 255,255,255,true)
				else
					setElementCollisionsEnabled(thePed, false)
					local x, y, z = getElementPosition(thePlayer)
					local rx,ry,rz = getElementRotation(thePlayer)
					local x2, y2, z2 = getPointInFrontOfPoint(x, y, z, rz+90, 1)
					setElementPosition(thePed, x2, y2, z2)
					setElementRotation(thePed,rx,ry,rz+180, "default", true)
					StartAnimation(thePlayer, "SEX", "SEX_1_Cum_P", 6800, true, false, false, false, true)
					StartAnimation(thePed, "SEX", "SEX_1_Cum_W", 6800, true, false, false, false, true)
					UnBindAllKey(thePlayer)
					UnBindAllKey(thePed)
					Pain(thePlayer)
					Pain(thePed)
					PData[thePlayer]["ActionTimer"] = setTimer(function()
						BindAllKey(thePlayer)
						BindAllKey(thePed)
						Koryachka(thePed)
						setElementCollisionsEnabled(thePed, true)
						if(isPlayerBolezn(thePlayer, "СПИД") or isPlayerBolezn(thePed, "СПИД")) then
							addPlayerBolezn(thePed, "СПИД", 1)
							addPlayerBolezn(thePlayer, "СПИД", 1)
						else
							local randSpid = math.random(1,10)
							if(randSpid == 1) then
								addPlayerBolezn(thePed, "СПИД", 1)
								addPlayerBolezn(thePlayer, "СПИД", 1)
							elseif(randSpid == 2) then
								BloodFoot(thePed, true)
								addPlayerBolezn(thePed, "Порванный анус", 1)
								outputChatBox("Ты порвал анус "..getPlayerName(thePed), thePlayer, 255,255,255,true)
							end
						end

					end, 5800, 1)
					wanktimers[thePlayer] = setTimer(function() end, 1000, 1) -- 240000
				end
			end
		end
	end
end
addEvent("iznas", true)
addEventHandler("iznas", getRootElement(), iznas)



function blowjob(thePlayer, thePed)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		if(thePed) then
			if(getElementType(thePed) == "player" or getElementType(thePed) == "ped") then
				if(isTimer(wanktimers[thePlayer])) then
					outputChatBox("#FF0033Не встает!", thePlayer, 255,255,255,true)
				else
					setElementCollisionsEnabled(thePed, false)
					local x, y, z = getElementPosition(thePlayer)
					local rx,ry,rz = getElementRotation(thePlayer)
					local x2, y2, z2 = getPointInFrontOfPoint(x, y, z, rz+90, 1)
					setElementPosition(thePed, x2, y2, z2)
					setElementRotation(thePed,rx,ry,rz+180, "default", true)
					StartAnimation(thePlayer, "BLOWJOBZ", "BJ_STAND_START_P", 6800, true, false, false, false, true)
					StartAnimation(thePed, "BLOWJOBZ", "BJ_STAND_LOOP_W", 6800, true, false, false, false, true)
					UnBindAllKey(thePlayer)
					UnBindAllKey(thePed)
					Pain(thePlayer)
					Pain(thePed)

					PData[thePlayer]["ActionTimer"] = setTimer(function()
						BindAllKey(thePlayer)
						BindAllKey(thePed)
						Koryachka(thePed)
						setElementCollisionsEnabled(thePed, true)
					end, 6800, 1)
					wanktimers[thePlayer] = setTimer(function() end, 1000, 1)
				end
			end
		end
	end
end
addEvent("blowjob", true)
addEventHandler("blowjob", getRootElement(), blowjob)









function butilka(thePlayer, thePed, model)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))

		if(thePlayer ~= thePed) then
			if(getElementHealth(thePed) > 20) then
				return ToolTip(thePlayer, "Игрок должен быть в #CC3300корячке")
			end
		end
		
		
		StartAnimation(thePed, "BLOWJOBZ", "BJ_STAND_LOOP_W", 6800, true, false, false, false, true)
		setElementData(thePed, "BottleAnus", model)
		AddPlayerArmas(thePed, model)
		PData[thePlayer]["ActionTimer"] = setTimer(function()
			Koryachka(thePed)
			RemovePlayerArmas(thePed, model)
			removeElementData(thePed, "BottleAnus")

			local PlayerTeam = getTeamName(getPlayerTeam(thePlayer))
			local PedTeam = getTeamName(getPlayerTeam(thePed))
			if(PlayerTeam == "Военные" and PedTeam == "Уголовники") then
				if(GetDatabaseAccount(thePlayer, "ATUT") == 2) then
					SetTeam(thePlayer, "Мирные жители")
					SetDatabaseAccount(thePlayer, "skin", 48)
					triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 18)
					triggerClientEvent(thePlayer, "RemoveGPSMarker", thePlayer, "Посади заключенного на бутылку")
					SetDatabaseAccount(thePlayer, "ATUT", 3)
					MissionCompleted(thePlayer, "Полиция +", "ОТСЛУЖИЛ")
					Respect(thePlayer, "police", 5)
					outputChatBox("Ты получил военный билет! Теперь ты можешь работать в #4169E1полиции#FFFFFF, вступить в #000000триаду#FFFFFF или #363D5Aколумбийский картель",thePlayer, 255,255,255,true)
					SpawnedAfterChange(thePlayer)
				end
			end
		end, 6800, 1)
	end
end
addEvent("butilka", true)
addEventHandler("butilka", getRootElement(), butilka)





function razd(thePlayer, player2)
	if(not isTimer(PData[thePlayer]["ActionTimer"])) then
		if(player2) then
			if(getElementType(player2) == "player" or getElementType(player2) == "ped") then
				StartAnimation(thePlayer, "BOMBER","BOM_Plant_Crouch_Out", false,false,false,false)
				PData[thePlayer]["ActionTimer"] = setTimer(function()
					local arr = fromJSON(GetDatabaseAccount(thePlayer, "wardrobe"))
					local new = getElementModel(player2)
					if(not arr[new]) then
						arr[new] = 1
					elseif(arr[new] < 999) then
						arr[new]=arr[new]+1
					end
					if(SkinData[new][3] == "Мужчина") then
						SetDatabaseAccount(thePlayer, "wardrobe", toJSON(arr))
						if(getElementType(player2) == "player") then SetDatabaseAccount(player2, "skin", 252) end
						setElementModel(player2, 252)
						setPedWalkingStyle(player2, SkinData[252][1])
					elseif(SkinData[new][3] == "Женщина") then
						SetDatabaseAccount(thePlayer, "wardrobe", toJSON(arr))
						if(getElementType(player2) == "player") then SetDatabaseAccount(player2, "skin", 145) end
						setElementModel(player2, 145)
						setPedWalkingStyle(player2, SkinData[145][1])
					end
				end, 1000, 1)
			end
		end
	end
end
addEvent("razd", true)
addEventHandler("razd", getRootElement(), razd)



function wank(thePlayer, command, h)
	if(isTimer(wanktimers[thePlayer])) then
		outputChatBox("#FF0033Не встает!", thePlayer, 255,255,255,true)
	else
		local x,y,z = getElementPosition(thePlayer)
		if(getDistanceBetweenPoints3D(x, y, z, 351.9, 163.9, 1020.7) < 10) then
			local playeraccount = getPlayerAccount(thePlayer)
			local money = GetDatabaseAccount(thePlayer, "kresp")+GetDatabaseAccount(thePlayer, "ballas")+GetDatabaseAccount(thePlayer, "civilian")+
			GetDatabaseAccount(thePlayer, "grove")+GetDatabaseAccount(thePlayer, "police")+GetDatabaseAccount(thePlayer, "ugol")
			if(money > 0) then
				setTimer(function()
					AddPlayerMoney(thePlayer, money*10, "СПЕРМА СДАНА!")
				end, 7000, 1)
			else
				outputChatBox("Твоя сперма никому не нужна...", thePlayer, 255,255,255, true)
			end
		end

		StartAnimation(thePlayer, "PAULNMAC", "wank_out",false,false,false,false)
		wanktimers[thePlayer] = setTimer(function() end, 240000, 1)
	end
end
addCommandHandler("wank", wank)






function race(thePlayer, command, h)
	if(isTimer(MPTimer)) then
		local YouRacer = false
		for Player, _ in pairs(MPPlayerList) do
			if(Player == thePlayer) then
				YouRacer = true
			end
		end
		if(YouRacer == false) then
			MPPlayerList[thePlayer] = 0
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, SData["RaceArr"][1][1], SData["RaceArr"][1][2], SData["RaceArr"][1][3], "Гонка")
			outputChatBox("* "..getElementData(thePlayer, "color")..getPlayerName(thePlayer).." #FFFFFFприсоединился к гонке!",getRootElement(),255,255,255,true)
			triggerClientEvent(thePlayer, "SetZoneDisplay", thePlayer, "#9b7c52Гоночный турнир")
		end
	else
		outputChatBox("В настоящий момент гонки не проходят", thePlayer, 255, 255, 255, true)
	end
end
addCommandHandler("race", race)






function respawnExplodedVehicle()
	if(isTimer(FuelTimer[source])) then
		killTimer(FuelTimer[source])
	end
	local weapon = getElementData(source, "weapon")
	local killer = getElementData(source, "killer")
	if(weapon and killer) then
		if(WeaponModel[weapon][2]) then
			AddSkill(getPlayerFromName(killer), WeaponModel[weapon][2])
		end
	end

	if(not getElementData(source, "destroy")) then
		if(getElementData(source, "owner")) then
			if(not ReparkEv(source)) then
				local owner = getPlayerFromName(getElementData(source, "owner"))
				local x,y,z = getElementPosition(source)
				local zone = getZoneName(x,y,z, true)
				local park = GetRandomParking(zone)
				if(park) then
					Parkings[park[1]][park[2]][park[3]][1] = source
					local randz = park[7]
					if(math.random(0,1) == 1) then
						randz = randz+180
					end

					setVehicleRespawnPosition(source, park[4], park[5], park[6]+VehicleSystem[getElementModel(source)][1], 0, 0, randz)
					if(owner) then
						triggerClientEvent(owner, "AddGPSMarker", owner, park[4], park[5], park[6], "Забери свой транспорт")
						ToolTip(owner, "Ваш транспорт доставлен на парковку")
					end
				end
			end
		end
		setTimer(respawnVehicle, 10000, 1, source)
	end
end


function GetRandomParking(city)
	if(city == "Red County" or city == "Flint County") then city = "Los Santos"
	elseif(city == "Tierra Robada" or city == "Bone County") then city = "Las Venturas"
	elseif(city == "Unknown" or city == "Whetstone") then city = "San Fierro" end
	if(Parkings[city]) then
		local randpark = {}
		for name, dat in pairs(Parkings[city]) do
			for i, dat2 in pairs(dat) do
				if(not dat2[1]) then
					randpark[#randpark+1] = {city, name, i, dat2[2], dat2[3], dat2[4], dat2[5]}
				end
			end
		end
		if(#randpark > 0) then
			return randpark[math.random(#randpark)]
		end
	end
	return false
end


function respawnVehicleAfterDead()
	removeElementData(source, "Fuel")
	removeElementData(source, "killer")
	removeElementData(source, "weapon")
	if getElementData(source, "i") then setElementInterior(source, getElementData(source, "i")) else setElementInterior(source, 0) end
	if getElementData(source, "d") then setElementDimension(source, getElementData(source, "d")) else setElementDimension(source, 0)  end
	for slot = 0, 5 do
		setVehicleDoorOpenRatio(source, slot, 0)
	end
	if(getElementData(source, "destroy")) then
		destroyElement(source)
	end
end
addEventHandler("onVehicleExplode", getRootElement(), respawnExplodedVehicle)
addEventHandler("onVehicleRespawn", getRootElement(), respawnVehicleAfterDead)



local BikeStadiumPickups = {
"g",-1486.92, 1630.25, 1056.54,
"y",-1486.72, 1641.97, 1060.67,
"y",-1485.11, 1596.46, 1061.33,
"r",-1488.43, 1564.97, 1056.63,
"g",-1466.76, 1581.16, 1054.72,
"y",-1466.51, 1596.21, 1056.70,
"g",-1462.08, 1622.39, 1054.41,
"g",-1461.83, 1635.99, 1054.41,
"y",-1453.67, 1635.78, 1056.42,
"y",-1453.90, 1628.47, 1054.41,
"r",-1454.02, 1620.89, 1056.42,
"r",-1446.53, 1620.97, 1054.41,
"g",-1416.65, 1606.79, 1055.32,
"y",-1409.12, 1617.69, 1055.32,
"r",-1390.24, 1623.65, 1055.32,
"g",-1384.55, 1603.49, 1053.71,
"g",-1378.88, 1610.33, 1053.71,
"g",-1371.29, 1623.02, 1054.81,
"r",-1372.50, 1631.84, 1055.55,
"g",-1362.46, 1612.83, 1055.46,
"y",-1360.01, 1638.50, 1056.21,
"g",-1371.38, 1638.84, 1053.41,
"r",-1403.92, 1645.57, 1071.03,
"g",-1388.59, 1571.87, 1053.53,
"g",-1373.78, 1562.30, 1059.53,
"g",-1354.83, 1584.96, 1058.47,
"g",-1354.83, 1610.70, 1054.53,
"g",-1456.99, 1648.68, 1054.41,
"g",-1443.41, 1648.54, 1054.41,
"g",-1431.34, 1597.96, 1054.36,
"g",-1420.67, 1597.97, 1054.16,
"g",-1434.54, 1578.21, 1054.42,
"g",-1427.82, 1584.00, 1054.43,
"y",-1430.88, 1580.87, 1055.71,
"g",-1426.79, 1568.77, 1058.44,
"y",-1401.74, 1568.74, 1054.62,
"g",-1408.25, 1585.43, 1055.75,
"g",-1408.17, 1593.39, 1055.79,
"r",-1451.70, 1570.27, 1059.34,
"y",-1457.84, 1575.85, 1056.20}


function Createkickstart()
	for i = 1, #BikeStadiumPickups/4 do
		local p = createMarker(BikeStadiumPickups[(i*4)-2], BikeStadiumPickups[(i*4)-1], BikeStadiumPickups[(i*4)], "corona",1)
		if(BikeStadiumPickups[(i*4)-3] == "r") then
			setMarkerColor(p, 255,0,0,255)
		elseif(BikeStadiumPickups[(i*4)-3] == "y") then
			setMarkerColor(p, 255,255,0,255)
		elseif(BikeStadiumPickups[(i*4)-3] == "g") then
			setMarkerColor(p, 0,255,0,255)
		end
		setElementInterior(p, 14)
		setElementData(p, "type", "kickstart")
	end
end



function FireVehicle(theVehicle, weapon, loss, tyre)
	setElementData(theVehicle, "killer", getPlayerName(source))
	setElementData(theVehicle, "weapon", weapon)
	setElementHealth(theVehicle, getElementHealth(theVehicle)-loss)
	
	if(tyre) then
		local Tires = {[1] = false, [2] = false, [3] = false, [4] = false}
		Tires[1], Tires[2], Tires[3], Tires[4] = getVehicleWheelStates(theVehicle)
		Tires[tyre+1] = 1
		setVehicleWheelStates(theVehicle, Tires[1], Tires[2], Tires[3], Tires[4])
	end
end
addEvent("FireVehicle", true)
addEventHandler("FireVehicle", getRootElement(), FireVehicle)


local AllFires = {}
function CreateFire(arr)
	arr = fromJSON(arr)
	local x, y, z = false
	for v, k in pairs(arr) do
		x, y, z = k[1], k[2], k[3]
		local fireId = #AllFires+1
		AllFires[fireId] = {}
		AllFires[fireId]["obj"] = createObject(1362, k[1],k[2],k[3]-0.6)
		setElementData(AllFires[fireId]["obj"], "fireid", fireId)
		
		AllFires[fireId]["mar"] = createMarker(k[1], k[2], k[3], "checkpoint", 1, 0,0,0,0)
		setElementVisibleTo(AllFires[fireId]["mar"], root, false)
		setElementData(AllFires[fireId]["mar"], "type", "FIRE")

		AllFires[fireId]["timer"] = setTimer(function(obj, mar, ped)
			destroyElement(obj)
			destroyElement(mar)
		end, 120000, 1, AllFires[fireId]["obj"], AllFires[fireId]["mar"]) -- 120000
	end
	if(x) then
		FireTruck(x, y, z, 0, 0)
	end
end
addEvent("CreateFire", true)
addEventHandler("CreateFire", getRootElement(), CreateFire)


function RemoveFire(thePlayer, fire)
	if(isElement(fire)) then
		local fireId = getElementData(fire, "fireid")
		killTimer(AllFires[fireId]["timer"])
		destroyElement(AllFires[fireId]["obj"])
		destroyElement(AllFires[fireId]["mar"])
	end
end
addEvent("RemoveFire", true)
addEventHandler("RemoveFire", getRootElement(), RemoveFire)



function AddSkill(thePlayer, skill, count)
	if(not count) then count = 1 end
	if(skill) then
		skill = tostring(skill)
		local arr = fromJSON(GetDatabaseAccount(thePlayer, "skill"))
		if(not arr[skill]) then arr[skill] = 0 end
		if(arr[skill] == 1000) then return true end
		arr[skill] = arr[skill]+count
		if(arr[skill] > 1000) then arr[skill] = 1000
		elseif(arr[skill] < 0) then arr[skill] = 0 end
		SetDatabaseAccount(thePlayer, "skill", toJSON(arr))
		setPedStat(thePlayer, skill, arr[skill])
		for i = 0, ReversePlus(count) do
			if(isint((arr[skill]+i)/10)) then
				triggerClientEvent(thePlayer, "RespectMessage", thePlayer, skill, count)
				break
			end
		end
	end
end
addEvent("AddSkill", true)
addEventHandler("AddSkill", getRootElement(), AddSkill)


function ReversePlus(int)
	if(int < 0) then return int-int-int
	else return int end
end


function playerDamage(attacker, weapon, bodypart, loss)
	if(attacker) then
		if(getElementType(attacker) == "player") then
			local PTeam = getTeamName(getPlayerTeam(source))
			local KTeam = getTeamName(getPlayerTeam(attacker))
			if(getTeamGroup(PTeam) == "Официалы" and KTeam ~= "Уголовники") then
				WantedLevel(attacker, 0.1)
			end
			if(weapon >= 0 and weapon <= 9) then
				AddSkill(attacker, 177)
				if(weapon == 6) then
					local rand = math.random(4)
					if(rand == 4) then
						setPedHeadless(source, true)
						killPed(source, attacker, weapon, 9)
					end
				end
			end
		end
	end
	
	if(not PData[source]["DeathMatch"]) then
		if(getElementHealth(source) < 20) then
			Koryachka(source)
			SetControls(source, "crack", {["fire"] = true, ["action"] = true, ["jump"] = true})
		else
			SetControls(source, "crack", {["fire"] = false, ["action"] = false, ["jump"] = false})
		end
	end
	
	if(bodypart == 9) then
		if(getElementType(attacker) == "player") then -- Боты не ставят хеды
			setPedHeadless(source, true)
			killPed(source, attacker, weapon, 9)
		end
	end


	if(weapon == 49) then
		if(loss) then
			if(loss*11 > 100) then
				killPed(source, getVehicleOccupant(attacker), weapon, bodypart, false)
			end
		end
	end
end
addEventHandler("onPlayerDamage", getRootElement (), playerDamage)








--{Название, минимальный вес, максимальный вес}
local Fishes = {
	{"Амурская щука", 567, 39992},
	{"Амурский осётр", 13413,  199999},
	{"Амурский сазан", 66,  8000},
	{"Амурский сом", 1045,  30000},
	{"Анчоус", 11,  300},
	{"Арапайма",100, 449983},
	{"Армадо", 100, 8933},
	{"Ауха", 100, 10999},
	{"Барбадо", 54,  7934},
	{"Белоглазка", 12, 1569},
	{"Белорыбица", 4588,  39997},
	{"Белуга", 100, 3184309},
	{"Белый амур",100, 59978},
	{"Бёрш", 100, 9992},
	{"Бестер", 439,  30000},
	{"Бикуда", 51,  8995},
	{"Быстрянка", 1, 100},
	{"Бычок-кругляк", 11, 262},
	{"Верховка", 1, 52},
	{"Верхогляд", 136, 14000},
	{"Веслонос", 51,  179983},
	{"Вобла", 15, 1998},
	{"Волжская сельдь", 16,  1499},
	{"Вырезуб", 100, 7989},
	{"Вьюн", 1, 198},
	{"Голавль", 149,  10000},
	{"Голубой сомик", 100, 70000},
	{"Гольян самец", 1, 52},
	{"Гольян самка", 1, 52},
	{"Густера", 53, 2500},
	{"Елец", 18, 1574},
	{"Ёрш", 11, 398},
	{"Желтощёк", 100, 70000},
	{"Жерех", 232, 29999},
	{"Змееголов", 112, 8997},
	{"Золотой карась", 60,  5986},
	{"Зунгаро", 10000, 99947},
	{"Калуга", 10098, 1496862},
	{"Карп", 100, 70000},
	{"Карпиодес", 56,  6954},
	{"Кета самец", 113, 19966},
	{"Кета самка", 105, 19999},
	{"Кижуч самец", 185,  15999},
	{"Кижуч самка", 143,  15943},
	{"Корюшка", 11,  600},
	{"Краснопёрка", 51,  3000},
	{"Красный паку", 4247,  24999},
	{"Кумжа", 1724,  24999},
	{"Кунджа", 1423,  16998},
	{"Ленок", 100, 8000},
	{"Лещ", 100, 16991},
	{"Линь", 343,  10000},
	{"Маскинонг", 745, 31995},
	{"Микижа", 143, 25971},
	{"Налим", 100, 36000},
	{"Нельма", 1007, 54999},
	{"Нерка", 133, 13999},
	{"Окунь", 57, 7000},
	{"Омуль", 280, 3487},
	{"Оскар", 12, 1600},
	{"Остронос", 12, 1000},
	{"Пайяра", 11691, 29967},
	{"Паку-каранха", 100, 19964},
	{"Пескарь", 11, 262},
	{"Пинтадо", 100, 89995},
	{"Пирайба", 100, 199935},
	{"Пиранья", 51, 3999},
	{"Пират-окунь", 1, 100},
	{"Плотва", 91, 3000},
	{"Подуст", 96, 3500},
	{"Рыбец", 76, 2988},
	{"Ряпушка", 16, 1500},
	{"Сазан", 132, 39977},
	{"Севрюга", 383, 79996},
	{"Сёмга", 2368, 49975},
	{"Сиг", 59, 6000},
	{"Сингиль", 16, 1995},
	{"Синец", 101, 2497},
	{"Снеток", 2, 50},
	{"Сом", 1828, 499876},
	{"Стерлядь", 100, 18000},
	{"Судак", 370, 20000},
	{"Таймень", 3083, 109999},
	{"Тамбакуи", 2080, 49993},
	{"Толстолобик", 143, 50000},
	{"Трайрао", 385, 20000},
	{"Уклейка", 11, 299},
	{"Усатый голец", 1, 157},
	{"Усач", 122, 25000},
	{"Хариус", 60, 7000},
	{"Чавыча", 2872, 70000},
	{"Чебак", 289, 3498},
	{"Чехонь", 14, 3500},
	{"Чукучан", 161, 3496},
	{"Шип", 8888, 130000},
	{"Щиповка", 1, 52},
	{"Щука", 113, 50000},
	{"Язь", 54, 9999},
	{"Реликвия", 1, 1000},
	{"Подкова", 1, 1000},
	{"Ракушка", 1, 50},
	{"Кошелек", 1,10000},
	{"Черепаха", 4300, 150000},
	{"Акула", 5600, 136000},
	{"Дельфин", 3200, 89000}
}

function startfish(thePlayer, lx,ly,lz)
	if(not isTimer(PData[thePlayer]["FishRodTimer2"])) then
		local GLUB = math.round(lz, 0)
		setElementFrozen(thePlayer, true)
		local x, y, z = getElementPosition (thePlayer)
		setElementData(thePlayer, "fishpos", toJSON({lx,ly,lz}))
		PData[thePlayer]["FishRodTimer2"] = setTimer(function() StopFish(thePlayer) end, 120000, 1) -- лимит времени
		PData[thePlayer]["FishRodTimer"] = setTimer(function()
			local rand = math.random(1,21)
			if(rand == 5) then
				StartAnimation(thePlayer, "SWORD", "sword_block",false,false,false,false)
				PData[thePlayer]["FishRodTimer3"] = setTimer(function()	StartAnimation(thePlayer, "SWORD", "sword_IDLE") end, 400, 1)
				local FishRand = math.random(#Fishes)

				local FishName = Fishes[FishRand][1]
				local minFish = Fishes[FishRand][2]
				local maxFish = Fishes[FishRand][3]
				local randFishVes = math.random(minFish,maxFish/2)
				local RandSkillVes = math.random(0, getPedStat(thePlayer, 157))
				local VES = randFishVes+(randFishVes*math.floor((RandSkillVes/1000)))--Множитель от навыка x2
				local Qual = math.floor((VES/maxFish)*1000)
				AddSkill(thePlayer, 157)

				local FishHones = xmlNodeGetChildren(FishesNode)
				local FishNode = xmlFindChild(FishesNode, string.gsub(FishName, " ", ""), 0)
				if(FishNode) then
					if(tonumber(xmlNodeGetValue(FishNode)) < VES) then
						outputChatBox("#CC9966"..getPlayerName(thePlayer).."#FFFFFF установил новый #FF0000рекорд#FFFFFF поймав #FFFFCC"..FishName.."#FFFFFF весом "..FishVes(VES, maxFish), getRootElement(), 255,255,255, true)
						xmlNodeSetValue(FishNode, VES)
					end
				else
					local NewNode = xmlCreateChild(FishesNode, string.gsub(FishName, " ", ""))
					xmlNodeSetValue(NewNode, VES)
				end
				if(FishName == "Кошелек") then
					AddPlayerMoney(thePlayer, VES, "ТЫ ПОЙМАЛ КОШЕЛЕК!")
				elseif(FishName == "Реликвия" or FishName == "Подкова" or FishName == "Ракушка") then
					AddInventoryItem(thePlayer, {["txd"] = FishName, ["name"] = FishName, ["quality"] = Qual})
				elseif(FishName == "Черепаха" or FishName == "Акула" or FishName == "Дельфин") then
					AddInventoryItem(thePlayer, {["txd"] = FishName, ["name"] = FishName, ["quality"] = Qual, ["mass"] = VES})
				else
					AddInventoryItem(thePlayer, {["txd"] = "Рыба", ["name"] = FishName, ["quality"] = Qual, ["mass"] = VES, ["cost"] = math.floor((VES/maxFish)*2500)})
				end
			end
		end, 1000, 0)
		setTimer(function()
			StartAnimation(thePlayer, "SWORD", "sword_IDLE")
		end, 50, 1)
	end
end
addEvent("startfish", true)
addEventHandler("startfish", getRootElement(), startfish)






function ChangePlayerPassword(thePlayer, command, oldpass, newpass)
	if(CheckDatabasePlayer) then
		local password_check = GetDatabaseAccount(thePlayer, "password")
		if(password_check == md5(oldpass)) then
			if (string.len(newpass)>=1) then
				SetDatabaseAccount(thePlayer, "password", md5(newpass))
				outputChatBox("Пароль удачно изменен!", thePlayer)
			else
				outputChatBox("Новый пароль должен иметь не менее 1 символа!", thePlayer)
			end
		else
			outputChatBox("Старый пароль неправильный!", thePlayer)
		end
	end
end
addCommandHandler("changepass", ChangePlayerPassword)




function StopFish(thePlayer, dead)
	triggerClientEvent(thePlayer, "FishStarted", thePlayer)
	removeElementData(thePlayer, "fishpos")
	if(isTimer(PData[thePlayer]["FishRodTimer"])) then
		setElementFrozen(thePlayer, false)
		killTimer(PData[thePlayer]["FishRodTimer"])
		killTimer(PData[thePlayer]["FishRodTimer2"])
	end
	if(not dead) then
		StartAnimation(thePlayer, nil,nil)
	end
end
addEvent("StopFish", true)
addEventHandler("StopFish", getRootElement(), StopFish)




function FishVes(ves, maxFish)
	local Quality = ves/maxFish*255
	if(ves >= 1000) then
		if(Quality > 240) then
			return "#F4C712(зачетная) "..(ves/1000).." кг"
		else
			return RGBToHex(255-Quality,0+Quality,0)..(ves/1000).." кг"
		end

	else
		if(Quality > 240) then
			return "#F4C712(зачетная) "..ves.." г"
		else
			return RGBToHex(255-Quality,0+Quality,0)..ves.." г"
		end
	end
end

function Respect(thePlayer, Group, count)
	if(Group and count) then
		count = count*5 -- Множитель для ускорения...
		local Total = GetDatabaseAccount(thePlayer, Group)+(count)
		if(Total > 1000) then Total = 1000
		elseif(Total < -1000) then Total = -1000 end
		SetDatabaseAccount(thePlayer, Group, Total)
		local GroupName=""
		local countName=""
		if(Group == "ballas") then GroupName="Баллас" end
		if(Group == "vagos") then GroupName="Вагос" end
		if(Group == "civilian") then GroupName="Мирные жители" end
		if(Group == "grove") then GroupName="Гроув-стрит" end
		if(Group == "police") then GroupName="Полиция" end
		if(Group == "ugol") then GroupName="Уголовники" end

		triggerClientEvent(thePlayer, "RespectMessage", thePlayer, GroupName, count)
	end

	setElementData(thePlayer, "civilian", GetDatabaseAccount(thePlayer, "civilian"))
	setElementData(thePlayer, "vagos", GetDatabaseAccount(thePlayer, "vagos"))
	setElementData(thePlayer, "police", GetDatabaseAccount(thePlayer, "police"))
	setElementData(thePlayer, "grove", GetDatabaseAccount(thePlayer, "grove"))
	setElementData(thePlayer, "ugol", GetDatabaseAccount(thePlayer, "ugol"))
	setElementData(thePlayer, "ballas", GetDatabaseAccount(thePlayer, "ballas"))
end
addEvent("Respect", true)
addEventHandler("Respect", getRootElement(), Respect)



function AddInventoryItem(thePlayer, item, x, y)
	triggerClientEvent(thePlayer, "AddInventoryItem", thePlayer, "Инвентарь", item, x, y)
end
addEvent("AddInventoryItem", true)
addEventHandler("AddInventoryItem", getRootElement(), AddInventoryItem)




function RemoveInventoryItemCount(thePlayer, x,y)
	triggerClientEvent(thePlayer, "RemoveInventoryItemCount", thePlayer, x,y)
end



function GetPlayerMoney(thePlayer)
	local arr = fromJSON(GetDatabaseAccount(thePlayer, "inv"))
	local count = 0
	for x, dat in pairs(arr) do
		for y, v in pairs(dat) do
			if(v["name"]) then
				if(v["name"] == "Деньги") then
					count = count+v["count"]
				end
			end
		end
	end
	return count
end




function MissionCompleted(thePlayer, count, mission, target, cinema)
	triggerClientEvent(thePlayer, "MissionCompleted", thePlayer, mission, count, target, cinema)
end


function HelpMessage(thePlayer, text)
	triggerClientEvent(thePlayer, "helpmessageEvent", thePlayer, text)
end


function AddPlayerMoney(thePlayer, count, mission)
	if(count < 0) then
		if(GetPlayerMoney(thePlayer)+count < 0) then
			local c = count+GetPlayerMoney(thePlayer)
			ToolTip(thePlayer, "Необходимо еще "..COLOR["DOLLAR"]["HEX"].."$"..c-c-c)
			cancelEvent()
			return false
		end
	end

	givePlayerMoney(thePlayer, count)
	AddInventoryItem(thePlayer, {["txd"] = "Деньги", ["name"] = "Деньги", ["count"] = count})
	if(mission) then
		MissionCompleted(thePlayer, count, mission)
		triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 6)
	end
	return true
end
addEvent("AddPlayerMoney", true)
addEventHandler("AddPlayerMoney", getRootElement(), AddPlayerMoney)









local sp40 = createMarker(-1420.7, 2583.8, 55, "corona", 4, 0, 0, 0, 0)
setElementData(sp40, "type", "SPRAY")
setElementData(sp40, "id", 40)
setElementData(sp40, "rz", 0)
local sp41 = createMarker(-99.8, 1117.8, 19, "corona", 4, 0, 0, 0, 0)
setElementData(sp41, "type", "SPRAY")
setElementData(sp41, "id", 41)
setElementData(sp41, "rz", 180)
local sp8 = createMarker(2064.8, -1831.2, 12.5, "corona", 4, 0, 0, 0, 0)
setElementData(sp8, "type", "SPRAY")
setElementData(sp8, "id", 8)
setElementData(sp8, "rz", 90)
local sp11 = createMarker(1024.9, -1023.9, 31, "corona", 4, 0, 0, 0, 0)
setElementData(sp11, "type", "SPRAY")
setElementData(sp11, "id", 11)
setElementData(sp11, "rz", 180)
local sp12 = createMarker(487.6, -1739.8, 10, "corona", 4, 0, 0, 0, 0)
setElementData(sp12, "type", "SPRAY")
setElementData(sp12, "id", 12)
setElementData(sp12, "rz", 0)
local sp19 = createMarker(-1904.5, 283.2, 40, "corona", 4, 0, 0, 0, 0)
setElementData(sp19, "type", "SPRAY")
setElementData(sp19, "id", 19)
setElementData(sp19, "rz", 180)
local sp27 = createMarker(-2425.6, 1021.6, 49, "corona", 4, 0, 0, 0, 0)
setElementData(sp27, "type", "SPRAY")
setElementData(sp27, "id", 27)
setElementData(sp27, "rz", 0)
local sp36 = createMarker(1974.2, 2162.2, 10, "corona", 4, 0, 0, 0, 0)
setElementData(sp36, "type", "SPRAY")
setElementData(sp36, "id", 36)
setElementData(sp36, "rz", 270)
local sp46 = createMarker(720.2, -456.9, 15, "corona", 4, 0, 0, 0, 0)
setElementData(sp46, "type", "SPRAY")
setElementData(sp46, "id", 46)
setElementData(sp46, "rz", 180)


--setElementData(createMarker(-220.5, 2619.3, 61.8, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")

setElementData(createMarker(2644.7, -2044, 12, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")
setElementData(createMarker(1041.5, -1015.9, 31, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")
setElementData(createMarker(-1935.7, 246.9, 33, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")
setElementData(createMarker(2386.7, 1052, 9.8, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")
setElementData(createMarker(-2721.7, 217.7, 3.4, "corona", 4, 0, 0, 0, 0), "type", "RVMarker")

setElementData(createColCuboid(-1334.6, 2665, 49.1, 15.0, 25.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(596.9, 1671.4, 6, 40.0, 40.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-740.8, 2741, 46, 10.0, 10.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(59.6, 1212.5, 17.8, 20.0, 10.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-1484.1, 1856, 31.6, 25.0, 20.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-1614.5, -2726.9, 47.7, 20.0, 25.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(1936.3, -1784.5, 12.4, 10.0, 20.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(1377.2, 455.5, 19, 15.0, 15.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(994.3, -943.5, 41.2, 20.0, 13.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(652.6, -576, 15.3, 10.0, 20.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-2251.2, -2566.2, 30.9, 15.0, 10.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-102.9, -1178.7, 1.4, 25.0, 20.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-2032.1, 148, 27.8, 13.0, 15.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-2415.4, 960.9, 44.3, 10.0, 30.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-1703.5, 402.2, 6.2, 40.0, 30.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(2193.8, 2464.6, 9.8, 20.0, 20.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(2629.1, 1096.1, 9.8, 25.0, 25.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(2135.9, 2737.4, 9.8, 25.0, 25.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(2104, 909.4, 9.8, 22.0, 22.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(1583.8, 2189.4, 9.8, 25.0, 25.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(229.5, 2529.1, 15.8, 30.0, 30.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(1769, -2474.4, 12.6, 50.0, 50.0, 5.0), "type", "PetrolFuelCol")
setElementData(createColCuboid(-1299.6, -33.4, 13.1, 50.0, 50.0, 5.0), "type", "PetrolFuelCol")


setElementData(createMarker(-2052.5, 161.9, 27.2, "cylinder", 4, 99, 148, 222, 70), "type", "siren")


setElementData(createMarker(2410.7, -1426, 23, "cylinder", 4, 99, 148, 222, 70), "type", "recyclels")



function SaveTrunk(theVehicle, arr)
	setElementData(theVehicle, "trunk", arr)
	if(getElementData(theVehicle, "x")) then
		for i,node in ipairs(xmlNodeGetChildren(CarNode)) do
			if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
				if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
					xmlNodeSetAttribute(node, "trunk", arr)
				end
			end
		end
	end
end
addEvent("SaveTrunk", true)
addEventHandler("SaveTrunk", getRootElement(), SaveTrunk)










function TrunkOpen(thePlayer, theVehicle)
	local AlreadyUsed = false
	for _, dat in pairs(SData["TrunkUsed"]) do
		if(dat == theVehicle) then
			AlreadyUsed = true
		end
	end

	if(not AlreadyUsed) then
		if(getVehicleDoorOpenRatio(theVehicle, 1) == 0) then
			setVehicleDoorOpenRatio(theVehicle, 1, 1, 200)
		end
		SData["TrunkUsed"][thePlayer] = theVehicle

		triggerClientEvent(thePlayer, "TrunkWindow", thePlayer, theVehicle)
	else
		ToolTip(thePlayer, "Багажник уже кто-то использует!")
	end
end
addEvent("TrunkOpen", true)
addEventHandler("TrunkOpen", getRootElement(), TrunkOpen)



function TrunkClose(thePlayer)
	if(getVehicleDoorOpenRatio(SData["TrunkUsed"][thePlayer], 1) == 1) then
		setVehicleDoorOpenRatio(SData["TrunkUsed"][thePlayer], 1, 0, 200)
	end
	SData["TrunkUsed"][thePlayer] = nil
end
addEvent("TrunkClose", true)
addEventHandler("TrunkClose", getRootElement(), TrunkClose)





function SyncTime(thePlayer)
	local h,m = getTime()
	triggerClientEvent(thePlayer, "normalspeed", thePlayer, h, m, getWeather())
	triggerClientEvent(thePlayer, "GameSky", thePlayer)
end
addEvent("SyncTime", true)
addEventHandler("SyncTime", getRootElement(), SyncTime)




function turnEngineOff(theVehicle, leftSeat, jackerPlayer, unbindkey)
	if(getElementType(source) == "player") then
		if(not unbindkey) then
			UnBindAllVehicleKey(source)
			if(isTimer(FuelTimer[theVehicle])) then
				killTimer(FuelTimer[theVehicle])
			end
		end

		if(SData["VehAccData"][source]) then
			AccelerationDown(source)
		end

		if leftSeat == 0 then
			if(GetVehicleType(getElementModel(theVehicle)) ~= "BMX" and GetVehicleType(getElementModel(theVehicle)) ~= "Train") then
				setVehicleEngineState(theVehicle, false)
				benztimer[theVehicle] = nil
			end
		end
		if(source) then
			if(getElementModel(theVehicle) == 515 or getElementModel(theVehicle) == 514 or getElementModel(theVehicle) == 403) then
				if(isElement(TruckMarker[source])) then
					DestroyTruckMarker(source)
				end
			end
		end
	end
end
addEventHandler("onPlayerVehicleExit", getRootElement(), turnEngineOff)




function turnEngineOn(theVehicle, leftSeat, jackerPlayer, unbindkey)
	--setTrainDerailable(theVehicle, false)
	if(getElementType(source) == "player") then
		if(not theVehicle) then return false end
		PData[source]["LastVehicle"] = theVehicle -- В случай взрыва автомобиля, получаем информацию из этой переменной о атакующем
		if(not unbindkey) then
			BindVehicleKey(source)
		end
		if(getElementModel(theVehicle) == 582) then
			if(leftSeat == 2 or leftSeat == 3) then
				outputChatBox("Ты в #FF0033прямом эфире!", source, 255, 255, 255, true)
			end
		end

		if leftSeat == 0 then
			CheckSiren(theVehicle, source)
			if(GetVehicleType(getElementModel(theVehicle)) ~= "BMX" and GetVehicleType(getElementModel(theVehicle)) ~= "Train") then
				if(not getElementData(theVehicle, "Fuel")) then
					setElementData(theVehicle, "Fuel", 25)
				end

				if(getElementData(theVehicle, "Fuel") > 0) then
					benztimer[theVehicle] = true
					setVehicleEngineState(theVehicle, true)
				else
					setVehicleEngineState(theVehicle, false)
				end
			end
		end


		if(getElementModel(theVehicle) == 515 or getElementModel(theVehicle) == 514 or getElementModel(theVehicle) == 403) then
			if(leftSeat == 0) then
				local trailer = getVehicleTowedByVehicle(theVehicle)
				if(trailer) then
					CreateTruckMarker(source, getElementData(trailer, "x"), getElementData(trailer, "y"), getElementData(trailer, "z"))
				end
			end
		end


		if(getElementData(theVehicle, "type")) then
			if(getElementData(theVehicle, "type") == "jobtruck") then
				CreateTruckMarker(source, getElementData(theVehicle, "x"), getElementData(theVehicle, "y"), getElementData(theVehicle, "z"))
			end
		end
	end
end
addEventHandler("onPlayerVehicleEnter", getRootElement(), turnEngineOn)






function CreateTruckMarker(thePlayer, x, y, z)
	if(isElement(TruckMarker[thePlayer])) then
		DestroyTruckMarker(thePlayer)
	end
	TruckMarker[thePlayer] = createMarker(x, y, z, "checkpoint", 10, 0, 0, 0, 0, thePlayer)
	setElementData(TruckMarker[thePlayer], "type", "TruckMarker")
	setElementData(TruckMarker[thePlayer], "player", getPlayerName(thePlayer))
	HelpMessage(thePlayer, "#FFFFFFОтвези груз на #FF0000красный маркер#FFFFFF\nчтобы получить #32CD32вознаграждение")
	triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, x, y, z, "Отвези груз")
end



function RaceFinish(thePlayer, times)
	--triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 7)
	racePlayerFinish[#racePlayerFinish+1] = getPlayerName(thePlayer)
	times = tonumber(times)

	local besttime = false
	local FishNode = xmlFindChild(FishesNode, SData["RaceName"], 0)
	if(FishNode) then
		besttime = tonumber(xmlNodeGetValue(FishNode))
	else
		FishNode = xmlCreateChild(FishesNode, SData["RaceName"])
		xmlNodeSetValue(FishNode, times)
		besttime = times
	end


	local seconds = (times)/1000
	local hours = math.floor(seconds/3600)
	local mins = math.floor(seconds/60 - (hours*60))
	local secs = math.floor(seconds - hours*3600 - mins *60)
	local msec = math.floor(((times)-(secs*1000)-(mins*60000)-(hours*3600000))/10)


	if(times <= besttime) then
		xmlNodeSetValue(FishNode, times)
		outputChatBox("#CC9966"..getPlayerName(thePlayer).."#FFFFFF установил новый #FF0000рекорд#FFFFFF на трассе #FFFFCC"..SData["RaceName"]:gsub('_', ' ').." #FFFFFF"..string.format("%02.f", mins)..":"..string.format("%02.f", secs)..":"..string.format("%02.f", msec), getRootElement(), 255,255,255, true)
	end



	if(#racePlayerFinish == 1) then
		killTimer(raceGlobalTimer)
		AddPlayerMoney(getPlayerFromName(racePlayerFinish[1]), raceMoney(SData["RaceArr"]), "МИССИЯ ВЫПОЛНЕНА!")
		for Player, _ in pairs(MPPlayerList) do
			if(isElement(Player)) then
				outputChatBox("#CC9966"..racePlayerFinish[1].."#FFFFFF Пришел на финиш первым! Гонка закончится через 30 секунд.", Player, 255,255,255,true)
			end
		end
		local EndRaceTimeout = 30
		EndRaceInfoTimer = setTimer(function()
			if(EndRaceTimeout == 0) then
				endRace()
			else
				for Player, _ in pairs(MPPlayerList) do
					if(isElement(Player)) then
						HelpMessage(Player, "Завершение гонки через "..EndRaceTimeout)
					end
				end
			end
			EndRaceTimeout = EndRaceTimeout-1
		end, 1000, 31)
		triggerClientEvent(thePlayer, "EndRace", thePlayer, "Выиграл!", besttime)

		RacePriceGeneration(thePlayer)
		RacePriceGeneration(thePlayer)
		RacePriceGeneration(thePlayer)
		MPPlayerList[thePlayer] = nil
	elseif(#racePlayerFinish == 2) then
		AddPlayerMoney(getPlayerFromName(racePlayerFinish[2]), math.floor(raceMoney(SData["RaceArr"])/2), "МИССИЯ ВЫПОЛНЕНА!")
		triggerClientEvent(thePlayer, "EndRace", thePlayer, "Второй", besttime)
		RacePriceGeneration(thePlayer)
		RacePriceGeneration(thePlayer)
		MPPlayerList[thePlayer] = nil
	elseif(#racePlayerFinish == 3) then
		AddPlayerMoney(getPlayerFromName(racePlayerFinish[3]), math.floor(raceMoney(SData["RaceArr"])/3), "МИССИЯ ВЫПОЛНЕНА!")
		triggerClientEvent(thePlayer, "EndRace", thePlayer, "Третий", besttime)
		RacePriceGeneration(thePlayer)
		MPPlayerList[thePlayer] = nil
	else
		triggerClientEvent(thePlayer, "EndRace", thePlayer, "Проиграл!", besttime)
	end
end
addEvent("RaceFinish", true)
addEventHandler("RaceFinish", getRootElement(), RaceFinish)









function RacePriceGeneration(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	local zone = getZoneName(x,y,z,true)
	local Prices = math.random(1,50)
	if(Prices == 1) then
		local park = GetRandomParking(zone)
		if(park) then
			local RacePrice = SData["PriceAuto"][math.random(1, #SData["PriceAuto"])]
			local v = CreateVehicle(RacePrice, park[4], park[5], park[6]+VehicleSystem[RacePrice][1], 0,0,park[7], getPlayerName(thePlayer))

			Parkings[park[1]][park[2]][park[3]][1] = v
			setElementData(v, "owner", getPlayerName(thePlayer))
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, park[4], park[5], park[6], "Приз")
			outputChatBox("Забери свой приз на красном маркере!", thePlayer, 255,255,255,true)
		end
	else
		--[[for i ,v in pairs(VCompVehicleTypes["Automobile"]) do
			local parts = VCompVehicleTypes[i]
			AddPlayerVehiclePart(thePlayer, v[1], v[2])
			outputChatBox("Ты выиграл #FFFFFF"..v[1].." "..v[2], thePlayer, math.random(255),math.random(255),math.random(255),true)

		end--]]
		local parts = VCompVehicleTypes["Automobile"][math.random(#VCompVehicleTypes["Automobile"])]
		AddPlayerVehiclePart(thePlayer, parts[1], parts[2])
		outputChatBox("Ты выиграл #FFFFFF"..parts[1].." "..parts[2], thePlayer, math.random(255),math.random(255),math.random(255),true)
	end
end



function raceMoney(arr)
	local money = 0
	for i, _ in pairs(arr) do
		if(arr[i+1]) then
			money = money+getDistanceBetweenPoints3D(arr[i][1], arr[i][2], arr[i][3], arr[i+1][1], arr[i+1][2], arr[i+1][3])
		end
	end
	return math.floor(money*5)
end



function displayVehicleLoss(loss)
	toggleVehicleRespawn(source, true)
	setVehicleIdleRespawnDelay(source, 300000)
	local vehh = getVehicleHandling(source)
	local occupants = getVehicleOccupants(source) or {}
	local passagers = 0
	local damage = loss/(vehh["mass"]/100)
	for seat, occupant in pairs(occupants) do
		if(damage >= 5) then
			setElementHealth(occupant, getElementHealth(occupant)-damage)
			Pain(occupant)
		end
		passagers = passagers+1
	end
	thePlayer = getVehicleOccupant(source, 0)
	if thePlayer then
		triggerClientEvent(thePlayer, "driftCarCrashed", root, source)
	end

	if(passagers == 0) then
		CheckSiren(source)
	end
end
addEventHandler("onVehicleDamage", getRootElement(), displayVehicleLoss)


function Pain(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	local rand = math.random(0,100)
	for key,thePlayers in pairs(getElementsByType "player") do
		triggerClientEvent(thePlayers, "PlaySFX3DforAll", thePlayers, "pain_a", 2, rand,x,y,z, false)
	end
end


local VehicleSirenTimer = {}

function CheckSiren(theVehicle, thePlayer)
	if(getElementData(theVehicle, "siren")) then
		if(getElementData(theVehicle, "owner") ~= getPlayerName(source)) then
			if(getElementData(theVehicle, "siren") == "true") then
				if(not isTimer(VehicleSirenTimer[theVehicle])) then
					for key,thePlayers in pairs(getElementsByType "player") do
						triggerClientEvent(thePlayers, "CreateVehicleAudioEvent", thePlayers, theVehicle, "genrl", 67, 11)
					end
					VehicleSirenTimer[theVehicle] = setTimer(function()
						for key,thePlayers in pairs(getElementsByType "player") do
							triggerClientEvent(thePlayers, "CreateVehicleAudioEvent", thePlayers, theVehicle,false, false, false)
						end
					end, 15000, 1)
					local x,y,z = getElementPosition(theVehicle)
					PoliceCallRemove(x,y,z,"Сработала сигнализация")
					if(thePlayer) then WantedLevel(thePlayer, 0.2) end
				end
			end
		end
	end
end


function race(name)
	SData["RaceArr"] = Races[name]
	SData["RaceName"] = name
	local raceblip = createBlip(Races[name][1][1], Races[name][1][2], 0, 33)
	outputChatBox("Стартует гонка на трассе #FFFF00"..name:gsub('_', ' '), getRootElement(), 255,255,255, true)

	local StartRaceTimeout = 90
	MPTimer = setTimer(function()
		if(StartRaceTimeout == 0) then
			destroyElement(raceblip)
			for Player, _ in pairs(MPPlayerList) do
				if(isElement(Player)) then
					triggerClientEvent(Player, "StartRace", Player, SData["RaceArr"], MPPlayerList)
				end
			end
			raceGlobalTimer = setTimer(function()
				endRace()
			end, 370000, 1)
		else
			if(isElementVisibleTo(raceblip, getRootElement())) then
				setElementVisibleTo(raceblip, getRootElement(), false)
			else
				setElementVisibleTo(raceblip, getRootElement(), true)
			end

			for Player, _ in pairs(MPPlayerList) do
				if(isElement(Player)) then
					HelpMessage(Player, "Начало гонки через "..StartRaceTimeout.." сек.")
				end
			end
		end
		StartRaceTimeout = StartRaceTimeout-1
	end, 1000, StartRaceTimeout+1)
	outputChatBox("Для участия в гонке напиши #A0A0A0/race", getRootElement(), 255,255,255, true)
end


function VehicleBindKeyEngine(thePlayer)
	theVehicle = getPedOccupiedVehicle(thePlayer)
	if(theVehicle and getPedOccupiedVehicleSeat(thePlayer) == 0) then
		if(getVehicleEngineState(theVehicle) == false) then
			if(isTimer(FuelTimer[theVehicle])) then
				local x,y,z=getElementPosition(thePlayer)
				createExplosion(x, y, z, 1)
				createExplosion(x, y, z, 6)
			end
			triggerEvent("onPlayerVehicleEnter", thePlayer, theVehicle, 0, 0, true)
		else
			triggerEvent("onPlayerVehicleExit", thePlayer, theVehicle, 0, 0, true)
		end
	end
end


function VehicleBindKeyLight(thePlayer)
	if(getPedOccupiedVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0) then
        if(getVehicleOverrideLights(getPedOccupiedVehicle(thePlayer)) ~= 2) then
            setVehicleOverrideLights(getPedOccupiedVehicle(thePlayer), 2)
        else
            setVehicleOverrideLights(getPedOccupiedVehicle(thePlayer), 1)
        end
	end
end


function VehicleBindKeyHood(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 0) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 0, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 0, 0, 200)
		end
	end
end


function VehicleBindKeyTrunk(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 1) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 1, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 1, 0, 200)
		end
	end
end


function VehicleBindKeyFL(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 2) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 2, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 2, 0, 200)
		end
	end
end


function VehicleBindKeyFR(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 3) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 3, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 3, 0, 200)
		end
	end
end


function VehicleBindKeyRL(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 4) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 4, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 4, 0, 200)
		end
	end
end


function VehicleBindKeyRR(thePlayer)
	if(getPedOccupiedVehicleSeat(thePlayer)) then
		if(getVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 5) == 0) then
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 5, 1, 200)
		else
			setVehicleDoorOpenRatio(getPedOccupiedVehicle(thePlayer), 5, 0, 200)
		end
	end
end


local radio = {7,6,5,9,10,11,12,13,15,16,19,23,27,28,35,37,36}
local channelveh={}
function switch_radio(vehicle, station)
	for key,thePlayers in pairs(getElementsByType "player") do
		triggerClientEvent(thePlayers, "CreateVehicleAudioEvent", thePlayers, vehicle,"radio", "Ambience",radio[station])
	end
end


function VehicleBindKeyRadioR(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if(theVehicle) then
		if(channelveh[theVehicle] == nil) then
			channelveh[theVehicle] = 0
		end
		channelveh[theVehicle]=channelveh[theVehicle]+1
		if(channelveh[theVehicle] > #radio) then channelveh[theVehicle]=0 end
		HelpMessage(thePlayer, "Радиостанция №"..channelveh[theVehicle])
		switch_radio(theVehicle, channelveh[theVehicle])
	end
end


function VehicleBindKeyRadioL(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if(theVehicle) then
		if(channelveh[theVehicle] == nil) then
			channelveh[theVehicle] = 0
		end
		channelveh[theVehicle]=channelveh[theVehicle]-1
		if(channelveh[theVehicle] < 0) then channelveh[theVehicle]=#radio end
		HelpMessage(thePlayer, "Радиостанция №"..channelveh[theVehicle])
		switch_radio(theVehicle, channelveh[theVehicle])
	end
end






function endRace()
	for Player, _ in pairs(MPPlayerList) do
		if(isElement(Player)) then
			local FishNode = xmlFindChild(FishesNode, SData["RaceName"], 0)
			if(FishNode) then
				besttime = xmlNodeGetValue(FishNode)
			end
			triggerClientEvent(Player, "EndRace", Player, besttime)
		end
	end

	MPPlayerList = {}
	racePlayerFinish = {}
	SData["RaceArr"] = false
	setTimer(function()
			StartMP()
	end, 10000, 1)
end




function onPlayerChat(message, messageType, messagenovision)
	if(PData[source]["auth"]) then
		if(string.len(message:gsub("%s+", "")) == 0) then
			cancelEvent()
			return false
		end

		local theVehicle = getPedOccupiedVehicle(source)
		if(theVehicle) then
			if(getElementModel(theVehicle) == 582) then
				local seat = getPedOccupiedVehicleSeat(source)
				if(seat == 2 or seat == 3) then
					cancelEvent()
					if(getElementModel(source) == 60) then
						outputChatBox("#FF0033Прямой эфир #CC9966(ведущий):#FFFFFF "..message, getRootElement(), 255,255,255,true)
					else
						outputChatBox("#FF0033Прямой эфир #CC9966(гость):#FFFFFF "..message, getRootElement(), 255,255,255,true)
					end
				end
			end
		end

		if messageType == 0 then
			if(not isTimer(PData[source]["AntiFlood"])) then
				for key,thePlayers in pairs(getElementsByType "player") do
					triggerClientEvent(thePlayers, "PlayerSayEvent", thePlayers, message, source)
				end
				if(Phones[source]) then
					local CallTo = PhonesTo[source]
					outputChatBox("(ТЕЛЕФОН) ["..getElementData(source, "id").."] "..getPlayerName(source)..": "..message, source,0,255,255, true)
					if(getPedOccupiedVehicle(source)) then
						StartAnimation(source, "ped", "phone_talk", false,false,false,false)
					else
						StartAnimation(source, "ped", "phone_talk", 1, false, true, true, true)
					end

					if(Phones[CallTo]) then
						outputChatBox("(ТЕЛЕФОН) ["..getElementData(source, "id").."] "..getPlayerName(source)..": "..message, CallTo,0,255,255, true)
					end
					cancelEvent()
					return true
				end
				local color = getElementData(source, "color")
				local team = getPlayerTeam(source)

				if(not messagenovision) then
					callRemote("http://109.227.228.4/engine/include/MTA/index.php", ResultGet, getPlayerName(source):gsub('#%x%x%x%x%x%x', ''), message, color)
					PData[source]["AntiFlood"] = setTimer(function() end, 1000, 1)
					outputChatBox(color..getPlayerName(source):gsub('#%x%x%x%x%x%x', '')..": #EEEEEE"..message, getRootElement(), 255, 255, 255, true)
					table.insert(SData['Chat Message'], color..getPlayerName(source):gsub('#%x%x%x%x%x%x', '')..": #EEEEEE"..message)
					if(#SData['Chat Message'] > 10) then
						table.remove(SData['Chat Message'], 1)
					end
				end
				cancelEvent()
			else
				outputChatBox("Не флуди!", source,255,255,255,true)
				cancelEvent()
			end
		elseif(messageType == 1) then
			for key,thePlayers in pairs(getElementsByType "player") do
				triggerClientEvent(thePlayers, "PlayerActionEvent", thePlayers, message, source)
			end
			cancelEvent()
		elseif(messageType == 2) then
			cancelEvent()
			local hex = RGBToHex(getPlayerNametagColor(source))

			local team = getPlayerTeam(source)
			if not team then
				return outputChatBox("Ты не состоишь в команде!", source, 255, 255, 255, true)
			end

			local members = getPlayersInTeam(team) or {}
			for _, player in ipairs(members) do
				outputChatBox("* Рация"..hex.." "..getPlayerName(source)..": #FFFFFF"..message, player, 255, 255, 255, true)
			end
			for key,thePlayers in pairs(getElementsByType "player") do
				triggerClientEvent(thePlayers, "PlayerSayEvent", thePlayers, message, source)
			end
		end
	else
		outputChatBox("Авторизируйся чтобы написать сообщение", source,255,255,255,true)
		cancelEvent()
	end
end
addEvent("onPlayerChat", true)
addEvent("CliendSideonPlayerChat", true)
addEventHandler("onPlayerChat", getRootElement(), onPlayerChat)
addEventHandler("CliendSideonPlayerChat", getRootElement(), onPlayerChat)

function BurnChatMSG(name, message, nickcolor)
	outputChatBox("[WEB] "..nickcolor..name..": #FFFFFF"..message, getRootElement(), 255, 255, 255, true)
	table.insert(SData['Chat Message'], "[WEB] "..nickcolor..name..": #FFFFFF"..message)
	if(#SData['Chat Message'] > 10) then
		table.remove(SData['Chat Message'], 1)
	end
end
addEvent("BurnChatMSG", true)
addEventHandler("BurnChatMSG", getRootElement(), BurnChatMSG)




function UPDOnline(name, message, nickcolor)
	setElementData(root, "ChatOnline", name)
end
addEvent("UPDOnline", true)
addEventHandler("UPDOnline", getRootElement(), UPDOnline)



function ForceRemoveFromVehicle(thePlayer, force)
	removePedFromVehicle(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	local rz,ry,rz = getElementRotation(thePlayer)
	setElementPosition(thePlayer, x,y,z+2)
	local x2,y2,z2 = getPointInFrontOfPoint(x, y, z, rz+90, force)
	setElementVelocity(thePlayer, x2-x, y2-y, (z2-z)+0.5)
	setPedAnimation(thePlayer, "ped", "ev_dive", 3000,false,true,false,false)

	setTimer(function(thePlayer)
		setPedAnimationProgress(thePlayer, "ev_dive", 0.2)
	end, 50, 1, thePlayer)
end
addEvent("ForceRemoveFromVehicle", true)
addEventHandler("ForceRemoveFromVehicle", getRootElement(), ForceRemoveFromVehicle)






function ResultGet(sum)
    --outputChatBox(sum)
end





function StaminaOut(method)
	local HP = getElementHealth(source)
	if(method) then
		if(HP > 20) then
			AddSkill(source, 22, 1)
			AddSkill(source, 24, 1)
		end
	end
end
addEvent("StaminaOut", true)
addEventHandler("StaminaOut", root, StaminaOut)




function doTakeScreenShot()
    takePlayerScreenShot(source, 300, 200)
end
addEvent("doTakeScreenShot", true)
addEventHandler("doTakeScreenShot", root, doTakeScreenShot)







local photo={}
addEventHandler("onPlayerScreenShot", root,
	function(theResource, status, pixels, timestamp, tag)
        triggerClientEvent(source, "onMyClientScreenShot", resourceRoot, pixels)
		photo[source]=pixels
		outputChatBox("Чтобы отправить фото садись в Newsvan и пиши /smi текст", source, 255,255,255,true)
    end
)


function smi(thePlayer, command, ...)
	if(photo[thePlayer]) then
		triggerClientEvent(getRootElement(), "onMyClientScreenShot", getRootElement(), photo[thePlayer])
		photo[thePlayer]=nil

		local stringWithAllParameters = table.concat({...}, " ")
		triggerEvent("onPlayerChat", thePlayer, stringWithAllParameters, 0)
	else
		outputChatBox("Фотки нет", thePlayer)
	end
end
addCommandHandler("smi", smi)








function lockhouse(thePlayer)
	if(PData[thePlayer]["GarageCol"]) then
		if(isElementWithinColShape(thePlayer, PData[thePlayer]["GarageCol"])) then
			if(getElementData(PData[thePlayer]["GarageCol"], "type") == "GEnter") then
				local HouseNodes = xmlNodeGetChildren(HouseNode)
				local node = xmlFindChild(HouseNode, getElementData(PData[thePlayer]["GarageCol"], "h"), 0)
				if(getPlayerName(thePlayer) == xmlNodeGetValue(node)) then
					local arr = fromJSON(xmlNodeGetAttribute(node, "Garage"))
					if(arr[getElementData(PData[thePlayer]["GarageCol"], "number")][5] == 1) then
						arr[getElementData(PData[thePlayer]["GarageCol"], "number")][5] = 0
						HelpMessage(thePlayer, "Ты открыл гараж")
						triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 17)
					else
						arr[getElementData(PData[thePlayer]["GarageCol"], "number")][5] = 1
						HelpMessage(thePlayer, "Ты закрыл гараж")
						triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 16)
					end
					setElementData(Garages[getElementData(PData[thePlayer]["GarageCol"], "h")][getElementData(PData[thePlayer]["GarageCol"], "number")]["enter"], "locked", arr[getElementData(PData[thePlayer]["GarageCol"], "number")][5])
					xmlNodeSetAttribute(node, "Garage", toJSON(arr))
				end
			end
		end
	end



	if(PlayersEnteredPickup[thePlayer]) then
		local x,y,z = getElementPosition(PlayersEnteredPickup[thePlayer])
		local px,py,pz = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(x, y, z, px, py ,pz)
		if(distance < 2) then
			if(getElementData(PlayersEnteredPickup[thePlayer], "owner")) then
				if(getElementData(PlayersEnteredPickup[thePlayer], "owner") == getPlayerName(thePlayer)) then
					local HouseNodes = xmlNodeGetChildren(HouseNode)
					local node = xmlFindChild(HouseNode, getElementData(PlayersEnteredPickup[thePlayer], "house"), 0)
					if(getPlayerName(thePlayer) == xmlNodeGetValue(node)) then
						if(xmlNodeGetAttribute(node, "locked") == "1") then
							xmlNodeSetAttribute(node, "locked", "0")
							setElementData(getElementByID(xmlNodeGetName(node)), "locked", 0, false)
							HelpMessage(thePlayer, "Ты открыл дом")
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 17)
						else
							xmlNodeSetAttribute(node, "locked", "1")
							setElementData(getElementByID(xmlNodeGetName(node)), "locked", 1, false)
							HelpMessage(thePlayer, "Ты закрыл дом")
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 16)
						end
					end
				end
			end
		end
	end
end





function dm(thePlayer, command, h)
	if(DMPlayerList[thePlayer]) then
		LeaveDeathMatch(thePlayer)
	else
		if(getPedOccupiedVehicle(thePlayer)) then removePedFromVehicle(thePlayer) end
		PData[thePlayer]["DeathMatch"] = true
		FullClip(thePlayer, true)
		HelpMessage(thePlayer, "Бесконечных патроны включены")
		SpawnthePlayer(thePlayer)
		DMPlayerList[thePlayer] = 0
		
		local randomSkin = SkinList[math.random(#SkinList)]
		setElementModel(thePlayer, randomSkin)
		local r, g, b = getTeamColor(SkinData[randomSkin][2])
		setBlipColor(PData[thePlayer]['radar'], r,g,b, 255)
		
	end
end
addCommandHandler("dm", dm)


function LeaveDeathMatch(thePlayer)
	local r, g, b = getTeamColor(getPlayerTeam(thePlayer))
	setBlipColor(PData[thePlayer]['radar'], r,g,b, 0)
	
	PData[thePlayer]["DeathMatch"] = nil
	DMPlayerList[thePlayer] = nil
	FullClip(thePlayer, false)
	triggerClientEvent(thePlayer, "deathmatchInfo", thePlayer, false, false)
	SpawnedAfterChange(thePlayer)
end
	
function deathmatch(matches)
	SData["DmName"] = matches
	
	local StartRaceTimeout = 300
	setTimer(function()
		if(StartRaceTimeout == 0) then
			local TopScore = 0
			local Winner = false
			for thePlayer, score in pairs(DMPlayerList) do
				if(isElement(thePlayer)) then
					if(TopScore < score) then
						TopScore = score
						Winner = thePlayer
					end
					DMPlayerList[thePlayer] = 0
				else
					DMPlayerList[thePlayer] = nil
				end
			end
			if(Winner) then
				for thePlayer, score in pairs(DMPlayerList) do
					if(isElement(thePlayer)) then
						outputChatBox(" *Deathmatch Победитель "..getPlayerName(Winner).." убийств "..TopScore, thePlayer, 255,255,255, true)
					end
				end
			
				RacePriceGeneration(Winner)
				RacePriceGeneration(Winner)
				RacePriceGeneration(Winner)
				AddPlayerMoney(Winner, math.random(500, 1000)*(TopScore+1), "МИССИЯ ВЫПОЛНЕНА!")
			end
			
			deathmatch(ListDeathmatchs[math.random(#ListDeathmatchs)])
		else
			for thePlayer, score in pairs(DMPlayerList) do
				if(isElement(thePlayer)) then
					triggerClientEvent(thePlayer, "deathmatchInfo", thePlayer, StartRaceTimeout, score)
					if(StartRaceTimeout == 300) then
						SpawnthePlayer(thePlayer)
					end
				end
			end
		end
		StartRaceTimeout = StartRaceTimeout-1
	end, 1000, StartRaceTimeout+1)
end
deathmatch(ListDeathmatchs[math.random(#ListDeathmatchs)])






function StartMP()
	local rand = math.random(getArrSize(Races))
	local ind = 1
	for i, _ in pairs(Races) do
		if(ind == rand) then
			rand = i
			break
		end
		ind = ind+1
	end
	race(rand)
end






function getTeamGroup(team)
	if(team == "Мирные жители" or team == "МЧС") then
		return "Мирные жители"
	elseif(team == "Вагос" or team == "Якудзы" or team == "Рифа") then
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


function startBizVacancy(thePlayer, name, args)
	local arg = fromJSON(args)
	if(getPlayerName(thePlayer)) then
		local vacancy = xmlNodeGetChildren(BizNode)
		for i, node in pairs(vacancy) do
			if(xmlNodeGetName(node) == arg[3]) then
				local ChildNode = xmlNodeGetChildren(node, arg[4])
				if(not IsPlayerJob(getPlayerName(thePlayer))) then
					if(VacancyDATA[arg[2]]) then
						if(GetDatabaseAccount(thePlayer, getTeamVariable(VacancyDATA[arg[2]][2])) < VacancyDATA[arg[2]][1]) then
							HelpMessage(thePlayer, "Необходимо "..VacancyDATA[arg[2]][1].." репутации "..getTeamGroup(VacancyDATA[arg[2]][2]))
							return false
						end
					end

					HelpMessage(thePlayer, "Тебе дали новую должность! теперь ты #EEEEEE"..arg[2])
					SetTeam(thePlayer, VacancyDATA[arg[2]][2])
					setElementData(thePlayer, "job", arg[2])
					if(xmlNodeGetAttribute(ChildNode, "jobbiz")) then
						for z, v in pairs(vacancy) do
							if(xmlNodeGetName(v) == xmlNodeGetAttribute(ChildNode, "jobbiz")) then
								xmlNodeSetAttribute(v, "owner", getPlayerName(thePlayer))
								if(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")]) then
									setElementData(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")], "bizowner", getPlayerName(thePlayer))
								end
							end
						end
					end

					xmlNodeSetValue(ChildNode, getPlayerName(thePlayer))
				else
					HelpMessage(thePlayer, "Ты уже работаешь "..IsPlayerJob(getPlayerName(thePlayer)), thePlayer)
				end

				UpdateBiz(arg[3])
				UpdateVacancyList()
				break

			end
		end
	end
end
addEvent("startBizVacancy", true)
addEventHandler("startBizVacancy", root, startBizVacancy)


function stopBizVacancy(thePlayer, name, args)
	local arg = fromJSON(args)
	if(getPlayerName(thePlayer)) then
		local vacancy = xmlNodeGetChildren(BizNode)
		for i, node in pairs(vacancy) do
			if(xmlNodeGetName(node) == arg[3]) then
				local ChildNode = xmlNodeGetChildren(node, arg[4])

				HelpMessage(thePlayer, "Ты уволился с должности #EEEEEE"..arg[2])
				SetDatabaseAccount(thePlayer, "team", "Мирные жители")
				if(xmlNodeGetAttribute(ChildNode, "jobbiz")) then
					for z, v in pairs(vacancy) do
						if(xmlNodeGetName(v) == xmlNodeGetAttribute(ChildNode, "jobbiz")) then
							xmlNodeSetAttribute(v, "owner", "")
							if(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")]) then
								setElementData(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")], "bizowner", "")
							end
						end
					end
				end

				xmlNodeSetValue(ChildNode, "")

				UpdateBiz(arg[3])
				UpdateVacancyList()
				break

			end
		end
	end
end
addEvent("stopBizVacancy", true)
addEventHandler("stopBizVacancy", root, stopBizVacancy)





function editBizVacancy(thePlayer, name, args)
	local arg = fromJSON(args)
	if(name) then
		local vacancy = xmlNodeGetChildren(BizNode)
		for i, node in pairs(vacancy) do
			if(xmlNodeGetName(node) == arg[3]) then
				local ChildNode = xmlNodeGetChildren(node, arg[4])


				if(name == "") then
					local player = getPlayerFromName(xmlNodeGetValue(ChildNode))
					if(player) then
						SetDatabaseAccount(player, "team", "Мирные жители")
						outputChatBox("Тебя уволили с должности #EEEEEE"..arg[2], player, 255, 255, 255, true)
					end

					if(xmlNodeGetAttribute(ChildNode, "jobbiz")) then
						for z, v in pairs(vacancy) do
							if(xmlNodeGetName(v) == xmlNodeGetAttribute(ChildNode, "jobbiz")) then
								xmlNodeSetAttribute(v, "owner", name)
								if(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")]) then
									setElementData(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")], "bizowner", name)
								end
							end
						end
					end

					xmlNodeSetValue(ChildNode, name)

				elseif(not IsPlayerJob(name)) then
					local player = getPlayerFromName(name)
					if(player) then
						local x,y,z = getElementPosition(thePlayer)
						local x2,y2,z2 = getElementPosition(player)
						if(getDistanceBetweenPoints3D(x, y, z, x2,y2,z2) < 10) then
							outputChatBox("Тебе дали новую должность! теперь ты #EEEEEE"..arg[2], player, 255, 255, 255, true)
							SetTeam(player, VacancyDATA[arg[2]][2])
							setElementData(player, "job", arg[2])
							local player = getPlayerFromName(xmlNodeGetValue(ChildNode))
							if(player) then
								SetTeam(player, "Мирные жители")
								setElementData(player, "job", "нет")
								outputChatBox("Тебя уволили с должности #EEEEEE"..arg[2], player, 255, 255, 255, true)
							end

							if(xmlNodeGetAttribute(ChildNode, "jobbiz")) then
								for z, v in pairs(vacancy) do
									if(xmlNodeGetName(v) == xmlNodeGetAttribute(ChildNode, "jobbiz")) then
										xmlNodeSetAttribute(v, "owner", name)
										if(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")]) then
											setElementData(BusinessPickup[xmlNodeGetAttribute(ChildNode, "jobbiz")], "bizowner", name)
										end
									end
								end
							end

							xmlNodeSetValue(ChildNode, name)
						else
							outputChatBox("Чтобы устроить игрока по \"#EEEEEEблату\" необходимо чтобы он находился рядом с вами в офисе.", thePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("Такого игрока нет в сети", thePlayer, 255, 255, 255, true)
					end
				else
					outputChatBox("Игрок "..name.." в настоящий момент уже где-то работает.", thePlayer, 255, 255, 255, true)
				end

				UpdateBiz(arg[3])
				UpdateVacancyList()
				break

			end
		end
	end
end
addEvent("editBizVacancy", true)
addEventHandler("editBizVacancy", root, editBizVacancy)


function IsPlayerJob(thePlayerName)
	for name, arr in pairs(VacancyList) do
		for w, nick in pairs(arr) do
			if(nick == thePlayerName) then
				return name
			end
		end
	end
	return false
end


function UpdateVacancyList()
	local bizNode = xmlNodeGetChildren(BizNode)
	VacancyList = {}
	for c,node in ipairs(bizNode) do
		local vacancy = xmlNodeGetChildren(node)
		for i, ChildNode in pairs(vacancy) do
			local name = xmlNodeGetAttribute(ChildNode, "name")
			if(not VacancyList[name]) then VacancyList[name] = {} end
			VacancyList[name][#VacancyList[name]+1] = xmlNodeGetValue(ChildNode)
		end
	end
end



function bank(thePlayer, count, args)
	local arg = fromJSON(args)
	local count = tonumber(count)
	if(count) then
		if(count > 0) then
			if(AddPlayerMoney(thePlayer, -count)) then
				local bankMoney=GetDatabaseAccount(thePlayer, "bank")
				SetDatabaseAccount(thePlayer, "bank", bankMoney+count)

				BankEvent(thePlayer, false, arg[1], true)
			end
		end
	end
end
addEvent("bank", true)
addEventHandler("bank", root, bank)



function withdraw(thePlayer, count, args)
	local arg = fromJSON(args)
	local count = tonumber(count)
	if(count) then
		if(GetDatabaseAccount(thePlayer, "bank") >= count and count > 0) then
			local bankMoney=GetDatabaseAccount(thePlayer, "bank")
			SetDatabaseAccount(thePlayer, "bank", bankMoney-count)
			AddPlayerMoney(thePlayer, count)
			BankEvent(thePlayer, false, arg[1], true)
		else
			ToolTip(thePlayer, "На твоем счету нет столько денег!")
		end
	end
end
addEvent("withdraw", true)
addEventHandler("withdraw", root, withdraw)




function givebizmoney(thePlayer, count, args)
	local arg = fromJSON(args)
	local count = tonumber(count)
	if(count) then
		if(count > 0) then
			local bizNode = xmlFindChild(BizNode, arg[1], 0)
			local PlayerMoney = GetPlayerMoney(thePlayer)
			if(xmlNodeGetAttribute(bizNode, "owner") == getPlayerName(thePlayer)) then
				if(AddPlayerMoney(thePlayer, -count)) then
					AddBizMoney(arg[1], count)
				end
			end
		end
	end
end
addEvent("givebizmoney", true)
addEventHandler("givebizmoney", root, givebizmoney)




function removebizmoney(thePlayer, count, args)
	local arg = fromJSON(args)
	local count = tonumber(count)
	if(count) then
		if(count > 0) then
			local bizNode = xmlFindChild(BizNode, arg[1], 0)
			local BizMoney = tonumber(xmlNodeGetAttribute(bizNode, "money"))
			if(xmlNodeGetAttribute(bizNode, "owner") == getPlayerName(thePlayer)) then
				if(BizMoney-count >= 0) then
					AddPlayerMoney(thePlayer, count)
					AddBizMoney(arg[1], -count)
				else
					ToolTip(thePlayer, "На твоем счету нет столько денег!")
				end
			end
		end
	end
end
addEvent("removebizmoney", true)
addEventHandler("removebizmoney", root, removebizmoney)



function repairVeh()
	local theVehicle = getPedOccupiedVehicle(source)
	local vehh = getVehicleHandling(theVehicle)
	local count =  math.round((vehh["mass"]/5)+(1000-getElementHealth(theVehicle)), 0)
	if(AddPlayerMoney(source, -count)) then
		fixVehicle(theVehicle)
		triggerClientEvent(source, "PlaySFXSoundEvent", source, 4)
	end
end
addEvent("repairVeh", true)
addEventHandler("repairVeh", root, repairVeh)


function hesoyam(thePlayer)
	setElementHealth(thePlayer, 1000)
	AddPlayerMoney(thePlayer, 25000)
	setPedArmor(thePlayer, 100)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if(theVehicle) then fixVehicle(theVehicle) end
end
addEvent("hesoyam", true)
addEventHandler("hesoyam", root, hesoyam)




function FullClip(thePlayer, state)
	if(state) then
		setElementData(thePlayer, "FullClip", "true")
		useinvweapon(thePlayer)
	else
		removeElementData(thePlayer, "FullClip")
		useinvweapon(thePlayer)
	end
end
addEvent("FullClip", true)
addEventHandler("FullClip", root, FullClip)


function ExitTuning(theVehicle)
	setElementDimension(theVehicle, 0)
	setElementInterior(theVehicle, 0, PData[source]["oldposition"][1], PData[source]["oldposition"][2], PData[source]["oldposition"][3]+VehicleSystem[getElementModel(theVehicle)][1])
	setElementRotation(theVehicle, 0, 0, PData[source]["oldposition"][4])

	local occupants = getVehicleOccupants(theVehicle) or {}
	for seat, occupant in pairs(occupants) do
		setElementDimension(occupant, 0)
		setElementInterior(occupant, 0, PData[source]["oldposition"][1], PData[source]["oldposition"][2], PData[source]["oldposition"][3])
	end

	PData[source]["ShowUpgrade"] = nil
	PData[source]["oldposition"] = nil
	PData[source]["theVehicleTuningHandl"] = nil
	PData[source]["theVehicleTuning"] = nil
	fadeCamera(source, true)
	setPlayerHudComponentVisible(source, "radar", true)
	setCameraTarget(source, source)
end
addEvent("ExitTuning", true)
addEventHandler("ExitTuning", root, ExitTuning)



function VehicleUpgrade(upgrade, count)
	local theVehicle = getPedOccupiedVehicle(source)
	if(GetPlayerMoney(source) >= count) then
		if(ModificationVehicle[upgrade]) then
			PData[source]["theVehicleTuningHandl"] = getElementData(theVehicle, "handl")

			AddPlayerMoney(source, 0, "УСТАНОВЛЕНО!")

			if(getElementData(theVehicle, "x")) then
				local CarNodes = xmlNodeGetChildren(CarNode)
				for i,node in ipairs(CarNodes) do
					if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
						if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
							xmlNodeSetAttribute(node, "handl", getElementData(theVehicle, "handl"))
						end
					end
				end
			end

			RemovePlayerVehiclePart(source, PData[source]["ShowUpgrade"][1], PData[source]["ShowUpgrade"][2])
			AddPlayerVehiclePart(source, PData[source]["ShowUpgrade"][1], PData[source]["ShowUpgrade"][3])
			local parts = GetPlayerVehiclePart(source, theVehicle)
			triggerClientEvent(source, "BuyUpgrade", source, PData[source]["theVehicleTuningHandl"], toJSON(parts))
		elseif(upgrade == 8) then
			local vehh = getVehicleHandling(theVehicle)
			if(getElementData(theVehicle, "siren")) then
				HelpMessage(source, "#009900Уже установлено!")
			else
				setElementData(theVehicle, "siren", "true")
				ToolTip(source, "Чтобы управлять сигнализацией выйди из машины и наведи на неё прицел.")
				AddPlayerMoney(source, -count, "КУПЛЕНО")
				if(getElementData(theVehicle, "x")) then
					local CarNodes = xmlNodeGetChildren(CarNode)
					for i,node in ipairs(CarNodes) do
						if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
							if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
								xmlNodeSetAttribute(node, "siren", "true")
							end
						end
					end
				end
			end
		elseif(upgrade == 10 or upgrade == 11 or upgrade == 12 or upgrade == 13) then
			setVehiclePaintjob(theVehicle, upgrade-10)
			AddPlayerMoney(source, -count)
			if(getElementData(theVehicle, "x")) then
				local CarNodes = xmlNodeGetChildren(CarNode)
				for i,node in ipairs(CarNodes) do
					if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
						if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
							xmlNodeSetAttribute(node, "vinyl", upgrade-10)
						end
					end
				end
			end
		else
			local upgr={}
			local removeUpgr = false
			for upgradeKey, upgradeValue in ipairs (getVehicleUpgrades(theVehicle)) do
				if(upgradeValue == upgrade) then
					removeUpgr = true
					removeVehicleUpgrade(theVehicle, upgrade)
				else
					upgr[upgradeKey]=upgradeValue
				end
			end
			if(not removeUpgr) then
				addVehicleUpgrade(theVehicle, upgrade)
				AddPlayerMoney(source, -count)
			end

			triggerClientEvent(source, "BuyUpgrade", source)
			if(getElementData(theVehicle, "x")) then
				local CarNodes = xmlNodeGetChildren(CarNode)
				for i,node in ipairs(CarNodes) do
					if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
						if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
							xmlNodeSetAttribute(node, "upgrades", toJSON(upgr))
						end
					end
				end
			end
		end
	else
		HelpMessage(source, "#B4191CНедостаточно средств!")
	end
end
addEvent("VehicleUpgrade", true)
addEventHandler("VehicleUpgrade", root, VehicleUpgrade)

function BuyColor(c1,c2,c3,c4,money)
	if(AddPlayerMoney(source, -money)) then
		local theVehicle = getPedOccupiedVehicle(source)
		setVehicleColor(theVehicle, c1, c2, c3, c4)
		if(getElementData(theVehicle, "x")) then
			local CarNodes = xmlNodeGetChildren(CarNode)
			for i,node in ipairs(CarNodes) do
				if(getElementData(theVehicle, "owner") == xmlNodeGetValue(node)) then
					if(getElementData(theVehicle, "x") == xmlNodeGetAttribute(node, "vx") and getElementData(theVehicle, "y") == xmlNodeGetAttribute(node, "vy") and getElementData(theVehicle, "z") == xmlNodeGetAttribute(node, "vz")) then
						xmlNodeSetAttribute(node, "vc1", c1)
						xmlNodeSetAttribute(node, "vc2", c2)
						xmlNodeSetAttribute(node, "vc3", c3)
						xmlNodeSetAttribute(node, "vc4", c4)
					end
				end
			end
		end
		triggerClientEvent(source, "BuyUpgrade", source)
	end
end
addEvent("BuyColor", true)
addEventHandler("BuyColor", root, BuyColor)




function SetHomeType(thePlayer, home, types)
	local node = xmlFindChild(HouseNode, home, 0)
	xmlNodeSetAttribute(node, "type", types)
	if(InteriorsClass[types]) then
		xmlNodeSetAttribute(node, "int", InteriorsClass[types][math.random(#InteriorsClass[types])])
	end
	outputChatBox("* Установлен "..types,thePlayer, 255,255,255, true)
end
addEvent("SetHomeType", true)
addEventHandler("SetHomeType", root, SetHomeType)









function edithome(thePlayer, command, h)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		local HouseNodes = xmlNodeGetChildren(HouseNode)
		local arr = {}
		for i,node in ipairs(HouseNodes) do
			local int = xmlNodeGetAttribute(node, "type")
			if(not int) then
				arr[#arr+1] = {xmlNodeGetAttribute(node, "x"), xmlNodeGetAttribute(node, "y"), xmlNodeGetAttribute(node, "z"), "street", xmlNodeGetName(node), 270}
			end
		end
		outputChatBox(#arr)
		triggerClientEvent(thePlayer, "StartLookZonesBeta", thePlayer, toJSON(arr))
	end
end
addCommandHandler("edithome", edithome)





function createNewHome(thePlayer, command, h)
	if(getPlayerName(thePlayer) == "alexaxel705") then
		local HouseNodes = xmlNodeGetChildren(HouseNode)
		local count=0
		for i,node in ipairs(HouseNodes) do
			count=count+1
		end
		if(not h) then h = 35000 end
		local NewNode = xmlCreateChild(HouseNode, "h"..count)
		local x,y,z=getElementPosition(thePlayer)
		xmlNodeSetAttribute(NewNode, "x", math.round(x, 1))
		xmlNodeSetAttribute(NewNode, "y", math.round(y, 1))
		xmlNodeSetAttribute(NewNode, "z", math.round(z, 1))
		xmlNodeSetAttribute(NewNode, "price", h)
		xmlNodeSetAttribute(NewNode, "locked", "1")
	end
end
addCommandHandler("newhome", createNewHome)



























local OffsetLiberty = {[1] = -8000, [2] = -8000, [3] = 0}
local LibertySmall = {
	--["WHOLEVC"] = {
	--	{"WHOLEVC", 5977.83, -10413.5, 10069.9, -6351.89}, 
	--	{"WHOLELC", 6109.65, 6902.24, 10069.9, 10206.4}
	--}, 
	--["COPS_1"] = {
	--	{"COPS_1", 9050.8, 8304.98, 9097.36, 8368.98}
	--}, 
	--["HOSPI_1"] = {
	--	{"HOSPI_1", 9051.09, 8390.02, 9097.09, 8478.83}
	--}, 
	--["FILLIN1"] = {
	--	{"FILLIN1", 9278.77, 8386.66, 9304.17, 8487.46}
	--}, 
	--["MAIN_D1"] = {
	--	{"MAIN_D1", 8952.53, 8092.73, 8980.16, 8362.31}
	--}, 
	--["MAIN_D2"] = {
	--	{"MAIN_D2", 8881.08, 8362.63, 8979.83, 8390.44}
	--}, 
	--["FISHFAC"] = {
	--	{"FISHFAC", 8859.21, 7850.19, 8931.14, 7923.99}
	--}, 
	--["MAIN_D3"] = {
	--	{"MAIN_D3", 8880.79, 8391.01, 8910.31, 8529.77}
	--}, 
	--["MAIN_D4"] = {
	--	{"MAIN_D4", 8910.59, 8488.91, 8980.11, 8529.77}
	--}, 
	--["MAIN_D5"] = {
	--	{"MAIN_D5", 8950.88, 8536.44, 8979.83, 8717.14}
	--}, 
	--["MAIN_D6"] = {
	--	{"MAIN_D6", 8951.15, 8718.04, 8979.85, 8820.78}
	--}, 
	--["WEE_DAM"] = {
	--	{"WEE_DAM", 6676.41, 9306.84, 7004.55, 9504.65}
	--}, 
	["ROADBR1"] = {
		{"Callahan Bridge", 8532.77, 8041.65, 8980.44, 8091.65}
	}, 
	["PORT_W"] = {
		{"Callahan Point", 8666.68, 7821.78, 8980.68, 8041.27}
	}, 
	["PORT_S"] = {
		{"Atlantic Quays", 8980.88, 7748.45, 9416.88, 7930.07}
	}, 
	["PORT_E"] = {
		{"Portland Harbor", 9278.68, 7930.35, 9730.68, 8386.35}
	}, 
	["PORT_I"] = {
		{"Trenton", 8980.88, 7930.15, 9278.38, 8257.95}
	}, 
	["LCHINA"] = {
		{"Chinatown", 8660.42, 8091.71, 8965.42, 8551.31}
	}, 
	["REDLIGH"] = {
		{"Red Light District", 8660.38, 8536.38, 8980.38, 8717.38}
	}, 
	["TOWERS"] = {
		{"Hepburn Heights", 8660.42, 8717.6, 8980.42, 8921.23}
	}, 
	["LITTLEI"] = {
		{"Saint Mark's", 8980.9, 8487.68, 9303.9, 8921.68}
	}, 
	["HARWOOD"] = {
		{"Harwood", 8660.98, 8921.82, 9303.98, 9322.68}
	}, 
	["EASTBAY"] = {
		{"Portland Beach", 9304.37, 8386.53, 9712.6, 9199.63}
	}, 
	["S_VIEW"] = {
		{"Portland View", 8981.1, 8258.19, 9278.6, 8487.19}
	}, 
	["ROADBR2"] = {
		{"Callahan Bridge", 8359.77, 8041.7, 8529.88, 8091.7}
	}, 
	["CONSTRU"] = {
		{"Fort Staunton", 8154.88, 8588.38, 8529.32, 8938.38}
	}, 
	["LCADIUM"] = {
		{"Aspatria", 7689.24, 8587.4, 8031.24, 9160.5}
	}, 
	["YAKUSA"] = {
		{"Torrington", 8114.77, 7327.58, 8492.77, 7940.07}
	}, 
	["LCOPING"] = {
		{"Bedford Point", 7690.56, 7327.95, 8114.56, 7995.55}
	}, 
	["COM_EAS"] = {
		{"Newport", 8115.11, 7940.81, 8530.11, 8587.81}
	}, 
	["PARK"] = {
		{"Belleville Park", 7793.43, 7996.93, 8114.27, 8586.93}
	}, 
	["UNIVERS"] = {
		{"Liberty Campus", 8032.27, 8588.38, 8154.27, 8938.38}
	}, 
	["HOSPI_2"] = {
		{"Rockford", 8032.24, 8938.89, 8530.24, 9268.89}
	}, 
	["LCRPORT"] = {
		{"Francis Intl. Airport", 6282.03, 7655.29, 7446.37, 8731.56}
	}, 
	["PROJECT"] = {
		{"Wichita Gardens", 7103.17, 8731.93, 7543.96, 9092.73}
	}, 
	["SWANKS"] = {
		{"Cedar Grove", 7047.77, 9093.39, 7648.09, 9650.06}
	}, 
	["SUB_IND"] = {
		{"Pike Creek", 6507.43, 8732.03, 7102.69, 9092.76}
	}, 
	["BIG_DAM"] = {
		{"Cochrane Dam", 6520.5, 9093.44, 7047.48, 9704.54}
	}, 
}

local LibertyBig = {
	["IND_ZON"] = {
		{"Portland", 8532.15, 7670.28, 9817.66, 9434.12}
	}, 
	["COM_ZON"] = {
		{"Staunton Island", 7649.52, 7280.03, 8530.52, 9367.26}
	}, 
	["SUB_ZON"] = {
		{"Shoreside Vale", 6270.36, 7648.62, 7648.1, 10206.4}
	}, 
	--["SUB_ZO2"] = {
	--	{"Shoreside Vale", 7649.56, 9161.11, 7793.71, 9367.04}
	--}, 
	--["SUB_ZO3"] = {
	--	{"Shoreside Vale", 7649.57, 9079.09, 7688.67, 9161.06}
	--}, 
}

for _,dat in pairs(LibertySmall) do
	for _, v in pairs(dat) do
		v[2] = v[2] + OffsetLiberty[1]
		v[3] = v[3] + OffsetLiberty[2]
		
		v[4] = v[4] + OffsetLiberty[1]
		v[5] = v[5] + OffsetLiberty[2]
	end
end


for _,dat in pairs(LibertyBig) do
	for _, v in pairs(dat) do
		v[2] = v[2] + OffsetLiberty[1]
		v[3] = v[3] + OffsetLiberty[2]
		
		v[4] = v[4] + OffsetLiberty[1]
		v[5] = v[5] + OffsetLiberty[2]
	end
end



function GetZoneName(x,y,z, citiesonly, City)
	if(City) then
		if(City == "Liberty City") then 
			if(not citiesonly) then -- Если ничего не находит отображает название больших районов
				for _, dist in pairs(LibertySmall) do
					for _, v in pairs(dist) do
						if(v[2] <= x and v[3] <= y) then
							if(v[4] >= x and v[5] >= y) then
								return v[1]
							end
						end
					end
				end
			end 
			
			for _, dist in pairs(LibertyBig) do -- Если не находит тут то пишет просто Liberty City
				for _, v in pairs(dist) do
					if(v[2] <= x and v[3] <= y) then
						if(v[4] >= x and v[5] >= y) then
							return v[1]
						end
					end
				end
			end
			return "Liberty City"
		elseif(City == "Vice City") then
			return "Vice City"
		end
	end
	return getZoneName(x,y,z, citiesonly)
end













local BodyArmour = {
	{2097.0,2154.0,14.0},
	{2435.0,1663.0,16.0},
	{2500.0,925.0,11.0},
	{2106.0,1004.0,11.0},
	{1531.0,925.0,11.0},
	{1433.0,1852.0,10.8},
	{1000.0,1068.0,11.0},
	{1269.0,1352.0,11.0},
	{2294.0,547.0,1.0},
	{2543.0,-1625.0,12.0},
	{2339.0,-1944.0,13.0},
	{2767.0,-1192.0,69.0},
	{2112.0,-1990.0,14.0},
	{2544.0,-1120.0,62.0},
	{1562.0,-1888.0,14.0},
	{1086.0,-1806.0,17.0},
	{253.0,80.0,1004.0},
	{1759.0,-2242.0,1.0},
	{-2650.0,-198.0,4.0},
	{-2285.0,-24.0,35.0},
	{-1863.0,112.0,15.0},
	{-1574.0,1268.0,1.27},
	{-2916.0,992.0,8.0},
	{-2513.0,770.0,35.0},
	{-1394.0,-373.0,6.0},
	{-2303.0,-1606.0,484.0},
	{-2092.0,-2330.0,31.0},
	{-2260.0,2568.0,6.0},
	{-902.0,2689.0,42.0},
	{-317.0,2651.0,67.0},
	{1325.0,190.0,19.0},
	{2487.0,139.0,27.0},
	{761.0,380.0,23.0},
	{-51.0,-232.0,7.0},
	{252.0,2616.0,17.0},
	{212.0,1807.0,22.0},
	{1291.76,-803.4566,1089.93},
	{1715.12,-1673.51,20.22},
	{943.012,-939.8284,57.7345},
	{275.169,1859.699,9.81},
	{1268.34,-804.33,1084.01},
	{263.52,83.14,1001.039},
	{264.2632,117.0737,1008.813},
	{245.0618,195.9429,1008.172},
	{215.8489,126.0831,1003.226},
	{2125.493,-2275.037,20.5202},
	{2230.45,-2286.004,14.3751},
}


for i, v in pairs(BodyArmour) do
	local arm = createPickup(v[1], v[2], v[3], 3, 1242)
	setElementData(arm, "type", "armour")
end






local StantardWeapon = {
	{18,10,2832.0,2405.0,18.0},
	{41,500,2819.0,1663.0,11.0},
	{17,10,2725.0,2727.0,11.0},
	{37,2000,2649.0,2733.0,11.0},
	{42,3000,2148.0,2721.0,11.0},
	{25,30,1345.0,2367.0,11.0},
	{30,60,1625.0,1944.0,11.0},
	{26,25,1569.0,2150.0,11.0},
	{35,10,2072.0,2370.0,61.0},
	{34,20,2225.0,2530.0,17.0},
	{34,20,2337.0,1806.0,72.0},
	{31,70,2575.0,1562.0,16.0},
	{29,70,2243.0,1132.0,11.0},
	{38,200,2676.0,836.0,22.0},
	{32,50,1761.0,591.0,10.0},
	{16,20,2809.0,864.0,21.0},
	{30,60,1923.0,1011.0,22.0},
	{27,50,1407.0,1098.0,11.0},
	{17,10,1319.0,1636.0,10.6},
	{28,60,1446.35,1900.03,11.0},
	{23,30,1098.0,1681.0,7.0},
	{26,25,924.0,2138.0,11.0},
	{36,10,1155.0,2341.0,17.0},
	{35,10,1646.0,1349.0,11.0},
	{18,10,1781.0,2072.0,11.0},
	{18,10,2478.0,1182.0,22.0},
	{7,2854.0,944.0,11.0},
	{3,2241.0,2425.0,11.0},
	{2,1418.0,2774.0,15.0},
	{6,1393.0,2174.0,10.0},
	{9,1061.0,2074.0,11.0},
	{46,2057.0,2434.0,166.0},
	{8,2000.0,1526.0,15.0},
	{6,1997.0,1658.0,12.0},
	{41,500,2510.0,-1723.0,19.0},
	{22,35,2538.0,-1630.0,14.0},
	{28,60,2551.33,-1740.0,6.49},
	{26,25,2428.0,-1214.0,36.0},
	{24,30,2766.0,-2182.0,11.0},
	{16,20,2142.0,-1804.0,16.0},
	{29,70,1764.0,-1930.0,14.0},
	{23,30,1214.0,-1816.0,17.0},
	{35,10,1740.0,-1231.0,92.0},
	{29,70,2266.0,-1028.0,59.0},
	{41,500,2463.0,-1061.0,60.0},
	{34,20,2047.0,-1406.0,68.0},
	{17,10,2213.0,-2283.0,15.0},
	{17,10,1463.0,-1013.0,27.0},
	{30,60,1308.97,-874.4,40.0},
	{33,30,1102.0,-661.0,114.0},
	{32,50,899.8012,-792.078,102.0},
	{22,35,338.0,-1875.0,4.0},
	{16,20,397.0,-1924.0,8.0},
	{18,10,886.0,-966.0,37.0},
	{32,50,1408.0,-2380.0,14.0},
	{31,70,1379.0,-2547.0,14.0},
	{18,10,2426.0,-1416.0,24.0},
	{3,259.0,80.0,1004.0},
	{10,261.0,71.0,1003.0},
	{2,1457.0,-792.0,90.0},
	{9,2371.0,-2543.0,3.0},
	{4,1124.0,-1335.0,13.0},
	{18,10,2197.0,-2475.0,14.0},
	{46,1528.222,-1357.985,330.0371},
	{8,1862.0,-1862.0,14.0},
	{1,1339.0,-1765.0,14.0},
	{9,2192.243,-1988.751,13.4185},
	{6,2459.0,-1708.0,13.6},
	{16,20,2441.0,-1013.0,54.0},
	{29,70,-2678.0,-128.0,4.0},
	{24,30,-2212.0,109.0,35.0},
	{31,70,-2903.0,784.0,35.0},
	{32,50,-2665.0,1452.0,7.0},
	{39,15,-2754.0,-400.0,7.0},
	{22,35,-2206.0,-23.0,35.0},
	{25,30,-1841.106,-74.2171,14.7606},
	{37,2000,-1579.0,29.45,17.0},
	{33,30,-2094.0,-488.0,36.0},
	{30,60,-1968.0,-923.0,32.0},
	{43,50,-1945.0,-1088.0,31.0},
	{42,3000,-1700.0,415.0,7.0},
	{17,10,-1386.0,509.0,4.0},
	{28,60,-1679.0,1410.0,7.0},
	{37,2000,-2132.52,189.2507,35.5379},
	{36,10,-1126.69,-150.82,14.61},
	{38,200,-1496.0,591.0,42.0},
	{39,15,-2542.262,922.2401,67.1221},
	{32,50,-2092.0,1121.0,54.0},
	{34,20,-1629.0,1167.0,24.0},
	{9,-2083.0,298.0,42.0},
	{5,-2306.0,93.0,35.0},
	{6,-2796.416,123.686,6.844},
	{7,-2135.0,197.0,35.0},
	{8,-2208.0,696.0,50.0},
	{1,-2206.0,961.0,80.0},
	{3,-2222.0,-302.0,43.0},
	{4,-1871.0,351.0,26.0},
	{2,-2715.0,-314.0,7.0},
	{9,-2359.0,-82.0,35.0},
	{24,30,-1870.0,-1625.0,22.0},
	{42,3000,-1627.0,-2692.0,49.0},
	{28,60,-2038.0,-2562.0,31.0},
	{33,30,-1035.0,-2258.0,70.0},
	{26,25,2366.0,23.0,28.0},
	{18,10,2255.0,-74.0,32.0},
	{29,70,1296.0,392.0,20.0},
	{32,50,262.0,38.0,2.0},
	{30,60,-121.0,-232.0,1.0},
	{6,-532.0,-106.0,63.0},
	{31,70,113.0,1811.0,18.0},
	{24,30,36.0,1372.0,9.0},
	{25,30,24.0,969.0,20.0},
	{18,10,-170.0,1025.0,20.0},
	{22,35,-639.0,1181.0,13.0},
	{30,60,-585.0,2714.0,72.0},
	{42,3000,-742.0,2752.0,47.0},
	{25,30,-932.02,2649.92,42.0},
	{36,10,-1317.0,2509.0,87.0},
	{29,70,-1474.0,2577.0,56.0},
	{24,30,-2352.0,2456.0,6.0},
	{16,20,-2520.0,2293.0,5.0},
	{37,2000,-1358.0,-2115.0,30.0},
	{28,60,119.0,2409.0,17.0},
	{6,-1809.0,-1662.0,24.0},
	{46,-2350.0,-1586.0,485.0},
	{2,-2227.0,-2401.0,31.4},
	{6,2240.0,-83.0,27.0},
	{7,294.0,-188.0,2.0},
	{9,-761.0,-126.0,66.0},
	{8,-1568.0,2718.0,56.0},
	{11,-2401.0,2360.0,5.0},
	{46,-2679.0,1933.0,217.0},
	{6,637.0,832.0,-43.0},
	{9,680.0,826.0,-39.0},
	{9,752.0,260.0,27.0},
	{1,-246.0,2725.0,63.0},
	{4,-23.0,2322.0,24.0},
	{39,15,1284.894,278.5705,19.5547},
	{30,60,2129.4,-2280.71,14.42},
	{46,-1542.857,698.4825,139.2658},
	{29,130,2198.11,-1170.22,33.5},
	{46,-225.6758,1394.256,172.0143},
	{46,-773.0379,2423.499,157.0856},
	{34,20,935.744,-926.0453,57.7642},
	{6,842.9783,-17.3791,64.2},
	{22,35,255.0493,84.0615,1002.453},
	{25,30,217.8,76.4,1005.047},
	{3,223.8347,120.4458,1010.212},
	{22,35,263.2531,109.7859,1004.625},
	{25,30,228.3176,114.433,999.0215},
	{3,247.4536,192.3085,1008.172},
	{22,35,242.613,196.3202,1008.172},
	{25,30,240.7765,196.1124,1008.172},
	{3,188.9769,158.218,1003.031},
	{46,-1753.418,885.3446,295.5166},
	{43,50,-2539.918,-598.6152,132.764},
	{43,50,-2329.984,-165.3635,35.2389},
	{43,50,-2721.241,-318.8085,7.5246},
	{43,50,-2677.102,234.9912,4.1048},
	{43,50,-2706.692,375.8728,5.0525},
	{43,50,-2550.106,657.286,14.7319},
	{43,50,-2791.248,771.5468,51.0904},
	{43,50,-1770.815,903.2556,25.3894},
	{43,50,-1713.006,1368.239,7.2664},
	{43,50,-1851.317,1302.291,60.7553},
	{43,50,-1635.026,604.4713,40.6377},
	{43,50,-1976.483,670.5043,46.6039},
	{43,50,-2038.409,1111.406,53.7928},
	{43,50,-2048.803,899.5274,53.8866},
	{43,50,-2292.47,722.5441,49.4265},
	{43,50,-1977.916,113.8457,27.1096},
	{43,50,-1528.144,160.0232,3.5142},
	{43,50,-1771.261,-597.5884,16.6287},
	{43,50,2495.807,-1700.637,1017.837},
	{15,-2677.726,-192.3469,6.8518},
	{9,-2752.243,-272.2891,6.5956},
	{15,-2617.473,-97.0801,4.003},
	{15,-2777.192,-25.2984,6.8721},
	{15,-2774.113,87.8845,6.7987},
	{15,-2770.624,389.0772,4.2818},
	{8,-2535.631,51.7034,8.6512},
	{15,-2530.958,-34.1009,25.2855},
	{15,-1691.649,946.7679,24.8084},
	{15,-2664.518,636.5673,14.2474},
	{37,2000,-601.4012,-1068.6,23.6667},
	{15,-377.2184,-1048.053,58.9125},
	{15,-45.5928,-1148.529,1.3953},
	{1,2428.499,-1679.27,13.1633},
	{16,20,2820.013,-1426.519,23.805},
	{28,60,2790.343,-1427.489,39.6258},
	{32,50,2574.065,-1134.201,64.6535},
	{22,35,2423.892,-1117.452,41.2464},
	{15,1296.155,-1081.892,26.1502},
	{15,1390.611,-800.4332,81.7795},
	{5,1308.466,2111.289,10.7221},
	{15,2183.116,2396.827,10.7722},
	{5,1081.133,1603.697,5.6},
	{4,777.8668,1948.123,5.3634},
	{26,25,1706.352,1242.019,34.2952},
	{38,200,2492.051,2398.377,4.5293},
	{35,10,2055.355,2435.356,40.3684},
	{6,1888.27,2877.262,10.1621},
	{15,1420.945,2519.882,10.6199},
	{15,1372.996,2605.758,10.8776},
	{29,70,2293.686,1982.286,31.4335},
	{8,2631.263,1722.395,11.0312},
	{15,2490.497,1522.47,10.576},
	{15,455.4583,-1485.896,30.9717},
	{38,200,244.98,1859.185,14.08},
	{32,50,2529.724,-1678.563,19.4225},
	{26,15,2254.378,-2261.689,14.3751},
	{34,20,2015.744,1004.045,39.1},
	{8,2002.263,981.3947,10.5},
	{14,1928.68,-1774.21,13.54},
	{14,1875.91,-1917.18,15.03},
	{14,2019.6,-1214.15,21.47},
	{14,2209.77,-1001.69,63.71},
	{14,1000.34,-1858.58,12.3},
	{14,911.11,-1120.31,24.03},
	{14,929.0,-750.0,105.82},
	{14,1129.09,-2052.82,69.0},
	{14,-92.74,-1425.46,12.75},
	{14,-77.65,-1167.18,2.16},
	{14,34.0,-2649.0,40.73},
	{14,-739.0,-1262.0,68.12},
	{14,-2177.0,-2423.0,30.63},
	{14,-615.0,-861.0,105.72},
	{14,-2051.0,948.0,55.4},
	{14,-2658.0,-187.0,4.18},
	{14,-2649.0,734.97,27.96},
	{14,-1791.0,481.0,25.68},
	{14,-2797.0,1182.0,20.28},
	{14,-2589.623,-16.165,3.9662},
	{14,-2865.0,690.0,23.43},
	{14,-2339.0,-453.0,80.24},
	{14,-1955.0,-748.0,36.22},
	{14,-2420.03,987.59,45.3},
	{14,-326.56,2215.37,43.57},
	{14,-1319.0,2705.0,50.27},
	{14,-2474.94,2443.52,16.03},
	{14,-1670.64,2590.49,81.37},
	{14,-892.98,1971.66,60.61},
	{14,1576.86,2837.14,10.83},
	{14,1492.72,2773.76,10.81},
	{14,2642.03,1125.74,11.03},
	{14,2025.24,661.6,10.93},
	{14,2181.82,1484.97,11.36},
	{14,2197.02,2476.33,11.0},
	{14,2212.0,2526.0,10.81},
	{14,2715.79,1109.47,6.7},
	{14,2489.25,918.28,11.02},
	{14,1472.08,1890.09,10.81},
}

for i, v in pairs(StantardWeapon) do
	local model = FoundWName(v[1])
	if(model) then
		if(#v == 4) then
			Drop({["txd"] = model, ["name"] = model, ["quality"] = math.random(0,600)}, v[2], v[3], v[4], 0, 0)
		elseif(#v == 5) then
			if(WeaponAmmo[v[1]]) then
				Drop({["txd"] = model, ["name"] = model, ["quality"] = math.random(0,600), [WeaponAmmo[v[1]]] = {["txd"] = WeaponAmmo[v[1]], ["name"] = WeaponAmmo[v[1]], ["quality"] = 450, ["count"] = v[2]}}, v[3], v[4], v[5], 0, 0)
			else
				Drop({["txd"] = model, ["name"] = model, ["quality"] = math.random(0,600)}, v[3], v[4], v[5], 0, 0)
			end
		end
	end
end




function isint(n)
  return n==math.floor(n)
end

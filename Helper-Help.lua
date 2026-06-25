script_name("Helper Help v.2.5")
script_author("[TLG] allecsei") 
script_description("Inspirat dupa Tupi & Madalin") 
script_version("v2.5")

local imgui = require 'mimgui'
local sampevents = require 'samp.events'
local inicfg = require 'inicfg'
local vkeys = require 'vkeys'
local encoding = require 'encoding'
local ffi = require 'ffi'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

-- [ VARIABILE REZERVATE PENTRU HELPER DUTY ] --
local render_font  
local isHelperDuty = false
local isFontScaleSet = false

local footerText = "{FFFFFF}Created by {00ffff}[TLG]{aa3333}allecsei" 
local headerText = "Helper Menu v2.5 - [TLG] allecsei" 

-- [ TAB NAMES ] --
local tabs = {
    "Main", "Jobs", "Vehicles", "Crates", 
    "Systems", "Businesses", "Shop", "Helper 2", "Settings"
}

local bindableKeys = {
    {name = "None", id = 0},
    {name = "CTRL", id = vkeys.VK_CONTROL},
    {name = "LCTRL", id = vkeys.VK_LCONTROL},
    {name = "RCTRL", id = vkeys.VK_RCONTROL},
    {name = "ALT", id = vkeys.VK_MENU},
    {name = "LALT", id = vkeys.VK_LMENU},
    {name = "RALT", id = vkeys.VK_RMENU},
    {name = "SHIFT", id = vkeys.VK_SHIFT},
    {name = "LSHIFT", id = vkeys.VK_LSHIFT},
    {name = "RSHIFT", id = vkeys.VK_RSHIFT},
    {name = "F1", id = vkeys.VK_F1}, {name = "F2", id = vkeys.VK_F2},
    {name = "F3", id = vkeys.VK_F3}, {name = "F4", id = vkeys.VK_F4},
    {name = "F5", id = vkeys.VK_F5}, {name = "F6", id = vkeys.VK_F6},
    {name = "F7", id = vkeys.VK_F7}, {name = "F8", id = vkeys.VK_F8},
    {name = "F9", id = vkeys.VK_F9}, {name = "F10", id = vkeys.VK_F10},
    {name = "F11", id = vkeys.VK_F11}, {name = "F12", id = vkeys.VK_F12},
    {name = "X", id = vkeys.VK_X}, {name = "Z", id = vkeys.VK_Z},
    {name = "C", id = vkeys.VK_C}, {name = "V", id = vkeys.VK_V},
    {name = "B", id = vkeys.VK_B}, {name = "N", id = vkeys.VK_N},
    {name = "M", id = vkeys.VK_M}, {name = "H", id = vkeys.VK_H},
    {name = "Y", id = vkeys.VK_Y}, {name = "U", id = vkeys.VK_U},
    {name = "I", id = vkeys.VK_I}, {name = "O", id = vkeys.VK_O},
    {name = "P", id = vkeys.VK_P}, {name = "K", id = vkeys.VK_K},
    {name = "L", id = vkeys.VK_L}, {name = "Caps Lock", id = vkeys.VK_CAPITAL},
    {name = "Tab", id = vkeys.VK_TAB}, {name = "Space", id = vkeys.VK_SPACE}
}

local keyCount = #bindableKeys
local comboStrings = {}
local comboItemsCArray = ffi.new("const char*[?]", keyCount)
for i = 1, keyCount do
    local s = ffi.new("char[?]", #bindableKeys[i].name + 1, bindableKeys[i].name)
    comboStrings[i] = s  
    comboItemsCArray[i - 1] = s
end

local function getKeyNameById(id)
    for _, k in ipairs(bindableKeys) do if k.id == id then return k.name end end
    return "None"
end

local function getKeyComboIndexById(id)
    for i, k in ipairs(bindableKeys) do if k.id == id then return i - 1 end end
    return 0
end

-- [ JOBS DATA ] --
local jobs_list = {
    "Quarry Worker", "Lumberjack", "Miner", "Garbage Man", "Bus Driver", 
    "Fisherman", "Trucker", "Farmer", "Chemist", "Detective", 
    "Transporter", "Drugs Dealer", "Car Jacker", "Car Mechanic", 
    "Arms Dealer", "Archeologist", "Electrician", "Lawyer", 
    "Pocket Thief", "Craftsman", "Firefighter", "Daily Job", "Job Clash"
}

local selected_job = 0

-- [ SYSTEMS DATA ] --
local selected_system = 0
local selected_biz = 0

-- [ VEHICLES DATA ] --
local vehiclesData = {
    {Name = "Cheetah", Price_Gold = "$695.000", Price = "$2.085.000", Gold = "2.229 Gold", Speed = "192 KM/h", Model = "Ferrari 512 TR", Seats = "2", Tune = "Transfender"},
    {Name = "Bullet", Price_Gold = "$785.000", Price = "$2.355.000", Gold = "2.849 Gold", Speed = "203 KM/h", Model = "Ford GT-40", Seats = "2", Tune = "Transfender"},
    {Name = "Infernus", Price_Gold = "$810.000", Price = "$2.430.000", Gold = "2.999 Gold", Speed = "222 KM/h", Model = "Acura NSX", Seats = "2", Tune = "Transfender"},
    {Name = "Turismo", Price_Gold = "$720.000", Price = "$2.160.000", Gold = "2.499 Gold", Speed = "193 KM/h", Model = "Ferrari F40", Seats = "2", Tune = "Transfender"},
    {Name = "Banshee", Price_Gold = "$755.000", Price = "$2.265.000", Gold = "2.599 Gold", Speed = "201 KM/h", Model = "1991 Dodge Viper", Seats = "2", Tune = "Transfender"},
    {Name = "Hotring", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.799 Gold", Speed = "214 KM/h", Model = "1987 Chevy Monte Carlo SS", Seats = "2", Tune = "Transfender"},
    {Name = "Hotring A", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.799 Gold", Speed = "214 KM/h", Model = "1985 Chevrolet Camaro", Seats = "2", Tune = "Transfender"},
    {Name = "Hotring B", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.799 Gold", Speed = "142 KM/h", Model = "1982 Ford Thunderbird", Seats = "2", Tune = "Transfender"},
    {Name = "Landstalker", Price = "$25.500", Gold = "N/A", Speed = "158 KM/h", Model = "Jeep Grand Cherokee", Seats = "4", Tune = "Transfender"},
    {Name = "Bravura", Price = "$21.450", Gold = "N/A", Speed = "147 KM/h", Model = "Oldsmobile Calais", Seats = "2", Tune = "Transfender"},
    {Name = "Buffalo", Price_Gold = "$260.000", Price = "$1.950.000", Gold = "2.149 Gold", Speed = "186 KM/h", Model = "Chevrolet Camaro", Seats = "2", Tune = "Transfender"},
    {Name = "Perennial", Price = "$4.500", Gold = "N/A", Speed = "133 KM/h", Model = "Ford Falcon Wagon", Seats = "4", Tune = "Transfender"},
    {Name = "Sentinel", Price = "$1.605.000", Gold = "N/A", Speed = "164 KM/h", Model = "1991 BMW 525i", Seats = "4", Tune = "Transfender"},
    {Name = "Stretch", Price = "$607.500", Gold = "N/A", Speed = "168 KM/h", Model = "Lincoln Town Car", Seats = "4", Tune = "Transfender"},
    {Name = "Manana", Price = "$15.975", Gold = "N/A", Speed = "130 KM/h", Model = "Dodge Aries", Seats = "2", Tune = "Transfender"},
    {Name = "Voodoo", Price = "$825.000", Gold = "N/A", Speed = "168 KM/h", Model = "1960 Chevrolet Impala", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Pony", Price = "$6.150", Gold = "N/A", Speed = "110 KM/h", Model = "Ford E-Series", Seats = "4", Tune = "Transfender"},
    {Name = "Moonbeam", Price = "$4.950", Gold = "N/A", Speed = "115 KM/h", Model = "Chevrolet Astrovan", Seats = "4", Tune = "Transfender"},
    {Name = "Esperanto", Price = "$150.000", Gold = "N/A", Speed = "149 KM/h", Model = "Cadillac Eldorado", Seats = "2", Tune = "Transfender"},
    {Name = "Washington", Price = "$333.000", Gold = "N/A", Speed = "154 KM/h", Model = "1982 Lincoln Continental", Seats = "4", Tune = "Transfender"},
    {Name = "Bobcat", Price = "$7.500", Gold = "N/A", Speed = "140 KM/h", Model = "GMC", Seats = "2", Tune = "Transfender"},
    {Name = "BF Injection", Price = "$202.500", Gold = "N/A", Speed = "135 KM/h", Model = "Volkswagen Beach Buggy", Seats = "2", Tune = "Transfender"},
    {Name = "Premier", Price_Gold = "$94.500", Price = "$283.500", Gold = "299 Gold", Speed = "173 KM/h", Model = "1991 Chevrolet Caprice", Seats = "4", Tune = "Transfender"},
    {Name = "Hotknife", Price = "$1.702.500", Gold = "N/A", Speed = "167 KM/h", Model = "1932 Ford (Custom)", Seats = "2", Tune = "Transfender"},
    {Name = "Previon", Price = "$79.500", Gold = "N/A", Speed = "149 KM/h", Model = "1988 Nissan Pulsar", Seats = "2", Tune = "Transfender"},
    {Name = "Stallion", Price = "$255.000", Gold = "N/A", Speed = "168 KM/h", Model = "Ford Mustang", Seats = "2", Tune = "Transfender"},
    {Name = "Rumpo", Price = "$5.700", Gold = "N/A", Speed = "136 KM/h", Model = "Peugeot J5", Seats = "4", Tune = "Transfender"},
    {Name = "Romero", Price = "$577.500", Gold = "N/A", Speed = "139 KM/h", Model = "Cadillac Superior Sovereign", Seats = "2", Tune = "Transfender"},
    {Name = "Admiral", Price = "$675.000", Gold = "N/A", Speed = "164 KM/h", Model = "Mercedes Benz 300d", Seats = "4", Tune = "Transfender"},
    {Name = "Solair", Price = "$187.500", Gold = "N/A", Speed = "157 KM/h", Model = "1992 Honda Accord", Seats = "4", Tune = "Transfender"},
    {Name = "Glendale", Price = "$11.700", Gold = "N/A", Speed = "147 KM/h", Model = "1961 Dodge Sedan", Seats = "4", Tune = "Transfender"},
    {Name = "Oceanic", Price = "$49.500", Gold = "N/A", Speed = "140 KM/h", Model = "1958 Dodge Coronet", Seats = "4", Tune = "Transfender"},
    {Name = "Hermes", Price = "$12.375", Gold = "N/A", Speed = "149 KM/h", Model = "1948 Mercury (Custom)", Seats = "2", Tune = "Transfender"},
    {Name = "Sabre", Price_Gold = "$190.000", Price = "$1.425.000", Gold = "1.699 Gold", Speed = "173 KM/h", Model = "1969 Oldsmobile Cutlass", Seats = "2", Tune = "Transfender"},
    {Name = "ZR-350", Price = "$1.777.500", Gold = "N/A", Speed = "186 KM/h", Model = "Mazda RX7", Seats = "2", Tune = "Transfender"},
    {Name = "Walton", Price = "$6.600", Gold = "N/A", Speed = "118 KM/h", Model = "1956 Chevrolet Task Force", Seats = "2", Tune = "Transfender"},
    {Name = "Regina", Price = "$235.500", Gold = "N/A", Speed = "140 KM/h", Model = "Ford LTD Wagon", Seats = "4", Tune = "Transfender"},
    {Name = "Comet", Price_Gold = "$607.500", Price = "$1.822.500", Gold = "1.949 Gold", Speed = "184 KM/h", Model = "Porsche 911", Seats = "2", Tune = "Transfender"},
    {Name = "Burrito", Price = "$36.000", Gold = "N/A", Speed = "157 KM/h", Model = "GMC G15 Vandura", Seats = "4", Tune = "Transfender"},
    {Name = "Camper", Price = "$90.000", Gold = "N/A", Speed = "123 KM/h", Model = "Volkswagen Transporter", Seats = "3", Tune = "Transfender"},
    {Name = "Majestic", Price = "$367.500", Gold = "N/A", Speed = "156 KM/h", Model = "1985 Buick Regal", Seats = "2", Tune = "Transfender"},
    {Name = "Sandking", Price_Gold = "$588.000", Price = "$1.380.000", Gold = "1.599 Gold", Speed = "176 KM/h", Model = "1985 Mitsubishi Pajero", Seats = "2", Tune = "Transfender"},
    {Name = "Blista Compact", Price = "$124.500", Gold = "N/A", Speed = "161 KM/h", Model = "1985 Honda CRX", Seats = "2", Tune = "Transfender"},
    {Name = "Mesa", Price = "$562.500", Gold = "N/A", Speed = "140 KM/h", Model = "Jeep Wrangler", Seats = "2", Tune = "Transfender"},
    {Name = "Super GT", Price_Gold = "$588.000", Price = "$1.764.000", Gold = "1.899 Gold", Speed = "179 KM/h", Model = "Mitsubishi 300GT", Seats = "2", Tune = "Transfender"},
    {Name = "Elegant", Price = "$795.000", Gold = "N/A", Speed = "166 KM/h", Model = "Buick Roadmaster", Seats = "4", Tune = "Transfender"},
    {Name = "Journey", Price = "$105.000", Gold = "N/A", Speed = "108 KM/h", Model = "Chevrolet Winnebago", Seats = "2", Tune = "Transfender"},
    {Name = "Buccaneer", Price = "$180.000", Gold = "N/A", Speed = "164 KM/h", Model = "1970 Chevrolet Monte Carlo", Seats = "2", Tune = "Transfender"},
    {Name = "Cadrona", Price = "$30.000", Gold = "N/A", Speed = "149 KM/h", Model = "1989 Chevrolet Z24", Seats = "2", Tune = "Transfender"},
    {Name = "Willard", Price = "$222.000", Gold = "N/A", Speed = "149 KM/h", Model = "1991 Dodge Dynasty", Seats = "4", Tune = "Transfender"},
    {Name = "Feltzer", Price_Gold = "$312.500", Price = "$937.500", Gold = "999 Gold", Speed = "167 KM/h", Model = "1990 Mercedes Benz SL", Seats = "2", Tune = "Transfender"},
    {Name = "Remington", Price = "$1.072.500", Gold = "N/A", Speed = "168 KM/h", Model = "1977 Lincoln Continental", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Slamvan", Price = "$1.005.000", Gold = "N/A", Speed = "158 KM/h", Model = "Dodge Sidewinder (Custom)", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Blade", Price = "$1.305.000", Gold = "N/A", Speed = "173 KM/h", Model = "1965 Chevrolet Impala", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Vincent", Price = "$232.500", Gold = "N/A", Speed = "149 KM/h", Model = "BMW E36 5 Series", Seats = "4", Tune = "Transfender"},
    {Name = "Clover", Price = "$135.000", Gold = "N/A", Speed = "164 KM/h", Model = "1969 Ford Torino", Seats = "2", Tune = "Transfender"},
    {Name = "Sadler", Price = "$33.000", Gold = "N/A", Speed = "151 KM/h", Model = "1971 Ford F-250", Seats = "2", Tune = "Transfender"},
    {Name = "Hustler", Price = "$600.000", Gold = "N/A", Speed = "147 KM/h", Model = "Ford Hotrod", Seats = "2", Tune = "Transfender"},
    {Name = "Intruder", Price = "$195.000", Gold = "N/A", Speed = "149 KM/h", Model = "1991 Chevrolet Lumina", Seats = "4", Tune = "Transfender"},
    {Name = "Tampa", Price = "$13.500", Gold = "N/A", Speed = "153 KM/h", Model = "1966 Chevrolet Corvair", Seats = "2", Tune = "Transfender"},
    {Name = "Sunrise", Price = "$112.500", Gold = "N/A", Speed = "145 KM/h", Model = "1991 Honda Accord", Seats = "4", Tune = "Transfender"},
    {Name = "Merit", Price = "$772.500", Gold = "N/A", Speed = "157 KM/h", Model = "1992 Mercury Grand Marquis", Seats = "4", Tune = "Transfender"},
    {Name = "Yosemite", Price = "$172.500", Gold = "N/A", Speed = "144 KM/h", Model = "1998 Chevrolet Silverado", Seats = "4", Tune = "Transfender"},
    {Name = "Windsor", Price = "$810.000", Gold = "N/A", Speed = "158 KM/h", Model = "1966 Jaguar XKE", Seats = "2", Tune = "Transfender"},
    {Name = "Uranus", Price = "$982.500", Gold = "N/A", Speed = "156 KM/h", Model = "1991 Mitsubishi Eclipse", Seats = "2", Tune = "Wheel Arch Angels"},
    {Name = "Jester", Price_Gold = "$557.500", Price = "$1.672.500", Gold = "1.799 Gold", Speed = "178 KM/h", Model = "Toyota Supra", Seats = "2", Tune = "Wheel Arch Angels"},
    {Name = "Sultan", Price_Gold = "$675.000", Price = "$2.025.000", Gold = "2.199 Gold", Speed = "169 KM/h", Model = "Subaru Impreza", Seats = "4", Tune = "Wheel Arch Angels"},
    {Name = "Stratum", Price = "$960.000", Gold = "N/A", Speed = "154 KM/h", Model = "Ford Taurus Wagon", Seats = "4", Tune = "Wheel Arch Angels"},
    {Name = "Elegy", Price_Gold = "$632.500", Price = "$1.897.500", Gold = "2.099 Gold", Speed = "178 KM/h", Model = "Nissan Skyline R33", Seats = "2", Tune = "Wheel Arch Angels"},
    {Name = "Flash", Price = "$1.500.000", Gold = "N/A", Speed = "165 KM/h", Model = "1990 Honda Civic", Seats = "2", Tune = "Wheel Arch Angels"},
    {Name = "Tahoma", Price = "$412.500", Gold = "N/A", Speed = "160 KM/h", Model = "6th Pontiac Bonneville", Seats = "4", Tune = "Loco Low Co."},
    {Name = "Savanna", Price_Gold = "$395.000", Price = "$1.185.000", Gold = "1.499 Gold", Speed = "173 KM/h", Model = "1964 Chevrolet Imala", Seats = "4", Tune = "Loco Low Co."},
    {Name = "Broadway", Price = "$877.500", Gold = "N/A", Speed = "158 KM/h", Model = "1948 Cadillac", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Tornado", Price = "$75.000", Gold = "N/A", Speed = "158 KM/h", Model = "1960 Chevrolet Bel Air", Seats = "2", Tune = "Loco Low Co."},
    {Name = "Huntley", Price_Gold = "$350.000", Price = "$1.050.000", Gold = "1.299 Gold", Speed = "158 KM/h", Model = "Range Rover", Seats = "4", Tune = "Transfender"},
    {Name = "Stafford", Price = "$450.000", Gold = "N/A", Speed = "153 KM/h", Model = "1974 Rolls Royce Shadow", Seats = "4", Tune = "Transfender"},
    {Name = "Emperor", Price = "$123.000", Gold = "N/A", Speed = "153 KM/h", Model = "Jaguar XJ6", Seats = "4", Tune = "Transfender"},
    {Name = "Euros", Price = "$1.110.000", Gold = "N/A", Speed = "165 KM/h", Model = "Nissan 300ZX", Seats = "2", Tune = "Transfender"},
    {Name = "Club", Price = "$295.500", Gold = "N/A", Speed = "163 KM/h", Model = "Volkswagen Golf", Seats = "2", Tune = "Transfender"},
    {Name = "Picador", Price = "$238.500", Gold = "N/A", Speed = "151 KM/h", Model = "1968 Chevrolet El Camino", Seats = "2", Tune = "Transfender"},
    {Name = "Alpha", Price = "$1.560.000", Gold = "N/A", Speed = "169 KM/h", Model = "Mitsubishi 300GT", Seats = "2", Tune = "Transfender"},
    {Name = "Phoenix", Price_Gold = "$96.500", Price = "$289.500", Gold = "349 Gold", Speed = "171 KM/h", Model = "1979 Pontiac Trans Am", Seats = "2", Tune = "Transfender"},
    {Name = "Nebula", Price = "$411.000", Gold = "N/A", Speed = "157 KM/h", Model = "1987 Buick Century", Seats = "4", Tune = "Transfender"},
    {Name = "Primo", Price = "$283.500", Gold = "N/A", Speed = "143 KM/h", Model = "1987 Toyota Corolla", Seats = "4", Tune = "Transfender"},
    {Name = "Fortune", Price = "$475.500", Gold = "N/A", Speed = "158 KM/h", Model = "1992 Ford Thunderbird", Seats = "2", Tune = "Transfender"},
    {Name = "Greenwood", Price = "$345.000", Gold = "N/A", Speed = "140 KM/h", Model = "Chrysler Fifth Avenue", Seats = "4", Tune = "Transfender"},
    {Name = "Virgo", Price = "$241.500", Gold = "N/A", Speed = "149 KM/h", Model = "1977 Mercury Cougar", Seats = "2", Tune = "Transfender"},
    {Name = "Rancher", Price = "$1.147.500", Gold = "N/A", Speed = "139 KM/h", Model = "1973 Chevrolet Blazer", Seats = "2", Tune = "Transfender"},
    {Name = "Mr Whoopee", Price = "$750.000", Gold = "N/A", Speed = "98 KM/h", Model = "Chevrolet Step Van", Seats = "2", Tune = "Transfender"},
    {Name = "Packer", Price = "$3.720.000", Gold = "N/A", Speed = "126 KM/h", Model = "Peterbilt", Seats = "2", Tune = "Transfender"},
    {Name = "Caddy", Price = "$825.000", Gold = "N/A", Speed = "95 KM/h", Model = "Club Car Golf Cart", Seats = "2", Tune = "Transfender"},
    {Name = "Baggage", Price = "$825.000", Gold = "N/A", Speed = "99 KM/h", Model = "Clark CT Tractor", Seats = "1", Tune = "N/A"},
    {Name = "Bloodring Banger", Price = "$1.200.000", Gold = "N/A", Speed = "173 KM/h", Model = "1961 Dodge Polara", Seats = "2", Tune = "Transfender"},
    {Name = "Forklift", Price = "$585.000", Gold = "N/A", Speed = "60 KM/h", Model = "Necunoscut", Seats = "1", Tune = "Transfender"},
    {Name = "Kart", Price = "$780.000", Gold = "N/A", Speed = "93 KM/h", Model = "Necunoscut", Seats = "1", Tune = "Transfender"},
    {Name = "Mower", Price = "$795.000", Gold = "N/A", Speed = "60 KM/h", Model = "1992 John Deere", Seats = "1", Tune = "Transfender"},
    {Name = "Sweeper", Price = "$765.000", Gold = "N/A", Speed = "60 KM/h", Model = "Necunoscut", Seats = "1", Tune = "Transfender"},
    {Name = "Tug", Price = "$772.500", Gold = "N/A", Speed = "85 KM/h", Model = "Clark CT-50", Seats = "1", Tune = "Transfender"},
    {Name = "Hotdog", Price = "$885.000", Gold = "N/A", Speed = "108 KM/h", Model = "1964 Dodge A100", Seats = "2", Tune = "Transfender"},
    {Name = "Bandito", Price = "$375.000", Gold = "N/A", Speed = "146 KM/h", Model = "Necunoscut", Seats = "1", Tune = "Transfender"},
    {Name = "Monster Truck", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.499 Gold", Speed = "110 KM/h", Model = "Necunoscut", Seats = "2", Tune = "Transfender"},
    {Name = "Monster Truck A", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.499 Gold", Speed = "110 KM/h", Model = "Necunoscut", Seats = "2", Tune = "Transfender"},
    {Name = "Monster Truck B", Price_Gold = "$1.150.000", Price = "$12.000.000", Gold = "3.499 Gold", Speed = "110 KM/h", Model = "Necunoscut", Seats = "2", Tune = "Transfender"},
    {Name = "RC Raider", Price = "$22.500", Gold = "N/A", Speed = "40 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "RC Cam", Price = "$22.500", Gold = "N/A", Speed = "60 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "RC Tiger", Price = "$22.500", Gold = "N/A", Speed = "88 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "RC Bandit", Price = "$22.500", Gold = "N/A", Speed = "75 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "RC Goblin", Price = "$22.500", Gold = "N/A", Speed = "30 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Freeway", Price_Gold = "$207.500", Price = "$622.500", Gold = "649 Gold", Speed = "157 KM/h", Model = "Harley-Davidson", Seats = "2", Tune = "N/A"},
    {Name = "PCJ-600", Price = "$307.500", Gold = "N/A", Speed = "171 KM/h", Model = "'80s Suzuki GSX", Seats = "2", Tune = "N/A"},
    {Name = "Faggio", Price = "$2.250", Gold = "N/A", Speed = "122 KM/h", Model = "Piaggio", Seats = "2", Tune = "N/A"},
    {Name = "Sanchez", Price = "$481.500", Gold = "N/A", Speed = "157 KM/h", Model = "Yamaha DT 200", Seats = "2", Tune = "N/A"},
    {Name = "Quad", Price = "$8.325", Gold = "N/A", Speed = "110 KM/h", Model = "Yamaha Breeze", Seats = "2", Tune = "N/A"},
    {Name = "Bike", Price = "$725", Gold = "N/A", Speed = "83 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "BMX", Price = "$1.500", Gold = "N/A", Speed = "100 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Mountain bike", Price = "$750", Gold = "N/A", Speed = "90 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "FCR-900",Price_Gold = "$305.000", Price = "$915.000", Gold = "899 Gold", Speed = "176 KM/h", Model = "Ducatti 900 SS", Seats = "2", Tune = "N/A"},
    {Name = "NRG-500",Price_Gold = "$575.000", Price = "$1.725.000", Gold = "1.899 Gold", Speed = "191 KM/h", Model = "Honda NSR500", Seats = "2", Tune = "N/A"},
    {Name = "BF-400", Price = "$213.000", Gold = "N/A", Speed = "159 KM/h", Model = "Suzuki Bandit", Seats = "2", Tune = "N/A"},
    {Name = "Wayfarer", Price = "$8.700", Gold = "N/A", Speed = "157 KM/h", Model = "Honda Gold Wing", Seats = "2", Tune = "N/A"},
    {Name = "Squalo", Price = "$1.695.000", Gold = "N/A", Speed = "226 KM/h", Model = "Chris-Craft Stinger", Seats = "1", Tune = "N/A"},
    {Name = "Speeder", Price = "$525.000", Gold = "N/A", Speed = "153 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Reefer", Price = "$720.000", Gold = "N/A", Speed = "60 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Tropic", Price = "$847.500", Gold = "N/A", Speed = "131 KM/h", Model = "Chris-Craft Corinthian", Seats = "1", Tune = "N/A"},
    {Name = "Dinghy", Price = "$9.600", Gold = "N/A", Speed = "107 KM/h", Model = "Zodiac Classic II", Seats = "1", Tune = "N/A"},
    {Name = "Marquis", Price = "$315.000", Gold = "N/A", Speed = "62 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Jetmax", Price = "$1.215.000", Gold = "N/A", Speed = "174 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Launch", Price = "$934.500", Gold = "N/A", Speed = "113 KM/h", Model = "Necunoscut", Seats = "1", Tune = "N/A"},
    {Name = "Shamal", Price = "$15.000.000", Gold = "N/A", Speed = "270 KM/h", Model = "Gulfstream G650", Seats = "1", Tune = "N/A"},
    {Name = "Stuntplane", Price = "$4.500.000", Gold = "N/A", Speed = "160 KM/h", Model = "Pitts Special S-1", Seats = "1", Tune = "N/A"},
    {Name = "Sparrow", Price_Gold = "$710.000", Price = "$9.000.000", Gold = "2.399 Gold", Speed = "133 KM/h", Model = "Bell 47", Seats = "2", Tune = "N/A"},
    {Name = "Maverick", Price_Gold = "$1.875.000", Price = "$12.000.000", Gold = "4.999 Gold", Speed = "180 KM/h", Model = "Bell Long Ranger", Seats = "4", Tune = "N/A"},
    {Name = "Dune", Price = "$25.000.000", Gold = "5.000 Gold", Speed = "110 KM/h", Model = "KAMAZ 4991 Rally Truck", Seats = "2", Tune = "Transfender"},
    {Name = "Flatbed", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "157 KM/h", Model = "M-939 US Army Truck", Seats = "2", Tune = "Transfender"},
    {Name = "Coach", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "157 KM/h", Model = "1990s MCI 102", Seats = "8", Tune = "Transfender"},
    {Name = "Roadtrain", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "142 KM/h", Model = "4964 Heritage", Seats = "2", Tune = "Transfender"},
    {Name = "DFT-30", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "130 KM/h", Model = "Ford Cargo", Seats = "2", Tune = "Transfender"},
    {Name = "Tractor", Price = "$25.000.000", Gold = "5.000 Gold", Speed = "70 KM/h", Model = "Ford N Series", Seats = "1", Tune = "Transfender"},
    {Name = "Securicar", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "157 KM/h", Model = "1990 GMC TopKick", Seats = "4", Tune = "Transfender"},
    {Name = "Raindance", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "160 KM/h", Model = "UH-60 Black Hawk", Seats = "2", Tune = "Nu este tunabil"},
    {Name = "Leviathan", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "102 KM/h", Model = "Sikorsky SH-3 Sea King", Seats = "2", Tune = "Nu este tunabil"},
    {Name = "Petrol Trailer", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "0 KM/h", Model = "Necunoscut", Seats = "0", Tune = "Nu este tunabil"},
    {Name = "Article Trailer", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "0 KM/h", Model = "Necunoscut", Seats = "0", Tune = "Nu este tunabil"},
    {Name = "Dozer", Price = "$25.000.000", Gold = "5.000 Gold", Speed = "40 KM/h", Model = "Necunoscut", Seats = "1", Tune = "Nu"},
    {Name = "Linerunner", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "110 KM/h", Model = "Kenworth W900L", Seats = "2", Tune = "Transfender"},
    {Name = "Tanker", Price = "$30.000.000", Gold = "6.000 Gold", Speed = "120 KM/h", Model = "International Paystar", Seats = "2", Tune = "Transfender"},
    {Name = "Christmas Sabre", Price = "$0", Gold = "N/A", Speed = "173 KM/h", Model = "1969 Oldsmobile Cutlass", Seats = "2", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade! (Christmas Quest)"},
    {Name = "Halloween Willard", Price = "$0", Gold = "N/A", Speed = "149 KM/h", Model = "1991 Dodge Dynasty", Seats = "4", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade!(Halloween Event)"},
    {Name = "Easter Alpha", Price = "$0", Gold = "N/A", Speed = "169 KM/h", Model = "Mitsubishi 300GT", Seats = "2", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade! (Easter Quest)"},
    {Name = "Season 20 Voodoo", Price = "$0", Gold = "N/A", Speed = "168 KM/h", Model = "1960 Chevrolet Impala", Seats = "2", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade! (Maraton Season 20)"},
    {Name = "Season 21 Broadway", Price = "$0", Gold = "N/A", Speed = "158 KM/h", Model = "1948 Cadillac", Seats = "2", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade! (Maraton Season 21)"},
    {Name = "Killer Clown Stuntplane", Price = "$0", Gold = "N/A", Speed = "160 KM/h", Model = "Pitts Special S-1", Seats = "1", Tune = "Nu este tunabil", Source = "Se poate de achizitionat de la jucatori prin /trade!"},
    {Name = "Ghost Rider Freeway", Price = "$0", Gold = "N/A", Speed = "157 KM/h", Model = "Harley-Davidson", Seats = "2", Tune = "Nu este tunabil", Source = "Nu se poate de achizitionat / vandut!"},
    {Name = "Spooky Tornado", Price = "$0", Gold = "N/A", Speed = "158 KM/h", Model = "1960 Chevrolet Bel Air", Seats = "2", Tune = "Nu este tunabil", Source = "Nu se poate de achizitionat / vandut!"},
    {Name = "Union Patriot", Price = "$0", Gold = "N/A", Speed = "157 KM/h", Model = "Humvee", Seats = "4", Tune = "Nu", Source = "Se poate de achizitionat de la jucatori prin /trade!"},
    {Name = "Jinx Linerunner", Price = "$0", Gold = "N/A", Speed = "110 KM/h", Model = "Kenworth W900L", Seats = "2", Tune = "Nu", Source = "Nu se poate de achizitionat / vandut!"},
    {Name = "Anniversary Trailer", Price = "$0", Gold = "N/A", Speed = "0 KM/h", Model = "Trailer", Seats = "0", Tune = "Nu", Source = "Nu se poate de achizitionat / vandut!"},
    {Name = "Haunted Hotknife", Price = "$0", Gold = "N/A", Speed = "167 KM/h", Model = "1932 Ford (Custom)", Seats = "2", Tune = "Nu", Source = "Nu se poate de achizitionat / vandut!"},
    {Name = "E30 Vincent", Price = "$0", Gold = "N/A", Speed = "149 KM/h", Model = "BMW E30", Seats = "4", Tune = "Nu", Source = "Nu se poate de achizitionat / vandut!"}
}

local vehicle_categories = {
    { name = "Cars", items = { "Cheetah", "Bullet", "Infernus", "Turismo", "Banshee", "Hotring", "Hotring A", "Hotring B", "Landstalker", "Bravura", "Buffalo", "Perennial", "Sentinel", "Stretch", "Manana", "Voodoo", "Pony", "Moonbeam", "Esperanto", "Washington", "Bobcat", "BF Injection", "Premier", "Hotknife", "Previon", "Stallion", "Rumpo", "Romero", "Admiral", "Solair", "Glendale", "Oceanic", "Hermes", "Sabre", "ZR-350", "Walton", "Regina", "Comet", "Burrito", "Camper", "Majestic", "Sandking", "Blista Compact", "Mesa", "Super GT", "Elegant", "Journey", "Buccaneer", "Cadrona", "Willard", "Feltzer", "Remington", "Slamvan", "Blade", "Vincent", "Clover", "Sadler", "Hustler", "Intruder", "Tampa", "Sunrise", "Merit", "Yosemite", "Windsor", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Flash", "Tahoma", "Savanna", "Broadway", "Tornado", "Huntley", "Stafford", "Emperor", "Euros", "Club", "Picador", "Alpha", "Phoenix", "Nebula", "Primo", "Fortune", "Greenwood", "Virgo", "Rancher" } },   
    { name = "Bikes & Moto", items = { "Freeway", "PCJ-600", "Faggio", "Sanchez", "Quad", "Bike", "BMX", "Mountain bike", "FCR-900", "NRG-500", "BF-400", "Wayfarer" } },
    { name = "Aircrafts", items = { "Shamal", "Stuntplane", "Sparrow", "Maverick", "Raindance", "Leviathan" } },
    { name = "Boats", items = { "Squalo", "Speeder", "Reefer", "Tropic", "Dinghy", "Marquis", "Jetmax", "Launch" } },
    { name = "Specials", items = { "Mr Whoopee", "Packer", "Caddy", "Baggage", "Bloodring Banger", "Forklift", "Kart", "Mower", "Sweeper", "Tug", "Hotdog", "Bandito", "Monster Truck", "Monster Truck A", "Monster Truck B", "RC Raider", "RC Cam", "RC Tiger", "RC Bandit", "RC Goblin" } },
    { name = "Decorated Cars", items = { "Christmas Sabre", "Halloween Willard", "Easter Alpha", "Season 20 Voodoo", "Season 21 Broadway", "Killer Clown Stuntplane", "Ghost Rider Freeway", "Spooky Tornado", "Union Patriot", "Jinx Linerunner", "Anniversary Trailer", "Haunted Hotknife", "E30 Vincent" } },
    { name = "Shop Cars", items = { "Dune", "Flatbed", "Coach", "Roadtrain", "DFT-30", "Tractor", "Securicar", "Dozer", "Tanker", "Linerunner", "Petrol Trailer", "Article Trailer" } },
    
}

local selected_category = 0
local selected_vehicle_name = ""

-- [ CRATES DATA ] --
local cratesData = {
    {name = "Red Crate", color = imgui.ImVec4(0.9, 0.2, 0.2, 1.0), priceGold = "70 Gold", priceMP = "60 MP", items = {
        "Premium Account - 1 - Chance: 40'/.",
        "3 days - Chance: 30'/.",
        "1 week - Chance: 15'/.",        
        "2 weeks - Chance: 10'/.",
        "1 month - Chance: 5'/."
    }},
    {name = "Orange Crate", color = imgui.ImVec4(0.9, 0.5, 0.1, 1.0), priceGold = "200 Gold", priceMP = "150 MP", items = {
        "Respect Points - 1 RP - Chance: 40'/.",
        "5 RP - Chance: 30'/.",
        "10 RP - Chance: 15'/.",
        "13 RP - Chance: 10'/.",
        "15 RP - Chance: 5'/."
    }},
    {name = "Green Crate", color = imgui.ImVec4(0.2, 0.8, 0.2, 1.0), priceGold = "150 Gold", priceMP = "100 MP", items = {
        "Drugs - 100 - Chance: 40'/.",
        "200 - Chance: 30'/.",
        "300 - Chance: 15'/.",
        "500 - Chance: 10'/.",
        "1000 - Chance: 5'/."
    }},
    {name = "Cyan Crate", color = imgui.ImVec4(0.1, 0.8, 0.8, 1.0), priceGold = "200 Gold", priceMP = "150 MP", items = {
        "Vehicles: Tampa - Chance: 40'/.",
        "Landstalker - Chance: 30'/.",
        "Tornado - Chance: 15'/.",
        "Flash - Chance: 10'/.",
        "Sultan - Chance: 5'/."
    }},
    {name = "Yellow Crate", color = imgui.ImVec4(0.9, 0.9, 0.1, 1.0), priceGold = "300 Gold", priceMP = "200 MP", items = {
        "Vehicles: Stafford - Chance: 40'/.",
        "Stretch - Chance: 30'/.",
        "Merit - Chance: 15'/.",
        "Jester - Chance: 10'/.",
        "Cheetah - Chance: 5'/."
    }},
    {name = "Purple Crate", color = imgui.ImVec4(0.6, 0.2, 0.8, 1.0), priceGold = "300 Gold", priceMP = "200 MP", items = {
        "Vehicles: Premier - Chance: 40'/.",
        "Mesa - Chance: 30'/.",
        "Voodoo - Chance: 15'/.",
        "NRG-500 - Chance: 10'/.",
        "Turismo - Chance: 5'/."
    }},
    {name = "Silver Crate", color = imgui.ImVec4(0.7, 0.7, 0.7, 1.0), priceGold = "400 Gold", priceMP = "250 MP", items = {
        "Vehicles: Stafford - Chance: 40'/.",
        "Admiral - Chance: 30'/.",
        "FCR-900 - Chance: 15'/.",
        "Super GT - Chance: 10'/.",
        "Banshee - Chance: 5'/."
    }},
    {name = "Blue Crate", color = imgui.ImVec4(0.2, 0.4, 0.9, 1.0), priceGold = "400 Gold", priceMP = "250 MP", items = {
        "Vehicles: Tahoma - Chance: 40'/.",
        "Freeway - Chance: 30'/.",
        "Savanna - Chance: 15'/.",
        "Comet - Chance: 10'/.",
        "Bullet - Chance: 5'/."
    }},
    {name = "Brown Crate", color = imgui.ImVec4(0.5, 0.3, 0.2, 1.0), priceGold = "400 Gold", priceMP = "250 MP", items = {
        "Vehicles: Greenwood - Chance: 40'/.",
        "Hustler - Chance: 30'/.",
        "Rancher - Chance: 15'/.",
        "Elegy - Chance: 10'/.",
        "Infernus - Chance: 5'/."
    }},
    {name = "Magenta Crate", color = imgui.ImVec4(0.8, 0.2, 0.6, 1.0), priceGold = "600 Gold", priceMP = "350 MP", items = {
        "Vehicles: Nebula - Chance: 40'/.",
        "Stretch - Chance: 30'/.",
        "Euros - Chance: 15'/.",
        "ZR-350 - Chance: 10'/.",
        "Packer - Chance: 5'/."
    }},
    {name = "Pink Crate", color = imgui.ImVec4(0.9, 0.5, 0.7, 1.0), priceGold = "700 Gold", priceMP = "400 MP", items = {
        "Vehicles: Fortune - Chance: 40'/.",
        "Hustler - Chance: 30'/.",
        "Bloodring Banger - Chance: 15'/.",
        "Buffalo - Chance: 10'/.",
        "Stuntplane - Chance: 5'/."
    }},
    {name = "White Crate", color = imgui.ImVec4(0.9, 0.9, 0.9, 1.0), priceGold = "250 Gold", priceMP = "150 MP", items = {
        "Bronze Skin - Chance: 40'/.",
        "Bronze Skin - Chance: 30'/.",
        "Bronze Skin - Chance: 15'/.",
        "Silver Skin - Chance: 10'/.",
        "Silver Skin - Chance: 5'/."
    }},
    {name = "Olive Crate", color = imgui.ImVec4(0.5, 0.6, 0.3, 1.0), priceGold = "450 Gold", priceMP = "250 MP", items = {
        "Bronze Skin - Chance: 40'/.",
        "Bronze Skin - Chance: 30'/.",
        "Bronze Skin - Chance: 15'/.",
        "Silver Skin - Chance: 10'/.",
        "Platinum Skin - Chance: 5'/."
    }},
    {name = "Lime Crate", color = imgui.ImVec4(0.5, 0.9, 0.2, 1.0), priceGold = "350 Gold", priceMP = "350 MP", items = {
        "Respect Points - 15 - Chance: 40'/.",
        "150 Cotton Materials - Chance: 30'/.",
        "$70,000 - Chance: 15'/.",
        "Diamond, Onyx Fragment - Chance: 10'/.",
    }}
}

local openedCrates = {}
for _, crate in ipairs(cratesData) do
    openedCrates[crate.name] = false
end


-- [ CONFIGURATION ] --
local directIni = "HelperHelp.ini"
local iniData = inicfg.load({
    settings = {
        theme = 1,
        style = 1,
        border_size = 1.0,
        frame_border = 1.0,
        win_alpha = 0.95,
        global_scale = 1.0,
        cmd = "hcmd",
        key2 = vkeys.VK_F3,
        hduty_x = 1650.0,
        hduty_y = 2.5,
        lang = 0 -- 0 = Romana, 1 = Engleza  
    }
}, directIni)
inicfg.save(iniData, directIni)

-- [ WINDOW STATES ] --
local WinState = imgui.new.bool(false)
local search_buffer = imgui.new.char[256]('')
local active_tab = 1

-- Adauga aceste randuri pentru limba:
local langItems = {"Romana", "English"}
local combo_lang = imgui.new.int(iniData.settings.lang)

local slider_border = imgui.new.float(iniData.settings.border_size)
local slider_frame_border = imgui.new.float(iniData.settings.frame_border)
local slider_alpha = imgui.new.float(iniData.settings.win_alpha)
local slider_scale = imgui.new.float(iniData.settings.global_scale)

-- [ BUFFERE NOI PENTRU POZITIE HELPER DUTY ] --
local slider_hduty_x = imgui.new.float(iniData.settings.hduty_x)
local slider_hduty_y = imgui.new.float(iniData.settings.hduty_y)

-- Buffere mimgui specializate pentru bind-uri
local cmd_buffer = imgui.new.char[64](iniData.settings.cmd)
local combo_key2 = imgui.new.int(getKeyComboIndexById(iniData.settings.key2))

-- [ BUTTON STYLE HELPERS ] --
local function buttonBlack(label, size)
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 1))
    local result = imgui.Button(label, size)
    imgui.PopStyleColor()
    return result
end

local function radioButtonBoolWhite(label, active)
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))
    local result = imgui.RadioButtonBool(label, active)
    imgui.PopStyleColor()
    return result
end

-- [ HELPER PENTRU TEXT COLOREAT STIL SAMP ] --
local function renderSampColoredText(text)
    for color, content in text:gmatch("{(%x%x%x%x%x%x)}([^{]*)") do
        local r = tonumber(color:sub(1, 2), 16) / 255
        local g = tonumber(color:sub(3, 4), 16) / 255
        local b = tonumber(color:sub(5, 6), 16) / 255
        
        if content ~= "" then
            imgui.TextColored(imgui.ImVec4(r, g, b, 1.0), content)
            imgui.SameLine(0, 0)
        end
    end
    imgui.NewLine()
end

local function getCleanTextWidth(text)
    local cleanStr = text:gsub("{%x%x%x%x%x%x}", "")
    return imgui.CalcTextSize(cleanStr).x
end

local function registerNewCommand(newCmd)
    if iniData.settings.cmd and iniData.settings.cmd ~= "" then
        sampUnregisterChatCommand(iniData.settings.cmd)
    end
    iniData.settings.cmd = newCmd
    inicfg.save(iniData, directIni)
    sampRegisterChatCommand(newCmd, function()
        WinState[0] = not WinState[0]
        imgui.GetIO().WantCaptureKeyboard = false
    end)
end

-- [ DETALII FINE JOBURI EXACT CA IN HELPERHELP ] --
local function renderQuarryDetails()
    imgui.Spacing()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Q U A R R Y - W O R K E R")
    imgui.Separator()
    imgui.Spacing()

    imgui.BeginChild("QuarryWorkerInfo", imgui.ImVec2(0, 600), true) 

    if iniData.settings.lang == 0 then
        -- ==================== [ LIMBA ROMaNa ] ====================
        imgui.TextColored(imgui.ImVec4(1.0, 0.0, 1.0, 1.0), "- Ocupatia muncitorilor la cariera")
        imgui.Separator()
        imgui.TextWrapped("Un muncitor la cariera din Las Venturas, trebuie sa incarce diverse materiale din partea de sus a carierei si sa le transporte\npe drumul abrupt direct in inima acesteia. O cursa pentru skill este adolescenta de un drum dus-intors.")
        imgui.Spacing()
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Timpul mediu pentru terminarea unei curse la skill 1-2 este de 123 secunde.")
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Timpul mediu pentru terminarea unei curse la skill 3-4 este de 92 secunde.")
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Timpul mediu pentru terminarea unei curse la skill 5-10 este de 76 secunde.")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "- Castiguri in functie de skill pentru o cursa")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 1 - Aproximativ $329 fara bonusuri. | Skill 2 - Aproximativ $347 fara bonusuri.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 3 - Aproximativ $299 fara bonusuri. | Skill 4 - Aproximativ $315 fara bonusuri.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 5 - Aproximativ $404 fara bonusuri. | Skill 6 - Aproximativ $437 fara bonusuri.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 7 - Aproximativ $472 fara bonusuri. | Skill 8 - Aproximativ $502 fara bonusuri.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 9 - Aproximativ $540 fara bonusuri. | Skill 10 - Aproximativ $562 fara bonusuri.")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), "- Curse necesare pentru avansare in skill")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(0.95, 1.0, 0.85, 1.0), "Skill 1 la skill 2, un muncitor are nevoie de 30 de curse.")
        imgui.TextColored(imgui.ImVec4(0.93, 1.0, 0.70, 1.0), "Skill 2 la skill 3, un muncitor are nevoie de 60 de curse. (90 in total)")
        imgui.TextColored(imgui.ImVec4(0.91, 1.0, 0.51, 1.0), "Skill 3 la skill 4, un muncitor are nevoie de 120 de curse. (210 in total)")
        imgui.TextColored(imgui.ImVec4(0.91, 1.0, 0.41, 1.0), "Skill 4 la skill 5, un muncitor are nevoie de 240 de curse. (450 in total)")
        imgui.TextColored(imgui.ImVec4(0.85, 1.0, 0.25, 1.0), "Skill 5 la skill 6, un muncitor are nevoie de 200 de curse. (650 in total)")
        imgui.TextColored(imgui.ImVec4(0.75, 1.0, 0.0, 1.0), "Skill 6 la skill 7, un muncitor are nevoie de 250 de curse. (900 in total)")
        imgui.TextColored(imgui.ImVec4(0.65, 0.90, 0.0, 1.0), "Skill 7 la skill 8, un muncitor are nevoie de 300 de curse. (1200 in total)")
        imgui.TextColored(imgui.ImVec4(0.55, 0.82, 0.0, 1.0), "Skill 8 la skill 9, un muncitor are nevoie de 350 de curse. (1550 in total)")
        imgui.TextColored(imgui.ImVec4(0.45, 0.72, 0.0, 1.0), "Skill 9 la skill 10, un muncitor are nevoie de 350 de curse. (1900 in total)")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), "- Vehicule in functie de skill")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Dozer - Skillul necesar: 1, 2")
        imgui.TextColored(imgui.ImVec4(0.6, 0.2, 1.0, 1.0), "Cement Truck - Skillul necesar: 3, 4")
        imgui.TextColored(imgui.ImVec4(1.0, 0.82, 0.51, 1.0), "Dumper - Skillul necesar: 5, 6, 7, 8, 9, 10")
    else
        -- ==================== [ LIMBA ENGLEZa ] ====================
        imgui.TextColored(imgui.ImVec4(1.0, 0.0, 1.0, 1.0), "- Quarry worker occupation")
        imgui.Separator()
        imgui.TextWrapped("A quarry worker in Las Venturas must load various materials from the top of the quarry and transport them\ndown the steep road directly into its heart. A run for skill is represented by a round trip.")
        imgui.Spacing()
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Average time to complete a run at skill 1-2 is 123 seconds.")
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Average time to complete a run at skill 3-4 is 92 seconds.")
        imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Average time to complete a run at skill 5-10 is 76 seconds.")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "- Earnings per run based on skill")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 1 - Approximately $329 without bonuses. | Skill 2 - Approximately $347 without bonuses.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 3 - Approximately $299 without bonuses. | Skill 4 - Approximately $315 without bonuses.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 5 - Approximately $404 without bonuses. | Skill 6 - Approximately $437 without bonuses.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 7 - Approximately $472 without bonuses. | Skill 8 - Approximately $502 without bonuses.")
        imgui.TextColored(imgui.ImVec4(0.49, 1.0, 0.65, 1.0), "Skill 9 - Approximately $540 without bonuses. | Skill 10 - Approximately $562 without bonuses.")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), "- Runs required to level up skill")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(0.95, 1.0, 0.85, 1.0), "Skill 1 to skill 2, a worker needs 30 runs.")
        imgui.TextColored(imgui.ImVec4(0.93, 1.0, 0.70, 1.0), "Skill 2 to skill 3, a worker needs 60 runs. (90 in total)")
        imgui.TextColored(imgui.ImVec4(0.91, 1.0, 0.51, 1.0), "Skill 3 to skill 4, a worker needs 120 runs. (210 in total)")
        imgui.TextColored(imgui.ImVec4(0.91, 1.0, 0.41, 1.0), "Skill 4 to skill 5, a worker needs 240 runs. (450 in total)")
        imgui.TextColored(imgui.ImVec4(0.85, 1.0, 0.25, 1.0), "Skill 5 to skill 6, a worker needs 200 runs. (650 in total)")
        imgui.TextColored(imgui.ImVec4(0.75, 1.0, 0.0, 1.0), "Skill 6 to skill 7, a worker needs 250 runs. (900 in total)")
        imgui.TextColored(imgui.ImVec4(0.65, 0.90, 0.0, 1.0), "Skill 7 to skill 8, a worker needs 300 runs. (1200 in total)")
        imgui.TextColored(imgui.ImVec4(0.55, 0.82, 0.0, 1.0), "Skill 8 to skill 9, a worker needs 350 runs. (1550 in total)")
        imgui.TextColored(imgui.ImVec4(0.45, 0.72, 0.0, 1.0), "Skill 9 to skill 10, a worker needs 350 runs. (1900 in total)")
        imgui.Spacing()
        imgui.Spacing()

        imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), "- Vehicles based on skill level")
        imgui.Separator()
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Dozer - Required Skill: 1, 2")
        imgui.TextColored(imgui.ImVec4(0.6, 0.2, 1.0, 1.0), "Cement Truck - Required Skill: 3, 4")
        imgui.TextColored(imgui.ImVec4(1.0, 0.82, 0.51, 1.0), "Dumper - Required Skill: 5, 6, 7, 8, 9, 10")
    end

    imgui.EndChild()
end

local function renderLumberjackDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "L U M B E R J A C K")
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "STATISTICI COMPLETE PE SKILL SI LOCATII")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMPLETE STATISTICS BY SKILL AND LOCATIONS")
    end
    
    imgui.BeginChild("LumberEarnings", imgui.ImVec2(0, 700), true)  
        imgui.Columns(4, "lumberCols", false)
        imgui.SetColumnWidth(0, 140) 
        imgui.SetColumnWidth(1, 85)   
        imgui.SetColumnWidth(2, 120)  
        imgui.SetColumnWidth(3, 120)  
        
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Skill/Padure") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Timp") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Fara Prem.") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Cu Premium") imgui.NextColumn()
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Skill/Forest") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Time") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "No Prem.") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "With Premium") imgui.NextColumn()
        end
        imgui.Separator()
        
        local lumberData = {}
        if iniData.settings.lang == 0 then
            lumberData = {
                {"Skill 1", "Walton", "0 curse", {"370s", "1198$", "1797$"}, {"267s", "864$", "1296$"}, {"322s", "1041$", "1561$"}, "+30 pt Skill 2"},
                {"Skill 2", "Walton", "30 curse", {"370s", "1219$", "1828$"}, {"267s", "879$", "1318$"}, {"322s", "1061$", "1591$"}, "+60 pt Skill 3"},
                {"Skill 3", "DFT-30", "90 curse", {"355s", "1265$", "1897$"}, {"252s", "898$", "1347$"}, {"291s", "1037$", "1555$"}, "+120 pt Skill 4"},
                {"Skill 4", "DFT-30", "210 curse", {"355s", "1428$", "2142$"}, {"252s", "1014$", "1521$"}, {"291s", "1170$", "1755$"}, "+240 pt Skill 5"},
                {"Skill 5", "Flatbed", "450 curse", {"306s", "1449$", "2173$"}, {"229s", "1083$", "1624$"}, {"265s", "1253$", "1879$"}, "+200 pt Skill 6"},
                {"Skill 6", "Flatbed", "650 curse", {"306s", "1675$", "2512$"}, {"229s", "1260$", "1890$"}, {"265s", "1455$", "2182$"}, "+250 pt Skill 7"},
                {"Skill 7", "Flatbed", "900 curse", {"306s", "1720$", "2580$"}, {"229s", "1300$", "1950$"}, {"265s", "1500$", "2250$"}, "+300 pt Skill 8"},
                {"Skill 8", "Flatbed", "1200 curse", {"306s", "1850$", "2775$"}, {"229s", "1380$", "2070$"}, {"265s", "1590$", "2385$"}, "+350 pt Skill 9"},
                {"Skill 9", "Flatbed", "1550 curse", {"306s", "1920$", "2880$"}, {"229s", "1440$", "2160$"}, {"265s", "1660$", "2490$"}, "+350 pt Skill 10"},
                {"Skill 10", "Flatbed", "1900 curse", {"306s", "1983$", "2974$"}, {"229s", "1484$", "2226$"}, {"265s", "1718$", "2577$"}, "NIVEL MAX"}
            }
        else
            lumberData = {
                {"Skill 1", "Walton", "0 runs", {"370s", "1198$", "1797$"}, {"267s", "864$", "1296$"}, {"322s", "1041$", "1561$"}, "30 runs for Skill 2"},
                {"Skill 2", "Walton", "30 runs", {"370s", "1219$", "1828$"}, {"267s", "879$", "1318$"}, {"322s", "1061$", "1591$"}, "60 runs for Skill 3"},
                {"Skill 3", "DFT-30", "90 runs", {"355s", "1265$", "1897$"}, {"252s", "898$", "1347$"}, {"291s", "1037$", "1555$"}, "120 runs for Skill 4"},
                {"Skill 4", "DFT-30", "210 runs", {"355s", "1428$", "2142$"}, {"252s", "1014$", "1521$"}, {"291s", "1170$", "1755$"}, "240 runs for Skill 5"},
                {"Skill 5", "Flatbed", "450 runs", {"306s", "1449$", "2173$"}, {"229s", "1083$", "1624$"}, {"265s", "1253$", "1879$"}, "200 runs for Skill 6"},
                {"Skill 6", "Flatbed", "650 runs", {"306s", "1675$", "2512$"}, {"229s", "1260$", "1890$"}, {"265s", "1455$", "2182$"}, "250 runs for Skill 7"},
                {"Skill 7", "Flatbed", "900 runs", {"306s", "1720$", "2580$"}, {"229s", "1300$", "1950$"}, {"265s", "1500$", "2250$"}, "300 runs for Skill 8"},
                {"Skill 8", "Flatbed", "1200 runs", {"306s", "1850$", "2775$"}, {"229s", "1380$", "2070$"}, {"265s", "1590$", "2385$"}, "350 runs for Skill 9"},
                {"Skill 9", "Flatbed", "1550 runs", {"306s", "1920$", "2880$"}, {"229s", "1440$", "2160$"}, {"265s", "1660$", "2490$"}, "350 runs for Skill 10"},
                {"Skill 10", "Flatbed", "1900 runs", {"306s", "1983$", "2974$"}, {"229s", "1484$", "2226$"}, {"265s", "1718$", "2577$"}, "MAX LEVEL"}
            }
        end
        
        for _, skill in ipairs(lumberData) do
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), skill[1]) imgui.NextColumn()          
            imgui.TextColored(imgui.ImVec4(0, 0.8, 1, 1), skill[2]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), skill[3]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.7, 0.4, 1.0, 1), skill[7]) imgui.NextColumn()
            
            if iniData.settings.lang == 0 then
                imgui.Text(" - Padurea I")
            else
                imgui.Text(" - Forest I")
            end
            imgui.NextColumn()
            imgui.Text(skill[4][1]) imgui.NextColumn()
            imgui.Text(skill[4][2]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), skill[4][3]) imgui.NextColumn()
            
            if iniData.settings.lang == 0 then
                imgui.Text(" - Padurea II")
            else
                imgui.Text(" - Forest II")
            end
            imgui.NextColumn()
            imgui.Text(skill[5][1]) imgui.NextColumn()
            imgui.Text(skill[5][2]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), skill[5][3]) imgui.NextColumn()
            
            if iniData.settings.lang == 0 then
                imgui.Text(" - Padurea III")
            else
                imgui.Text(" - Forest III")
            end
            imgui.NextColumn()
            imgui.Text(skill[6][1]) imgui.NextColumn()
            imgui.Text(skill[6][2]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), skill[6][3]) imgui.NextColumn()
            
            imgui.Separator()
        end
        imgui.Columns(1)
    imgui.EndChild()
end

local function renderMinerDetails()
    imgui.Spacing()
    imgui.BeginChild("MinerTitleBox", imgui.ImVec2(0, 30), true)
        imgui.SetCursorPosY(5)
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "M I N E R") 
    imgui.EndChild()  
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ CASTIGURI CONT FARA CONT PREMIUM. | CU CONT PREMIUM. ]")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ EARNINGS WITHOUT PREMIUM ACCOUNT | WITH PREMIUM ACCOUNT ]")
    end

    imgui.BeginChild("MinerEarningsBox", imgui.ImVec2(0, 200), true)  
        imgui.Columns(2, "minerCols", false)
        local earnings = {
            {s = "Skill 1", f = "743$", p = "1114$"}, {s = "Skill 6", f = "1111$", p = "1666$"},
            {s = "Skill 2", f = "759$", p = "1138$"}, {s = "Skill 7", f = "1178$", p = "1767$"},
            {s = "Skill 3", f = "820$", p = "1230$"}, {s = "Skill 8", f = "1273$", p = "1909$"},
            {s = "Skill 4", f = "924$", p = "1386$"}, {s = "Skill 9", f = "1330$", p = "1995$"},
            {s = "Skill 5", f = "1088$", p = "1632$"}, {s = "Skill 10", f = "1406$", p = "2109$"}
        }
        for _, v in ipairs(earnings) do
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v.s .. ":") 
            imgui.SameLine()
            imgui.Text(v.f) 
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.3), ">>")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), v.p)
            imgui.NextColumn()
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ VEHICULE SI VITEZA ]")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ VEHICLES AND SPEED ]")
    end

    imgui.BeginChild("MinerVehBox", imgui.ImVec2(0, 95), true)  
        imgui.Columns(2, "minVehCols", false)      
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "BOBCAT")
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Skill: 1-5")
        if iniData.settings.lang == 0 then
            imgui.Text("Viteza: 140 KM/h")      
        else
            imgui.Text("Speed: 140 KM/h")      
        end
        imgui.NextColumn()     
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "YOSEMITE")
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Skill: 6-10")
        if iniData.settings.lang == 0 then
            imgui.Text("Viteza: 144 KM/h")     
        else
            imgui.Text("Speed: 144 KM/h")     
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ AVANSARE IN SKILL ]")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "  [ SKILL LEVEL UP PROGRESS ]")
    end

    imgui.BeginChild("MinerProgressBox", imgui.ImVec2(0, 260), true)  
        local progress = {}
        if iniData.settings.lang == 0 then
            progress = {
                "Skill 1 -> Skill 2: +30 curse (30 total)",
                "Skill 2 -> Skill 3: +60 curse (90 total)",
                "Skill 3 -> Skill 4: +120 curse (210 total)",
                "Skill 4 -> Skill 5: +240 curse (450 total)",
                "Skill 5 -> Skill 6: +200 curse (650 total)",
                "Skill 6 -> Skill 7: +250 curse (900 total)",
                "Skill 7 -> Skill 8: +300 curse (1200 total)",
                "Skill 8 -> Skill 9: +350 curse (1550 total)",
                "Skill 9 -> Skill 10: +350 curse (1900 total)"
            }
        else
            progress = {
                "Skill 1 -> Skill 2: +30 runs (30 total)",
                "Skill 2 -> Skill 3: +60 runs (90 total)",
                "Skill 3 -> Skill 4: +120 runs (210 total)",
                "Skill 4 -> Skill 5: +240 runs (450 total)",
                "Skill 5 -> Skill 6: +200 runs (650 total)",
                "Skill 6 -> Skill 7: +250 runs (900 total)",
                "Skill 7 -> Skill 8: +300 runs (1200 total)",
                "Skill 8 -> Skill 9: +350 runs (1550 total)",
                "Skill 9 -> Skill 10: +350 runs (1900 total)"
            }
        end

        for i, txt in ipairs(progress) do
            if i == 5 then 
                imgui.Spacing()
                if iniData.settings.lang == 0 then
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), " > DEBLOCARE YOSEMITE (Skill 6)")
                else
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), " > UNLOCK YOSEMITE (Skill 6)")
                end
                imgui.Separator()
                imgui.Spacing()
            end
            imgui.TextColored(imgui.ImVec4(0.7, 0.4, 1.0, 1), " * " .. txt) 
        end
    imgui.EndChild()
end

local function renderGarbageDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "G A R B A G E - M A N")
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VENITURI DETALIATE")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "DETAILED EARNINGS")
    end

    imgui.BeginChild("GarbageEarnings", imgui.ImVec2(0, 200), true)  
        imgui.Columns(3, "earningsHeader", false)
        imgui.SetColumnWidth(0, 100)
        imgui.SetColumnWidth(1, 180)
        imgui.SetColumnWidth(2, 180)        
        
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Checkpoints") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Fara Premium") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Cu Premium") imgui.NextColumn()
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Checkpoints") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Without Premium") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "With Premium") imgui.NextColumn()
        end
        imgui.Separator()

        local earnings = {
            {"10 CP", "1.265$", "1.897$"}, {"12 CP", "1.518$", "2.277$"},
            {"14 CP", "1.771$", "2.656$"}, {"16 CP", "2.024$", "3.036$"},
            {"18 CP", "2.277$", "3.415$"}, {"20 CP", "2.530$", "3.795$"}
        }
        for _, v in ipairs(earnings) do
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v[1]) imgui.NextColumn()
            imgui.Text(v[2]) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), v[3]) imgui.NextColumn()
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICUL DISPONIBIL")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "AVAILABLE VEHICLE")
    end

    imgui.BeginChild("GarbageVeh", imgui.ImVec2(0, 95), true)  
        imgui.Columns(2, "garbVehCols", false)
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "TRASHMASTER")
        if iniData.settings.lang == 0 then
            imgui.Text("Viteza: 100 KM/h")
            imgui.NextColumn()
            imgui.Text("Locuri: 2")
            imgui.Text("Combustibil: Infinit")
        else
            imgui.Text("Speed: 100 KM/h")
            imgui.NextColumn()
            imgui.Text("Seats: 2")
            imgui.Text("Fuel: Infinite")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()  
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMENZI SI MOD DE LUCRU")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMMANDS AND GAMEPLAY")
    end

    imgui.BeginChild("GarbageCmds", imgui.ImVec2(0, 210), true)  
        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/work ") imgui.SameLine()
        if iniData.settings.lang == 0 then
            imgui.Text("- Primesti un Trashmaster incuiat.")         
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/dumptrash ") imgui.SameLine()
            imgui.Text("- Finalizezi cursa (minim 10 pubele).")          
            imgui.Separator()
            imgui.Spacing()            
            imgui.TextWrapped("- Colecteaza gunoi de la maxim 20 de pubele.")
            imgui.TextWrapped("- Vehiculele sunt incuiate si NU consuma combustibil.")
            imgui.TextWrapped("- Daca parasesti masina, ai 20 de secunde sa revii.")
        else
            imgui.Text("- Spawns a locked Trashmaster.")         
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/dumptrash ") imgui.SameLine()
            imgui.Text("- Finishes the run (minimum 10 trash bins required).")          
            imgui.Separator()
            imgui.Spacing()            
            imgui.TextWrapped("- Collect trash from a maximum of 20 trash bins.")
            imgui.TextWrapped("- Vehicles are locked and do NOT consume fuel.")
            imgui.TextWrapped("- If you leave the vehicle, you have 20 seconds to return.")
        end
    imgui.EndChild()
    imgui.Separator()
    
    if iniData.settings.lang == 0 then
        imgui.TextWrapped("Locatii: Los Santos si Las Venturas.")
        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Bonus: Contul Premium ofera +50 '/. la plata finala.")
    else
        imgui.TextWrapped("Locations: Los Santos and Las Venturas.")
        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Bonus: Premium Account grants +50 '/. to the final payout.")
    end
end

local function renderBusDriverDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "B U S - D R I V E R")
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VENITURI SI PLATA")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "EARNINGS AND PAYOUT")
    end

    imgui.BeginChild("BusEarningsBox", imgui.ImVec2(0, 95), true)
        imgui.Spacing()
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Plata per statie: ") imgui.SameLine()
            imgui.Text("12$ - 16$ (Suma aleatorie)")      
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill: ") imgui.SameLine()
            imgui.Text("Orice skill poate folosi Bus-ul")
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Payout per station: ") imgui.SameLine()
            imgui.Text("12$ - 16$ (Random amount)")      
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill: ") imgui.SameLine()
            imgui.Text("Any skill level can use the Bus")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICUL DISPONIBIL")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "AVAILABLE VEHICLE")
    end

    imgui.BeginChild("BusVehBox", imgui.ImVec2(0, 110), true)  
        imgui.Columns(2, "busVehCols", false)
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "BUS")
        if iniData.settings.lang == 0 then
            imgui.Text("Viteza: 130 KM/h")
            imgui.NextColumn()
            imgui.Text("Locuri: 8")
            imgui.Text("Tunabil: TransFender")
        else
            imgui.Text("Speed: 130 KM/h")
            imgui.NextColumn()
            imgui.Text("Seats: 8")
            imgui.Text("Tunable: TransFender")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMENZI SI MOD DE LUCRU")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMMANDS AND GAMEPLAY")
    end

    imgui.BeginChild("BusCmdsBox", imgui.ImVec2(0, 200), true)  
        imgui.Bullet() imgui.SameLine()
        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/work ") imgui.SameLine()
        if iniData.settings.lang == 0 then
            imgui.Text("- Primesti vehiculul si incepi cursa.")
            imgui.Bullet() imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/fare ") imgui.SameLine()
            imgui.Text("- Setezi tariful biletului (1$ - 5$).")       
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()     
            imgui.TextWrapped("- Puncte de angajare: Los Santos si San Fierro.")
            imgui.TextWrapped("- Daca parasesti vehiculul, ai 20 de secunde sa revii.")
            imgui.TextWrapped("- Jobul este legal si necesita minim nivel 1.")
        else
            imgui.Text("- Spawns the vehicle and starts the route.")
            imgui.Bullet() imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/fare ") imgui.SameLine()
            imgui.Text("- Sets the ticket fare (1$ - 5$).")       
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()     
            imgui.TextWrapped("- Employment locations: Los Santos and San Fierro.")
            imgui.TextWrapped("- If you leave the vehicle, you have 20 seconds to return.")
            imgui.TextWrapped("- The job is legal and requires minimum level 1.")
        end
    imgui.EndChild()
    imgui.Separator()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Nota: Premium +5'/. | Poti lua pasageri pe tot parcursul traseului.")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Note: Premium +50'/. | You can pick up passengers along the entire route.")
    end
end

local function renderFishermanDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "F I S H E R M A N")
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VENITURI PE TIP PESTE")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "EARNINGS BY FISH TYPE")
    end

    imgui.BeginChild("FishEarningsBox", imgui.ImVec2(0, 200), true)  
        imgui.Columns(2, "fishCols", false)     
        local fishPrices = {}
        if iniData.settings.lang == 0 then
            fishPrices = {
                {n = "Crap", p = "350$"}, {n = "Betta", p = "1.100$"},
                {n = "Salau", p = "500$"}, {n = "Ayu", p = "1.250$"},
                {n = "Pastrav", p = "650$"}, {n = "Cod", p = "1.400$"},
                {n = "Somon", p = "800$"}, {n = "Escolar", p = "1.550$"},
                {n = "Rechin", p = "950$"}, {n = "Dragonet", p = "1.700$"}
            }
        else
            fishPrices = {
                {n = "Carp", p = "350$"}, {n = "Betta", p = "1.100$"},
                {n = "Zander", p = "500$"}, {n = "Ayu", p = "1.250$"},
                {n = "Trout", p = "650$"}, {n = "Cod", p = "1.400$"},
                {n = "Salmon", p = "800$"}, {n = "Escolar", p = "1.550$"},
                {n = "Shark", p = "950$"}, {n = "Dragonet", p = "1.700$"}
            }
        end

        for _, v in ipairs(fishPrices) do
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v.n .. ":") 
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), v.p)
            imgui.NextColumn()
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "REGULI SI NECESAR")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "RULES AND REQUIREMENTS")
    end

    imgui.BeginChild("FishInfoBox", imgui.ImVec2(0, 100), true)  
        imgui.Columns(2, "fishInfoCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "ECHIPAMENT")
            imgui.Text("Undita & Momeala (24/7)")
            imgui.Text("Durata Undita: 24h")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "AVERTIZARE")
            imgui.Text("Fara licenta: Wanted 1")
            imgui.Text("Mecanica: 30s / 10 click")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "EQUIPMENT")
            imgui.Text("Fishing Rod & Bait (24/7)")
            imgui.Text("Rod Duration: 24h")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "WARNING")
            imgui.Text("No license: Wanted 1")
            imgui.Text("Mechanics: 30s / 10 clicks")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PROGRES SKILL (PESTI PRINSI)")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL PROGRESS (FISH CAUGHT)")
    end

    imgui.BeginChild("FishProgressBox", imgui.ImVec2(0, 250), true)  
        local progress = {}
        if iniData.settings.lang == 0 then
            progress = {
                "Skill 1 -> Skill 2: 50 pesti", "Skill 2 -> Skill 3: 150 pesti",
                "Skill 3 -> Skill 4: 350 pesti", "Skill 4 -> Skill 5: 750 pesti",
                "Skill 5 -> Skill 6: 1.500 pesti", "Skill 6 -> Skill 7: 3.000 pesti",
                "Skill 7 -> Skill 8: 5.000 pesti", "Skill 8 -> Skill 9: 8.000 pesti",
                "Skill 9 -> Skill 10: 11.000 pesti"
            }
        else
            progress = {
                "Skill 1 -> Skill 2: 50 fish", "Skill 2 -> Skill 3: 150 fish",
                "Skill 3 -> Skill 4: 350 fish", "Skill 4 -> Skill 5: 750 fish",
                "Skill 5 -> Skill 6: 1,500 fish", "Skill 6 -> Skill 7: 3,000 fish",
                "Skill 7 -> Skill 8: 5,000 fish", "Skill 8 -> Skill 9: 8,000 fish",
                "Skill 9 -> Skill 10: 11,000 fish"
            }
        end

        for _, txt in ipairs(progress) do
            imgui.TextColored(imgui.ImVec4(0.7, 0.4, 1.0, 1), "• " .. txt) 
        end
    imgui.EndChild()
    imgui.Separator()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Nota: Pestii se vand automat cand intri intr-un magazin 24/7.")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Note: Fish are sold automatically when you enter a 24/7 store.")
    end
end

local function renderTruckerDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "T R U C K E R") 
    imgui.Separator()
    
    imgui.BeginChild("TruckerBase", imgui.ImVec2(0, 95), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "GENERAL:")
            imgui.Separator()
            imgui.Spacing()
            imgui.Bullet() 
            imgui.TextWrapped("Nivel: 1+ (Job Legal)  |  Sloturi Muncitori: 50  |  Timp Misiune: 15 minute")
            imgui.Spacing()
            imgui.Bullet() 
            imgui.TextWrapped("Comanda Lucru: /work  |  Comanda Decuplare: /detach  |  Recuplare: 20 secunde")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "GENERAL:")
            imgui.Separator()
            imgui.Spacing()
            imgui.Bullet() 
            imgui.TextWrapped("Level: 1+ (Legal Job)  |  Worker Slots: 50  |  Mission Time: 15 minutes")
            imgui.Spacing()
            imgui.Bullet() 
            imgui.TextWrapped("Work Command: /work  |  Detach Command: /detach  |  Reattach: 20 seconds")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "TIPURI DE INCARCATURI:")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "CARGO TYPES:")
    end

    imgui.BeginChild("CargoTypes", imgui.ImVec2(0, 120), true)  
        imgui.Columns(2, "cargoCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "[SKILL 1] Comercial")
            imgui.TextWrapped("- Sansa 15: +1 Extra Skill Point.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(0.9, 0.5, 0.1, 1), "[SKILL 4] Constructii")
            imgui.TextWrapped("- Garantat: 20-40 Lemn/Bumbac/Aur sau 40-60 Argint.")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.1, 0.6, 0.9, 1), "[SKILL 7] Fuel")
            imgui.TextWrapped("- Sansa 25: +30 Cash pe cursa.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(0.8, 0.2, 0.8, 1), "[SKILL 9] Marfa")
            imgui.TextWrapped("- Sansa 5: Cutie aleatorie (Crate).")       
        else
            imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "[SKILL 1] Commercial")
            imgui.TextWrapped("- 15 Chance: +1 Extra Skill Point.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(0.9, 0.5, 0.1, 1), "[SKILL 4] Construction")
            imgui.TextWrapped("- Guaranteed: 20-40 Wood/Cotton/Gold or 40-60 Silver.")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.1, 0.6, 0.9, 1), "[SKILL 7] Fuel")
            imgui.TextWrapped("- 25 Chance: +30 Cash per run.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(0.8, 0.2, 0.8, 1), "[SKILL 9] Cargo")
            imgui.TextWrapped("- 5 Chance: Random box (Crate).")       
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "ANALIZA RUTE (S1 - S10):")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "ROUTE ANALYSIS (S1 - S10):")
    end

    imgui.BeginChild("RoutesList", imgui.ImVec2(0, 150), true)  
        imgui.Columns(3, "routeCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Destinatie") imgui.NextColumn()
            imgui.Text("Dist.") imgui.NextColumn()
            imgui.Text("Plata (S1-10)") imgui.NextColumn()
        else
            imgui.Text("Destination") imgui.NextColumn()
            imgui.Text("Dist.") imgui.NextColumn()
            imgui.Text("Payout (S1-10)") imgui.NextColumn()
        end
        imgui.Separator()
        
        local routes = {
            {"Ocean Docks (LS)", "10.3 KM", "$1134 - $1866"},
            {"Bayside (SF)", "10.6 KM", "$1237 - $1761"},
            {"Rockshore (LV)", "9.8 KM", "$868 - $1096"},
            {"Creek (LV)", "12.4 KM", "$1062 - $1621"},
            {"Whetstone (SF)", "10.3 KM", "$1036 - $1516"}
        }
        for _, r in ipairs(routes) do
            imgui.Text(r[1]) imgui.NextColumn()
            imgui.Text(r[2]) imgui.NextColumn()
            imgui.Text(r[3]) imgui.NextColumn()
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("TruckerProg", imgui.ImVec2(0, 155), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "CURSE NECESARE PENTRU SKILL:")
            imgui.Separator()
            imgui.Spacing()      
            imgui.Columns(2, "progCols", false) 
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 -> 2:") imgui.SameLine() imgui.Text("30 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 -> 3:") imgui.SameLine() imgui.Text("60 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 3 -> 4:") imgui.SameLine() imgui.Text("120 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 4 -> 5:") imgui.SameLine() imgui.Text("240 curse")      
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 5 -> 6:") imgui.SameLine() imgui.Text("200 curse")   
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 6 -> 7:") imgui.SameLine() imgui.Text("250 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 7 -> 8:") imgui.SameLine() imgui.Text("300 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 8 -> 9:") imgui.SameLine() imgui.Text("350 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 9 -> 10:") imgui.SameLine() imgui.Text("350 curse")
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Total Skill 10: 1.900 Curse")  
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "RUNS REQUIRED FOR SKILL UPGRADE:")
            imgui.Separator()
            imgui.Spacing()      
            imgui.Columns(2, "progCols", false) 
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 -> 2:") imgui.SameLine() imgui.Text("30 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 -> 3:") imgui.SameLine() imgui.Text("60 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 3 -> 4:") imgui.SameLine() imgui.Text("120 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 4 -> 5:") imgui.SameLine() imgui.Text("240 runs")      
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 5 -> 6:") imgui.SameLine() imgui.Text("200 runs")   
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 6 -> 7:") imgui.SameLine() imgui.Text("250 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 7 -> 8:") imgui.SameLine() imgui.Text("300 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 8 -> 9:") imgui.SameLine() imgui.Text("350 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 9 -> 10:") imgui.SameLine() imgui.Text("350 runs")
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Total Skill 10: 1,900 Runs")  
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "VEHICULE:")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "VEHICLES:")
    end

    imgui.BeginChild("TruckerFleet", imgui.ImVec2(0, 100), true)  
        imgui.Columns(3, "fleetCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Camion") imgui.NextColumn()
            imgui.Text("Viteza") imgui.NextColumn()
            imgui.Text("Model Real") imgui.NextColumn()
            imgui.Separator()
            imgui.Text("Linerunner (Skill 1)") imgui.NextColumn()
            imgui.Text("110 KM/h") imgui.NextColumn()
            imgui.Text("Kenworth W900L") imgui.NextColumn()
            imgui.Text("Tanker (Skill 3)") imgui.NextColumn()
            imgui.Text("120 KM/h") imgui.NextColumn()
            imgui.Text("Int. Paystar") imgui.NextColumn()
            imgui.Text("Roadtrain (Skill 5)") imgui.NextColumn()
            imgui.Text("142 KM/h") imgui.NextColumn()
            imgui.Text("4964 Heritage")
        else
            imgui.Text("Truck") imgui.NextColumn()
            imgui.Text("Speed") imgui.NextColumn()
            imgui.Text("Real Model") imgui.NextColumn()
            imgui.Separator()
            imgui.Text("Linerunner (Skill 1)") imgui.NextColumn()
            imgui.Text("110 KM/h") imgui.NextColumn()
            imgui.Text("Kenworth W900L") imgui.NextColumn()
            imgui.Text("Tanker (Skill 3)") imgui.NextColumn()
            imgui.Text("120 KM/h") imgui.NextColumn()
            imgui.Text("Int. Paystar") imgui.NextColumn()
            imgui.Text("Roadtrain (Skill 5)") imgui.NextColumn()
            imgui.Text("142 KM/h") imgui.NextColumn()
            imgui.Text("4964 Heritage")
        end
        imgui.Columns(1)
    imgui.EndChild()
end

local function renderFarmerDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "F A R M E R")
    imgui.Separator()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "ADMINISTRARE PARCELE (24 ORE):")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "PLOT MANAGEMENT (24 HOURS):")
    end

    imgui.BeginChild("FarmerPlots", imgui.ImVec2(0, 150), true)  
        imgui.Columns(2, "plotCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PARCELA PUBLICA")
            imgui.Text("Pret: $1,000 / 24h")
            imgui.Text("ID-uri LS: 1-20 | SF: 29-48 | LV: 53-64")
            imgui.NextColumn()        
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "PARCELA PRIVATA")
            imgui.Text("Pret: 200 Gold / 24h")
            imgui.Text("ID-uri LS: 21-24 | SF: 25-28 | LV: 49-52")
            imgui.Columns(1)
            imgui.Separator()
            imgui.TextWrapped("Poti detine simultan o parcela privata si una publica.")
            imgui.TextWrapped("Avantaj Privat: NU se usuca plantele si poti planta orice indiferent de skill.")
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PUBLIC PLOT")
            imgui.Text("Price: $1,000 / 24h")
            imgui.Text("IDs LS: 1-20 | SF: 29-48 | LV: 53-64")
            imgui.NextColumn()        
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "PRIVATE PLOT")
            imgui.Text("Price: 200 Gold / 24h")
            imgui.Text("IDs LS: 21-24 | SF: 25-28 | LV: 49-52")
            imgui.Columns(1)
            imgui.Separator()
            imgui.TextWrapped("You can simultaneously own one private plot and one public plot.")
            imgui.TextWrapped("Private Advantage: Plants do NOT dry out and you can plant anything regardless of your skill level.")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "PROCESUL DE LUCRU:")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "WORK PROCESS:")
    end

    imgui.BeginChild("FarmerWork", imgui.ImVec2(0, 140), true)  
        if iniData.settings.lang == 0 then
            imgui.BulletText("Inchiriere: Mergi la parcela si apasa 'Y'.")
            imgui.BulletText("Timp Limita: Ai 1 ora sa plantezi dupa inchiriere.")
            imgui.BulletText("Biz Agricol (158): Inchiriaza unelte si cumpara seminte.")
            imgui.BulletText("Etape: ARA terenul (Tractor) -> PLANTEAZA -> UDA.")
            imgui.BulletText("Comenzi: /seeds (vezi stoc) | /tog (HUD parcela) | /abandonparcel.")
            imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), "ATENTIE: Daca plantele se usuca, pierzi chiria parcelei!")
        else
            imgui.BulletText("Renting: Go to the plot and press 'Y'.")
            imgui.BulletText("Time Limit: You have 1 hour to start planting after renting.")
            imgui.BulletText("Agricultural Biz (158): Rent tools and buy seeds.")
            imgui.BulletText("Stages: PLOW the field (Tractor) -> PLANT -> WATER.")
            imgui.BulletText("Commands: /seeds (check stock) | /tog (plot HUD) | /abandonparcel.")
            imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), "WARNING: If the plants dry out, you lose the plot lease!")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "ANALIZA PLANTE SI TIMPI:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "CROP & TIME ANALYSIS:")
    end

    imgui.BeginChild("FarmerCrops", imgui.ImVec2(0, 170), true)  
        imgui.Columns(4, "cropCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Planta") imgui.NextColumn()
            imgui.Text("Maturitate") imgui.NextColumn()
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Culegere") imgui.NextColumn()
        else
            imgui.Text("Plant") imgui.NextColumn()
            imgui.Text("Maturity") imgui.NextColumn()
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Harvest") imgui.NextColumn()
        end
        imgui.Separator()
        
        local crops = {}
        if iniData.settings.lang == 0 then
            crops = {
                {"Usturoi", "15 min", "S1", "7.5 min"}, {"Feriga", "45 min", "S2", "30 min"},
                {"Trestie", "2 ore", "S3", "1 ora"}, {"Menta", "8 ore", "S4", "4 ore"},
                {"Cactus", "16 ore", "S5", "8 ore"}
            }
        else
            crops = {
                {"Garlic", "15 min", "S1", "7.5 min"}, {"Fern", "45 min", "S2", "30 min"},
                {"Sugar Cane", "2 hours", "S3", "1 hour"}, {"Mint", "8 hours", "S4", "4 hours"},
                {"Cactus", "16 hours", "S5", "8 hours"}
            }
        end

        for _, c in ipairs(crops) do
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), c[1]) imgui.NextColumn()
            imgui.Text(c[2]) imgui.NextColumn()
            imgui.Text(c[3]) imgui.NextColumn()
            imgui.Text(c[4]) imgui.NextColumn()
        end
        imgui.Columns(1)
        imgui.Separator()
        
        if iniData.settings.lang == 0 then
            imgui.TextWrapped("Umiditatea scade de la 100 la 0 intr-un timp egal cu maturitatea (max 5.5h).")
        else
            imgui.TextWrapped("Moisture drops from 100 to 0 in an amount of time equal to maturity (max 5.5h).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PROFIT SI AVANSARE SKILL:")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PROFIT & SKILL UPGRADE:")
    end

    imgui.BeginChild("FarmerProfit", imgui.ImVec2(0, 170), true)  
        imgui.Columns(2, "skillCols", false)       
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "PROFIT ESTIMAT / PLANTA:")
            imgui.Text("Skill 1: ~$244 (Usturoi)\nSkill 2: ~$563 (Feriga)\nSkill 3: ~$1,050 (Trestie)")
            imgui.Text("Skill 4: ~$2,400 (Menta)\nSkill 5: ~$4,200 (Cactus)")     
            imgui.NextColumn()           
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "PRAGURI PUNCTE:")
            imgui.Text("S1 -> S2: 1,536 pct\nS2 -> S3: 6,144 pct\nS3 -> S4: 13,824 pct\nS4 -> S5: 23,040 pct")       
            imgui.Columns(1)
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Puncte/Planta: Usturoi(1) | Feriga(3) | Trestie(8) | Menta(32) | Cactus(64)")
            imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1, 1), "Info: O parcela completa (16 plante) de Cactus ofera 1,024 puncte.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "ESTIMATED PROFIT / PLANT:")
            imgui.Text("Skill 1: ~$244 (Garlic)\nSkill 2: ~$563 (Fern)\nSkill 3: ~$1,050 (Sugar Cane)")
            imgui.Text("Skill 4: ~$2,400 (Mint)\nSkill 5: ~$4,200 (Cactus)")     
            imgui.NextColumn()           
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "POINT THRESHOLDS:")
            imgui.Text("S1 -> S2: 1,536 pts\nS2 -> S3: 6,144 pts\nS3 -> S4: 13,824 pts\nS4 -> S5: 23,040 pts")       
            imgui.Columns(1)
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "Points/Plant: Garlic(1) | Fern(3) | Sugar Cane(8) | Mint(32) | Cactus(64)")
            imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1, 1), "Info: A full plot (16 plants) of Cactus grants 1,024 points.")
        end
    imgui.EndChild()
end

local function renderChemistDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "C H E M I S T")
    imgui.Separator()
    
    imgui.BeginChild("ChemistInfo", imgui.ImVec2(0, 120), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATII SI COMENZI:")
            imgui.Separator()
            imgui.Columns(2, "chemInfoCols", false)
            imgui.BulletText("Nivel: 1 (Job Legal)")
            imgui.BulletText("Locatie: Montgomery (LS)")
            imgui.BulletText("Bonus: +6 XP Clan / Maraton")
            imgui.NextColumn()
            imgui.BulletText("Comanda: /work")
            imgui.BulletText("Oprire: /killcp")
            imgui.BulletText("Inventar Kit: /usekit")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATION AND COMMANDS:")
            imgui.Separator()
            imgui.Columns(2, "chemInfoCols", false)
            imgui.BulletText("Level: 1 (Legal Job)")
            imgui.BulletText("Location: Montgomery (LS)")
            imgui.BulletText("Bonus: +6 Clan XP / Marathon")
            imgui.NextColumn()
            imgui.BulletText("Command: /work")
            imgui.BulletText("Stop: /killcp")
            imgui.BulletText("Kit Inventory: /usekit")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "TABEL PLATI SI SANSE DROP:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PAYOUT TABLE AND DROP CHANCES:")
    end

    imgui.BeginChild("ChemistFullTable", imgui.ImVec2(0, 280), true)  
        imgui.Columns(3, "chemFullCols", false)
        imgui.SetColumnWidth(0, 85)   
        imgui.SetColumnWidth(1, 290)        
        
        if iniData.settings.lang == 0 then
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Plata (Fara premium vs Premium)") imgui.NextColumn()
            imgui.Text("Drop (M/D)") imgui.NextColumn()
        else
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Payout (Without premium vs Premium)") imgui.NextColumn()
            imgui.Text("Drop (M/A)") imgui.NextColumn() -- Med/Addiction
        end
        imgui.Separator()
        
        local fullChemData = {
            {"Skill 1",  "1.440 - 1.550$",  "2.160 - 2.325$",         "30'/. / 10'/.",      {1, 1, 1, 1}},
            {"Skill 2",  "1.488 - 1.588$",  "2.232 - 2.382$",         "35'/. / 15'/.",      {1, 1, 1, 1}},
            {"Skill 3",  "1.536 - 1.636$",  "2.304 - 2.454$",         "40'/. / 20'/.",      {0.4, 0.8, 1, 1}},
            {"Skill 4",  "1.584 - 1.684$",  "2.376 - 2.526$",         "45'/. / 25'/.",      {0.4, 0.8, 1, 1}},
            {"Skill 5",  "1.632 - 1.732$",  "2.448 - 2.598$",         "50'/. / 30'/.",      {0.4, 1, 0.4, 1}},  
            {"Skill 6",  "1.720 - 1.820$",  "2.580 - 2.730$",         "50'/. / 30'/.",      {0.4, 1, 0.4, 1}},  
            {"Skill 7",  "1.790 - 1.890$",  "2.685 - 2.835$",         "50'/. / 30'/.",      {0.4, 1, 0.4, 1}},   
            {"Skill 8",  "1.850 - 1.950$",  "2.775 - 2.925$",         "50'/. / 30'/.",      {0.4, 1, 0.4, 1}},  
            {"Skill 9",  "1.895 - 1.995$",  "2.842 - 2.992$",         "50'/. / 30'/.",      {0.4, 1, 0.4, 1}},  
            {"Skill 10", "1.930 - 2.030$",  "2.895 - 3.045$",         "50'/. / 30'/.",      {1, 0.8, 0, 1}}
        }
        for _, d in ipairs(fullChemData) do
            imgui.TextColored(imgui.ImVec4(d[5][1], d[5][2], d[5][3], d[5][4]), d[1]) imgui.NextColumn()           
            imgui.Text(d[2]) imgui.SameLine() 
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " | " .. d[3]) imgui.NextColumn()         
            imgui.Text(d[4]) imgui.NextColumn()
        end     
        imgui.Columns(1)
        imgui.Separator()
        
        if iniData.settings.lang == 0 then
            imgui.TextWrapped("Vehicule: Skill 1-2 (Mule), Skill 3-4 (Yankee), Skill 5-10 (Personal).")
        else
            imgui.TextWrapped("Vehicles: Skill 1-2 (Mule), Skill 3-4 (Yankee), Skill 5-10 (Personal).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.Columns(2, "chemFooter", false)    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "SISTEM KIT-URI:")
        imgui.BeginChild("KitInfo", imgui.ImVec2(0, 200), true)
            imgui.BulletText("Kit Medical: 100 HP")
            imgui.BulletText("Kit Dependenta: -30 unit.")
            imgui.BulletText("Capacitate: Skill-ul tau")
            imgui.TextDisabled("Ex: Skill 5 = 5 kit-uri total.")
        imgui.EndChild()   
        imgui.NextColumn()    
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PROGRESIE (PRAGURI):")
        imgui.BeginChild("ProgInfo", imgui.ImVec2(0, 200), true)
            imgui.Text("Skill 1 >> Skill 2: 30 de curse. (30 total)")
            imgui.Text("Skill 2 >> Skill 3: 60 de curse. (90 total)")
            imgui.Text("Skill 3 >> Skill 4: 120 de curse. (210 total)")
            imgui.Text("Skill 4 >> Skill 5: 240 de curse. (450 total)")
            imgui.Text("Skill 5 >> Skill 6: 200 de curse. (650 total)")
            imgui.Text("Skill 6 >> Skill 7: 250 de curse. (900 total)")
            imgui.Text("Skill 7 >> Skill 8: 300 de curse. (1200 total)")
            imgui.Text("Skill 8 >> Skill 9: 350 de curse. (1550 total)")
            imgui.Text("Skill 9 >> Skill 10: 350 de curse. (1900 total)")
        imgui.EndChild()    
    else
        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "KIT SYSTEM:")
        imgui.BeginChild("KitInfo", imgui.ImVec2(0, 200), true)
            imgui.BulletText("Medical Kit: 100 HP")
            imgui.BulletText("Addiction Kit: -30 units")
            imgui.BulletText("Capacity: Your skill level")
            imgui.TextDisabled("Ex: Skill 5 = 5 kits total.")
        imgui.EndChild()   
        imgui.NextColumn()    
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "PROGRESSION (THRESHOLDS):")
        imgui.BeginChild("ProgInfo", imgui.ImVec2(0, 200), true)
            imgui.Text("Skill 1 >> Skill 2: 30 runs. (30 total)")
            imgui.Text("Skill 2 >> Skill 3: 60 runs. (90 total)")
            imgui.Text("Skill 3 >> Skill 4: 120 runs. (210 total)")
            imgui.Text("Skill 4 >> Skill 5: 240 runs. (450 total)")
            imgui.Text("Skill 5 >> Skill 6: 200 runs. (650 total)")
            imgui.Text("Skill 6 >> Skill 7: 250 runs. (900 total)")
            imgui.Text("Skill 7 >> Skill 8: 300 runs. (1200 total)")
            imgui.Text("Skill 8 >> Skill 9: 350 runs. (1550 total)")
            imgui.Text("Skill 9 >> Skill 10: 350 runs. (1900 total)")
        imgui.EndChild()    
    end
    imgui.Columns(1)
end

local function renderDetectiveDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "D E T E C T I V E") 
    imgui.Separator()
    
    imgui.BeginChild("DetectiveGeneral", imgui.ImVec2(0, 120), true)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATII SI LOCATIE:")
            imgui.Separator()
            imgui.BulletText("Tip Job: Legal | Nivel Minim: 3 | HQ: Primaria Los Santos.")
            imgui.Spacing()
            imgui.TextWrapped("Scop: Gasirea locatiei exacte a unui anumit jucator pe harta.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATION AND LOCATION:")
            imgui.Separator()
            imgui.BulletText("Job Type: Legal | Minimum Level: 3 | HQ: Los Santos City Hall.")
            imgui.Spacing()
            imgui.TextWrapped("Purpose: Finding the exact location of a specific player on the map.")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "UTILIZARE COMANDA /FIND:")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "USING THE /FIND COMMAND:")
    end

    imgui.BeginChild("DetectiveCmd", imgui.ImVec2(0, 140), true)  
        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "/find [ID/Name]")
        imgui.Separator()
        if iniData.settings.lang == 0 then
            imgui.BulletText("Fixeaza un punct rosu (checkpoint) pe harta la locatia tintei.")
            imgui.BulletText("Afiseaza in chat zona si orasul (LS, SF, LV) unde se afla tinta.")
            imgui.BulletText("Actualizeaza periodic distanta pana la jucatorul cautat.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Cooldown: Comanda poate fi activa o data la 2 minute (S1-4).")
        else
            imgui.BulletText("Places a red checkpoint on the map at the target's location.")
            imgui.BulletText("Displays the zone and city (LS, SF, LV) where the target is located in chat.")
            imgui.BulletText("Periodically updates the distance to the tracked player.")
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Cooldown: The command can be used once every 2 minutes (S1-4).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "DURATA CHECKPOINT PER SKILL:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "CHECKPOINT DURATION PER SKILL:")
    end

    imgui.BeginChild("DetectiveTable", imgui.ImVec2(0, 160), true)  
        imgui.Columns(2, "detSkillCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Hex Nivel Skill") imgui.NextColumn()
            imgui.Text("Durata Checkpoint") imgui.NextColumn()
            imgui.Separator()       
            imgui.Text("Skill 1") imgui.NextColumn() imgui.Text("30 secunde") imgui.NextColumn()
            imgui.Text("Skill 2") imgui.NextColumn() imgui.Text("60 secunde") imgui.NextColumn()
            imgui.Text("Skill 3") imgui.NextColumn() imgui.Text("100 secunde") imgui.NextColumn()
            imgui.Text("Skill 4") imgui.NextColumn() imgui.Text("180 secunde") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 5") imgui.NextColumn() 
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "PERMANENT") imgui.NextColumn()    
        else
            imgui.Text("Skill Level") imgui.NextColumn()
            imgui.Text("Checkpoint Duration") imgui.NextColumn()
            imgui.Separator()       
            imgui.Text("Skill 1") imgui.NextColumn() imgui.Text("30 seconds") imgui.NextColumn()
            imgui.Text("Skill 2") imgui.NextColumn() imgui.Text("60 seconds") imgui.NextColumn()
            imgui.Text("Skill 3") imgui.NextColumn() imgui.Text("100 seconds") imgui.NextColumn()
            imgui.Text("Skill 4") imgui.NextColumn() imgui.Text("180 seconds") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 5") imgui.NextColumn() 
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "PERMANENT") imgui.NextColumn()    
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("DetectiveProgression", imgui.ImVec2(0, 150), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PRAGURI AVANSARE (UTILIZARI /FIND):")
            imgui.Separator()
            imgui.Spacing()   
            imgui.Columns(2, "detProgCols", false)
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 -> Skill 2:") imgui.SameLine() imgui.Text("50 utilizari")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 -> Skill 3:") imgui.SameLine() imgui.Text("50 utilizari")
            imgui.NextColumn()        
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 3 -> Skill 4:") imgui.SameLine() imgui.Text("100 utilizari")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 4 -> Skill 5:") imgui.SameLine() imgui.Text("200 utilizari")       
            imgui.Columns(1)
            imgui.Separator()
            imgui.Text("Total necesar pentru Skill 5: 400 folosiri /find.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PROGRESSION THRESHOLDS (/FIND USES):")
            imgui.Separator()
            imgui.Spacing()   
            imgui.Columns(2, "detProgCols", false)
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 -> Skill 2:") imgui.SameLine() imgui.Text("50 uses")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 -> Skill 3:") imgui.SameLine() imgui.Text("50 uses")
            imgui.NextColumn()        
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 3 -> Skill 4:") imgui.SameLine() imgui.Text("100 uses")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 4 -> Skill 5:") imgui.SameLine() imgui.Text("200 uses")       
            imgui.Columns(1)
            imgui.Separator()
            imgui.Text("Total required for Skill 5: 400 /find uses.")
        end
    imgui.EndChild()
end

local function renderTransporterDetails()
    imgui.BeginChild("TransporterMainChild", imgui.ImVec2(0, 0), true)
        
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "T R A N S P O R T E R") 
        imgui.Separator()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "Caracteristici Generale")
            imgui.Separator()
            imgui.BulletText("Jucatorii care lucreaza la curier, trebuie sa livreze colete la casele indicate de server.")
            imgui.BulletText("Jobul de curier este legal si necesita minim nivel 3.")
            imgui.BulletText("Va puteti angaja din zona K.A.C.C Military Fuels, Las Venturas.")
            imgui.BulletText("Dupa aceea va trebui sa livrati pachetele la case individual.")
            imgui.BulletText("Comanda: /work | Cooldown: 40 secunde.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "General Features")
            imgui.Separator()
            imgui.BulletText("Players working as transporters must deliver packages to the houses indicated by the server.")
            imgui.BulletText("The transporter job is legal and requires at least level 3.")
            imgui.BulletText("You can take the job at K.A.C.C Military Fuels, Las Venturas.")
            imgui.BulletText("After that, you will have to deliver packages to individual houses.")
            imgui.BulletText("Command: /work | Cooldown: 40 seconds.")
        end
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Livrari maxime in functie de skill si distanta de livrare")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Max deliveries based on skill and delivery distance")
        end
        imgui.Separator()
        
        imgui.BeginChild("LivrariDistanteChild", imgui.ImVec2(0, 120), true)
            imgui.Columns(3, "livrariCols", false)
            if iniData.settings.lang == 0 then
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Livrari Maxime") imgui.NextColumn()
                imgui.Text("Distanta (Unitati)") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1-2") imgui.NextColumn() imgui.Text("maxim 10 colete") imgui.NextColumn() imgui.Text("intre 500 si 750 unitati.") imgui.NextColumn()
                imgui.Text("Skill 3-4") imgui.NextColumn() imgui.Text("maxim 20 de colete") imgui.NextColumn() imgui.Text("intre 750 si 1.000 unitati.") imgui.NextColumn()
                imgui.Text("Skill 5-6") imgui.NextColumn() imgui.Text("maxim 30 de colete") imgui.NextColumn() imgui.Text("intre 1.000 si 1.250 unitati.") imgui.NextColumn()
                imgui.Text("Skill 7-8") imgui.NextColumn() imgui.Text("maxim 40 de colete") imgui.NextColumn() imgui.Text("intre 1.250 si 1.500 unitati.") imgui.NextColumn()
                imgui.Text("Skill 9-10") imgui.NextColumn() imgui.Text("maxim 50 de colete") imgui.NextColumn() imgui.Text("intre 1.500 si 2.000 unitati.") imgui.NextColumn()
            else
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Max Deliveries") imgui.NextColumn()
                imgui.Text("Distance (Units)") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1-2") imgui.NextColumn() imgui.Text("max 10 packages") imgui.NextColumn() imgui.Text("between 500 and 750 units.") imgui.NextColumn()
                imgui.Text("Skill 3-4") imgui.NextColumn() imgui.Text("max 20 packages") imgui.NextColumn() imgui.Text("between 750 and 1,000 units.") imgui.NextColumn()
                imgui.Text("Skill 5-6") imgui.NextColumn() imgui.Text("max 30 packages") imgui.NextColumn() imgui.Text("between 1,000 and 1,250 units.") imgui.NextColumn()
                imgui.Text("Skill 7-8") imgui.NextColumn() imgui.Text("max 40 packages") imgui.NextColumn() imgui.Text("between 1,250 and 1,500 units.") imgui.NextColumn()
                imgui.Text("Skill 9-10") imgui.NextColumn() imgui.Text("max 50 packages") imgui.NextColumn() imgui.Text("between 1,500 and 2,000 units.") imgui.NextColumn()
            end
            imgui.Columns(1)
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Castiguri in functie de skill si de distanta de livrare")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Earnings based on skill and delivery distance")
        end
        imgui.Separator()
        
        imgui.BeginChild("CastiguriChild", imgui.ImVec2(0, 120), true)
            imgui.Columns(3, "castiguriCols", false)
            if iniData.settings.lang == 0 then
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Formula Calcul") imgui.NextColumn()
                imgui.Text("Castig Estimativ") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1-2") imgui.NextColumn() imgui.Text("0.5 * distanta_parcursa") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "intre 250$ si 375$.") imgui.NextColumn()
                imgui.Text("Skill 3-4") imgui.NextColumn() imgui.Text("0.7 * distanta_parcursa") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "intre 525$ si 700$.") imgui.NextColumn()
                imgui.Text("Skill 5-6") imgui.NextColumn() imgui.Text("0.9 * distanta_parcursa") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "intre 900$ si 1,125$") imgui.NextColumn()
                imgui.Text("Skill 7-8") imgui.NextColumn() imgui.Text("1.1 * distanta_parcursa") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "intre 1,375 si 1,650$.") imgui.NextColumn()
                imgui.Text("Skill 9-10") imgui.NextColumn() imgui.Text("1.3 * distanta_parcursa") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "intre 1,950$ si 2,600$") imgui.NextColumn()
            else
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Calculation Formula") imgui.NextColumn()
                imgui.Text("Estimated Profit") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1-2") imgui.NextColumn() imgui.Text("0.5 * distance_traveled") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "between $250 and $375.") imgui.NextColumn()
                imgui.Text("Skill 3-4") imgui.NextColumn() imgui.Text("0.7 * distance_traveled") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "between $525 and $700.") imgui.NextColumn()
                imgui.Text("Skill 5-6") imgui.NextColumn() imgui.Text("0.9 * distance_traveled") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "between $900 and $1,125") imgui.NextColumn()
                imgui.Text("Skill 7-8") imgui.NextColumn() imgui.Text("1.1 * distance_traveled") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "between $1,375 and $1,650.") imgui.NextColumn()
                imgui.Text("Skill 9-10") imgui.NextColumn() imgui.Text("1.3 * distance_traveled") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "between $1,950 and $2,600") imgui.NextColumn()
            end
            imgui.Columns(1)
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Avansarea in skill")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Skill Progression")
        end
        imgui.Separator()
        
        imgui.BeginChild("AvansareChild", imgui.ImVec2(0, 190), true)
            if iniData.settings.lang == 0 then
                imgui.BulletText("Pentru a trece de la skill 1 la skill 2, trebuie sa terminati 60 de curse.")
                imgui.BulletText("Pentru a trece de la skill 2 la skill 3, trebuie sa terminati alte 60 de curse. (total: 120)")
                imgui.BulletText("Pentru a trece de la skill 3 la skill 4, trebuie sa terminati 120 de curse. (total: 240)")
                imgui.BulletText("Pentru a trece de la skill 4 la skill 5, trebuie sa terminati 240 de curse. (total: 480)")
                imgui.BulletText("Pentru a trece de la skill 5 la skill 6, trebuie sa terminati 200 de curse. (total: 680)")
                imgui.BulletText("Pentru a trece de la skill 6 la skill 7, trebuie sa terminati 250 de curse. (total: 930)")
                imgui.BulletText("Pentru a trece de la skill 7 la skill 8, trebuie sa terminati 300 de curse. (total: 1230)")
                imgui.BulletText("Pentru a trece de la skill 8 la skill 9, trebuie sa terminati 350 de curse. (total: 1580)")
                imgui.BulletText("Pentru a trece de la skill 9 la skill 10, trebuie sa terminati 350 de curse. (total: 1930)")
            else
                imgui.BulletText("To upgrade from skill 1 to skill 2, you must complete 60 runs.")
                imgui.BulletText("To upgrade from skill 2 to skill 3, you must complete another 60 runs. (total: 120)")
                imgui.BulletText("To upgrade from skill 3 to skill 4, you must complete 120 runs. (total: 240)")
                imgui.BulletText("To upgrade from skill 4 to skill 5, you must complete 240 runs. (total: 480)")
                imgui.BulletText("To upgrade from skill 5 to skill 6, you must complete 200 runs. (total: 680)")
                imgui.BulletText("To upgrade from skill 6 to skill 7, you must complete 250 runs. (total: 930)")
                imgui.BulletText("To upgrade from skill 7 to skill 8, you must complete 300 runs. (total: 1,230)")
                imgui.BulletText("To upgrade from skill 8 to skill 9, you must complete 350 runs. (total: 1,580)")
                imgui.BulletText("To upgrade from skill 9 to skill 10, you must complete 350 runs. (total: 1,930)")
            end
        imgui.EndChild()
        imgui.Spacing()
        
        imgui.BeginChild("PuncteAliniateChild", imgui.ImVec2(0, 110), true)
            imgui.Columns(2, "puncteAliniateCols", false)

            if iniData.settings.lang == 0 then
                imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Acordarea punctelor de skill")
                imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Acordarea punctelor de maraton/clan xp")
                imgui.NextColumn()

                imgui.Separator() imgui.NextColumn()
                imgui.Separator() imgui.NextColumn()

                imgui.BulletText("Skill 1-4: vei primi 1 punct de skill per livrare.")
                imgui.BulletText("Skill 5-6: vei primi 2 puncte de skill per livrare.")
                imgui.BulletText("Skill 7-10: vei primi 3 puncte de skill per livrare.")
                imgui.NextColumn()
                
                imgui.BulletText("Skill 1-4: vei primi 1 punct de maraton/clan xp per livrare.")
                imgui.BulletText("Skill 5-6: vei primi 2 puncte de maraton/clan xp per livrare.")
                imgui.BulletText("Skill 7-10: vei primi 4 puncte de maraton/clan xp per livrare.")
            else
                imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Skill points reward")
                imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Marathon/Clan XP points reward")
                imgui.NextColumn()

                imgui.Separator() imgui.NextColumn()
                imgui.Separator() imgui.NextColumn()

                imgui.BulletText("Skill 1-4: you will receive 1 skill point per delivery.")
                imgui.BulletText("Skill 5-6: you will receive 2 skill points per delivery.")
                imgui.BulletText("Skill 7-10: you will receive 3 skill points per delivery.")
                imgui.NextColumn()
                
                imgui.BulletText("Skill 1-4: you will receive 1 marathon/clan xp point per delivery.")
                imgui.BulletText("Skill 5-6: you will receive 2 marathon/clan xp points per delivery.")
                imgui.BulletText("Skill 7-10: you will receive 4 marathon/clan xp points per delivery.")
            end
            imgui.Columns(1)  
        imgui.EndChild()
        
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Tipuri de masini in functie de skill")
            imgui.Separator()
            imgui.BeginChild("MasiniChild", imgui.ImVec2(0, 65), true)
                imgui.BulletText("Burrito - Skillul necesar: 1, 2, 3, 4")
                imgui.BulletText("Solair - Skillul necesar: 5, 6, 7, 8, 9, 10")
            imgui.EndChild()
        else
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Vehicle types based on skill")
            imgui.Separator()
            imgui.BeginChild("MasiniChild", imgui.ImVec2(0, 65), true)
                imgui.BulletText("Burrito - Required Skill: 1, 2, 3, 4")
                imgui.BulletText("Solair - Required Skill: 5, 6, 7, 8, 9, 10")
            imgui.EndChild()
        end

    imgui.EndChild()
end

local function renderDrugsDealerDetails()
    imgui.BeginChild("DrugsDealerMainChild", imgui.ImVec2(0, 0), true)

        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "D R U G S - D E A L E R") 
        imgui.Separator()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Castiguri in functie de skill pentru jucatorii fara cont premium (o cursa)")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Earnings based on skill for players without a premium account (one run)")
        end
        imgui.Separator()
        
        imgui.BeginChild("DrugCastiguriChild", imgui.ImVec2(0, 140), true)
            imgui.Columns(3, "drugProfitCols", false)
            if iniData.settings.lang == 0 then
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Castig Estimativ") imgui.NextColumn()
                imgui.Text("Timp Mediu Cursa") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aproximativ $973.") imgui.NextColumn() imgui.Text("98 secunde.") imgui.NextColumn()
                imgui.Text("Skill 2") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aproximativ $1074.") imgui.NextColumn() imgui.Text("91 secunde.") imgui.NextColumn()
                imgui.Text("Skill 3") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aproximativ $1203.") imgui.NextColumn() imgui.Text("80 secunde.") imgui.NextColumn()
                imgui.Text("Skill 4") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aproximativ $1375.") imgui.NextColumn() imgui.Text("76 secunde.") imgui.NextColumn()
                imgui.Text("Skill 5") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aproximativ $1548.") imgui.NextColumn() imgui.Text("57 secunde.") imgui.NextColumn()
            else
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Estimated Profit") imgui.NextColumn()
                imgui.Text("Average Run Time") imgui.NextColumn()
                imgui.Separator()
                imgui.Text("Skill 1") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Approximately $973.") imgui.NextColumn() imgui.Text("98 seconds.") imgui.NextColumn()
                imgui.Text("Skill 2") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Approximately $1074.") imgui.NextColumn() imgui.Text("91 seconds.") imgui.NextColumn()
                imgui.Text("Skill 3") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Approximately $1203.") imgui.NextColumn() imgui.Text("80 seconds.") imgui.NextColumn()
                imgui.Text("Skill 4") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Approximately $1375.") imgui.NextColumn() imgui.Text("76 seconds.") imgui.NextColumn()
                imgui.Text("Skill 5") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Approximately $1548.") imgui.NextColumn() imgui.Text("57 seconds.") imgui.NextColumn()
            end
            imgui.Columns(1)
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Curse necesare pentru avansare in skill")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Runs required for skill progression")
        end
        imgui.Separator()
        
        imgui.BeginChild("DrugAvansareChild", imgui.ImVec2(0, 100), true)
            if iniData.settings.lang == 0 then
                imgui.BulletText("Pentru a se efectua trecerea de la skill 1 la skill 2, un muncitor are nevoie de 50 de curse.")
                imgui.BulletText("Pentru a se efectua trecerea de la skill 2 la skill 3, un muncitor are nevoie de 50 de curse. (total: 100)")
                imgui.BulletText("Pentru a se efectua trecerea de la skill 3 la skill 4, un muncitor are nevoie de 100 de curse. (total: 200)")
                imgui.BulletText("Pentru a se efectua trecerea de la skill 4 la skill 5, un muncitor are nevoie de 200 de curse. (total: 400)")
            else
                imgui.BulletText("To upgrade from skill 1 to skill 2, a worker needs 50 runs.")
                imgui.BulletText("To upgrade from skill 2 to skill 3, a worker needs 50 runs. (total: 100)")
                imgui.BulletText("To upgrade from skill 3 to skill 4, a worker needs 100 runs. (total: 200)")
                imgui.BulletText("To upgrade from skill 4 to skill 5, a worker needs 200 runs. (total: 400)")
            end
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Vehicule in functie de skill")
            imgui.Separator()
            imgui.BeginChild("DrugVehiculeChild", imgui.ImVec2(0, 80), true)
                imgui.BulletText("Benson - Skillul necesar: 1, 2")
                imgui.BulletText("Berkley's RC Van - Skillul necesar: 3, 4")
                imgui.BulletText("Vehicul Personal - Skill 5 - Orice vehicul personal")
            imgui.EndChild()
        else
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Vehicles based on skill")
            imgui.Separator()
            imgui.BeginChild("DrugVehiculeChild", imgui.ImVec2(0, 80), true)
                imgui.BulletText("Benson - Required Skill: 1, 2")
                imgui.BulletText("Berkley's RC Van - Required Skill: 3, 4")
                imgui.BulletText("Personal Vehicle - Skill 5 - Any personal vehicle")
            imgui.EndChild()
        end
        imgui.Spacing()

       local isRO = (iniData.settings.lang == 0)

        imgui.BeginChild("DrugComenziChild", imgui.ImVec2(0, 220), true)
            imgui.Columns(2, "drugComenziCols", false)

            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "/getdrugs")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "/selldrugs")
            imgui.NextColumn()

            imgui.Separator() imgui.NextColumn()
            imgui.Separator() imgui.NextColumn()

            -- Traducere pentru sectiunea de sus
            if isRO then
                imgui.BulletText("Skill 1/2: Nu pot cumpara.")
                imgui.BulletText("Skill 3/4: Max 25g/h.")
                imgui.BulletText("Skill 5: Max 50g/h.")
                imgui.NextColumn()
                imgui.TextWrapped("Foloseste pentru a vinde droguri altor jucatori.")
            else
                imgui.BulletText("Skill 1/2: Cannot buy.")
                imgui.BulletText("Skill 3/4: Max 25g/h.")
                imgui.BulletText("Skill 5: Max 50g/h.")
                imgui.NextColumn()
                imgui.TextWrapped("Use to sell drugs to other players.")
            end
            
            imgui.Columns(1) -- Resetam coloanele
            
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()

            -- Traducere pentru lista drogurilor
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Informatii Droguri:") or "Drugs Information:")      
            imgui.Text(isRO and u8("Marijuana: +10 HP, 1 '/. dependenta, cooldown scurt (12g)") or "Marijuana: +10 HP, 1 '/. addiction, short cooldown (12g)")
            imgui.Text(isRO and u8("Cocaina: +30 HP, 3 '/. dependenta, recuperare rapida (18g)") or "Cocaine: +30 HP, 3 '/. addiction, fast recovery (18g)")
            imgui.Text(isRO and u8("Ecstasy: +70 HP, 8 '/. dependenta, imobilizare scurta (26g)") or "Ecstasy: +70 HP, 8 '/. addiction, short immobilization (26g)")
            imgui.Text(isRO and u8("Metamfetamina: Sanatate completa, 15 '/. dependenta, 15s imob. (38g)") or "Methamphetamine: Full health, 15 '/. addiction, 15s imob. (38g)")

        imgui.EndChild()
            
            if iniData.settings.lang == 0 then
                imgui.BulletText("Skill 1 - Nu poate cumpara droguri de la un sediu (crack house).")
                imgui.BulletText("Skill 2 - Nu poate cumpara droguri de la un sediu (crack house).")
                imgui.BulletText("Skill 3 - Maxim 25 de grame de droguri pe ora.")
                imgui.BulletText("Skill 4 - Maxim 25 de grame de droguri pe ora.")
                imgui.BulletText("Skill 5 - Maxim 50 de grame de droguri pe ora.")
                imgui.NextColumn()
                
                imgui.TextWrapped("Folosind aceasta comanda, un jucator poate sa vanda o anumita cantitate de droguri unui alt jucator, contra unei sume de bani.")
            else
                imgui.BulletText("Skill 1 - Cannot buy drugs from a crack house.")
                imgui.BulletText("Skill 2 - Cannot buy drugs from a crack house.")
                imgui.BulletText("Skill 3 - Maximum 25 grams of drugs per hour.")
                imgui.BulletText("Skill 4 - Maximum 25 grams of drugs per hour.")
                imgui.BulletText("Skill 5 - Maximum 50 grams of drugs per hour.")
                imgui.NextColumn()
                
                imgui.TextWrapped("Using this command, a player can sell a certain amount of drugs to another player for a sum of money.")
            end
            
            imgui.Columns(1)
        imgui.EndChild()
    imgui.EndChild()
end

local function renderCarJackerDetails()
    imgui.BeginChild("CarJackerMainChild", imgui.ImVec2(0, 0), true)

        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "C A R - J A C K E R") 
        imgui.Separator()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "Caracteristici generale")
            imgui.Separator()
            imgui.BeginChild("CarJackerCaracteristiciChild", imgui.ImVec2(0, 260), true)
                imgui.BulletText("Exista cate 3 puncte de predare in fiecare oras.")
                imgui.BulletText("Pentru a fura vehicule, aveti nevoie de permis de conducere.")
                imgui.BulletText("Trebuie sa asteptati 5 minute de la predarea ultimei masini pentru a fura o alta. Timpul este salvat si la iesirea de pe server.")
                imgui.BulletText("Vehiculele pe care le puteti fura sunt doar cele corespunzatoare skillului detinut (vezi mai jos).")
                imgui.BulletText("Aveti timp 20 de secunde sa reveniti in vehicul, daca il parasiti, altfel veti pierde cursa.")
                imgui.BulletText("Nu se pot fura biciclete, barci, avioane, elicoptere sau masini ale caror chei le detineti.")
                imgui.BulletText("Folosirea comenzii /picklock duce la wanted 1 automat.")
                imgui.BulletText("Pentru furtul unui vehicul de politie, veti primi automat wanted 3, fara drept de predare.")
                imgui.BulletText("Proprietarii masinilor si membrii gangurilor vor primi mesaje specifice atunci cand masinile lor sunt furate.")
                imgui.BulletText("Mafiotii nu-si pot fura vehiculele propriei factiuni.")
                imgui.BulletText("Nu va puteti fura propria masina personala.")
                imgui.BulletText("Proprietarii vor putea folosi /locatecar pentru a gasi hotul, iar membrii de gang au la dispozitie /stealers.")
            imgui.EndChild()
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "General features")
            imgui.Separator()
            imgui.BeginChild("CarJackerCaracteristiciChild", imgui.ImVec2(0, 260), true)
                imgui.BulletText("There are 3 delivery points in each city.")
                imgui.BulletText("To steal vehicles, you need a driving license.")
                imgui.BulletText("You must wait 5 minutes after delivering the last car before stealing another. The timer saves even if you leave the server.")
                imgui.BulletText("The vehicles you can steal are only those corresponding to your skill level (see below).")
                imgui.BulletText("You have 20 seconds to return to the vehicle if you leave it, otherwise you will lose the run.")
                imgui.BulletText("You cannot steal bicycles, boats, planes, helicopters, or cars that you own the keys to.")
                imgui.BulletText("Using the /picklock command automatically gives you wanted 1.")
                imgui.BulletText("Stealing a police vehicle automatically grants you wanted 3, with no right to surrender.")
                imgui.BulletText("Car owners and gang members will receive specific notifications when their vehicles are stolen.")
                imgui.BulletText("Mafia members cannot steal vehicles belonging to their own faction.")
                imgui.BulletText("You cannot steal your own personal vehicle.")
                imgui.BulletText("Owners can use /locatecar to find the thief, while gang members can use /stealers.")
            imgui.EndChild()
        end
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Castiguri in functie de skill")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Earnings based on skill")
        end
        imgui.Separator()
        
        imgui.BeginChild("CarJackerCastiguriChild", imgui.ImVec2(0, 150), true)
            imgui.Columns(2, "cjCastiguriCols", false)
            if iniData.settings.lang == 0 then
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Castig") imgui.NextColumn()
            else
                imgui.Text("Skill") imgui.NextColumn()
                imgui.Text("Earnings") imgui.NextColumn()
            end
            imgui.Separator()
            imgui.Text("Skill 1") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$978") imgui.NextColumn()
            imgui.Text("Skill 2") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1070") imgui.NextColumn()
            imgui.Text("Skill 3") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1200") imgui.NextColumn()
            imgui.Text("Skill 4") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1380") imgui.NextColumn()
            imgui.Text("Skill 5") imgui.NextColumn() imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1659") imgui.NextColumn()
            imgui.Columns(1)
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Avansare in skill")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Skill progression")
        end
        imgui.Separator()
        
        imgui.BeginChild("CarJackerAvansareChild", imgui.ImVec2(0, 90), true)
            if iniData.settings.lang == 0 then
                imgui.BulletText("Pentru a trece de la skill 1 la skill 2, trebuie sa furati 60 de vehicule.")
                imgui.BulletText("Pentru a trece de la skill 2 la skill 3, trebuie sa furati alte 60 de vehicule. (total: 120)")
                imgui.BulletText("Pentru a trece de la skill 3 la skill 4, trebuie sa furati alte 120 de vehicule. (total: 240)")
                imgui.BulletText("Pentru a trece de la skill 4 la skill 5, trebuie sa furati alte 240 de vehicule. (total: 480)")
            else
                imgui.BulletText("To upgrade from skill 1 to skill 2, you must steal 60 vehicles.")
                imgui.BulletText("To upgrade from skill 2 to skill 3, you must steal another 60 vehicles. (total: 120)")
                imgui.BulletText("To upgrade from skill 3 to skill 4, you must steal another 120 vehicles. (total: 240)")
                imgui.BulletText("To upgrade from skill 4 to skill 5, you must steal another 240 vehicles. (total: 480)")
            end
        imgui.EndChild()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Tipuri de masini care pot fi furate, dupa skill")
            imgui.Separator()
            imgui.BeginChild("CarJackerMasiniChild", imgui.ImVec2(0, 110), true)
                imgui.BulletText("La skill 1, jucatorii vor putea fura doar vehicule publice (aflate pe strada; oricine le poate conduce).")
                imgui.BulletText("La skill 2, jucatorii vor putea fura doar vehicule personale descuiate.")
                imgui.BulletText("La skill 3, jucatorii vor putea fura doar vehicule ale gangurilor.")
                imgui.BulletText("La skill 4, jucatorii vor putea fura doar vehicule personale incuiate.")
                imgui.BulletText("La skill 5, jucatorii vor putea fura vehicule apartinand departamentelor sau pot opta sa aleaga sa fure vehiculele disponibile pentru celelalte skilluri.")
            imgui.EndChild()
        else
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Vehicle types that can be stolen, based on skill")
            imgui.Separator()
            imgui.BeginChild("CarJackerMasiniChild", imgui.ImVec2(0, 110), true)
                imgui.BulletText("At skill 1, players can only steal public vehicles (found on the street; anyone can drive them).")
                imgui.BulletText("At skill 2, players can only steal unlocked personal vehicles.")
                imgui.BulletText("At skill 3, players can only steal gang vehicles.")
                imgui.BulletText("At skill 4, players can only steal locked personal vehicles.")
                imgui.BulletText("At skill 5, players can steal faction/department vehicles or choose to steal vehicles available for lower skills.")
            imgui.EndChild()
        end
        imgui.Spacing()

        imgui.BeginChild("CarJackerComenziChild", imgui.ImVec2(0, 145), true)
            imgui.Columns(2, "cjComenziCols", false)

            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "/work")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "/picklock")
            imgui.NextColumn()

            imgui.Separator() imgui.NextColumn()
            imgui.Separator() imgui.NextColumn()

            if iniData.settings.lang == 0 then
                imgui.BulletText("Aceasta comanda va permite sa incepeti lucrul.")
                imgui.BulletText("Trebuie folosita inainte de a fura sau de a sparge (/picklock) un vehicul.")
                imgui.BulletText("Este disponibila la 5 minute dupa incheierea misiunii precedente (cu succes sau nu).")
                imgui.BulletText("La folosirea comenzii, veti primi wanted 3, daca aveti skill 5 si este folosita pe un vehicul de politie.")
                imgui.TextDisabled("Nota: Puteti anula aceasta actiune folosind comanda /cancel carjacker")
                imgui.NextColumn()
                
                imgui.BulletText("Comanda va permite sa deschideti masinile personale incuiate si nefolosite de un alt sofer la acel moment.")
                imgui.BulletText("Este necesara folosireacomenzii /work in prealabil.")
                imgui.BulletText("La folosirea comenzii, veti primi wanted 1.")
            else
                imgui.BulletText("This command allows you to start working.")
                imgui.BulletText("It must be used before stealing or breaking into (/picklock) a vehicle.")
                imgui.BulletText("It is available 5 minutes after ending the previous mission (successful or not).")
                imgui.BulletText("When using the command, you will receive wanted 3 if you have skill 5 and use it on a police vehicle.")
                imgui.TextDisabled("Note: You can cancel this action by using /cancel carjacker")
                imgui.NextColumn()
                
                imgui.BulletText("This command allows you to open locked personal vehicles that are not currently occupied by another driver.")
                imgui.BulletText("You must use the /work command beforehand.")
                imgui.BulletText("When using the command, you will receive wanted 1.")
            end
            
            imgui.Columns(1) 
        imgui.EndChild()

    imgui.EndChild()
end

local function renderMecanicDetails()
    imgui.BeginChild("MecanicMainChild", imgui.ImVec2(0, 0), true)

        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "M E C A N I C") 
        imgui.Separator()
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "Informatii Generale")
            imgui.Separator()
            imgui.TextWrapped("Odata folosita comanda /work, mergeti la checkpoint si completati unul din cele 3 minigame-uri:")
            imgui.BulletText("Tow The Car: Controlati TowTruckul din click stanga/dreapta (sau Y/N pe android) pana atingeti masina.")
            imgui.BulletText("Adjust the Oil Level: Reglati uleiul pana la maxim. Nu goliti motorul si nu-l supraalimentati.")
            imgui.BulletText("Mount the Components: Montati un set de 3 piese pe vehicul in ordinea specificata.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "General Information")
            imgui.Separator()
            imgui.TextWrapped("Once you use the /work command, go to the checkpoint and complete one of the 3 minigames:")
            imgui.BulletText("Tow The Car: Control the TowTruck using left/right click (or Y/N on android) until you hook the car.")
            imgui.BulletText("Adjust the Oil Level: Fill the oil to the maximum. Do not empty the engine and do not overfill it.")
            imgui.BulletText("Mount the Components: Mount a set of 3 components onto the vehicle in the specified order.")
        end
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Perk-uri Job (Skill Mare)")
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "Change Vehicle Color (Skill 6+): Schimba culoarea permanenta (Hidden/NonHidden). Bani redirectionati in biz.")
            imgui.TextColored(imgui.ImVec4(0.1, 0.6, 0.9, 1), "Tune The Vehicle (Skill 7+): Tuneaza vehiculul fara biz. Bani redirectionati la cel mai apropiat Tuning. Discounturi:")
            imgui.BulletText("S7: Front/Rear Bumper, Sideskirts, Hydraulics (Discount 5 '/.) | S8: Roof, Front Bullbar, Hood, Lamps, Vents (Discount 10 '/.)")
            imgui.BulletText("S9: Spoiler, Wheels, Exhaust (Discount 15 '/.) | S10: NOS, Paintjob, Neons (Discount 20 '/.)")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Job Perks (High Skill)")
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "Change Vehicle Color (Skill 6+): Change the permanent color (Hidden/NonHidden). Money redirected to business.")
            imgui.TextColored(imgui.ImVec4(0.1, 0.6, 0.9, 1), "Tune The Vehicle (Skill 7+): Tune the vehicle without a business. Money redirected to the nearest Tuning shop. Discounts:")
            imgui.BulletText("S7: Front/Rear Bumper, Sideskirts, Hydraulics (5 '/. Discount) | S8: Roof, Front Bullbar, Hood, Lamps, Vents (10 '/. Discount)")
            imgui.BulletText("S9: Spoiler, Wheels, Exhaust (15 '/. Discount) | S10: NOS, Paintjob, Neons (20 '/. Discount)")
        end
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Eficienta (Reparatii / Combustibil) si Castiguri")
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Nota: Skill 5+ ofera posibilitatea de a repara/reumple rezervorul cu motorul pornit.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "Efficiency (Repairs / Fuel) and Earnings")
            imgui.Separator()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Note: Skill 5+ offers the possibility to repair/refill the tank while the engine is running.")
        end
        
        imgui.Columns(4, "mecStatsCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("HP Repair") imgui.NextColumn()
            imgui.Text("Refill (Fara / Cu Premium)") imgui.NextColumn()
            imgui.Text("Castig (Fara / Cu Premium)") imgui.NextColumn()
            imgui.Separator()
            
            local mecStats = {
                {"Skill 1", "100 HP", "55 '/. / 83 '/.", "$90 - $650 / $135 - $975"},
                {"Skill 2", "200 HP", "60 '/. / 90 '/.", "$102 - $718 / $153 - $1,077"},
                {"Skill 3", "300 HP", "65 '/. / 98 '/.", "$120 - $840 / $180 - $1,260"},
                {"Skill 4", "400 HP", "70 '/. / 105 '/.", "$145 - $1025 / $217 - $1,537"},
                {"Skill 5", "500 HP", "75 '/. / 113 '/.", "$185 - $1305 / $277 - $1,957"},
                {"Skill 6", "600 HP", "80 '/. / 120 '/.", "$225 - $1585 / $337 - $2,377"},
                {"Skill 7", "700 HP", "85 '/. / 128 '/.", "$280 - $1960 / $420 - $2,940"},
                {"Skill 8", "800 HP", "90 '/. / 135 '/.", "$335 - $2415 / $502 - $3,622"},
                {"Skill 9", "900 HP", "95 '/. / 143 '/.", "$415 - $2935 / $622 - $4,402"},
                {"Skill 10", "1000 HP", "100 '/. / 150 '/.", "$510 - $3390 / $765 - $5,085"}
            }
            for _, stat in ipairs(mecStats) do
                imgui.Text(stat[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), stat[2]) imgui.NextColumn()
                imgui.Text(stat[3]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), stat[4]) imgui.NextColumn()
            end
        else
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("HP Repair") imgui.NextColumn()
            imgui.Text("Refill (Without / With Premium)") imgui.NextColumn()
            imgui.Text("Earnings (Without / With Premium)") imgui.NextColumn()
            imgui.Separator()
            
            local mecStats = {
                {"Skill 1", "100 HP", "55 '/. / 83 '/.", "$90 - $650 / $135 - $975"},
                {"Skill 2", "200 HP", "60 '/. / 90 '/.", "$102 - $718 / $153 - $1,077"},
                {"Skill 3", "300 HP", "65 '/. / 98 '/.", "$120 - $840 / $180 - $1,260"},
                {"Skill 4", "400 HP", "70 '/. / 105 '/.", "$145 - $1025 / $217 - $1,537"},
                {"Skill 5", "500 HP", "75 '/. / 113 '/.", "$185 - $1305 / $277 - $1,957"},
                {"Skill 6", "600 HP", "80 '/. / 120 '/.", "$225 - $1585 / $337 - $2,377"},
                {"Skill 7", "700 HP", "85 '/. / 128 '/.", "$280 - $1960 / $420 - $2,940"},
                {"Skill 8", "800 HP", "90 '/. / 135 '/.", "$335 - $2415 / $502 - $3,622"},
                {"Skill 9", "900 HP", "95 '/. / 143 '/.", "$415 - $2935 / $622 - $4,402"},
                {"Skill 10", "1000 HP", "100 '/. / 150 '/.", "$510 - $3390 / $765 - $5,085"}
            }
            for _, stat in ipairs(mecStats) do
                imgui.Text(stat[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), stat[2]) imgui.NextColumn()
                imgui.Text(stat[3]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), stat[4]) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Kit-uri (Preturi / Uzura)")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "Kits (Prices / Wear)")
        end
        imgui.Separator()
        
        imgui.Columns(3, "kitsCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Kit Repair (Pret / Uzura)") imgui.NextColumn()
            imgui.Text("Kit Refill (Pret / Uzura)") imgui.NextColumn()
            imgui.Separator()
            
            local kitStats = {
                {"Skill 3", "$15.000 | 12 '/.", "$25.000 | 13 '/."},
                {"Skill 4", "$12.000 | 11 '/.", "$20.000 | 12 '/."},
                {"Skill 5", "$12.000 | 10 '/.", "$20.000 | 11 '/."},
                {"Skill 6", "$12.000 | 9 '/.",  "$20.000 | 10 '/."},
                {"Skill 7", "$12.000 | 8 '/.",  "$20.000 | 9 '/."},
                {"Skill 8", "$10.000 | 7 '/.",  "$15.000 | 8 '/."},
                {"Skill 9", "$10.000 | 6 '/.",  "$15.000 | 7 '/."},
                {"Skill 10", "$10.000 | 5 '/.", "$15.000 | 6 '/."}
            }
            for _, kit in ipairs(kitStats) do
                imgui.Text(kit[1]) imgui.NextColumn()
                imgui.Text(kit[2]) imgui.NextColumn()
                imgui.Text(kit[3]) imgui.NextColumn()
            end
        else
            imgui.Text("Skill") imgui.NextColumn()
            imgui.Text("Repair Kit (Price / Wear)") imgui.NextColumn()
            imgui.Text("Refill Kit (Price / Wear)") imgui.NextColumn()
            imgui.Separator()
            
            local kitStats = {
                {"Skill 3", "$15.000 | 12 '/.", "$25.000 | 13 '/."},
                {"Skill 4", "$12.000 | 11 '/.", "$20.000 | 12 '/."},
                {"Skill 5", "$12.000 | 10 '/.", "$20.000 | 11 '/."},
                {"Skill 6", "$12.000 | 9 '/.",  "$20.000 | 10 '/."},
                {"Skill 7", "$12.000 | 8 '/.",  "$20.000 | 9 '/."},
                {"Skill 8", "$10.000 | 7 '/.",  "$15.000 | 8 '/."},
                {"Skill 9", "$10.000 | 6 '/.",  "$15.000 | 7 '/."},
                {"Skill 10", "$10.000 | 5 '/.", "$15.000 | 6 '/."}
            }
            for _, kit in ipairs(kitStats) do
                imgui.Text(kit[1]) imgui.NextColumn()
                imgui.Text(kit[2]) imgui.NextColumn()
                imgui.Text(kit[3]) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
        imgui.Spacing()

        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Avansare & Vehicule")
            imgui.Separator()
            
            imgui.Columns(2, "avansareVehCols", false)
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Praguri Curse") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Vehicul Atribuit") imgui.NextColumn()
            imgui.Separator()
            
            imgui.Text("Skill 2 - 50 curse (total de 50). | Skill 3 - 50 curse (total de 100)")
            imgui.Text("Skill 4 - 100 curse (total de 200). | Skill 5 - 200 curse (total de 400)")
            imgui.Text("Skill 6 - 250 curse (total de 650). | Skill 7 - 250 curse (total de 900)")
            imgui.Text("Skill 8 - 300 curse (total de 1200). | Skill 9 - 350 curse (total de 1550)")
            imgui.Text("Skill 10 - 350 curse (total de 1900).")
            imgui.NextColumn()
            
            imgui.BulletText("Skill 1 - 2: Utility Van.")
            imgui.BulletText("Skill 3 - 4: Rumpo. | Skill 5 - 6: Bobcat.")
            imgui.BulletText("Skill 7 - 8: Burrito. | Skill 9 - 10: TowTruck.")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.5, 1, 1), "Progression & Vehicles")
            imgui.Separator()
            
            imgui.Columns(2, "avansareVehCols", false)
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Run Thresholds") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0.5, 1), "Assigned Vehicle") imgui.NextColumn()
            imgui.Separator()
            
            imgui.Text("Skill 2 - 50 runs (total of 50). | Skill 3 - 50 runs (total of 100)")
            imgui.Text("Skill 4 - 100 runs (total of 200). | Skill 5 - 200 runs (total of 400)")
            imgui.Text("Skill 6 - 250 runs (total of 650). | Skill 7 - 250 runs (total of 900)")
            imgui.Text("Skill 8 - 300 runs (total of 1,200). | Skill 9 - 350 runs (total of 1,550)")
            imgui.Text("Skill 10 - 350 runs (total of 1,900).")
            imgui.NextColumn()
            
            imgui.BulletText("Skill 1 - 2: Utility Van.")
            imgui.BulletText("Skill 3 - 4: Rumpo. | Skill 5 - 6: Bobcat.")
            imgui.BulletText("Skill 7 - 8: Burrito. | Skill 9 - 10: TowTruck.")
        end
        imgui.Columns(1)
    imgui.EndChild()
end

local function renderArmsDealerDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "A R M S - D E A L E R") 
    imgui.Separator()
    
    imgui.BeginChild("ArmsDealerBase", imgui.ImVec2(0, 125), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATII SI RISCURI:")
            imgui.Separator()
            imgui.Columns(2, "armsBaseCols", false)
            imgui.BulletText("Depozite: LS, LV, SF | Pret: 10 mat. / $1 | Multiplu de 10.")
            imgui.NextColumn()
            imgui.BulletText("Wanted S3-4: +1 | Wanted S5: +3 | Exceptie: Cei cu licenta activa.")
            imgui.Columns(1)
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Nota: Capacitatea maxima stoc creste de la 100k (S1) la 2.1B materiale (S5).")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INFORMATION AND RISKS:")
            imgui.Separator()
            imgui.Columns(2, "armsBaseCols", false)
            imgui.BulletText("Warehouses: LS, LV, SF | Price: 10 mats / $1 | Multiples of 10.")
            imgui.NextColumn()
            imgui.BulletText("Wanted S3-4: +1 | Wanted S5: +3 | Exception: Those with an active license.")
            imgui.Columns(1)
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Note: Maximum stock capacity increases from 100k (S1) to 2.1B materials (S5).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PROFIT BIROU SI EFICIENTA:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "OFFICE PROFIT AND EFFICIENCY:")
    end
    imgui.Spacing()
    
    imgui.BeginChild("ArmsProfitTable", imgui.ImVec2(0, 150), true)  
        imgui.Columns(3, "armsProfitCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Nivel Skill") imgui.NextColumn()
            imgui.Text("Plata Baza") imgui.NextColumn()
            imgui.Text("Timp Mediu") imgui.NextColumn()
            imgui.Separator()
            
            local armsRewards = {
                {"Skill 1", "$1077", "117 sec"}, {"Skill 2", "$1159", "101 sec"},
                {"Skill 3", "$1276", "95 sec"},  {"Skill 4", "$1423", "91 sec"},
                {"Skill 5", "$1573", "91 sec"}
            }
            for _, r in ipairs(armsRewards) do
                imgui.Text(r[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), r[2]) imgui.NextColumn()
                imgui.Text(r[3]) imgui.NextColumn()
            end
        else
            imgui.Text("Skill Level") imgui.NextColumn()
            imgui.Text("Base Payout") imgui.NextColumn()
            imgui.Text("Average Time") imgui.NextColumn()
            imgui.Separator()
            
            local armsRewards = {
                {"Skill 1", "$1077", "117 seconds"}, {"Skill 2", "$1159", "101 seconds"},
                {"Skill 3", "$1276", "95 seconds"},  {"Skill 4", "$1423", "91 seconds"},
                {"Skill 5", "$1573", "91 seconds"}
            }
            for _, r in ipairs(armsRewards) do
                imgui.Text(r[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), r[2]) imgui.NextColumn()
                imgui.Text(r[3]) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "COST MATERIALE CONSTRUCTIE ARME (/creategun):")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "WEAPON CRAFTING MATERIALS COST (/creategun):")
    end
    
    imgui.BeginChild("ArmsCraftTable", imgui.ImVec2(0, 160), true)  
        imgui.Columns(3, "armsCraftCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Arma") imgui.NextColumn()
            imgui.Text("Skill 1") imgui.NextColumn()
            imgui.Text("Skill 5") imgui.NextColumn()
            imgui.Separator()
            
            local craftData = {
                {"SD Pistol", "1000", "400"}, {"Deagle", "1500", "700"},
                {"Shotgun", "2000", "1000"}, {"MP5", "3000", "2000"},
                {"AK47/M4", "6000", "5000"}, {"Rifle", "7000", "6000"}
            }
            for _, d in ipairs(craftData) do
                imgui.Text(d[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), d[2]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), d[3]) imgui.NextColumn()
            end
        else
            imgui.Text("Weapon") imgui.NextColumn()
            imgui.Text("Skill 1") imgui.NextColumn()
            imgui.Text("Skill 5") imgui.NextColumn()
            imgui.Separator()
            
            local craftData = {
                {"SD Pistol", "1000", "400"}, {"Deagle", "1500", "700"},
                {"Shotgun", "2000", "1000"}, {"MP5", "3000", "2000"},
                {"AK47/M4", "6000", "5000"}, {"Rifle", "7000", "6000"}
            }
            for _, d in ipairs(craftData) do
                imgui.Text(d[1]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), d[2]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), d[3]) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("ArmsVehProg", imgui.ImVec2(0, 170), true)  
        imgui.Columns(2, "armsFinalCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICULE FLOTA:") 
            imgui.Text("Benson - Skill necesar: 1, 2")
            imgui.Text("Berkley's RC Van - Skill necesar: 3, 4")
            imgui.Text("Orice vehicul personal - Skill 5")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PRAGURI SKILL (CURSE):") 
            imgui.Separator()
            imgui.Text("Skill 1 la skill 2, ai nevoie de 50 de curse.")
            imgui.Text("Skill 2 la skill 3, ai nevoie de 200 de curse.(total: 250)")
            imgui.Text("Skill 3 la skill 4, ai nevoie de 250 de curse.(total: 500)")
            imgui.Text("Skill 4 la skill 5, ai nevoie de 500 de curse.(total: 1000)")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "FLEET VEHICLES:") 
            imgui.Text("Benson - Required Skill: 1, 2")
            imgui.Text("Berkley's RC Van - Required Skill: 3, 4")
            imgui.Text("Any personal vehicle - Skill 5")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL THRESHOLDS (RUNS):") 
            imgui.Separator()
            imgui.Text("Skill 1 to skill 2, you need 50 runs.")
            imgui.Text("Skill 2 to skill 3, you need 200 runs.(total: 250)")
            imgui.Text("Skill 3 to skill 4, you need 250 runs.(total: 500)")
            imgui.Text("Skill 4 to skill 5, you need 500 runs.(total: 1000)")
        end
        imgui.Columns(1)
    imgui.EndChild()
end

local function renderArcheologistDetails()
    imgui.Spacing()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "A R C H E O L O G")
    imgui.Separator()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VALOARE ARTEFACTE SI TIMP LOCALIZARE")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "ARTIFACT VALUE AND LOCATION TIME")
    end

    imgui.BeginChild("ArcheoArtifacts", imgui.ImVec2(0, 280), true)
        imgui.Columns(4, "archCols", false)
        imgui.SetColumnWidth(0, 110)  
        imgui.SetColumnWidth(1, 100)
        imgui.SetColumnWidth(2, 115) 
        imgui.SetColumnWidth(3, 115) 
        
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Artefact")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Timp")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Valoare Baza")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Puncte Skill")) imgui.NextColumn()
            imgui.Separator()

            local skillData = {
                {"Romanesc", "19 secunde", "$350", "1 punct"}, {"Moldovenesc", "18 secunde", "$500", "1 punct"},
                {"Egiptean", "17 secunde", "$650", "1 punct"}, {"Rusesc", "16 secunde", "$800", "1 punct"},
                {"Ucrainean", "15 secunde", "$950", "2 puncte"}, {"Tunisian", "14 secunde", "$1.100", "2 puncte"},
                {"Grecesc", "13 secunde", "$1.250", "2 puncte"}, {"Italian", "12 secunde", "$1.400", "2 puncte"},
                {"Spaniol", "11 secunde", "$1.550", "3 puncte"}, {"Chinezesc", "10 secunde", "$1.700", "3 puncte"}
            }
            for _, v in ipairs(skillData) do
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                imgui.Text(u8(v[2])) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[3])) imgui.NextColumn()
                imgui.Text(u8(v[4])) imgui.NextColumn()
            end
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Artifact")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Time")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Base Value")) imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill Points")) imgui.NextColumn()
            imgui.Separator()

            local skillData = {
                {"Romanian", "19 seconds", "$350", "1 point"}, {"Moldovan", "18 seconds", "$500", "1 point"},
                {"Egyptian", "17 seconds", "$650", "1 point"}, {"Russian", "16 seconds", "$800", "1 point"},
                {"Ukrainian", "15 seconds", "$950", "2 points"}, {"Tunisian", "14 seconds", "$1,100", "2 points"},
                {"Greek", "13 seconds", "$1,250", "2 points"}, {"Italian", "12 seconds", "$1,400", "2 points"},
                {"Spanish", "11 seconds", "$1,550", "3 points"}, {"Chinese", "10 seconds", "$1,700", "3 points"}
            }
            for _, v in ipairs(skillData) do
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                imgui.Text(u8(v[2])) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[3])) imgui.NextColumn()
                imgui.Text(u8(v[4])) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.Columns(2, "archInfo", false)    
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PROGRES SKILL")
        imgui.BeginChild("ArcheoProgress", imgui.ImVec2(0, 220), true)
            imgui.Text(u8("Skill 1 > 2: 50 puncte (50 total)"))
            imgui.Text(u8("Skill 2 > 3: 100 puncte (150 total)"))
            imgui.Text(u8("Skill 3 > 4: 200 puncte (350 total)"))
            imgui.Text(u8("Skill 4 > 5: 400 puncte (750 total)"))
            imgui.Text(u8("Skill 5 > 6: 750 puncte (1500 total)"))
            imgui.Text(u8("Skill 6 > 7: 1500 puncte (3000 total)"))
            imgui.Text(u8("Skill 7 > 8: 2000 puncte (5000 total)"))
            imgui.Text(u8("Skill 8 > 9: 3000 puncte (8000 total)"))
            imgui.Text(u8("Skill 9 > 10: 3000 puncte (11000 total)"))
        imgui.EndChild()
        
        imgui.NextColumn()    
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "BONUSURI SI REGULI")
        imgui.BeginChild("ArcheoBonus", imgui.ImVec2(0, 220), true)
            imgui.Text(u8("Skill 1 - este o incercare disponibila, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 2 - sunt 2 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 3 - sunt 3 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 4 - sunt 4 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 5 - sunt 5 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 6 - sunt 6 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 7 - sunt 7 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 8 - sunt 8 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 9 - sunt 9 incercari disponibile, altfel va fi distrus artefactul."))
            imgui.Text(u8("Skill 10 - sunt 10 incercari disponibile, altfel va fi distrus artefactul."))
        imgui.EndChild()
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL PROGRESSION")
        imgui.BeginChild("ArcheoProgress", imgui.ImVec2(0, 220), true)
            imgui.Text(u8("Skill 1 > 2: 50 points (50 total)"))
            imgui.Text(u8("Skill 2 > 3: 100 points (150 total)"))
            imgui.Text(u8("Skill 3 > 4: 200 points (350 total)"))
            imgui.Text(u8("Skill 4 > 5: 400 points (750 total)"))
            imgui.Text(u8("Skill 5 > 6: 750 points (1,500 total)"))
            imgui.Text(u8("Skill 6 > 7: 1500 points (3,000 total)"))
            imgui.Text(u8("Skill 7 > 8: 2000 points (5,000 total)"))
            imgui.Text(u8("Skill 8 > 9: 3000 points (8,000 total)"))
            imgui.Text(u8("Skill 9 > 10: 3000 points (11,000 total)"))
        imgui.EndChild()
        
        imgui.NextColumn()    
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "BONUSES AND RULES")
        imgui.BeginChild("ArcheoBonus", imgui.ImVec2(0, 220), true)
            imgui.Text(u8("Skill 1 - 1 attempt available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 2 - 2 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 3 - 3 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 4 - 4 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 5 - 5 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 6 - 6 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 7 - 7 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 8 - 8 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 9 - 9 attempts available, otherwise the artifact will be destroyed."))
            imgui.Text(u8("Skill 10 - 10 attempts available, otherwise the artifact will be destroyed."))
        imgui.EndChild()
    end
    imgui.Columns(1)
end

local function renderElectricianDetails()
    local lang = iniData.settings.lang
    
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "E L E C T R I C I A N") 
    imgui.Separator()
    
    -- Un singur child pentru toate informatiile
    imgui.BeginChild("ElecFullDetails", imgui.ImVec2(0, 0), true)
        
        -- 1. Date Tehnice
        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), lang == 0 and "DATE TEHNICE INTERFATA:" or "INTERFACE TECHNICAL DATA:")
        imgui.BulletText(lang == 0 and "Nivel Minim: 3 | Locatie: Ocean Docks (LS) | Comanda: /work" or "Minimum Level: 3 | Location: Ocean Docks (LS) | Command: /work")
        imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), lang == 0 and "AVERTIZARE SIGURANTA:" or "SAFETY WARNING:")
        imgui.TextWrapped(lang == 0 and "Eroarea in minigame provoaca EXPLOZIE si esuarea instanta a misiunii." or "Failing the minigame causes an EXPLOSION and instant mission failure.")
        imgui.TextDisabled(lang == 0 and "Oprire CP curent: /killcp" or "Stop current CP: /killcp")
        imgui.Separator()

        -- 2. Vehicule necesare
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), lang == 0 and "VEHICULE NECESARE:" or "REQUIRED VEHICLES:")
        imgui.Text(lang == 0 and "Sadler - Skillul necesar: 1, 2" or "Sadler - Required skill: 1, 2")
        imgui.Text(lang == 0 and "Picador - Skillul necesar: 3, 4, 5, 6" or "Picador - Required skill: 3, 4, 5, 6")
        imgui.Text(lang == 0 and "Rancher - Skillul necesar: 7, 8, 9, 10" or "Rancher - Required skill: 7, 8, 9, 10")
        imgui.Separator()

        -- 3. Plati
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), lang == 0 and "PLATI (DOAR PLATA):" or "PAYMENTS:")
        
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), lang == 0 and "Taierea firelor:" or "Cutting wires:")
        imgui.Text("Skill 1: $90 - $650 (Sadler) | Skill 2: $102 - $718 (Sadler)")
        imgui.Text("Skill 3: $120 - $840 (Picador) | Skill 4: $145 - $1025 (Picador)")
        imgui.Text("Skill 5: $185 - $1305 (Picador) | Skill 6: $225 - $1585 (Picador)")
        imgui.Text("Skill 7: $280 - $1960 (Rancher) | Skill 8: $335 - $2415 (Rancher)")
        imgui.Text("Skill 9: $415 - $2935 (Rancher) | Skill 10: $510 - $3390 (Rancher)")
        
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), lang == 0 and "\nConectarea firelor:" or "\nConnecting wires:")
        imgui.Text("Skill 4: $165 - $1125 (Picador) | Skill 5: $205 - $1405 (Picador)")
        imgui.Text("Skill 6: $250 - $1690 (Picador) | Skill 7: $295 - $2055 (Rancher)")
        imgui.Text("Skill 8: $370 - $2530 (Rancher) | Skill 9: $475 - $3075 (Rancher)")
        imgui.Text("Skill 10: $530 - $3490 (Rancher)")
        
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), lang == 0 and "\nReglarea voltajului:" or "\nVoltage regulation:")
        imgui.Text("Skill 8: $430 - $2670 (Rancher) | Skill 9: $495 - $3175 (Rancher)")
        imgui.Text("Skill 10: $560 - $3600 (Rancher)")
        imgui.Separator()

        -- 4. Praguri Skill
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), lang == 0 and "PRAGURI SKILL (CURSE TOTAL):" or "SKILL THRESHOLDS (TOTAL RUNS):")
        if lang == 0 then
            imgui.Text("Skill 1 >> Skill 2: 30 de curse. (30 total)")
            imgui.Text("Skill 2 >> Skill 3: 60 de curse. (90 total)")
            imgui.Text("Skill 3 >> Skill 4: 120 de curse. (210 total)")
            imgui.Text("Skill 4 >> Skill 5: 240 de curse. (450 total)")
            imgui.Text("Skill 5 >> Skill 6: 200 de curse. (650 total)")
            imgui.Text("Skill 6 >> Skill 7: 250 de curse. (900 total)")
            imgui.Text("Skill 7 >> Skill 8: 300 de curse. (1200 total)")
            imgui.Text("Skill 8 >> Skill 9: 350 de curse. (1550 total)")
            imgui.Text("Skill 9 >> Skill 10: 350 de curse. (1900 total)")
        else
            imgui.Text("Skill 1 >> Skill 2: 30 runs. (30 total)")
            imgui.Text("Skill 2 >> Skill 3: 60 runs. (90 total)")
            imgui.Text("Skill 3 >> Skill 4: 120 runs. (210 total)")
            imgui.Text("Skill 4 >> Skill 5: 240 runs. (450 total)")
            imgui.Text("Skill 5 >> Skill 6: 200 runs. (650 total)")
            imgui.Text("Skill 6 >> Skill 7: 250 runs. (900 total)")
            imgui.Text("Skill 7 >> Skill 8: 300 runs. (1200 total)")
            imgui.Text("Skill 8 >> Skill 9: 350 runs. (1550 total)")
            imgui.Text("Skill 9 >> Skill 10: 350 runs. (1900 total)")
        end
        
        imgui.Separator()
        imgui.TextWrapped(lang == 0 and "Nota: Sumele de bani mentionate sunt platile de baza. La acestea se vor adauga eventualele bonusuri, de exemplu cel de la Cont Premium, de la Maraton sau de la Jobul Zilei." or "Note: The mentioned amounts are base payments. Bonuses (Premium, Marathon, Daily Job) are added on top.")
        
    imgui.EndChild()
end

local function renderLawyerDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "L A W Y E R") 
    imgui.Separator()
    
    imgui.BeginChild("LawyerBase", imgui.ImVec2(0, 145), true)  
        imgui.Columns(2, "lawBaseCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "CERINTE SI LOCATIE:")
            imgui.Separator()
            imgui.BulletText("Nivel: 5 | Tip: Legal | HQ: Primaria LS.\nActivitate: Eliberari & Divorturi asigurate.")
            imgui.NextColumn()
            imgui.BulletText("Limitare: Fara detinuti in AJail.\nCooldown general /free: 30 minute.")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "REQUIREMENTS AND LOCATION:")
            imgui.Separator()
            imgui.BulletText("Level: 5 | Type: Legal | HQ: LS City Hall.\nActivity: Releases & Divorces provided.")
            imgui.NextColumn()
            imgui.BulletText("Limitation: No inmates in AJail.\nGeneral /free cooldown: 30 minutes.")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "GESTIONARE MANDATE (ACCEPT LAWYER):")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "MANAGING WARRANTS (ACCEPT LAWYER):")
    end
    
    imgui.BeginChild("LawyerPoints", imgui.ImVec2(0, 125), true)  
        if iniData.settings.lang == 0 then
            imgui.TextWrapped("Pentru a elibera un detinut, ai nevoie obligatorie de un punct 'Accept Lawyer'.")
            imgui.Separator()
            imgui.BulletText("Sursa 1: Politisti R3+ (Pret negociat: $5.000 - $20.000)")
            imgui.BulletText("Sursa 2: Primarie (/getlawyer - Pret fix de stat: $40.000)")
            imgui.TextDisabled("Verificare stoc puncte: /acceptlaws")
        else
            imgui.TextWrapped("To release an inmate, you strictly need an 'Accept Lawyer' point.")
            imgui.Separator()
            imgui.BulletText("Source 1: Cop R3+ (Negotiated price: $5,000 - $20,000)")
            imgui.BulletText("Source 2: City Hall (/getlawyer - Fixed state price: $40,000)")
            imgui.TextDisabled("Check point stock: /acceptlaws")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SERVICII SI LIMITE TARIFE:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SERVICES AND PRICE LIMITS:")
    end
    
    imgui.BeginChild("LawyerServices", imgui.ImVec2(0, 110), true)  
        imgui.Columns(2, "lawServCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Tip Serviciu") imgui.NextColumn()
            imgui.Text("Tarif Permis Server") imgui.NextColumn()
            imgui.Separator()      
            imgui.Text("Eliberare Detinut (/free)") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$15.000 - $50.000") imgui.NextColumn()      
            imgui.Text("Asistenta Divort (/ldivorce)") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1.000 - $3.000") imgui.NextColumn()
        else
            imgui.Text("Service Type") imgui.NextColumn()
            imgui.Text("Allowed Server Rate") imgui.NextColumn()
            imgui.Separator()      
            imgui.Text("Inmate Release (/free)") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$15,000 - $50,000") imgui.NextColumn()      
            imgui.Text("Divorce Assistance (/ldivorce)") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$1,000 - $3,000") imgui.NextColumn()
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("LawyerProg", imgui.ImVec2(0, 170), true)  
        imgui.Columns(2, "lawFinalCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "COMENZI SPECIFICE:")
            imgui.Text("Comanda /jaillist (In interior Jail)")
            imgui.Text("Comanda /free [id] [pret] (In interior Jail / afara)")
            imgui.Text("Comanda /ldivorce [id] [pret] ii va fi trimisa oferta de divort")
            imgui.Text("Comanda /acceptlaws - numarul de puncte accept lawyer detinute")
            imgui.Text("Comanda /getlawyer - mandat de eliberare in suma de $40,000.")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PRAGURI SKILL (ELIBERARI):")
            imgui.Text("Skill 1 la skill 2, trebuie sa eliberati 50 de detinuti.")
            imgui.Text("Skill 2 la skill 3, trebuie sa eliberati alti 50 de detinuti. (total: 100)")
            imgui.Text("Skill 3 la skill 4, trebuie sa eliberati alti 100 de detinuti. (total: 200)")
            imgui.Text("Skill 4 la skill 5, trebuie sa eliberati alti 200 de detinuti. (total: 400)")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SPECIFIC COMMANDS:")
            imgui.Text("Command /jaillist (Inside Jail)")
            imgui.Text("Command /free [id] [price] (Inside Jail / outside)")
            imgui.Text("Command /ldivorce [id] [price] sends the divorce offer")
            imgui.Text("Command /acceptlaws - shows owned accept lawyer points")
            imgui.Text("Command /getlawyer - purchase release warrant for $40,000.")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL THRESHOLDS (RELEASES):")
            imgui.Text("Skill 1 to skill 2, you must release 50 inmates.")
            imgui.Text("Skill 2 to skill 3, you must release another 50 inmates. (total: 100)")
            imgui.Text("Skill 3 to skill 4, you must release another 100 inmates. (total: 200)")
            imgui.Text("Skill 4 to skill 5, you must release another 200 inmates. (total: 400)")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Separator()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Nota: Banii pentru eliberare trebuie sa fie in BANCA clientului care solicita.")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Note: The money for the release must be in the BANK account of the client requesting it.")
    end
end

local function renderPocketThiefDetails()
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "H O T - D E - B U Z U N A R E") 
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "P I C K P O C K E T") 
    end
    imgui.Separator()
    
    imgui.BeginChild("PickBase", imgui.ImVec2(0, 160), true)  
        imgui.Columns(2, "pickBaseCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "REGULI SI RESTRICTII:")
            imgui.Separator()
            imgui.BulletText("Nivel: 5 | Ilegal | Victima: Minim Lv 15.\nMaxim: 2 ori/PD per aceeasi victima.")
            imgui.NextColumn()
            imgui.BulletText("Interzis: Safezone / AFK / Interioare / Auto.\nComanda: /pickpocket [ID] | Recompensa: 10 Gold/S")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "RULES AND RESTRICTIONS:")
            imgui.Separator()
            imgui.BulletText("Level: 5 | Illegal | Victim: Minimum Lv 15.\nMaximum: 2 times/PD per same victim.")
            imgui.NextColumn()
            imgui.BulletText("Forbidden: Safezone / AFK / Interiors / Vehicles.\nCommand: /pickpocket [ID] | Reward: 10 Gold/S")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("PickRisks", imgui.ImVec2(0, 115), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "CONSECINTE JURIDICE:")
            imgui.Separator()
            imgui.BulletText("Victima poate folosi [/emergency] pentru Wanted 1 (cu drept de predare).")
            imgui.BulletText("Daca victima reuseste sa te omoare, isi primeste toti banii furati inapoi.")
            imgui.BulletText("Jafuirea unui politist la datorie aduce instant Wanted 3 (Jefuire).")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "LEGAL CONSEQUENCES:")
            imgui.Separator()
            imgui.BulletText("The victim can use [/emergency] for Wanted 1 (with right to surrender).")
            imgui.BulletText("If the victim manages to kill you, they get all their stolen money back.")
            imgui.BulletText("Robbing an on-duty cop instantly grants Wanted 3 (Robbery).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "RATA DE SUCCES SI PROFIT ESTIMATIV:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SUCCESS RATE AND ESTIMATED PROFIT:")
    end
    
    imgui.BeginChild("PickStats", imgui.ImVec2(0, 175), true)  
        imgui.Columns(3, "pickStatsCols", false)
        if iniData.settings.lang == 0 then
            imgui.Text("Nivel Skill") imgui.NextColumn()
            imgui.Text("Sansa Succes") imgui.NextColumn()
            imgui.Text("Plata Baza") imgui.NextColumn()
            imgui.Separator()
            
            local pickData = {
                {"Skill 1", "25 '/.", "$598"},   {"Skill 3", "32.5 '/.", "$874"},
                {"Skill 5", "50 '/.", "$1150"},  {"Skill 7", "75 '/.", "$3638"},
                {"Skill 10", "100 '/.", "$5000"}
            }
            for _, d in ipairs(pickData) do
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), d[1]) imgui.NextColumn()
                imgui.Text(d[2]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), d[3]) imgui.NextColumn()
            end
        else
            imgui.Text("Skill Level") imgui.NextColumn()
            imgui.Text("Success Chance") imgui.NextColumn()
            imgui.Text("Base Payout") imgui.NextColumn()
            imgui.Separator()
            
            local pickData = {
                {"Skill 1", "25 '/.", "$598"},   {"Skill 3", "32.5 '/.", "$874"},
                {"Skill 5", "50 '/.", "$1150"},  {"Skill 7", "75 '/.", "$3638"},
                {"Skill 10", "100 '/.", "$5000"}
            }
            for _, d in ipairs(pickData) do
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), d[1]) imgui.NextColumn()
                imgui.Text(d[2]) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), d[3]) imgui.NextColumn()
            end
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("PickProg", imgui.ImVec2(0, 220), true)  
        imgui.Columns(1) 
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PRAGURI FURTURI SKILL:")
            imgui.Separator()
            imgui.Text("Skill 1 la skill 2 ai nevoie de 60 de incercari de furt.")
            imgui.Text("Skill 2 la skill 3 ai nevoie de alte 60 de incercari de furt.(total: 120)")
            imgui.Text("Skill 3 la skill 4 ai nevoie de 120 de incercari de furt.(total: 240)")
            imgui.Text("Skill 4 la skill 5 ai nevoie de 240 de incercari de furt.(total: 480)")
            imgui.Text("Skill 5 la skill 6 ai nevoie de 200 de incercari de furt (total: 680)")
            imgui.Text("Skill 6 la skill 7 ai nevoie de 250 de incercari de furt.(total: 930)")
            imgui.Text("Skill 7 la skill 8 ai nevoie de 300 de incercari de furt.(total: 1230)")
            imgui.Text("Skill 8 la skill 9 ai nevoie de 350 de incercari de furt.(total: 1580)")
            imgui.Text("Skill 9 la skill 10 ai nevoie de 350 de incercari de furt.(total: 1930)")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL THEFT THRESHOLDS:")
            imgui.Separator()
            imgui.Text("Skill 1 to skill 2 you need 60 theft attempts.")
            imgui.Text("Skill 2 to skill 3 you need another 60 theft attempts.(total: 120)")
            imgui.Text("Skill 3 to skill 4 you need 120 theft attempts.(total: 240)")
            imgui.Text("Skill 4 to skill 5 you need 240 theft attempts.(total: 480)")
            imgui.Text("Skill 5 to skill 6 you need 200 theft attempts.(total: 680)")
            imgui.Text("Skill 6 to skill 7 you need 250 theft attempts.(total: 930)")
            imgui.Text("Skill 7 to skill 8 you need 300 theft attempts.(total: 1230)")
            imgui.Text("Skill 8 to skill 9 you need 350 theft attempts.(total: 1580)")
            imgui.Text("Skill 9 to skill 10 you need 350 theft attempts.(total: 1930)")
        end
    imgui.EndChild()
end

local function renderCraftsmanDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "C R A F T S M A N")
    imgui.Separator()
    
    imgui.BeginChild("MesterBase", imgui.ImVec2(0, 80), true)  
        imgui.Columns(2, "logisticaCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "ADMINISTRATIV & CHIRIE (24H):")
            imgui.BulletText("HQ: King's, SF (ID 160) | Nivel: 5 | Livrare: Upgrade Case.\nChirie: Dulgher ($1.000) | Drujba ($500) | Masca ($500)")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "RECOMPENSE TURA:\n+20 XP Maraton/Clan\nSkill: 3-11 pct/tura\nStoc maxim: 999 (S10: 1999)")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "ADMINISTRATIVE & RENT (24H):")
            imgui.BulletText("HQ: King's, SF (ID 160) | Level: 5 | Delivery: House Upgrades.\nRent: Carpenter ($1,000) | Chainsaw ($500) | Mask ($500)")
            imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "RUN REWARDS:\n+20 Marathon/Clan XP\nSkill: 3-11 pts/run\nMax Stock: 999 (S10: 1999)")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "CATALOG PRODUCTIE SI VENITURI SYSTEM:")   
    else
        imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1), "PRODUCTION CATALOG AND SYSTEM INCOME:")   
    end
    
    imgui.BeginChild("MesterFullCatalog", imgui.ImVec2(0, 500), true)  
        imgui.Columns(7, "catalogCols", false)

        imgui.SetColumnWidth(0, 110) 
        imgui.SetColumnWidth(1, 45)  
        imgui.SetColumnWidth(2, 50)  
        imgui.SetColumnWidth(3, 45)  
        imgui.SetColumnWidth(4, 55)  
        imgui.SetColumnWidth(5, 80)  
        imgui.SetColumnWidth(6, 95)  
      
        if iniData.settings.lang == 0 then
            imgui.Text("Articol") imgui.NextColumn()
            imgui.Text("Lemn") imgui.NextColumn()
            imgui.Text("Argint") imgui.NextColumn()
            imgui.Text("Aur") imgui.NextColumn()
            imgui.Text("Bumbac") imgui.NextColumn()
            imgui.Text("Fara Prem.") imgui.NextColumn()
            imgui.Text("Cu Prem.") imgui.NextColumn()
        else
            imgui.Text("Item") imgui.NextColumn()
            imgui.Text("Wood") imgui.NextColumn()
            imgui.Text("Silver") imgui.NextColumn()
            imgui.Text("Gold") imgui.NextColumn()
            imgui.Text("Cotton") imgui.NextColumn()
            imgui.Text("No. Prem") imgui.NextColumn()
            imgui.Text("With. Prem") imgui.NextColumn()
        end
        imgui.Separator()
        
        local function CraftRow(name, l, ar, au, b, pay, payP, isHeader, hCol)
            if isHeader then
                imgui.TextColored(hCol, name)
                imgui.NextColumn() imgui.NextColumn() imgui.NextColumn()
                imgui.NextColumn() imgui.NextColumn() imgui.NextColumn()
                imgui.NextColumn()
                imgui.Separator()
            else
                imgui.Text(name) imgui.NextColumn()
                imgui.Text(l) imgui.NextColumn()
                imgui.Text(ar) imgui.NextColumn()
                imgui.Text(au) imgui.NextColumn()
                imgui.Text(b) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), pay) imgui.NextColumn()
                imgui.TextColored(imgui.ImVec4(1, 0.3, 1, 1), payP) imgui.NextColumn()
            end
        end

        if iniData.settings.lang == 0 then
            -- [SCAUNE]
            CraftRow("[SCAUNE]", "", "", "", "", "", "", true, imgui.ImVec4(0.4, 0.8, 1, 1))
            CraftRow("Scaun 1", "12", "76", "25", "0", "$6.250", "$9.375", false)
            CraftRow("Scaun 2", "13", "83", "27", "0", "$6.875", "$10.312", false)
            CraftRow("Scaun 3", "14", "91", "30", "0", "$7.500", "$11.250", false)
            CraftRow("Scaun 4", "15", "98", "32", "0", "$8.125", "$12.187", false)
            CraftRow("Scaun 5", "16", "106", "35", "10", "$9.750", "$14.625", false)

            -- [MESE]
            CraftRow("[MESE]", "", "", "", "", "", "", true, imgui.ImVec4(0.4, 1, 0.4, 1))
            CraftRow("Masa 1", "18", "114", "37", "0", "$9.375", "$14.062", false)
            CraftRow("Masa 2", "19", "121", "40", "0", "$10.000", "$15.000", false)
            CraftRow("Masa 3", "20", "129", "42", "0", "$10.625", "$15.937", false)
            CraftRow("Masa 4", "21", "136", "45", "0", "$11.250", "$16.875", false)
            CraftRow("Masa 5", "22", "144", "47", "20", "$12.875", "$19.312", false)

            -- [ACCESORII]
            CraftRow("[ACCESORII]", "", "", "", "", "", "", true, imgui.ImVec4(1, 0.5, 0, 1))
            CraftRow("Skateboard", "24", "152", "50", "0", "$12.500", "$18.750", false)
            CraftRow("Evantai", "25", "159", "52", "0", "$13.125", "$19.687", false)
            CraftRow("Scaun Plaja", "26", "167", "55", "0", "$13.750", "$20.625", false)
            CraftRow("Rama", "27", "174", "57", "0", "$14.375", "$21.562", false)
            CraftRow("Televizor", "28", "182", "60", "30", "$15.000", "$22.500", false)

            -- [USI]
            CraftRow("[USI]", "", "", "", "", "", "", true, imgui.ImVec4(1, 0.2, 0.2, 1))
            CraftRow("Usa 1", "30", "190", "62", "0", "$15.625", "$23.437", false)
            CraftRow("Usa 2", "31", "197", "65", "0", "$16.250", "$24.375", false)
            CraftRow("Usa 3", "32", "205", "67", "0", "$16.875", "$25.312", false)
            CraftRow("Usa 4", "33", "212", "70", "0", "$17.500", "$26.250", false)
            CraftRow("Usa 5", "34", "220", "72", "40", "$19.125", "$28.687", false)    
        else
            -- [CHAIRS]
            CraftRow("[CHAIRS]", "", "", "", "", "", "", true, imgui.ImVec4(0.4, 0.8, 1, 1))
            CraftRow("Chair 1", "12", "76", "25", "0", "$6.250", "$9.375", false)
            CraftRow("Chair 2", "13", "83", "27", "0", "$6.875", "$10.312", false)
            CraftRow("Chair 3", "14", "91", "30", "0", "$7.500", "$11.250", false)
            CraftRow("Chair 4", "15", "98", "32", "0", "$8.125", "$12.187", false)
            CraftRow("Chair 5", "16", "106", "35", "10", "$9.750", "$14.625", false)

            -- [TABLES]
            CraftRow("[TABLES]", "", "", "", "", "", "", true, imgui.ImVec4(0.4, 1, 0.4, 1))
            CraftRow("Table 1", "18", "114", "37", "0", "$9.375", "$14.062", false)
            CraftRow("Table 2", "19", "121", "40", "0", "$10.000", "$15.000", false)
            CraftRow("Table 3", "20", "129", "42", "0", "$10.625", "$15.937", false)
            CraftRow("Table 4", "21", "136", "45", "0", "$11.250", "$16.875", false)
            CraftRow("Table 5", "22", "144", "47", "20", "$12.875", "$19.312", false)

            -- [ACCESSORIES]
            CraftRow("[ACCESSORIES]", "", "", "", "", "", "", true, imgui.ImVec4(1, 0.5, 0, 1))
            CraftRow("Skateboard", "24", "152", "50", "0", "$12.500", "$18.750", false)
            CraftRow("Folding Fan", "25", "159", "52", "0", "$13.125", "$19.687", false)
            CraftRow("Beach Chair", "26", "167", "55", "0", "$13.750", "$20.625", false)
            CraftRow("Frame", "27", "174", "57", "0", "$14.375", "$21.562", false)
            CraftRow("TV", "28", "182", "60", "30", "$15.000", "$22.500", false)

            -- [DOORS]
            CraftRow("[DOORS]", "", "", "", "", "", "", true, imgui.ImVec4(1, 0.2, 0.2, 1))
            CraftRow("Door 1", "30", "190", "62", "0", "$15.625", "$23.437", false)
            CraftRow("Door 2", "31", "197", "65", "0", "$16.250", "$24.375", false)
            CraftRow("Door 3", "32", "205", "67", "0", "$16.875", "$25.312", false)
            CraftRow("Door 4", "33", "212", "70", "0", "$17.500", "$26.250", false)
            CraftRow("Door 5", "34", "220", "72", "40", "$19.125", "$28.687", false)    
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("MesterProgFinal", imgui.ImVec2(0, 220), true)  
        imgui.Columns(2, "finalProgCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICULE:")
            imgui.Text("Pony - Skillul necesar: 1, 2, 3, 4")
            imgui.Text("Vehicul Personal - Skillul necesar: 5, 6, 7, 8, 9, 10")

            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Aeronavele permise pentru transport sunt:")
            imgui.Text("Elicoptere: Leviathan, Sparrow, Maverick, Cargobob, Raindance.")
            imgui.Text("Avioane: Skimmer, Beagle, Cropduster, Stuntplane, Shamal, Nevada, Dodo.")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "PRAGURI PUNCTE SKILL:")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 la skill 2, trebuie 30 de puncte.")
            imgui.TextColored(imgui.ImVec4(1, 0.75, 0, 1), "Skill 2 la skill 3, trebuie 60 de puncte(90 in total)")
            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Skill 3 la skill 4, trebuie 120 de puncte(210 in total)")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 4 la skill 5, trebuie 240 de puncte(450 in total)")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.6, 1), "Skill 5 la skill 6, trebuie 200 de puncte(650 in total)")
            imgui.TextColored(imgui.ImVec4(0, 0.8, 1, 1), "Skill 6 la skill 7, trebuie 250 de puncte(900 in total)")
            imgui.TextColored(imgui.ImVec4(0.5, 0.5, 1, 1), "Skill 7 la skill 8, trebuie 300 de puncte(1200 in total)")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 8 la skill 9, trebuie 350 de puncte(1550 in total)")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0.6, 1), "Skill 9 la skill 10, trebuie 350 de puncte(1900 in total)")  
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICLES:")
            imgui.Text("Pony - Required Skill: 1, 2, 3, 4")
            imgui.Text("Personal Vehicle - Required Skill: 5, 6, 7, 8, 9, 10")

            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Allowed aircrafts for transport are:")
            imgui.Text("Helicopters: Leviathan, Sparrow, Maverick, Cargobob, Raindance.")
            imgui.Text("Planes: Skimmer, Beagle, Cropduster, Stuntplane, Shamal, Nevada, Dodo.")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL POINT THRESHOLDS:")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 to skill 2, you need 30 points.")
            imgui.TextColored(imgui.ImVec4(1, 0.75, 0, 1), "Skill 2 to skill 3, you need 60 points (90 total)")
            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "Skill 3 to skill 4, you need 120 points (210 total)")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 4 to skill 5, you need 240 points (450 total)")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.6, 1), "Skill 5 to skill 6, you need 200 points (650 total)")
            imgui.TextColored(imgui.ImVec4(0, 0.8, 1, 1), "Skill 6 to skill 7, you need 250 points (900 total)")
            imgui.TextColored(imgui.ImVec4(0.5, 0.5, 1, 1), "Skill 7 to skill 8, you need 300 points (1200 total)")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 8 to skill 9, you need 350 points (1550 total)")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0.6, 1), "Skill 9 to skill 10, you need 350 points (1900 total)")  
        end
        imgui.Columns(1)
    imgui.EndChild()
end

local function renderFirefighterDetails()
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "P O M P I E R")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "F I R E F I G H T E R")
    end
    imgui.Separator()
    
    imgui.BeginChild("FireBase", imgui.ImVec2(0, 80), true)  
        imgui.Columns(2, "fireBaseCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INTERVENTIE & OPERARE FURTUN:")
            imgui.Separator()
            imgui.Bullet() imgui.TextWrapped("Activitate: Dispecerat plata pe DISTANTA.")
            imgui.Bullet() imgui.TextWrapped("Comanda Ajutor rapid dedicat: /jobhelp")
            imgui.NextColumn()
            imgui.Bullet() imgui.TextWrapped("PC: ALT / FIRE (On/Off) | ALT (Langa Hidrant - Refill)")
            imgui.Bullet() imgui.TextWrapped("Mobil: Comenzi rapide /hose | /refillhose")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "INTERVENTION & HOSE OPERATION:")
            imgui.Separator()
            imgui.Bullet() imgui.TextWrapped("Activity: Dispatch payout based on DISTANCE.")
            imgui.Bullet() imgui.TextWrapped("Dedicated job help command: /jobhelp")
            imgui.NextColumn()
            imgui.Bullet() imgui.TextWrapped("PC: ALT / FIRE (On/Off) | ALT (Near Hydrant - Refill)")
            imgui.Bullet() imgui.TextWrapped("Mobile: Quick commands /hose | /refillhose")
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "VENITURI ESTIMATIVE (MIN - MAX):")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "ESTIMATED INCOME (MIN - MAX):")
    end
    
    imgui.BeginChild("FireScenarios", imgui.ImVec2(0, 240), true) 
        imgui.Columns(2, "scenariosCols", false)
        imgui.SetColumnWidth(0, 310)
        imgui.SetColumnWidth(1, 310)

        if iniData.settings.lang == 0 then
            local function FireRow(title, color, payMin, payMax)
                imgui.TextColored(color, title)
                imgui.Text("   Fara Premium: "); imgui.SameLine(135)
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$" .. payMin .. " - $" .. payMax)
                imgui.Text("   Cu Premium:   "); imgui.SameLine(135)
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "$" .. math.floor(payMin*1.5) .. " - $" .. math.floor(payMax*1.5))
                imgui.Spacing()
            end

            FireRow("[Skill 1] Cisterna de Petrol", imgui.ImVec4(0.4, 0.8, 1, 1), 105, 2745)
            imgui.NextColumn() 
            FireRow("[Skill 2] Vehicule in Flacari", imgui.ImVec4(1, 0.6, 0.2, 1), 140, 2850)
            imgui.NextColumn() 
            imgui.Separator()

            FireRow("[Skill 4] Incendiu la Tomberoane", imgui.ImVec4(0.4, 1, 0.4, 1), 180, 2950)
            imgui.NextColumn() 
            FireRow("[Skill 6] Cladire in Flacari", imgui.ImVec4(1, 0.3, 0.3, 1), 250, 3050)
            imgui.NextColumn() 
            imgui.Separator()
         
            FireRow("[Skill 8] Scurgere de Gaze", imgui.ImVec4(0.8, 0.4, 1, 1), 380, 3180)
            imgui.NextColumn() 
            FireRow("[Skill 10] Salvare de pe Acoperis", imgui.ImVec4(1, 1, 1, 1), 540, 3340)
        else
            local function FireRow(title, color, payMin, payMax)
                imgui.TextColored(color, title)
                imgui.Text("   No Premium: "); imgui.SameLine(135)
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "$" .. payMin .. " - $" .. payMax)
                imgui.Text("   With Premium: "); imgui.SameLine(135)
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "$" .. math.floor(payMin*1.5) .. " - $" .. math.floor(payMax*1.5))
                imgui.Spacing()
            end

            FireRow("[Skill 1] Petrol Tanker", imgui.ImVec4(0.4, 0.8, 1, 1), 105, 2745)
            imgui.NextColumn() 
            FireRow("[Skill 2] Burning Vehicles", imgui.ImVec4(1, 0.6, 0.2, 1), 140, 2850)
            imgui.NextColumn() 
            imgui.Separator()

            FireRow("[Skill 4] Dumpster Fire", imgui.ImVec4(0.4, 1, 0.4, 1), 180, 2950)
            imgui.NextColumn() 
            FireRow("[Skill 6] Building in Flames", imgui.ImVec4(1, 0.3, 0.3, 1), 250, 3050)
            imgui.NextColumn() 
            imgui.Separator()
         
            FireRow("[Skill 8] Gas Leak", imgui.ImVec4(0.8, 0.4, 1, 1), 380, 3180)
            imgui.NextColumn() 
            FireRow("[Skill 10] Roof Rescue", imgui.ImVec4(1, 1, 1, 1), 540, 3340)
        end
        imgui.Columns(1) 
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("FireFooter", imgui.ImVec2(0, 220), true)   
        imgui.Columns(2, "fireFCols", false)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "RECOMPENSE:")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 - Firefighter Moonbeam")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 2 - 3 - Firefighter Rumpo")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 4 - 5 - Firefighter BF Injection")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 6 - 7 - Firefighter DFT-30")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 8 - Firefighter Fire Ladder")
            imgui.TextColored(imgui.ImVec4(0.4, 0.6, 1, 1), "Skill 9 - Firefighter Securicar")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 10 - Firefighter Elite Fire Ladder")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL (CURSE):")  
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 necesita 30 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 3 necesita 90 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 4 necesita 210 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 5 necesita 450 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 6 necesita 650 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.4, 0.6, 1, 1), "Skill 7 necesita 900 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 8 necesita 1200 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0.6, 1), "Skill 9 necesita 1550 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Skill 10 necesita 1900 Job Skill Points.")     
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "VEHICLE REWARDS:")
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 - Firefighter Moonbeam")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 2 - 3 - Firefighter Rumpo")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 4 - 5 - Firefighter BF Injection")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 6 - 7 - Firefighter DFT-30")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 8 - Firefighter Fire Ladder")
            imgui.TextColored(imgui.ImVec4(0.4, 0.6, 1, 1), "Skill 9 - Firefighter Securicar")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 10 - Firefighter Elite Fire Ladder")
            imgui.NextColumn()
            
            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SKILL (RUNS):")  
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 2 requires 30 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 3 requires 90 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 4 requires 210 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 5 requires 450 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 6 requires 650 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.4, 0.6, 1, 1), "Skill 7 requires 900 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "Skill 8 requires 1200 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0.6, 1), "Skill 9 requires 1550 Job Skill Points.")
            imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Skill 10 requires 1900 Job Skill Points.")     
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "SPECIFICATII REZERVOR APA:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "WATER TANK SPECIFICATIONS:")
    end
    
    imgui.BeginChild("FireWater", imgui.ImVec2(0, 150), true)  
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 - 700 unitati de apa (10 curse)  |  Skill 2 - 900 unitati de apa (13 curse)")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 3 - 1100 unitati de apa (15 curse) |  Skill 4 - 1300 unitati de apa (18 curse)")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 5 - 1400 unitati de apa (20 curse) |  Skill 6 - 1500 unitati de apa (21 curse)")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 7 - 1700 unitati de apa (24 curse) |  Skill 8 - 1900 unitati de apa (27 curse)")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 9 - 2100 unitati de apa (30 curse) |  Skill 10 - 2200 unitati de apa (31 curse)")
        else
            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Skill 1 - 700 water units (10 runs)  |  Skill 2 - 900 water units (13 runs)")
            imgui.TextColored(imgui.ImVec4(1, 0.7, 0, 1), "Skill 3 - 1100 water units (15 runs) |  Skill 4 - 1300 water units (18 runs)")
            imgui.TextColored(imgui.ImVec4(1, 0.4, 0, 1), "Skill 5 - 1400 water units (20 runs) |  Skill 6 - 1500 water units (21 runs)")
            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), "Skill 7 - 1700 water units (24 runs) |  Skill 8 - 1900 water units (27 runs)")
            imgui.TextColored(imgui.ImVec4(0, 1, 0.8, 1), "Skill 9 - 2100 water units (30 runs) |  Skill 10 - 2200 water units (31 runs)")
        end
    imgui.EndChild()
end

local function renderDailyJobDetails()
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "J O B U L - Z I L E I")
    else
        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "J O B - O F - T H E - D A Y")
    end
    imgui.Separator()
    
    imgui.BeginChild("JZBase", imgui.ImVec2(0, 120), true)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "DESCRIERE SISTEM:")
            imgui.Separator()
            imgui.BulletText("Obiectiv: Dublarea castigurilor cash pentru un job specific selectat.")
            imgui.BulletText("Durata: 24 de ore (se reseteaza complet la ora exacta 00:00).")
            imgui.BulletText("Identificare: Marcat stabil cu text special in lista sistemului [/jobs].")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "SYSTEM DESCRIPTION:")
            imgui.Separator()
            imgui.BulletText("Objective: Double cash earnings for a specific selected job.")
            imgui.BulletText("Duration: 24 hours (resets completely at exactly 00:00).")
            imgui.BulletText("Identification: Permanently marked with special text in the [/jobs] list.")
        end
    imgui.EndChild()  
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "CALCULUL CASTIGURILOR STACKABLE:")
    else
        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "STACKABLE EARNINGS CALCULATION:")
    end
    
    imgui.BeginChild("JZCalcul", imgui.ImVec2(0, 140), true)
        if iniData.settings.lang == 0 then
            imgui.BulletText("1. Plata Baza x 2 (Bonusul nativ de Zi active)")
            imgui.BulletText("2. + 50 '/. din noua valoare (Daca detii in paralel Cont Premium)")
            imgui.BulletText("3. + Toate bonusurile active simultan (Maraton, Gold, Evenimente).")
        else
            imgui.BulletText("1. Base Payout x 2 (Native active Daily bonus)")
            imgui.BulletText("2. + 50 '/. of the new value (If you also hold a Premium Account)")
            imgui.BulletText("3. + All simultaneously active bonuses (Marathon, Gold, Events).")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("JZExclusions", imgui.ImVec2(0, 120), true)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "RESTRICTII EXCLUSE:")
            imgui.TextWrapped("Urmatoarele joburi NU pot fi selectate: Hot buzunare, Detectiv, Avocat, Fermier, Autobuz, Mester.")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "EXCLUDED RESTRICTIONS:")
            imgui.TextWrapped("The following jobs CANNOT be selected: Pickpocket, Detective, Lawyer, Farmer, Bus Driver, Craftsman.")
        end
    imgui.EndChild()
end

local function renderJobClashDetails()
    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "J O B - C L A S H")
    imgui.Separator()
    
    imgui.BeginChild("ClashBase", imgui.ImVec2(0, 130), true)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "CUM PARTICI:")
            imgui.Separator()
            imgui.TextWrapped("Zilnic, un job este ales aleatoriu ca 'Clash Job'. Fiecare cursa completata aduce +1 punct in clasament. Comanda verificare: [/jobclash]")
        else
            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "HOW TO PARTICIPATE:")
            imgui.Separator()
            imgui.TextWrapped("Daily, a job is randomly selected as the 'Clash Job'. Each completed run grants +1 point in the leaderboard. Check command: [/jobclash]")
        end
    imgui.EndChild()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "RECOMPENSE MIEZUL NOPTII (00:00):")
    else
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "MIDNIGHT REWARDS (00:00):")
    end
    
    imgui.BeginChild("ClashRewards", imgui.ImVec2(0, 105), true)
        imgui.Columns(3, "rewardCols", false)     
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.84, 0, 1), "LOCUL 1\n$200,000") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.75, 0.75, 0.75, 1), "LOCUL 2\n$100,000") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.8, 0.5, 0.2, 1), "LOCUL 3\n$50,000") imgui.NextColumn()     
        else
            imgui.TextColored(imgui.ImVec4(1, 0.84, 0, 1), "1ST PLACE\n$200,000") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.75, 0.75, 0.75, 1), "2ND PLACE\n$100,000") imgui.NextColumn()
            imgui.TextColored(imgui.ImVec4(0.8, 0.5, 0.2, 1), "3RD PLACE\n$50,000") imgui.NextColumn()     
        end
        imgui.Columns(1)
    imgui.EndChild()
    imgui.Spacing()
    
    imgui.BeginChild("ClashInfo", imgui.ImVec2(0, 130), true)
        if iniData.settings.lang == 0 then
            imgui.BulletText("Resetare: Zilnic la ora 00:00 (se alege un job complet nou).")
            imgui.BulletText("Egalitate Scor: Daca punctele sunt egale, castiga cel mai vechi (ID cont mai mic).")
        else
            imgui.BulletText("Reset: Daily at 00:00 (a completely new job is chosen).")
            imgui.BulletText("Score Tie: If points are tied, the oldest account wins (lower account ID).")
        end
     imgui.EndChild()
     imgui.Spacing()    
     imgui.BeginChild("ClashVehicles", imgui.ImVec2(0, 120), true)
        if iniData.settings.lang == 0 then
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "RESTRICTII EXCLUSE:")
            imgui.TextWrapped("Urmatoarele joburi NU pot fi selectate: Hot buzunare, Detectiv, Avocat, Fermier, Autobuz, Mester, Pompier.")
        else
            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "EXCLUDED RESTRICTIONS:")
            imgui.TextWrapped("The following jobs CANNOT be selected: Pickpocket, Detective, Lawyer, Farmer, Bus Driver, Craftsman, Firefighter.")
        end
    imgui.EndChild()
end

-- [ RENDERING INFORMATII VEHICUL INTEGRAT ] --
local function renderVehicleDetailsPanel(vehName)
    local found = false
    local data = nil
    for _, v in ipairs(vehiclesData) do
        if v.Name == vehName then
            data = v
            found = true
            break
        end
    end

    if found and data then
        if iniData.settings.lang == 0 then
            imgui.Text("Vehicul: " .. data.Name)
        else
            imgui.Text("Vehicle: " .. data.Name)
        end
        imgui.Separator()
        imgui.Spacing()

        local numericPrice = 0
        if data.Price and data.Price ~= "N/A" and data.Price ~= "$0" then
            local cleanPrice = data.Price:gsub("[%$%.]", "") 
            numericPrice = tonumber(cleanPrice) or 0
        end

        if iniData.settings.lang == 0 then
            if numericPrice > 20000000 then
                imgui.Text("Pret Kelton: ")
            else
                imgui.Text("Pret Dealership: ")
            end
        else
            if numericPrice > 20000000 then
                imgui.Text("Kelton Price: ")
            else
                imgui.Text("Dealership Price: ")
            end
        end

        imgui.SameLine()
        imgui.TextColored(imgui.ImVec4(0.2, 0.9, 0.2, 1.0), data.Price)
        
        if numericPrice > 0 and numericPrice <= 20000000 then
            local refundValue = math.floor(numericPrice * 0.6)
            local formattedRefund = tostring(refundValue):reverse():gsub("(%d%d%d)", "%1."):reverse()
            if formattedRefund:sub(1, 1) == "." then formattedRefund = formattedRefund:sub(2) end
            formattedRefund = "$" .. formattedRefund

            if iniData.settings.lang == 0 then
                imgui.Text(u8("Returnare DealerShip: "))
            else
                imgui.Text("DealerShip Refund: ")
            end
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.9, 0.3, 0.3, 1.0), formattedRefund)
        end

        if data.Price_Gold and data.Price_Gold ~= "" then
            local cleanGoldPrice = data.Price_Gold:gsub("[%$%.]", "")
            local numericGoldPrice = tonumber(cleanGoldPrice)

            if numericGoldPrice and numericGoldPrice > 0 then
                local goldRefundValue = math.floor(numericGoldPrice * 0.4)
                
                local formattedGoldRefund = tostring(goldRefundValue):reverse():gsub("(%d%d%d)", "%1."):reverse()
                if formattedGoldRefund:sub(1, 1) == "." then formattedGoldRefund = formattedGoldRefund:sub(2) end
                formattedGoldRefund = "$" .. formattedGoldRefund

                if iniData.settings.lang == 0 then
                    imgui.Text(u8("Returnare DealerShip Gold: "))
                else
                    imgui.Text("DealerShip Gold Refund: ")
                end
                imgui.SameLine()
                imgui.TextColored(imgui.ImVec4(1.0, 0.85, 0.2, 1.0), formattedGoldRefund)
            end
        end
        if iniData.settings.lang == 0 then
            if data.Gold ~= "N/A" then
                if iniData.settings.lang == 0 then
                    imgui.Text("Pret Gold: ")
                else
                    imgui.Text("Gold Price: ")
                end
                imgui.SameLine()
                imgui.TextColored(imgui.ImVec4(1.0, 0.85, 0.2, 1.0), data.Gold)
            end
            
            imgui.Text("Viteza Maxima: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), data.Speed)
            
            imgui.Text("Inspirat din modelul real: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), data.Model)
            
            imgui.Text("Numar Locuri: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.9, 0.9, 0.9, 1.0), data.Seats)
            
            imgui.Text("Locatie Tuning Shop: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 0.9, 1.0), data.Tune)
        else
            if data.Gold ~= "N/A" then
                if iniData.settings.lang == 0 then
                    imgui.Text("Pret Gold: ")
                else
                    imgui.Text("Gold Price: ")
                end
                imgui.SameLine()
                imgui.TextColored(imgui.ImVec4(1.0, 0.85, 0.2, 1.0), data.Gold)
            end
            
            imgui.Text("Maximum Speed: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), data.Speed)
            
            imgui.Text("Informed by real model: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), data.Model)
            
            imgui.Text("Seats Count: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.9, 0.9, 0.9, 1.0), data.Seats)
            
            imgui.Text("Tuning Shop Location: ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.8, 0.4, 0.9, 1.0), data.Tune)
        end

        if data.Source and data.Source ~= "" then
            imgui.Spacing()
            imgui.Separator()
            if iniData.settings.lang == 0 then
                imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "Sursa Achizitie:")
            else
                imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "Purchase Source:")
            end
            imgui.TextWrapped(data.Source)
        end

        if (data.Price:find("0.000.000") or data.Price:find("25.000.000") or data.Price:find("30.000.000")) and (not data.Source or data.Source == "") then
            imgui.Spacing()
            imgui.Separator()
            if iniData.settings.lang == 0 then
                imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "* Acest vehicul premium necesita cumparat de pe website! (Ticket Kelton).")
            else
                imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "* This premium vehicle must be purchased from the website! (Kelton Ticket).")
            end
        end
    else
        if iniData.settings.lang == 0 then
            imgui.Text("Selecteaza un vehicul din categoriile din stanga.")
        else
            imgui.Text("Select a vehicle from the categories on the left.")
        end
    end
end

-- [ RENDER SELECTIE TEME (TAB 8) ] --
local function renderThemeSettings()
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Configurare generala:")
    else
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "General configuration:")
    end
    imgui.Separator()
    imgui.Spacing()
    
    imgui.PushItemWidth(150)
    if iniData.settings.lang == 0 then
        imgui.InputText("Comanda chat (fara /)", cmd_buffer, 64)
    else
        imgui.InputText("Chat command (without /)", cmd_buffer, 64)
    end
    imgui.PopItemWidth()
    
    imgui.PushItemWidth(150)
    if iniData.settings.lang == 0 then
        if imgui.Combo("Tasta 1 (Principala)", combo_key2, comboItemsCArray, keyCount) then
            iniData.settings.key2 = bindableKeys[combo_key2[0] + 1].id
            inicfg.save(iniData, directIni)
        end
    else
        if imgui.Combo("Key 1 (Main)", combo_key2, comboItemsCArray, keyCount) then
            iniData.settings.key2 = bindableKeys[combo_key2[0] + 1].id
            inicfg.save(iniData, directIni)
        end
    end
    imgui.PopItemWidth()    

    -- ----- CODUL PENTRU SELECTARE LIMBa -----
    imgui.Spacing()
    imgui.PushItemWidth(150)
    local langCArray = ffi.new("const char*[?]", #langItems)
    for i = 1, #langItems do
        langCArray[i - 1] = ffi.cast("const char*", langItems[i])
    end
    
    if imgui.Combo("Limba / Language", combo_lang, langCArray, #langItems) then
        iniData.settings.lang = combo_lang[0]
        inicfg.save(iniData, directIni)

        if iniData.settings.lang == 0 then
            sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Limba a fost schimbata in: {f54242}Romana{ffffff}.", -1)
        else
            sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Language has been changed to: {f54242}English{ffffff}.", -1)
        end
    end
    imgui.PopItemWidth()

    imgui.Spacing()    
    if imgui.Button(iniData.settings.lang == 0 and "Salveaza schimbarile" or "Save changes", imgui.ImVec2(150, 26)) then
        local targetCmd = ffi.string(cmd_buffer):gsub("%s+", "")
        
        if targetCmd ~= "" then
            registerNewCommand(targetCmd)
            local name2 = getKeyNameById(iniData.settings.key2)
            -- Definim limba pentru mesaj
            local langName = (iniData.settings.lang == 0) and "Romana" or "English"
            
            if iniData.settings.lang == 0 then
                sampAddChatMessage(string.format("{f54242}[HelperHelp]{ffffff} Setarile au fost aplicate! (Limba: {f54242}%s{ffffff}) Comanda: {f54242}/%s{ffffff} | Taste: {f54242}[%s]{ffffff}.", langName, targetCmd, name2), -1)
            else
                sampAddChatMessage(string.format("{f54242}[HelperHelp]{ffffff} Settings have been applied! (Language: {f54242}%s{ffffff}) Command: {f54242}/%s{ffffff} | Keys: {f54242}[%s]{ffffff}.", langName, targetCmd, name2), -1)
            end
        else
            if iniData.settings.lang == 0 then
                sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Comanda nu poate fi goala!", -1)
            else
                sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Command cannot be empty!", -1)
            end
        end
    end

    imgui.Spacing()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Pozitionare Text Helper Duty:")
    else
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Helper Duty Text Positioning:")
    end
    imgui.Separator()
    imgui.Spacing()
    
    imgui.PushItemWidth(250)
    if iniData.settings.lang == 0 then
        if imgui.SliderFloat("Pozitie pe Orizizontala (X)", slider_hduty_x, 0.0, 2000.0, "%.1f") then
            iniData.settings.hduty_x = slider_hduty_x[0]
            inicfg.save(iniData, directIni)
        end
        if imgui.SliderFloat("Pozitie pe Verticala (Y)", slider_hduty_y, 0.0, 1200.0, "%.1f") then
            iniData.settings.hduty_y = slider_hduty_y[0]
            inicfg.save(iniData, directIni)
        end
    else
        if imgui.SliderFloat("Horizontal Position (X)", slider_hduty_x, 0.0, 2000.0, "%.1f") then
            iniData.settings.hduty_x = slider_hduty_x[0]
            inicfg.save(iniData, directIni)
        end
        if imgui.SliderFloat("Vertical Position (Y)", slider_hduty_y, 0.0, 1200.0, "%.1f") then
            iniData.settings.hduty_y = slider_hduty_y[0]
            inicfg.save(iniData, directIni)
        end
    end
    imgui.PopItemWidth()
    
    imgui.Spacing()
    if iniData.settings.lang == 0 then
        if imgui.Button("Reseteaza pozitiile", imgui.ImVec2(250, 26)) then
            slider_hduty_x[0] = 1650.0
            slider_hduty_y[0] = 2.5
            iniData.settings.hduty_x = 1650.0
            iniData.settings.hduty_y = 2.5
            inicfg.save(iniData, directIni)
            sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Pozitiile Helper Duty au fost resetate la valorile implicite", -1)
        end
    else
        if imgui.Button("Reset positions", imgui.ImVec2(250, 26)) then
            slider_hduty_x[0] = 1650.0
            slider_hduty_y[0] = 2.5
            iniData.settings.hduty_x = 1650.0
            iniData.settings.hduty_y = 2.5
            inicfg.save(iniData, directIni)
            sampAddChatMessage("{f54242}[HelperHelp]{ffffff} Helper Duty positions have been reset to default values", -1)
        end
    end
    imgui.Spacing()
    imgui.Spacing()

    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Selecteaza o tema vizuala:")
    else
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Select a visual theme:")
    end
    imgui.Separator()
    imgui.Spacing()
    
    imgui.Columns(3, "##themes_columns", false)
    imgui.SetColumnWidth(0, 150)
    imgui.SetColumnWidth(1, 150)

    if radioButtonBoolWhite("Cyber Purple", iniData.settings.theme == 1) then iniData.settings.theme = 1; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Golden Amber", iniData.settings.theme == 2) then iniData.settings.theme = 2; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Glacial Blue", iniData.settings.theme == 3) then iniData.settings.theme = 3; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Ruby Velvet", iniData.settings.theme == 4) then iniData.settings.theme = 4; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Forest Emerald", iniData.settings.theme == 5) then iniData.settings.theme = 5; inicfg.save(iniData, directIni) end

    imgui.NextColumn()  

    if radioButtonBoolWhite("Toxic Lime", iniData.settings.theme == 6) then iniData.settings.theme = 6; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Mystic Orchid", iniData.settings.theme == 7) then iniData.settings.theme = 7; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Deep Sea Teal", iniData.settings.theme == 8) then iniData.settings.theme = 8; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Iron Grey", iniData.settings.theme == 9) then iniData.settings.theme = 9; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Magma", iniData.settings.theme == 10) then iniData.settings.theme = 10; inicfg.save(iniData, directIni) end

    imgui.NextColumn()

    if radioButtonBoolWhite("Cyberpunk Pink", iniData.settings.theme == 11) then iniData.settings.theme = 11; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Neon Acid", iniData.settings.theme == 12) then iniData.settings.theme = 12; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Royal Gold", iniData.settings.theme == 13) then iniData.settings.theme = 13; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Void Space", iniData.settings.theme == 14) then iniData.settings.theme = 14; inicfg.save(iniData, directIni) end
    if radioButtonBoolWhite("Blood Moon", iniData.settings.theme == 15) then iniData.settings.theme = 15; inicfg.save(iniData, directIni) end

    imgui.Columns(1)  
    imgui.Spacing()
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.Text("Presetari Stil Structura:")
    else
        imgui.Text("Layout Style Presets:")
    end
    imgui.Separator()
    imgui.Spacing()

    imgui.Columns(2, "##styles_columns", false)
    imgui.SetColumnWidth(0, 200)

    if iniData.settings.lang == 0 then
        if radioButtonBoolWhite("Rounded (Modern)", iniData.settings.style == 1) then
            iniData.settings.style = 1; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Classic (Patrat)", iniData.settings.style == 2) then
            iniData.settings.style = 2; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Compact (Mic)", iniData.settings.style == 3) then
            iniData.settings.style = 3; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Sci-Fi Ultra", iniData.settings.style == 4) then
            iniData.settings.style = 4; inicfg.save(iniData, directIni)
        end

        imgui.NextColumn() 

        if radioButtonBoolWhite("Sharp Gaming", iniData.settings.style == 5) then
            iniData.settings.style = 5; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Console Retro", iniData.settings.style == 6) then
            iniData.settings.style = 6; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Mobile Flat", iniData.settings.style == 7) then
            iniData.settings.style = 7; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Bubbles Style", iniData.settings.style == 8) then
            iniData.settings.style = 8; inicfg.save(iniData, directIni)
        end
    else
        if radioButtonBoolWhite("Rounded (Modern)", iniData.settings.style == 1) then
            iniData.settings.style = 1; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Classic (Square)", iniData.settings.style == 2) then
            iniData.settings.style = 2; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Compact (Small)", iniData.settings.style == 3) then
            iniData.settings.style = 3; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Sci-Fi Ultra", iniData.settings.style == 4) then
            iniData.settings.style = 4; inicfg.save(iniData, directIni)
        end

        imgui.NextColumn() 

        if radioButtonBoolWhite("Sharp Gaming", iniData.settings.style == 5) then
            iniData.settings.style = 5; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Console Retro", iniData.settings.style == 6) then
            iniData.settings.style = 6; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Mobile Flat", iniData.settings.style == 7) then
            iniData.settings.style = 7; inicfg.save(iniData, directIni)
        end
        if radioButtonBoolWhite("Bubbles Style", iniData.settings.style == 8) then
            iniData.settings.style = 8; inicfg.save(iniData, directIni)
        end
    end

    imgui.Columns(1) 
    imgui.Spacing()
    
    if iniData.settings.lang == 0 then
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "Ajustari fine interfata:")
    else
        imgui.TextColored(imgui.ImVec4(0.5, 0.7, 1.0, 1.0), "UI Fine adjustments:")
    end
    imgui.Separator()
    imgui.Spacing()
    
    imgui.BeginGroup()
        if iniData.settings.lang == 0 then
            imgui.Text("Opacitate Meniu:")
        else
            imgui.Text("Menu Opacity:")
        end
        imgui.PushItemWidth(170)
        if imgui.SliderFloat("##alpha_slider", slider_alpha, 0.2, 1.0, "%.2f") then
            iniData.settings.win_alpha = slider_alpha[0]
            inicfg.save(iniData, directIni)
        end
        imgui.PopItemWidth()
    imgui.EndGroup()

    imgui.SameLine(230)

    imgui.BeginGroup()
        if iniData.settings.lang == 0 then
            imgui.Text("Setari Margine Butoane:")
        else
            imgui.Text("Button Border Settings:")
        end
        imgui.PushItemWidth(170)
        if imgui.SliderFloat("##frame_border_slider", slider_frame_border, 0.0, 2.0, "%.1f px") then
            iniData.settings.frame_border = slider_frame_border[0]
            inicfg.save(iniData, directIni)
        end
        imgui.PopItemWidth()
    imgui.EndGroup()

    imgui.Spacing()

    imgui.BeginGroup()
        if iniData.settings.lang == 0 then
            imgui.Text("Setari Margine Fereastra:")
        else
            imgui.Text("Window Border Settings:")
        end
        imgui.PushItemWidth(170)
        if imgui.SliderFloat("##border_slider", slider_border, 0.0, 3.0, "%.1f px") then
            iniData.settings.border_size = slider_border[0]
            inicfg.save(iniData, directIni)
        end
        imgui.PopItemWidth()
    imgui.EndGroup()

    imgui.SameLine(230)

    imgui.BeginGroup()
        if iniData.settings.lang == 0 then
            imgui.Text("Marimea elementelor:")
        else
            imgui.Text("Element Scale Size:")
        end
        imgui.PushItemWidth(170)
        if imgui.SliderFloat("##scale_slider", slider_scale, 0.8, 1.4, "%.2f x") then
            iniData.settings.global_scale = slider_scale[0]
            inicfg.save(iniData, directIni)
        end
        imgui.PopItemWidth()
    imgui.EndGroup()
end

-- [ RENDER CARD CRATE ] --
local function renderSingleCrateCard(crate)
    local cardHeight = openedCrates[crate.name] and (45 + 30 + 25 + (#crate.items * 22) + 10) or 45
    imgui.BeginChild("CrateCard_" .. crate.name, imgui.ImVec2(-1, cardHeight), true)
        
        imgui.ColorButton("##color_box_" .. crate.name, crate.color, 0, imgui.ImVec2(25, 25))
        imgui.SameLine()
        
        imgui.SetCursorPosY(imgui.GetCursorPosY() + 3)
        imgui.TextColored(crate.color, crate.name)
        
        imgui.SameLine(imgui.GetWindowWidth() - 100)
        imgui.SetCursorPosY(imgui.GetCursorPosY() - 3)
        
        local btnLabel = ""
        if iniData.settings.lang == 0 then
            btnLabel = openedCrates[crate.name] and "Ascunde" or "Detalii"
        else
            btnLabel = openedCrates[crate.name] and "Hide" or "Details"
        end
        
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(crate.color.x, crate.color.y, crate.color.z, 0.35))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(crate.color.x, crate.color.y, crate.color.z, 0.60))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(crate.color.x, crate.color.y, crate.color.z, 0.85))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.0, 1.0, 1.0, 1.0))
        
        if imgui.Button(btnLabel .. " ##btn_" .. crate.name, imgui.ImVec2(80, 25)) then
            openedCrates[crate.name] = not openedCrates[crate.name]
        end
        imgui.PopStyleColor(4)
        
        if openedCrates[crate.name] then
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            
            if iniData.settings.lang == 0 then
                imgui.Text("Pret achizitie: ")
            else
                imgui.Text("Purchase price: ")
            end
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(1.0, 0.84, 0.0, 1.0), crate.priceGold) 
            imgui.SameLine()
            imgui.Text(" | ")
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(0.65, 0.65, 0.65, 1.0), crate.priceMP) 
            
            imgui.Spacing()
            if iniData.settings.lang == 0 then
                imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Iteme posibile si sanse (Drop-uri):")
            else
                imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Possible items and chances (Drops):")
            end
            imgui.Spacing()
            
            for _, item in ipairs(crate.items) do
                imgui.Bullet()
                imgui.Text(item)
            end
        end
    imgui.EndChild()
    imgui.Spacing()
end

-- [ MAIN THEME & STYLES APPLIER ] --
local function applyTheme(themeId)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local alpha = iniData.settings.win_alpha
    
  if themeId == 1 then -- Cyber Purple
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.04, 0.10, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.10, 0.07, 0.15, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.40, 0.30, 0.80, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.15, 0.12, 0.22, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.22, 0.18, 0.35, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.30, 0.25, 0.45, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.35, 0.25, 0.60, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.45, 0.35, 0.80, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.55, 0.45, 0.95, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.25, 0.20, 0.40, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.40, 0.30, 0.60, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.50, 0.40, 0.75, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.90, 0.85, 1.00, 1.00)
elseif themeId == 2 then -- Golden Amber
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.10, 0.08, 0.04, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.15, 0.12, 0.07, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.80, 0.60, 0.20, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.22, 0.18, 0.10, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.35, 0.28, 0.15, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.45, 0.38, 0.20, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.60, 0.45, 0.15, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.80, 0.60, 0.25, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.75, 0.35, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.30, 0.10, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.60, 0.45, 0.15, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.60, 0.25, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.95, 0.80, 1.00)
elseif themeId == 3 then -- Glacial Blue
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.04, 0.07, 0.10, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.07, 0.12, 0.18, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.30, 0.70, 1.00, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.12, 0.22, 0.35, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.18, 0.35, 0.55, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.25, 0.50, 0.75, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.20, 0.45, 0.70, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.35, 0.65, 0.90, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.50, 0.85, 1.00, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.15, 0.30, 0.50, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.25, 0.50, 0.75, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.40, 0.70, 0.95, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.80, 0.95, 1.00, 1.00)
elseif themeId == 4 then -- Ruby Velvet
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.12, 0.04, 0.06, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.18, 0.06, 0.10, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.70, 0.10, 0.20, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.30, 0.08, 0.12, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.45, 0.15, 0.20, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.60, 0.22, 0.30, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.55, 0.12, 0.18, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.80, 0.20, 0.30, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.30, 0.40, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.08, 0.12, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.60, 0.15, 0.20, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.85, 0.25, 0.35, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.85, 0.90, 1.00)
elseif themeId == 5 then -- Forest Emerald
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.04, 0.08, 0.06, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.06, 0.12, 0.09, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.20, 0.60, 0.30, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.10, 0.20, 0.15, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.18, 0.35, 0.25, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.25, 0.50, 0.35, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.15, 0.40, 0.25, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.25, 0.60, 0.40, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.35, 0.80, 0.55, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.12, 0.30, 0.20, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.20, 0.45, 0.30, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.30, 0.65, 0.45, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.85, 1.00, 0.90, 1.00)
elseif themeId == 6 then -- Toxic Lime
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.05, 0.06, 0.02, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.08, 0.10, 0.04, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.60, 0.80, 0.10, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.15, 0.20, 0.08, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.25, 0.35, 0.12, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.35, 0.50, 0.18, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.40, 0.60, 0.05, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.60, 0.85, 0.10, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.80, 1.00, 0.20, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.25, 0.40, 0.05, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.40, 0.60, 0.08, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.60, 0.85, 0.12, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.95, 1.00, 0.80, 1.00)
elseif themeId == 7 then -- Mystic Orchid
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.08, 0.04, 0.08, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.12, 0.06, 0.12, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.90, 0.30, 0.80, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.22, 0.10, 0.20, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.35, 0.18, 0.32, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.50, 0.25, 0.45, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.60, 0.20, 0.55, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.80, 0.35, 0.75, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.50, 0.95, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.15, 0.35, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.60, 0.25, 0.55, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.35, 0.75, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.90, 0.98, 1.00)
elseif themeId == 8 then -- Deep Sea Teal
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.02, 0.06, 0.06, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.04, 0.10, 0.10, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.10, 0.50, 0.50, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.08, 0.20, 0.20, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.15, 0.35, 0.35, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.25, 0.50, 0.50, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.10, 0.40, 0.40, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.20, 0.60, 0.60, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.30, 0.80, 0.80, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.08, 0.30, 0.30, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.15, 0.45, 0.45, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.25, 0.65, 0.65, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.80, 1.00, 1.00, 1.00)
elseif themeId == 9 then -- Iron Grey
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.08, 0.08, 0.08, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.40, 0.40, 0.40, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.18, 0.18, 0.18, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.30, 0.30, 0.30, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.45, 0.45, 0.45, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.22, 0.22, 0.22, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.35, 0.35, 0.35, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
elseif themeId == 10 then -- Magma
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.10, 0.04, 0.04, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.15, 0.06, 0.06, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.90, 0.30, 0.10, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.25, 0.08, 0.08, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.40, 0.15, 0.15, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.55, 0.25, 0.25, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.70, 0.20, 0.08, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.90, 0.35, 0.15, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.50, 0.25, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.50, 0.12, 0.08, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.70, 0.25, 0.12, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.90, 0.40, 0.20, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.90, 0.80, 1.00)
elseif themeId == 11 then -- Cyberpunk Pink
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.04, 0.10, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.10, 0.06, 0.15, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(1.00, 0.00, 0.60, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.20, 0.08, 0.25, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.35, 0.15, 0.40, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.50, 0.22, 0.60, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.70, 0.15, 0.50, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.90, 0.25, 0.70, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.35, 0.90, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.50, 0.10, 0.40, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.70, 0.20, 0.55, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.90, 0.30, 0.75, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.90, 1.00, 1.00)
elseif themeId == 12 then -- Neon Acid
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.04, 0.06, 0.04, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.07, 0.12, 0.07, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.40, 1.00, 0.10, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.12, 0.25, 0.12, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.20, 0.40, 0.20, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.30, 0.60, 0.30, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.30, 0.70, 0.15, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.45, 0.90, 0.25, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.60, 1.00, 0.40, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.20, 0.50, 0.10, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.35, 0.70, 0.20, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.50, 0.90, 0.30, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.90, 1.00, 0.90, 1.00)
elseif themeId == 13 then -- Royal Gold
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.05, 0.03, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.10, 0.08, 0.05, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(1.00, 0.75, 0.10, 0.50)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.18, 0.15, 0.08, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.30, 0.25, 0.12, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.45, 0.38, 0.20, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.60, 0.45, 0.10, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.80, 0.60, 0.20, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.75, 0.30, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.30, 0.08, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.60, 0.45, 0.15, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.60, 0.25, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.95, 0.80, 1.00)
elseif themeId == 14 then -- Void Space
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.02, 0.02, 0.06, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.04, 0.04, 0.10, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(0.30, 0.40, 0.90, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.08, 0.10, 0.22, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.15, 0.20, 0.35, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.25, 0.30, 0.50, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.20, 0.30, 0.60, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.35, 0.45, 0.80, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.50, 0.60, 1.00, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.15, 0.20, 0.40, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.25, 0.35, 0.60, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.40, 0.50, 0.80, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(0.85, 0.90, 1.00, 1.00)
elseif themeId == 15 then -- Blood Moon
    colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.02, 0.02, alpha)
    colors[imgui.Col.ChildBg] = imgui.ImVec4(0.10, 0.04, 0.04, 1.00)
    colors[imgui.Col.Border] = imgui.ImVec4(1.00, 0.15, 0.15, 0.40)
    colors[imgui.Col.FrameBg] = imgui.ImVec4(0.22, 0.08, 0.08, 1.00)
    colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.35, 0.15, 0.15, 1.00)
    colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.50, 0.25, 0.25, 1.00)
    colors[imgui.Col.Button] = imgui.ImVec4(0.65, 0.15, 0.15, 0.60)
    colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.85, 0.25, 0.25, 0.80)
    colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.35, 0.35, 1.00)
    colors[imgui.Col.Header] = imgui.ImVec4(0.45, 0.08, 0.08, 0.70)
    colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.65, 0.20, 0.20, 0.80)
    colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.85, 0.30, 0.30, 1.00)
    colors[imgui.Col.Text] = imgui.ImVec4(1.00, 0.80, 0.80, 1.00)
end
end

local function applyStyle(styleId)
    local style = imgui.GetStyle()
    local scale = iniData.settings.global_scale
    
    style.WindowBorderSize = iniData.settings.border_size
    style.FrameBorderSize  = iniData.settings.frame_border
    
    if not isFontScaleSet or imgui.GetIO().FontGlobalScale ~= scale then
        imgui.GetIO().FontGlobalScale = scale
        isFontScaleSet = true
    end

    if styleId == 1 then
        style.WindowRounding    = 10.0 * scale
        style.FrameRounding     = 6.0 * scale
        style.ChildRounding     = 6.0 * scale
        style.ScrollbarRounding = 12.0 * scale
        style.GrabRounding      = 6.0 * scale
        style.ItemSpacing.x     = 8.0 * scale
        style.ItemSpacing.y     = 6.0 * scale
    elseif styleId == 2 then
        style.WindowRounding    = 0.0
        style.FrameRounding     = 0.0
        style.ChildRounding     = 0.0
        style.ScrollbarRounding = 0.0
        style.GrabRounding      = 0.0
        style.ItemSpacing.x     = 10.0 * scale
        style.ItemSpacing.y     = 6.0 * scale
    elseif styleId == 3 then
        style.WindowRounding    = 3.0 * scale
        style.FrameRounding     = 2.0 * scale
        style.ChildRounding     = 2.0 * scale
        style.ScrollbarRounding = 4.0 * scale
        style.GrabRounding      = 2.0 * scale
        style.ItemSpacing.x     = 5.0 * scale
        style.ItemSpacing.y     = 3.0 * scale
    elseif styleId == 4 then
        style.WindowRounding    = 18.0 * scale
        style.FrameRounding     = 10.0 * scale
        style.ChildRounding     = 10.0 * scale
        style.ScrollbarRounding = 16.0 * scale
        style.GrabRounding      = 8.0 * scale
        style.ItemSpacing.x     = 9.0 * scale
        style.ItemSpacing.y     = 7.0 * scale
    elseif styleId == 5 then
        style.WindowRounding    = 2.0 * scale
        style.FrameRounding     = 1.0 * scale
        style.ChildRounding     = 1.0 * scale
        style.ScrollbarRounding = 2.0 * scale
        style.GrabRounding      = 1.0 * scale
        style.ItemSpacing.x     = 12.0 * scale
        style.ItemSpacing.y     = 8.0 * scale
    elseif styleId == 6 then
        style.WindowRounding    = 0.0
        style.FrameRounding     = 4.0 * scale
        style.ChildRounding     = 0.0
        style.ScrollbarRounding = 0.0
        style.GrabRounding      = 4.0 * scale
        style.ItemSpacing.x     = 14.0 * scale
        style.ItemSpacing.y     = 10.0 * scale
    elseif styleId == 7 then
        style.WindowRounding    = 7.0 * scale
        style.FrameRounding     = 4.0 * scale
        style.ChildRounding     = 5.0 * scale
        style.ScrollbarRounding = 6.0 * scale
        style.GrabRounding      = 4.0 * scale
        style.ItemSpacing.x     = 7.0 * scale
        style.ItemSpacing.y     = 5.0 * scale
    elseif styleId == 8 then
        style.WindowRounding    = 25.0 * scale
        style.FrameRounding     = 14.0 * scale
        style.ChildRounding     = 14.0 * scale
        style.ScrollbarRounding = 20.0 * scale
        style.GrabRounding      = 12.0 * scale
        style.ItemSpacing.x     = 8.0 * scale
        style.ItemSpacing.y     = 6.0 * scale
    end
end

-- [ MAIN RENDER LOOP ] --
local MainWindow = imgui.OnFrame(function()
    return WinState[0]
end, function(player)
    imgui.SetNextWindowSize(imgui.ImVec2(1060, 885), imgui.Cond.FirstUseEver)
    
    imgui.Begin("Helper Menu ##MainWindow", WinState, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoNavInputs)
    
    applyTheme(iniData.settings.theme)
    applyStyle(iniData.settings.style)
    
    -- [ TOP BAR ] --
    local windowWidth = imgui.GetWindowWidth()
    local headerTextWidth = imgui.CalcTextSize(headerText).x
    local headerCenterX = (windowWidth - headerTextWidth) / 2
    
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetCursorPosX(headerCenterX)
    imgui.Text(headerText)
    
    imgui.SameLine(windowWidth - 35)
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
    if buttonBlack("X", imgui.ImVec2(25, 20)) then
        WinState[0] = false
        imgui.GetIO().WantCaptureKeyboard = false
    end
    imgui.PopStyleColor()
    
    imgui.Separator()
    imgui.Spacing()

    -- [ LEFT SIDEBAR ] --
    imgui.BeginChild("LeftSidebar", imgui.ImVec2(190, 0), true)
    for i, tab_name in ipairs(tabs) do
        local is_active = (active_tab == i)
        if is_active then
            imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
        end
        
        if buttonBlack(tab_name, imgui.ImVec2(-1, 35)) then
            active_tab = i
        end
        
        if is_active then
            imgui.PopStyleColor()
        end
    end

    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()

    local child_h = imgui.GetWindowHeight()
    local desired_button_y = child_h - 75
    if desired_button_y > imgui.GetCursorPosY() then imgui.SetCursorPosY(desired_button_y) end
    
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.80, 0.12, 0.12, 1.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.90, 0.18, 0.18, 1.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.10, 0.10, 1.00))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1,1,1,1))
    if imgui.Button("Close", imgui.ImVec2(-1, 35)) then
        WinState[0] = false
        imgui.GetIO().WantCaptureKeyboard = false
        if sampSetCursorMode then sampSetCursorMode(0) end
    end
    imgui.PopStyleColor(4)

    imgui.Spacing()
    local sidebarWidth = imgui.GetWindowWidth()
    local textWidth = getCleanTextWidth(footerText)
    local centerX = (sidebarWidth - textWidth) / 2
    
    imgui.SetCursorPosX(centerX)
    renderSampColoredText(footerText)

    imgui.EndChild()

    imgui.SameLine()

    -- [ RIGHT MAIN PANEL ] --
    -- [ RIGHT MAIN PANEL ] --
    imgui.BeginChild("MainContent", imgui.ImVec2(0, 0), true)

        local raw_search = ffi.string(search_buffer)
        local isSearchActive = (raw_search ~= "")
        local inputWidth = isSearchActive and -75 or -1 
        
        imgui.PushItemWidth(inputWidth)
        if iniData.settings.lang == 0 then
            imgui.InputTextWithHint("##search", "Cauta global prin tot scriptul...", search_buffer, 256)
        else
            imgui.InputTextWithHint("##search", "Search globally through the entire script...", search_buffer, 256)
        end
        imgui.PopItemWidth()
        
        if isSearchActive then
            imgui.SameLine()
            if imgui.Button("Clear", imgui.ImVec2(65, 22)) then
                ffi.copy(search_buffer, "")
                isSearchActive = false
                raw_search = ""
                imgui.GetIO().WantCaptureKeyboard = false
            end
        end
        
        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()

        local current_search = u8:decode(raw_search):lower()

        -- [ LOGICA RENDARII GLOBAL / INDIVIDUAL ] --
        if isSearchActive then
            if iniData.settings.lang == 0 then
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Rezultate cautare globala pentru: '" .. raw_search .. "'")
            else
                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Global search results for: '" .. raw_search .. "'")
            end
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()

            local foundAny = false
            imgui.BeginChild("GlobalSearchScrollArea", imgui.ImVec2(0, 0), false)

            -- Cautare inteligenta in textul de intampinare din Panoul Principal (RO / EN)
            if ("bine ai venit in panoul principal"):find(current_search, 1, true) or 
               ("principal"):find(current_search, 1, true) or
               ("welcome to the main panel"):find(current_search, 1, true) or
               ("main panel"):find(current_search, 1, true) then
               
                foundAny = true
                if iniData.settings.lang == 0 then
                    if imgui.CollapsingHeader("Rezultate din: Panoul Principal") then
                        imgui.TextWrapped("Bine ai venit in panoul principal!")
                    end
                else
                    if imgui.CollapsingHeader("Results from: Main Panel") then
                        imgui.TextWrapped("Welcome to the main panel!")
                    end
                end
                imgui.Spacing()
            end

            -- Cautare prin Joburi
            local jobMatches = {}
            for idx, jobName in ipairs(jobs_list) do
                if jobName:lower():find(current_search, 1, true) then
                    table.insert(jobMatches, {name = jobName, id = idx})
                end
            end
            
            if #jobMatches > 0 then
                foundAny = true
                local headerLabel = iniData.settings.lang == 0 and ("Rezultate din: Joburi (" .. #jobMatches .. ")") or ("Results from: Jobs (" .. #jobMatches .. ")")
                
                if imgui.CollapsingHeader(headerLabel) then
                    for _, jm in ipairs(jobMatches) do
                        if imgui.TreeNodeStr(jm.name .. " ##global_job_" .. jm.id) then
                            if jm.id == 1 then renderQuarryDetails()
                            elseif jm.id == 2 then renderLumberjackDetails()
                            elseif jm.id == 3 then renderMinerDetails()
                            elseif jm.id == 4 then renderGarbageDetails()
                            elseif jm.id == 5 then renderBusDriverDetails()
                            elseif jm.id == 6 then renderFishermanDetails()
                            elseif jm.id == 7 then renderTruckerDetails()
                            elseif jm.id == 8 then renderFarmerDetails()
                            elseif jm.id == 9 then renderChemistDetails()
                            elseif jm.id == 10 then renderDetectiveDetails()
                            elseif jm.id == 11 then renderTransporterDetails()
                            elseif jm.id == 12 then renderDrugsDealerDetails()
                            elseif jm.id == 13 then renderCarJackerDetails()
                            elseif jm.id == 14 then renderMecanicDetails()
                            elseif jm.id == 15 then renderArmsDealerDetails()
                            elseif jm.id == 16 then renderArcheologistDetails()
                            elseif jm.id == 17 then renderElectricianDetails()
                            elseif jm.id == 18 then renderLawyerDetails()
                            elseif jm.id == 19 then renderPocketThiefDetails()
                            elseif jm.id == 20 then renderCraftsmanDetails()
                            elseif jm.id == 21 then renderFirefighterDetails()
                            elseif jm.id == 22 then renderDailyJobDetails()
                            elseif jm.id == 23 then renderJobClashDetails()
                            end
                            imgui.TreePop()
                        end
                    end
                end
                imgui.Spacing()
            end

            -- Cautare prin Vehicule
            local vehMatches = {}
            for _, v in ipairs(vehiclesData) do
                if v.Name:lower():find(current_search, 1, true) or v.Model:lower():find(current_search, 1, true) then
                    table.insert(vehMatches, v)
                end
            end
            
            if #vehMatches > 0 then
                foundAny = true
                local vehHeaderLabel = iniData.settings.lang == 0 and ("Rezultate din: Vehicule (" .. #vehMatches .. ")") or ("Results from: Vehicles (" .. #vehMatches .. ")")
                
                if imgui.CollapsingHeader(vehHeaderLabel) then
                    for _, vm in ipairs(vehMatches) do
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.0, 0.8, 1.0, 1.0))
                        local nodeOpen = imgui.TreeNodeStr(vm.Name .. " (" .. vm.Price .. ") ##node_" .. vm.Name)
                        imgui.PopStyleColor()
                        if nodeOpen then
                            imgui.Spacing()
                            renderVehicleDetailsPanel(vm.Name)
                            imgui.Spacing()
                            imgui.TreePop()
                        end
                    end
                end
                imgui.Spacing()
            end

            -- Cautare prin Crate-uri
            local crateMatches = {}
            for _, crate in ipairs(cratesData) do
                if crate.name:lower():find(current_search, 1, true) or crate.priceGold:lower():find(current_search, 1, true) or crate.priceMP:lower():find(current_search, 1, true) then
                    table.insert(crateMatches, crate)
                else
                    for _, item in ipairs(crate.items) do
                        if item:lower():find(current_search, 1, true) then
                            table.insert(crateMatches, crate)
                            break
                        end
                    end
                end
            end
            
            if #crateMatches > 0 then
                foundAny = true
                local crateHeaderLabel = iniData.settings.lang == 0 and ("Rezultate din: Crate-uri (" .. #crateMatches .. ")") or ("Results from: Crates (" .. #crateMatches .. ")")
                
                if imgui.CollapsingHeader(crateHeaderLabel) then
                    imgui.Spacing()
                    for _, crate in ipairs(crateMatches) do
                        renderSingleCrateCard(crate)
                    end
                end
                imgui.Spacing()
            end

            local systemMatches = {}
            local systemsData = {
            {name = "Misiuni (Ryder, Dimitri, OG Loc)", nameEN = "Missions (Ryder, Dimitri, OG Loc)", keywords = "misiuni ryder dimitri og loc jetpack space marte"},
            {name = "Bunker (SF, LV, LS)", nameEN = "Bunker (SF, LV, LS)", keywords = "bunker upgrades staff securitate monitorizare provizii stoc tier buybunker"},
            {name = "Job Goal", nameEN = "Job Goal", keywords = "job goal obiectiv global individual saptamanal rewards"},
            {name = "Cufar (Rewards)", nameEN = "Chest (Rewards)", keywords = "cufar reward rewards premiu premii tier permanent permanent"},
            {name = "Skinuri Speciale & Trader", nameEN = "Special Skins & Trader", keywords = "skinuri speciale upgrade trader ticket diamond onyx platinum fragmente"},
            {name = "Clan XP", nameEN = "Clan XP", keywords = "clan xp experienta ilegal rob solo heist escape meserii spray"},
            {name = "Rob ATM", nameEN = "Rob ATM", keywords = "rob atm heist cod sms interfata parasute recompense"},
            {name = "Rob Solo", nameEN = "Rob Solo", keywords = "rob solo seif burghiu space evadare barca cash minigame"},
            {name = "Rob Team", nameEN = "Rob Team", keywords = "rob team roluri loaner scout gas man bijuterii sac pilot"},
            {name = "Escape (Evadare)", nameEN = "Escape", keywords = "escape evadare gard hit puscariasi wanted snitch"},
            {name = "Jail (Inchisoare)", nameEN = "Jail", keywords = "jailtime inchisoare detinuti free jaillist vizite"},
            {name = "Skinuri Factiuni (PD/Mafioti/Pasnice)", nameEN = "Faction Skins (PD/Mafia/Peaceful)", keywords = "skinuri factiuni pd fbi ng taxi paramedics rank lspd tsar bratva verdant"},
            {name = "Licente (Suspendare & Costuri)", nameEN = "Licenses (Suspension & Costs)", keywords = "licente zbor navigatie pescuit arma port roads viteza confiscare instructor npc"},
            {name = "Niveluri Minime (Sisteme)", nameEN = "Minimum Levels (Systems)", keywords = "niveluri minime barbut spin poker ad trade transfer buybunker rob"},
            {name = "Referral", nameEN = "Referral", keywords = "referral buylevel invitatie prieteni cod account stats"},
            {name = "Safebox (Seifuri)", nameEN = "Safebox (Safes)", keywords = "safebox seif seifuri sb opensafe throw deagle m4 rifle unitati arms dealer"},
            {name = "Masini Tutorial", nameEN = "Tutorial Vehicles", keywords = "masini tutorial faggio perrenial bobcat bravura landstalker vehicul"},
            {name = "Economie & Preturi", nameEN = "Economy & Prices", keywords = "economie preturi combustibil arme bauturi obiecte asigurari job uri"},
            {name = "Amenzi & Legislatie", nameEN = "Fines & Legislation", keywords = "amenzi legislatie circulatie confiscari permis suspendare reguli"},
            {name = "Trader Shop", nameEN = "Trader Shop", keywords = "trader shop reroll fuziune fuziune skin diamond onyx reciclare reciclare puncte tichete crate uri"},
            {name = "PayDay", nameEN = "PayDay", keywords = "payday payday bonusuri happy hour respect rob escape clear fp dobanda premium nivel payday"},
        }

            for idx, sys in ipairs(systemsData) do
                local matchNameRO = sys.name:lower():find(current_search, 1, true)
                local matchNameEN = sys.nameEN:lower():find(current_search, 1, true)
                local matchKeywords = sys.keywords:lower():find(current_search, 1, true)
                
                if matchNameRO or matchNameEN or matchKeywords then
                    local displayName = iniData.settings.lang == 0 and sys.name or sys.nameEN
                    table.insert(systemMatches, {name = displayName, id = idx})
                end
            end

            if #systemMatches > 0 then
                foundAny = true
                local systemHeaderLabel = iniData.settings.lang == 0 and ("Rezultate din: Ghiduri si Sisteme (" .. #systemMatches .. ")") or ("Results from: Guides and Systems (" .. #systemMatches .. ")")
                
                if imgui.CollapsingHeader(systemHeaderLabel) then
                    for _, sm in ipairs(systemMatches) do
                        if imgui.TreeNodeStr(sm.name .. " ##global_sys_" .. sm.id) then
                            if sm.id == 1 then
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "--- SISTEMUL DE MISIUNI ---")
                                    imgui.Separator()
                                    imgui.BeginChild("MissionsLocalBox", imgui.ImVec2(0, 110), true)
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "REGULI SI COMENZI:")
                                        imgui.Separator()
                                        imgui.BulletText("Cooldown: O misiune noua la fiecare 4 ore.")
                                        imgui.BulletText("Parasire: [/leavemission] (nu activeaza cooldown-ul).")
                                        imgui.BulletText("Licente: Poti conduce barci/avioane fara licenta in misiune.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "MISIUNI DISPONIBILE PE NIVELURI:")
                                    imgui.BeginChild("MissionsRyderBox", imgui.ImVec2(0, 100), true)
                                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "RYDER (Nivel 1+)")
                                        imgui.Separator()
                                        imgui.Text("1. Fura Jetpack-ul: $15.000 + 5 MP\n2. Fura pachete de armament: $5.000 + 3 MP\n3. Raid: $5.000 + 3 MP")
                                    imgui.EndChild()
                                    imgui.BeginChild("MissionsDimitriBox", imgui.ImVec2(0, 120), true)
                                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "DIMITRI PETRENKO (Nivel 1+)")
                                        imgui.Separator()
                                        imgui.Text("1. Fura bucati de metal: $15.000 + 5 MP\n2. Fura naveta spatiala: $5.000 + 3 MP\n3. Adu motoarele: $10.000 + 4 MP\n4. Zbor pe Marte: $15.000 + 5 MP")
                                    imgui.EndChild()
                                    imgui.BeginChild("MissionsOGBox", imgui.ImVec2(0, 85), true)
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "OG LOC (Nivel 5+)")
                                        imgui.Separator()
                                        imgui.Text("1. Fura discul: $15.000 + 5 MP\n2. Fa-ti prieteni noi: $5.000 + 3 MP")
                                    imgui.EndChild()
                                    imgui.Separator()
                                    imgui.TextDisabled("Nota: Misiunile NEA MIREL si CATALIN sunt specifice evenimentelor.")
                                else
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "--- MISSIONS SYSTEM ---")
                                    imgui.Separator()
                                    imgui.BeginChild("MissionsLocalBox", imgui.ImVec2(0, 110), true)
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "RULES AND COMMANDS:")
                                        imgui.Separator()
                                        imgui.BulletText("Cooldown: A new mission every 4 hours.")
                                        imgui.BulletText("Leave: [/leavemission] (does not trigger cooldown).")
                                        imgui.BulletText("Licenses: You can drive boats/airplanes without a license during missions.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "AVAILABLE MISSIONS BY LEVEL:")
                                    imgui.BeginChild("MissionsRyderBox", imgui.ImVec2(0, 100), true)
                                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "RYDER (Level 1+)")
                                        imgui.Separator()
                                        imgui.Text("1. Steal the Jetpack: $15.000 + 5 MP\n2. Steal weapon packages: $5.000 + 3 MP\n3. Raid: $5.000 + 3 MP")
                                    imgui.EndChild()
                                    imgui.BeginChild("MissionsDimitriBox", imgui.ImVec2(0, 120), true)
                                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "DIMITRI PETRENKO (Level 1+)")
                                        imgui.Separator()
                                        imgui.Text("1. Steal scrap metal: $15.000 + 5 MP\n2. Steal the spaceship: $5.000 + 3 MP\n3. Bring the engines: $10.000 + 4 MP\n4. Flight to Mars: $15.000 + 5 MP")
                                    imgui.EndChild()
                                    imgui.BeginChild("MissionsOGBox", imgui.ImVec2(0, 85), true)
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "OG LOC (Level 5+)")
                                        imgui.Separator()
                                        imgui.Text("1. Steal the disc: $15.000 + 5 MP\n2. Make new friends: $5.000 + 3 MP")
                                    imgui.EndChild()
                                    imgui.Separator()
                                    imgui.TextDisabled("Note: NEA MIREL and CATALIN missions are event-specific.")
                                  end
                            elseif sm.id == 2 then -- BUNKER
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "--- SISTEMUL DE BUNKER ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "LOCATII SI PRETURI CUMPARARE:")
                                    imgui.BeginChild("BunkerLocsBox", imgui.ImVec2(0, 65), true)
                                        imgui.Columns(3, "bunkLocsCols", false)
                                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Basin (SF)"); imgui.Text("$1.000.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Diablo (LV)"); imgui.Text("$2.500.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "Blueberry (LS)"); imgui.Text("$3.500.000"); imgui.Columns(1)
                                    imgui.EndChild()

                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "COSTURI UPGRADES PE LOCATII:")
                                    imgui.BeginChild("BunkerUpgBox", imgui.ImVec2(0, 210), true)
                                        imgui.Columns(4, "bunkUpgCols", false)
                                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "Upgrade") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.0, 0.7, 1.0, 1.0), "San Fierro") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "Las Venturas") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.68, 0.26, 0.73, 1.0), "Los Santos") imgui.NextColumn()
                                        imgui.Separator()
                                        
                                        imgui.Text("Echipament"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn(); imgui.Text("$600.000"); imgui.NextColumn(); imgui.Text("$800.000"); imgui.NextColumn()
                                        imgui.Text("Staff"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn(); imgui.Text("$600.000"); imgui.NextColumn(); imgui.Text("$800.000"); imgui.NextColumn()
                                        imgui.Text("Securitate"); imgui.NextColumn(); imgui.Text("$200.000"); imgui.NextColumn(); imgui.Text("$300.000"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn()
                                        imgui.Text("Supraveghere"); imgui.NextColumn(); imgui.Text("$2.400.000"); imgui.NextColumn(); imgui.Text("$3.200.000"); imgui.NextColumn(); imgui.Text("$4.000.000"); imgui.NextColumn()
                                        imgui.Text("Confort"); imgui.NextColumn(); imgui.Text("$1.000.000"); imgui.NextColumn(); imgui.Text("$1.500.000"); imgui.NextColumn(); imgui.Text("$2.000.000"); imgui.NextColumn()
                                        
                                        imgui.Separator() 
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), "Total Upgrades"); imgui.NextColumn(); imgui.Text("$4.400.000"); imgui.NextColumn(); imgui.Text("$6.200.000"); imgui.NextColumn(); imgui.Text("$8.000.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.2, 0.6, 1.0, 1.0), "PRET (BUNKER + UPGRADES)"); imgui.NextColumn(); imgui.Text("$5.400.000"); imgui.NextColumn(); imgui.Text("$8.700.000"); imgui.NextColumn(); imgui.Text("$11.500.000"); imgui.Columns(1)
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "PRODUCTIE SI VANZARE:")
                                    imgui.BeginChild("BunkerProdBox", imgui.ImVec2(0, 115), true)
                                        imgui.BulletText("Viteza Max (Staff+Echip): 1 unitate / 10 min")
                                        imgui.BulletText("Consum Provizii (Maxim): 1 unitate / 300 sec")
                                        imgui.BulletText("Pret Vanzare (Departe): $2.000 / unitate | (Aproape): $1.000 / unitate")
                                        imgui.BulletText("Bonus Ajutoare: 10 '/. din plata finala")
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.95, 1.0), "CAPACITATE SI TIER PROGRES:")
                                    imgui.BeginChild("BunkerTiersBox", imgui.ImVec2(0, 65), true)
                                        imgui.Columns(2, "bunkTiersCols", false)
                                        imgui.Text("Tier 0: 100 Prov / 100 Stoc\nTier 5: 150 Prov / 100 Stoc"); imgui.NextColumn()
                                        imgui.Text("Tier 6: 150 Prov / 110 Stoc\nTier 10: 150 Prov / 150 Stoc"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Nota: Comanda /buybunker (Lvl 10). Stocul se pierde la mutare!")
                                else
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "--- BUNKER SYSTEM ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "LOCATIONS AND PURCHASE PRICES:")
                                    imgui.BeginChild("BunkerLocsBox", imgui.ImVec2(0, 65), true)
                                        imgui.Columns(3, "bunkLocsCols", false)
                                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Basin (SF)"); imgui.Text("$1.000.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Diablo (LV)"); imgui.Text("$2.500.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "Blueberry (LS)"); imgui.Text("$3.500.000"); imgui.Columns(1)
                                    imgui.EndChild()

                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "UPGRADE COSTS BY LOCATION:")
                                    imgui.BeginChild("BunkerUpgBox", imgui.ImVec2(0, 210), true)
                                        imgui.Columns(4, "bunkUpgCols", false)
                                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "Upgrade") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.0, 0.7, 1.0, 1.0), "San Fierro") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "Las Venturas") imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.68, 0.26, 0.73, 1.0), "Los Santos") imgui.NextColumn()
                                        imgui.Separator()
                                        
                                        imgui.Text("Equipment"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn(); imgui.Text("$600.000"); imgui.NextColumn(); imgui.Text("$800.000"); imgui.NextColumn()
                                        imgui.Text("Staff"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn(); imgui.Text("$600.000"); imgui.NextColumn(); imgui.Text("$800.000"); imgui.NextColumn()
                                        imgui.Text("Security"); imgui.NextColumn(); imgui.Text("$200.000"); imgui.NextColumn(); imgui.Text("$300.000"); imgui.NextColumn(); imgui.Text("$400.000"); imgui.NextColumn()
                                        imgui.Text("Monitoring"); imgui.NextColumn(); imgui.Text("$2.400.000"); imgui.NextColumn(); imgui.Text("$3.200.000"); imgui.NextColumn(); imgui.Text("$4.000.000"); imgui.NextColumn()
                                        imgui.Text("Comfort"); imgui.NextColumn(); imgui.Text("$1.000.000"); imgui.NextColumn(); imgui.Text("$1.500.000"); imgui.NextColumn(); imgui.Text("$2.000.000"); imgui.NextColumn()
                                        
                                        imgui.Separator() 
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), "Total Upgrades"); imgui.NextColumn(); imgui.Text("$4.400.000"); imgui.NextColumn(); imgui.Text("$6.200.000"); imgui.NextColumn(); imgui.Text("$8.000.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0.2, 0.6, 1.0, 1.0), "PRICE (BUNKER + UPGRADES)"); imgui.NextColumn(); imgui.Text("$5.400.000"); imgui.NextColumn(); imgui.Text("$8.700.000"); imgui.NextColumn(); imgui.Text("$11.500.000"); imgui.Columns(1)
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "PRODUCTION AND SELLING:")
                                    imgui.BeginChild("BunkerProdBox", imgui.ImVec2(0, 115), true)
                                        imgui.BulletText("Max Speed (Staff+Equip): 1 unit / 10 min")
                                        imgui.BulletText("Supplies Consumption (Max): 1 unit / 300 sec")
                                        imgui.BulletText("Selling Price (Far): $2.000 / unit | (Near): $1.000 / unit")
                                        imgui.BulletText("Supporters Bonus: 10 '/. of the final payment")
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.95, 1.0), "CAPACITY AND TIER PROGRESS:")
                                    imgui.BeginChild("BunkerTiersBox", imgui.ImVec2(0, 65), true)
                                        imgui.Columns(2, "bunkTiersCols", false)
                                        imgui.Text("Tier 0: 100 Supp / 100 Stock\nTier 5: 150 Supp / 100 Stock"); imgui.NextColumn()
                                        imgui.Text("Tier 6: 150 Supp / 110 Stock\nTier 10: 150 Supp / 150 Stock"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Note: /buybunker command (Lvl 10). Stock is lost when changing locations!")
                                end
                           elseif sm.id == 3 then -- JOB GOAL
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "--- SISTEM JOB GOAL ---")
                                    imgui.Separator()
                                    imgui.BeginChild("GoalDescBox", imgui.ImVec2(0, 95), true)
                                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "DESCRIERE OBIECTIV:")
                                        imgui.TextWrapped("Job Goal reprezinta suma sau '/.ajul pe care toti jucatorii de pe server trebuie sa il atinga impreuna pentru a debloca premiile zilei. Reset: Zilnic la 00:00.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "RECOMPENSE LA 100'/. COMPLETAT:")
                                    imgui.BeginChild("GoalRewardsBox", imgui.ImVec2(0, 90), true)
                                        imgui.Text("Daca obiectivul global si cel individual sunt atinse:")
                                        imgui.BulletText("Bani: intre $25.000 si $50.000\nGold: intre 5 si 10 (aleatoriu)\nRespect Points: intre 5 si 10 puncte")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "BONUS SPECIAL WEEKLY (100 GOLD):")
                                    imgui.BeginChild("GoalWeeklyBox", imgui.ImVec2(0, 75), true)
                                        imgui.TextWrapped("Jucatorii care contribuie la pragul individual in cel putin 5 zile din 7 intr-o saptamana sunt premiati automat. Reset: Luni.")
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "--- JOB GOAL SYSTEM ---")
                                    imgui.Separator()
                                    imgui.BeginChild("GoalDescBox", imgui.ImVec2(0, 95), true)
                                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "OBJECTIVE DESCRIPTION:")
                                        imgui.TextWrapped("Job Goal represents the sum or '/.age that all players on the server must achieve together to unlock the daily rewards. Reset: Daily at 00:00.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "REWARDS AT 100'/. COMPLETED:")
                                    imgui.BeginChild("GoalRewardsBox", imgui.ImVec2(0, 90), true)
                                        imgui.Text("If both global and individual objectives are met:")
                                        imgui.BulletText("Money: between $25.000 and $50.000\nGold: between 5 and 10 (random)\nRespect Points: between 5 and 10 points")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "SPECIAL WEEKLY BONUS (100 GOLD):")
                                    imgui.BeginChild("GoalWeeklyBox", imgui.ImVec2(0, 75), true)
                                        imgui.TextWrapped("Players who contribute to the individual threshold on at least 5 out of 7 days in a week are automatically rewarded. Reset: Monday.")
                                    imgui.EndChild()
                                end
                            elseif sm.id == 4 then -- CUFAR
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "--- SISTEM CUFAR (REWARDS) ---")
                                    imgui.Separator()
                                    imgui.BeginChild("ChestCmdsBox", imgui.ImVec2(0, 65), true)
                                        imgui.Text("Comenzi disponibile: /reward, /rewards, /premiu, /premii")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "REGULI SI TIMPI:")
                                    imgui.BeginChild("ChestRulesBox", imgui.ImVec2(0, 100), true)
                                        imgui.BulletText("Resetare: Zilnic la ora 23:00 (Colectare max 1 Tier/zi).")
                                        imgui.BulletText("Ore Jucate: Doar orele REALE (fara AFK/Sleep).")
                                        imgui.BulletText("Reroll: Disponibil daca nu ai slot liber sau Premium.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), "PREMII GARANTATE (TIER 5+):")
                                    imgui.BeginChild("ChestGarantatBox", imgui.ImVec2(0, 170), true)
                                        imgui.Columns(2, "chestCols", false)
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 5:"); imgui.Text(" - $50.000 Bonus")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 6:"); imgui.Text(" - $75.000 Bonus")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 7:"); imgui.Text(" - 90 Gold + $100.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 8:"); imgui.Text(" - 110 Gold + $125.000")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 9:"); imgui.Text(" - 120 Gold + $150.000")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 10:"); imgui.Text(" - 130 Gold + $150.000\n   + 1 Saptamana Premium"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.TextDisabled("Nota: Daca ai Premium Permanent, la Tier 10 primesti 75 Gold in loc de abonament.")
                                else
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "--- CHEST SYSTEM (REWARDS) ---")
                                    imgui.Separator()
                                    imgui.BeginChild("ChestCmdsBox", imgui.ImVec2(0, 65), true)
                                        imgui.Text("Available commands: /reward, /rewards, /premiu, /premii")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "RULES AND TIMINGS:")
                                    imgui.BeginChild("ChestRulesBox", imgui.ImVec2(0, 100), true)
                                        imgui.BulletText("Reset: Daily at 23:00 (Collect max 1 Tier/day).")
                                        imgui.BulletText("Hours Played: Only REAL hours (excluding AFK/Sleep).")
                                        imgui.BulletText("Reroll: Available if you don't have a free slot or Premium.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), "GUARANTEED REWARDS (TIER 5+):")
                                    imgui.BeginChild("ChestGarantatBox", imgui.ImVec2(0, 170), true)
                                        imgui.Columns(2, "chestCols", false)
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 5:"); imgui.Text(" - $50.000 Bonus")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 6:"); imgui.Text(" - $75.000 Bonus")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 7:"); imgui.Text(" - 90 Gold + $100.000"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 8:"); imgui.Text(" - 110 Gold + $125.000")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 9:"); imgui.Text(" - 120 Gold + $150.000")
                                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Tier 10:"); imgui.Text(" - 130 Gold + $150.000\n   + 1 Week of Premium"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.TextDisabled("Note: If you have Permanent Premium, you receive 75 Gold at Tier 10 instead of the subscription.")
                                end

                           elseif sm.id == 5 then -- SKINURI SPECIALE
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1.0, 1.0), "--- UPGRADE SKINURI SPECIALE ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "COSTURI TICHETE (/shop):")
                                    imgui.BeginChild("SkinTicketBox", imgui.ImVec2(0, 65), true)
                                        imgui.BulletText("Diamond Ticket: 800 Gold | Onyx Ticket: 1.000 Gold")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "PROCES UPGRADE LA TRADER SHOP (LV):")
                                    imgui.BeginChild("SkinTraderBox", imgui.ImVec2(0, 180), true)
                                        imgui.TextWrapped("Poti transforma 5 Fragmente de acelasi tip in 1 Tichet la Trader Shop (Egyptian Shop LV).")
                                        imgui.Separator()
                                        imgui.BulletText("Bronze -> Silver: 500.000$ + 50 MP + 1x Tichet Upgrade")
                                        imgui.BulletText("Silver -> Platinum: 500.000$ + 50 MP + 1x Tichet Upgrade")
                                        imgui.Separator()
                                        imgui.Spacing()
                                        imgui.BulletText("Platinum -> Diamond: $1.000.000 + 100 MP + 1 Ticket Diamond")
                                        imgui.BulletText("Diamond -> Onyx: $2.000.000 + 200 MP + 1 Ticket Onyx")
                                        imgui.Separator()
                                        imgui.BulletText("Pentru skinurile Diamond pretul va fi $4.000.000, 400 Mission Points si 3 Tichete Diamond.")
                                        imgui.BulletText("Pentru skinurile Onyx pretul va fi $6.000.000, 600 Mission Points si 5 Tichete Onyx.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "IDENTIFICARE VIZUALA:")
                                    imgui.BeginChild("SkinVisualBox", imgui.ImVec2(0, 65), true)
                                        imgui.Text("Diamond: Albastru Deschis in garderoba\nOnyx: Portocaliu in garderoba")
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1.0, 1.0), "--- SPECIAL SKINS UPGRADE ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "TICKET COSTS (/shop):")
                                    imgui.BeginChild("SkinTicketBox", imgui.ImVec2(0, 65), true)
                                        imgui.BulletText("Diamond Ticket: 800 Gold | Onyx Ticket: 1.000 Gold")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "UPGRADE PROCESS AT TRADER SHOP (LV):")
                                    imgui.BeginChild("SkinTraderBox", imgui.ImVec2(0, 180), true)
                                        imgui.TextWrapped("You can turn 5 Fragments of the same type into 1 Ticket at the Trader Shop (Egyptian Shop LV).")
                                        imgui.Separator()
                                        imgui.BulletText("Bronze -> Silver: 500.000$ + 50 MP + 1x Tichet Upgrade")
                                        imgui.BulletText("Silver -> Platinum: 500.000$ + 50 MP + 1x Tichet Upgrade")
                                        imgui.Separator()
                                        imgui.Spacing()
                                        imgui.BulletText("Platinum -> Diamond: $1.000.000 + 100 MP + 1 Diamond Ticket")
                                        imgui.BulletText("Diamond -> Onyx: $2.000.000 + 200 MP + 1 Onyx Ticket")
                                        imgui.Separator()
                                        imgui.BulletText("For Diamond skins, the price will be $4.000.000, 400 Mission Points and 3 Diamond Tickets.")
                                        imgui.BulletText("For Onyx skins, the price will be $6.000.000, 600 Mission Points and 5 Onyx Tickets.")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "VISUAL IDENTIFICATION:")
                                    imgui.BeginChild("SkinVisualBox", imgui.ImVec2(0, 65), true)
                                        imgui.Text("Diamond: Light Blue in wardrobe\nOnyx: Orange in wardrobe")
                                    imgui.EndChild()
                                end

                            elseif sm.id == 6 then -- CLAN XP
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "--- SISTEM GENERARE CLAN XP ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), "ACTIVITATI ILEGALE:")
                                    imgui.BeginChild("XPIlegalBox", imgui.ImVec2(0, 115), true)
                                        imgui.BulletText("Rob Echipa: 1 XP per punct jaf (10 XP tot) | Solo Rob: 5 XP")
                                        imgui.BulletText("ATM Heist: 3 XP per jaf reusit")
                                        imgui.BulletText("Escape: 1 XP per punct (20 XP total) | Pocket Thief: 5 XP")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "ACTIVITATI SI JOBURI:")
                                    imgui.BeginChild("XPJobsBox", imgui.ImVec2(0, 135), true)
                                        imgui.Columns(2, "xpLocalJobs", false)
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Fixe:")
                                        imgui.BulletText("Mester: 20 XP\nMisiuni: 10 XP\nCarJacker: 10 XP\nGunoier/Chimist: 6 XP"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Progresive:")
                                        imgui.BulletText("Trucker: 5 XP\nArms Dealer: 4 XP\nMiner/Curier: 3 XP\nPescar: 2 XP | Arheolog: 1 XP"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), "ALTE METODE:")
                                    imgui.BeginChild("XPMiscBox", imgui.ImVec2(0, 85), true)
                                        imgui.BulletText("Achizitii /shop: 30 XP | Taskuri Zilnice: 3 XP | Tag-uri (/spray): 1 XP (Max 30/zi)")
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "--- CLAN XP GENERATION SYSTEM ---")
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), "ILLEGAL ACTIVITIES:")
                                    imgui.BeginChild("XPIlegalBox", imgui.ImVec2(0, 115), true)
                                        imgui.BulletText("Team Rob: 1 XP per rob point (10 XP total) | Solo Rob: 5 XP")
                                        imgui.BulletText("ATM Heist: 3 XP per successful heist")
                                        imgui.BulletText("Escape: 1 XP per point (20 XP total) | Pocket Thief: 5 XP")
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), "ACTIVITIES AND JOBS:")
                                    imgui.BeginChild("XPJobsBox", imgui.ImVec2(0, 135), true)
                                        imgui.Columns(2, "xpLocalJobs", false)
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Fixed:")
                                        imgui.BulletText("Craftsman: 20 XP\nMissions: 10 XP\nCarJacker: 10 XP\nGarbage/Chemist: 6 XP"); imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Progressive:")
                                        imgui.BulletText("Trucker: 5 XP\nArms Dealer: 4 XP\nMiner/Courier: 3 XP\nFisherman: 2 XP | Archeologist: 1 XP"); imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), "OTHER METHODS:")
                                    imgui.BeginChild("XPMiscBox", imgui.ImVec2(0, 85), true)
                                        imgui.BulletText("/shop Purchases: 30 XP | Daily Tasks: 3 XP | Sprays (/spray): 1 XP (Max 30/day)")
                                    imgui.EndChild()
                                end

                            elseif sm.id == 7 then -- ROB ATM
                                if iniData.settings.lang == 0 then
                                    imgui.SetWindowFontScale(1.2) 
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - A T M")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("RECOMPENSE FINANCIARE PE SKILL (LA SUCCES)"))
                                    imgui.SetWindowFontScale(1.0) 
                                    
                                    imgui.Columns(3, "robAtmCols", false)
                                    imgui.SetColumnWidth(0, 110)  
                                    imgui.SetColumnWidth(1, 200)
                                    imgui.SetColumnWidth(2, 160) 
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill Rob")) imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Recompensa de Baza")) imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Puncte Skill")) imgui.NextColumn()
                                    imgui.Separator()

                                    local atmData = {
                                        {"Skill 1", "intre $12.500 - $17.500", "+1 punct skill"},
                                        {"Skill 2", "intre $17.500 - $22.500", "+1 punct skill"},
                                        {"Skill 3", "intre $22.500 - $27.500", "+1 punct skill"},
                                        {"Skill 4", "intre $27.500 - $32.500", "+1 punct skill"},
                                        {"Skill 5", "intre $32.500 - $37.500", "Nivel Maxim"}
                                    }
                                    for _, v in ipairs(atmData) do
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                        imgui.Text(u8(v[3])) imgui.NextColumn()
                                    end
                                    imgui.Columns(1)
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.SetWindowFontScale(1.2) 
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("1. CONDITII MINIME & DECLANSARE"))
                                    imgui.BulletText(u8("Nivel minim 7 | Sa nu fii membru PD."))
                                    imgui.BulletText(u8("Minim 10 puncte de jaf (se consuma automat la initiere)."))
                                    imgui.BulletText(u8("Sa NU ai Wanted in acel moment | Licenta de zbor valabila."))
                                    imgui.BulletText(u8("Trebuie sa detii cel putin o bomba creata in inventar."))
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Mecanica de Armare:"))
                                    imgui.TextWrapped(u8("Te apropii de un ATM si foloseste comanda /robatm. Vei primi un SMS de la Comerciantul de Explozibil cu un cod de 10 cifre. Trebuie sa introduci exact codul in interfata grafica (textdraw) pentru a arma bomba."))
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("Reguli de warfare/anulare instant:"))
                                    imgui.TextWrapped(u8("Daca parasesti zona, inchizi interfata, primesti crash sau mori in timp ce bagi codul -> jaful esueaza si primesti Wanted. Cod incorect = Explozie locala cu daune + Wanted."))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("2. COLECTAREA BANILOR SI COOLDOWN"))
                                    imgui.TextWrapped(u8("Dupa ce bomba explodeaza, langa ATM apare un sac personal cu bani. Ai la dispozitie fix 90 de secunde sa il ridici, altfel prada expira si jaful e esuat."))
                                    imgui.BulletText(u8("La ridicarea sacului primesti Wanted automat si porneste evadarea."))
                                    imgui.BulletText(u8("ATM-ul intra in cooldown 180s (este dezactivat pt operatiuni si jafuri)."))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("3. ETAPA DE EVADARE SI ALTITUDINE"))
                                    imgui.TextWrapped(u8("Se va seta un checkpoint de extractie in alt oras. Trebuie sa zbori pana acolo cu un avion sau un elicopter. Cand atingi punctul, esti aruncat automat in aer si primesti o parasuta."))
                                    imgui.Spacing()
                                    imgui.TextWrapped(u8("Urmareste cu mare atentie indicatorul de altitudine pentru deschidere:"))
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("   [X] Mai mare de 500 m -> Prea sus (NU deschide parasuta!)"))
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8("   [V] Intre 350 si 500 m -> PERFECT! (Deschide aici pentru a finaliza cu succes)"))
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("   [X] Mai mic de 350 m -> Prea jos (Prabusire si esec jaful)"))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Bonus la succes: Daca deschizi parasuta corect, Wanted-ul este sters complet. Primesti +7 puncte maraton, +3 EXP clan si +1 punct de skill la Rob."))
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.5), u8("Sumele de bani pot fi marite suplimentar de maratoane active, bonus de nivel sau skinuri posedate."))
                                    imgui.SetWindowFontScale(1.0)
                                else
                                    imgui.SetWindowFontScale(1.2) 
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - A T M")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("FINANCIAL REWARDS BY SKILL (ON SUCCESS)"))
                                    imgui.SetWindowFontScale(1.0) 
                                    
                                    imgui.Columns(3, "robAtmCols", false)
                                    imgui.SetColumnWidth(0, 110)  
                                    imgui.SetColumnWidth(1, 200)
                                    imgui.SetColumnWidth(2, 160) 
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Rob Skill")) imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Base Reward")) imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill Points")) imgui.NextColumn()
                                    imgui.Separator()

                                    local atmData = {
                                        {"Skill 1", "between $12.500 - $17.500", "+1 skill point"},
                                        {"Skill 2", "between $17.500 - $22.500", "+1 skill point"},
                                        {"Skill 3", "between $22.500 - $27.500", "+1 skill point"},
                                        {"Skill 4", "between $27.500 - $32.500", "+1 skill point"},
                                        {"Skill 5", "between $32.500 - $37.500", "Max Level"}
                                    }
                                    for _, v in ipairs(atmData) do
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                        imgui.Text(u8(v[3])) imgui.NextColumn()
                                    end
                                    imgui.Columns(1)
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.SetWindowFontScale(1.2) 
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("1. MINIMUM CONDITIONS & INITIATION"))
                                    imgui.BulletText(u8("Minimum level 7 | Must not be a PD member."))
                                    imgui.BulletText(u8("Minimum 10 rob points (automatically consumed at initiation)."))
                                    imgui.BulletText(u8("Must NOT have Wanted at that moment | Valid flying license."))
                                    imgui.BulletText(u8("You must own at least one crafted bomb in your inventory."))
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Arming Mechanics:"))
                                    imgui.TextWrapped(u8("Approach an ATM and use the /robatm command. You will receive an SMS from the Explosive Dealer with a 10-digit code. You must enter the exact code into the graphical interface (textdraw) to arm the bomb."))
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("Instant Cancellation Rules:"))
                                    imgui.TextWrapped(u8("If you leave the area, close the interface, crash, or die while entering the code -> the rob fails and you receive Wanted. Incorrect code = Local explosion with damage + Wanted."))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("2. COLLECTING MONEY AND COOLDOWN"))
                                    imgui.TextWrapped(u8("After the bomb explodes, a personal bag with money appears near the ATM. You have exactly 90 seconds to pick it up, otherwise the loot expires and the rob fails."))
                                    imgui.BulletText(u8("Upon picking up the bag, you automatically receive Wanted and the escape begins."))
                                    imgui.BulletText(u8("The ATM enters a 180s cooldown (it is disabled for transactions and robberies)."))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("3. ESCAPE STAGE AND ALTITUDE"))
                                    imgui.TextWrapped(u8("An extraction checkpoint will be set in another city. You must fly there using a plane or a helicopter. When you hit the checkpoint, you are automatically thrown into the air and given a parachute."))
                                    imgui.Spacing()
                                    imgui.TextWrapped(u8("Pay close attention to the altitude indicator for deployment:"))
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("   [X] Higher than 500 m -> Too high (DO NOT open the parachute!)"))
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8("   [V] Between 350 and 500 m -> PERFECT! (Open here to successfully complete)"))
                                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8("   [X] Lower than 350 m -> Too low (Crash and rob failure)"))
                                    
                                    imgui.Spacing()
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Success Bonus: If you deploy the parachute correctly, your Wanted is completely cleared. You receive +7 marathon points, +3 clan EXP, and +1 Rob skill point."))
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.5), u8("Money amounts can be further increased by active marathons, level bonuses, or owned skins."))
                                    imgui.SetWindowFontScale(1.0)
                                end

                            elseif sm.id == 8 then -- ROB SOLO
                                if iniData.settings.lang == 0 then
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - S O L O")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("CASTIGURI SI TIMP DISPONIBIL PE SKILL"))
                                    imgui.SetWindowFontScale(1.0)  
                                    imgui.BeginChild("RobSoloEarnings", imgui.ImVec2(0, 165), true)
                                        imgui.Columns(3, "robSoloCols", false)
                                        imgui.SetColumnWidth(0, 100)  
                                        imgui.SetColumnWidth(1, 180)
                                        imgui.SetColumnWidth(2, 160) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Castig Estimativ")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Timp Circuit")) imgui.NextColumn()
                                        imgui.Separator()

                                        local robData = {
                                            {"Skill 1", "intre $25.000 - $35.000", "300 secunde"},
                                            {"Skill 2", "intre $35.000 - $45.000", "310 secunde"},
                                            {"Skill 3", "intre $45.000 - $55.000", "320 secunde"},
                                            {"Skill 4", "intre $55.000 - $65.000", "330 secunde"},
                                            {"Skill 5", "intre $65.000 - $70.000", "340 secunde"}
                                        }
                                        for _, v in ipairs(robData) do
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                            imgui.Text(u8(v[3])) imgui.NextColumn()
                                        end
                                        imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    
                                    imgui.Columns(2, "robInfo", false)    
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("RESURSE & PROCEDURI"))
                                    imgui.BeginChild("RobRequirements", imgui.ImVec2(0, 400), true)  
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Cerinte Jaf (Casa/Biz):"))
                                        imgui.BulletText(u8("Cel putin nivel 7."))
                                        imgui.BulletText(u8("Cel putin 15 puncte de jaf (/robpoints)."))
                                        imgui.BulletText(u8("Cazier curat (fara wanted)."))
                                        imgui.BulletText(u8("Ora serverului: intre 08:00 - 04:00."))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Spargerea Seifului:"))
                                        imgui.TextWrapped(u8("Se foloseste tasta SPACE pentru burghiu. Mentineti burghiul cat mai rece urmarind indicele de temperatura; daca se supraincalzeste, devine ineficient si spargerea dureaza mult mai mult."))
                                    imgui.EndChild()
                                    imgui.NextColumn()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("MINIJOCURI (IN FUNCTIE DE SKILL)"))
                                    imgui.BeginChild("RobMinigames", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 1 - 5: Scurtcircuit (Implicit)"))
                                        imgui.TextWrapped(u8("Directionati sarma cu sagetile dintr-o parte in alta fara a atinge peretii. Atingerea lor reseteaza traseul."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 6 - 7: Taiere SAU Conectare Fire"))
                                        imgui.TextWrapped(u8("- Taiere: Ghiciti si taiati firul corect (rosu/verde/albastru) de 3 ori.\n- Conectare: Uniti culoarea din stanga cu cea corespondenta din dreapta de 3 ori."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 8 - 10: Taiere / Conectare / Voltaj"))
                                        imgui.TextWrapped(u8("- Reglare Voltaj: Cresteti/scadeti voltajul curent pana devine identic cu cel optim (de 3 ori pentru a trece)."))
                                    imgui.EndChild()
                                    imgui.Columns(1)   
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Nota: In incaperea speciala aveti un timp limita sa terminati minijocurile si seiful, altfel jaful va esua."))
                                    imgui.SetWindowFontScale(1.0)
                                else
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - S O L O")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("EARNINGS AND TIME PER SKILL"))
                                    imgui.SetWindowFontScale(1.0)  
                                    imgui.BeginChild("RobSoloEarnings", imgui.ImVec2(0, 165), true)
                                        imgui.Columns(3, "robSoloCols", false)
                                        imgui.SetColumnWidth(0, 100); imgui.SetColumnWidth(1, 180); imgui.SetColumnWidth(2, 160) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Estimated Gain")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Circuit Time")) imgui.NextColumn()
                                        imgui.Separator()

                                        local robData = {
                                            {"Skill 1", "between $25.000 - $35.000", "300 seconds"},
                                            {"Skill 2", "between $35.000 - $45.000", "310 seconds"},
                                            {"Skill 3", "between $45.000 - $55.000", "320 seconds"},
                                            {"Skill 4", "between $55.000 - $65.000", "330 seconds"},
                                            {"Skill 5", "between $65.000 - $70.000", "340 seconds"}
                                        }
                                        for _, v in ipairs(robData) do
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                            imgui.Text(u8(v[3])) imgui.NextColumn()
                                        end
                                        imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    
                                    imgui.Columns(2, "robInfo", false)    
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("RESOURCES & PROCEDURES"))
                                    imgui.BeginChild("RobRequirements", imgui.ImVec2(0, 400), true)  
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Rob Requirements (House/Biz):"))
                                        imgui.BulletText(u8("Minimum level 7."))
                                        imgui.BulletText(u8("Minimum 15 rob points (/robpoints)."))
                                        imgui.BulletText(u8("Clean criminal record (no wanted)."))
                                        imgui.BulletText(u8("Server time: between 08:00 - 04:00."))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Safe Cracking:"))
                                        imgui.TextWrapped(u8("Use the SPACE key for the drill. Keep the drill cool by watching the temperature gauge; if it overheats, it becomes inefficient and breaking takes much longer."))
                                    imgui.EndChild()
                                    imgui.NextColumn()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("MINIGAMES (BY SKILL LEVEL)"))
                                    imgui.BeginChild("RobMinigames", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 1 - 5: Short Circuit (Default)"))
                                        imgui.TextWrapped(u8("Guide the wire from side to side without touching the walls. Touching them resets the path."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 6 - 7: Cut OR Connect Wires"))
                                        imgui.TextWrapped(u8("- Cut: Guess and cut the correct wire (red/green/blue) 3 times.\n- Connect: Match the color on the left with the corresponding one on the right 3 times."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Skill 8 - 10: Cut / Connect / Voltage"))
                                        imgui.TextWrapped(u8("- Voltage Reg: Increase/decrease the current voltage until it matches the optimal one (3 times to pass)."))
                                    imgui.EndChild()
                                    imgui.Columns(1)   
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Note: In the special room you have a time limit to finish the minigames and the safe, otherwise the robbery will fail."))
                                    imgui.SetWindowFontScale(1.0)
                                end

                        elseif sm.id == 9 then -- ROB TEAM
                                if iniData.settings.lang == 0 then
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - T E A M")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("CAPACITATE GRAB SI AVANSARE PE SKILL"))
                                    imgui.SetWindowFontScale(1.0)  
                                    imgui.BeginChild("RobGroupEarnings", imgui.ImVec2(0, 145), true)
                                        imgui.Columns(3, "robGroupCols", false)
                                        imgui.SetColumnWidth(0, 110); imgui.SetColumnWidth(1, 160); imgui.SetColumnWidth(2, 200) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Bijuterii / Grab")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Avansare (Jafuri Necesare)")) imgui.NextColumn()
                                        imgui.Separator()

                                        local robGroupData = {
                                            {"Skill 1", "25 bijuterii", "25 jafuri -> Skill 2"},
                                            {"Skill 2", "30 bijuterii", "50 jafuri -> Skill 3"},
                                            {"Skill 3", "35 bijuterii", "100 jafuri -> Skill 4"},
                                            {"Skill 4", "40 bijuterii", "200 jafuri -> Skill 5"},
                                            {"Skill 5", "45 bijuterii", "Maxim"}
                                        }
                                        for _, v in ipairs(robGroupData) do
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                            imgui.Text(u8(v[3])) imgui.NextColumn()
                                        end
                                        imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    
                                    imgui.Columns(2, "robGroupInfo", false)    
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("RESURSE & PROCES"))
                                    imgui.BeginChild("RobGroupReqs", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Resurse Necesare:"))
                                        imgui.BulletText(u8("Echipa de minim 4 si maxim 8 membri."))
                                        imgui.BulletText(u8("Fiecare membru: minim nivel 7 & 10 robpoints."))
                                        imgui.BulletText(u8("Cel putin un membru trebuie sa aiba licenta de pilot."))
                                        imgui.BulletText(u8("Cazier curat (fara wanted) pentru toti membrii."))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Procesul de Jaf:"))
                                        imgui.TextWrapped(u8("Liderul alege 1 din 21 locatii prin /rob (Next Step). Se deblocheaza chat-ul /rc. Liderul atribuie cele 4 roluri. Dupa indeplinirea misiunilor rolurilor, se intra in magazin."))
                                        imgui.Spacing()
                                        imgui.TextWrapped(u8("In magazin sunt 15 mese a cate 40 bijuterii (Total: 600 bijuterii)."))
                                    imgui.EndChild()
                                    imgui.NextColumn()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("COMENZI SPECIFICE"))
                                    imgui.BeginChild("RobGroupCmds", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/rob")
                                        imgui.TextWrapped(u8("Meniul principal al jafului, gestionare membri, invitatii (max 8) si pornire."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/robbers")
                                        imgui.TextWrapped(u8("Lista de cautare echipa. Interzis pt: PD, < Lvl 7, wanted, < 10 puncte jaf sau deja in echipa."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/accept rob [id] | /cancel rob")
                                        imgui.TextWrapped(u8("Accepta invitatia / Anuleaza jaful (lider) sau paraseste echipa (membru)."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/grab | /drop | /rc")
                                        imgui.TextWrapped(u8("/grab: Fura bijuterii de la mese.\n/drop: Depoziteaza bijuteriile in vehicul.\n/rc: Chatul echipei de jaf."))
                                    imgui.EndChild()
                                    imgui.Columns(1)   
                                    imgui.Separator()
                                    imgui.SetWindowFontScale(1.2) 
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Formula Castig: [ (Bijuterii Furate * 626) - 20000 ] / Numar Membri"))
                                    imgui.SetWindowFontScale(1.0) 
                                else
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - T E A M")
                                    imgui.Separator()
                                    imgui.Spacing()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("GRAB CAPACITY AND SKILL PROGRESS"))
                                    imgui.SetWindowFontScale(1.0)  
                                    imgui.BeginChild("RobGroupEarnings", imgui.ImVec2(0, 145), true)
                                        imgui.Columns(3, "robGroupCols", false)
                                        imgui.SetColumnWidth(0, 110); imgui.SetColumnWidth(1, 160); imgui.SetColumnWidth(2, 200) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Skill")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Jewels / Grab")) imgui.NextColumn()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Progression (Required Robs)")) imgui.NextColumn()
                                        imgui.Separator()

                                        local robGroupData = {
                                            {"Skill 1", "25 jewels", "25 robs -> Skill 2"},
                                            {"Skill 2", "30 jewels", "50 robs -> Skill 3"},
                                            {"Skill 3", "35 jewels", "100 robs -> Skill 4"},
                                            {"Skill 4", "40 jewels", "200 robs -> Skill 5"},
                                            {"Skill 5", "45 jewels", "Maximum"}
                                        }
                                        for _, v in ipairs(robGroupData) do
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8(v[1])) imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8(v[2])) imgui.NextColumn()
                                            imgui.Text(u8(v[3])) imgui.NextColumn()
                                        end
                                        imgui.Columns(1)
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    
                                    imgui.Columns(2, "robGroupInfo", false)    
                                    imgui.SetWindowFontScale(1.2)  
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("RESOURCES & PROCESS"))
                                    imgui.BeginChild("RobGroupReqs", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Required Resources:"))
                                        imgui.BulletText(u8("Team of at least 4 and max 8 members."))
                                        imgui.BulletText(u8("Each member: min level 7 & 10 robpoints."))
                                        imgui.BulletText(u8("At least one member must have a pilot license."))
                                        imgui.BulletText(u8("Clean criminal record for all members."))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), u8("Robbery Process:"))
                                        imgui.TextWrapped(u8("The leader chooses 1 of 21 locations via /rob. /rc chat unlocks. The leader assigns 4 roles. After completing role missions, enter the store."))
                                        imgui.Spacing()
                                        imgui.TextWrapped(u8("There are 15 tables with 40 jewels each inside (Total: 600 jewels)."))
                                    imgui.EndChild()
                                    imgui.NextColumn()
                                    
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("SPECIFIC COMMANDS"))
                                    imgui.BeginChild("RobGroupCmds", imgui.ImVec2(0, 400), true) 
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/rob")
                                        imgui.TextWrapped(u8("Main robbery menu, member management, invites (max 8) and start."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/robbers")
                                        imgui.TextWrapped(u8("Team search list. Forbidden for: PD, < Lvl 7, wanted, < 10 rob points or already in a team."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/accept rob [id] | /cancel rob")
                                        imgui.TextWrapped(u8("Accept invite / Cancel robbery (leader) or leave team (member)."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/grab | /drop | /rc")
                                        imgui.TextWrapped(u8("/grab: Steal jewels from tables.\n/drop: Store jewels in vehicle.\n/rc: Robbery team chat."))
                                    imgui.EndChild()
                                    imgui.Columns(1)   
                                    imgui.Separator()
                                    imgui.SetWindowFontScale(1.2) 
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), u8("Earnings Formula: [ (Jewels Stolen * 626) - 20000 ] / Number of Members"))
                                    imgui.SetWindowFontScale(1.0) 
                                end

                            elseif sm.id == 10 then -- ESCAPE
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.0, 1.0), "--- ESCAPE ---")
                                    imgui.Separator()
                                    imgui.BeginChild("EscapeLocalBox", imgui.ImVec2(0, 220), true)
                                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), u8("CONDITII SI SPARGERE GARD:"))
                                        imgui.BulletText(u8("Minim 20 puncte evadare, grup max 6 oameni, timp jail > 500s."))
                                        imgui.BulletText(u8("/escape (formare grup) -> mergi la gard -> /hit pentru a lovi."))
                                        imgui.TextWrapped(u8("Fiecare /hit alerteaza politistii pe o raza de 15 metri. Gardul are HP limitat."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), u8("CONSECINTE:"))
                                        imgui.TextWrapped(u8("Primiti Wanted 6 fara drept, marcat pe harta. Alt jucator poate folosi /snitch pe tine pentru o reducere a pedepsei sale."))
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.0, 1.0), "--- ESCAPE ---")
                                    imgui.Separator()
                                    imgui.BeginChild("EscapeLocalBox", imgui.ImVec2(0, 220), true)
                                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), u8("CONDITIONS AND FENCE BREACHING:"))
                                        imgui.BulletText(u8("Minimum 20 escape points, max group size 6, jail time > 500s."))
                                        imgui.BulletText(u8("/escape (form group) -> go to the fence -> /hit to strike."))
                                        imgui.TextWrapped(u8("Each /hit alerts cops within a 15-meter radius. The fence has limited HP."))
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), u8("CONSEQUENCES:"))
                                        imgui.TextWrapped(u8("You receive Wanted 6 without right, marked on map. Another player can use /snitch on you for a reduction of their sentence."))
                                    imgui.EndChild()
                                end

                            elseif sm.id == 11 then -- JAIL
                            local isRO = (iniData.settings.lang == 0)
                            local titleColor = imgui.ImVec4(0.9, 0.2, 0.2, 1.0)
                            local sectionColor = imgui.ImVec4(1.0, 0.8, 0.0, 1.0)
                            local highlight = imgui.ImVec4(0.0, 1.0, 1.0, 1.0)

                            imgui.TextColored(titleColor, isRO and "--- INFORMATII INCHISOARE ---" or "--- PRISON INFORMATION ---")
                            imgui.Separator()
                            imgui.BeginChild("JailMainBox", imgui.ImVec2(0, 0), true)

                                -- Informatii Reguli
                                imgui.TextColored(sectionColor, isRO and "REGULI SI FUNCTIONARE" or "RULES AND OPERATIONS")
                                imgui.Indent()
                                    imgui.TextWrapped(isRO and "Celulele se deschid la fix si la jumatate (08:00-02:00) pentru 10 min. Kill-ul in jail adauga 2 min la pedeapsa." or "Cells open on the hour and half-hour (08:00-02:00) for 10 min. Killing in jail adds 2 mins to sentence.")
                                    imgui.BulletText(isRO and "[/surrender] - Predare automata daca nu e politist." or "[/surrender] - Auto-surrender if no police online.")
                                    imgui.BulletText(isRO and "Puncte: +1 evadare/PayDay real." or "Points: +1 escape point/real PayDay.")
                                imgui.Unindent()
                                imgui.Spacing()

                                -- Tabel Detaliat
                                imgui.TextColored(sectionColor, isRO and "STATISTICI WANTED - FULL" or "WANTED STATISTICS - FULL")
                                imgui.Separator()

                                imgui.Columns(5, "jail_full_table", true)
                                imgui.SetColumnWidth(0, 65); imgui.Text("Wanted"); imgui.NextColumn()
                                imgui.SetColumnWidth(1, 95); imgui.Text(isRO and "Timp (C/F)" or "Time (W/O)"); imgui.NextColumn()
                                imgui.SetColumnWidth(2, 70); imgui.Text(isRO and "Arestat" or "Arrested"); imgui.NextColumn()
                                imgui.SetColumnWidth(3, 70); imgui.Text(isRO and "Omorat" or "Killed"); imgui.NextColumn()
                                imgui.Text(isRO and "Cautiune" or "Bail"); imgui.NextColumn()
                                imgui.Separator()

                                local times = {"240/500 sec.", "480/1000 sec.", "600/1500 sec.", "840/2000 sec.", "960/2500 sec.", "1080/3000 sec."}
                                local arrested = {"$800", "$1.500", "$2.500", "$4.000", "$6.000", "$7.000"}
                                local killed = {"$1.340", "$2.640", "$3.940", "$5.240", "$6.540", "$7.840"}
                                local bail = {"$4.000", "$6.500", "$8.000", "$11.000", "$13.500", "$15.000"}

                                for i = 1, 6 do
                                    imgui.TextColored(highlight, "Wanted "..i); imgui.NextColumn()
                                    imgui.Text(times[i]); imgui.NextColumn()
                                    imgui.Text(arrested[i]); imgui.NextColumn()
                                    imgui.Text(killed[i]); imgui.NextColumn()
                                    imgui.Text(bail[i]); imgui.NextColumn()
                                end
                                imgui.Columns(1)
                                
                                imgui.Separator()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1.0), isRO and "* Nota: Banii de cautiune trebuie sa fie in mana (cash)." or "* Note: Bail money must be in hand (cash).")

                            imgui.EndChild()
                        
                            elseif sm.id == 12 then -- SKINURI FACTIUNI
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0.0, 0.6, 1.0, 1.0), "--- SKINURI FACTIUNI SI MODELE ---")
                                    imgui.Separator()
                                    imgui.BeginChild("FactionSkinsBox", imgui.ImVec2(0, 700), true)
                                        imgui.TextColored(imgui.ImVec4(0.2, 0.4, 1.0, 1.0), u8("DEPARTAMENTE (POLITIE / FBI / NG)")) 
                                        imgui.Bullet(); imgui.Text(u8("Police (LSPD/LVPD/SFPD):"))
                                        imgui.TextDisabled(u8("  Rank 1: ID 71 (wmysgrd) | Rank 2: ID 284/280 (lapdm1/lapd1)\n  Rank 3: ID 281/282 (sfpd1/lvpd1) | Rank 4: ID 266 (pulaski)\n  Rank 5: ID 283/288 (csher/dsher) | Rank 6: ID 267/265 (Hernandez/tenpen)"))
                                        imgui.Spacing()
                                        imgui.Bullet(); imgui.Text(u8("F.B.I & National Guard:")) 
                                        imgui.TextDisabled(u8("  FBI: ID 163 (Rank 1), 164 (Rank 2), 166 (Rank 3/4), 286 (Rank 5), 295 (Rank 6)\n  NG: ID 285 (Rank 1-3), 287 (Rank 4/5), 179 (Rank 6)"))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("FACTIUNI PASNICE"))   
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(1.0, 0.6, 0.6, 1.0), u8("Paramedics:")) 
                                        imgui.TextDisabled(u8("  Rank 1-2: ID 276, 275 | Rank 3-4: ID 277-279, 274 | Fata: ID 150")) 
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.4, 1.0), u8("Taxi (LS/LV/SF):")) 
                                        imgui.TextDisabled(u8("  Rank 1-3: ID 255 | Rank 4-5: ID 253 | Rank 6: ID 61 | Fata: ID 219")) 
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), u8("Instructors:")) 
                                        imgui.TextDisabled(u8("  Rank 1: ID 153 | Rank 2-3: ID 60 | Rank 4-5: ID 240 | Rank 6: ID 171"))
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.8, 0.6, 1.0, 1.0), u8("News Reporters:")) 
                                        imgui.TextDisabled(u8("  Rank 1-3: ID 188, 17 | Rank 4-6: ID 187, 147 | Fata: ID 191")) 
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                                        imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), u8("MAFII SI GANG-URI"))
                                        imgui.BeginChild("MafiiGrid", imgui.ImVec2(0, 310), true)
                                            imgui.Columns(4, "mafiiCols", true)
                                            imgui.TextColored(imgui.ImVec4(0.2, 0.67, 0.2, 1.0), "G.S. Bloods"); imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0.4, 0.4, 0.4, 1.0), "Verdant Fam"); imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0.54, 0.63, 0.62, 1.0), "Viet Boys"); imgui.NextColumn()
                                            imgui.TextColored(imgui.ImVec4(0.58, 0.38, 0.25, 1.0), "Tsar Bratva"); imgui.NextColumn()
                                            imgui.Separator() 
                                            imgui.Text(u8("R1: 106\nR2: 271\nR4: 269\nR6: 270\nF: 195")); imgui.NextColumn()
                                            imgui.Text(u8("R1-5: 124\nR1-5: 125\nR1-5: 127\nR6: 126\nF: 12")); imgui.NextColumn()
                                            imgui.Text(u8("R1-2: 122\nR3: 121\nR4: 123\nR6: 223\nF: 226")); imgui.NextColumn()
                                            imgui.Text(u8("R1: 272\nR2: 111\nR3-5: 112\nR6: 113")); imgui.NextColumn()
                                            imgui.Separator()
                                        imgui.EndChild()
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                                        imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1.0), "HITMAN / SOA")
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.8, 0.2, 0.2, 1.0), u8("Hitman Agency:")) 
                                        imgui.TextDisabled(u8("  Rank 1: ID 186 | Rank 2-3: ID 208 | Rank 4-6: ID 294")) 
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.2, 0.4, 0.2, 1.0), u8("Sons of Anarchy:")) 
                                        imgui.TextDisabled(u8("  Rank 1: ID 241 | Rank 2: ID 133 | Rank 4-5: ID 181 | Rank 6: ID 100"))
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(0.0, 0.6, 1.0, 1.0), "--- FACTION SKINS AND MODELS ---")
                                    imgui.Separator()
                                    imgui.BeginChild("FactionSkinsBox", imgui.ImVec2(0, 700), true)
                                        imgui.TextColored(imgui.ImVec4(0.2, 0.4, 1.0, 1.0), u8("DEPARTMENTS (POLICE / FBI / NG)")) 
                                        imgui.Bullet(); imgui.Text(u8("Police (LSPD/LVPD/SFPD):"))
                                        imgui.TextDisabled(u8("  Rank 1: ID 71 | Rank 2: ID 284/280\n  Rank 3: ID 281/282 | Rank 4: ID 266\n  Rank 5: ID 283/288 | Rank 6: ID 267/265"))
                                        imgui.Spacing()
                                        imgui.Bullet(); imgui.Text(u8("F.B.I & National Guard:")) 
                                        imgui.TextDisabled(u8("  FBI: ID 163 (R1), 164 (R2), 166 (R3/4), 286 (R5), 295 (R6)\n  NG: ID 285 (R1-3), 287 (R4/5), 179 (R6)"))
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("PACIFIST FACTIONS"))   
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(1.0, 0.6, 0.6, 1.0), u8("Paramedics:")) 
                                        imgui.TextDisabled(u8("  Rank 1-2: ID 276, 275 | Rank 3-4: ID 277-279, 274 | Female: ID 150")) 
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.4, 1.0), u8("Taxi (LS/LV/SF):")) 
                                        imgui.TextDisabled(u8("  Rank 1-3: ID 255 | Rank 4-5: ID 253 | Rank 6: ID 61 | Female: ID 219")) 
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), u8("Instructors:")) 
                                        imgui.TextDisabled(u8("  Rank 1: ID 153 | Rank 2-3: ID 60 | Rank 4-5: ID 240 | Rank 6: ID 171"))
                                        imgui.Bullet(); imgui.TextColored(imgui.ImVec4(0.8, 0.6, 1.0, 1.0), u8("News Reporters:")) 
                                        imgui.TextDisabled(u8("  Rank 1-3: ID 188, 17 | Rank 4-6: ID 187, 147 | Female: ID 191")) 
                                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                                        imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), u8("MAFIAS AND GANGS"))
                                        imgui.BeginChild("MafiiGrid", imgui.ImVec2(0, 310), true)
                                            imgui.Columns(4, "mafiiCols", true)
                                            imgui.Text("G.S. Bloods"); imgui.NextColumn()
                                            imgui.Text("Verdant Fam"); imgui.NextColumn()
                                            imgui.Text("Viet Boys"); imgui.NextColumn()
                                            imgui.Text("Tsar Bratva"); imgui.NextColumn()
                                            imgui.Separator() 
                                            imgui.Text(u8("R1: 106\nR2: 271\nR4: 269\nR6: 270\nF: 195")); imgui.NextColumn()
                                            imgui.Text(u8("R1-5: 124\nR1-5: 125\nR1-5: 127\nR6: 126\nF: 12")); imgui.NextColumn()
                                            imgui.Text(u8("R1-2: 122\nR3: 121\nR4: 123\nR6: 223\nF: 226")); imgui.NextColumn()
                                            imgui.Text(u8("R1: 272\nR2: 111\nR3-5: 112\nR6: 113")); imgui.NextColumn()
                                            imgui.Separator()
                                        imgui.EndChild()
                                    imgui.EndChild()
                                end

                            elseif sm.id == 13 then -- LICENTE
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), "--- SISTEMUL DE LICENTE ---")
                                    imgui.Separator()
                                    imgui.BeginChild("LicensesMainBox", imgui.ImVec2(0, 650), true)
                                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), u8("INFO GENERAL SI OBTINERE"))   
                                        imgui.BeginChild("LicenteObtinereBox", imgui.ImVec2(0, 95), true)
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Tipuri:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("Zbor, Navigatie, Pescuit, Materiale (Lvl 1), Port-Arma (Lvl 5)."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Obtinere:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("[/needlicense] (instructor) sau NPC la HQ S.I. (cost x5)."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Valabilitate:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("100 ore. Scade cu 1h la PayDay (inclusiv pe /sleep)."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.4, 1.0), u8("SUSPENDARE PERMIS (ROADS)"))  
                                        imgui.BeginChild("LicenteRoadsBox", imgui.ImVec2(0, 150), true)
                                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("Confiscare permis pentru 1 ORA:"))
                                            imgui.BulletText(u8("NOS, Hidraulice, Contrasens, Alcool (3.0), Parcare neregulamentara."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("Confiscare dupa VITEZA:"))
                                            imgui.BulletText(u8("Oras (lim. 100): 150-199 km/h (1h) | 200+ km/h (2h)."))
                                            imgui.BulletText(u8("Afara (lim. 130): 180-229 km/h (1h) | Autostrada (lim. 160): 210+ km/h (1h)."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(0.6, 0.4, 1.0, 1.0), u8("COSTURI LICENTE (INSTRUCTOR)"))
                                        imgui.BeginChild("LicenteCostBox", imgui.ImVec2(0, 175), true)
                                            imgui.Columns(4, "costCols", true)
                                            imgui.Text(u8("Tip")); imgui.NextColumn(); imgui.Text(u8("Lvl 1-9")); imgui.NextColumn(); imgui.Text(u8("Lvl 10-49")); imgui.NextColumn(); imgui.Text(u8("Lvl 50+")); imgui.NextColumn()
                                            imgui.Separator()
                                            local data = {{"Pescar", "$250", "$500", "$1.000"}, {"Materiale", "$800", "$1.600", "$3.200"}, {"Navigatie", "$850", "$1.700", "$3.400"}, {"Zbor", "$900", "$1.800", "$3.600"}, {"Arme", "$1.000", "$2.000", "$4.000"}}
                                            for _, v in ipairs(data) do imgui.Text(u8(v[1])); imgui.NextColumn(); imgui.Text(v[2]); imgui.NextColumn(); imgui.Text(v[3]); imgui.NextColumn(); imgui.Text(v[4]); imgui.NextColumn() end
                                            imgui.Separator()
                                            imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("TOTAL")); imgui.NextColumn(); imgui.Text("$3.800"); imgui.NextColumn(); imgui.Text("$7.600"); imgui.NextColumn(); imgui.Text("$15.200"); imgui.Columns(1)
                                        imgui.EndChild()
                                        imgui.Spacing(); imgui.Separator()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Preturile la NPC sunt de 5 ori (x5) mai mari decat cele de mai sus."))
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), "--- LICENSE SYSTEM ---")
                                    imgui.Separator()
                                    imgui.BeginChild("LicensesMainBox", imgui.ImVec2(0, 650), true)
                                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), u8("GENERAL INFO & OBTAINING"))   
                                        imgui.BeginChild("LicenteObtinereBox", imgui.ImVec2(0, 95), true)
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Types:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("Flying, Sailing, Fishing, Materials (Lvl 1), Gun License (Lvl 5)."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Obtaining:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("[/needlicense] (instructor) or NPC at S.I. HQ (x5 cost)."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("> Validity:")); imgui.SameLine()
                                            imgui.TextWrapped(u8("100 hours. Decreases by 1h each PayDay (including on /sleep)."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.4, 1.0), u8("LICENSE SUSPENSION (ROADS)"))  
                                        imgui.BeginChild("LicenteRoadsBox", imgui.ImVec2(0, 150), true)
                                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("License confiscation for 1 HOUR:"))
                                            imgui.BulletText(u8("NOS, Hydraulics, Wrong way, Alcohol (3.0), Illegal parking."))
                                            imgui.Spacing()
                                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("Confiscation for SPEEDING:"))
                                            imgui.BulletText(u8("City (lim. 100): 150-199 km/h (1h) | 200+ km/h (2h)."))
                                            imgui.BulletText(u8("Outside (lim. 130): 180-229 km/h (1h) | Highway (lim. 160): 210+ km/h (1h)."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(imgui.ImVec4(0.6, 0.4, 1.0, 1.0), u8("LICENSE COSTS (INSTRUCTOR)"))
                                        imgui.BeginChild("LicenteCostBox", imgui.ImVec2(0, 175), true)
                                            imgui.Columns(4, "costCols", true)
                                            imgui.Text(u8("Type")); imgui.NextColumn(); imgui.Text(u8("Lvl 1-9")); imgui.NextColumn(); imgui.Text(u8("Lvl 10-49")); imgui.NextColumn(); imgui.Text(u8("Lvl 50+")); imgui.NextColumn()
                                            imgui.Separator()
                                            local data = {{"Fishing", "$250", "$500", "$1.000"}, {"Materials", "$800", "$1.600", "$3.200"}, {"Sailing", "$850", "$1.700", "$3.400"}, {"Flying", "$900", "$1.800", "$3.600"}, {"Gun", "$1.000", "$2.000", "$4.000"}}
                                            for _, v in ipairs(data) do imgui.Text(u8(v[1])); imgui.NextColumn(); imgui.Text(v[2]); imgui.NextColumn(); imgui.Text(v[3]); imgui.NextColumn(); imgui.Text(v[4]); imgui.NextColumn() end
                                            imgui.Separator()
                                            imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("TOTAL")); imgui.NextColumn(); imgui.Text("$3.800"); imgui.NextColumn(); imgui.Text("$7.600"); imgui.NextColumn(); imgui.Text("$15.200"); imgui.Columns(1)
                                        imgui.EndChild()
                                        imgui.Spacing(); imgui.Separator()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Tip: NPC prices are 5 times (x5) higher than the ones above."))
                                    imgui.EndChild()
                                end

                            elseif sm.id == 14 then -- NIVELURI MINIME
                                imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "--- NIVELURI MINIME ---")
                                imgui.Separator()
                                imgui.BeginChild("NivelsMainBox", imgui.ImVec2(0, 540), true)

                                local function renderSampStyleText(text)
                                    local pos = 1
                                    while pos <= #text do
                                        local start, stop, color = text:find("{(%x%x%x%x%x%x)}", pos)
                                        if start then
                                            if start > pos then
                                                imgui.TextUnformatted(text:sub(pos, start - 1))
                                                imgui.SameLine(0, 0)
                                            end
                                            local r = tonumber(color:sub(1, 2), 16) / 255
                                            local g = tonumber(color:sub(3, 4), 16) / 255
                                            local b = tonumber(color:sub(5, 6), 16) / 255
                                            imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(r, g, b, 1.0))
                                            pos = stop + 1
                                            local next_start = text:find("{%x%x%x%x%x%x}", pos)
                                            local segment = text:sub(pos, (next_start or #text + 1) - 1)
                                            imgui.TextUnformatted(segment)
                                            if next_start then imgui.SameLine(0, 0) end
                                            imgui.PopStyleColor()
                                            pos = next_start or #text + 1
                                        else
                                            imgui.TextUnformatted(text:sub(pos))
                                            break
                                        end
                                    end
                                end
                                if iniData.settings.lang == 0 then
                                    -- ROMANA
                                    imgui.TextColored(imgui.ImVec4(0.4, 0.4, 1.0, 1.0), u8("SOCIAL SI JOCURI DE NOROC"))
                                    imgui.BeginChild("NiveliSocialBox", imgui.ImVec2(0, 140), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/barbut - nivel minim {44A564}1{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/spin - nivel minim {44A564}1{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Poker - nivel minim {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/ad - nivel minim {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/w - nivel minim {44A564}3{FFFFFF}."))
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("ECONOMIE"))
                                    imgui.BeginChild("NiveliEconBox", imgui.ImVec2(0, 120), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/trade - nivel minim {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/transfer - nivel minim {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}A cumpara un vehicul personal - nivel minim {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}A vinde masina de la tutorial - nivel minim {44A564}5{FFFFFF}."))
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("ACTIVITATI SPECIALE"))
                                    imgui.BeginChild("NiveliIlegalBox", imgui.ImVec2(0, 120), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/rob - nivel minim {44A564}7{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/escape - nivel minim {44A564}7{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/requestevent - nivel minim {44A564}10{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Cumparare bunker - nivel minim {44A564}10{FFFFFF}."))
                                    imgui.EndChild()
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Cresterea in nivel se face automat prin acumularea orelor jucate (PayDay)."))
                                else
                                    -- ENGLISH
                                    imgui.TextColored(imgui.ImVec4(0.4, 0.4, 1.0, 1.0), u8("SOCIAL AND GAMBLING"))
                                    imgui.BeginChild("NiveliSocialBox", imgui.ImVec2(0, 140), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/dice - min level {44A564}1{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/spin - min level {44A564}1{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Poker - min level {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/ad - min level {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/w - min level {44A564}3{FFFFFF}."))
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), u8("ECONOMY"))
                                    imgui.BeginChild("NiveliEconBox", imgui.ImVec2(0, 120), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/trade - min level {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/transfer - min level {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Buy personal vehicle - min level {44A564}3{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Sell tutorial car - min level {44A564}5{FFFFFF}."))
                                    imgui.EndChild()
                                    
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), u8("SPECIAL ACTIVITIES"))
                                    imgui.BeginChild("NiveliIlegalBox", imgui.ImVec2(0, 120), true)
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/rob - min level {44A564}7{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/escape - min level {44A564}7{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}/requestevent - min level {44A564}10{FFFFFF}."))
                                        imgui.Bullet(); imgui.SameLine(); renderSampStyleText(u8("{FFFFFF}Buy bunker - min level {44A564}10{FFFFFF}."))
                                    imgui.EndChild()
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Tip: Leveling up is done automatically by accumulating playtime (PayDay)."))
                                end
                                imgui.EndChild()

                            elseif sm.id == 15 then -- REFERRAL
                                local whiteColor  = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                                local yellowColor = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                                local greenColor  = imgui.ImVec4(0.27, 0.65, 0.39, 1.0)

                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(yellowColor, u8("--- SISTEMUL DE REFERRAL ---"))
                                    imgui.Separator()
                                    imgui.BeginChild("ReferralMainBox", imgui.ImVec2(0, 540), true)
                                        imgui.TextColored(yellowColor, u8("INFO GENERAL"))
                                        imgui.BeginChild("RefGeneralBox", imgui.ImVec2(0, 85), true)
                                            imgui.TextWrapped(u8("Sistemul de referral este o modalitate prin care poti castiga bonusuri invitandu-ti prietenii la joc."))
                                            imgui.Spacing()
                                            imgui.TextWrapped(u8("Acest sistem te va ajuta sa cresti mai repede in nivel si sa castigi bani mai usor."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(yellowColor, u8("CALCUL BONUSURI (/buylevel)"))
                                        imgui.BeginChild("RefRewardsBox", imgui.ImVec2(0, 100), true)
                                            imgui.TextColored(whiteColor, u8("Vei primi bonusuri cand prietenii tai cumpara nivel:"))
                                            imgui.Spacing()
                                            imgui.PushStyleColor(imgui.Col.Text, greenColor); imgui.TextUnformatted("10"); imgui.PopStyleColor()
                                            imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> din punctele de respect (RP) ale prietenului."))
                                            imgui.Spacing()
                                            imgui.PushStyleColor(imgui.Col.Text, greenColor); imgui.TextUnformatted("100"); imgui.PopStyleColor()
                                            imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> din suma de bani platita de prieten."))
                                        imgui.EndChild()
                                        imgui.TextColored(yellowColor, u8("COMENZI DISPONIBILE"))
                                        imgui.BeginChild("RefCmdsBox", imgui.ImVec2(0, 65), true)
                                            imgui.TextColored(greenColor, "/referrals"); imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> Vezi lista referralilor online."))
                                        imgui.EndChild()
                                        imgui.Spacing(); imgui.Separator()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Codul tau de referral este ID-ul tau de cont (vezi pe /stats)."))
                                    imgui.EndChild()
                                else
                                    imgui.TextColored(yellowColor, u8("--- REFERRAL SYSTEM ---"))
                                    imgui.Separator()
                                    imgui.BeginChild("ReferralMainBox", imgui.ImVec2(0, 540), true)
                                        imgui.TextColored(yellowColor, u8("GENERAL INFO"))
                                        imgui.BeginChild("RefGeneralBox", imgui.ImVec2(0, 85), true)
                                            imgui.TextWrapped(u8("The referral system is a way to earn bonuses by inviting your friends to the game."))
                                            imgui.Spacing()
                                            imgui.TextWrapped(u8("This system will help you level up faster and earn money more easily."))
                                        imgui.EndChild()
                                        imgui.Spacing()
                                        imgui.TextColored(yellowColor, u8("BONUS CALCULATION (/buylevel)"))
                                        imgui.BeginChild("RefRewardsBox", imgui.ImVec2(0, 100), true)
                                            imgui.TextColored(whiteColor, u8("You will receive bonuses when your friends buy levels:"))
                                            imgui.Spacing()
                                            imgui.PushStyleColor(imgui.Col.Text, greenColor); imgui.TextUnformatted("10'/."); imgui.PopStyleColor()
                                            imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> of the friend's respect points (RP)."))
                                            imgui.Spacing()
                                            imgui.PushStyleColor(imgui.Col.Text, greenColor); imgui.TextUnformatted("100'/."); imgui.PopStyleColor()
                                            imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> of the money amount paid by the friend."))
                                        imgui.EndChild()
                                        imgui.TextColored(yellowColor, u8("AVAILABLE COMMANDS"))
                                        imgui.BeginChild("RefCmdsBox", imgui.ImVec2(0, 65), true)
                                            imgui.TextColored(greenColor, "/referrals"); imgui.SameLine(); imgui.TextColored(whiteColor, u8(" -> View list of online referrals."))
                                        imgui.EndChild()
                                        imgui.Spacing(); imgui.Separator()
                                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Tip: Your referral code is your account ID (see /stats)."))
                                    imgui.EndChild()
                                end                                

                            elseif sm.id == 16 then -- SAFEBOX
                            local whiteColor  = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                            local yellowColor = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                            local greenColor  = imgui.ImVec4(0.27, 0.65, 0.39, 1.0)
                            local grayColor   = imgui.ImVec4(0.6, 0.6, 0.6, 1.0)
                            imgui.BeginChild("SafeboxMainBox", imgui.ImVec2(0, 650), true)
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(yellowColor, u8("--- SISTEMUL DE SAFEBOX ---"))
                                    imgui.Separator()
                                    imgui.TextColored(yellowColor, u8("ACHIZITIE SI ADMINISTRARE"))
                                    imgui.BeginChild("SBGeneralBox", imgui.ImVec2(0, 120), true)
                                        imgui.BulletText(u8("Pret: 600 Gold in [/shop]."))
                                        imgui.BulletText(u8("Limita: Poti detine pana la 50 de Safebox-uri."))
                                        imgui.BulletText(u8("Gestiune: Foloseste [/safeboxes] sau [/sb] pentru lista."))
                                        imgui.BulletText(u8("Actiuni: Amplasare, stergere, localizare sau modificare pozitie."))
                                        imgui.TextColored(grayColor, u8(" * Nota: Se pot spawnat doar in lumea virtuala 0 (exterior)."))
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(yellowColor, u8("UTILIZARE SI OPERATIUNI"))
                                    imgui.BeginChild("SBOpsBox", imgui.ImVec2(0, 145), true)
                                        imgui.TextColored(greenColor, "[/opensafe]"); imgui.SameLine(); imgui.TextColored(whiteColor, u8(" (sau F/ENTER) -> Deschide seiful."))
                                        imgui.BulletText(u8("Redenumire: Click pe titlu (maxim 30 caractere)."))
                                        imgui.BulletText(u8("Depozitare: Meniul din dreapta (arme, materiale, droguri)."))
                                        imgui.BulletText(u8("Extragere: Click pe numele elementului dorit."))
                                        imgui.BulletText(u8("Functia 'throw': Tasteaza 'throw' pentru a goli un slot blocat."))
                                        imgui.TextColored(grayColor, u8(" * Exemplu: Scapi de Tec-9/Sniper daca nu mai ai factiunea."))
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(yellowColor, u8("CONSUM UNITATI (DUPA SKILL ARMS DEALER)"))
                                    imgui.BeginChild("SBCalcBox", imgui.ImVec2(0, 185), true)
                                        imgui.Columns(2, "sbTableCols", true); imgui.SetColumnWidth(0, 180)
                                        imgui.TextColored(greenColor, u8("Arma")); imgui.NextColumn(); imgui.TextColored(greenColor, u8("Unitati (S1 -> S5)")); imgui.NextColumn()
                                        imgui.Separator()
                                        imgui.Text(u8("Deagle / SD Pistol")); imgui.NextColumn(); imgui.Text("30 / 26 / 22 / 18 / 14"); imgui.NextColumn()
                                        imgui.Text(u8("Combat / Shotgun")); imgui.NextColumn(); imgui.Text("40 / 35 / 30 / 25 / 20"); imgui.NextColumn()
                                        imgui.Text(u8("MP5 / TEC-9")); imgui.NextColumn(); imgui.Text("15 / 14 / 13 / 12 / 11"); imgui.NextColumn()
                                        imgui.Text(u8("M4 / AK-47")); imgui.NextColumn(); imgui.Text("24 / 23 / 22 / 21 / 20"); imgui.NextColumn()
                                        imgui.Text(u8("Rifle / Sniper")); imgui.NextColumn(); imgui.Text("350 / 338 / 325 / 313 / 300"); imgui.Columns(1)
                                        imgui.Separator()
                                        imgui.Text(u8("Materiale / Droguri: 1 unitate per bucata."))
                                    imgui.EndChild()
                                    imgui.Spacing(); imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Mafiotii pot folosi seifurile la war daca sunt spawnate inainte de incepere."))
                                else
                                    imgui.TextColored(yellowColor, u8("--- SAFEBOX SYSTEM ---"))
                                    imgui.Separator()
                                    imgui.TextColored(yellowColor, u8("ACQUISITION AND ADMINISTRATION"))
                                    imgui.BeginChild("SBGeneralBox", imgui.ImVec2(0, 120), true)
                                        imgui.BulletText(u8("Price: 600 Gold in [/shop]."))
                                        imgui.BulletText(u8("Limit: You can own up to 50 Safeboxes."))
                                        imgui.BulletText(u8("Management: Use [/safeboxes] or [/sb] for the list."))
                                        imgui.BulletText(u8("Actions: Place, delete, locate or modify position."))
                                        imgui.TextColored(grayColor, u8(" * Note: Can only be spawned in virtual world 0 (exterior)."))
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(yellowColor, u8("USAGE AND OPERATIONS"))
                                    imgui.BeginChild("SBOpsBox", imgui.ImVec2(0, 145), true)
                                        imgui.TextColored(greenColor, "[/opensafe]"); imgui.SameLine(); imgui.TextColored(whiteColor, u8(" (or F/ENTER) -> Open the safe."))
                                        imgui.BulletText(u8("Rename: Click the title (max 30 chars)."))
                                        imgui.BulletText(u8("Deposit: Right menu (weapons, materials, drugs)."))
                                        imgui.BulletText(u8("Withdraw: Click the desired item name."))
                                        imgui.BulletText(u8("Throw function: Type 'throw' to empty a blocked slot."))
                                        imgui.TextColored(grayColor, u8(" * Example: Get rid of Tec-9/Sniper if you're no longer in the faction."))
                                    imgui.EndChild()
                                    imgui.Spacing()
                                    imgui.TextColored(yellowColor, u8("UNIT CONSUMPTION (BY ARMS DEALER SKILL)"))
                                    imgui.BeginChild("SBCalcBox", imgui.ImVec2(0, 185), true)
                                        imgui.Columns(2, "sbTableCols", true); imgui.SetColumnWidth(0, 180)
                                        imgui.TextColored(greenColor, u8("Weapon")); imgui.NextColumn(); imgui.TextColored(greenColor, u8("Units (S1 -> S5)")); imgui.NextColumn()
                                        imgui.Separator()
                                        imgui.Text(u8("Deagle / SD Pistol")); imgui.NextColumn(); imgui.Text("30 / 26 / 22 / 18 / 14"); imgui.NextColumn()
                                        imgui.Text(u8("Combat / Shotgun")); imgui.NextColumn(); imgui.Text("40 / 35 / 30 / 25 / 20"); imgui.NextColumn()
                                        imgui.Text(u8("MP5 / TEC-9")); imgui.NextColumn(); imgui.Text("15 / 14 / 13 / 12 / 11"); imgui.NextColumn()
                                        imgui.Text(u8("M4 / AK-47")); imgui.NextColumn(); imgui.Text("24 / 23 / 22 / 21 / 20"); imgui.NextColumn()
                                        imgui.Text(u8("Rifle / Sniper")); imgui.NextColumn(); imgui.Text("350 / 338 / 325 / 313 / 300"); imgui.Columns(1)
                                        imgui.Separator()
                                        imgui.Text(u8("Materials / Drugs: 1 unit per piece."))
                                    imgui.EndChild()
                                    imgui.Spacing(); imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Mobsters can use safes at war if they are spawned before it starts."))
                                end
                            imgui.EndChild()

                            elseif sm.id == 17 then -- VEHICULE TUTORIAL
                            local isRO = (iniData.settings.lang == 0)
                            imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), isRO and u8("--- VEHICULE TUTORIAL ---") or "--- TUTORIAL VEHICLES ---")
                            imgui.Separator()
                            imgui.BeginChild("VehiclesTutorialBox", imgui.ImVec2(0, 0), true)
                                
                                local greenColor = imgui.ImVec4(0.26, 0.64, 0.40, 1.0)
                                local whiteColor = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)

                                local tutorialData = isRO and {
                                    "Nivel 1: jucatorul primeste un Faggio.",
                                    "Nivel 2: jucatorul primeste un Perrenial.",
                                    "Nivel 3: jucatorul primeste un Bobcat.",
                                    "Nivel 4: jucatorul nu primeste alt vehicul.",
                                    "Nivel 5: jucatorul primeste o Bravura.",
                                    "Nivel 6: jucatorul nu primeste alt vehicul.",
                                    "Nivel 7: jucatorul primeste un Landstalker."
                                } or {
                                    "Level 1: the player receives a Faggio.",
                                    "Level 2: the player receives a Perrenial.",
                                    "Level 3: the player receives a Bobcat.",
                                    "Level 4: the player receives no other vehicle.",
                                    "Level 5: the player receives a Bravura.",
                                    "Level 6: the player receives no other vehicle.",
                                    "Level 7: the player receives a Landstalker."
                                }

                                for _, msg in ipairs(tutorialData) do
                                    imgui.TextColored(greenColor, ">>")
                                    imgui.SameLine()
                                    imgui.TextColored(whiteColor, u8(msg))
                                    imgui.Spacing()
                                end

                            imgui.EndChild()

                            elseif sm.id == 18 then -- ECONOMIE TUTORIAL
                            local isRO = (iniData.settings.lang == 0)
                            
                            imgui.SetWindowFontScale(1.2) 

                            imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), isRO and u8("--- ECONOMIE ---") or "--- ECONOMY ---")
                            imgui.Separator()
                            
                            imgui.BeginChild("EconomyTutorialBox", imgui.ImVec2(0, 0), true)
                                local green = imgui.ImVec4(0.26, 0.64, 0.40, 1.0)
                                local white = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                                local yellow = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)

                                local function Category(name)
                                    imgui.Spacing()
                                    imgui.TextColored(yellow, name)
                                end

                                local function Item(text)
                                    imgui.TextColored(green, ">>")
                                    imgui.SameLine()
                                    imgui.TextColored(white, u8(text))
                                end

                                Category(isRO and "--- SERVICII & COMBUSTIBIL ---" or "--- SERVICES & FUEL ---")
                                Item("Combustibil: 5$ / '/. (litru)")
                                Item("Spital: 100$ | PnS: 200$ | Tractari: 200$")

                                Category(isRO and "--- ARME ---" or "--- WEAPONS ---")
                                Item("Deagle, Shotgun, MP5: 2$ per glont")
                                Item("SDPistol: 1$ per glont")
                                Item("M4, Ak47, Rifle: 3$ per glont")

                                Category(isRO and "--- BAUTURI ---" or "--- DRINKS ---")
                                Item("Bere(12$), Vin(21$), Whiskey(38$)")
                                Item("Vodka, Apa, Soda: 30$")
                                Item("Sprunk, Cafea: 23$")

                                Category(isRO and "--- OBIECTE (/buy) ---" or "--- ITEMS (/buy) ---")
                                Item("Telefon: 1.500$ | Statie emisie: 5.000$")
                                Item("MP3, Canistra: 2.000$ | Artificii: 1.000$")
                                Item("Zaruri: 500$ | Bricheta: 300$ | Fumigene: 200$")
                                Item("Camera, Tigari: 100$ | Trusa prim ajutor: 50$")

                                Category(isRO and "--- ALTELE ---" or "--- OTHERS ---")
                                Item("Accesorii (palarii/ochelari) / Costume: 500$")
                                Item("Inmatriculare (/carplate) / Culoare: 500$")
                                Item("Asigurari: 0-100k(500$), 100k-1M(1.000$), 1M-6M(1.500$), 6M+(2.000$)")
                                Item("Job-uri: Castiguri +15'/. | Job-ul Zilei: SUMA DUBLA")

                            imgui.EndChild()                    
                            imgui.SetWindowFontScale(1.0)  

                            elseif sm.id == 19 then -- AMENZI SI CONFISCARI
                            local isRO = (iniData.settings.lang == 0)

                            imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.4, 1.0), isRO and u8("--- LEGISLATIE & AMENZI ---") or "--- LEGISLATION & FINES ---")
                            imgui.Separator()
                            imgui.BeginChild("FinesBox", imgui.ImVec2(0, 0), true)
                                
                                local colorHeader = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                                local colorText = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)

                                imgui.TextColored(colorHeader, isRO and "Amenzi Trafic" or "Traffic Fines")
                                imgui.TextWrapped(u8("Parcare/Faruri stinse: 720$ (+conf. permis la parcare)"))
                                imgui.TextWrapped(u8("Condus neregulamentar/Incurcare trafic: 600$ + conf. permis"))
                                imgui.TextWrapped(u8("Viteza <50km/h: 840$ | Viteza >50km/h: 1200$ + conf. permis (LVL 8+)"))
                                imgui.TextWrapped(u8("NOS: 480$ + conf. permis | Hidraulice: 240$ + conf. permis"))
                                imgui.TextWrapped(u8("Alcoolemie >3.0: 600$ + conf. permis"))
                                
                                imgui.Separator()
                                imgui.Spacing()
                                imgui.TextColored(colorHeader, isRO and "Alte infractiuni" or "Other Offenses")
                                imgui.TextWrapped(u8("Materiale fara licenta: 120$ + conf. materiale"))
                                imgui.TextWrapped(u8("Vanzare arme (LVL 1-10) / Peste / Mers pe carosabil: 360$"))

                                imgui.Spacing()
                                imgui.Separator()
                                imgui.Spacing()

                                imgui.TextColored(colorHeader, isRO and "Suspendari Permis (Ore)" or "License Suspension (Hours)")
                                imgui.TextWrapped(u8("Alcool 3.0 / Hidraulice: 1 ora"))
                                imgui.TextWrapped(u8("Viteza 50-100km/h: 2 ore | Viteza >100km/h: 4 ore"))
                                imgui.TextWrapped(u8("Condus neregulamentar/Parcare/NOS: 3 ore"))
                                imgui.TextWrapped(u8("Recidiva: 5 ore"))

                                imgui.Spacing()
                                imgui.Separator()
                                imgui.Spacing()

                                imgui.TextColored(colorHeader, isRO and "Exceptii" or "Exceptions")
                                imgui.TextWrapped(u8("LVL 1-3: Doar mustrare."))
                                imgui.TextWrapped(u8("LVL 4-7: Alegere amenda 300$ sau conf. permis."))
                                imgui.TextWrapped(u8("Departamente: 2.000$ amenda pentru abateri."))
                                imgui.TextWrapped(u8("LVL 1-14: Wanted maxim 1 | Runner LVL 1-4: Wanted 1."))
                                imgui.Separator()

                                imgui.EndChild()

                            elseif sm.id == 20 then -- TRADER SHOP
                            local isRO = (iniData.settings.lang == 0)
                            imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), isRO and u8("--- TRADER SHOP ---") or "--- TRADER SHOP ---")
                            imgui.Separator()
                            imgui.BeginChild("TraderMainBox", imgui.ImVec2(0, 720), true)
                                -- MECANICI REROLL & FUZIUNE
                            imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), isRO and u8("MECANICA DE REROLL") or "REROLL MECHANIC")
                                imgui.BeginChild("RerollBox", imgui.ImVec2(0, 180), true)
                                    imgui.TextWrapped(isRO and u8("Schimba bonusurile de pe un skin la Traderul Egiptean. Poti alege ce pastrezi (x) si ce schimbi (v).") or "Change bonuses on a skin at the Egyptian Trader. You can choose what to keep (x) and what to reroll (v).")
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Costuri Reroll:") or "Reroll Costs:")
                                    imgui.BulletText(isRO and u8("1 bonus: $1.000.000 + 50 MP") or "1 bonus: $1,000,000 + 50 MP")
                                    imgui.BulletText(isRO and u8("2 bonusuri: $2.000.000 + 100 MP") or "2 bonuses: $2,000,000 + 100 MP")
                                    imgui.BulletText(isRO and u8("3 bonusuri: $3.000.000 + 150 MP") or "3 bonuses: $3,000,000 + 150 MP")
                                    imgui.BulletText(isRO and u8("4 bonusuri: $4.000.000 + 200 MP") or "4 bonuses: $4,000,000 + 200 MP")
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Tickete necesare: 1-2 bonusuri (1 ticket); 3-4 bonusuri (2 tickete).") or "Tickets required: 1-2 bonuses (1 ticket); 3-4 bonuses (2 tickets).")
                                imgui.EndChild()
                                imgui.Spacing()
                                -- MECANICA FUZIUNE
                                imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("MECANICA DE FUZIUNE") or "FUSION MECHANIC")
                                imgui.BeginChild("FusionBox", imgui.ImVec2(0, 130), true)
                                    imgui.TextWrapped(isRO and u8("Fuzioneaza 2 skinuri Diamond/Onyx. Skinul pastrat primeste bonusurile selectate.") or "Merge 2 Diamond/Onyx skins. The kept skin receives the selected bonuses.")
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Reguli & Costuri:") or "Rules & Costs:")
                                    imgui.BulletText(isRO and u8("Diamond: Max 2 bonusuri | $4.000.000 + 400 MP + 3 Tichete Diamond") or "Diamond: Max 2 bonuses | $4,000,000 + 400 MP + 3 Diamond Tickets")
                                    imgui.BulletText(isRO and u8("Onyx: Max 4 bonusuri | $6.000.000 + 600 MP + 5 Tichete Onyx") or "Onyx: Max 4 bonuses | $6,000,000 + 600 MP + 5 Onyx Tickets")
                                    imgui.Spacing()
                                    imgui.TextWrapped(isRO and u8("Nota: Skinurile rezultate primesc eticheta [FUSED]. Fuziunea reseteaza selectia bonusurilor.") or "Note: Resulting skins receive the [FUSED] tag. Fusion resets bonus selection.")
                                imgui.EndChild()
                                -- RARITATE
                                imgui.TextColored(imgui.ImVec4(1.0, 0.4, 1.0, 1.0), isRO and u8("RARITATE SKINURI") or "SKIN RARITY")
                                imgui.BeginChild("RarityBox", imgui.ImVec2(0, 95), true)
                                    imgui.TextColored(imgui.ImVec4(1, 0.84, 0, 1), "Legendary: 4 bonusuri speciale (20%+)")
                                    imgui.TextColored(imgui.ImVec4(0.5, 0.5, 1, 1), "Very Rare: 3 bonusuri speciale (15%+)")
                                    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Uncommon: 2 bonusuri speciale (10%+)")
                                    imgui.Text("Common: Restul")
                                imgui.EndChild()
                                -- RECICLARE 
                                imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("SISTEM DE RECICLARE (VALORI)") or "RECYCLING SYSTEM (VALUES)")
                                imgui.BeginChild("RecycleBox", imgui.ImVec2(0, 400), true)
                                    imgui.Columns(2, "recycleList", true)
                                    imgui.Text(isRO and u8("Item (x100 sau x1)") or "Item"); imgui.NextColumn()
                                    imgui.Text(isRO and u8("Gold / Bani") or "Gold / Money"); imgui.NextColumn()
                                    imgui.Separator()

                                    local recycleItems = {
                                        {"Puncte (Acc/MP/Rob/Esc)", "10 Gold / $5.000"},
                                        {"Free Bails (x10)", "5 Gold / $2.500"},
                                        {"Name/VIP/Hidden/KM/Label", "120 Gold / $60.000"},
                                        {"DS Stock", "260 Gold / $120.000"},
                                        {"Colored Carplate", "60 Gold / $30.000"},
                                        {"Half/FP Clear", "40 Gold / $20.000"},
                                        {"Optional/Warn Clear", "80 Gold / $40.000"},
                                        {"Job Skill", "280 Gold / $140.000"},
                                        {"Wheel Spins", "20 Gold / $10.000"},
                                        {"Diamond Fragments", "32 Gold / $16.000"},
                                        {"Diamond Tickets", "160 Gold / $80.000"},
                                        {"Onyx Fragments", "40 Gold / $20.000"},
                                        {"Onyx Tickets", "200 Gold / $100.000"},
                                        {"Skin Upgrade Ticket", "120 Gold / $60.000"},
                                        {"Skin Upgrade Fragment", "24 Gold / $12.000"},
                                        {"Red/Orange Crate", "18-45 MP"},
                                        {"Green/White Crate", "30-45 MP"},
                                        {"Cyan/Purple/Brown Crate", "45-75 MP"},
                                        {"Yellow/Silver/Blue/Olive Crate", "60-75 MP"},
                                        {"Magenta/Lime Crate", "105 MP"},
                                        {"Pink Crate", "120 MP"}
                                    }

                                    for _, item in ipairs(recycleItems) do
                                        imgui.TextWrapped(item[1]); imgui.NextColumn()
                                        imgui.Text(item[2]); imgui.NextColumn()
                                    end
                                    imgui.Columns(1)
                                imgui.EndChild()
                            
                            elseif sm.id == 21 then -- PAYDAY
                            local isRO = (iniData.settings.lang == 0)
                            imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), isRO and u8("--- PAYDAY ---") or "--- PAYDAY ---")
                            imgui.Separator()
                            imgui.BeginChild("PayDayMainBox", imgui.ImVec2(0, 720), true)
                                
                                -- CARACTERISTICI GENERALE
                                imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), isRO and u8("Caracteristici Generale") or "General Features")
                            imgui.BeginChild("MainPayday", imgui.ImVec2(0, 120), true)
                                imgui.TextWrapped(isRO and u8("Payday-ul se acorda la ora exacta (XX:00). Necesita 30 min jucate.") or "Payday is granted at the exact hour (XX:00). Requires 30 mins played.")
                                imgui.Spacing()
                                imgui.BulletText(isRO and u8("Standard: 1 Respect, 1 Rob, 1 Escape, 1 Clear FP, 1 Accept Point.") or "Standard: 1 Respect, 1 Rob, 1 Escape, 1 Clear FP, 1 Accept Point.")
                                imgui.BulletText(isRO and u8("Premium: +25 '/. salariu. La 5 ore: bonus de puncte suplimentare.") or "Premium: +25 '/. salary. Every 5 hours: extra points bonus.")
                                imgui.BulletText(isRO and u8("AFK/Sleep: Acumuleaza doar 1/3 din timp (20min din 60).") or "AFK/Sleep: Accumulates only 1/3 of time (20min out of 60).")
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Dobanda: Standard 0.01 '/. | Dobanda: Premium 0.03 '/.") or "Interest: Standard 0.01 '/. | Interest: Premium 0.03 '/.")
                            imgui.EndChild()
                            imgui.Spacing()
                            -- Bonusuri Detaliate
                            imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("Happy Hour & Bonusuri Detaliate") or "Happy Hour & Detailed Bonuses")
                            imgui.BeginChild("HappyHour", imgui.ImVec2(0, 260), true)
                                imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Happy Hour: 19:00 - 22:00 (Beneficii Duble!)") or "Happy Hour: 19:00 - 22:00 (Double Benefits!)")                 
                                imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Bonusuri Payday:") or "Payday Bonuses:")
                                imgui.BulletText(isRO and u8("Lvl 100: Cont Premium PERMANENT.") or "Lvl 100: PERMANENT Premium Account.")
                                imgui.BulletText(isRO and u8("3 Payday-uri: Dublu puncte de Respect.") or "3 Paydays: Double Respect points.")
                                imgui.BulletText(isRO and u8("4 Payday-uri: Dublu: Jaf, Evadare, Clear FP, Accept Lawyer.") or "4 Paydays: Double: Rob, Escape, Clear FP, Accept Lawyer.")
                                imgui.BulletText(isRO and u8("6 Payday-uri: 10 MP, 1 Accept Lawyer, 100 Droguri.") or "6 Paydays: 10 MP, 1 Accept Lawyer, 100 Drugs.")
                                imgui.BulletText(isRO and u8("10 Payday-uri: Triplu: Respect, FP, Jaf, Evadare + 10 Gold + 1 /bail.") or "10 Paydays: Triple: Respect, FP, Rob, Escape + 10 Gold + 1 /bail.")
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Bonusuri in functie de Nivel:") or "Level-based Bonuses:")
                                imgui.TextWrapped(isRO and u8("Job: Lvl 110-129 (5 '/.), 130-149 (10 '/.), 150-169 (15 '/.). Creste cu 5'/. la fiecare 20 nivele pana la 100 '/. (Lvl 490).") or "Job: Lvl 110-129 (5 '/.), 130-149 (10 '/.), 150-169 (15 '/.). Increases by 5'/. every 20 levels up to 100 '/. (Lvl 490).")
                                imgui.Spacing()
                                imgui.TextWrapped(isRO and u8("Rob: Lvl 120-139 (5 '/.), 140-159 (10 '/.), 160-179 (15 '/.). Creste cu 5'/. la fiecare 20 nivele pana la 100 '/. (Lvl 500).") or "Rob: Lvl 120-139 (5 '/.), 140-159 (10 '/.), 160-179 (15 '/.). Increases by 5'/. every 20 levels up to 100 '/. (Lvl 500).")
                            imgui.EndChild()
                            -- Informatii Payday
                            imgui.TextColored(imgui.ImVec4(1.0, 0.4, 1.0, 1.0), isRO and u8("Informatii afisate la Payday") or "Information displayed at Payday")
                            imgui.BeginChild("RarityBox", imgui.ImVec2(0, 50), true)
                                imgui.TextWrapped(isRO and u8("Plata, Bonus (25 '/. Premium), Taxa Primar, Chirie, Sold, Dobanda, Profit Business.") or "Payment, Bonus (25 '/. Premium), Mayor Tax, Rent, Balance, Interest, Business Profit.")
                                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), isRO and u8("Nota: Jucatorii cu bani > $5.000.000/$10.000.000 nu primesc dobanda.") or "Note: Players with money > $5.000.000/$10.000.000 do not receive interest.")
                                imgui.EndChild()    

                            imgui.EndChild()    
                            end    
                            imgui.TreePop()
                        end
                    end
                end
                imgui.Spacing()
            end

            local businessesData = {
            {name = "Banci", nameEN = "Banks", keywords = "banci banca credit transfer cash atm depozite seif comisioane bizbalance idlewood commerce vinewood", id_real = 1},
            {name = "Benzinarii", nameEN = "Gas Stations", keywords = "benzinarii benzinarie gas station fill canistra stoc combustibil rezervor pompa normal premium", id_real = 2},
            {name = "24/7", nameEN = "24/7", keywords = "24/7 magazine mixte telefon cartela agenda tigari brichete camera foto spray setprice lotto zaruri electronics util", id_real = 3},
            {name = "Fast Fooduri", nameEN = "Fast Foods", keywords = "fast fooduri burger shot cluckin bell pizza stack mancare hp saturatie tejghea idlewood market willowfield East marina whitewood redsands spinybed garcia downtown juniper hollow flats", id_real = 4},
            {name = "Clothing Stores", nameEN = "Clothing Stores", keywords = "clothing stores magazine haine skin civile garderoba setprice cabine binco suburban zip victim prolaps didiersachs", id_real = 5},
            {name = "Gun Shops", nameEN = "Gun Shops", keywords = "gun shops ammu-nation arme poligon gym war mafii licenta port-arma deagle sdpistol shotgun mp5 m4 ak47 rifle sniper knife tec9 uzi damage daune", id_real = 6},
            {name = "Cluburi si baruri", nameEN = "Clubs and Bars", keywords = "cluburi baruri alhambra jizzy misty's interactiuni sociale alcool hp bizfee evenimente bere vin vodka whiskey sprunk cafea pig pen casino caligulas big spread ranch", id_real = 7},
            {name = "Restaurante", nameEN = "Restaurants", keywords = "restaurante gourmet mancaruri fine preturi mari profit fix gaydar dinner eat drink", id_real = 8},
            {name = "Pay'n'Spray-uri", nameEN = "Pay'n'Sprays", keywords = "pay'n'spray-uri reparare instant culoare vopsea rob solo wanted jumatate spray pns temple beach idlewood dilimore redsands carson quebrados downtown hollow", id_real = 9},
            {name = "Tuninguri", nameEN = "Tuning Shops", keywords = "tuninguri jante nos hidraulice spoiler bampere lips mecanici componente masini transfender angels premium nitro neoane", id_real = 10},
            {name = "Arene", nameEN = "Arenas", keywords = "arene dm paintball gungame antrenament bilet inscriere mafii departamente racing war hydra rhino hunter lcs last car standing", id_real = 11},
            {name = "CNN", nameEN = "CNN", keywords = "cnn studio anunturi ad chat global caracter licitatii unic myad ads", id_real = 12},
            {name = "Rent", nameEN = "Rent", keywords = "rent car bike inchiriere mobila gari aeroporturi rentcar rentbike taxa minut gara plane boat aeroport bayside pier", id_real = 13},
            {name = "White Weapons", nameEN = "White Weapons", keywords = "white weapons armurarii speciale cutite bate baseball golf katana flori fara licenta shovel lopata brass knuckles", id_real = 14},
            {name = "Sex Shopuri", nameEN = "Sex Shops", keywords = "sex shopuri jucarii amuzante afacere mica incepatori ieftin comercial dildo vibrator flori buchet", id_real = 15},
            {name = "Poker Casino", nameEN = "Poker Casino", keywords = "poker casino caligula four dragons texas hold'em blackjack ruleta rake pot castigat royal flush straight careu chinta pereche high card blind", id_real = 16},
            {name = "Car Insurance", nameEN = "Car Insurance", keywords = "car insurance asigurari auto insurance explozie distrus polita polite auto buyinsurance", id_real = 17},
            {name = "PubG Arena", nameEN = "PubG Arena", keywords = "pubg arena minijoc supravietuire battle royale inscriere taxa meciuri fond premiere loot armor zone cerc danger hp gear", id_real = 18},
            {name = "Car Color", nameEN = "Car Color", keywords = "car color vopsitorii hidden rgb custom reflectii stickere upgrade materiale standard principala secundara", id_real = 19},
            {name = "Alte bizuri", nameEN = "Other Businesses", keywords = "alte bizuri parcari subterane tractare lifturi map automate bizbalance retragere phone plating plating hospital spital gate farm co", id_real = 20}
        }

            local bizMatches = {}
            for _, biz in ipairs(businessesData) do
                local matchNameRO = biz.name:lower():find(current_search, 1, true)
                local matchNameEN = biz.nameEN:lower():find(current_search, 1, true)
                local matchKeywords = biz.keywords:lower():find(current_search, 1, true)
                
                if matchNameRO or matchNameEN or matchKeywords then
                    local displayName = iniData.settings.lang == 0 and biz.name or biz.nameEN
                    table.insert(bizMatches, {name = displayName, id = biz.id_real})
                end
            end

            if #bizMatches > 0 then
            foundAny = true
            local bizHeaderLabel = iniData.settings.lang == 0 and ("Rezultate din: Categorii Bizuri (" .. #bizMatches .. ")") or ("Results from: Business Categories (" .. #bizMatches .. ")")
            if imgui.CollapsingHeader(u8(bizHeaderLabel)) then
                for _, bm in ipairs(bizMatches) do
                    if imgui.TreeNodeStr(u8(bm.name) .. " ##global_biz_" .. bm.id) then
                            if bm.id == 1 then -- BANCI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            
                            if iniData.settings.lang == 0 then
                                local title = "B A N C I"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                                imgui.SetWindowFontScale(1.0)
                                imgui.Separator()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("LOCATII SI IDENTIFICARE"))
                                imgui.BeginChild("BankLocations_Search", imgui.ImVec2(0, 135), true)
                                    imgui.SetWindowFontScale(1.5)   
                                    imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Los Santos"); imgui.SameLine(250); imgui.Text("-> ID 4")  
                                    imgui.Spacing(); imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Las Venturas"); imgui.SameLine(250); imgui.Text("-> ID 5")    
                                    imgui.Spacing(); imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "San Fierro"); imgui.SameLine(250); imgui.Text("-> ID 132")    
                                    imgui.SetWindowFontScale(1.0)
                                imgui.EndChild()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), u8("OPERATIUNI SI COMENZI"))
                                imgui.BeginChild("BankOps_Search", imgui.ImVec2(0, 250), true)
                                    imgui.SetWindowFontScale(1.2)
                                    imgui.BulletText(u8("Sold curent: [/balance]"))
                                    imgui.BulletText(u8("Depunere bani: [/deposit]"))
                                    imgui.BulletText(u8("Retragere: [/withdraw] sau [/atm]"))
                                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("TRANSFER BANCAR:"))
                                    imgui.TextWrapped(u8("- Comanda: [/transfer]"))
                                    imgui.TextWrapped(u8("- Necesar: Minim Nivel 3"))
                                    imgui.TextWrapped(u8("- Taxa: 1 '/. din suma transferata"))
                                    imgui.SetWindowFontScale(1.0)
                                imgui.EndChild()
                                imgui.Spacing(); imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Bancile sunt marcate pe harta cu simbolul '$' de culoare verde."))
                            else
                                -- ENGLISH VERSION
                                local title = "B A N K S"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                                imgui.SetWindowFontScale(1.0)
                                imgui.Separator()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "LOCATIONS AND IDENTIFICATION")
                                imgui.BeginChild("BankLocations_Search", imgui.ImVec2(0, 135), true)
                                    imgui.SetWindowFontScale(1.5)   
                                    imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Los Santos"); imgui.SameLine(250); imgui.Text("-> ID 4")  
                                    imgui.Spacing(); imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Las Venturas"); imgui.SameLine(250); imgui.Text("-> ID 5")    
                                    imgui.Spacing(); imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "San Fierro"); imgui.SameLine(250); imgui.Text("-> ID 132")    
                                    imgui.SetWindowFontScale(1.0)
                                imgui.EndChild()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "OPERATIONS AND COMMANDS")
                                imgui.BeginChild("BankOps_Search", imgui.ImVec2(0, 250), true)
                                    imgui.SetWindowFontScale(1.2)
                                    imgui.BulletText("Current balance: [/balance]")
                                    imgui.BulletText("Deposit money: [/deposit]")
                                    imgui.BulletText("Withdraw: [/withdraw] or [/atm]")
                                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "BANK TRANSFER:")
                                    imgui.TextWrapped("- Command: [/transfer]")
                                    imgui.TextWrapped("- Requirement: Minimum Level 3")
                                    imgui.TextWrapped("- Fee: 1 '/. of the transferred amount")
                                    imgui.SetWindowFontScale(1.0)
                                imgui.EndChild()
                                imgui.Spacing(); imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Banks are marked on the map with a green '$' symbol.")
                            end

                            elseif bm.id == 2 then -- BENZINARII
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "G A S - S T A T I O N"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("GasGeneralInfo_Search", imgui.ImVec2(0, 95), true)
                                imgui.Columns(2, "gasInfoCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), u8("COMENZI:"))
                                    imgui.BulletText("/fill ['/.]") 
                                    imgui.BulletText("/fillgascan")
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("REZERVOR:"))
                                    imgui.Text(u8("Normal: 100'/."))
                                    imgui.Text(u8("Premium: 150'/."))
                                else
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "COMMANDS:")
                                    imgui.BulletText("/fill ['/.]") 
                                    imgui.BulletText("/fillgascan")
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "FUEL TANK:")
                                    imgui.Text("Normal: 100'/.")
                                    imgui.Text("Premium: 150'/.")
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LISTA LOCATII PE ORASE:") or "LOCATION LIST BY CITY:")

                            -- Child LS
                            imgui.BeginChild("GS_LS_Search", imgui.ImVec2(0, 115), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "lsGasList_Search", false)
                                imgui.BulletText("Idlewood - ID 69"); imgui.BulletText("Vinewood - ID 68")
                                imgui.NextColumn()
                                imgui.BulletText("Dilimore - ID 73"); imgui.BulletText("Montgomery - ID 72")
                                imgui.Columns(1)
                            imgui.EndChild()

                            -- Child LV
                            imgui.BeginChild("GS_LV_Search", imgui.ImVec2(0, 140), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "lvGasList_Search", false)
                                imgui.BulletText("Fort Carson - ID 81"); imgui.BulletText("Bone County - ID 79")
                                imgui.BulletText("Redsands W. - ID 84"); imgui.BulletText("Emerald Isle - ID 78")
                                imgui.NextColumn()
                                imgui.BulletText("Spinybed - ID 86"); imgui.BulletText("GSLV - ID 83"); imgui.BulletText("4 Dragons - ID 82")
                                imgui.Columns(1)
                            imgui.EndChild()

                            -- Child SF
                            imgui.BeginChild("GS_SF_Search", imgui.ImVec2(0, 165), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "sfGasList_Search", false)
                                imgui.BulletText("Easter Basin - ID 77"); imgui.BulletText("Doherty - ID 74")
                                imgui.BulletText("Juniper Hollow - ID 75"); imgui.BulletText("Tierra Robada 2 - ID 85")
                                imgui.NextColumn()
                                imgui.BulletText("Tierra Robada 1 - ID 80"); imgui.BulletText("Angel Pine - ID 76")
                                imgui.BulletText("Flint County - ID 70"); imgui.BulletText("Whetstone - ID 71")
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Identificare: Benzinariile sunt marcate cu un camion pe harta."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Identification: Gas stations are marked with a fuel truck on the map.")
                            end

                            elseif bm.id == 3 then -- 24/7
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "24/7"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- Produse si Comenzi
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRODUSE SI COMENZI") or "PRODUCTS AND COMMANDS")
                            imgui.BeginChild("Prod247_Search", imgui.ImVec2(0, 180), true)
                                imgui.Columns(2, "prodCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("ELECTRONICE / DIVERSE:"))
                                    imgui.Text(u8("- Telefon: $1.500"))
                                    imgui.Text(u8("- MP3 Player: $2.000"))
                                    imgui.Text(u8("- Statie Radio: $5.000"))
                                    imgui.Text(u8("- Aparat foto: $100"))
                                    imgui.Text(u8("- Zaruri: $500"))
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("UTILE / FISHING:"))
                                    imgui.Text(u8("- Canistra: $2.000"))
                                    imgui.Text(u8("- Undita: $400"))
                                    imgui.Text(u8("- Momeala: $20"))
                                    imgui.Text(u8("- Bricheta: $300"))
                                    imgui.Text(u8("- Tigari: $100"))
                                    imgui.Columns(1)
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), u8("Comenzi: /buy (produse), /lotto (bilet loterie)"))
                                else
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "ELECTRONICS / MISC:")
                                    imgui.Text("- Phone: $1,500")
                                    imgui.Text("- MP3 Player: $2,000")
                                    imgui.Text("- Radio Station: $5,000")
                                    imgui.Text("- Camera: $100")
                                    imgui.Text("- Dice: $500")
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "UTILITY / FISHING:")
                                    imgui.Text("- Fuel Can: $2,000")
                                    imgui.Text("- Fishing Rod: $400")
                                    imgui.Text("- Bait: $20")
                                    imgui.Text("- Lighter: $300")
                                    imgui.Text("- Cigarettes: $100")
                                    imgui.Columns(1)
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "Commands: /buy (products), /lotto (lottery ticket)")
                                end
                            imgui.EndChild()

                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")

                            imgui.BeginChild("LS247", imgui.ImVec2(0, 130), true)
                            imgui.SetWindowFontScale(1.5)
                            local city1 = "Los Santos"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Columns(2, "lsCols", false)
                            imgui.BulletText("24/7 Vinewood LS 1 - 13")
                            imgui.BulletText("24/7 Vinewood LS 2 - 14")
                            imgui.BulletText("24/7 Commerce LS - 15")
                            imgui.BulletText("24/7 Idlewood LS - 16")
                            imgui.NextColumn()
                            imgui.Columns(1)
                        imgui.EndChild()

                        -- Las Venturas
                        imgui.BeginChild("LV247", imgui.ImVec2(0, 130), true)
                            imgui.SetWindowFontScale(1.5)
                            local city2 = "Las Venturas"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Columns(2, "lvCols", false)
                            imgui.BulletText("24/7 Redsands East LV - 17")
                            imgui.BulletText("24/7 Emerald Isle LV - 18")
                            imgui.BulletText("24/7 Starfish Casino LV 1 - 19")
                            imgui.BulletText("24/7 Roca Escalante LV - 20")
                            imgui.NextColumn()
                            imgui.BulletText("24/7 Old Venturas Strip LV - 21")
                            imgui.BulletText("24/7 Starfish Casino LV 2 - 22")
                            imgui.BulletText("24/7 Creek LV - 23")
                            imgui.Columns(1)
                        imgui.EndChild()

                        -- San Fierro
                        imgui.BeginChild("SF247", imgui.ImVec2(0, 120), true)
                            imgui.SetWindowFontScale(1.5)
                            local city3 = "San Fierro"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Columns(2, "sfCols", false)
                            imgui.BulletText("24/7 Juniper Hill SF - 124")
                            imgui.BulletText("24/7 Garcia SF 1 - 125")
                            imgui.BulletText("24/7 Garcia SF 2 - 126")
                            imgui.NextColumn()
                            imgui.BulletText("24/7 Hashbury SF - 127")
                            imgui.BulletText("24/7 Chinatown SF - 128")
                            imgui.Columns(1)
                        imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Marcaj: Magazinele sunt reprezentate pe harta cu litera 'S' rosie."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Marking: Stores are represented on the map with a red 'S' letter.")
                            end

                            elseif bm.id == 4 then -- FAST FOODURI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.Spacing()
                            imgui.SetWindowFontScale(1.4)
                            local title = "F A S T - F O O D S"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            
                            imgui.BeginChild("FF_InfoText_Search", imgui.ImVec2(0, 80), true)
                                imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                if iniData.settings.lang == 0 then
                                    imgui.Text(u8("Serverul detine un numar total de 28 de fast fooduri pe harta."))
                                    imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                    imgui.Text(u8("Magazinele sunt marcate cu: felie de pizza, clopotel sau burger."))
                                    imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                    imgui.Text(u8("Comanda [/eat] / LALT: +20'/. HP | Cost: $30"))
                                else
                                    imgui.Text("The server has a total of 28 fast foods on the map.")
                                    imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                    imgui.Text("Stores are marked with: pizza slice, bell, or burger.")
                                    imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                    imgui.Text("Command [/eat] / LALT: +20'/. HP | Cost: $30")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.BeginChild("FF_LongList_Search", imgui.ImVec2(0, 800), true)
                            local lang = iniData.settings.lang == 0
                            local city_order = {"Los Santos", "Las Venturas", "San Fierro"}

                            local categories = {
                                {
                                    name = lang and u8("Pizza") or "Pizza",
                                    data = {
                                        ["Los Santos"] = {"Pizza Idlewood LS - 59", "Pizza Red County LS - 60", "Pizza Montgomery LS - 61", "Pizza Palomino Creek LS - 62"},
                                        ["Las Venturas"] = {"Pizza Emerald Isle LV - 63", "Pizza Starfish Casino LV - 64", "Pizza Creek LV - 65", "Pizza Escalante LV - 66"},
                                        ["San Fierro"] = {"Pizza Financial SF - 38", "Pizza Esplanade North SF - 37"}
                                    }
                                },
                                {
                                    name = "Cluckin' Bell",
                                    data = {
                                        ["Los Santos"] = {"Cluckin Bell Market LS - 50", "Cluckin Bell Willowfield LS - 51", "Cluckin Bell East Los Santos LS - 52"},
                                        ["Las Venturas"] = {"Cluckin Bell Emerald Isle LV - 53", "Cluckin Bell Old Venturas - 54", "Cluckin Bell Pilgrim LV - 55", "Cluckin Bell Creek LV - 56", "Cluckin Bell Bone County LV - 57"},
                                        ["San Fierro"] = {"Cluckin Bell Tierra Robada SF - 58", "Cluckin Bell Downtown SF - 117", "Cluckin Bell Ocean Flats SF - 118"}
                                    }
                                },
                                {
                                    name = "Burger Shot",
                                    data = {
                                        ["Los Santos"] = {"Burger Shot Marina LS - 43", "Burger Shot Vinewood LS - 44"},
                                        ["Las Venturas"] = {"Burger Shot Old Venturas LV 1 - 47", "Burger Shot Old Venturas LV 2 - 48", "Burger Shot Whitewood LV - 45", "Burger Shot Redsands LV - 46", "Burger Shot Spinybed LV - 49"},
                                        ["San Fierro"] = {"Burger Shot Garcia SF - 27", "Burger Shot Downtown SF - 28", "Burger Shot Hollow SF - 33"}
                                    }
                                }
                            }

                            -- Afisare
                            for _, cat in ipairs(categories) do
                                imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), ">> " .. cat.name)
                                imgui.Separator()
                                
                                for _, city_name in ipairs(city_order) do
                                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), ">> " .. city_name)
                                    for _, text in ipairs(cat.data[city_name]) do
                                        imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                                        imgui.Text(text)
                                    end
                                end
                                imgui.Spacing(); imgui.Spacing()
                            end
                            imgui.EndChild()

                            elseif bm.id == 5 then -- CLOTHING STORES
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "C L O T H I N G - S T O R E S"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("ClothingPreturiInfo_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("CATEGORII SKINURI SI ACCESORII:") or "SKIN AND ACCESSORY CATEGORIES:")
                                imgui.Separator()
                                imgui.Columns(2, "clothPriceCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Starter: $1 / 1 Gold"))
                                    imgui.BulletText(u8("Bronze: $20.000 / 100 Gold"))
                                    imgui.BulletText(u8("Silver: $195.000 / 1000 Gold"))
                                    imgui.BulletText(u8("Platinum: $1.090.000 / 5000 Gold"))
                                    imgui.NextColumn()
                                    imgui.BulletText(u8("Ochelari: $500"))
                                    imgui.BulletText(u8("Palarie: $500"))
                                    imgui.BulletText(u8("Costume: $500"))
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), u8("Comenzi: /skins, /costumes, /buyacs"))
                                else
                                    imgui.BulletText("Starter: $1 / 1 Gold")
                                    imgui.BulletText("Bronze: $20,000 / 100 Gold")
                                    imgui.BulletText("Silver: $195,000 / 1000 Gold")
                                    imgui.BulletText("Platinum: $1,090,000 / 5000 Gold")
                                    imgui.NextColumn()
                                    imgui.BulletText("Glasses: $500")
                                    imgui.BulletText("Hat: $500")
                                    imgui.BulletText("Suits: $500")
                                    imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "Commands: /skins, /costumes, /buyacs")
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")

                            -- Los Santos
                            imgui.BeginChild("Cloth_LS_Search", imgui.ImVec2(0, 140), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "lsClothCols_Search", false)
                                imgui.BulletText("Clothes Store Ganton LS - 101")
                                imgui.BulletText("Clothes Store Downtown LS - 104")
                                imgui.BulletText("Clothes Store Rodeo LS 1 - 107")
                                imgui.NextColumn()
                                imgui.BulletText("Clothes Store Jefferson LS - 109")
                                imgui.BulletText("Clothes Store Rodeo LS 2 - 111")
                                imgui.BulletText("Clothes Store Rodeo LS - 123")
                                imgui.Columns(1)
                            imgui.EndChild()

                            -- Las Venturas
                            imgui.BeginChild("Cloth_LV_Search", imgui.ImVec2(0, 155), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "lvClothCols_Search", false)
                                imgui.BulletText("Clothes Store LV Airport - 102")
                                imgui.BulletText("Clothes Store Emerald Isle LV 1 - 103")
                                imgui.BulletText("Clothes Store Emerald Isle LV 2 - 105")
                                imgui.BulletText("Clothes Store Starfish Casino LV - 106")
                                imgui.NextColumn()
                                imgui.BulletText("Clothes Store Creek LV 1 - 108")
                                imgui.BulletText("Clothes Store Creek LV 2 - 110")
                                imgui.Columns(1)
                            imgui.EndChild()

                            -- San Fierro
                            imgui.BeginChild("Cloth_SF_Search", imgui.ImVec2(0, 110), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "sfClothCols_Search", false)
                                imgui.BulletText("Clothes Store Hashbury SF - 119")
                                imgui.BulletText("Clothes Store Juniper Hill SF - 120")
                                imgui.NextColumn()
                                imgui.BulletText("Clothes Store Downtown SF 1 - 121")
                                imgui.BulletText("Clothes Store Downtown SF 2 - 122")
                                imgui.Columns(1)
                            imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Marcaj harta: Un tricou alb."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Map marking: A white t-shirt.")
                            end

                            elseif bm.id == 6 then -- GUN SHOPS
                                local w = imgui.GetWindowWidth() - 40
                                imgui.SetWindowFontScale(1.5)
                                local title = "G U N - S H O P S"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), title)
                                imgui.SetWindowFontScale(1.0)
                                imgui.Separator()
                                imgui.Spacing()
                                imgui.BeginChild("GunShopInfo_Search", imgui.ImVec2(0, 85), true)
                                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "OPERATIUNI:")
                                    imgui.BulletText("Comanda: [/buygun (nume) (munitie)]")
                                    imgui.BulletText("Regenerare HP: [/eat] costa $30 si ofera 20 HP.")
                                imgui.EndChild()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "LOCATII PE ORASE:")
                                imgui.BeginChild("GunShopLocations_Search", imgui.ImVec2(0, 120), true)
                                    imgui.SetWindowFontScale(1.5)      
                                    imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Los Santos")
                                    imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 1")       
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Las Venturas")
                                    imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 144")     
                                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "San Fierro")
                                    imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 137")      
                                    imgui.SetWindowFontScale(1.0)
                                imgui.EndChild()
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), "CATALOG ARME SI DAUNE (DAMAGE):")
                                imgui.BeginChild("GunCatalog_Search", imgui.ImVec2(0, 240), true)
                                    imgui.Columns(3, "gunCols_Search", true)
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Arma"); imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Pret/Glont"); imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Dauna (HP)"); imgui.NextColumn()
                                    imgui.Separator()
                                    imgui.Text("SDPistol"); imgui.NextColumn(); imgui.Text("$1"); imgui.NextColumn(); imgui.Text("13.2"); imgui.NextColumn()
                                    imgui.Text("Desert Eagle"); imgui.NextColumn(); imgui.Text("$2"); imgui.NextColumn(); imgui.Text("46.2"); imgui.NextColumn()
                                    imgui.Text("Shotgun"); imgui.NextColumn(); imgui.Text("$2"); imgui.NextColumn(); imgui.Text("~49.5"); imgui.NextColumn()
                                    imgui.Text("MP5"); imgui.NextColumn(); imgui.Text("$2"); imgui.NextColumn(); imgui.Text("8.2"); imgui.NextColumn()
                                    imgui.Text("M4 / AK47"); imgui.NextColumn(); imgui.Text("$3"); imgui.NextColumn(); imgui.Text("10.0"); imgui.NextColumn()
                                    imgui.Text("Country Rifle"); imgui.NextColumn(); imgui.Text("$3"); imgui.NextColumn(); imgui.Text("24.7"); imgui.NextColumn()      
                                    imgui.Columns(1)
                                    imgui.Separator()
                                    imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), "ARME SPECIALE (NON-SHOP):")
                                    imgui.Text("Sniper: 200 HP | Knife: 200 HP | Tec9: 6.6 HP | Uzi: 6.5 HP")
                                imgui.EndChild()
                                imgui.Spacing()
                                imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Marcaj: Magazinele sunt marcate pe harta cu simbolul unui pistol.")

                            elseif bm.id == 7 then -- CLUBURI SI BARURI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "C L U B S - B A R S" -- Titlu fixat in engleza
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0.6, 0.1, 0.9, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("MENIU BAUTURI SI COMENZI") or "DRINK MENU AND COMMANDS")
                            imgui.BeginChild("BarMeniu_Search", imgui.ImVec2(0, 160), true)
                                imgui.Columns(2, "barCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("ALCOOLICE:"))
                                    imgui.Text(u8("- Bere: $12")); imgui.Text(u8("- Vin: $21"))
                                    imgui.Text(u8("- Vodka: $30")); imgui.Text(u8("- Whiskey: $38"))
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("NON-ALCOOLICE:"))
                                    imgui.Text(u8("- Apa / Suc: $30")); imgui.Text(u8("- Sprunk / Cafea: $23"))
                                else
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "ALCOHOLIC:")
                                    imgui.Text("- Beer: $12"); imgui.Text("- Wine: $21")
                                    imgui.Text("- Vodka: $30"); imgui.Text("- Whiskey: $38")
                                    imgui.NextColumn()
                                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "NON-ALCOHOLIC:")
                                    imgui.Text("- Water / Soda: $30"); imgui.Text("- Sprunk / Coffee: $23")
                                end
                                imgui.Columns(1)
                                imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("Comanda: [/drink] pentru a comanda la bar.") or "Command: [/drink] to order at the bar.")
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE (ID-URI):") or "LOCATIONS BY CITY (IDS):")

                            -- LS
                            imgui.BeginChild("Bar_LS_Search", imgui.ImVec2(0, 100), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Alhambra LS - ID 7"); imgui.BulletText("The Pig Pen LS - ID 8")
                            imgui.EndChild()

                            -- LV
                            imgui.BeginChild("Bar_LV_Search", imgui.ImVec2(0, 150), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.Columns(2, "lvBarCols_Search", false)
                                imgui.BulletText("4 Dragons - ID 115"); imgui.BulletText("Caligulas - ID 114"); imgui.BulletText("Jizzy LV - ID 10")
                                imgui.NextColumn()
                                imgui.BulletText("Casino Redsands - ID 116"); imgui.BulletText("Big Spread Ranch - ID 9")
                                imgui.Columns(1)
                            imgui.EndChild()

                            -- SF
                            imgui.BeginChild("Bar_SF_Search", imgui.ImVec2(0, 75), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Jizzy SF - ID 134")
                            imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Marcaj: Cluburile sunt reprezentate pe harta cu 'S' alb sau o roata/discheta."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Marking: Clubs are represented on the map with a white 'S' or a wheel/disc icon.")
                            end

                            elseif bm.id == 8 then -- RESTAURANTE
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "R E S T A U R A N T S" -- Titlu fixat in engleza
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("RestGeneralInfo_Search", imgui.ImVec2(0, 80), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("ACTIVITATI:") or "ACTIVITIES:")
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Comanda: [/eat] pentru a manca."))
                                    imgui.BulletText(u8("Comanda: [/drink] pentru a comanda bautura."))
                                else
                                    imgui.BulletText("Command: [/eat] to eat.")
                                    imgui.BulletText("Command: [/drink] to order a drink.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                            
                            -- LS
                            imgui.BeginChild("Rest_LS_Search", imgui.ImVec2(0, 95), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Restaurant LS 1 - ID 2"); imgui.BulletText("Restaurant LS 2 - ID 12")
                            imgui.EndChild()
                            
                            -- LV
                            imgui.BeginChild("Rest_LV_Search", imgui.ImVec2(0, 75), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Restaurant LV - ID 11")
                            imgui.EndChild()
                            
                            -- SF
                            imgui.BeginChild("Rest_SF_Search", imgui.ImVec2(0, 135), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Restaurant SF 1 - ID 135"); imgui.BulletText("Restaurant SF 2 - ID 136")
                                imgui.BulletText("Gaydar Station Club SF - ID 139"); imgui.BulletText("Dinner Restaurant SF - ID 138")
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Identificare: Restaurantele sunt marcate cu o furculita si un cutit."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Identification: Restaurants are marked with a fork and knife icon.")
                            end

                            elseif bm.id == 9 then -- PAY'N'SPRAY-URI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "P A Y 'N' S P R A Y"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("PNSGeneralInfo_Search", imgui.ImVec2(0, 85), true)
                                imgui.Columns(2, "pnsInfoCols_Search", false)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("COST REPARATIE:") or "REPAIR COST:")
                                imgui.BulletText(u8("$200 (indiferent de vehicul)"))
                                imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("COMENZI:") or "COMMANDS:")
                                imgui.BulletText("/enter")
                                imgui.BulletText(iniData.settings.lang == 0 and u8("Alternativa: LALT") or "Alternative: LALT")
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE (ID-URI):") or "LOCATIONS BY CITY (IDS):")
                            
                            -- LS
                            imgui.BeginChild("PNS_LS_Search", imgui.ImVec2(0, 135), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("PNS Temple - ID 87"); imgui.BulletText("PNS Santa Maria Beach - ID 88")
                                imgui.BulletText("PNS Idlewood - ID 93"); imgui.BulletText("PNS Dilimore - ID 95")
                            imgui.EndChild()
                            
                            -- LV
                            imgui.BeginChild("PNS_LV_Search", imgui.ImVec2(0, 95), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("PNS Redsands - ID 92"); imgui.BulletText("PNS Fort Carson - ID 94")
                            imgui.EndChild()
                            
                            -- SF
                            imgui.BeginChild("PNS_SF_Search", imgui.ImVec2(0, 115), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("PNS El Quebrados - ID 89"); imgui.BulletText("PNS Downtown - ID 90")
                                imgui.BulletText("PNS Juniper Hollow - ID 91")
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Identificare: Pay'n'Spray-urile sunt marcate pe harta cu o cutie de spray."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Identification: Pay'n'Spray locations are marked on the map with a spray can icon.")
                            end

                            elseif bm.id == 10 then -- TUNINGURI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "T U N I N G - S H O P S" -- Titlu in engleza
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0, 1, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("TuningPricesInfo_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("PRETURI COMPONENTE (DIN PRETUL MASINII):") or "COMPONENT PRICES (OF VEHICLE PRICE):")
                                imgui.Separator()
                                imgui.Columns(2, "tunePriceCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Paint Jobs: 1.15'/.")); imgui.BulletText(u8("Nitro (10): 0.8'/."))
                                    imgui.BulletText(u8("Roti / Exhaust: 0.8'/.")); imgui.BulletText(u8("Hidraulice: 0.25'/."))
                                    imgui.NextColumn()
                                    imgui.BulletText(u8("Neoane: 1.15'/. (Doar Premium)")); imgui.BulletText(u8("Bari / Spoiler / Praguri: 0.5'/."))
                                    imgui.BulletText(u8("Capota / Lampi / Vents: 0.5'/.")); imgui.BulletText(u8("Culori: $25 (Pret fix)"))
                                else
                                    imgui.BulletText("Paint Jobs: 1.15'/."); imgui.BulletText("Nitro (10): 0.8%'/.")
                                    imgui.BulletText("Wheels / Exhaust: 0.8'/."); imgui.BulletText("Hydraulics: 0.25'/.")
                                    imgui.NextColumn()
                                    imgui.BulletText("Neon: 1.15'/. (Premium only)"); imgui.BulletText("Bumpers / Spoiler / Skirts: 0.5'/.")
                                    imgui.BulletText("Hood / Lights / Vents: 0.5'/."); imgui.BulletText("Colors: $25 (Fixed price)")
                                end
                                imgui.Columns(1)
                            imgui.EndChild()

                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")

                            -- LS
                            imgui.BeginChild("Tune_LS_Search", imgui.ImVec2(0, 95), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Transfender LS - ID 96")
                                imgui.BulletText(iniData.settings.lang == 0 and u8("Loco Low Co. LS (Savanna, Blade, etc.) - ID 100") or "Loco Low Co. LS (Savanna, Blade, etc.) - ID 100")
                            imgui.EndChild()

                            -- LV
                            imgui.BeginChild("Tune_LV_Search", imgui.ImVec2(0, 75), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Transfender LV - ID 98")
                            imgui.EndChild()

                            -- SF
                            imgui.BeginChild("Tune_SF_Search", imgui.ImVec2(0, 95), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Transfender SF - ID 97")
                                imgui.BulletText(iniData.settings.lang == 0 and u8("Wheel Arch Angels SF (Sultan, Elegy, etc.) - ID 99") or "Wheel Arch Angels SF (Sultan, Elegy, etc.) - ID 99")
                            imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Identificare: Service-urile sunt marcate cu o cheie rosie pe harta."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Identification: Tuning shops are marked with a red wrench icon on the map.")
                            end

                            elseif bm.id == 11 then -- ARENE
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "A R E N A S"  
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- PAINTBALL
                            imgui.BeginChild("ArenaPaintball_Search", imgui.ImVec2(0, 110), true)
                                imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "PAINTBALL ARENA (ID 34)")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Durata: Un meci dureaza 4 minute.")); imgui.BulletText(u8("Premiu: Cel mai bun jucator primeste $110 la final.")); imgui.BulletText(u8("Comanda Parasire: [/leavepaintball]."))
                                else
                                    imgui.BulletText("Duration: A match lasts 4 minutes."); imgui.BulletText("Prize: The best player receives $110 at the end."); imgui.BulletText("Leave command: [/leavepaintball].")
                                end
                            imgui.EndChild()

                            -- RACING
                            imgui.BeginChild("ArenaRacing_Search", imgui.ImVec2(0, 110), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), "RACING ARENA (ID 35)")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Cerinta: Ai nevoie de permis de conducere.")); imgui.BulletText(u8("Pariuri: Poti paria pe tine intre $500 si $5.000.")); imgui.BulletText(u8("Votare: Ai 30 de secunde pentru a vota harta inainte de start."))
                                else
                                    imgui.BulletText("Requirement: You need a driver's license."); imgui.BulletText("Bets: You can bet on yourself between $500 and $5,000."); imgui.BulletText("Voting: You have 30 seconds to vote for the map before the start.")
                                end
                            imgui.EndChild()

                            -- WAR
                            imgui.BeginChild("ArenaWar_Search", imgui.ImVec2(0, 125), true)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "WAR ARENA (ID 145)")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Cerinte: Permis de conducere si licenta de zbor.")); imgui.BulletText(u8("Vehicule: Poti vota intre Hunter, Rhino sau Hydra.")); imgui.BulletText(u8("Detalii: Runda dureaza 5 minute (fara premiu/clasament).")); imgui.BulletText(u8("Comanda Parasire: [/leavewararena]."))
                                else
                                    imgui.BulletText("Requirements: Driver's license and flying license."); imgui.BulletText("Vehicles: You can vote between Hunter, Rhino, or Hydra."); imgui.BulletText("Details: The round lasts 5 minutes (no prize/ranking)."); imgui.BulletText("Leave command: [/leavewararena].")
                                end
                            imgui.EndChild()

                            -- GUN GAME
                            imgui.BeginChild("ArenaGunGame_Search", imgui.ImVec2(0, 125), true)
                                imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "GUN GAME ARENA (ID 147)")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Cerinta: Necesita licenta de arme activa.")); imgui.BulletText(u8("Capacitate: Maxim 40 de jucatori in arena.")); imgui.BulletText(u8("Regula AFK: Esti scos daca stai AFK peste 1 minut.")); imgui.BulletText(u8("Comanda Parasire: [/leavegungame]."))
                                else
                                    imgui.BulletText("Requirement: Requires an active weapons license."); imgui.BulletText("Capacity: Max 40 players in the arena."); imgui.BulletText("AFK Rule: You are removed if you stay AFK for over 1 minute."); imgui.BulletText("Leave command: [/leavegungame].")
                                end
                            imgui.EndChild()

                            -- LCS
                            imgui.BeginChild("ArenaLCS_Search", imgui.ImVec2(0, 110), true)
                                imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "LAST CAR STANDING (ID 149)")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Cerinta: Ai nevoie de permis de conducere.")); imgui.BulletText(u8("Pariuri: Poti paria pe tine (sistem similar cu Racing).")); imgui.BulletText(u8("Comanda Parasire: [/leavelcs]."))
                                else
                                    imgui.BulletText("Requirement: You need a driver's license."); imgui.BulletText("Bets: You can bet on yourself (system similar to Racing)."); imgui.BulletText("Leave command: [/leavelcs].")
                                end
                            imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Foloseste [/gps] pentru a localiza arenele rapid."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Tip: Use [/gps] to locate arenas quickly.")
                            end

                            elseif bm.id == 12 then -- CNN
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "C N N"  
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- REGULAMENT
                            imgui.BeginChild("CNNRules_Search", imgui.ImVec2(0, 110), true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("REGULAMENT:") or "RULES:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Nivel Minim: Ai nevoie de nivel 3 pentru a publica.")); 
                                    imgui.BulletText(u8("Lungime: Maxim 124 de caractere per anunt.")); 
                                    imgui.BulletText(u8("Marcaj: Locatiile CNN sunt marcate cu litera 'N' albastra."))
                                else
                                    imgui.BulletText("Min Level: You need level 3 to post."); 
                                    imgui.BulletText("Length: Max 124 characters per ad."); 
                                    imgui.BulletText("Marker: CNN locations are marked with a blue 'N'.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            
                            -- COMENZI
                            imgui.BeginChild("CNNCmds_Search", imgui.ImVec2(0, 105), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), iniData.settings.lang == 0 and u8("COMENZI DISPONIBILE:") or "AVAILABLE COMMANDS:")
                                imgui.Separator()
                                imgui.BulletText("/ad [text] - " .. (iniData.settings.lang == 0 and u8("Plaseaza un anunt.") or "Place an ad."))
                                imgui.BulletText("/ads - " .. (iniData.settings.lang == 0 and u8("Vezi anunturile in asteptare.") or "View pending ads."))
                                imgui.BulletText("/myad - " .. (iniData.settings.lang == 0 and u8("Previzualizeaza anuntul tau.") or "Preview your ad."))
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("STUDIURI PE ORASE:") or "STUDIOS BY CITY:")
                            
                            -- STUDIOS
                            local cities = {
                                {"Los Santos", "CNN LS - ID 31", imgui.ImVec4(0.3, 0.7, 1, 1)},
                                {"Las Venturas", "CNN LV - ID 41", imgui.ImVec4(1, 0.8, 0.2, 1)},
                                {"San Fierro", "CNN SF - ID 133", imgui.ImVec4(0.2, 1, 0.2, 1)}
                            }

                            for _, v in ipairs(cities) do
                                imgui.BeginChild("CNN_" .. v[1] .. "_Search", imgui.ImVec2(0, 80), true)
                                    imgui.SetWindowFontScale(1.5)
                                    imgui.SetCursorPosX((w - imgui.CalcTextSize(v[1]).x) / 2)
                                    imgui.TextColored(v[3], v[1])
                                    imgui.SetWindowFontScale(1.0)
                                    imgui.Separator()
                                    imgui.SetCursorPosX((w - imgui.CalcTextSize(v[2]).x) / 2)
                                    imgui.Text(v[2])
                                imgui.EndChild()
                            end
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Informatie: Poti publica anunturi doar daca te afli langa un studio."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Info: You can only post ads if you are near a studio.")
                            end

                            elseif bm.id == 13 then -- RENT
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "R E N T - C A R"  
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- COSTURI SI REGULI
                            imgui.BeginChild("RentGeneralInfo_Search", imgui.ImVec2(0, 105), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("COSTURI SI REGULI:") or "COSTS AND RULES:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Pret fix: $2.000 pe ora (maxim 24 de ore).")); 
                                    imgui.BulletText(u8("Gestiune: Vehiculul apare pe [/v], poate fi localizat sau tractat.")); 
                                    imgui.BulletText(u8("Control: Poti incuia vehiculul folosind tasta 'L' sau [/lock]."))
                                else
                                    imgui.BulletText("Fixed price: $2,000 per hour (max 24 hours)."); 
                                    imgui.BulletText("Management: Vehicle appears on [/v], can be located or towed."); 
                                    imgui.BulletText("Control: You can lock the vehicle using 'L' or [/lock].")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII RENT PE ORASE:") or "RENT LOCATIONS BY CITY:")

                           -- LS
                            imgui.BeginChild("Rent_LS_Search", imgui.ImVec2(0, 100), true)
                                imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Rent Car LS - ID 24")
                                imgui.BulletText("Rent Bike LS - ID 36")  
                            imgui.EndChild()

                            -- LV
                            imgui.BeginChild("Rent_LV_Search", imgui.ImVec2(0, 120), true)
                                imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                                imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Rent Plane LV - ID 148") 
                                imgui.BulletText("Rent Boat LV - ID 40")
                                imgui.BulletText("Rent Car LV - ID 25")
                                imgui.BulletText("Rent Bike LV - ID 67")  
                            imgui.EndChild()

                            -- SF
                            imgui.BeginChild("Rent_SF_Search", imgui.ImVec2(0, 100), true)
                                imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                                imgui.SetWindowFontScale(1.0); imgui.Separator()
                                imgui.BulletText("Rent Car SF - ID 129")
                                imgui.BulletText("Rent Bike SF - ID 130")  
                            imgui.EndChild()

                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Identificare: Locatiile Rent sunt marcate cu o masina alba pe harta."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Identification: Rent locations are marked with a white car icon on the map.")
                            end

                            elseif bm.id == 14 then -- WHITE WEAPONS
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "W H I T E - W E A P O N S"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- DETALII
                            imgui.BeginChild("WhiteWeaponsInfo_Search", imgui.ImVec2(0, 105), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("DETALII:") or "DETAILS:")
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Aceste arme sunt ideale pentru lupte de proximitate (Melee)."))
                                    imgui.BulletText(u8("Pentru a putea cumpara o arma alba dintr-un White Weapon Store, jucatorul va trebui sa mearga"))
                                    imgui.BulletText(u8("la indicatorul din interiorul afacerii si sa apese pe tasta Y."))
                                else
                                    imgui.BulletText("These weapons are ideal for melee combat.")
                                    imgui.BulletText("In order to purchase a white weapon from a White Weapon Store, the player will need to go")
                                    imgui.BulletText("to the indicator inside the business and press the Y key.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CATALOG PRODUSE:") or "PRODUCT CATALOG:")
                            
                            -- CATALOG
                            imgui.BeginChild("WhiteWeaponsCatalog_Search", imgui.ImVec2(0, 165), true)
                                imgui.Columns(3, "whiteGunCols_Search", true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("Arma") or "Weapon"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("Pret") or "Price"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Damage (HP)"); imgui.NextColumn()
                                imgui.Separator()
                                
                                local items = {
                                    {"Katana", "$1.000", "2.6"},
                                    {"Golf Club", "$250", "4.6"},
                                    {"Baseball Bat", "$250", "4.6"},
                                    {iniData.settings.lang == 0 and u8("Lopata") or "Shovel", "$500", "4.6"},
                                    {"Brass Knuckles", "$500", "1.3"}
                                }
                                
                                for _, item in ipairs(items) do
                                    imgui.Text(item[1]); imgui.NextColumn()
                                    imgui.Text(item[2]); imgui.NextColumn()
                                    imgui.Text(item[3]); imgui.NextColumn()
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                            
                            -- LOCATII
                            imgui.BeginChild("WhiteWeaponsLocs_Search", imgui.ImVec2(0, 180), true)
                            local locations = {
                                {"Los Santos", (iniData.settings.lang == 0 and "Magazin LS - ID 153" or "LS Shop - ID 153"), imgui.ImVec4(0.3, 0.7, 1, 1)},
                                {"Las Venturas", (iniData.settings.lang == 0 and "Magazin LV - ID 154" or "LV Shop - ID 154"), imgui.ImVec4(1, 0.8, 0.2, 1)},
                                {"San Fierro", (iniData.settings.lang == 0 and "Magazin SF - ID 155" or "SF Shop - ID 155"), imgui.ImVec4(0.2, 1, 0.2, 1)}
                            }
                            
                            for _, loc in ipairs(locations) do
                                imgui.SetWindowFontScale(1.5)
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(loc[1]).x) / 2)
                                imgui.TextColored(loc[3], loc[1])
                                imgui.SetWindowFontScale(1.0)
                                imgui.SetCursorPosX((w - imgui.CalcTextSize(loc[2]).x) / 2)
                                imgui.Text(loc[2])
                                imgui.Separator()
                            end
                        imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Marcaj: Locatiile sunt reprezentate pe harta printr-o sabie/cutit."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Marker: Locations are marked on the map with a sword/knife icon.")
                            end

                            elseif bm.id == 15 then -- SEX SHOPURI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "S E X - S H O P"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0, 0.6, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- INFO
                            imgui.BeginChild("SexShopInfo_Search", imgui.ImVec2(0, 100), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("INFO:") or "INFO:")
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Articolele pot fi folosite ca obiecte de interactiune sau cadouri."))
                                    imgui.BulletText(u8("Comanda: Foloseste [/buy] odata ce ai intrat in business."))
                                else
                                    imgui.BulletText("Items can be used as interaction objects or gifts.")
                                    imgui.BulletText("Command: Use [/buy] once you entered the business.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CATALOG ARTICOLE:") or "ITEM CATALOG:")
                            
                            -- CATALOG
                            imgui.BeginChild("SexShopCatalog_Search", imgui.ImVec2(0, 155), true)
                                imgui.Columns(2, "sexPriceCols_Search", true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("Articol") or "Item"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("Pret") or "Price"); imgui.NextColumn()
                                imgui.Separator()
                                
                                local items = {
                                    {iniData.settings.lang == 0 and u8("Buchet de Flori") or "Flower Bouquet", "$50"},
                                    {iniData.settings.lang == 0 and u8("Dildo Alb") or "White Dildo", "$100"},
                                    {iniData.settings.lang == 0 and u8("Dildo Mov") or "Purple Dildo", "$150"},
                                    {iniData.settings.lang == 0 and u8("Vibrator Scurt") or "Short Vibrator", "$100"},
                                    {iniData.settings.lang == 0 and u8("Vibrator Lung") or "Long Vibrator", "$150"}
                                }
                                
                                for _, item in ipairs(items) do
                                    imgui.Text(item[1]); imgui.NextColumn()
                                    imgui.Text(item[2]); imgui.NextColumn()
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                            
                            -- LOCATII
                            imgui.BeginChild("SexShopLocs_Search", imgui.ImVec2(0, 180), true)
                                local locations = {
                                    {"Los Santos", (iniData.settings.lang == 0 and "Sex Shop LS - ID 150" or "LS Sex Shop - ID 150"), imgui.ImVec4(0.3, 0.7, 1, 1)},
                                    {"Las Venturas", (iniData.settings.lang == 0 and "Sex Shop LV - ID 151" or "LV Sex Shop - ID 151"), imgui.ImVec4(1, 0.8, 0.2, 1)},
                                    {"San Fierro", (iniData.settings.lang == 0 and "Sex Shop SF - ID 152" or "SF Sex Shop - ID 152"), imgui.ImVec4(0.2, 1, 0.2, 1)}
                                }
                                
                                for _, loc in ipairs(locations) do
                                    imgui.SetWindowFontScale(1.5)
                                    imgui.SetCursorPosX((w - imgui.CalcTextSize(loc[1]).x) / 2)
                                    imgui.TextColored(loc[3], loc[1])
                                    imgui.SetWindowFontScale(1.0)
                                    imgui.SetCursorPosX((w - imgui.CalcTextSize(loc[2]).x) / 2)
                                    imgui.Text(loc[2])
                                    imgui.Separator()
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Informatie: Aceste locatii sunt marcate de obicei cu o buza rosie pe harta."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Info: These locations are usually marked with a red lip icon on the map.")
                            end

                            elseif bm.id == 16 then -- POKER CASINO
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "P O K E R - C A S I N O"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- REGULAMENT
                            imgui.BeginChild("PokerGeneralInfo_Search", imgui.ImVec2(0, 160), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("REGULAMENT SI CONDITII:") or "RULES AND CONDITIONS:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Cerinta: Ai nevoie de minim nivel 3 pentru a juca.")); 
                                    imgui.BulletText(u8("Jucatori: Minim 2, maxim 6 persoane per masa.")); 
                                    imgui.BulletText(u8("Sistem: Texas Hold'em (2 carti in mana, 5 pe masa).")); 
                                    imgui.BulletText(u8("Taxa: Castigatorul primeste 95'/. din pot (5'/. taxa server).")); 
                                    imgui.BulletText(u8("Locatie: Diamond Casino - ID 156"))
                                else
                                    imgui.BulletText("Requirement: You need at least level 3 to play."); 
                                    imgui.BulletText("Players: Min 2, max 6 per table."); 
                                    imgui.BulletText("System: Texas Hold'em (2 hole cards, 5 on the board)."); 
                                    imgui.BulletText("Fee: Winner receives 95'/. of the pot (5'/. server fee)."); 
                                    imgui.BulletText("Location: Diamond Casino - ID 156")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("MESE SI LIMITE DE PARIERE:") or "TABLES AND BETTING LIMITS:")
                            
                            -- MESE
                            imgui.BeginChild("PokerTables_Search", imgui.ImVec2(0, 145), true)
                                imgui.Columns(3, "pokerCols_Search", true)
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), iniData.settings.lang == 0 and u8("Masa") or "Table"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), iniData.settings.lang == 0 and u8("Intrare Min.") or "Min. Buy-in"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), "Big Blind"); imgui.NextColumn()
                                imgui.Separator()
                                
                                local tables = {{"Masa 1-3", "$1", "$100"}, {"Masa 4-7", "$250.000", "$8.000"}, {"Masa 8-10", "$10.000.000", "$50.000"}}
                                for _, t in ipairs(tables) do
                                    imgui.Text(t[1]); imgui.NextColumn(); imgui.Text(t[2]); imgui.NextColumn(); imgui.Text(t[3]); imgui.NextColumn()
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), iniData.settings.lang == 0 and u8("IERARHIA MAINILOR:") or "HAND RANKINGS:")
                            
                            -- MAINILE
                            imgui.BeginChild("PokerHands_Search", imgui.ImVec2(0, 160), true)
                                imgui.Columns(2, "handCols_Search", false)
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Royal Flush (10-A aceeasi culoare)")); imgui.BulletText(u8("Straight Flush (5 in ordine)")); 
                                    imgui.BulletText(u8("Four of a Kind (Careu)")); imgui.BulletText(u8("Full House")); imgui.BulletText(u8("Flush (Culoare)"))
                                    imgui.NextColumn()
                                    imgui.BulletText(u8("Straight (Chinta)")); imgui.BulletText(u8("Three of a Kind (Set)")); 
                                    imgui.BulletText(u8("Two Pairs (Doua perechi)")); imgui.BulletText(u8("One Pair (O pereche)")); imgui.BulletText(u8("High Card"))
                                else
                                    imgui.BulletText("Royal Flush (10-A same suit)"); imgui.BulletText("Straight Flush"); 
                                    imgui.BulletText("Four of a Kind"); imgui.BulletText("Full House"); imgui.BulletText("Flush")
                                    imgui.NextColumn()
                                    imgui.BulletText("Straight"); imgui.BulletText("Three of a Kind"); 
                                    imgui.BulletText("Two Pairs"); imgui.BulletText("One Pair"); imgui.BulletText("High Card")
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Actiuni: Check (Verificare), Bet (Pariere), Fold (Renuntare), All-in."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Actions: Check, Bet, Fold, All-in.")
                            end

                           elseif bm.id == 17 then -- CAR INSURANCE
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = "C A R  I N S U R A N C E"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(0, 0.4, 1, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- REGULAMENT
                            imgui.BeginChild("InsuranceRules_Search", imgui.ImVec2(0, 110), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("REGULAMENT:") or "RULES:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Capacitate: Poti avea maxim 5 asigurari active simultan pe un vehicul."))
                                    imgui.BulletText(u8("Efect: Daca vehiculul este distrus, asigurarea plateste taxa de recuperare."))
                                    imgui.BulletText(u8("Locatie: Car Insurance - ID 157"))
                                else
                                    imgui.BulletText("Capacity: You can have max 5 active insurance policies per vehicle.")
                                    imgui.BulletText("Effect: If the vehicle is destroyed, insurance pays the recovery fee.")
                                    imgui.BulletText("Location: Car Insurance - ID 157")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("COSTUL ASIGURARII (PER UNITATE):") or "INSURANCE COST (PER UNIT):")
                            
                            -- PRETURI
                            imgui.BeginChild("InsurancePrices_Search", imgui.ImVec2(0, 150), true)
                                imgui.Columns(2, "insCols_Search", true)
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), iniData.settings.lang == 0 and u8("Valoare Vehicul (DS)") or "Vehicle Value (DS)"); imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), iniData.settings.lang == 0 and u8("Pret Asigurare") or "Price"); imgui.NextColumn()
                                imgui.Separator()
                                
                                local prices = {
                                    {"Sub $100.000", "$500"},
                                    {"$100.000 - $1.000.000", "$1.000"},
                                    {"$1.000.000 - $6.000.000", "$1.500"},
                                    {"Peste $6M / Non-DS", "$2.000"}
                                }
                                for _, p in ipairs(prices) do
                                    imgui.Text(p[1]); imgui.NextColumn(); imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), p[2]); imgui.NextColumn()
                                end
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            
                            -- COMENZI
                            imgui.BeginChild("InsuranceCmds_Search", imgui.ImVec2(0, 100), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), iniData.settings.lang == 0 and u8("COMENZI UTILE:") or "USEFUL COMMANDS:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("/buyinsurance - Cumpara o asigurare (trebuie sa fii in biz)."))
                                    imgui.BulletText(u8("/v - Verifica numarul de asigurari ramase pe vehicul."))
                                else
                                    imgui.BulletText("/buyinsurance - Buy insurance (must be inside the biz).")
                                    imgui.BulletText("/v - Check remaining insurance policies on vehicle.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing(); imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Asigurarea se consuma automat cand masina explodeaza sau este distrusa."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Tip: Insurance is consumed automatically when the car is destroyed.")
                            end

                            elseif bm.id == 18 then -- PUBG ARENA
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = " P U B G - A R E N A "
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- REGULAMENT
                            imgui.BeginChild("PubGGeneralInfo_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("REGULAMENT SI CONTROL:") or "RULES AND CONTROLS:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Obiectiv: Fii ultimul supravietuitor din arena."))
                                    imgui.BulletText(u8("Control Inventar: Foloseste tasta [Y] sau comanda [/inventory]."))
                                    imgui.BulletText(u8("Start: Meciul incepe cand se aduna numarul minim de jucatori."))
                                    imgui.BulletText(u8("Locatie: PUBG Arena - ID 159"))
                                else
                                    imgui.BulletText("Objective: Be the last survivor in the arena.")
                                    imgui.BulletText("Inventory Control: Use [Y] key or [/inventory] command.")
                                    imgui.BulletText("Start: Match begins when minimum players are reached.")
                                    imgui.BulletText("Location: PUBG Arena - ID 159")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("LOOT SI ECHIPAMENT DISPONIBIL:") or "AVAILABLE LOOT AND GEAR:")
                            
                            -- LOOT
                            imgui.BeginChild("PubGLoot_Search", imgui.ImVec2(0, 130), true)
                                imgui.Columns(2, "lootCols_Search", false)
                                imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), iniData.settings.lang == 0 and u8("MEDICAL / DEFENSE:") or "MEDICAL / DEFENSE:")
                                imgui.BulletText("Medical Kit (+100 HP)")
                                imgui.BulletText(iniData.settings.lang == 0 and u8("Adrenalina (Viteza/HP)") or "Adrenaline (Speed/HP)")
                                imgui.BulletText("Armor Level 1, 2, 3")
                                imgui.NextColumn()
                                imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), iniData.settings.lang == 0 and u8("ARME (WEAPONS):") or "WEAPONS:")
                                imgui.BulletText("Silenced, Deagle")
                                imgui.BulletText("M4, AK47, Rifle")
                                imgui.BulletText("RPG (Rare Loot)")
                                imgui.Columns(1)
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), iniData.settings.lang == 0 and u8("SISTEMUL DE ZONE:") or "ZONE SYSTEM:")
                            
                            -- ZONE
                            imgui.BeginChild("PubGZones_Search", imgui.ImVec2(0, 110), true)
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Safe Zone (Cercul Alb): Esti in siguranta aici."))
                                    imgui.BulletText(u8("Neutral Zone: Esti in afara cercului, dar zona nu a ajuns la tine."))
                                    imgui.BulletText(u8("Danger Zone (Zona Albastra): Pierzi HP constant pana intri in Safe Zone."))
                                    imgui.BulletText(u8("Damage-ul zonei creste pe masura ce meciul avanseaza."))
                                else
                                    imgui.BulletText("Safe Zone (White Circle): You are safe here.")
                                    imgui.BulletText("Neutral Zone: Outside the circle, but the zone hasn't reached you.")
                                    imgui.BulletText("Danger Zone (Blue Zone): You lose constant HP until you enter the Safe Zone.")
                                    imgui.BulletText("Zone damage increases as the match progresses.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Comanda Parasire: /leavepubg (doar in timpul lobby-ului)."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Leave Command: /leavepubg (only during lobby).")
                            end

                           elseif bm.id == 19 then -- CAR COLOR
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = " C A R - C O L O R "
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 0.4, 0.7, 1), title)
                            imgui.SetWindowFontScale(1.0)
                            imgui.Separator()
                            imgui.Spacing()

                            -- DETALII BIZ
                            imgui.BeginChild("CarColorInfo_Search", imgui.ImVec2(0, 120), true)
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("DETALII BIZ:") or "BUSINESS DETAILS:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Locatie: Car Color LS - ID 29"))
                                    imgui.BulletText(u8("Identificare: Marcaj cu litera 'C' de culoare roz pe harta."))
                                    imgui.BulletText(u8("Utilizare: Permite schimbarea culorii primare si secundare."))
                                else
                                    imgui.BulletText("Location: Car Color LS - ID 29")
                                    imgui.BulletText("Identification: Pink 'C' marker on the map.")
                                    imgui.BulletText("Usage: Allows changing primary and secondary colors.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CATEGORII CULORI SI COSTURI:") or "COLOR CATEGORIES AND COSTS:")
                            
                            -- CULORI
                            imgui.BeginChild("ColorCategories_Search", imgui.ImVec2(0, 185), true)
                                if iniData.settings.lang == 0 then
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), u8("CULORI NORMALE (STANDARD):"))
                                    imgui.BulletText(u8("Interval ID-uri: 0 - 127"))
                                    imgui.BulletText(u8("Cost: $500 (Bani in joc)"))
                                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), u8("CULORI HIDDEN (PREMIUM):"))
                                    imgui.BulletText(u8("Interval ID-uri: 128 - 255"))
                                    imgui.BulletText(u8("Cost: 600 Gold (Puncte Premium)"))
                                    imgui.BulletText(u8("Nota: Aceste culori sunt unice si nu se pierd la respawn."))
                                else
                                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "NORMAL COLORS (STANDARD):")
                                    imgui.BulletText("ID Range: 0 - 127")
                                    imgui.BulletText("Cost: $500 (In-game cash)")
                                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), "HIDDEN COLORS (PREMIUM):")
                                    imgui.BulletText("ID Range: 128 - 255")
                                    imgui.BulletText("Cost: 600 Gold (Premium Points)")
                                    imgui.BulletText("Note: These colors are unique and do not disappear on respawn.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            -- CUM SCHIMBI CULOAREA
                            imgui.BeginChild("ColorInstructions_Search", imgui.ImVec2(0, 130), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), iniData.settings.lang == 0 and u8("CUM SCHIMBI CULOAREA:") or "HOW TO CHANGE COLOR:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.TextWrapped(u8("1. Intra in business-ul Car Color (ID 29)."))
                                    imgui.TextWrapped(u8("2. Foloseste [/carcolor (ID 1) (ID 2)] pentru a vopsi masina."))
                                    imgui.TextWrapped(u8("3. Primul ID este culoarea principala, al doilea este cea secundara."))
                                else
                                    imgui.TextWrapped("1. Enter the Car Color business (ID 29).")
                                    imgui.TextWrapped("2. Use [/carcolor (ID 1) (ID 2)] to paint your vehicle.")
                                    imgui.TextWrapped("3. The first ID is the primary color, the second is the secondary one.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Poti testa culorile inainte de a le cumpara definitiv."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Tip: You can test colors before buying them permanently.")
                            end

                            elseif bm.id == 20 then -- ALTE BIZURI
                            local w = imgui.GetWindowWidth() - 40
                            imgui.SetWindowFontScale(1.5)
                            local title = iniData.settings.lang == 0 and "ALTE AFACERI SI SERVICII" or "OTHER BUSINESS AND SERVICES"
                            imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                            imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), title)
                            imgui.SetWindowFontScale(1.2)
                            imgui.Separator()
                            imgui.Spacing()

                            imgui.BeginChild("CommBiz_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), iniData.settings.lang == 0 and u8("COMUNICATII SI INMATRICULARE:") or "COMMUNICATION AND REGISTRATION:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Phone Co. (ID 26): SMS ($2), Apel ($6 / 30s)."))
                                    imgui.BulletText(u8("Car Plating (ID 146): Inmatriculare vehicul ($500)."))
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), u8("Locatie: In apropierea sediului Primariei."))
                                else
                                    imgui.BulletText("Phone Co. (ID 26): SMS ($2), Call ($6 / 30s).")
                                    imgui.BulletText("Car Plating (ID 146): Vehicle registration ($500).")
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), "Location: Near City Hall.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()

                            imgui.BeginChild("HouseHealthBiz_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), iniData.settings.lang == 0 and u8("CASA SI SANATATE:") or "HOUSE AND HEALTH:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("House Upgrade (ID 30): Upgrade interior/Mobila ($1.000)."))
                                    imgui.BulletText(u8("LS Hospital (ID 39): Vindecare dependenta de droguri ($2)."))
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), u8("Nota: Spitalul ofera si tratament pentru HP gratuit."))
                                else
                                    imgui.BulletText("House Upgrade (ID 30): Interior/Furniture upgrade ($1,000).")
                                    imgui.BulletText("LS Hospital (ID 39): Cure drug addiction ($2).")
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), "Note: Hospital also offers free HP treatment.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()

                            imgui.BeginChild("JobBiz_Search", imgui.ImVec2(0, 150), true)
                                imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), iniData.settings.lang == 0 and u8("JOBURI SI PRODUCTIE:") or "JOBS AND PRODUCTION:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Farmer Biz (ID 158): Unelte, seminte si fertilizatori."))
                                    imgui.BulletText(u8("Craftsman Biz (ID 160): Produse tamplarie si materiale."))
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), u8("Necesare pentru a avansa in skill-ul joburilor respective."))
                                else
                                    imgui.BulletText("Farmer Biz (ID 158): Tools, seeds, and fertilizers.")
                                    imgui.BulletText("Craftsman Biz (ID 160): Carpentry products and materials.")
                                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), "Required for job skill progression.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()

                            imgui.BeginChild("MiscBiz_Search", imgui.ImVec2(0, 100), true)
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("ALTE LOCATII:") or "OTHER LOCATIONS:")
                                imgui.Separator()
                                if iniData.settings.lang == 0 then
                                    imgui.BulletText(u8("Towing Co.: Recuperare vehicule tractate."))
                                    imgui.BulletText(u8("Airport Gate: Acces catre hangarele private."))
                                else
                                    imgui.BulletText("Towing Co.: Recover impounded vehicles.")
                                    imgui.BulletText("Airport Gate: Access to private hangars.")
                                end
                            imgui.EndChild()
                            
                            imgui.Spacing()
                            imgui.Separator()
                            if iniData.settings.lang == 0 then
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), u8("Sfat: Foloseste /gps -> Business-uri pentru a vedea lista completa."))
                            else
                                imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), "Tip: Use /gps -> Businesses to see the full list.")
                            end
                        end
                            imgui.TreePop()
                        end
                    end
                end
                imgui.Spacing()
            end

    local shopData = {
        {name = "Cont Premium", nameEN = "Premium Account", keywords = "premium vip gold beneficii cont salariu payday dobanda banca job hours", id_real = 1},
        {name = "Vouchere", nameEN = "Vouchers", keywords = "vouchere voucher plata staff trade expirare", id_real = 2},
        {name = "Cumpara Gold", nameEN = "Buy Gold", keywords = "gold cumpara moneda premium website rpg", id_real = 3},
        {name = "Vehicule Gold", nameEN = "Gold Vehicles", keywords = "vehicule gold masini motor elicoptere infernus bullet turismo dealership", id_real = 4},
        {name = "Hidden Color", nameEN = "Hidden Color", keywords = "hidden color vopsea culori ascunse unic", id_real = 5},
        {name = "Extra Vehicle Slot", nameEN = "Extra Vehicle Slot", keywords = "slot masina garaj extra spatiu", id_real = 6},
        {name = "Resetare KM", nameEN = "Vehicle KM Reset", keywords = "resetare km kilometraj 0", id_real = 7},
        {name = "VIP Car", nameEN = "VIP Car", keywords = "vip car convert text culoare", id_real = 8},
        {name = "Varsta Vehicul", nameEN = "Vehicle Age", keywords = "varsta zile vehicul adauga valoare", id_real = 9},
        {name = "Vehicul 3D Text", nameEN = "Vehicle 3D Text", keywords = "3d text masina personalizat", id_real = 10},
        {name = "Slot Favorite Extra", nameEN = "Extra Favorite Slot", keywords = "favorite slot extra lista", id_real = 11},
        {name = "Placuta Inmatriculare", nameEN = "Colored Vehicle Plate", keywords = "placuta numar inmatriculare culoare", id_real = 12},
        {name = "Interioare Casa", nameEN = "House Interiors", keywords = "interior casa locuinta decorare", id_real = 13},
        {name = "Garaj Casa", nameEN = "House Garage", keywords = "garaj casa locuinta storage sloturi masini", id_real = 14},
        {name = "Clanuri", nameEN = "Clans", keywords = "clan clanuri membri tag factiune teritoriu nivel", id_real = 15},
        {name = "Schimbare Nume & Tag", nameEN = "Clan Name & Tag Change", keywords = "schimbare tag nume clan identitate", id_real = 16},
        {name = "Culoare Clan", nameEN = "Clan Color", keywords = "culoare clan hex tag hq perete teritoriu", id_real = 17},
        {name = "Revendicare HQ", nameEN = "Clan HQ Claim", keywords = "revendicare hq claim locatie sediu clan", id_real = 18},
        {name = "Interior HQ Clan", nameEN = "Clan HQ Interior", keywords = "interior hq clan design decorare aspect", id_real = 19},
        {name = "Clear Faction Punish", nameEN = "Clear Faction Punish", keywords = "clear faction punish fp stergere penalitate", id_real = 20},
        {name = "Schimbare Nume", nameEN = "Change Nickname", keywords = "schimbare nick nume player identitate", id_real = 21},
        {name = "Sterge Avertisment", nameEN = "Clear Warn", keywords = "sterge warn avertisment reputatie", id_real = 22},
        {name = "Schimbare Sex", nameEN = "Change Sex", keywords = "schimbare sex skin gender personaj", id_real = 23},
        {name = "Safebox", nameEN = "Safebox", keywords = "safebox seif depozit arme materiale droguri storage", id_real = 24},
        {name = "Maraton", nameEN = "Marathon", keywords = "maraton eveniment lunar puncte premii obiective", id_real = 25},
        {name = "Frecventa Privata", nameEN = "Private Frequency", keywords = "frecventa privata radio comunicare parola excluderi", id_real = 26}
    }
            local shopMatches = {}
            for _, sh in ipairs(shopData) do
                local matchNameRO = sh.name:lower():find(current_search, 1, true)
                local matchNameEN = sh.nameEN:lower():find(current_search, 1, true)
                local matchKeywords = sh.keywords:lower():find(current_search, 1, true)
                
                if matchNameRO or matchNameEN or matchKeywords then
                    table.insert(shopMatches, {name = sh.name, nameEN = sh.nameEN, id = sh.id_real})
                end
            end

        if #shopMatches > 0 then
        foundAny = true
        local shopHeaderLabel = iniData.settings.lang == 0 and ("Rezultate din: Categorii Shop (" .. #shopMatches .. ")") or ("Results from: Shop Categories (" .. #shopMatches .. ")")
        
        if imgui.CollapsingHeader(u8(shopHeaderLabel)) then
            for _, sh in ipairs(shopMatches) do
                local displayName = iniData.settings.lang == 0 and sh.name or sh.nameEN
                if imgui.TreeNodeStr(u8(displayName) .. " ##global_shop_" .. sh.id) then
                    
                    if sh.id == 1 then -- CONT PREMIUM
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "C O N T   P R E M I U M" or "P R E M I U M   A C C O U N T"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("PremiumIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Cu totii incepem de la aceleasi statistici, insa pe parcurs, daca doriti sa dispuneti de si mai multe facilitati pe serverele B-Zone RPG, trebuie sa achizitionati un astfel de pachet. Folositi comanda /shop.") 
                            or "We all start from the same stats, but along the way, if you want more perks on B-Zone RPG servers, you must purchase a premium package. Use /shop in-game.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PACHETE DISPONIBILE:") or "AVAILABLE PACKAGES:")
                    
                    imgui.BeginChild("PremiumPackages", imgui.ImVec2(0, 130), true)
                        imgui.Text(iniData.settings.lang == 0 and 
                            u8("1 Saptamana [Trial]: Gratuit (O singura data)\n1 Saptamana: 90 Gold\n1 Luna: 320 Gold\n3 Luni: 840 Gold\n6 Luni: 1600 Gold\n1 An: 3000 Gold") 
                            or "1 Week [Trial]: Free (Once only)\n1 Week: 90 Gold\n1 Month: 320 Gold\n3 Months: 840 Gold\n6 Months: 1600 Gold\n1 Year: 3000 Gold")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("BENEFICII:") or "BENEFITS:")
                    
                    imgui.BeginChild("PremiumBenefits", imgui.ImVec2(0, 0), true)
                        local benefits = (iniData.settings.lang == 0) and {
                            "Dobanda banca: 0.01 -> 0.03", "Salariu payday: +25'/.", "Bani joburi: +50'/.",
                            "Bonus 5 ore: Respect, Jaf, Evadare, Accept, -1 FP", "Respect: Nu se pierde la /buylevel",
                            "Vehicule sport: Acces Turismo, Bullet, Infernus etc.", "Limite: Jaf (20), Evadare (40), Accept (300)",
                            "Comanda /mp3 oriunde", "Combustibil: pana la 150'/.", "Race: miza pana la $2000", "Friends list: pana la 60 sloturi"
                        } or {
                            "Bank interest: 0.01 -> 0.03", "Payday salary: +25'/.", "Job money: +50'/.",
                            "5-hour bonus: Respect, Rob, Escape, Accept, -1 FP", "Respect: No loss on /buylevel",
                            "Sport vehicles: Access to Turismo, Bullet, Infernus etc.", "Limits: Rob (20), Escape (40), Accept (300)",
                            "Command /mp3 anywhere", "Fuel: up to 150'/.", "Race: stake up to $2000", "Friends list: up to 60 slots"
                        }
                        
                        for _, b in ipairs(benefits) do
                            imgui.BulletText(u8(b))
                        end
                    imgui.EndChild()
                        
                    elseif sh.id == 2 then -- VOUCHERE
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "V O U C H E R E" or "V O U C H E R S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("VoucherInfo", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Voucherele reprezinta o forma de plata pentru jucatori. Membrii STAFF (lideri/helperi/admini) NU primesc vouchere ca plata lunara.") or 
                            "Vouchers are a form of payment for players. STAFF members (leaders/helpers/admins) DO NOT receive vouchers as monthly payment.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CARACTERISTICI GENERALE:") or "GENERAL FEATURES:")
                    
                    imgui.BeginChild("VoucherFeatures", imgui.ImVec2(0, 130), true)
                        local features = (iniData.settings.lang == 0) and {
                            "Valabilitate: Maxim 6 luni.",
                            "Notificare: Ai 7 zile pana la expirare.",
                            "Trade: Se pot vinde prin [/trade] de maxim 2 ori.",
                            "Dupa 2 trade-uri, ramane definitiv pe cont.",
                            "Cele ce expira in 24h sunt marcate cu rosu."
                        } or {
                            "Validity: Max 6 months.",
                            "Notification: You get 7 days before expiration.",
                            "Trade: Can be sold via [/trade] max 2 times.",
                            "After 2 trades, it remains permanently on the account.",
                            "Those expiring in 24h are marked in red."
                        }
                        for _, f in ipairs(features) do imgui.BulletText(u8(f)) end
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("COMENZI:") or "COMMANDS:")
                    imgui.BeginChild("VoucherCmds", imgui.ImVec2(0, 70), true)
                        imgui.BulletText("/voucher, /vouchers, /vouchere")
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Dialogul ofera paginatie (<<< >>>) pentru mai multe vouchere.") or 
                            "The dialog offers pagination (<<< >>>) for multiple vouchers.")
                    imgui.EndChild()
                        
                    elseif sh.id == 3 then -- CUMPARA GOLD
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "C U M P A R A   G O L D" or "B U Y   G O L D"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("GoldIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Principala sursa de procurare a goldului (moneda premium) este reprezentata de RPG Website.") 
                            or "The main source for acquiring gold (the premium currency) is the RPG Website.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PASI CUMPARARE:") or "PURCHASE STEPS:")
                    
                    imgui.BeginChild("GoldSteps", imgui.ImVec2(0, 180), true)
                        if iniData.settings.lang == 0 then
                            imgui.TextWrapped(u8("1. Conecteaza-te pe website-ul RPG si da click pe iconita cosului."))
                            imgui.TextWrapped(u8("2. Completeaza datele de facturare (doar prima data)."))
                            imgui.TextWrapped(u8("3. Mergi inapoi si apasa pe butonul galben 'Buy Gold'."))
                            imgui.TextWrapped(u8("4. Adauga pachetele dorite in cos, specifica jucatorul si metoda de plata."))
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), u8("Nota: Poti folosi ulterior [/shop] sau [/buyvehicle] pentru a consuma Gold-ul."))
                        else
                            imgui.TextWrapped("1. Log in to the RPG website and click on the shopping cart icon.")
                            imgui.TextWrapped("2. Fill in your billing info (only required once).")
                            imgui.TextWrapped("3. Go back and click the yellow 'Buy Gold' button.")
                            imgui.TextWrapped("4. Add desired packages to your cart, specify the player and payment method.")
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Note: You can later use [/shop] or [/buyvehicle] to spend your Gold.")
                        end
                    imgui.EndChild()

                    elseif sh.id == 4 then -- GOLD VEHICLES
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "V E H I C U L E   G O L D" or "G O L D   V E H I C L E S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("GoldIntro", imgui.ImVec2(0, 55), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Mai jos gasiti vehiculele serverului ce pot fi achizitionate cu Gold. Vehiculele nu pot fi vandute jucatorilor, doar returnate DealerShip-ului pentru 40'/. din valoare. Nu este necesar cont premium.") 
                            or "Below you can find the server vehicles that can be purchased with Gold. Vehicles cannot be sold to players, only returned to the Dealership for 40'/. of their value. Premium account is not required.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("LISTA VEHICULE:") or "VEHICLE LIST:")
                    
                    imgui.BeginChild("GoldList", imgui.ImVec2(0, 300), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("MASINI:") or "CARS:")
                        imgui.Separator()
                        local cars = {"Buffalo: 2.149", "Premier: 299", "Sabre: 1.699", "Comet: 1.949", "Sandking: 1.599", "Super GT: 1.899", "Feltzer: 999", "Jester: 1.799", "Sultan: 2.199", "Elegy: 2.099", "Cheetah: 2.299", "Bullet: 2.849", "Infernus: 2.999", "Turismo: 2.499", "Banshee: 2.599", "Monster Truck: 3.799", "Hotring: 3.799"}
                        for _, car in ipairs(cars) do imgui.Text(car) end
                        
                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("MOTO / BICICLETE:") or "MOTO / BIKES:")
                        imgui.Text("Freeway: 649 | FCR-900: 899 | NRG-500: 1.899")
                        
                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), iniData.settings.lang == 0 and u8("ELICOPTERE:") or "HELICOPTERS:")
                        imgui.Text("Sparrow: 2.399 | Maverick: 4.999")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("LEGENDA:") or "LEGEND:")
                    
                    imgui.BeginChild("GoldLegend", imgui.ImVec2(0, 0), true)
                        local legend = (iniData.settings.lang == 0) and {
                            "Pret Dealership: Pretul bunului cumparat.",
                            "Refund: 40 la suta din valoare inapoi la DealerShip.",
                            "Viteza maxima: Limita vehiculului.",
                            "Numar de locuri: Capacitate maxima.",
                            "Tunabil: Numele tuning-ului sau 'Nu este tunabil'."
                        } or {
                            "Dealership Price: The purchase price.",
                            "Refund: 40 '/. of value back at the Dealership.",
                            "Max Speed: The vehicle's speed limit.",
                            "Seats: Maximum capacity.",
                            "Tunable: Tuning name or 'Not tunable'."
                        }
                        for _, l in ipairs(legend) do imgui.BulletText(u8(l)) end
                    imgui.EndChild()

                    elseif sh.id == 5 then -- HIDDEN COLOR
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "H I D D E N   C O L O R" or "H I D D E N   C O L O R"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    -- Introducere
                    imgui.BeginChild("HiddenIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Daca doresti o culoare aparte, speciala, pentru vehiculul tau, trebuie sa cumperi un set de culori ascunse (hidden). Pret: 600 Gold.") 
                            or "If you want a special, unique color for your vehicle, you must buy a set of hidden colors. Price: 600 Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("DETALII:") or "DETAILS:")
                    
                    imgui.BeginChild("HiddenDetails", imgui.ImVec2(0, 90), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold (vezi [/shop]).") or "Price: 600 Gold (see [/shop]).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Durata: Permanent (pana la vanzarea vehiculului).") or "Duration: Permanent (until the vehicle is sold).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Daca vinzi vehiculul, culorile dispar.") or "If you sell the vehicle, the colors disappear.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI (PASI):") or "HOW TO BUY (STEPS):")
                    
                    imgui.BeginChild("HiddenSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza [/shop] si selecteaza 'Hidden color'.",
                            "Apasati butonul 'Order'.",
                            "Anulati orice checkpoint rosu existent [/cancel checkpoint].",
                            "Mergeti la checkpointul rosu primit (CarColor biz).",
                            "Folositi [/hiddencolor] langa biz.",
                            "Selectati culorile si apasati 'Buy Color'."
                        } or {
                            "Access [/shop] and select 'Hidden color'.",
                            "Press the 'Order' button.",
                            "Cancel any active red checkpoint [/cancel checkpoint].",
                            "Go to the red checkpoint (CarColor biz).",
                            "Use [/hiddencolor] near the biz.",
                            "Select colors and press 'Buy Color'."
                        }
                        for _, s in ipairs(steps) do
                            imgui.BulletText(u8(s))
                        end
                    imgui.EndChild()

                    elseif sh.id == 6 then -- EXTRA VEHICLE SLOT
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "E X T R A   V E H I C L E   S L O T" or "E X T R A   V E H I C L E   S L O T"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("SlotIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Garajul standard este limitat la 4 vehicule. Daca ai nevoie de mai mult spatiu, poti extinde capacitatea acestuia folosind Gold prin comanda /shop.") 
                            or "The standard garage is limited to 4 vehicles. If you need more space, you can expand its capacity using Gold via the /shop command.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("DURATA SI PRET:") or "DURATION AND PRICE:")
                    
                    imgui.BeginChild("SlotDetails", imgui.ImVec2(0, 70), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 800 Gold pentru un slot suplimentar.") or "Price: 800 Gold for an additional slot.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Durata: Permanent.") or "Duration: Permanent.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("SlotSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Extra vehicle slot - 800 Gold'.",
                            "Citeste informatiile afisate pe ecran.",
                            "Apasati butonul 'Order'.",
                            "Slotul va fi adaugat instantaneu garajului tau."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Extra vehicle slot - 800 Gold'.",
                            "Read the information displayed on the screen.",
                            "Press the 'Order' button.",
                            "The slot will be added to your garage instantly."
                        }
                        for _, s in ipairs(steps) do
                            imgui.BulletText(u8(s))
                        end
                    imgui.EndChild()

                    elseif sh.id == 7 then -- VEHICLE KM RESET
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "R E S E T A R E   K M   V E H I C U L" or "V E H I C L E   K M   R E S E T"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("KMIntro", imgui.ImVec2(0, 90), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Doresti sa scapi de kilometrii parcursi si sa vinzi masina mai usor? Reseteaza kilometrajul la 0 si fa-o sa para ca noua!") 
                            or "Do you want to get rid of the miles driven and sell your car easier? Reset the mileage to 0 and make it look like new!")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET:") or "PRICE:")
                    
                    imgui.BeginChild("KMPrice", imgui.ImVec2(0, 45), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pretul resetarii kilometrajului este de 600 Gold.") or "The price for resetting the mileage is 600 Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("KMSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Vehicle KM Reset - 600 Gold'.",
                            "Citeste informatiile afisate pe ecran.",
                            "Apasati butonul 'Order'.",
                            "Kilometrajul vehiculului va fi resetat instantaneu la 0."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Vehicle KM Reset - 600 Gold'.",
                            "Read the information displayed on the screen.",
                            "Press the 'Order' button.",
                            "The vehicle's mileage will be instantly reset to 0."
                        }
                        for _, s in ipairs(steps) do
                            imgui.BulletText(u8(s))
                        end
                    imgui.EndChild()

                    elseif sh.id == 8 then -- VIP CAR
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "V I P   C A R" or "V I P   C A R"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("VIPIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Doresti un vehicul unic cu text personalizat? Converteste-ti masina intr-un vehicul VIP. Textul si culoarea pot fi modificate ulterior oricand!") 
                            or "Want a unique vehicle with custom text? Convert your car into a VIP vehicle. Text and color can be changed anytime later!")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET SI DURATA:") or "PRICE AND DURATION:")
                    
                    imgui.BeginChild("VIPDetails", imgui.ImVec2(0, 75), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Durata: Pana la vanzarea vehiculului (se pierde la vanzare).") or "Duration: Until the vehicle is sold (lost upon sale).")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("VIPSteps", imgui.ImVec2(0, 120), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza [/v] si alege vehiculul dorit.",
                            "Selecteaza 'Convert to VIP car (600 Gold)'.",
                            "Citeste informatiile si apasa 'Yes'.",
                            "Editeaza textul si culoarea din meniul [/v]."
                        } or {
                            "Access [/v] and choose your vehicle.",
                            "Select 'Convert to VIP car (600 Gold)'.",
                            "Read the info and press 'Yes'.",
                            "Edit text and color from the [/v] menu."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextWrapped(iniData.settings.lang == 0 and 
                        u8("Nota: Vehiculele eligibile includ: Infernus, Bullet, Banshee, NRG-500, Sultan si multe altele (verifica lista completa in /v).") 
                        or "Note: Eligible vehicles include: Infernus, Bullet, Banshee, NRG-500, Sultan and many others (check full list in /v).")

                elseif sh.id == 9 then -- VEHICLE AGE
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "V A R S T A   V E H I C U L" or "V E H I C L E   A G E"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("AgeIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Creste valoarea vehiculului tau adaugandu-i zile la varsta totala. Un vehicul mai vechi este mai pretios si mai atragator pentru cumparatori!") 
                            or "Increase the value of your vehicle by adding days to its total age. An older vehicle is more valuable and attractive to buyers!")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PACHETE SI PRETURI:") or "PACKAGES AND PRICES:")
                    
                    imgui.BeginChild("AgePackages", imgui.ImVec2(0, 100), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("+ 30 zile: 400 Gold") or "+ 30 days: 400 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("+ 180 zile: 2.000 Gold") or "+ 180 days: 2,000 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("+ 365 zile: 4.000 Gold") or "+ 365 days: 4,000 Gold")
                        imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), iniData.settings.lang == 0 and u8("* Zilele raman permanent adaugate.") or "* Days are added permanently.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("AgeSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza garajul tau folosind [/vehicles].",
                            "Selecteaza unul dintre cele 3 pachete disponibile.",
                            "Citeste informatiile despre procesul de cumparare.",
                            "Apasati butonul 'Order'.",
                            "Zilele vor fi adaugate instantaneu la varsta vehiculului."
                        } or {
                            "Access your garage using [/vehicles].",
                            "Select one of the 3 available packages.",
                            "Read the information about the purchase process.",
                            "Press the 'Order' button.",
                            "The days will be added instantly to your vehicle's age."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 10 then -- VEHICLE 3D TEXT
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "V E H I C U L   C U   3 D   T E X T" or "V E H I C L E   3 D   T E X T"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    -- Introducere
                    imgui.BeginChild("3DTextIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Adauga un text personalizat vizibil oricui pe vehiculul tau! Textul este dinamic si poate fi pozitionat oriunde in jurul masinii.") 
                            or "Add a custom text visible to everyone on your vehicle! The text is dynamic and can be positioned anywhere around the car.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("DETALII SI REGULI:") or "DETAILS AND RULES:")
                    
                    imgui.BeginChild("3DTextDetails", imgui.ImVec2(0, 150), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Maxim 60 de caractere.") or "Maximum 60 characters.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pozitie: Raza de 10 unitati (0-10).") or "Position: 10 unit radius (0-10).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Format culori: {RRGGBB}Text.") or "Color format: {RRGGBB}Text.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Nota: Se pierde la vanzarea vehiculului.") or "Note: Lost upon vehicle sale.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM ADAUGI / MODIFICI:") or "HOW TO ADD / MODIFY:")
                    
                    imgui.BeginChild("3DTextSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Foloseste [/vehicles] si alege vehiculul dorit.",
                            "Selecteaza 'Adauga 3D text pe masina'.",
                            "Modifica Text/Culoare/Pozitie direct din meniul [/vehicles].",
                            "Foloseste coduri RGB intre acolade {} pentru culori."
                        } or {
                            "Use [/vehicles] and choose your vehicle.",
                            "Select 'Add 3D text to car'.",
                            "Modify Text/Color/Position directly from [/vehicles].",
                            "Use RGB codes inside {} for colors."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 11 then -- EXTRA FAVORITE SLOT
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "S L O T   F A V O R I T E   E X T R A" or "E X T R A   F A V O R I T E   S L O T"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("FavIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Doresti sa adaugi mai multe vehicule in lista ta de favorite? Poti cumpara sloturi suplimentare pentru lista de vehicule favorite folosind Gold.") 
                            or "Want to add more vehicles to your favorites list? You can purchase additional slots for the favorite vehicles list using Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET:") or "PRICE:")
                    
                    imgui.BeginChild("FavPrice", imgui.ImVec2(0, 45), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 300 Gold per slot.") or "Price: 300 Gold per slot.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("FavSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza 'Extra Favorite Slot - 300 Gold'.",
                            "Confirma achizitia in dialogul aparut.",
                            "Apasati butonul 'Order'.",
                            "Vei primi instantaneu un slot in plus in lista de favorite."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select 'Extra Favorite Slot - 300 Gold'.",
                            "Confirm the purchase in the dialog that appears.",
                            "Press the 'Order' button.",
                            "You will instantly receive an extra slot in your favorites list."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 12 then -- VEHICLE COLORED PLATE
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "P L A C U T A   C O L O R A T A" or "C O L O R E D   P L A T E"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("PlateIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Personalizeaza numarul de inmatriculare al vehiculului tau alegand o culoare unica. Textul si culoarea pot fi modificate ulterior.") 
                            or "Customize your vehicle's license plate by choosing a unique color. The text and color can be modified later.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CARACTERISTICI:") or "FEATURES:")
                    
                    imgui.BeginChild("PlateDetails", imgui.ImVec2(0, 130), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 300 Gold.") or "Price: 300 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Maxim 10 caractere (fara caractere speciale).") or "Max 10 characters (no special characters).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Se pierde la vanzarea vehiculului.") or "Lost upon vehicle sale.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Format culori: {RRGGBB} intre acolade.") or "Color format: {RRGGBB} inside braces.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM ADAUGI / MODIFICI:") or "HOW TO ADD / MODIFY:")
                    
                    imgui.BeginChild("PlateSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Foloseste [/vehicles] si alege vehiculul dorit.",
                            "Selecteaza 'Adauga placuta de inmatriculare colorata'.",
                            "Foloseste optiunea 'Schimba placuta de Inmatriculare'.",
                            "Modifica textul, alege culoare RGB sau din paleta prestabilita."
                        } or {
                            "Use [/vehicles] and choose your vehicle.",
                            "Select 'Add colored license plate'.",
                            "Use the 'Change license plate' option.",
                            "Modify text, choose RGB color or from the preset palette."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 13 then -- HOUSE INTERIORS
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "I N T E R I O A R E   C A S A" or "H O U S E   I N T E R I O R S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("HouseIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Infrumuseteaza-ti locuinta cu unul dintre cele aproximativ 40 de interioare disponibile. Un interior nou te va face cel mai invidiat vecin!") 
                            or "Beautify your home with one of the 40+ available interiors. A new interior will make you the most envied neighbor!")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PACHETE SI PRETURI:") or "PACKAGES AND PRICES:")
                    
                    imgui.BeginChild("HousePackages", imgui.ImVec2(0, 120), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Interior Mic: 1.400 Gold (6 variante)") or "Small Interior: 1,400 Gold (6 variants)")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Interior Mediu: 2.000 Gold (24 variante)") or "Medium Interior: 2,000 Gold (24 variants)")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Interior Mare: 2.600 Gold (10 variante)") or "Big Interior: 2,600 Gold (10 variants)")
                        imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), iniData.settings.lang == 0 and u8("* Interiorul este permanent, dar se reseteaza la vanzare.") or "* Interior is permanent, but resets upon sale.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("HouseSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Trebuie sa fii in exteriorul casei.",
                            "Acceseaza [/shop] si alege pachetul dorit.",
                            "Apasati butonul 'Order'.",
                            "Alege interiorul preferat din lista si apasa 'Select'."
                        } or {
                            "You must be outside the house.",
                            "Access [/shop] and choose your preferred package.",
                            "Press the 'Order' button.",
                            "Choose the interior from the list and press 'Select'."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 14 then -- HOUSE GARAGE
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "G A R A J   C A S A" or "H O U S E   G A R A G E"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("GarageIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Detinatorii de case pot achizitiona garaje speciale pentru a-si adaposti vehiculele in siguranta. Garajul se plaseaza in locatia curenta.") 
                            or "Homeowners can purchase special garages to shelter their vehicles safely. The garage is placed at your current location.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("TIPURI SI PRETURI:") or "TYPES AND PRICES:")
                    
                    imgui.BeginChild("GaragePackages", imgui.ImVec2(0, 100), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Garaj Mic (4 sloturi): 1.000 Gold") or "Small Garage (4 slots): 1,000 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Garaj Mediu (8 sloturi): 1.600 Gold") or "Medium Garage (8 slots): 1,600 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Garaj Mare (12 sloturi): 2.400 Gold") or "Big Garage (12 slots): 2,400 Gold")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), iniData.settings.lang == 0 and u8("ATENTIE:") or "WARNING:")
                    imgui.TextWrapped(iniData.settings.lang == 0 and 
                        u8("Pozitia este definitiva! Nu exista optiune de editare ulterior. Garajul dispare la vanzarea casei.") 
                        or "Position is final! There is no edit option later. The garage disappears upon selling the house.")

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("GarageSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza [/shop] si alege tipul de garaj.",
                            "Pozitioneaza-te unde vrei sa fie intrarea.",
                            "Citeste cu atentie informatiile despre plasare.",
                            "Apasati butonul 'Order' pentru a finaliza."
                        } or {
                            "Access [/shop] and choose the garage type.",
                            "Position yourself where you want the entrance.",
                            "Read carefully the placement information.",
                            "Press the 'Order' button to finish."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 15 then -- CLANS
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "C L A N U R I" or "C L A N S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("ClanIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Grupeaza-te cu prietenii tai si creati propriul clan! Beneficiati de sisteme de teritorii, socializare si posibilitati de castig.") 
                            or "Group up with your friends and create your own clan! Benefit from territory systems, social networking, and earning possibilities.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PACHETE (30 ZILE):") or "PACKAGES (30 DAYS):")
                    
                    imgui.BeginChild("ClanPackages", imgui.ImVec2(0, 130), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Small Clan (15 sloturi): 2.000 Gold") or "Small Clan (15 slots): 2,000 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Medium Clan (25 sloturi): 3.000 Gold") or "Medium Clan (25 slots): 3,000 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Big Clan (50 sloturi): 4.000 Gold") or "Big Clan (50 slots): 4,000 Gold")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Mega Clan (75 sloturi): 5.500 Gold") or "Mega Clan (75 slots): 5,500 Gold")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("ClanSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza [/shop] si alege pachetul dorit.",
                            "Apasati butonul 'Order'.",
                            "Introdu numele si tag-ul clanului (fara paranteze).",
                            "Re-logheaza-te pe server pentru sincronizare.",
                            "Contacteaza un admin forum pentru sectiunea speciala."
                        } or {
                            "Access [/shop] and choose the desired package.",
                            "Press the 'Order' button.",
                            "Enter the clan name and tag (without brackets).",
                            "Re-log on the server for synchronization.",
                            "Contact a forum admin for the special section."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 16 then -- CLAN NAME & TAG CHANGE
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "S C H I M B A R E   N U M E   &   T A G" or "C L A N   N A M E   &   T A G   C H A N G E"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("ClanChangeIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Doresti un rebranding pentru clanul tau? Poti schimba numele si tag-ul acestuia direct din shop pentru 600 Gold.") 
                            or "Want a rebranding for your clan? You can change its name and tag directly from the shop for 600 Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("REGULI SI LIMITE:") or "RULES AND LIMITS:")
                    
                    imgui.BeginChild("ClanChangeDetails", imgui.ImVec2(0, 130), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Nume clan: 1-22 caractere.") or "Clan name: 1-22 characters.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("TAG clan: 1-4 caractere.") or "Clan TAG: 1-4 characters.")
                        imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), iniData.settings.lang == 0 and 
                            u8("Atentie: Numele vulgare pot duce la stergerea clanului!") or "Warning: Vulgar names can lead to clan deletion!")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM SCHIMBI:") or "HOW TO CHANGE:")
                    
                    imgui.BeginChild("ClanChangeSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza 'Clan Name+Tag Change'.",
                            "Confirma achizitia in dialogul aparut.",
                            "Introdu noul nume dorit.",
                            "Introdu noul TAG dorit."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select 'Clan Name+Tag Change'.",
                            "Confirm the purchase in the dialog that appears.",
                            "Enter the desired new name.",
                            "Enter the desired new TAG."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 17 then -- CLAN COLOR
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "C U L O A R E   C L A N" or "C L A N   C O L O R"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    -- Introducere
                    imgui.BeginChild("ClanColorIntro", imgui.ImVec2(0, 90), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Personalizeaza identitatea vizuala a clanului tau! Culoarea se aplica la tag, nume, peretii HQ-ului si teritorii.") 
                            or "Customize your clan's visual identity! The color applies to the tag, name, HQ walls, and territories.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET SI INFORMATII:") or "PRICE AND INFO:")
                    
                    imgui.BeginChild("ClanColorDetails", imgui.ImVec2(0, 100), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Prima schimbare: Gratuit.") or "First change: Free.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret ulterior: 400 Gold.") or "Subsequent price: 400 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Format necesar: Cod HEX (ex: 3399FF).") or "Required format: HEX code (e.g., 3399FF).")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM SCHIMBI CULOAREA:") or "HOW TO CHANGE COLOR:")
                    
                    imgui.BeginChild("ClanColorSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Foloseste comanda [/clancolor] in joc.",
                            "Alege codul HEX al culorii dorite (foloseste un 'HEX Picker').",
                            "Introdu comanda in format: [/clancolor COD_HEX].",
                            "Verifica previzualizarea si apasa 'Yes' pentru confirmare."
                        } or {
                            "Use command [/clancolor] in-game.",
                            "Choose the HEX code for the desired color (use a 'HEX Picker').",
                            "Enter the command as: [/clancolor HEX_CODE].",
                            "Check the preview and press 'Yes' to confirm."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 18 then -- CLAN HQ CLAIM
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "R E V E N D I C A R E   H Q" or "C L A N   H Q   C L A I M"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("HQIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Schimba locatia HQ-ului clanului tau! Poti alege dintr-o varietate de 71 de HQ-uri disponibile pe harta.") 
                            or "Change your clan's HQ location! You can choose from a variety of 71 available HQs on the map.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CONDITII:") or "REQUIREMENTS:")
                    
                    imgui.BeginChild("HQDetails", imgui.ImVec2(0, 110), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Nivel clan minim: 5.") or "Minimum clan level: 5.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Prima revendicare: Gratuit (la atingerea nivelului 5).") or "First claim: Free (at reaching level 5).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Verifica creditele cu [/claninfo].") or "Check credits with [/claninfo].")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM REVENDICI:") or "HOW TO CLAIM:")
                    
                    imgui.BeginChild("HQSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Cumpara 'HQ Claim' din [/shop].",
                            "Mergi la intrarea HQ-ului dorit.",
                            "Foloseste comanda [/claimhq] pentru a-l revendica.",
                            "HQ-ul va deveni proprietatea clanului tau."
                        } or {
                            "Purchase 'HQ Claim' from [/shop].",
                            "Go to the entrance of the desired HQ.",
                            "Use command [/claimhq] to claim it.",
                            "The HQ will become your clan's property."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 19 then -- CLAN HQ INTERIOR
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "I N T E R I O R   H Q   C L A N" or "C L A N   H Q   I N T E R I O R"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("HQIntIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Schimba aspectul interior al HQ-ului tau cu unul dintre interioarele predefinite disponibile, in functie de nivelul clanului tau.") 
                            or "Change the interior look of your HQ with one of the available predefined interiors, depending on your clan's level.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("CONDITII:") or "REQUIREMENTS:")
                    
                    imgui.BeginChild("HQIntDetails", imgui.ImVec2(0, 110), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Nivel clan minim: 7.") or "Minimum clan level: 7.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Primul interior: Gratuit (la nivelul 7).") or "First interior: Free (at level 7).")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Verifica creditele cu [/claninfo].") or "Check credits with [/claninfo].")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM MODIFICI INTERIORUL:") or "HOW TO CHANGE INTERIOR:")
                    
                    imgui.BeginChild("HQIntSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Cumpara 'Clan HQ Interior' din [/shop].",
                            "Pozitioneaza-te in fata HQ-ului tau.",
                            "Foloseste comanda [/interiorhq].",
                            "Alege interiorul dorit din lista si apasa 'Yes'."
                        } or {
                            "Purchase 'Clan HQ Interior' from [/shop].",
                            "Position yourself in front of your HQ.",
                            "Use command [/interiorhq].",
                            "Choose the desired interior from the list and press 'Yes'."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 20 then -- CLEAR FACTION PUNISH
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "C L E A R   F A C T I O N   P U N I S H" or "C L E A R   F A C T I O N   P U N I S H"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("FPIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Ai primit Faction Punish si vrei sa intri mai repede intr-o factiune? Poti sterge 10 puncte de FP direct din shop.") 
                            or "Did you get Faction Punish and want to join a faction faster? You can clear 10 FP points directly from the shop.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                    
                    imgui.BeginChild("FPDetails", imgui.ImVec2(0, 75), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 200 Gold pentru 10 puncte FP.") or "Price: 200 Gold for 10 FP points.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Taxa fixa: Chiar daca ai sub 10 puncte, pretul ramane 200 Gold.") or "Fixed fee: Even if you have less than 10 points, the price is 200 Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("FPSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Clear 10 FP - 200 Gold'.",
                            "Citeste informatiile afisate pe ecran.",
                            "Apasati butonul 'Order'.",
                            "Punctele de FP vor fi sterse instantaneu."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Clear 10 FP - 200 Gold'.",
                            "Read the information displayed on the screen.",
                            "Press the 'Order' button.",
                            "The FP points will be removed instantly."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 21 then -- CHANGE NICKNAME
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "S C H I M B A R E   N U M E" or "C H A N G E   N I C K N A M E"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("NickIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Ai nevoie de o noua identitate in joc? Poti schimba numele tau actual direct din magazinul comunitatii.") 
                            or "Do you need a new identity in-game? You can change your current name directly from the community shop.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET:") or "PRICE:")
                    
                    imgui.BeginChild("NickPrice", imgui.ImVec2(0, 45), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pretul schimbarii numelui este de 600 Gold.") or "The price for changing your name is 600 Gold.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("NickSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Change nickname - 600 Gold'.",
                            "Citeste informatiile si apasa 'Order'.",
                            "Introdu noul nume in casuta aparuta.",
                            "Apasati butonul 'Ok' pentru a finaliza schimbarea."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Change nickname - 600 Gold'.",
                            "Read the info and press 'Order'.",
                            "Enter the new name in the box that appears.",
                            "Press the 'Ok' button to finish the change."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 22 then -- CLEAR WARN
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "S T E R G E   A V E R T I S M E N T" or "C L E A R   W A R N"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("WarnIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Ai primit avertizari (warns) care iti afecteaza reputatia? Poti sterge un avertisment direct din magazinul comunitatii.") 
                            or "Have you received warnings (warns) that affect your reputation? You can clear one warning directly from the community shop.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                    
                    imgui.BeginChild("WarnDetails", imgui.ImVec2(0, 85), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 400 Gold per avertisment.") or "Price: 400 Gold per warning.")
                        imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), iniData.settings.lang == 0 and 
                            u8("* Istoricul ramane vizibil pe website.") or "* History remains visible on the website.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("WarnSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Clear 1 warn - 400 Gold'.",
                            "Citeste informatiile despre procesul de stergere.",
                            "Apasati butonul 'Order'.",
                            "Avertismentul va fi sters instantaneu din cont."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Clear 1 warn - 400 Gold'.",
                            "Read the information about the removal process.",
                            "Press the 'Order' button.",
                            "The warning will be instantly removed from your account."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 23 then -- CHANGE SEX
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and "S C H I M B A R E   S E X" or "C H A N G E   S E X"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("SexIntro", imgui.ImVec2(0, 70), true)
                        imgui.TextWrapped(iniData.settings.lang == 0 and 
                            u8("Doresti sa iti schimbi identitatea vizuala? Poti schimba sexul personajului tau pentru a debloca noi skin-uri.") 
                            or "Do you want to change your visual identity? You can change your character's sex to unlock new skins.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), iniData.settings.lang == 0 and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                    
                    imgui.BeginChild("SexDetails", imgui.ImVec2(0, 70), true)
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                        imgui.BulletText(iniData.settings.lang == 0 and u8("Modificarea este permanenta (poate fi inversata prin alta achizitie).") or "The change is permanent (can be reversed by another purchase).")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), iniData.settings.lang == 0 and u8("CUM CUMPERI:") or "HOW TO BUY:")
                    
                    imgui.BeginChild("SexSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Acceseaza magazinul comunitatii prin [/shop].",
                            "Selecteaza item-ul 'Change sex - 600 Gold'.",
                            "Citeste informatiile si apasa 'Order'.",
                            "Sexul va fi schimbat instantaneu in cel opus.",
                            "Foloseste [/clothes] pentru a alege noile skin-uri."
                        } or {
                            "Access the community shop via [/shop].",
                            "Select the item 'Change sex - 600 Gold'.",
                            "Read the info and press 'Order'.",
                            "Your sex will be changed instantly to the opposite one.",
                            "Use [/clothes] to choose your new skins."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 24 then -- SAFEBOX
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and u8("--- SAFEBOX ---") or "--- SAFEBOX ---"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("SBIntro", imgui.ImVec2(0, 40), true)
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Depoziteaza arme, materiale si droguri oriunde pe harta in siguranta.") or "Store weapons, materials, and drugs anywhere on the map safely.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), (iniData.settings.lang == 0) and u8("CAPACITATEA UTILIZABILA DE FIECARE ELEMENT:") or "USABLE CAPACITY PER ELEMENT:")
                    
                    imgui.BeginChild("SBCapacity", imgui.ImVec2(0, 0), true)
                        imgui.Text((iniData.settings.lang == 0) and u8("1 material - 1 unitate.") or "1 material - 1 unit.")
                        imgui.Text((iniData.settings.lang == 0) and u8("1 gram droguri - 1 unitate.") or "1 gram drugs - 1 unit.")
                        imgui.Separator()
                        imgui.Spacing()

                        imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Deagle / SD Pistol:")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.") or "Skill 1 Weapon Dealer - 1 bullet ~ takes 20 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 17 de unitati.") or "Skill 2 Weapon Dealer - 1 bullet ~ takes 17 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 14 de unitati.") or "Skill 3 Weapon Dealer - 1 bullet ~ takes 14 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 11 de unitati.") or "Skill 4 Weapon Dealer - 1 bullet ~ takes 11 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 8 de unitati.") or "Skill 5 Weapon Dealer - 1 bullet ~ takes 8 units.")
                        imgui.Spacing()
                        imgui.Separator()

                        imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Shotgun / Combat:")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 40 de unitati.") or "Skill 1 Weapon Dealer - 1 bullet ~ takes 40 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 35 de unitati.") or "Skill 2 Weapon Dealer - 1 bullet ~ takes 35 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 30 de unitati.") or "Skill 3 Weapon Dealer - 1 bullet ~ takes 30 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 25 de unitati.") or "Skill 4 Weapon Dealer - 1 bullet ~ takes 25 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.") or "Skill 5 Weapon Dealer - 1 bullet ~ takes 20 units.")
                        imgui.Spacing()
                        imgui.Separator()

                        imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "M4 / AK47:")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 24 de unitati.") or "Skill 1 Weapon Dealer - 1 bullet ~ takes 24 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 23 de unitati.") or "Skill 2 Weapon Dealer - 1 bullet ~ takes 23 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 22 de unitati.") or "Skill 3 Weapon Dealer - 1 bullet ~ takes 22 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 21 de unitati.") or "Skill 4 Weapon Dealer - 1 bullet ~ takes 21 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.") or "Skill 5 Weapon Dealer - 1 bullet ~ takes 20 units.")
                        imgui.Spacing()
                        imgui.Separator()

                        imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "MP5 / TEC-9:")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 15 de unitati.") or "Skill 1 Weapon Dealer - 1 bullet ~ takes 15 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 14 de unitati.") or "Skill 2 Weapon Dealer - 1 bullet ~ takes 14 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 13 de unitati.") or "Skill 3 Weapon Dealer - 1 bullet ~ takes 13 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 12 de unitati.") or "Skill 4 Weapon Dealer - 1 bullet ~ takes 12 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 10 de unitati.") or "Skill 5 Weapon Dealer - 1 bullet ~ takes 10 units.")
                        imgui.Spacing()
                        imgui.Separator()

                        imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Sniper / Sniper Rifle:")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 350 de unitati.") or "Skill 1 Weapon Dealer - 1 bullet ~ takes 350 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 338 de unitati.") or "Skill 2 Weapon Dealer - 1 bullet ~ takes 338 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 325 de unitati.") or "Skill 3 Weapon Dealer - 1 bullet ~ takes 325 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 313 de unitati.") or "Skill 4 Weapon Dealer - 1 bullet ~ takes 313 units.")
                        imgui.Text((iniData.settings.lang == 0) and u8("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 300 de unitati.") or "Skill 5 Weapon Dealer - 1 bullet ~ takes 300 units.")
                        imgui.Separator()
                    imgui.EndChild()

                    elseif sh.id == 25 then -- MARATHON
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and u8("--- M A R A T O N ---") or "--- M A R A T H O N ---"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("MarIntro", imgui.ImVec2(0, 60), true)
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Eveniment lunar automat pentru toti jucatorii. Completeaza obiective, aduna puncte si revendica premii zilnice.") 
                        or "Automated monthly event for all players. Complete objectives, gather points and claim daily rewards.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), (iniData.settings.lang == 0) and u8("DETALII EVENIMENT:") or "EVENT DETAILS:")
                    
                    imgui.BeginChild("MarDetails", imgui.ImVec2(0, 130), true)
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Participare automata pentru nivel 1+.") or "Automatic participation for level 1+.")
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Acces: comanda [/maraton] sau [/marathon].") or "Access: [/maraton] or [/marathon] command.")
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Punctele se reporteaza pentru ziua urmatoare.") or "Points carry over to the next day.")
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Premiile se revendica prin butonul 'CLAIM'.") or "Rewards are claimed via the 'CLAIM' button.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), (iniData.settings.lang == 0) and u8("VERSIUNEA PRO SI COMPLETE:") or "PRO VERSION AND COMPLETE:")
                    
                    imgui.BeginChild("MarPro", imgui.ImVec2(0, 100), true)
                        imgui.TextColored(imgui.ImVec4(0.2, 0.8, 1, 1), (iniData.settings.lang == 0) and u8("Versiunea PRO:") or "PRO Version:")
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Ofera premii mai valoroase si posibilitatea de a primi recompensele ambelor versiuni simultan.") or "Offers higher value rewards and the ability to receive rewards from both versions simultaneously.")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), (iniData.settings.lang == 0) and u8("Optiunea Complete (150 Gold):") or "Complete option (150 Gold):")
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Finalizeaza instant progresul zilei curente.") or "Instantly finish current day progress.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), (iniData.settings.lang == 0) and u8("CUM SA PARTICIPATI:") or "HOW TO PARTICIPATE:")
                    
                    imgui.BeginChild("MarSteps", imgui.ImVec2(0, 0), true)
                        local steps = (iniData.settings.lang == 0) and {
                            "Deschide interfata cu [/maraton].",
                            "Verifica punctele necesare la butonul 'POINTS'.",
                            "Efectueaza activitati pe server pentru a aduna puncte.",
                            "Revendica premiile zilnice folosind 'CLAIM'.",
                            "Foloseste 'GET PRO' pentru avantaje extra."
                        } or {
                            "Open the interface with [/maraton].",
                            "Check required points at the 'POINTS' button.",
                            "Perform activities on the server to gather points.",
                            "Claim daily rewards using 'CLAIM'.",
                            "Use 'GET PRO' for extra perks."
                        }
                        for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                    imgui.EndChild()

                    elseif sh.id == 26 then -- PRIVATE FREQUENCY
                    local w = imgui.GetWindowWidth() - 40
                    imgui.SetWindowFontScale(1.5)
                    local title = (iniData.settings.lang == 0) and u8("--- F R E C V E N T A   P R I V A T A ---") or "--- P R I V A T E   F R E Q U E N C Y ---"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("FreqIntro", imgui.ImVec2(0, 75), true)
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Comunica in siguranta cu prietenii tai. Ai control total asupra frecventei tale: parole, excluderi si administrare completa.") 
                        or "Communicate safely with your friends. You have full control over your frequency: passwords, bans, and full management.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), (iniData.settings.lang == 0) and u8("PRET SI DURATA:") or "PRICE AND DURATION:")
                    
                    imgui.BeginChild("FreqDetails", imgui.ImVec2(0, 75), true)
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Pret: 299 Gold pentru 31 de zile.") or "Price: 299 Gold for 31 days.")
                        imgui.BulletText((iniData.settings.lang == 0) and u8("Prelungire: Se pot adauga 31 de zile prin achizitionare repetata.") or "Extension: You can add 31 days by purchasing again.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), (iniData.settings.lang == 0) and u8("COMENZI:") or "COMMANDS:")
                    
                    imgui.BeginChild("FreqCommands", imgui.ImVec2(0, 0), true)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/myfreq")
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Administrare frecventa (parola, excluderi, distrugere).") or "Frequency management (password, bans, destruction).")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/setfreq")
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Seteaza frecventa (10.0-79.9 private, 80.0-109.9 publice).") or "Set frequency (10.0-79.9 private, 80.0-109.9 public).")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/wt")
                        imgui.TextWrapped((iniData.settings.lang == 0) and u8("Comanda pentru a vorbi (necesita Walkie-Talkie din 24/7).") or "Command to speak (requires Walkie-Talkie from 24/7).")
                    imgui.EndChild()    
                end
                    
                    imgui.TreePop()
                end
            end
        end
    end

             if ("setari tema vizuala opacitate meniu stil structura margini scalare taste comanda bind-uri bind taste hotkey grosime margini butoane fereastra settings theme visual opacity menu style structure margins scaling keys command bindings hotkey thickness buttons window"):find(current_search:lower(), 1, true) then
                foundAny = true
                if imgui.CollapsingHeader(iniData.settings.lang == 0 and "Rezultate din: Setari Sistem" or "Results from: System Settings") then
                    imgui.Spacing()
                    renderThemeSettings()
                    imgui.Spacing()
                end
            end
            if not foundAny then
               imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), iniData.settings.lang == 0 and u8("Nu s-a gasit nicio potrivire nicaieri in script.") or "No matches found anywhere in the script.")
            end
            imgui.EndChild()
        else   

        if active_tab == 1 then
        imgui.Spacing()
        imgui.SetWindowFontScale(1.4)
        local title = (iniData.settings.lang == 0) and u8("PANOU CENTRAL - GHID COMENZI RAPIDE") or "CENTRAL PANEL - QUICK COMMAND GUIDE"
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(title).x) / 2)
        imgui.TextColored(imgui.ImVec4(0.5, 0.14, 1.00, 1.0), title)
        imgui.SetWindowFontScale(1.0)           
        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()
        
        imgui.BeginChild("CommandsScroll", imgui.ImVec2(0, 0), false)
            imgui.SetWindowFontScale(1.1)
            
            local function DrawCmdCard(cmd, descRO, descEN)
                local desc = (iniData.settings.lang == 0) and u8(descRO) or descEN
                imgui.BeginChild("CmdCard_" .. cmd, imgui.ImVec2(-1, 38), true)
                    imgui.SetCursorPos(imgui.ImVec2(10, 10))
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), cmd)
                    imgui.SameLine(220)
                    imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1.0), "|")
                    imgui.SameLine(240)
                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 1.0, 1.0), desc)
                imgui.EndChild()
                imgui.Spacing()
            end

            -- Header INFO CUTII & VEHICULE
            if imgui.CollapsingHeader((iniData.settings.lang == 0) and u8("INFO CUTII & VEHICULE") or "CRATE & VEHICLE INFO") then
                imgui.Spacing()
                DrawCmdCard("/anredcrate / .redcrate", "Informatii despre cutie", "Crate information")
                DrawCmdCard("/aninfernus / .infernus", "Informatii despre masina", "Car information")
                -- DrawCmdCard("/anjobclash / .jobclash", "Informatii despre job clash", "Job Clash information")
                -- DrawCmdCard("/anjobgoal / .jobgoal", "Informatii despre job goal", "Job Goal information")
                imgui.Spacing()
            end
            imgui.Spacing()

            -- Header SKIN UPGRADE & REROLL
            -- if imgui.CollapsingHeader((iniData.settings.lang == 0) and u8("SKIN UPGRADE & REROLL") or "SKIN UPGRADE & REROLL") then
            --     imgui.Spacing()
            --     DrawCmdCard("/anskinupgrade / .skinupgrade", "Info upgrade skin", "Skin upgrade info")
            --     DrawCmdCard("/anskinfragments / .skinfragments", "Info fragmente skin", "Skin fragments info")
            --     DrawCmdCard("/anskinticket / .skinticket", "Info tichete skin", "Skin tickets info")
            --     DrawCmdCard("/anskindiamond / .skindiamond", "Pret upgrade Diamond", "Diamond upgrade price")
            --     DrawCmdCard("/anskinonyx / .skinonyx", "Pret upgrade Onyx", "Onyx upgrade price")
            --     DrawCmdCard("/anskinsilver / .skinsilver", "Pret upgrade Silver", "Silver upgrade price")
            --     DrawCmdCard("/anskinplatinum  / .skinplatinum", "Pret upgrade Platinum", "Platinum upgrade price")
            --     DrawCmdCard("/anreroll / .reroll", "Sistem reroll skin", "Skin reroll system")
            --     imgui.Spacing()
            -- end
            -- imgui.Spacing()

            -- Header APLICATII FACTIUNI
            if imgui.CollapsingHeader((iniData.settings.lang == 0) and u8("APLICATII FACTIUNI") or "FACTION APPLICATIONS") then
                imgui.Spacing()
                DrawCmdCard("/anapplyp / .applyp", "Aplicare factiune pasnica", "Apply for peaceful faction")
                DrawCmdCard("/anapplym / .applym", "Aplicare mafie", "Apply for mafia")
                DrawCmdCard("/anapplypd / .applyd", "Aplicare departament", "Apply for department")
                DrawCmdCard("/anapplyf / .applyf", "Ghid aplicatii website", "Website application guide")
                imgui.Spacing()
            end
            imgui.Spacing()

            -- Header GENERAL & ECONOMIE
            if imgui.CollapsingHeader((iniData.settings.lang == 0) and u8("GENERAL & ECONOMIE") or "GENERAL & ECONOMY") then
                imgui.Spacing()
                DrawCmdCard("/anbani / .bani", "Cum faci bani rapid", "How to make money fast")
                DrawCmdCard("/anrp / .rp", "Respect Points (Payday)", "Respect Points (Payday)")
                DrawCmdCard("/anmp / .mp", "Mission Points", "Mission Points")
                DrawCmdCard("/angold / .gold", "Metode obtinere Gold", "Methods to get Gold")
                -- DrawCmdCard("/anplate / .plate", "Schimbare numar auto", "Change license plate")
                DrawCmdCard("/cninfo / .info", "Salut! Nu detinem aceasta informatie", "Hello! We don't have this information")
                -- DrawCmdCard("/anroata / .roata", "Cum obtii rotiri pentru Roata Norocului", "How to get spins for the Lucky Wheel")
            end
            imgui.Spacing()

             -- Header COMENZI & GENERALE
            -- if imgui.CollapsingHeader((iniData.settings.lang == 0) and u8("COMENZI GENERALE") or "GENERAL COMMANDS") then
            --     imgui.Spacing()
            --     DrawCmdCard("/anmester / .mester", "Informatii despre mester", "Info about mester")
            --     DrawCmdCard("/anspawn / .spawn", "Informatii despre spawnchange", "Info about spawnchange")
            --     DrawCmdCard("/anpaint / .paint", "Informatii despre cum dai parasesti paintball", "Info about how to leave paintball")
            --     DrawCmdCard("/anbicicleta / .bicileta", "Informatii despre cum faci rost de biciclete", "Info about how to get bikes")
            --     imgui.Spacing()
            -- end

            imgui.SetWindowFontScale(1.0)
            imgui.EndChild()
            
            elseif active_tab == 2 then
                imgui.BeginChild("JobsListNavigation", imgui.ImVec2(180, 0), true)
                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), iniData.settings.lang == 0 and u8("LISTA JOBURI:") or "JOBS LIST:")
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("JobsListScrollArea", imgui.ImVec2(0, 0), false)
                        local themeButton = imgui.GetStyle().Colors[imgui.Col.Button]
                        local themeHovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
                        local themeActive = imgui.GetStyle().Colors[imgui.Col.ButtonActive]

                        for idx, name in ipairs(jobs_list) do
                            local isSelected = (selected_job == idx)

                            if isSelected then
                                imgui.PushStyleColor(imgui.Col.Button, themeActive)
                            else
                                imgui.PushStyleColor(imgui.Col.Button, themeButton)
                            end
                            imgui.PushStyleColor(imgui.Col.ButtonHovered, themeHovered)
                            imgui.PushStyleColor(imgui.Col.ButtonActive, themeActive)
                            imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))

                            if imgui.Button(name .. "##btn_" .. idx, imgui.ImVec2(160, 30)) then
                                selected_job = idx
                            end
                            
                            imgui.PopStyleColor(4)
                        end
                    imgui.EndChild()
                imgui.EndChild()

                imgui.SameLine()

                -- [ RIGHT CONTENT RENDERING PANEL ] --
                imgui.BeginChild("JobDetailsDisplayArea", imgui.ImVec2(0, 0), true)
                    if selected_job == 1 then renderQuarryDetails()
                    elseif selected_job == 2 then renderLumberjackDetails()
                    elseif selected_job == 3 then renderMinerDetails()
                    elseif selected_job == 4 then renderGarbageDetails()
                    elseif selected_job == 5 then renderBusDriverDetails()
                    elseif selected_job == 6 then renderFishermanDetails()
                    elseif selected_job == 7 then renderTruckerDetails()
                    elseif selected_job == 8 then renderFarmerDetails()
                    elseif selected_job == 9 then renderChemistDetails()
                    elseif selected_job == 10 then renderDetectiveDetails()
                    elseif selected_job == 11 then renderTransporterDetails()
                    elseif selected_job == 12 then renderDrugsDealerDetails()
                    elseif selected_job == 13 then renderCarJackerDetails()
                    elseif selected_job == 14 then renderMecanicDetails()
                    elseif selected_job == 15 then renderArmsDealerDetails()
                    elseif selected_job == 16 then renderArcheologistDetails()
                    elseif selected_job == 17 then renderElectricianDetails()
                    elseif selected_job == 18 then renderLawyerDetails()
                    elseif selected_job == 19 then renderPocketThiefDetails()
                    elseif selected_job == 20 then renderCraftsmanDetails()
                    elseif selected_job == 21 then renderFirefighterDetails()
                    elseif selected_job == 22 then renderDailyJobDetails()
                    elseif selected_job == 23 then renderJobClashDetails()
                    end
                imgui.EndChild()

            elseif active_tab == 3 then
                imgui.BeginChild("VehiclesNavigationArea", imgui.ImVec2(210, 0), true)
                    if selected_category == 0 then
                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), iniData.settings.lang == 0 and u8("CATEGORII:") or "CATEGORIES:")
                        imgui.Separator()
                        imgui.Spacing()
                        
                        for idx, cat in ipairs(vehicle_categories) do
                            if imgui.Selectable(cat.name, false, 0, imgui.ImVec2(0, 25)) then
                                selected_category = idx
                                selected_vehicle_name = ""
                            end
                        end
                    else
                        local current_cat = vehicle_categories[selected_category]
                        
                        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.80, 0.12, 0.12, 1.00))
                        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.90, 0.18, 0.18, 1.00))
                        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.10, 0.10, 1.00))
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
                        
                        if imgui.Button("<< " .. (iniData.settings.lang == 0 and u8("Inapoi") or "Back") .. " >>", imgui.ImVec2(-1, 28)) then
                            selected_category = 0
                            selected_vehicle_name = ""
                        end
                        imgui.PopStyleColor(4) 
                        
                        imgui.Separator()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0.5, 0.8, 1.0, 1.0), current_cat.name .. ":")
                        imgui.Spacing()

                        imgui.BeginChild("FilteredVehItemsArea", imgui.ImVec2(0, 0), false)
                            for _, name in ipairs(current_cat.items) do
                                local isSelected = (selected_vehicle_name == name)
                                if imgui.Selectable(name, isSelected, 0, imgui.ImVec2(0, 25)) then
                                    selected_vehicle_name = name
                                end
                            end
                        imgui.EndChild()
                    end
                imgui.EndChild()

                imgui.SameLine()

                imgui.BeginChild("VehiclesDetailsArea", imgui.ImVec2(0, 0), true)
                    if selected_vehicle_name ~= "" then
                        renderVehicleDetailsPanel(selected_vehicle_name)
                    else
                        imgui.SetCursorPos(imgui.ImVec2(20, 40))
                        imgui.TextWrapped(iniData.settings.lang == 0 and u8("Selecteaza o categorie din stanga si apoi alege un vehicul pentru a-i vedea configuratia completa.") or "Select a category from the left and then choose a vehicle to see its complete configuration.")
                    end
                imgui.EndChild()

            elseif active_tab == 4 then
                imgui.BeginChild("CratesListWindow", imgui.ImVec2(0, 0), false)
                for _, crate in ipairs(cratesData) do
                    renderSingleCrateCard(crate)
                end
                imgui.EndChild()

            elseif active_tab == 5 then
                -- [ NAVIGARE STaNGA: LISTa TOATE SISTEMELE ] --
                imgui.BeginChild("SystemsNavigationPanel", imgui.ImVec2(190, 0), true)
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.15, 1), iniData.settings.lang == 0 and u8("GHIDUL SISTEMELOR:") or "SYSTEMS GUIDE:")
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("SystemsScrollNavigation", imgui.ImVec2(0, 0), false)
                    -- Definim traducerile
                    local sys_buttons = {"Misiuni", "Bunker", "Job Goal", "Cufar", "Skinuri Speciale", "Clan XP", "Rob ATM", "Rob Solo", "Rob Team", "Escape", "Jail", "Skinuri Factiuni", "Licente", "Niveluri Minime", "Referral", "Safebox", "Masini Tutoriale", "Economie", "Amenzi", "Trader Shop", "Payday"}
                    local sys_buttons_en = {"Missions", "Bunker", "Job Goal", "Chest", "Special Skins", "Clan XP", "Rob ATM", "Rob Solo", "Rob Team", "Escape", "Jail", "Faction Skins", "Licenses", "Min Levels", "Referral", "Safebox", "Tutorial Cars", "Economy", "Fines", "Trader Shop", "Payday"}

                    local themeButton = imgui.GetStyle().Colors[imgui.Col.Button]
                    local themeHovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
                    local themeActive = imgui.GetStyle().Colors[imgui.Col.ButtonActive]

                    for idx, sys_name in ipairs(sys_buttons) do
                        local isSelected = (selected_system == idx)
                        
                        -- Alegem numele corect in functie de limba
                        local displayName = (iniData.settings.lang == 0) and u8(sys_name) or sys_buttons_en[idx]
                        
                        if isSelected then
                            imgui.PushStyleColor(imgui.Col.Button, themeActive)
                        else
                            imgui.PushStyleColor(imgui.Col.Button, themeButton)
                        end
                        imgui.PushStyleColor(imgui.Col.ButtonHovered, themeHovered)
                        imgui.PushStyleColor(imgui.Col.ButtonActive, themeActive)
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))

                        if imgui.Button(displayName .. "##sys_btn_" .. idx, imgui.ImVec2(170, 30)) then
                            selected_system = idx
                        end
                        
                        imgui.PopStyleColor(4)
                    end
                imgui.EndChild()
                imgui.EndChild()

                imgui.SameLine()

                -- [ PANEL DREAPTA: RENDERING DETALIAT LOCAL ] --
                imgui.BeginChild("SystemDetailsDisplayArea", imgui.ImVec2(0, 0), true)
                    if selected_system == 0 then
                        imgui.SetCursorPos(imgui.ImVec2(30, 40))
                        local msg = (iniData.settings.lang == 0) and u8("Selecteaza un sistem din partea stanga pentru a vizualiza informatiile detaliate.") or "Select a system from the left to view detailed information."
                        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), msg)

                    elseif selected_system == 1 then -- MISIUNI
                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), (iniData.settings.lang == 0) and u8("--- SISTEMUL DE MISIUNI ---") or "--- MISSION SYSTEM ---")
                    imgui.Separator()
                    
                    imgui.BeginChild("MissionsLocalBox", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), (iniData.settings.lang == 0) and u8("REGULI SI COMENZI:") or "RULES AND COMMANDS:")
                        imgui.Separator()
                        if iniData.settings.lang == 0 then
                            imgui.BulletText(u8("Cooldown: O misiune noua la fiecare 4 ore."))
                            imgui.BulletText(u8("Parasire: [/leavemission] (nu activeaza cooldown-ul)."))
                            imgui.BulletText(u8("Licente: Poti conduce barci/avioane fara licenta in misiune."))
                        else
                            imgui.BulletText("Cooldown: A new mission every 4 hours.")
                            imgui.BulletText("Leave: [/leavemission] (does not trigger cooldown).")
                            imgui.BulletText("Licenses: You can drive boats/planes without a license during missions.")
                        end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), (iniData.settings.lang == 0) and u8("MISIUNI DISPONIBILE PE NIVELURI:") or "AVAILABLE MISSIONS BY LEVEL:")
                    
                    imgui.BeginChild("MissionsRyderBox", imgui.ImVec2(0, 100), true)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "RYDER (Level 1+)")
                        imgui.Separator()
                        imgui.Text((iniData.settings.lang == 0) and u8("1. Fura Jetpack-ul: $15.000 + 5 MP\n2. Fura pachete de armament: $5.000 + 3 MP\n3. Raid: $5.000 + 3 MP") or "1. Steal the Jetpack: $15,000 + 5 MP\n2. Steal weapon packages: $5,000 + 3 MP\n3. Raid: $5,000 + 3 MP")
                    imgui.EndChild()
                    
                    imgui.BeginChild("MissionsDimitriBox", imgui.ImVec2(0, 120), true)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "DIMITRI PETRENKO (Level 3+)")
                        imgui.Separator()
                        imgui.Text((iniData.settings.lang == 0) and u8("1. Fura bucati de metal: $15.000 + 5 MP\n2. Fura naveta spatiala: $5.000 + 3 MP\n3. Adu motoarele: $10.000 + 4 MP\n4. Zbor pe Marte: $15.000 + 5 MP") or "1. Steal metal pieces: $15,000 + 5 MP\n2. Steal space shuttle: $5,000 + 3 MP\n3. Bring the engines: $10,000 + 4 MP\n4. Fly to Mars: $15,000 + 5 MP")
                    imgui.EndChild()
                    
                    imgui.BeginChild("MissionsOGBox", imgui.ImVec2(0, 85), true)
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "OG LOC (Level 5+)")
                        imgui.Separator()
                        imgui.Text((iniData.settings.lang == 0) and u8("1. Fura discul: $15.000 + 5 MP\n2. Fa-ti prieteni noi: $5.000 + 3 MP") or "1. Steal the disc: $15,000 + 5 MP\n2. Make new friends: $5,000 + 3 MP")
                    imgui.EndChild()
                    
                    imgui.Separator()
                    imgui.TextDisabled((iniData.settings.lang == 0) and u8("Nota: Misiunile NEA MIREL si CATALIN sunt specifice evenimentelor.") or "Note: NEA MIREL and CATALIN missions are event-specific.")

                    elseif selected_system == 2 then -- BUNKER
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), isRO and u8("--- SISTEMUL DE BUNKER ---") or "--- BUNKER SYSTEM ---")
                    imgui.Separator()
                    
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), isRO and u8("LOCATII SI PRETURI CUMPARARE:") or "LOCATIONS AND PURCHASE PRICES:")
                    imgui.BeginChild("BunkerLocsBox", imgui.ImVec2(0, 65), true)
                        imgui.Columns(3, "bunkLocsCols", false)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Basin (SF)"); imgui.Text("$1.000.000"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Diablo (LV)"); imgui.Text("$2.500.000"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "Blueberry (LS)"); imgui.Text("$3.500.000"); imgui.Columns(1)
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), isRO and u8("COSTURI UPGRADES PE LOCATII:") or "UPGRADE COSTS BY LOCATION:")
                    imgui.BeginChild("BunkerUpgBox", imgui.ImVec2(0, 210), true)
                        imgui.Columns(4, "bunkUpgCols", false)
                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), isRO and u8("Upgrade") or "Upgrade") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.0, 0.7, 1.0, 1.0), "San Fierro") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "Las Venturas") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.68, 0.26, 0.73, 1.0), "Los Santos") imgui.NextColumn()
                        imgui.Separator()
                        
                        local upgNames = isRO and {u8("Echipament"), u8("Staff"), u8("Securitate"), u8("Supraveghere"), u8("Confort")} 
                                                or {"Equipment", "Staff", "Security", "Surveillance", "Comfort"}
                        
                        for i, name in ipairs(upgNames) do
                            imgui.Text(name); imgui.NextColumn()
                            imgui.Text("$400.000"); imgui.NextColumn(); imgui.Text("$600.000"); imgui.NextColumn(); imgui.Text("$800.000"); imgui.NextColumn()
                        end
                        
                        imgui.Separator() 
                        imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), isRO and u8("Total Upgrades") or "Total Upgrades"); imgui.NextColumn(); imgui.Text("$4.400.000"); imgui.NextColumn(); imgui.Text("$6.200.000"); imgui.NextColumn(); imgui.Text("$8.000.000"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.2, 0.6, 1.0, 1.0), isRO and u8("PRET (BUNKER + UPGRADES)") or "PRICE (BUNKER + UPGRADES)"); imgui.NextColumn(); imgui.Text("$5.400.000"); imgui.NextColumn(); imgui.Text("$8.700.000"); imgui.NextColumn(); imgui.Text("$11.500.000"); imgui.Columns(1)
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), isRO and u8("PRODUCTIE SI VANZARE:") or "PRODUCTION AND SALE:")
                    imgui.BeginChild("BunkerProdBox", imgui.ImVec2(0, 115), true)
                        if isRO then
                            imgui.BulletText(u8("Viteza Max (Staff+Echip): 1 unitate / 10 min"))
                            imgui.BulletText(u8("Consum Provizii (Maxim): 1 unitate / 300 sec"))
                            imgui.BulletText(u8("Pret Vanzare (Departe): $2.000 / unitate | (Aproape): $1.000 / unitate"))
                            imgui.BulletText(u8("Bonus Ajutoare: 10'/. din plata finala"))
                        else
                            imgui.BulletText("Max Speed (Staff+Equip): 1 unit / 10 min")
                            imgui.BulletText("Supplies Consumption (Max): 1 unit / 300 sec")
                            imgui.BulletText("Sale Price (Far): $2,000 / unit | (Near): $1,000 / unit")
                            imgui.BulletText("Helpers Bonus: 10'/. of final payment")
                        end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.95, 1.0), isRO and u8("CAPACITATE SI TIER PROGRES:") or "CAPACITY AND TIER PROGRESS:")
                    imgui.BeginChild("BunkerTiersBox", imgui.ImVec2(0, 65), true)
                        imgui.Columns(2, "bunkTiersCols", false)
                        imgui.Text("Tier 0: 100 Supp / 100 Stock\nTier 5: 150 Supp / 100 Stock"); imgui.NextColumn()
                        imgui.Text("Tier 6: 150 Supp / 110 Stock\nTier 10: 150 Supp / 150 Stock"); imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), isRO and u8("Nota: Comanda /buybunker (Lvl 10). Stocul se pierde la mutare!") or "Note: Command /buybunker (Lvl 10). Stock is lost upon moving!")
                  
                elseif selected_system == 3 then -- JOB GOAL
                    local isRO = (iniData.settings.lang == 0)
                    if isRO then
                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "--- SISTEM JOB GOAL ---")
                        imgui.Separator()
                        imgui.BeginChild("GoalDescBox", imgui.ImVec2(0, 95), true)
                            imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "DESCRIERE OBIECTIV:")
                            imgui.TextWrapped("Job Goal reprezinta suma sau '/.ajul pe care toti jucatorii de pe server trebuie sa il atinga impreuna pentru a debloca premiile zilei. Reset: Zilnic la 00:00.")
                        imgui.EndChild()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "RECOMPENSE LA 100'/. COMPLETAT:")
                        imgui.BeginChild("GoalRewardsBox", imgui.ImVec2(0, 90), true)
                            imgui.Text("Daca obiectivul global si cel individual sunt atinse:")
                            imgui.BulletText("Bani: intre $25.000 si $50.000\nGold: intre 5 si 10 (aleatoriu)\nRespect Points: intre 5 si 10 puncte")
                        imgui.EndChild()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "BONUS SPECIAL WEEKLY (100 GOLD):")
                        imgui.BeginChild("GoalWeeklyBox", imgui.ImVec2(0, 75), true)
                            imgui.TextWrapped("Jucatorii care contribuie la pragul individual in cel putin 5 zile din 7 intr-o saptamana sunt premiati automat. Reset: Luni.")
                        imgui.EndChild()
                    else
                        imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), "--- JOB GOAL SYSTEM ---")
                        imgui.Separator()
                        imgui.BeginChild("GoalDescBox", imgui.ImVec2(0, 95), true)
                            imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), "OBJECTIVE DESCRIPTION:")
                            imgui.TextWrapped("Job Goal represents the sum or '/.age that all players on the server must reach together to unlock the daily rewards. Reset: Daily at 00:00.")
                        imgui.EndChild()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), "REWARDS AT 100'/. COMPLETED:")
                        imgui.BeginChild("GoalRewardsBox", imgui.ImVec2(0, 90), true)
                            imgui.Text("If the global and individual objective are reached:")
                            imgui.BulletText("Money: between $25,000 and $50,000\nGold: between 5 and 10 (randomly)\nRespect Points: between 5 and 10 points")
                        imgui.EndChild()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), "SPECIAL WEEKLY BONUS (100 GOLD):")
                        imgui.BeginChild("GoalWeeklyBox", imgui.ImVec2(0, 75), true)
                            imgui.TextWrapped("Players who contribute to the individual threshold at least 5 out of 7 days in a week are automatically rewarded. Reset: Monday.")
                        imgui.EndChild()
                    end
                    elseif selected_system == 4 then -- CUFAR
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), isRO and u8("--- SISTEM CUFAR (REWARDS) ---") or "--- CHEST SYSTEM (REWARDS) ---")
                    imgui.Separator()
                    
                    imgui.BeginChild("ChestCmdsBox", imgui.ImVec2(0, 65), true)
                        imgui.Text(isRO and u8("Comenzi disponibile: /reward, /rewards, /premiu, /premii") or "Available commands: /reward, /rewards, /premiu, /premii")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("REGULI SI TIMPI:") or "RULES AND TIMINGS:")
                    imgui.BeginChild("ChestRulesBox", imgui.ImVec2(0, 100), true)
                        if isRO then
                            imgui.BulletText(u8("Resetare: Zilnic la ora 23:00 (Colectare max 1 Tier/zi)."))
                            imgui.BulletText(u8("Ore Jucate: Doar orele REALE (fara AFK/Sleep)."))
                            imgui.BulletText(u8("Reroll: Disponibil daca nu ai slot liber sau Premium."))
                        else
                            imgui.BulletText("Reset: Daily at 23:00 (Max 1 Tier/day).")
                            imgui.BulletText("Played Hours: Only REAL hours (no AFK/Sleep).")
                            imgui.BulletText("Reroll: Available if you don't have a free slot or Premium.")
                        end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), isRO and u8("PREMII GARANTATE (TIER 5+):") or "GUARANTEED REWARDS (TIER 5+):")
                    imgui.BeginChild("ChestGarantatBox", imgui.ImVec2(0, 170), true)
                        imgui.Columns(2, "chestCols", false)
                        local labels = {"Tier 5:", "Tier 6:", "Tier 7:", "Tier 8:", "Tier 9:", "Tier 10:"}
                        local rewardsRO = {" - $50.000 Bonus", " - $75.000 Bonus", " - 90 Gold + $100.000", " - 110 Gold + $125.000", " - 120 Gold + $150.000", " - 130 Gold + $150.000\n   + 1 Saptamana Premium"}
                        local rewardsEN = {" - $50,000 Bonus", " - $75,000 Bonus", " - 90 Gold + $100,000", " - 110 Gold + $125,000", " - 120 Gold + $150,000", " - 130 Gold + $150,000\n   + 1 Week Premium"}
                        
                        for i=1, 6 do
                            imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), labels[i]); 
                            imgui.Text(isRO and u8(rewardsRO[i]) or rewardsEN[i])
                            if i == 3 then imgui.NextColumn() end
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.TextDisabled(isRO and u8("Nota: Daca ai Premium Permanent, la Tier 10 primesti 75 Gold in loc de abonament.") or "Note: If you have Permanent Premium, at Tier 10 you receive 75 Gold instead of the subscription.")

                   elseif selected_system == 5 then -- SKINURI SPECIALE
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1.0, 1.0), isRO and u8("--- UPGRADE SKINURI SPECIALE ---") or "--- SPECIAL SKIN UPGRADE ---")
                    imgui.Separator()
                    
                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("COSTURI TICHETE (/shop):") or "TICKET COSTS (/shop):")
                    imgui.BeginChild("SkinTicketBox", imgui.ImVec2(0, 65), true)
                        imgui.BulletText(isRO and u8("Diamond Ticket: 800 Gold | Onyx Ticket: 1.000 Gold") or "Diamond Ticket: 800 Gold | Onyx Ticket: 1,000 Gold")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), isRO and u8("PROCES UPGRADE LA TRADER SHOP (LV):") or "UPGRADE PROCESS AT TRADER SHOP (LV):")
                    imgui.BeginChild("SkinTraderBox", imgui.ImVec2(0, 180), true)
                        imgui.TextWrapped(isRO and u8("Poti transforma 5 Fragmente de acelasi tip in 1 Tichet la Trader Shop (Egyptian Shop LV).") or "You can turn 5 Fragments of the same type into 1 Ticket at the Trader Shop (Egyptian Shop LV).")
                        imgui.Spacing()
                        if isRO then
                            imgui.Separator()
                            imgui.BulletText("Bronze -> Silver: 500.000$ + 50 MP + 1x Tichet Upgrade")
                            imgui.BulletText("Silver -> Platinum: 500.000$ + 50 MP + 1x Tichet Upgrade")
                            imgui.Separator()
                            imgui.BulletText(u8("Platinum -> Diamond: $1.000.000 + 100 MP + 1 Ticket Diamond"))
                            imgui.BulletText(u8("Diamond -> Onyx: $2.000.000 + 200 MP + 1 Ticket Onyx"))
                            imgui.Separator()
                            imgui.BulletText(u8("Pentru skinurile Diamond pretul va fi $4.000.000, 400 Mission Points si 3 Tichete Diamond."))
                            imgui.BulletText(u8("Pentru skinurile Onyx pretul va fi $6.000.000, 600 Mission Points si 5 Tichete Onyx."))
                        else
                            imgui.Separator()
                            imgui.BulletText("Bronze -> Silver: 500.000$ + 50 MP + 1x Tichet Upgrade")
                            imgui.BulletText("Silver -> Platinum: 500.000$ + 50 MP + 1x Tichet Upgrade")
                            imgui.Separator()
                            imgui.BulletText("Platinum -> Diamond: $1,000,000 + 100 MP + 1 Diamond Ticket")
                            imgui.BulletText("Diamond -> Onyx: $2,000,000 + 200 MP + 1 Onyx Ticket")
                            imgui.Separator()
                            imgui.BulletText("For Diamond skins, the price will be $4,000,000, 400 Mission Points, and 3 Diamond Tickets.")
                            imgui.BulletText("For Onyx skins, the price will be $6,000,000, 600 Mission Points, and 5 Onyx Tickets.")
                        end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), isRO and u8("IDENTIFICARE VIZUALA:") or "VISUAL IDENTIFICATION:")
                    imgui.BeginChild("SkinVisualBox", imgui.ImVec2(0, 65), true)
                        imgui.Text(isRO and u8("Diamond: Albastru Deschis in garderoba\nOnyx: Portocaliu in garderoba") or "Diamond: Light Blue in wardrobe\nOnyx: Orange in wardrobe")
                    imgui.EndChild()

                    elseif selected_system == 6 then -- CLAN XP
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 1.0, 1.0), isRO and u8("--- SISTEM GENERARE CLAN XP ---") or "--- CLAN XP GENERATION SYSTEM ---")
                    imgui.Separator()
                    
                    imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), isRO and u8("ACTIVITATI ILEGALE:") or "ILLEGAL ACTIVITIES:")
                    imgui.BeginChild("XPIlegalBox", imgui.ImVec2(0, 115), true)
                        if isRO then
                            imgui.BulletText(u8("Rob Echipa: 1 XP per punct jaf (10 XP tot) | Solo Rob: 5 XP"))
                            imgui.BulletText(u8("ATM Heist: 3 XP per jaf reusit"))
                            imgui.BulletText(u8("Escape: 1 XP per punct (20 XP total) | Pocket Thief: 5 XP"))
                        else
                            imgui.BulletText("Team Rob: 1 XP per robbery point (10 XP total) | Solo Rob: 5 XP")
                            imgui.BulletText("ATM Heist: 3 XP per successful heist")
                            imgui.BulletText("Escape: 1 XP per point (20 XP total) | Pocket Thief: 5 XP")
                        end
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("ACTIVITATI SI JOBURI:") or "ACTIVITIES AND JOBS:")
                    imgui.BeginChild("XPJobsBox", imgui.ImVec2(0, 135), true)
                        imgui.Columns(2, "xpLocalJobs", false)
                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), isRO and u8("Fixe:") or "Fixed:")
                        imgui.BulletText(isRO and u8("Mester: 20 XP\nMisiuni: 10 XP\nCarJacker: 10 XP\nGunoier/Chimist: 6 XP") or "Craftsman: 20 XP\nMissions: 10 XP\nCarJacker: 10 XP\nGarbage/Chemist: 6 XP"); imgui.NextColumn()
                        
                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), isRO and u8("Progresive:") or "Progressive:")
                        imgui.BulletText(isRO and u8("Trucker: 5 XP\nArms Dealer: 4 XP\nMiner/Curier: 3 XP\nPescar: 2 XP | Arheolog: 1 XP") or "Trucker: 5 XP\nArms Dealer: 4 XP\nMiner/Courier: 3 XP\nFisherman: 2 XP | Archeologist: 1 XP"); imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), isRO and u8("ALTE METODE:") or "OTHER METHODS:")
                    imgui.BeginChild("XPMiscBox", imgui.ImVec2(0, 85), true)
                        imgui.BulletText(isRO and u8("Achizitii /shop: 30 XP | Taskuri Zilnice: 3 XP | Tag-uri (/spray): 1 XP (Max 30/zi)") or "/shop purchases: 30 XP | Daily Tasks: 3 XP | Tags (/spray): 1 XP (Max 30/day)")
                    imgui.EndChild()

                    elseif selected_system == 7 then -- ROB ATM
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.SetWindowFontScale(1.2)
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - A T M")
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("RECOMPENSE FINANCIARE PE SKILL (LA SUCCES)") or "FINANCIAL REWARDS BY SKILL (ON SUCCESS)")
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Columns(3, "robAtmCols", false)
                    imgui.SetColumnWidth(0, 110)
                    imgui.SetColumnWidth(1, 200)
                    imgui.SetColumnWidth(2, 160)
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Skill Rob") or "Rob Skill") imgui.NextColumn()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Recompensa de Baza") or "Base Reward") imgui.NextColumn()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Puncte Skill") or "Skill Points") imgui.NextColumn()
                    imgui.Separator()

                    local atmDataRO = {
                        {"Skill 1", "intre $12.500 - $17.500", "+1 punct skill"},
                        {"Skill 2", "intre $17.500 - $22.500", "+1 punct skill"},
                        {"Skill 3", "intre $22.500 - $27.500", "+1 punct skill"},
                        {"Skill 4", "intre $27.500 - $32.500", "+1 punct skill"},
                        {"Skill 5", "intre $32.500 - $37.500", "Nivel Maxim"}
                    }
                    local atmDataEN = {
                        {"Skill 1", "between $12,500 - $17,500", "+1 skill point"},
                        {"Skill 2", "between $17,500 - $22,500", "+1 skill point"},
                        {"Skill 3", "between $22,500 - $27,500", "+1 skill point"},
                        {"Skill 4", "between $27,500 - $32,500", "+1 skill point"},
                        {"Skill 5", "between $32,500 - $37,500", "Max Level"}
                    }
                    
                    local currentData = isRO and atmDataRO or atmDataEN
                    for _, v in ipairs(currentData) do
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v[1]) imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), isRO and u8(v[2]) or v[2]) imgui.NextColumn()
                        imgui.Text(isRO and u8(v[3]) or v[3]) imgui.NextColumn()
                    end
                    imgui.Columns(1)
                    
                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                    imgui.SetWindowFontScale(1.2)
                    
                    -- [ SECTIUNEA 1 ] --
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("1. CONDITII MINIME & DECLANSARE") or "1. MINIMUM REQUIREMENTS & TRIGGER")
                    imgui.BulletText(isRO and u8("Nivel minim 7 | Sa nu fii membru PD.") or "Minimum level 7 | Cannot be a PD member.")
                    imgui.BulletText(isRO and u8("Minim 10 puncte de jaf (se consuma automat la initiere).") or "Minimum 10 robbery points (consumed automatically on start).")
                    imgui.BulletText(isRO and u8("Sa NU ai Wanted in acel moment | Licenta de zbor valabila.") or "Must NOT have Wanted | Valid flying license.")
                    imgui.BulletText(isRO and u8("Trebuie sa detii cel putin o bomba creata in inventar.") or "Must own at least one crafted bomb in inventory.")
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Mecanica de Armare:") or "Arming Mechanic:")
                    imgui.TextWrapped(isRO and u8("Te apropii de un ATM si foloseste comanda /robatm. Vei primi un SMS de la Comerciantul de Explozibil cu un cod de 10 cifre. Trebuie sa introduci exact codul in interfata grafica (textdraw) pentru a arma bomba.") or "Approach an ATM and use /robatm. You'll receive an SMS from the Explosives Dealer with a 10-digit code. You must enter the exact code in the GUI (textdraw) to arm the bomb.")
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), isRO and u8("Reguli de anulare instant:") or "Instant failure rules:")
                    imgui.TextWrapped(isRO and u8("Daca parasesti zona, inchizi interfata, primesti crash sau mori in timp ce bagi codul -> jaful esueaza si primesti Wanted. Cod incorect = Explozie locala cu daune + Wanted.") or "If you leave the area, close the GUI, crash, or die while entering the code -> robbery fails and you get Wanted. Wrong code = Local explosion with damage + Wanted.")
                    
                    -- [ SECTIUNEA 2 ] --
                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("2. COLECTAREA BANILOR SI COOLDOWN") or "2. MONEY COLLECTION AND COOLDOWN")
                    imgui.TextWrapped(isRO and u8("Dupa ce bomba explodeaza, langa ATM apare un sac personal cu bani. Ai la dispozitie fix 90 de secunde sa il ridici, altfel prada expira si jaful e esuat.") or "After the bomb explodes, a personal money bag appears near the ATM. You have exactly 90 seconds to pick it up, otherwise the loot expires and the robbery fails.")
                    imgui.BulletText(isRO and u8("La ridicarea sacului primesti Wanted automat si porneste evadarea.") or "Upon picking up the bag, you automatically get Wanted and the escape starts.")
                    imgui.BulletText(isRO and u8("ATM-ul intra in cooldown 180s (este dezactivat pt operatiuni si jafuri).") or "ATM enters a 180s cooldown (disabled for operations and robberies).")
                    
                    -- [ SECTIUNEA 3 ] --
                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("3. ETAPA DE EVADARE SI ALTITUDINE") or "3. ESCAPE STAGE AND ALTITUDE")
                    imgui.TextWrapped(isRO and u8("Se va seta un checkpoint de extractie in alt oras. Trebuie sa zbori pana acolo cu un avion sau un elicopter. Cand atingi punctul, esti aruncat automat in aer si primesti o parasuta.") or "An extraction checkpoint will be set in another city. You must fly there by plane or helicopter. When you hit the point, you are automatically ejected and given a parachute.")
                    
                    imgui.TextWrapped(isRO and u8("Urmareste cu mare atentie indicatorul de altitudine pentru deschidere:") or "Watch the altitude indicator very carefully for opening:")
                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), isRO and u8(" [X] Mai mare de 500 m -> Prea sus (NU deschide parasuta!)") or " [X] Higher than 500m -> Too high (DO NOT open parachute!)")
                    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), isRO and u8(" [V] Intre 350 si 500 m -> PERFECT! (Deschide aici pentru a finaliza cu succes)") or " [V] Between 350 and 500m -> PERFECT! (Open here to finish successfully)")
                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), isRO and u8(" [X] Mai mic de 350 m -> Prea jos (Prabusire si esec jaful)") or " [X] Lower than 350m -> Too low (Crash and robbery failure)")
                    
                    -- [ PARTEA FINALA ] --
                    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), isRO and u8("Bonus la succes: Daca deschizi parasuta corect, Wanted-ul este sters complet. Primesti +7 puncte maraton, +3 EXP clan si +1 punct de skill la Rob.") or "Success bonus: If you open the parachute correctly, Wanted is completely cleared. You get +7 marathon points, +3 clan EXP, and +1 Rob skill point.")
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.5), isRO and u8("Sumele de bani pot fi marite suplimentar de maratoane active, bonus de nivel sau skinuri posedate.") or "Money amounts can be further increased by active marathons, level bonuses, or owned skins.")
                    
                    imgui.SetWindowFontScale(1.0)

                    elseif selected_system == 8 then -- ROB SOLO
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.SetWindowFontScale(1.2)  
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - S O L O")
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CASTIGURI SI TIMP DISPONIBIL PE SKILL") or "EARNINGS AND AVAILABLE TIME BY SKILL")
                    imgui.SetWindowFontScale(1.0)  
                    imgui.BeginChild("RobSoloEarnings", imgui.ImVec2(0, 165), true)
                        imgui.Columns(3, "robSoloCols", false)
                        imgui.SetColumnWidth(0, 100)  
                        imgui.SetColumnWidth(1, 180)
                        imgui.SetColumnWidth(2, 160) 
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Skill") or "Skill") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Castig Estimativ") or "Estimated Gain") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Timp Circuit") or "Circuit Time") imgui.NextColumn()
                        imgui.Separator()

                        local robData = {
                            {"Skill 1", isRO and u8("intre $25.000 - $35.000") or "between $25,000 - $35,000", isRO and u8("300 secunde") or "300 seconds"},
                            {"Skill 2", isRO and u8("intre $35.000 - $45.000") or "between $35,000 - $45,000", isRO and u8("310 secunde") or "310 seconds"},
                            {"Skill 3", isRO and u8("intre $45.000 - $55.000") or "between $45,000 - $55,000", isRO and u8("320 secunde") or "320 seconds"},
                            {"Skill 4", isRO and u8("intre $55.000 - $65.000") or "between $55,000 - $65,000", isRO and u8("330 secunde") or "330 seconds"},
                            {"Skill 5", isRO and u8("intre $65.000 - $70.000") or "between $65,000 - $70,000", isRO and u8("340 secunde") or "340 seconds"}
                        }
                        for _, v in ipairs(robData) do
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v[1]) imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), v[2]) imgui.NextColumn()
                            imgui.Text(v[3]) imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.Columns(2, "robInfo", false)    
                    
                    -- [ COLOANA 1: CERINTE ]
                    imgui.SetWindowFontScale(1.2)  
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("RESURSE & PROCEDURI") or "RESOURCES & PROCEDURES")
                    imgui.BeginChild("RobRequirements", imgui.ImVec2(0, 400), true)  
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Cerinte Jaf (Casa/Biz):") or "Robbery Requirements (House/Biz):")
                        imgui.BulletText(isRO and u8("Cel putin nivel 7.") or "At least level 7.")
                        imgui.BulletText(isRO and u8("Cel putin 15 puncte de jaf (/robpoints).") or "At least 15 robbery points (/robpoints).")
                        imgui.BulletText(isRO and u8("Cazier curat (fara wanted).") or "Clean criminal record (no wanted).")
                        imgui.BulletText(isRO and u8("Ora serverului: intre 08:00 - 04:00.") or "Server time: between 08:00 - 04:00.")
                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Spargerea Seifului:") or "Safe Cracking:")
                        imgui.TextWrapped(isRO and u8("Se foloseste tasta SPACE pentru burghiu. Mentineti burghiul cat mai rece urmarind indicele de temperatura; daca se supraincalzeste, devine ineficient si spargerea dureaza mult mai mult.") or "Use the SPACE key for the drill. Keep the drill cool by monitoring the temperature gauge; if it overheats, it becomes inefficient and the cracking takes much longer.")
                    imgui.EndChild()
                    
                    imgui.NextColumn()
                    
                    -- [ COLOANA 2: MINIGAMES ]
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("MINIJOCURI (IN FUNCTIE DE SKILL)") or "MINIGAMES (BY SKILL)")
                    imgui.BeginChild("RobMinigames", imgui.ImVec2(0, 400), true) 
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Skill 1 - 5: Scurtcircuit (Implicit)") or "Skill 1 - 5: Short Circuit (Default)")
                        imgui.TextWrapped(isRO and u8("Directionati sarma cu sagetile dintr-o parte in alta fara a atinge peretii. Atingerea lor reseteaza traseul.") or "Guide the wire with the arrow keys side to side without touching the walls. Touching them resets the path.")
                        imgui.Spacing()
                        
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Skill 6 - 7: Taiere SAU Conectare Fire") or "Skill 6 - 7: Wire Cutting OR Connection")
                        imgui.TextWrapped(isRO and u8("- Taiere: Ghiciti si taiati firul corect (rosu/verde/albastru) de 3 ori.\n- Conectare: Uniti culoarea din stanga cu cea corespondenta din dreapta de 3 ori.") or "- Cutting: Guess and cut the correct wire (red/green/blue) 3 times.\n- Connection: Connect the left color to the corresponding right one 3 times.")
                        imgui.Spacing()
                        
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Skill 8 - 10: Taiere / Conectare / Voltaj") or "Skill 8 - 10: Cutting / Connection / Voltage")
                        imgui.TextWrapped(isRO and u8("- Reglare Voltaj: Cresteti/scadeti voltajul curent pana devine identic cu cel optim (de 3 ori pentru a trece).") or "- Voltage Regulation: Increase/decrease current voltage until it matches the optimal one (3 times to pass).")
                    imgui.EndChild()
                    
                    imgui.Columns(1)   
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), isRO and u8("Nota: In incaperea speciala aveti un timp limita sa terminati minijocurile si seiful, altfel jaful va esua.") or "Note: In the special room you have a time limit to finish the minigames and the safe, otherwise the robbery will fail.")
                    imgui.SetWindowFontScale(1.0)

                   elseif selected_system == 9 then -- Rob Team  
                    local isRO = (iniData.settings.lang == 0)

                    imgui.SetWindowFontScale(1.2)  
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), " R O B - T E A M")
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CAPACITATE GRAB SI AVANSARE PE SKILL") or "GRAB CAPACITY AND SKILL PROGRESSION")
                    imgui.SetWindowFontScale(1.0)  
                    imgui.BeginChild("RobGroupEarnings", imgui.ImVec2(0, 145), true)
                        imgui.Columns(3, "robGroupCols", false)
                        imgui.SetColumnWidth(0, 110)  
                        imgui.SetColumnWidth(1, 160)
                        imgui.SetColumnWidth(2, 200) 
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Skill") or "Skill") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Bijuterii / Grab") or "Jewelry / Grab") imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Avansare (Jafuri Necesare)") or "Progression (Robberies Needed)") imgui.NextColumn()
                        imgui.Separator()

                        local robGroupData = {
                            {"Skill 1", "25 "..(isRO and u8("bijuterii") or "jewelry"), isRO and u8("25 jafuri -> Skill 2") or "25 robberies -> Skill 2"},
                            {"Skill 2", "30 "..(isRO and u8("bijuterii") or "jewelry"), isRO and u8("50 jafuri -> Skill 3") or "50 robberies -> Skill 3"},
                            {"Skill 3", "35 "..(isRO and u8("bijuterii") or "jewelry"), isRO and u8("100 jafuri -> Skill 4") or "100 robberies -> Skill 4"},
                            {"Skill 4", "40 "..(isRO and u8("bijuterii") or "jewelry"), isRO and u8("200 jafuri -> Skill 5") or "200 robberies -> Skill 5"},
                            {"Skill 5", "45 "..(isRO and u8("bijuterii") or "jewelry"), isRO and u8("Maxim") or "Max"}
                        }
                        for _, v in ipairs(robGroupData) do
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), v[1]) imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), v[2]) imgui.NextColumn()
                            imgui.Text(v[3]) imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    imgui.Spacing()
                    
                    imgui.Columns(2, "robGroupInfo", false)    
                    imgui.SetWindowFontScale(1.2)  
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("RESURSE & PROCES") or "RESOURCES & PROCESS")
                    imgui.BeginChild("RobGroupReqs", imgui.ImVec2(0, 400), true) 
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Resurse Necesare:") or "Required Resources:")
                        imgui.BulletText(isRO and u8("Echipa de minim 4 si maxim 8 membri.") or "Team of min 4 and max 8 members.")
                        imgui.BulletText(isRO and u8("Fiecare membru: minim nivel 7 & 10 robpoints.") or "Each member: min level 7 & 10 robpoints.")
                        imgui.BulletText(isRO and u8("Cel putin un membru trebuie sa aiba licenta de pilot.") or "At least one member must have a pilot license.")
                        imgui.BulletText(isRO and u8("Cazier curat (fara wanted) pentru toti membrii.") or "Clean criminal record (no wanted) for all members.")
                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Procesul de Jaf:") or "Robbery Process:")
                        imgui.TextWrapped(isRO and u8("Liderul alege 1 din 21 locatii prin /rob (Next Step). Se deblocheaza chat-ul /rc. Liderul atribuie cele 4 roluri. Dupa indeplinirea misiunilor rolurilor, se intra in magazin.") or "The leader chooses 1 of 21 locations via /rob (Next Step). /rc chat unlocks. The leader assigns 4 roles. After completing role missions, you enter the shop.")
                        imgui.Spacing()
                        imgui.TextWrapped(isRO and u8("In magazin sunt 15 mese a cate 40 bijuterii (Total: 600 bijuterii).") or "In the shop there are 15 tables with 40 jewelry each (Total: 600 jewelry).")
                    imgui.EndChild()
                    imgui.NextColumn()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("COMENZI SPECIFICE") or "SPECIFIC COMMANDS")
                    imgui.BeginChild("RobGroupCmds", imgui.ImVec2(0, 400), true) 
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/rob")
                        imgui.TextWrapped(isRO and u8("Meniul principal al jafului, gestionare membri, invitatii (max 8) si pornire.") or "Main robbery menu, member management, invites (max 8) and start.")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/robbers")
                        imgui.TextWrapped(isRO and u8("Lista de cautare echipa (max 60 jucatori, stergere dupa 10 min). Interzis pt: PD, < Lvl 7, wanted, < 10 puncte jaf sau deja in echipa.") or "Team search list (max 60 players, clears after 10 min). Forbidden for: PD, < Lvl 7, wanted, < 10 rob points or already in team.")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("/accept rob [id] | /cancel rob") or "/accept rob [id] | /cancel rob")
                        imgui.TextWrapped(isRO and u8("Accepta invitatia / Anuleaza jaful (lider) sau paraseste echipa (membru).") or "Accept invite / Cancel robbery (leader) or leave team (member).")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/grab | /drop | /rc")
                        imgui.TextWrapped(isRO and u8("/grab: Fura bijuterii de la mese.\n/drop: Depoziteaza bijuteriile in vehicul.\n/rc: Chatul echipei de jaf.") or "/grab: Steal jewelry from tables.\n/drop: Store jewelry in vehicle.\n/rc: Robbery team chat.")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "/enter | /goup | /godown")
                        imgui.TextWrapped(isRO and u8("Accesarea interiorului sau a acoperisurilor marcate.") or "Access the marked interior or rooftops.")
                    imgui.EndChild()
                    imgui.Columns(1)   
                    imgui.Separator()
                    imgui.SetWindowFontScale(1.2) 
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.7), isRO and u8("Formula Castig: [ (Bijuterii Furate * 626) - 20000 ] / Numar Membri") or "Gain Formula: [ (Jewelry Stolen * 626) - 20000 ] / Number of Members")
                    imgui.SetWindowFontScale(1.0)

                    elseif selected_system == 10 then -- ESCAPE
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.0, 1.0), "--- ESCAPE ---")
                    imgui.Separator()
                    
                    imgui.BeginChild("EscapeLocalBox", imgui.ImVec2(0, 220), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("CONDITII SI SPARGERE GARD:") or "REQUIREMENTS AND FENCE BREAKING:")
                        
                        if isRO then
                            imgui.BulletText(u8("Minim 20 puncte evadare, grup max 6 oameni, timp jail > 500s."))
                            imgui.BulletText(u8("/escape (formare grup) -> mergi la gard -> /hit pentru a lovi."))
                            imgui.TextWrapped(u8("Fiecare /hit alerteaza politistii pe o raza de 15 metri. Gardul are HP limitat."))
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), u8("CONSECINTE:"))
                            imgui.TextWrapped(u8("Primiti Wanted 6 fara drept, marcat pe harta. Alt jucator poate folosi /snitch pe tine pentru o reducere a pedepsei sale."))
                        else
                            imgui.BulletText("Min 20 escape points, max group of 6, jail time > 500s.")
                            imgui.BulletText("/escape (form group) -> go to the fence -> /hit to strike.")
                            imgui.TextWrapped("Every /hit alerts police within 15 meters. The fence has limited HP.")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "CONSEQUENCES:")
                            imgui.TextWrapped("You receive Wanted 6 non-bailable, marked on the map. Another player can use /snitch on you for a sentence reduction.")
                        end
                    imgui.EndChild()

                elseif selected_system == 11 then -- JAIL
                    local isRO = (iniData.settings.lang == 0)
                    local titleColor = imgui.ImVec4(0.9, 0.2, 0.2, 1.0)
                    local sectionColor = imgui.ImVec4(1.0, 0.8, 0.0, 1.0)
                    local highlight = imgui.ImVec4(0.0, 1.0, 1.0, 1.0)

                    imgui.TextColored(titleColor, isRO and "--- INFORMATII INCHISOARE ---" or "--- PRISON INFORMATION ---")
                    imgui.Separator()
                    imgui.BeginChild("JailMainBox", imgui.ImVec2(0, 0), true)

                        -- Informatii Reguli
                        imgui.TextColored(sectionColor, isRO and "REGULI SI FUNCTIONARE" or "RULES AND OPERATIONS")
                        imgui.Indent()
                            imgui.TextWrapped(isRO and "Celulele se deschid la fix si la jumatate (08:00-02:00) pentru 10 min. Kill-ul in jail adauga 2 min la pedeapsa." or "Cells open on the hour and half-hour (08:00-02:00) for 10 min. Killing in jail adds 2 mins to sentence.")
                            imgui.BulletText(isRO and "[/surrender] - Predare automata daca nu e politist." or "[/surrender] - Auto-surrender if no police online.")
                            imgui.BulletText(isRO and "Puncte: +1 evadare/PayDay real." or "Points: +1 escape point/real PayDay.")
                        imgui.Unindent()
                        imgui.Spacing()

                        -- Tabel Detaliat
                        imgui.TextColored(sectionColor, isRO and "STATISTICI WANTED - FULL" or "WANTED STATISTICS - FULL")
                        imgui.Separator()

                        imgui.Columns(5, "jail_full_table", true)
                        imgui.SetColumnWidth(0, 65); imgui.Text("Wanted"); imgui.NextColumn()
                        imgui.SetColumnWidth(1, 95); imgui.Text(isRO and "Timp (C/F)" or "Time (W/O)"); imgui.NextColumn()
                        imgui.SetColumnWidth(2, 70); imgui.Text(isRO and "Arestat" or "Arrested"); imgui.NextColumn()
                        imgui.SetColumnWidth(3, 70); imgui.Text(isRO and "Omorat" or "Killed"); imgui.NextColumn()
                        imgui.Text(isRO and "Cautiune" or "Bail"); imgui.NextColumn()
                        imgui.Separator()

                        local times = {"240/500 sec.", "480/1000 sec.", "600/1500 sec.", "840/2000 sec.", "960/2500 sec.", "1080/3000 sec."}
                        local arrested = {"$800", "$1.500", "$2.500", "$4.000", "$6.000", "$7.000"}
                        local killed = {"$1.340", "$2.640", "$3.940", "$5.240", "$6.540", "$7.840"}
                        local bail = {"$4.000", "$6.500", "$8.000", "$11.000", "$13.500", "$15.000"}

                        for i = 1, 6 do
                            imgui.TextColored(highlight, "Wanted "..i); imgui.NextColumn()
                            imgui.Text(times[i]); imgui.NextColumn()
                            imgui.Text(arrested[i]); imgui.NextColumn()
                            imgui.Text(killed[i]); imgui.NextColumn()
                            imgui.Text(bail[i]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                        
                        imgui.Separator()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1.0), isRO and "* Nota: Banii de cautiune trebuie sa fie in mana (cash)." or "* Note: Bail money must be in hand (cash).")

                    imgui.EndChild()

                    elseif selected_system == 12 then -- SKINURI FACTIUNI
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(0.0, 0.6, 1.0, 1.0), isRO and u8("--- SKINURI FACTIUNI SI MODELE ---") or "--- FACTION SKINS AND MODELS ---")
                    imgui.Separator()
                    imgui.BeginChild("FactionSkinsBox", imgui.ImVec2(0, 700), true)                    
                        -- DEPARTAMENTE
                        imgui.TextColored(imgui.ImVec4(0.2, 0.4, 1.0, 1.0), isRO and u8("DEPARTAMENTE (POLITIE / FBI / NG)") or "DEPARTMENTS (POLICE / FBI / NG)") 
                        imgui.Bullet() imgui.Text(isRO and u8("Politie (LSPD/LVPD/SFPD):") or "Police (LSPD/LVPD/SFPD):")
                        imgui.TextDisabled(isRO and u8("  Rank 1: ID 71 (wmysgrd) | Rank 2: ID 284/280 (lapdm1/lapd1)\n  Rank 3: ID 281/282 (sfpd1/lvpd1) | Rank 4: ID 266 (pulaski)\n  Rank 5: ID 283/288 (csher/dsher) | Rank 6: ID 267/265 (Hernandez/tenpen)") or "  Rank 1: ID 71 (wmysgrd) | Rank 2: ID 284/280 (lapdm1/lapd1)\n  Rank 3: ID 281/282 (sfpd1/lvpd1) | Rank 4: ID 266 (pulaski)\n  Rank 5: ID 283/288 (csher/dsher) | Rank 6: ID 267/265 (Hernandez/tenpen)")
                        imgui.Spacing()
                        imgui.Bullet() imgui.Text("F.B.I & National Guard:") 
                        imgui.TextDisabled("  FBI: ID 163 (Rank 1), 164 (Rank 2), 166 (Rank 3/4), 286 (Rank 5), 295 (Rank 6)\n  NG: ID 285 (Rank 1-3), 287 (Rank 4/5), 179 (Rank 6)")
                        
                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                        -- FACTIUNI PASNICE
                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("FACTIUNI PASNICE") or "PEACEFUL FACTIONS")   
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(1.0, 0.6, 0.6, 1.0), isRO and u8("Paramedici:") or "Paramedics:") 
                        imgui.TextDisabled(isRO and u8("  Rank 1-2: ID 276, 275 | Rank 3-4: ID 277-279, 274 | Fata: ID 150") or "  Rank 1-2: ID 276, 275 | Rank 3-4: ID 277-279, 274 | Female: ID 150") 
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.4, 1.0), "Taxi (LS/LV/SF):") 
                        imgui.TextDisabled(isRO and u8("  Rank 1-3: ID 255 | Rank 4-5: ID 253 | Rank 6: ID 61 | Fata: ID 219") or "  Rank 1-3: ID 255 | Rank 4-5: ID 253 | Rank 6: ID 61 | Female: ID 219") 
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), isRO and u8("Instructori:") or "Instructors:") 
                        imgui.TextDisabled("  Rank 1: ID 153 | Rank 2-3: ID 60 | Rank 4-5: ID 240 | Rank 6: ID 171")
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(0.8, 0.6, 1.0, 1.0), isRO and u8("News Reporters:") or "News Reporters:") 
                        imgui.TextDisabled(isRO and u8("  Rank 1-3: ID 188, 17 | Rank 4-6: ID 187, 147 | Fata: ID 191") or "  Rank 1-3: ID 188, 17 | Rank 4-6: ID 187, 147 | Female: ID 191") 

                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                        -- MAFII SI GANG-URI
                        imgui.TextColored(imgui.ImVec4(1.0, 0.2, 0.2, 1.0), isRO and u8("MAFII SI GANG-URI") or "MAFIAS AND GANGS")
                        imgui.BeginChild("MafiiGrid", imgui.ImVec2(0, 310), true)
                            imgui.Columns(4, "mafiiCols", true)
                            imgui.TextColored(imgui.ImVec4(0.2, 0.67, 0.2, 1.0), "G.S. Bloods"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.4, 0.4, 0.4, 1.0), "Verdant Fam"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.54, 0.63, 0.62, 1.0), "Viet Boys"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.58, 0.38, 0.25, 1.0), "Tsar Bratva"); imgui.NextColumn()
                            imgui.Separator() 
                            imgui.Text(isRO and u8("Rank 1: 106\nRank 2: 271\nRank 4: 269\nRank 6: 270\nF: 195") or "Rank 1: 106\nRank 2: 271\nRank 4: 269\nRank 6: 270\nF: 195"); imgui.NextColumn()
                            imgui.Text("Rank 1-5: 124\nRank 1-5: 125\nRank 1-5: 127\nRank 6: 126\nF: 12"); imgui.NextColumn()
                            imgui.Text(isRO and u8("Rank 1-2: 122\nRank 3: 121\nRank 4: 123\nRank 6: 223\nF: 226") or "Rank 1-2: 122\nRank 3: 121\nRank 4: 123\nRank 6: 223\nF: 226"); imgui.NextColumn()
                            imgui.Text("Rank 1: 272\nRank 2: 111\nRank 3-5: 112\nRank 6: 113"); imgui.NextColumn()
                            imgui.Separator() 
                            imgui.TextColored(imgui.ImVec4(0.82, 0.0, 0.06, 1.0), "R.D. Triad"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.7, 0.17, 0.96, 1.0), "South Pim"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.2, 0.8, 1.0, 1.0), "69 Pier Mob"); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.23, 0.27, 0.05, 1.0), "Avispa Rifa"); imgui.NextColumn()
                            imgui.Separator()
                            imgui.Text(isRO and u8("Rank 1-2: 117\nRank 3-4: 118\nRank 5: 208\nRank 6: 120\nF: 169") or "Rank 1-2: 117\nRank 3-4: 118\nRank 5: 208\nRank 6: 120\nF: 169"); imgui.NextColumn()
                            imgui.Text(isRO and u8("Rank 1: 185\nRank 2: 102\nRank 3-4: 104\nRank 6: 296\nF: 55") or "Rank 1: 185\nRank 2: 102\nRank 3-4: 104\nRank 6: 296\nF: 55"); imgui.NextColumn()
                            imgui.Text("Rank 1: 114\nRank 2: 116\nRank 3-5: 115\nRank 6: 46"); imgui.NextColumn()
                            imgui.Text(isRO and u8("Rank 1: 175\nRank 2-3: 174\nRank 4-5: 173\nRank 6: 3\nF: 233") or "Rank 1: 175\nRank 2-3: 174\nRank 4-5: 173\nRank 6: 3\nF: 233"); imgui.NextColumn()
                            imgui.Separator()
                            imgui.TextColored(imgui.ImVec4(1.0, 0.6, 0.0, 1.0), "El Loco"); imgui.NextColumn(); imgui.NextColumn(); imgui.NextColumn(); imgui.NextColumn()
                            imgui.Separator()
                            imgui.Text(isRO and u8("Rank 1-5: 108\nRank 1-5: 109\nRank 1-5: 110\nRank 6: 292\nF: 193") or "Rank 1-5: 108\nRank 1-5: 109\nRank 1-5: 110\nRank 6: 292\nF: 193"); imgui.NextColumn(); imgui.NextColumn(); imgui.NextColumn(); imgui.NextColumn()
                            imgui.Columns(1)
                        imgui.EndChild()

                        imgui.Spacing(); imgui.Separator(); imgui.Spacing()

                        -- HITMAN / SOA
                        imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1.0), "HITMAN / SOA")
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(0.8, 0.2, 0.2, 1.0), isRO and u8("Agentia Hitman:") or "Hitman Agency:") 
                        imgui.TextDisabled("  Rank 1: ID 186 | Rank 2-3: ID 208 | Rank 4-6: ID 294") 
                        imgui.Bullet() imgui.TextColored(imgui.ImVec4(0.2, 0.4, 0.2, 1.0), "Sons of Anarchy:") 
                        imgui.TextDisabled("  Rank 1: ID 241 | Rank 2: ID 133 | Rank 4-5: ID 181 | Rank 6: ID 100")
                    imgui.EndChild()

                    elseif selected_system == 13 then -- LICENTE
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), isRO and u8("--- SISTEMUL DE LICENTE ---") or "--- LICENSE SYSTEM ---")
                    imgui.Separator()
                    imgui.BeginChild("LicensesMainBox", imgui.ImVec2(0, 650), true)

                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("INFO GENERAL SI OBTINERE") or "GENERAL INFO AND OBTAINING")   
                        imgui.BeginChild("LicenteObtinereBox", imgui.ImVec2(0, 95), true)
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("> Tipuri:") or "> Types:")
                            imgui.SameLine()
                            imgui.TextWrapped(isRO and u8("Zbor, Navigatie, Pescuit, Materiale (Lvl 1), Port-Arma (Lvl 5).") or "Flight, Sailing, Fishing, Materials (Lvl 1), Gun License (Lvl 5).")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("> Obtinere:") or "> Obtaining:")
                            imgui.SameLine()
                            imgui.TextWrapped(isRO and u8("[/needlicense] (instructor) sau NPC la HQ S.I. (cost x5).") or "[/needlicense] (instructor) or NPC at S.I. HQ (cost x5).")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("> Valabilitate:") or "> Validity:")
                            imgui.SameLine()
                            imgui.TextWrapped(isRO and u8("100 ore. Scade cu 1h la PayDay (inclusiv pe /sleep).") or "100 hours. Decreases by 1h at PayDay (including during /sleep).")
                        imgui.EndChild()

                        imgui.Spacing()

                        imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.4, 1.0), isRO and u8("SUSPENDARE PERMIS (ROADS)") or "LICENSE SUSPENSION (ROADS)")  
                        imgui.BeginChild("LicenteRoadsBox", imgui.ImVec2(0, 150), true)
                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), isRO and u8("Confiscare permis pentru 1 ORA:") or "License confiscation for 1 HOUR:")
                            imgui.BulletText(isRO and u8("NOS, Hidraulice, Contrasens, Alcool (3.0), Parcare neregulamentara.") or "NOS, Hydraulics, Wrong way, Alcohol (3.0), Illegal parking.")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), isRO and u8("Confiscare dupa VITEZA:") or "Confiscation by SPEEDING:")
                            imgui.BulletText(isRO and u8("Oras (lim. 100): 150-199 km/h (1h) | 200+ km/h (2h).") or "City (limit 100): 150-199 km/h (1h) | 200+ km/h (2h).")
                            imgui.BulletText(isRO and u8("Afara (lim. 130): 180-229 km/h (1h) | Autostrada (lim. 160): 210+ km/h (1h).") or "Outside (limit 130): 180-229 km/h (1h) | Highway (limit 160): 210+ km/h (1h).")
                        imgui.EndChild()

                        imgui.Spacing()

                        imgui.TextColored(imgui.ImVec4(0.6, 0.4, 1.0, 1.0), isRO and u8("COSTURI LICENTE (INSTRUCTOR)") or "LICENSE COSTS (INSTRUCTOR)")
                        imgui.BeginChild("LicenteCostBox", imgui.ImVec2(0, 175), true)
                            imgui.Columns(4, "costCols", true)
                            imgui.Text(isRO and u8("Tip") or "Type"); imgui.NextColumn()
                            imgui.Text("Lvl 1-9"); imgui.NextColumn()
                            imgui.Text("Lvl 10-49"); imgui.NextColumn()
                            imgui.Text("Lvl 50+"); imgui.NextColumn()
                            imgui.Separator()
                            
                            local types = {
                                {isRO and u8("Pescar") or "Fishing", "$250", "$500", "$1.000"},
                                {isRO and u8("Materiale") or "Materials", "$800", "$1.600", "$3.200"},
                                {isRO and u8("Navigatie") or "Sailing", "$850", "$1.700", "$3.400"},
                                {isRO and u8("Zbor") or "Flight", "$900", "$1.800", "$3.600"},
                                {isRO and u8("Arme") or "Weapons", "$1.000", "$2.000", "$4.000"}
                            }
                            for _, row in ipairs(types) do
                                imgui.Text(row[1]); imgui.NextColumn(); imgui.Text(row[2]); imgui.NextColumn(); imgui.Text(row[3]); imgui.NextColumn(); imgui.Text(row[4]); imgui.NextColumn()
                            end
                            imgui.Separator()
                            imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), "TOTAL"); imgui.NextColumn()
                            imgui.Text("$3.800"); imgui.NextColumn(); imgui.Text("$7.600"); imgui.NextColumn(); imgui.Text("$15.200"); imgui.Columns(1)
                        imgui.EndChild()

                        imgui.Spacing()
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Preturile la NPC sunt de 5 ori (x5) mai mari decat cele de mai sus.") or "Tip: NPC prices are 5 times (x5) higher than those above.")
                    imgui.EndChild()

                   elseif selected_system == 14 then -- NIVELURI MINIME
                    local isRO = (iniData.settings.lang == 0)

                    -- Functie locala pentru emularea culorilor stil SAMP
                    local function renderSampStyleText(text)
                        local pos = 1
                        while pos <= #text do
                            local start, stop, color = text:find("{(%x%x%x%x%x%x)}", pos)
                            if start then
                                if start > pos then
                                    imgui.TextUnformatted(text:sub(pos, start - 1))
                                    imgui.SameLine(0, 0)
                                end
                                local r = tonumber(color:sub(1, 2), 16) / 255
                                local g = tonumber(color:sub(3, 4), 16) / 255
                                local b = tonumber(color:sub(5, 6), 16) / 255
                                imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(r, g, b, 1.0))
                                pos = stop + 1
                                local next_start = text:find("{%x%x%x%x%x%x}", pos)
                                local segment = text:sub(pos, (next_start or #text + 1) - 1)
                                imgui.TextUnformatted(segment)
                                if next_start then imgui.SameLine(0, 0) end
                                imgui.PopStyleColor()
                                pos = next_start or #text + 1
                            else
                                imgui.TextUnformatted(text:sub(pos))
                                break
                            end
                        end
                    end

                    imgui.TextColored(imgui.ImVec4(1.0, 0.5, 0.0, 1.0), isRO and u8("--- NIVELURI MINIME ---") or "--- MINIMUM LEVELS ---")
                    imgui.Separator()
                    imgui.BeginChild("NivelsMainBox", imgui.ImVec2(0, 540), true)
                        
                        -- SOCIAL SI JOCURI DE NOROC
                        imgui.TextColored(imgui.ImVec4(0.4, 0.4, 1.0, 1.0), isRO and u8("SOCIAL SI JOCURI DE NOROC") or "SOCIAL AND GAMBLING")   
                        imgui.BeginChild("NiveliSocialBox", imgui.ImVec2(0, 140), true)
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/barbut - nivel minim {44A564}1{FFFFFF}.") or "{FFFFFF}/barbut - minimum level {44A564}1{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/spin - nivel minim {44A564}1{FFFFFF}.") or "{FFFFFF}/spin - minimum level {44A564}1{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}Poker - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}Poker - minimum level {44A564}3{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/ad - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}/ad - minimum level {44A564}3{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/w - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}/w - minimum level {44A564}3{FFFFFF}.")
                        imgui.EndChild()

                        imgui.Spacing()

                        -- ECONOMIE  
                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("ECONOMIE") or "ECONOMY")  
                        imgui.BeginChild("NiveliEconBox", imgui.ImVec2(0, 120), true)
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/trade - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}/trade - minimum level {44A564}3{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/transfer - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}/transfer - minimum level {44A564}3{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}A cumpara un vehicul personal - nivel minim {44A564}3{FFFFFF}.") or "{FFFFFF}Buy a personal vehicle - minimum level {44A564}3{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}A vinde masina de la tutorial - nivel minim {44A564}5{FFFFFF}.") or "{FFFFFF}Sell tutorial car - minimum level {44A564}5{FFFFFF}.")
                        imgui.EndChild()

                        imgui.Spacing()

                        -- ACTIVITATI SPECIALE
                        imgui.TextColored(imgui.ImVec4(1.0, 0.3, 0.3, 1.0), isRO and u8("ACTIVITATI SPECIALE") or "SPECIAL ACTIVITIES")
                        imgui.BeginChild("NiveliIlegalBox", imgui.ImVec2(0, 120), true)
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/rob - nivel minim {44A564}7{FFFFFF}.") or "{FFFFFF}/rob - minimum level {44A564}7{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/escape - nivel minim {44A564}7{FFFFFF}.") or "{FFFFFF}/escape - minimum level {44A564}7{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}/requestevent - nivel minim {44A564}10{FFFFFF}.") or "{FFFFFF}/requestevent - minimum level {44A564}10{FFFFFF}.")
                            imgui.Bullet(); imgui.SameLine(); renderSampStyleText(isRO and u8("{FFFFFF}Cumparare bunker - nivel minim {44A564}10{FFFFFF}.") or "{FFFFFF}Buy bunker - minimum level {44A564}10{FFFFFF}.")
                        imgui.EndChild()

                        imgui.Spacing(); imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Cresterea in nivel se face automat prin acumularea orelor jucate (PayDay).") or "Tip: Leveling up is done automatically by accumulating play hours (PayDay).")
                    imgui.EndChild()

                    elseif selected_system == 15 then -- REFERRAL
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("--- SISTEMUL DE REFERRAL ---") or "--- REFERRAL SYSTEM ---")
                    imgui.Separator()
                    imgui.BeginChild("ReferralMainBox", imgui.ImVec2(0, 540), true)
                        
                        local whiteColor  = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                        local yellowColor = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                        local greenColor  = imgui.ImVec4(0.27, 0.65, 0.39, 1.0)

                        -- INFO GENERAL                           
                        imgui.TextColored(yellowColor, isRO and u8("INFO GENERAL") or "GENERAL INFO")
                        imgui.BeginChild("RefGeneralBox", imgui.ImVec2(0, 85), true)
                            imgui.TextWrapped(isRO and u8("Sistemul de referral este o modalitate prin care poti castiga bonusuri invitandu-ti prietenii la joc.") or "The referral system is a way for you to earn bonuses by inviting your friends to the game.")
                            imgui.Spacing()
                            imgui.TextWrapped(isRO and u8("Acest sistem te va ajuta sa cresti mai repede in nivel si sa castigi bani mai usor.") or "This system will help you level up faster and earn money more easily.")
                        imgui.EndChild()

                        imgui.Spacing()

                        -- CALCUL BONUSURI (/buylevel)                            
                        imgui.TextColored(yellowColor, isRO and u8("CALCUL BONUSURI (/buylevel)") or "BONUS CALCULATION (/buylevel)")
                        imgui.BeginChild("RefRewardsBox", imgui.ImVec2(0, 100), true)
                            imgui.TextColored(whiteColor, isRO and u8("Vei primi bonusuri cand prietenii tai cumpara nivel:") or "You will receive bonuses when your friends buy levels:")
                            imgui.Spacing()
                            
                            imgui.PushStyleColor(imgui.Col.Text, greenColor)
                            imgui.TextUnformatted("10'/.")
                            imgui.PopStyleColor()
                            imgui.SameLine()
                            imgui.TextColored(whiteColor, isRO and u8(" -> din punctele de respect (RP) ale prietenului.") or " -> of the friend's Respect Points (RP).")
                            
                            imgui.Spacing()
                            
                            imgui.PushStyleColor(imgui.Col.Text, greenColor)
                            imgui.TextUnformatted("100'/.")
                            imgui.PopStyleColor()
                            imgui.SameLine()
                            imgui.TextColored(whiteColor, isRO and u8(" -> din suma de bani platita de prieten.") or " -> of the money paid by the friend.")
                        imgui.EndChild()

                        -- COMENZI DISPONIBILE                            
                        imgui.TextColored(yellowColor, isRO and u8("COMENZI DISPONIBILE") or "AVAILABLE COMMANDS")
                        imgui.BeginChild("RefCmdsBox", imgui.ImVec2(0, 65), true)
                            imgui.TextColored(greenColor, "/referrals") imgui.SameLine()
                            imgui.TextColored(whiteColor, isRO and u8(" -> Vezi lista referralilor online.") or " -> See the list of online referrals.")
                        imgui.EndChild()

                        imgui.Spacing()
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Codul tau de referral este ID-ul tau de cont (vezi pe /stats).") or "Tip: Your referral code is your account ID (see /stats).")

                    imgui.EndChild()

                   elseif selected_system == 16 then -- SAFEBOX
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), isRO and u8("--- SISTEMUL DE SAFEBOX ---") or "--- SAFEBOX SYSTEM ---")
                    imgui.Separator()
                    imgui.BeginChild("SafeboxMainBox", imgui.ImVec2(0, 650), true)

                        local whiteColor  = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                        local yellowColor = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                        local greenColor  = imgui.ImVec4(0.27, 0.65, 0.39, 1.0)
                        local grayColor   = imgui.ImVec4(0.6, 0.6, 0.6, 1.0)

                        imgui.TextColored(yellowColor, isRO and u8("ACHIZITIE SI ADMINISTRARE") or "ACQUISITION AND MANAGEMENT")
                        imgui.BeginChild("SBGeneralBox", imgui.ImVec2(0, 120), true)
                            imgui.BulletText(isRO and u8("Pret: 600 Gold in [/shop].") or "Price: 600 Gold in [/shop].")
                            imgui.BulletText(isRO and u8("Limita: Poti detine pana la 50 de Safebox-uri.") or "Limit: You can own up to 50 Safeboxes.")
                            imgui.BulletText(isRO and u8("Gestiune: Foloseste [/safeboxes] sau [/sb] pentru lista.") or "Management: Use [/safeboxes] or [/sb] for the list.")
                            imgui.BulletText(isRO and u8("Actiuni: Amplasare, stergere, localizare sau modificare pozitie.") or "Actions: Place, delete, locate, or modify position.")
                            imgui.TextColored(grayColor, isRO and u8(" * Nota: Se pot spawn doar in lumea virtuala 0 (exterior).") or " * Note: Can only be spawned in virtual world 0 (outside).")
                        imgui.EndChild()

                        imgui.Spacing()

                        imgui.TextColored(yellowColor, isRO and u8("UTILIZARE SI OPERATIUNI") or "USAGE AND OPERATIONS")
                        imgui.BeginChild("SBOpsBox", imgui.ImVec2(0, 145), true)
                            imgui.TextColored(greenColor, "[/opensafe]") imgui.SameLine()
                            imgui.TextColored(whiteColor, isRO and u8(" (sau F/ENTER) -> Deschide seiful.") or " (or F/ENTER) -> Opens the safe.")
                            imgui.BulletText(isRO and u8("Redenumire: Click pe titlu (maxim 30 caractere).") or "Rename: Click on title (max 30 characters).")
                            imgui.BulletText(isRO and u8("Depozitare: Meniul din dreapta (arme, materiale, droguri).") or "Store: Menu on the right (weapons, materials, drugs).")
                            imgui.BulletText(isRO and u8("Extragere: Click pe numele elementului dorit.") or "Withdraw: Click on the item name.")
                            imgui.BulletText(isRO and u8("Functia 'throw': Tasteaza 'throw' pentru a goli un slot blocat.") or "'throw' function: Type 'throw' to empty a blocked slot.")
                            imgui.TextColored(grayColor, isRO and u8(" * Exemplu: Scapi de Tec-9/Sniper daca nu mai ai factiunea.") or " * Example: Get rid of Tec-9/Sniper if you are no longer in the faction.")
                        imgui.EndChild()

                        imgui.Spacing()

                        imgui.TextColored(yellowColor, isRO and u8("CONSUM UNITATI (DUPA SKILL ARMS DEALER)") or "UNIT CONSUMPTION (BY ARMS DEALER SKILL)")
                        imgui.BeginChild("SBCalcBox", imgui.ImVec2(0, 185), true)
                            imgui.Columns(2, "sbTableCols", true)
                            imgui.SetColumnWidth(0, 180)
                            
                            imgui.TextColored(greenColor, isRO and u8("Arma") or "Weapon"); imgui.NextColumn()
                            imgui.TextColored(greenColor, isRO and u8("Unitati (S1 -> S5)") or "Units (S1 -> S5)"); imgui.NextColumn()
                            imgui.Separator()        
                            
                            imgui.Text("Deagle / SD Pistol"); imgui.NextColumn(); imgui.Text("30 / 26 / 22 / 18 / 14"); imgui.NextColumn()
                            imgui.Text("Combat / Shotgun"); imgui.NextColumn(); imgui.Text("40 / 35 / 30 / 25 / 20"); imgui.NextColumn()
                            imgui.Text("MP5 / TEC-9"); imgui.NextColumn(); imgui.Text("15 / 14 / 13 / 12 / 11"); imgui.NextColumn()
                            imgui.Text("M4 / AK-47"); imgui.NextColumn(); imgui.Text("24 / 23 / 22 / 21 / 20"); imgui.NextColumn()
                            imgui.Text("Rifle / Sniper"); imgui.NextColumn(); imgui.Text("350 / 338 / 325 / 313 / 300"); imgui.Columns(1)
                            
                            imgui.Separator()
                            imgui.Text(isRO and u8("Materiale / Droguri: 1 unitate per bucata.") or "Materials / Drugs: 1 unit per piece.")
                        imgui.EndChild()

                        imgui.Spacing()
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Mafiotii pot folosi seifurile la war daca sunt spawnate inainte de incepere.") or "Mafia members can use safes at war if spawned before it starts.")

                    imgui.EndChild()
                    
                    elseif selected_system == 17 then -- VEHICULE TUTORIAL
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), isRO and u8("--- VEHICULE TUTORIAL ---") or "--- TUTORIAL VEHICLES ---")
                    imgui.Separator()
                    imgui.BeginChild("VehiclesTutorialBox", imgui.ImVec2(0, 0), true)
                        
                        local greenColor = imgui.ImVec4(0.26, 0.64, 0.40, 1.0)
                        local whiteColor = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)

                        local tutorialData = isRO and {
                            "Nivel 1: jucatorul primeste un Faggio.",
                            "Nivel 2: jucatorul primeste un Perrenial.",
                            "Nivel 3: jucatorul primeste un Bobcat.",
                            "Nivel 4: jucatorul nu primeste alt vehicul.",
                            "Nivel 5: jucatorul primeste o Bravura.",
                            "Nivel 6: jucatorul nu primeste alt vehicul.",
                            "Nivel 7: jucatorul primeste un Landstalker."
                        } or {
                            "Level 1: the player receives a Faggio.",
                            "Level 2: the player receives a Perrenial.",
                            "Level 3: the player receives a Bobcat.",
                            "Level 4: the player receives no other vehicle.",
                            "Level 5: the player receives a Bravura.",
                            "Level 6: the player receives no other vehicle.",
                            "Level 7: the player receives a Landstalker."
                        }

                        for _, msg in ipairs(tutorialData) do
                            imgui.TextColored(greenColor, ">>")
                            imgui.SameLine()
                            imgui.TextColored(whiteColor, u8(msg))
                            imgui.Spacing()
                        end

                    imgui.EndChild()

                    elseif selected_system == 18 then -- ECONOMIE TUTORIAL
                    local isRO = (iniData.settings.lang == 0)
                    
                    imgui.SetWindowFontScale(1.2) 

                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.5, 1.0), isRO and u8("--- ECONOMIE ---") or "--- ECONOMY ---")
                    imgui.Separator()
                    
                    imgui.BeginChild("EconomyTutorialBox", imgui.ImVec2(0, 0), true)
                        local green = imgui.ImVec4(0.26, 0.64, 0.40, 1.0)
                        local white = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
                        local yellow = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)

                        -- Functie pentru titlu categorie
                        local function Category(name)
                            imgui.Spacing()
                            imgui.TextColored(yellow, name)
                        end

                        -- Functie pentru item lista
                        local function Item(text)
                            imgui.TextColored(green, ">>")
                            imgui.SameLine()
                            imgui.TextColored(white, u8(text))
                        end

                        Category(isRO and "--- SERVICII & COMBUSTIBIL ---" or "--- SERVICES & FUEL ---")
                        Item("Combustibil: 5$ / '/. (litru)")
                        Item("Spital: 100$ | PnS: 200$ | Tractari: 200$")

                        Category(isRO and "--- ARME ---" or "--- WEAPONS ---")
                        Item("Deagle, Shotgun, MP5: 2$ per glont")
                        Item("SDPistol: 1$ per glont")
                        Item("M4, Ak47, Rifle: 3$ per glont")

                        Category(isRO and "--- BAUTURI ---" or "--- DRINKS ---")
                        Item("Bere(12$), Vin(21$), Whiskey(38$)")
                        Item("Vodka, Apa, Soda: 30$")
                        Item("Sprunk, Cafea: 23$")

                        Category(isRO and "--- OBIECTE (/buy) ---" or "--- ITEMS (/buy) ---")
                        Item("Telefon: 1.500$ | Statie emisie: 5.000$")
                        Item("MP3, Canistra: 2.000$ | Artificii: 1.000$")
                        Item("Zaruri: 500$ | Bricheta: 300$ | Fumigene: 200$")
                        Item("Camera, Tigari: 100$ | Trusa prim ajutor: 50$")

                        Category(isRO and "--- ALTELE ---" or "--- OTHERS ---")
                        Item("Accesorii (palarii/ochelari) / Costume: 500$")
                        Item("Inmatriculare (/carplate) / Culoare: 500$")
                        Item("Asigurari: 0-100k(500$), 100k-1M(1.000$), 1M-6M(1.500$), 6M+(2.000$)")
                        Item("Job-uri: Castiguri +15'/. | Job-ul Zilei: SUMA DUBLA")

                    imgui.EndChild()                    
                    imgui.SetWindowFontScale(1.0)  

                    elseif selected_system == 19 then -- AMENZI SI CONFISCARI
                    local isRO = (iniData.settings.lang == 0)

                    imgui.TextColored(imgui.ImVec4(1.0, 0.4, 0.4, 1.0), isRO and u8("--- LEGISLATIE & AMENZI ---") or "--- LEGISLATION & FINES ---")
                    imgui.Separator()
                    imgui.BeginChild("FinesBox", imgui.ImVec2(0, 0), true)
                        
                        local colorHeader = imgui.ImVec4(1.0, 1.0, 0.0, 1.0)
                        local colorText = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)

                        imgui.TextColored(colorHeader, isRO and "Amenzi Trafic" or "Traffic Fines")
                        imgui.TextWrapped(u8("Parcare/Faruri stinse: 720$ (+conf. permis la parcare)"))
                        imgui.TextWrapped(u8("Condus neregulamentar/Incurcare trafic: 600$ + conf. permis"))
                        imgui.TextWrapped(u8("Viteza <50km/h: 840$ | Viteza >50km/h: 1200$ + conf. permis (LVL 8+)"))
                        imgui.TextWrapped(u8("NOS: 480$ + conf. permis | Hidraulice: 240$ + conf. permis"))
                        imgui.TextWrapped(u8("Alcoolemie >3.0: 600$ + conf. permis"))
                        
                        imgui.Separator()
                        imgui.Spacing()
                        imgui.TextColored(colorHeader, isRO and "Alte infractiuni" or "Other Offenses")
                        imgui.TextWrapped(u8("Materiale fara licenta: 120$ + conf. materiale"))
                        imgui.TextWrapped(u8("Vanzare arme (LVL 1-10) / Peste / Mers pe carosabil: 360$"))

                        imgui.Spacing()
                        imgui.Separator()
                        imgui.Spacing()

                        imgui.TextColored(colorHeader, isRO and "Suspendari Permis (Ore)" or "License Suspension (Hours)")
                        imgui.TextWrapped(u8("Alcool 3.0 / Hidraulice: 1 ora"))
                        imgui.TextWrapped(u8("Viteza 50-100km/h: 2 ore | Viteza >100km/h: 4 ore"))
                        imgui.TextWrapped(u8("Condus neregulamentar/Parcare/NOS: 3 ore"))
                        imgui.TextWrapped(u8("Recidiva: 5 ore"))

                        imgui.Spacing()
                        imgui.Separator()
                        imgui.Spacing()

                        imgui.TextColored(colorHeader, isRO and "Exceptii" or "Exceptions")
                        imgui.TextWrapped(u8("LVL 1-3: Doar mustrare."))
                        imgui.TextWrapped(u8("LVL 4-7: Alegere amenda 300$ sau conf. permis."))
                        imgui.TextWrapped(u8("Departamente: 2.000$ amenda pentru abateri."))
                        imgui.TextWrapped(u8("LVL 1-14: Wanted maxim 1 | Runner LVL 1-4: Wanted 1."))
                        imgui.Separator()

                    imgui.EndChild()

                    elseif selected_system == 20 then -- TRADER SHOP
                    local isRO = (iniData.settings.lang == 0)
                    imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), isRO and u8("--- TRADER SHOP ---") or "--- TRADER SHOP ---")
                    imgui.Separator()
                    imgui.BeginChild("TraderMainBox", imgui.ImVec2(0, 720), true)
                        -- MECANICI REROLL & FUZIUNE
                       imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), isRO and u8("MECANICA DE REROLL") or "REROLL MECHANIC")
                        imgui.BeginChild("RerollBox", imgui.ImVec2(0, 180), true)
                            imgui.TextWrapped(isRO and u8("Schimba bonusurile de pe un skin la Traderul Egiptean. Poti alege ce pastrezi (x) si ce schimbi (v).") or "Change bonuses on a skin at the Egyptian Trader. You can choose what to keep (x) and what to reroll (v).")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Costuri Reroll:") or "Reroll Costs:")
                            imgui.BulletText(isRO and u8("1 bonus: $1.000.000 + 50 MP") or "1 bonus: $1,000,000 + 50 MP")
                            imgui.BulletText(isRO and u8("2 bonusuri: $2.000.000 + 100 MP") or "2 bonuses: $2,000,000 + 100 MP")
                            imgui.BulletText(isRO and u8("3 bonusuri: $3.000.000 + 150 MP") or "3 bonuses: $3,000,000 + 150 MP")
                            imgui.BulletText(isRO and u8("4 bonusuri: $4.000.000 + 200 MP") or "4 bonuses: $4,000,000 + 200 MP")
                            imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Tickete necesare: 1-2 bonusuri (1 ticket); 3-4 bonusuri (2 tickete).") or "Tickets required: 1-2 bonuses (1 ticket); 3-4 bonuses (2 tickets).")
                        imgui.EndChild()
                        imgui.Spacing()
                        -- MECANICA FUZIUNE
                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("MECANICA DE FUZIUNE") or "FUSION MECHANIC")
                        imgui.BeginChild("FusionBox", imgui.ImVec2(0, 130), true)
                            imgui.TextWrapped(isRO and u8("Fuzioneaza 2 skinuri Diamond/Onyx. Skinul pastrat primeste bonusurile selectate.") or "Merge 2 Diamond/Onyx skins. The kept skin receives the selected bonuses.")
                            imgui.Spacing()
                            imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Reguli & Costuri:") or "Rules & Costs:")
                            imgui.BulletText(isRO and u8("Diamond: Max 2 bonusuri | $4.000.000 + 400 MP + 3 Tichete Diamond") or "Diamond: Max 2 bonuses | $4,000,000 + 400 MP + 3 Diamond Tickets")
                            imgui.BulletText(isRO and u8("Onyx: Max 4 bonusuri | $6.000.000 + 600 MP + 5 Tichete Onyx") or "Onyx: Max 4 bonuses | $6,000,000 + 600 MP + 5 Onyx Tickets")
                            imgui.Spacing()
                            imgui.TextWrapped(isRO and u8("Nota: Skinurile rezultate primesc eticheta [FUSED]. Fuziunea reseteaza selectia bonusurilor.") or "Note: Resulting skins receive the [FUSED] tag. Fusion resets bonus selection.")
                        imgui.EndChild()
                        -- RARITATE
                        imgui.TextColored(imgui.ImVec4(1.0, 0.4, 1.0, 1.0), isRO and u8("RARITATE SKINURI") or "SKIN RARITY")
                        imgui.BeginChild("RarityBox", imgui.ImVec2(0, 95), true)
                            imgui.TextColored(imgui.ImVec4(1, 0.84, 0, 1), "Legendary: 4 bonusuri speciale (20'/.+)")
                            imgui.TextColored(imgui.ImVec4(0.5, 0.5, 1, 1), "Very Rare: 3 bonusuri speciale (15'/.+)")
                            imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), "Uncommon: 2 bonusuri speciale (10'/.+)")
                            imgui.Text("Common: Restul")
                        imgui.EndChild()
                        -- RECICLARE 
                        imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("SISTEM DE RECICLARE (VALORI)") or "RECYCLING SYSTEM (VALUES)")
                        imgui.BeginChild("RecycleBox", imgui.ImVec2(0, 400), true)
                            imgui.Columns(2, "recycleList", true)
                            imgui.Text(isRO and u8("Item (x100 sau x1)") or "Item"); imgui.NextColumn()
                            imgui.Text(isRO and u8("Gold / Bani") or "Gold / Money"); imgui.NextColumn()
                            imgui.Separator()

                            local recycleItems = {
                                {"Puncte (Acc/MP/Rob/Esc)", "10 Gold / $5.000"},
                                {"Free Bails (x10)", "5 Gold / $2.500"},
                                {"Name/VIP/Hidden/KM/Label", "120 Gold / $60.000"},
                                {"DS Stock", "260 Gold / $120.000"},
                                {"Colored Carplate", "60 Gold / $30.000"},
                                {"Half/FP Clear", "40 Gold / $20.000"},
                                {"Optional/Warn Clear", "80 Gold / $40.000"},
                                {"Job Skill", "280 Gold / $140.000"},
                                {"Wheel Spins", "20 Gold / $10.000"},
                                {"Diamond Fragments", "32 Gold / $16.000"},
                                {"Diamond Tickets", "160 Gold / $80.000"},
                                {"Onyx Fragments", "40 Gold / $20.000"},
                                {"Onyx Tickets", "200 Gold / $100.000"},
                                {"Skin Upgrade Ticket", "120 Gold / $60.000"},
                                {"Skin Upgrade Fragment", "24 Gold / $12.000"},
                                {"Red/Orange Crate", "18-45 MP"},
                                {"Green/White Crate", "30-45 MP"},
                                {"Cyan/Purple/Brown Crate", "45-75 MP"},
                                {"Yellow/Silver/Blue/Olive Crate", "60-75 MP"},
                                {"Magenta/Lime Crate", "105 MP"},
                                {"Pink Crate", "120 MP"}
                            }

                            for _, item in ipairs(recycleItems) do
                                imgui.TextWrapped(item[1]); imgui.NextColumn()
                                imgui.Text(item[2]); imgui.NextColumn()
                            end
                            imgui.Columns(1)
                        imgui.EndChild()

                        elseif selected_system == 21 then -- Payday
                        local isRO = (iniData.settings.lang == 0)
                        imgui.TextColored(imgui.ImVec4(0.0, 0.8, 1.0, 1.0), isRO and u8("--- PayDay ---") or "--- Payday ---")
                        imgui.Separator()
                        imgui.BeginChild("PayDayInfo", imgui.ImVec2(0, 720), true)
                            -- Caracteristici Generale
                        imgui.TextColored(imgui.ImVec4(1.0, 0.8, 0.0, 1.0), isRO and u8("Caracteristici Generale") or "General Features")
                            imgui.BeginChild("MainPayday", imgui.ImVec2(0, 120), true)
                                imgui.TextWrapped(isRO and u8("Payday-ul se acorda la ora exacta (XX:00). Necesita 30 min jucate.") or "Payday is granted at the exact hour (XX:00). Requires 30 mins played.")
                                imgui.Spacing()
                                imgui.BulletText(isRO and u8("Standard: 1 Respect, 1 Rob, 1 Escape, 1 Clear FP, 1 Accept Point.") or "Standard: 1 Respect, 1 Rob, 1 Escape, 1 Clear FP, 1 Accept Point.")
                                imgui.BulletText(isRO and u8("Premium: +25 '/. salariu. La 5 ore: bonus de puncte suplimentare.") or "Premium: +25 '/. salary. Every 5 hours: extra points bonus.")
                                imgui.BulletText(isRO and u8("AFK/Sleep: Acumuleaza doar 1/3 din timp (20min din 60).") or "AFK/Sleep: Accumulates only 1/3 of time (20min out of 60).")
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Dobanda: Standard 0.01 '/. | Dobanda: Premium 0.03 '/.") or "Interest: Standard 0.01 '/. | Interest: Premium 0.03 '/.")
                            imgui.EndChild()
                            imgui.Spacing()
                            -- Bonusuri Detaliate
                            imgui.TextColored(imgui.ImVec4(0.4, 1.0, 0.4, 1.0), isRO and u8("Happy Hour & Bonusuri Detaliate") or "Happy Hour & Detailed Bonuses")
                            imgui.BeginChild("HappyHour", imgui.ImVec2(0, 260), true)
                                imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("Happy Hour: 19:00 - 22:00 (Beneficii Duble!)") or "Happy Hour: 19:00 - 22:00 (Double Benefits!)")                 
                                imgui.Separator()
                                imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Bonusuri Payday:") or "Payday Bonuses:")
                                imgui.BulletText(isRO and u8("Lvl 100: Cont Premium PERMANENT.") or "Lvl 100: PERMANENT Premium Account.")
                                imgui.BulletText(isRO and u8("3 Payday-uri: Dublu puncte de Respect.") or "3 Paydays: Double Respect points.")
                                imgui.BulletText(isRO and u8("4 Payday-uri: Dublu: Jaf, Evadare, Clear FP, Accept Lawyer.") or "4 Paydays: Double: Rob, Escape, Clear FP, Accept Lawyer.")
                                imgui.BulletText(isRO and u8("6 Payday-uri: 10 MP, 1 Accept Lawyer, 100 Droguri.") or "6 Paydays: 10 MP, 1 Accept Lawyer, 100 Drugs.")
                                imgui.BulletText(isRO and u8("10 Payday-uri: Triplu: Respect, FP, Jaf, Evadare + 10 Gold + 1 /bail.") or "10 Paydays: Triple: Respect, FP, Rob, Escape + 10 Gold + 1 /bail.")
                                imgui.Spacing()
                                imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Bonusuri in functie de Nivel:") or "Level-based Bonuses:")
                                imgui.TextWrapped(isRO and u8("Job: Lvl 110-129 (5 '/.), 130-149 (10 '/.), 150-169 (15 '/.). Creste cu 5'/. la fiecare 20 nivele pana la 100 '/. (Lvl 490).") or "Job: Lvl 110-129 (5 '/.), 130-149 (10 '/.), 150-169 (15 '/.). Increases by 5'/. every 20 levels up to 100 '/. (Lvl 490).")
                                imgui.Spacing()
                                imgui.TextWrapped(isRO and u8("Rob: Lvl 120-139 (5 '/.), 140-159 (10 '/.), 160-179 (15 '/.). Creste cu 5'/. la fiecare 20 nivele pana la 100 '/. (Lvl 500).") or "Rob: Lvl 120-139 (5 '/.), 140-159 (10 '/.), 160-179 (15 '/.). Increases by 5'/. every 20 levels up to 100 '/. (Lvl 500).")
                            imgui.EndChild()
                            -- Informatii Payday
                            imgui.TextColored(imgui.ImVec4(1.0, 0.4, 1.0, 1.0), isRO and u8("Informatii afisate la Payday") or "Information displayed at Payday")
                            imgui.BeginChild("RarityBox", imgui.ImVec2(0, 50), true)
                                imgui.TextWrapped(isRO and u8("Plata, Bonus (25 '/. Premium), Taxa Primar, Chirie, Sold, Dobanda, Profit Business.") or "Payment, Bonus (25 '/. Premium), Mayor Tax, Rent, Balance, Interest, Business Profit.")
                                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), isRO and u8("Nota: Jucatorii cu bani > $5.000.000/$10.000.000 nu primesc dobanda.") or "Note: Players with money > $5.000.000/$10.000.000 do not receive interest.")
                            imgui.EndChild()
                       
                    imgui.EndChild()
                end            

            -- [ PANEL DREAPTA: RENDERING AFACERI LOCAL ] --        
            elseif active_tab == 6 then
            local isRO = (iniData.settings.lang == 0)

            imgui.BeginChild("BizNavigationPanel", imgui.ImVec2(200, 0), true)
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("AFACERI DISPONIBILE:") or "AVAILABLE BUSINESSES:")
                imgui.Separator()
                imgui.Spacing()
                
                imgui.BeginChild("BizScrollNavigation", imgui.ImVec2(0, 0), false)
                    -- Tabela cu traducerile pentru fiecare biz
                    local businesses = {
                        {ro = "Banci", en = "Banks"}, {ro = "Benzinarii", en = "Gas Stations"},
                        {ro = "24/7", en = "24/7"}, {ro = "Fast Fooduri", en = "Fast Foods"},
                        {ro = "Clothing Stores", en = "Clothing Stores"}, {ro = "Gun Shops", en = "Gun Shops"},
                        {ro = "Cluburi si baruri", en = "Clubs and bars"}, {ro = "Restaurante", en = "Restaurants"},
                        {ro = "Pay'n'Spray-uri", en = "Pay'n'Sprays"}, {ro = "Tuninguri", en = "Tunings"},
                        {ro = "Arene", en = "Arenas"}, {ro = "CNN", en = "CNN"},
                        {ro = "Rent", en = "Rent"}, {ro = "White Weapons", en = "White Weapons"},
                        {ro = "Sex Shopuri", en = "Sex Shops"}, {ro = "Poker Casino", en = "Poker Casino"},
                        {ro = "Car Insurance", en = "Car Insurance"}, {ro = "PubG Arena", en = "PubG Arena"},
                        {ro = "Car Color", en = "Car Color"}, {ro = "Alte bizuri", en = "Other businesses"}
                    }
                    
                    local themeButton = imgui.GetStyle().Colors[imgui.Col.Button]
                    local themeHovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
                    local themeActive = imgui.GetStyle().Colors[imgui.Col.ButtonActive]

                    for idx, biz in ipairs(businesses) do
                        local biz_label = isRO and u8(biz.ro) or biz.en
                        local isSelected = (selected_biz == idx)
                        
                        if isSelected then
                            imgui.PushStyleColor(imgui.Col.Button, themeActive)
                        else
                            imgui.PushStyleColor(imgui.Col.Button, themeButton)
                        end
                        imgui.PushStyleColor(imgui.Col.ButtonHovered, themeHovered)
                        imgui.PushStyleColor(imgui.Col.ButtonActive, themeActive)
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))

                        if imgui.Button(biz_label .. "##biz_btn_" .. idx, imgui.ImVec2(180, 30)) then
                            selected_biz = idx
                        end
                        
                        imgui.PopStyleColor(4)
                    end
                imgui.EndChild()
            imgui.EndChild()

            imgui.SameLine()

                -- [ PANEL DREAPTA: DETALII COMPLETE AFACERE ] --
                imgui.BeginChild("BizDetailsDisplayArea", imgui.ImVec2(0, 0), true)
                    local yellowColor, greenColor = imgui.ImVec4(1,1,0,1), imgui.ImVec4(0.27,0.65,0.39,1)

                    if selected_biz == 0 then
                        imgui.SetCursorPos(imgui.ImVec2(30, 40))
                        imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("Selecteaza un tip de business din panoul stang pentru detalii.") or "Select a business type from the left panel for details.")
                    
                    elseif selected_biz == 1 then -- BANCI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "B A N C I" or "B A N K S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII SI IDENTIFICARE") or "LOCATIONS AND IDENTIFICATION")
                    imgui.BeginChild("BankLocations", imgui.ImVec2(0, 135), true)
                        imgui.SetWindowFontScale(1.5)   
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Los Santos")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 4")  
                        imgui.Spacing()    
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Las Venturas")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 5")    
                        imgui.Spacing()   
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "San Fierro")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 132")    
                        imgui.SetWindowFontScale(1.0)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("OPERATIUNI SI COMENZI") or "OPERATIONS AND COMMANDS")
                    imgui.BeginChild("BankOps", imgui.ImVec2(0, 250), true)
                        imgui.SetWindowFontScale(1.2)
                        imgui.BulletText("Sold curent: [/balance]")
                        imgui.BulletText(isRO and u8("Depunere bani: [/deposit]") or "Deposit money: [/deposit]")
                        imgui.BulletText(isRO and u8("Retragere: [/withdraw] sau [/atm]") or "Withdraw: [/withdraw] or [/atm]")
                        imgui.Spacing()
                        imgui.Separator()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("TRANSFER BANCAR:") or "BANK TRANSFER:")
                        imgui.TextWrapped("- " .. (isRO and u8("Comanda: [/transfer]") or "Command: [/transfer]"))
                        imgui.TextWrapped("- " .. (isRO and u8("Necesar: Minim Nivel 3") or "Requirement: Min Level 3"))
                        imgui.TextWrapped("- " .. (isRO and u8("Taxa: 1 '/. din suma transferata") or "Fee: 1 '/. of the transferred amount"))
                        imgui.SetWindowFontScale(1.0)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Bancile sunt marcate pe harta cu simbolul '$' de culoare verde.") or "Banks are marked on the map with a green '$' symbol.")

                    elseif selected_biz == 2 then -- BENZINARII
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "B E N Z I N A R I I" or "G A S - S T A T I O N S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("GasGeneralInfo", imgui.ImVec2(0, 95), true)
                        imgui.Columns(2, "gasInfoCols", false)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("COMENZI:") or "COMMANDS:")
                        imgui.BulletText("/fill ['/.]") 
                        imgui.BulletText("/fillgascan")
                        imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("REZERVOR:") or "FUEL TANK:")
                        imgui.Text(isRO and u8("Normal: 100'/.") or "Normal: 100'/.")
                        imgui.Text(isRO and u8("Premium: 150'/.") or "Premium: 150'/.")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LISTA LOCATII PE ORASE:") or "LOCATIONS LIST BY CITY:")
                    
                    -- Los Santos
                    imgui.BeginChild("GS_LS", imgui.ImVec2(0, 115), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "lsGasList", false)
                        imgui.BulletText("Gas Station Vinewood LS - ID 68")
                        imgui.BulletText("Gas Station Idlewood LS - ID 69")
                        imgui.NextColumn()
                        imgui.BulletText("Gas Station Montgomery LS - ID 72")
                        imgui.BulletText("Gas Station Dillimore LS - ID 73")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    -- Las Venturas
                    imgui.BeginChild("GS_LV", imgui.ImVec2(0, 140), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "lvGasList", false)
                        imgui.BulletText("Gas Station Emerald Isle LV - ID 78")
                        imgui.BulletText("Gas Station Bone County LV - ID 79")
                        imgui.BulletText("Gas Station Fort Carson LV - ID 81")
                        imgui.BulletText("Gas Station 4 Dragons LV - ID 82")
                        imgui.NextColumn()
                        imgui.BulletText("Gas Station GSLV - ID 83")
                        imgui.BulletText("Gas Station Redsands LV - ID 84")
                        imgui.BulletText("Gas Station Spinybed LV - ID 86")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    -- San Fierro
                    imgui.BeginChild("GS_SF", imgui.ImVec2(0, 165), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "sfGasList", false)
                        imgui.BulletText("Gas Station Flint County SF - ID 70")
                        imgui.BulletText("Gas Station Whetstone SF - ID 71")
                        imgui.BulletText("Gas Station Doherty SF - ID 74")
                        imgui.BulletText("Gas Station Juniper Hollow SF - ID 75")
                        imgui.NextColumn()
                        imgui.BulletText("Gas Station Angel Pine SF - ID 76")
                        imgui.BulletText("Gas Station Easter Basin SF - ID 77")
                        imgui.BulletText("Gas Station Tierra Robada SF 1 - ID 80")
                        imgui.BulletText("Gas Station Tierra Robada SF 2 - ID 85")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Identificare: Benzinariile sunt marcate cu un camion pe harta.") or "Identification: Gas stations are marked with a fuel pump icon on the map.")

                    elseif selected_biz == 3 then -- 24/7
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "M A G A Z I N E - 24/7" or "24/7 S T O R E S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRODUSE SI COMENZI") or "PRODUCTS AND COMMANDS")
                    imgui.BeginChild("Prod247", imgui.ImVec2(0, 160), true)
                        imgui.Columns(2, "prodCols", false)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("ELECTRONICE / DIVERSE:") or "ELECTRONICS / MISC:")
                        imgui.Text("- " .. (isRO and u8("Telefon: $1.500") or "Phone: $1.500"))
                        imgui.Text("- " .. (isRO and u8("MP3 Player: $2.000") or "MP3 Player: $2.000"))
                        imgui.Text("- " .. (isRO and u8("Statie Radio: $5.000") or "Radio: $5.000"))
                        imgui.Text("- " .. (isRO and u8("Aparat foto: $100") or "Camera: $100"))
                        imgui.Text("- " .. (isRO and u8("Zaruri: $500") or "Dice: $500"))
                        imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("UTILE / FISHING:") or "USEFUL / FISHING:")
                        imgui.Text("- " .. (isRO and u8("Canistra: $2.000") or "Gas can: $2.000"))
                        imgui.Text("- " .. (isRO and u8("Undita: $400") or "Fishing rod: $400"))
                        imgui.Text("- " .. (isRO and u8("Momeala: $20") or "Bait: $20"))
                        imgui.Text("- " .. (isRO and u8("Bricheta: $300") or "Lighter: $300"))
                        imgui.Text("- " .. (isRO and u8("Tigari: $100") or "Cigarettes: $100"))
                        imgui.Columns(1)
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Comenzi: /buy (produse), /lotto (bilet loterie)") or "Commands: /buy (products), /lotto (lottery ticket)")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")

                    -- Los Santos
                    imgui.BeginChild("LS247", imgui.ImVec2(0, 130), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "lsCols", false)
                        imgui.BulletText("24/7 Vinewood LS 1 - 13")
                        imgui.BulletText("24/7 Vinewood LS 2 - 14")
                        imgui.BulletText("24/7 Commerce LS - 15")
                        imgui.BulletText("24/7 Idlewood LS - 16")
                        imgui.NextColumn()
                        imgui.Columns(1)
                    imgui.EndChild()

                    -- Las Venturas
                    imgui.BeginChild("LV247", imgui.ImVec2(0, 130), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "lvCols", false)
                        imgui.BulletText("24/7 Redsands East LV - 17")
                        imgui.BulletText("24/7 Emerald Isle LV - 18")
                        imgui.BulletText("24/7 Starfish Casino LV 1 - 19")
                        imgui.BulletText("24/7 Roca Escalante LV - 20")
                        imgui.NextColumn()
                        imgui.BulletText("24/7 Old Venturas Strip LV - 21")
                        imgui.BulletText("24/7 Starfish Casino LV 2 - 22")
                        imgui.BulletText("24/7 Creek LV - 23")
                        imgui.Columns(1)
                    imgui.EndChild()

                    -- San Fierro
                    imgui.BeginChild("SF247", imgui.ImVec2(0, 120), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "sfCols", false)
                        imgui.BulletText("24/7 Juniper Hill SF - 124")
                        imgui.BulletText("24/7 Garcia SF 1 - 125")
                        imgui.BulletText("24/7 Garcia SF 2 - 126")
                        imgui.NextColumn()
                        imgui.BulletText("24/7 Hashbury SF - 127")
                        imgui.BulletText("24/7 Chinatown SF - 128")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(700)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Marcaj: Magazinele sunt reprezentate pe harta cu litera 'S' rosie.") or "Marker: Stores are represented on the map with a red 'S' letter.")

                    elseif selected_biz == 4 then -- FAST FOODURI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.Spacing()
                    imgui.SetWindowFontScale(1.4)
                    local title = isRO and "F A S T - F O O D U R I" or "F A S T - F O O D S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.BeginChild("FF_InfoText", imgui.ImVec2(0, 80), true)
                        imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                        imgui.Text(isRO and u8("Serverul detine un numar total de 28 de fast fooduri pe harta.") or "The server has a total of 28 fast food locations on the map.")
                        
                        imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                        imgui.Text(isRO and u8("Magazinele sunt marcate cu: felie de pizza, clopotel sau burger.") or "Stores are marked with: pizza slice, bell or burger.") 
                        
                        imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                        imgui.Text(isRO and u8("Comanda [/eat] / LALT: +20'/. HP | Cost: $30") or "Command [/eat] / LALT: +20'/. HP | Cost: $30")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.BeginChild("FF_LongList", imgui.ImVec2(0, 750), true)
                    local city_order = {"Los Santos", "Las Venturas", "San Fierro"}

                    local data_mapping = {
                        ["Los Santos"] = "LS",
                        ["Las Venturas"] = "LV",
                        ["San Fierro"] = "SF"
                    }

                    -- PIZZA
                    imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), ">> Pizza")
                    imgui.Separator()
                    local pizza_data = {
                        LS = {"Pizza Idlewood LS - 59", "Pizza Red County LS - 60", "Pizza Montgomery LS - 61", "Pizza Palomino Creek LS - 62"},
                        LV = {"Pizza Emerald Isle LV - 63", "Pizza Starfish Casino LV - 64", "Pizza Creek LV - 65", "Pizza Escalante LV - 66"},
                        SF = {"Pizza Financial SF - 38", "Pizza Esplanade North SF - 37"}
                    }
                    for _, city_name in ipairs(city_order) do
                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), ">> " .. city_name)
                        local short = data_mapping[city_name]
                        for _, text in ipairs(pizza_data[short]) do
                            imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                            imgui.Text(text)
                        end
                    end

                    imgui.Spacing(); imgui.Spacing()

                    -- CLUCKIN' BELL
                    imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), ">> Cluckin' Bell")
                    imgui.Separator()
                    local cb_data = {
                        LS = {"Cluckin Bell Market LS - 50", "Cluckin Bell Willowfield LS - 51", "Cluckin Bell East Los Santos LS - 52"},
                        LV = {"Cluckin Bell Emerald Isle LV - 53", "Cluckin Bell Old Venturas - 54", "Cluckin Bell Pilgrim LV - 55", "Cluckin Bell Creek LV - 56", "Cluckin Bell Bone County LV - 57"},
                        SF = {"Cluckin Bell Tierra Robada SF - 58", "Cluckin Bell Downtown SF - 117", "Cluckin Bell Ocean Flats SF - 118"}
                    }
                    for _, city_name in ipairs(city_order) do
                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), ">> " .. city_name)
                        local short = data_mapping[city_name]
                        for _, text in ipairs(cb_data[short]) do
                            imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                            imgui.Text(text)
                        end
                    end

                    imgui.Spacing(); imgui.Spacing()

                    -- BURGER SHOT
                    imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), ">> Burger Shot")
                    imgui.Separator()
                    local bs_data = {
                        LS = {"Burger Shot Marina LS - 43", "Burger Shot Vinewood LS - 44"},
                        LV = {"Burger Shot Old Venturas LV 1 - 47", "Burger Shot Old Venturas LV 2 - 48", "Burger Shot Whitewood LV - 45", "Burger Shot Redsands LV - 46", "Burger Shot Spinybed LV - 49"},
                        SF = {"Burger Shot Garcia SF - 27", "Burger Shot Downtown SF - 28", "Burger Shot Hollow SF - 33"}
                    }
                    for _, city_name in ipairs(city_order) do
                        imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), ">> " .. city_name)
                        local short = data_mapping[city_name]
                        for _, text in ipairs(bs_data[short]) do
                            imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                            imgui.Text(text)
                        end
                    end

                    imgui.EndChild() 
                    
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.4), isRO and u8("Folositi scroll pentru a vedea toate locatiile.") or "Use scroll to see all locations.")

                    elseif selected_biz == 5 then -- CLOTHING STORES
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "M A G A Z I N E - H A I N E" or "C L O T H I N G - S T O R E S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("ClothingPreturiInfo", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("CATEGORII SKINURI SI ACCESORII:") or "SKIN AND ACCESSORIES CATEGORIES:")
                        imgui.Separator()
                        imgui.Columns(2, "clothPriceCols", false)
                        imgui.BulletText("Starter: $1 / 1 Gold")
                        imgui.BulletText("Bronze: $20.000 / 100 Gold")
                        imgui.BulletText("Silver: $195.000 / 1000 Gold")
                        imgui.BulletText("Platinum: $1.090.000 / 5000 Gold")
                        imgui.NextColumn()
                        imgui.BulletText(isRO and u8("Ochelari: $500") or "Glasses: $500")
                        imgui.BulletText(isRO and u8("Palarie: $500") or "Hat: $500")
                        imgui.BulletText(isRO and u8("Costume: $500") or "Suits: $500")
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Comenzi: /skins, /costumes, /buyacs") or "Commands: /skins, /costumes, /buyacs")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    -- Los Santos
                    imgui.BeginChild("Cloth_LS_Search", imgui.ImVec2(0, 140), true)
                        imgui.SetWindowFontScale(1.5); local city1 = "Los Santos"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0); imgui.Separator()
                        imgui.Columns(2, "lsClothCols_Search", false)
                        imgui.BulletText("Clothes Store Ganton LS - 101")
                        imgui.BulletText("Clothes Store Downtown LS - 104")
                        imgui.BulletText("Clothes Store Rodeo LS 1 - 107")
                        imgui.NextColumn()
                        imgui.BulletText("Clothes Store Jefferson LS - 109")
                        imgui.BulletText("Clothes Store Rodeo LS 2 - 111")
                        imgui.BulletText("Clothes Store Rodeo LS - 123")
                        imgui.Columns(1)
                    imgui.EndChild()

                    -- Las Venturas
                    imgui.BeginChild("Cloth_LV_Search", imgui.ImVec2(0, 155), true)
                        imgui.SetWindowFontScale(1.5); local city2 = "Las Venturas"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0); imgui.Separator()
                        imgui.Columns(2, "lvClothCols_Search", false)
                        imgui.BulletText("Clothes Store LV Airport - 102")
                        imgui.BulletText("Clothes Store Emerald Isle LV 1 - 103")
                        imgui.BulletText("Clothes Store Emerald Isle LV 2 - 105")
                        imgui.BulletText("Clothes Store Starfish Casino LV - 106")
                        imgui.NextColumn()
                        imgui.BulletText("Clothes Store Creek LV 1 - 108")
                        imgui.BulletText("Clothes Store Creek LV 2 - 110")
                        imgui.Columns(1)
                    imgui.EndChild()

                    -- San Fierro
                    imgui.BeginChild("Cloth_SF_Search", imgui.ImVec2(0, 110), true)
                        imgui.SetWindowFontScale(1.5); local city3 = "San Fierro"
                        imgui.SetCursorPosX((w - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0); imgui.Separator()
                        imgui.Columns(2, "sfClothCols_Search", false)
                        imgui.BulletText("Clothes Store Hashbury SF - 119")
                        imgui.BulletText("Clothes Store Juniper Hill SF - 120")
                        imgui.NextColumn()
                        imgui.BulletText("Clothes Store Downtown SF 1 - 121")
                        imgui.BulletText("Clothes Store Downtown SF 2 - 122")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Marcaj harta: Un tricou alb.") or "Map marker: A white t-shirt.")
                  
                    elseif selected_biz == 6 then -- GUN SHOPS
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "M A G A Z I N E - A R M E" or "G U N - S H O P S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("GunShopInfo", imgui.ImVec2(0, 85), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("OPERATIUNI:") or "OPERATIONS:")
                        imgui.BulletText(isRO and u8("Comanda: [/buygun (nume) (munitie)]") or "Command: [/buygun (name) (ammo)]")
                        imgui.BulletText(isRO and u8("Regenerare HP: [/eat] costa $30 si ofera 20 HP.") or "HP Regen: [/eat] costs $30 and gives 20 HP.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    imgui.BeginChild("GunShopLocations", imgui.ImVec2(0, 120), true)
                        imgui.SetWindowFontScale(1.5)       
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), "Los Santos")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 1")       
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), "Las Venturas")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 144")    
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "San Fierro")
                        imgui.SameLine(250); imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "-> ID 137")      
                        imgui.SetWindowFontScale(1.0)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CATALOG ARME SI DAUNE (DAMAGE):") or "WEAPON CATALOG AND DAMAGE:")
                    
                    imgui.BeginChild("GunCatalog", imgui.ImVec2(0, 240), true)
                        imgui.Columns(3, "gunCols", true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Arma") or "Weapon"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Pret/Glont") or "Price/Ammo"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Dauna (HP)") or "Damage (HP)"); imgui.NextColumn()
                        imgui.Separator()
                        
                        local weapons = {
                            {"SDPistol", "$1", "13.2"}, {"Desert Eagle", "$2", "46.2"},
                            {"Shotgun", "$2", "~49.5"}, {"MP5", "$2", "8.2"},
                            {"M4 / AK47", "$3", "10.0"}, {"Country Rifle", "$3", "24.7"}
                        }
                        
                        for _, wpn in ipairs(weapons) do
                            imgui.Text(wpn[1]); imgui.NextColumn()
                            imgui.Text(wpn[2]); imgui.NextColumn()
                            imgui.Text(wpn[3]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                        
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), isRO and u8("ARME SPECIALE (NON-SHOP):") or "SPECIAL WEAPONS (NON-SHOP):")
                        imgui.Text("Sniper: 200 HP | Knife: 200 HP | Tec9: 6.6 HP | Uzi: 6.5 HP")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Marcaj: Magazinele sunt marcate pe harta cu simbolul unui pistol.") or "Marker: Stores are marked on the map with a gun symbol.")
                  
                    elseif selected_biz == 7 then -- CLUBURI SI BARURI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "C L U B U R I - B A R U R I" or "C L U B S - B A R S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0.6, 0.1, 0.9, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("MENIU BAUTURI SI COMENZI") or "DRINK MENU AND COMMANDS")
                    imgui.BeginChild("BarMeniu", imgui.ImVec2(0, 160), true)
                        imgui.Columns(2, "barCols", false)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("ALCOOLICE:") or "ALCOHOLIC:")
                        imgui.Text("- " .. (isRO and u8("Bere: $12") or "Beer: $12"))
                        imgui.Text("- " .. (isRO and u8("Vin: $21") or "Wine: $21"))
                        imgui.Text("- " .. (isRO and u8("Vodka: $30") or "Vodka: $30"))
                        imgui.Text("- " .. (isRO and u8("Whiskey: $38") or "Whiskey: $38"))
                        imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("NON-ALCOOLICE:") or "NON-ALCOHOLIC:")
                        imgui.Text("- " .. (isRO and u8("Apa / Suc: $30") or "Water / Soda: $30"))
                        imgui.Text("- " .. (isRO and u8("Sprunk / Cafea: $23") or "Sprunk / Coffee: $23"))
                        imgui.Columns(1)
                        imgui.Separator()
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("Comanda: [/drink] pentru a comanda la bar.") or "Command: [/drink] to order at the bar.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE (ID-URI):") or "LOCATIONS BY CITY (IDS):")
                    
                    -- LS
                    imgui.BeginChild("Bar_LS", imgui.ImVec2(0, 100), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Alhambra LS - ID 7")
                        imgui.BulletText("The Pig Pen LS - ID 8")
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("Bar_LV", imgui.ImVec2(0, 150), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.Columns(2, "lvBarCols", false)
                        imgui.BulletText("4 Dragons - ID 115")
                        imgui.BulletText("Caligulas - ID 114")
                        imgui.BulletText("Jizzy LV - ID 10")
                        imgui.NextColumn()
                        imgui.BulletText("Casino Redsands - ID 116")
                        imgui.BulletText("Big Spread Ranch - ID 9")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("Bar_SF", imgui.ImVec2(0, 75), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Jizzy SF - ID 134")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Marcaj: Cluburile sunt reprezentate pe harta cu 'S' alb sau o roata/discheta.") or "Marker: Clubs are represented on the map with a white 'S' or a wheel/disk icon.")
                    
                    elseif selected_biz == 8 then -- RESTAURANTE
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "R E S T A U R A N T E" or "R E S T A U R A N T S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("RestGeneralInfo", imgui.ImVec2(0, 80), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("ACTIVITATI:") or "ACTIVITIES:")
                        imgui.BulletText(isRO and u8("Comanda: [/eat] pentru a manca.") or "Command: [/eat] to eat.")  
                        imgui.BulletText(isRO and u8("Comanda: [/drink] pentru a comanda bautura.") or "Command: [/drink] to order a drink.")  
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    -- LS
                    imgui.BeginChild("Rest_LS", imgui.ImVec2(0, 95), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Restaurant LS 1 - ID 2")  
                        imgui.BulletText("Restaurant LS 2 - ID 12")  
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("Rest_LV", imgui.ImVec2(0, 75), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Restaurant LV - ID 11")  
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("Rest_SF", imgui.ImVec2(0, 135), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Restaurant SF 1 - ID 135") 
                        imgui.BulletText("Restaurant SF 2 - ID 136")  
                        imgui.BulletText("Gaydar Station Club SF - ID 139")  
                        imgui.BulletText("Dinner Restaurant SF - ID 138") 
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Identificare: Restaurantele sunt marcate cu o furculita si un cutit.") or "Identification: Restaurants are marked with a fork and knife.")
                   
                    elseif selected_biz == 9 then -- PAY'N'SPRAY-URI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = "P A Y 'N' S P R A Y"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("PNSGeneralInfo", imgui.ImVec2(0, 85), true)
                        imgui.Columns(2, "pnsInfoCols", false)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("COST REPARATIE:") or "REPAIR COST:")
                        imgui.BulletText(isRO and u8("$200 (indiferent de vehicul)") or "$200 (any vehicle)")
                        imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("COMENZI:") or "COMMANDS:")
                        imgui.BulletText("/enter")
                        imgui.BulletText(isRO and u8("Alternativa: LALT") or "Alternative: LALT")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE (ID-URI):") or "LOCATIONS BY CITY (IDS):")
                    
                    -- LS
                    imgui.BeginChild("PNS_LS", imgui.ImVec2(0, 135), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("PNS Temple - ID 87")
                        imgui.BulletText("PNS Santa Maria Beach - ID 88")
                        imgui.BulletText("PNS Idlewood - ID 93")
                        imgui.BulletText("PNS Dilimore - ID 95")
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("PNS_LV", imgui.ImVec2(0, 95), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("PNS Redsands - ID 92")
                        imgui.BulletText("PNS Fort Carson - ID 94")
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("PNS_SF", imgui.ImVec2(0, 115), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("PNS El Quebrados - ID 89")
                        imgui.BulletText("PNS Downtown - ID 90")
                        imgui.BulletText("PNS Juniper Hollow - ID 91")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Identificare: Pay'n'Spray-urile sunt marcate pe harta cu o cutie de spray.") or "Identification: Pay'n'Spray locations are marked on the map with a spray can.")
                  
                    elseif selected_biz == 10 then -- TUNINGURI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = "T U N I N G - S H O P S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0, 1, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    imgui.BeginChild("TuningPricesInfo", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("PRETURI COMPONENTE (DIN PRETUL MASINII):") or "COMPONENT PRICES (OF CAR VALUE):")
                        imgui.Separator()
                        imgui.Columns(2, "tunePriceCols", false)
                        imgui.BulletText("Paint Jobs: 1.15'/.")
                        imgui.BulletText("Nitro (10): 0.8'/.")
                        imgui.BulletText((isRO and u8("Roti / Exhaust") or "Wheels / Exhaust") .. ": 0.8'/.")
                        imgui.BulletText((isRO and u8("Hidraulice") or "Hydraulics") .. ": 0.25'/.")
                        imgui.NextColumn()
                        imgui.BulletText((isRO and u8("Neoane: 1.15'/. (Doar Premium)") or "Neon: 1.15'/. (Premium Only)"))
                        imgui.BulletText((isRO and u8("Bari / Spoiler / Praguri") or "Bumpers / Spoiler / Skirts") .. ": 0.5'/.")
                        imgui.BulletText((isRO and u8("Capota / Lampi / Vents") or "Hood / Lamps / Vents") .. ": 0.5'/.")
                        imgui.BulletText((isRO and u8("Culori: $25 (Pret fix)") or "Colors: $25 (Fixed price)"))
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    -- LS
                    imgui.BeginChild("Tune_LS", imgui.ImVec2(0, 95), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Transfender LS - ID 96")
                        imgui.BulletText("Loco Low Co. LS - ID 100")
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("Tune_LV", imgui.ImVec2(0, 75), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Transfender LV - ID 98")
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("Tune_SF", imgui.ImVec2(0, 95), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Transfender SF - ID 97")
                        imgui.BulletText("Wheel Arch Angels SF - ID 99")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Identificare: Service-urile sunt marcate cu o cheie rosie pe harta.") or "Identification: Tuning shops are marked with a red wrench on the map.")
                    
                    elseif selected_biz == 11 then -- ARENE
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and "A R E N E" or "A R E N A S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- PAINTBALL
                    imgui.BeginChild("ArenaPaintball", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), "PAINTBALL ARENA (ID 34)")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Durata: Un meci dureaza 4 minute.") or "Duration: A match lasts 4 minutes.")
                        imgui.BulletText(isRO and u8("Premiu: Cel mai bun jucator primeste $110 la final.") or "Prize: Best player receives $110 at the end.")
                        imgui.BulletText(isRO and u8("Comanda Parasire: [/leavepaintball].") or "Leave command: [/leavepaintball].")
                    imgui.EndChild()
                    
                    -- RACING
                    imgui.BeginChild("ArenaRacing", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), "RACING ARENA (ID 35)")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Cerinta: Ai nevoie de permis de conducere.") or "Requirement: You need a driving license.")
                        imgui.BulletText(isRO and u8("Pariuri: Poti paria pe tine intre $500 si $5.000.") or "Bets: You can bet on yourself between $500 and $5.000.")
                        imgui.BulletText(isRO and u8("Votare: Ai 30 de secunde pentru a vota harta inainte de start.") or "Voting: You have 30 seconds to vote for the map before start.")
                    imgui.EndChild()
                    
                    -- WAR
                    imgui.BeginChild("ArenaWar", imgui.ImVec2(0, 125), true)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "WAR ARENA (ID 145)")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Cerinte: Permis de conducere si licenta de zbor.") or "Requirements: Driving license and flying license.")
                        imgui.BulletText(isRO and u8("Vehicule: Poti vota intre Hunter, Rhino sau Hydra.") or "Vehicles: You can vote between Hunter, Rhino, or Hydra.")
                        imgui.BulletText(isRO and u8("Detalii: Runda dureaza 5 minute (fara premiu/clasament).") or "Details: Round lasts 5 minutes (no prize/rank).")
                        imgui.BulletText(isRO and u8("Comanda Parasire: [/leavewararena].") or "Leave command: [/leavewararena].")
                    imgui.EndChild()
                    
                    -- GUN GAME
                    imgui.BeginChild("ArenaGunGame", imgui.ImVec2(0, 125), true)
                        imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), "GUN GAME ARENA (ID 147)")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Cerinta: Necesita licenta de arme activa.") or "Requirement: Requires active weapons license.")
                        imgui.BulletText(isRO and u8("Capacitate: Maxim 40 de jucatori in arena.") or "Capacity: Max 40 players in the arena.")
                        imgui.BulletText(isRO and u8("Regula AFK: Esti scos daca stai AFK peste 1 minut.") or "AFK Rule: You are removed if AFK over 1 minute.")
                        imgui.BulletText(isRO and u8("Comanda Parasire: [/leavegungame].") or "Leave command: [/leavegungame].")
                    imgui.EndChild()
                    
                    -- LCS
                    imgui.BeginChild("ArenaLCS", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(0.8, 0.4, 1, 1), "LAST CAR STANDING (ID 149)")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Cerinta: Ai nevoie de permis de conducere.") or "Requirement: You need a driving license.")
                        imgui.BulletText(isRO and u8("Pariuri: Poti paria pe tine (sistem similar cu Racing).") or "Bets: You can bet on yourself (system similar to Racing).")
                        imgui.BulletText(isRO and u8("Comanda Parasire: [/leavelcs].") or "Leave command: [/leavelcs].")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Foloseste [/gps] pentru a localiza arenele rapid.") or "Tip: Use [/gps] to locate arenas quickly.")

                    elseif selected_biz == 12 then -- CNN
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " C N N "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- REGULAMENT
                    imgui.BeginChild("CNNRules", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("REGULAMENT:") or "RULES:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Nivel Minim: Ai nevoie de nivel 3 pentru a publica.") or "Minimum Level: Level 3 required to post.")
                        imgui.BulletText(isRO and u8("Lungime: Maxim 124 de caractere per anunt.") or "Length: Max 124 characters per ad.")
                        imgui.BulletText(isRO and u8("Marcaj: Locatiile CNN sunt marcate cu litera 'N' albastra.") or "Marker: CNN locations are marked with a blue 'N'.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- COMENZI
                    imgui.BeginChild("CNNCmds", imgui.ImVec2(0, 105), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), isRO and u8("COMENZI DISPONIBILE:") or "AVAILABLE COMMANDS:")
                        imgui.Separator()
                        imgui.BulletText("/ad [text] - " .. (isRO and u8("Plaseaza un anunt.") or "Place an ad."))
                        imgui.BulletText("/ads - " .. (isRO and u8("Vezi anunturile in asteptare.") or "View pending ads."))
                        imgui.BulletText("/myad - " .. (isRO and u8("Previzualizeaza anuntul tau.") or "Preview your ad."))
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("STUDIURI PE ORASE:") or "STUDIOS BY CITY:")
                    
                    -- LS
                    imgui.BeginChild("CNN_LS", imgui.ImVec2(0, 80), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        local text = "CNN LS - ID 31"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(text).x) / 2)
                        imgui.Text(text)
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("CNN_LV", imgui.ImVec2(0, 80), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        local text = "CNN LV - ID 41"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(text).x) / 2)
                        imgui.Text(text)
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("CNN_SF", imgui.ImVec2(0, 80), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        local text = "CNN SF - ID 133"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(text).x) / 2)
                        imgui.Text(text)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Informatie: Poti publica anunturi doar daca te afli langa un studio.") or "Information: You can only post ads if you are near a studio.")

                    elseif selected_biz == 13 then -- RENT
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " R E N T - C A R "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- COSTURI SI REGULI
                    imgui.BeginChild("RentGeneralInfo", imgui.ImVec2(0, 105), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("COSTURI SI REGULI:") or "COSTS AND RULES:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Pret fix: $2.000 pe ora (maxim 24 de ore).") or "Fixed price: $2.000 per hour (max 24 hours).")
                        imgui.BulletText(isRO and u8("Gestiune: Vehiculul apare pe [/v], poate fi localizat sau tractat.") or "Management: Vehicle appears in [/v], can be located or towed.")
                        imgui.BulletText(isRO and u8("Control: Poti incuia vehiculul folosind tasta 'L' sau [/lock].") or "Control: You can lock the vehicle using 'L' or [/lock].")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII RENT PE ORASE:") or "RENT LOCATIONS BY CITY:")
                    
                    -- LS
                    imgui.BeginChild("Rent_LS", imgui.ImVec2(0, 100), true)
                        imgui.SetWindowFontScale(1.5)
                        local city1 = "Los Santos"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city1).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.3, 0.7, 1, 1), city1)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Rent Car LS - ID 24")
                        imgui.BulletText("Rent Bike LS - ID 36")
                    imgui.EndChild()
                    
                    -- LV
                    imgui.BeginChild("Rent_LV", imgui.ImVec2(0, 120), true)
                        imgui.SetWindowFontScale(1.5)
                        local city2 = "Las Venturas"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city2).x) / 2)
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), city2)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Rent Plane LV - ID 148")
                        imgui.BulletText("Rent Boat LV - ID 40")
                        imgui.BulletText("Rent Car LV - ID 25")
                        imgui.BulletText("Rent Bike LV - 67")
                    imgui.EndChild()
                    
                    -- SF
                    imgui.BeginChild("Rent_SF", imgui.ImVec2(0, 100), true)
                        imgui.SetWindowFontScale(1.5)
                        local city3 = "San Fierro"
                        imgui.SetCursorPosX((510 - imgui.CalcTextSize(city3).x) / 2)
                        imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), city3)
                        imgui.SetWindowFontScale(1.0)
                        imgui.Separator()
                        imgui.BulletText("Rent Car SF - ID 129")
                        imgui.BulletText("Rent Bike SF - ID 130")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Identificare: Locatiile Rent sunt marcate cu o masina alba pe harta.") or "Identification: Rent locations are marked with a white car on the map.")

                    elseif selected_biz == 14 then -- WHITE WEAPONS
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = "W H I T E - W E A P O N S"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- DETALII
                    imgui.BeginChild("WhiteWeaponsInfo", imgui.ImVec2(0, 105), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("DETALII:") or "DETAILS:")
                        imgui.BulletText(isRO and u8("Aceste arme sunt ideale pentru lupte de proximitate (Melee).") or "These weapons are ideal for close-quarters combat (Melee).")
                        imgui.BulletText(isRO and u8("Pentru a putea cumpara o arma alba dintr-un White Weapon Store, jucatorul va trebui sa mearga") or "In order to purchase a white weapon from a White Weapon Store, the player will need to go")
                        imgui.BulletText(isRO and u8("la indicatorul din interiorul afacerii si sa apese pe tasta Y.") or "to the indicator inside the business and press the Y key.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- CATALOG
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CATALOG PRODUSE:") or "PRODUCT CATALOG:")
                    imgui.BeginChild("WhiteWeaponsCatalog", imgui.ImVec2(0, 165), true)
                        imgui.Columns(3, "whiteGunCols", true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Arma") or "Weapon"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Pret") or "Price"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Dauna") or "Damage"); imgui.NextColumn()
                        imgui.Separator()
                        
                        local items = {
                            {"Katana", "$1.000", "2.6"},
                            {"Golf Club", "$250", "4.6"},
                            {"Baseball Bat", "$250", "4.6"},
                            {isRO and u8("Lopata") or "Shovel", "$500", "4.6"},
                            {"Brass Knuckles", "$500", "1.3"}
                        }
                        
                        for _, v in ipairs(items) do
                            imgui.Text(v[1]); imgui.NextColumn()
                            imgui.Text(v[2]); imgui.NextColumn()
                            imgui.Text(v[3]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    -- LOCATII
                    imgui.BeginChild("WhiteWeaponsLocs", imgui.ImVec2(0, 180), true)
                        local cities = {
                            {"Los Santos", "Location LS - ID 153", imgui.ImVec4(0.3, 0.7, 1, 1)},
                            {"Las Venturas", "Location LV - ID 154", imgui.ImVec4(1, 0.8, 0.2, 1)},
                            {"San Fierro", "Location SF - ID 155", imgui.ImVec4(0.2, 1, 0.2, 1)}
                        }
                        
                        for _, c in ipairs(cities) do
                            imgui.SetWindowFontScale(1.5)
                            imgui.SetCursorPosX((510 - imgui.CalcTextSize(c[1]).x) / 2)
                            imgui.TextColored(c[3], c[1])
                            imgui.SetWindowFontScale(1.0)
                            imgui.SetCursorPosX((510 - imgui.CalcTextSize(c[2]).x) / 2)
                            imgui.Text(c[2])
                            imgui.Separator()
                        end
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Marcaj: Locatiile sunt reprezentate pe harta printr-o sabie/cutit.") or "Marker: Locations are represented on the map by a sword/knife.")

                    elseif selected_biz == 15 then -- SEX SHOPURI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " S E X - S H O P "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0, 0.6, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- INFO
                    imgui.BeginChild("SexShopInfo", imgui.ImVec2(0, 100), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("INFO:") or "INFO:")
                        imgui.BulletText(isRO and u8("Articolele pot fi folosite ca obiecte de interactiune sau cadouri.") or "Items can be used as interaction objects or gifts.")
                        imgui.BulletText(isRO and u8("Pentru a putea cumpara un obiect dintr-un Sex Shop, jucatorul va trebui sa mearga la indicatorul din interiorul afacerii si sa apese pe tasta Y.") or "In order to purchase an item from a Sex Shop, the player will need to go to the indicator inside the business and press the Y key.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- CATALOG
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CATALOG ARTICOLE:") or "ITEM CATALOG:")
                    imgui.BeginChild("SexShopCatalog", imgui.ImVec2(0, 155), true)
                        imgui.Columns(2, "sexPriceCols", true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Articol") or "Item"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("Pret Unitate") or "Unit Price"); imgui.NextColumn()
                        imgui.Separator()
                        
                        local items = {
                            {isRO and u8("Buchet de Flori") or "Bouquet of Flowers", "$50"},
                            {isRO and u8("Dildo Alb") or "White Dildo", "$100"},
                            {isRO and u8("Dildo Mov") or "Purple Dildo", "$150"},
                            {isRO and u8("Vibrator Scurt") or "Short Vibrator", "$100"},
                            {isRO and u8("Vibrator Lung") or "Long Vibrator", "$150"}
                        }
                        
                        for _, v in ipairs(items) do
                            imgui.Text(v[1]); imgui.NextColumn()
                            imgui.Text(v[2]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LOCATII PE ORASE:") or "LOCATIONS BY CITY:")
                    
                    -- LOCATII
                    imgui.BeginChild("SexShopLocs", imgui.ImVec2(0, 180), true)
                        local locs = {
                            {"Los Santos", "Sex Shop LS - ID 150", imgui.ImVec4(0.3, 0.7, 1, 1)},
                            {"Las Venturas", "Sex Shop LV - ID 151", imgui.ImVec4(1, 0.8, 0.2, 1)},
                            {"San Fierro", "Sex Shop SF - ID 152", imgui.ImVec4(0.2, 1, 0.2, 1)}
                        }
                        
                        for _, l in ipairs(locs) do
                            imgui.SetWindowFontScale(1.5)
                            imgui.SetCursorPosX((510 - imgui.CalcTextSize(l[1]).x) / 2)
                            imgui.TextColored(l[3], l[1])
                            imgui.SetWindowFontScale(1.0)
                            imgui.SetCursorPosX((510 - imgui.CalcTextSize(l[2]).x) / 2)
                            imgui.Text(l[2])
                            imgui.Separator()
                        end
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Informatie: Aceste locatii sunt marcate de obicei cu o buza rosie pe harta.") or "Information: These locations are usually marked with red lips on the map.")

                   elseif selected_biz == 16 then -- POKER CASINO
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " P O K E R - C A S I N O "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- REGULAMENT
                    imgui.BeginChild("PokerGeneralInfo", imgui.ImVec2(0, 160), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("REGULAMENT SI CONDITII:") or "RULES AND CONDITIONS:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Cerinta: Ai nevoie de minim nivel 3 pentru a juca.") or "Requirement: Minimum level 3 to play.")
                        imgui.BulletText(isRO and u8("Jucatori: Minim 2, maxim 6 persoane per masa.") or "Players: Min 2, max 6 per table.")
                        imgui.BulletText(isRO and u8("Sistem: Texas Hold'em (2 carti in mana, 5 pe masa).") or "System: Texas Hold'em (2 hole cards, 5 community).")
                        imgui.BulletText(isRO and u8("Taxa: Castigatorul primeste 95'/. din pot (5'/. taxa server).") or "Tax: Winner receives 95'/. of pot (5'/. server tax).")
                        imgui.BulletText("Locatie: Diamond Casino - ID 156")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- MESE
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("MESE SI LIMITE DE PARIERE:") or "TABLES AND BETTING LIMITS:")
                    imgui.BeginChild("PokerTables", imgui.ImVec2(0, 145), true)
                        imgui.Columns(3, "pokerCols", true)
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), isRO and u8("Masa") or "Table"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), isRO and u8("Intrare") or "Buy-in"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), "Big Blind"); imgui.NextColumn()
                        imgui.Separator()
                        
                        local tables = {
                            {"1-3", "$1", "$100"},
                            {"4-7", "$250.000", "$8.000"},
                            {"8-10", "$10.000.000", "$50.000"}
                        }
                        
                        for _, t in ipairs(tables) do
                            imgui.Text(t[1]); imgui.NextColumn()
                            imgui.Text(t[2]); imgui.NextColumn()
                            imgui.Text(t[3]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- IERARHIA MAINILOR
                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), isRO and u8("IERARHIA MAINILOR:") or "HAND HIERARCHY:")
                    imgui.BeginChild("PokerHands", imgui.ImVec2(0, 160), true)
                        imgui.Columns(2, "handCols", false)
                        imgui.BulletText(isRO and u8("Royal Flush (10-A aceeasi culoare)") or "Royal Flush (10-A same suit)")
                        imgui.BulletText(isRO and u8("Straight Flush (5 in ordine, aceeasi col.)") or "Straight Flush (5 in order, same suit)")
                        imgui.BulletText(isRO and u8("Four of a Kind (Careu)") or "Four of a Kind")
                        imgui.BulletText(isRO and u8("Full House") or "Full House")
                        imgui.BulletText(isRO and u8("Flush (Culoare)") or "Flush")
                        imgui.NextColumn()
                        imgui.BulletText(isRO and u8("Straight (Chinta)") or "Straight")
                        imgui.BulletText(isRO and u8("Three of a Kind (Set)") or "Three of a Kind")
                        imgui.BulletText(isRO and u8("Two Pairs (Doua perechi)") or "Two Pairs")
                        imgui.BulletText(isRO and u8("One Pair (O pereche)") or "One Pair")
                        imgui.BulletText(isRO and u8("High Card (Carte mare)") or "High Card")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Actiuni: Check, Bet, Fold, All-in.") or "Actions: Check, Bet, Fold, All-in.")

                   elseif selected_biz == 17 then -- CAR INSURANCE
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " C A R I N S U R A N C E "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(0, 0.4, 1, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- REGULAMENT
                    imgui.BeginChild("InsuranceRules", imgui.ImVec2(0, 110), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("REGULAMENT:") or "RULES:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Capacitate: Poti avea maxim 5 asigurari active simultan pe un vehicul.") or "Capacity: Max 5 active insurances per vehicle.")
                        imgui.BulletText(isRO and u8("Efect: Daca vehiculul este distrus, asigurarea plateste taxa de recuperare.") or "Effect: If destroyed, insurance covers the recovery fee.")
                        imgui.BulletText(isRO and u8("Locatie: Car Insurance - ID 157") or "Location: Car Insurance - ID 157")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- COSTURI
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("COSTUL ASIGURARII (PER UNITATE):") or "INSURANCE COST (PER UNIT):")
                    imgui.BeginChild("InsurancePrices", imgui.ImVec2(0, 150), true)
                        imgui.Columns(2, "insCols", true)
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), isRO and u8("Valoare Vehicul (DS)") or "Vehicle Value (DS)"); imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), isRO and u8("Pret Asigurare") or "Insurance Price"); imgui.NextColumn()
                        imgui.Separator()
                        
                        local prices = {
                            {"Sub $100.000", "$500"},
                            {"$100.000 - $1.000.000", "$1.000"},
                            {"$1.000.000 - $6.000.000", "$1.500"},
                            {isRO and u8("Peste $6M / Non-DS") or "Over $6M / Non-DS", "$2.000"}
                        }
                        
                        for _, p in ipairs(prices) do
                            imgui.Text(p[1]); imgui.NextColumn()
                            imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), p[2]); imgui.NextColumn()
                        end
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- COMENZI
                    imgui.BeginChild("InsuranceCmds", imgui.ImVec2(0, 100), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), isRO and u8("COMENZI UTILE:") or "USEFUL COMMANDS:")
                        imgui.Separator()
                        imgui.BulletText("/buyinsurance - " .. (isRO and u8("Cumpara o asigurare.") or "Buy insurance."))
                        imgui.BulletText("/v - " .. (isRO and u8("Verifica numarul de asigurari.") or "Check number of insurances."))
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Asigurarea se consuma automat cand masina explodeaza.") or "Tip: Insurance is automatically consumed when the car explodes.")
                    
                    elseif selected_biz == 18 then -- PUBG ARENA
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " P U B G - A R E N A "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.5, 0, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- REGULAMENT
                    imgui.BeginChild("PubGGeneralInfo", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("REGULAMENT SI CONTROL:") or "RULES AND CONTROLS:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Obiectiv: Fii ultimul supravietuitor din arena.") or "Objective: Be the last survivor in the arena.")
                        imgui.BulletText(isRO and u8("Control Inventar: Foloseste tasta [Y] sau comanda [/inventory].") or "Inventory: Use [Y] or [/inventory].")
                        imgui.BulletText(isRO and u8("Start: Meciul incepe cand se aduna numarul minim de jucatori.") or "Start: Match starts when the minimum players are reached.")
                        imgui.BulletText("Locatie: PUBG Arena - ID 159")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- LOOT
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("LOOT SI ECHIPAMENT DISPONIBIL:") or "AVAILABLE LOOT AND GEAR:")
                    imgui.BeginChild("PubGLoot", imgui.ImVec2(0, 130), true)
                        imgui.Columns(2, "lootCols", false)
                        imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), isRO and u8("MEDICAL / DEFENSE:") or "MEDICAL / DEFENSE:")
                        imgui.BulletText(isRO and u8("Medical Kit (+100 HP)") or "Medical Kit (+100 HP)")
                        imgui.BulletText(isRO and u8("Adrenalina (Viteza/HP)") or "Adrenaline (Speed/HP)")
                        imgui.BulletText("Armor Level 1, 2, 3")
                        imgui.NextColumn()
                        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), isRO and u8("ARME (WEAPONS):") or "WEAPONS:")
                        imgui.BulletText("Silenced, Deagle")
                        imgui.BulletText("M4, AK47, Rifle")
                        imgui.BulletText(isRO and u8("RPG (Loot Rar)") or "RPG (Rare Loot)")
                        imgui.Columns(1)
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- SISTEM ZONE
                    imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), isRO and u8("SISTEMUL DE ZONE:") or "ZONE SYSTEM:")
                    imgui.BeginChild("PubGZones", imgui.ImVec2(0, 110), true)
                        imgui.BulletText(isRO and u8("Safe Zone (Cercul Alb): Esti in siguranta.") or "Safe Zone (White Circle): You are safe.")
                        imgui.BulletText(isRO and u8("Neutral Zone: Afara din cerc, dar safe.") or "Neutral Zone: Outside circle, but safe.")
                        imgui.BulletText(isRO and u8("Danger Zone (Albastra): Pierzi HP constant.") or "Danger Zone (Blue): Constant HP loss.")
                        imgui.BulletText(isRO and u8("Damage-ul creste pe parcursul meciului.") or "Damage increases as match progresses.")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Parasire: /leavepubg (doar in lobby).") or "Leave: /leavepubg (lobby only).")

                    elseif selected_biz == 19 then -- CAR COLOR
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = " C A R - C O L O R "
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 0.4, 0.7, 1), title)
                    imgui.SetWindowFontScale(1.0)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- DETALII BIZ
                    imgui.BeginChild("CarColorInfo", imgui.ImVec2(0, 120), true)
                        imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), isRO and u8("DETALII BIZ:") or "BUSINESS DETAILS:")
                        imgui.Separator()
                        imgui.BulletText(isRO and u8("Locatie: Car Color LS - ID 29") or "Location: Car Color LS - ID 29")
                        imgui.BulletText(isRO and u8("Identificare: Marcaj cu litera 'C' de culoare roz pe harta.") or "Identification: Pink 'C' marker on map.")
                        imgui.BulletText(isRO and u8("Utilizare: Permite schimbarea culorii primare si secundare.") or "Usage: Change primary and secondary colors.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- CATEGORII CULORI
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CATEGORII CULORI SI COSTURI:") or "COLOR CATEGORIES & COSTS:")
                    imgui.BeginChild("ColorCategories", imgui.ImVec2(0, 185), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), isRO and u8("CULORI NORMALE (STANDARD):") or "STANDARD COLORS:")
                        imgui.BulletText(isRO and u8("Interval ID-uri: 0 - 127") or "ID Range: 0 - 127")
                        imgui.BulletText(isRO and u8("Cost: $500 (Bani in joc)") or "Cost: $500 (In-game cash)")
                        imgui.Spacing()
                        imgui.Separator()
                        imgui.Spacing()
                        imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("CULORI HIDDEN (PREMIUM):") or "HIDDEN COLORS (PREMIUM):")
                        imgui.BulletText(isRO and u8("Interval ID-uri: 128 - 255") or "ID Range: 128 - 255")
                        imgui.BulletText(isRO and u8("Cost: 600 Gold (Puncte Premium)") or "Cost: 600 Gold (Premium Points)")
                        imgui.BulletText(isRO and u8("Nota: Culori unice, nu se pierd la respawn.") or "Note: Unique colors, saved on respawn.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- INSTRUCTIUNI
                    imgui.BeginChild("ColorInstructions", imgui.ImVec2(0, 130), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), isRO and u8("CUM SCHIMBI CULOAREA:") or "HOW TO CHANGE COLOR:")
                        imgui.Separator()
                        imgui.TextWrapped(isRO and u8("1. Intra in business-ul Car Color (ID 29).") or "1. Enter the Car Color business (ID 29).")
                        imgui.TextWrapped(isRO and u8("2. Foloseste [/carcolor (ID 1) (ID 2)] pentru a vopsi masina.") or "2. Use [/carcolor (ID 1) (ID 2)] to paint the car.")
                        imgui.TextWrapped(isRO and u8("3. Primul ID este culoarea principala, al doilea este cea secundara.") or "3. First ID is primary, second is secondary color.")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Poti testa culorile inainte de a le cumpara definitiv.") or "Tip: You can test colors before purchasing them.")
                    
                    elseif selected_biz == 20 then -- ALTE BIZURI
                    local isRO = (iniData.settings.lang == 0)
                    local w = 510
                    
                    imgui.SetWindowFontScale(1.5)
                    local title = isRO and u8(" ALTE AFACERI SI SERVICII") or " OTHER BUSINESSES & SERVICES"
                    imgui.SetCursorPosX((w - imgui.CalcTextSize(title).x) / 2)
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), title)
                    imgui.SetWindowFontScale(1.2)
                    
                    imgui.Separator()
                    imgui.Spacing()
                    
                    -- COMUNICATII
                    imgui.BeginChild("CommBiz", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), isRO and u8("COMUNICATII SI INMATRICULARE:") or "COMMUNICATIONS & REGISTRATION:")
                        imgui.Separator()
                        imgui.BulletText("Phone Co. (ID 26): SMS ($2), " .. (isRO and u8("Apel") or "Call") .. " ($6 / 30s).")
                        imgui.BulletText("Car Plating (ID 146): " .. (isRO and u8("Inmatriculare vehicul") or "Vehicle registration") .. " ($500).")
                        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), isRO and u8("Locatie: In apropierea sediului Primariei.") or "Location: Near City Hall.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- CASA SI SANATATE
                    imgui.BeginChild("HouseHealthBiz", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), isRO and u8("CASA SI SANATATE:") or "HOME & HEALTH:")
                        imgui.Separator()
                        imgui.BulletText("House Upgrade (ID 30): " .. (isRO and u8("Upgrade interior/Mobila") or "Interior/Furniture upgrade") .. " ($1.000).")
                        imgui.BulletText("LS Hospital (ID 39): " .. (isRO and u8("Vindecare dependenta") or "Drug addiction treatment") .. " ($2).")
                        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), isRO and u8("Nota: Spitalul ofera tratament HP gratuit.") or "Note: Hospital offers free HP treatment.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- JOBURI
                    imgui.BeginChild("JobBiz", imgui.ImVec2(0, 150), true)
                        imgui.TextColored(imgui.ImVec4(0.4, 1, 0.4, 1), isRO and u8("JOBURI SI PRODUCTIE:") or "JOBS & PRODUCTION:")
                        imgui.Separator()
                        imgui.BulletText("Farmer Biz (ID 158): " .. (isRO and u8("Unelte, seminte, fertilizatori") or "Tools, seeds, fertilizers") .. ".")
                        imgui.BulletText("Craftsman Biz (ID 160): " .. (isRO and u8("Produse tamplarie si materiale") or "Carpentry and materials") .. ".")
                        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), isRO and u8("Necesare pentru avansare skill job.") or "Required for job skill progression.")
                    imgui.EndChild()
                    
                    imgui.Spacing()
                    
                    -- MISC
                    imgui.BeginChild("MiscBiz", imgui.ImVec2(0, 100), true)
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("ALTE LOCATII:") or "OTHER LOCATIONS:")
                        imgui.Separator()
                        imgui.BulletText("Towing Co.: " .. (isRO and u8("Recuperare vehicule tractate") or "Towed vehicle recovery") .. ".")
                        imgui.BulletText("Airport Gate: " .. (isRO and u8("Acces hangare private") or "Private hangar access") .. ".")
                    imgui.EndChild()
                    
                    imgui.SetCursorPosY(645)
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.6), isRO and u8("Sfat: Foloseste /gps -> Business-uri pentru lista completa.") or "Tip: Use /gps -> Businesses for the full list.")
                    end
                imgui.EndChild()

            elseif active_tab == 7 then -- Shop Tab
            local isRO = (iniData.settings.lang == 0)

            -- 1. Panoul din stanga (Navigare)
            imgui.BeginChild("ShopNavigationPanel", imgui.ImVec2(200, 0), true)
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("CATEGORII SHOP:") or "SHOP CATEGORIES:")
                imgui.Separator()
                imgui.Spacing()
                
                imgui.BeginChild("ShopScrollNavigation", imgui.ImVec2(0, 0), false)
                    local shop_items = {
                        "Premium Account", "Vouchers", "Buy Gold", "Gold Vehicles", "Hidden Color", 
                        "Extra Vehicle Slot", "Vehicle KM Reset", "VIP Car", "Vehicle Age", 
                        "Vehicle 3D Text", "Extra Favorite Slot", "Vehicle Colored Plate", 
                        "House Interiors", "House Garage", "Clans", "Clan Name & Tag", 
                        "Clan Color", "Clan HQ Claim", "Clan HQ Interior", "Clear Faction Punish", 
                        "Change Nickname", "Clear Warn", "Change Sex", "Safebox", 
                        "Marathon", "Private Frequency"
                    }
                    
                    local themeButton = imgui.GetStyle().Colors[imgui.Col.Button]
                    local themeHovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
                    local themeActive = imgui.GetStyle().Colors[imgui.Col.ButtonActive]

                    for idx, name in ipairs(shop_items) do
                        local isSelected = (selected_shop == idx)
                        
                        if isSelected then
                            imgui.PushStyleColor(imgui.Col.Button, themeActive)
                        else
                            imgui.PushStyleColor(imgui.Col.Button, themeButton)
                        end
                        imgui.PushStyleColor(imgui.Col.ButtonHovered, themeHovered)
                        imgui.PushStyleColor(imgui.Col.ButtonActive, themeActive)
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))

                        if imgui.Button(name .. "##shop_btn_" .. idx, imgui.ImVec2(180, 30)) then
                            selected_shop = idx 
                        end
                        
                        imgui.PopStyleColor(4)
                    end
                imgui.EndChild() 
            imgui.EndChild() 

            imgui.SameLine()

            imgui.BeginChild("ShopContent", imgui.ImVec2(0, 0), true)
                
                if selected_shop == 1 then -- PREMIUM ACCOUNT
                    imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- CONT PREMIUM ---") or "--- PREMIUM ACCOUNT ---")
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.BeginChild("PremiumIntro", imgui.ImVec2(0, 80), true)
                        imgui.TextWrapped(isRO and u8("Cu totii incepem de la aceleasi statistici, insa pe parcurs, daca doriti sa dispuneti de si mai multe facilitati pe serverele B-Zone RPG, trebuie sa achizitionati un astfel de pachet. Folositi comanda /shop.") 
                        or "We all start from the same stats, but along the way, if you want more perks on B-Zone RPG servers, you must purchase a premium package. Use /shop in-game.")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PACHETE DISPONIBILE:") or "AVAILABLE PACKAGES:")
                    
                    imgui.BeginChild("PremiumPackages", imgui.ImVec2(0, 130), true)
                        imgui.Text(isRO and u8("1 Saptamana [Trial]: Gratuit (O singura data)\n1 Saptamana: 90 Gold\n1 Luna: 320 Gold\n3 Luni: 840 Gold\n6 Luni: 1600 Gold\n1 An: 3000 Gold") 
                        or "1 Week [Trial]: Free (Once only)\n1 Week: 90 Gold\n1 Month: 320 Gold\n3 Months: 840 Gold\n6 Months: 1600 Gold\n1 Year: 3000 Gold")
                    imgui.EndChild()

                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("BENEFICII:") or "BENEFITS:")
                    
                    imgui.BeginChild("PremiumBenefits", imgui.ImVec2(0, 0), true)
                        local benefits = isRO and {
                            "Dobanda banca: 0.01 -> 0.03", "Salariu payday: +25 la suta", "Bani joburi: +50 la suta",
                            "Bonus 5 ore: Respect, Jaf, Evadare, Accept, -1 FP", "Respect: Nu se pierde la /buylevel",
                            "Vehicule sport: Acces Turismo, Bullet, Infernus etc.", "Limite: Jaf (20), Evadare (40), Accept (300)",
                            "Comanda /mp3 oriunde", "Combustibil: pana la 150'/.", "Race: miza pana la $2000", "Friends list: pana la 60 sloturi"
                        } or {
                            "Bank interest: 0.01 -> 0.03", "Payday salary: +25 la suta", "Job money: +50 la suta",
                            "5-hour bonus: Respect, Rob, Escape, Accept, -1 FP", "Respect: No loss on /buylevel",
                            "Sport vehicles: Access to Turismo, Bullet, Infernus etc.", "Limits: Rob (20), Escape (40), Accept (300)",
                            "Command /mp3 anywhere", "Fuel: up to 150'/.", "Race: stake up to $2000", "Friends list: up to 60 slots"
                        }
                        
                        for _, b in ipairs(benefits) do
                            imgui.BulletText(u8(b))
                        end
                    imgui.EndChild()

            elseif selected_shop == 2 then -- VOUCHERE
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- VOUCHERE ---") or "--- VOUCHERS ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("VoucherInfo", imgui.ImVec2(0, 100), true)
                    imgui.TextWrapped(isRO and u8("Voucherele reprezinta o forma de plata pentru jucatori. Membrii STAFF (lideri/helperi/admini) NU primesc vouchere ca plata lunara.") 
                    or "Vouchers are a form of payment for players. STAFF members (leaders/helpers/admins) DO NOT receive vouchers as monthly payment.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CARACTERISTICI GENERALE:") or "GENERAL FEATURES:")
                
                imgui.BeginChild("VoucherFeatures", imgui.ImVec2(0, 150), true)
                    local features = isRO and {
                        "Valabilitate: Maxim 6 luni.",
                        "Notificare: Ai 7 zile pana la expirare.",
                        "Trade: Se pot vinde prin [/trade] de maxim 2 ori.",
                        "Dupa 2 trade-uri, ramane definitiv pe cont.",
                        "Cele ce expira in 24h sunt marcate cu rosu."
                    } or {
                        "Validity: Max 6 months.",
                        "Notification: You get 7 days before expiration.",
                        "Trade: Can be sold via [/trade] max 2 times.",
                        "After 2 trades, it remains permanently on the account.",
                        "Those expiring in 24h are marked in red."
                    }
                    for _, f in ipairs(features) do imgui.BulletText(u8(f)) end
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("COMENZI:") or "COMMANDS:")
                imgui.BulletText("/voucher, /vouchers, /vouchere")
                imgui.TextWrapped(isRO and u8("Dialogul ofera paginatie (<<< >>>) daca ai prea multe vouchere si afiseaza dinamic numarul lor.") 
                or "The dialog offers pagination (<<< >>>) if you have too many vouchers and displays their number dynamically.")

                elseif selected_shop == 3 then -- BUY GOLD
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- CUMPARA GOLD ---") or "--- BUY GOLD ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("GoldIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Principala sursa de procurare a goldului (moneda premium) este reprezentata de RPG Website.") 
                    or "The main source for acquiring gold (the premium currency) is the RPG Website.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PASI CUMPARARE:") or "PURCHASE STEPS:")
                
                imgui.BeginChild("GoldSteps", imgui.ImVec2(0, 180), true)
                    if isRO then
                        imgui.TextWrapped("1. Conecteaza-te pe website-ul RPG si da click pe iconita cosului.")
                        imgui.TextWrapped("2. Completeaza datele de facturare (doar prima data).")
                        imgui.TextWrapped("3. Mergi inapoi si apasa pe butonul galben 'Buy Gold'.")
                        imgui.TextWrapped("4. Adauga pachetele dorite in cos, specifica jucatorul si metoda de plata.")
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Nota: Poti folosi ulterior [/shop] sau [/buyvehicle] pentru a consuma Gold-ul.")
                    else
                        imgui.TextWrapped("1. Log in to the RPG website and click on the shopping cart icon.")
                        imgui.TextWrapped("2. Fill in your billing info (only required once).")
                        imgui.TextWrapped("3. Go back and click the yellow 'Buy Gold' button.")
                        imgui.TextWrapped("4. Add desired packages to your cart, specify the player and payment method.")
                        imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "Note: You can later use [/shop] or [/buyvehicle] to spend your Gold.")
                    end
                imgui.EndChild()

                elseif selected_shop == 4 then -- GOLD VEHICLES
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- VEHICULE GOLD ---") or "--- GOLD VEHICLES ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("GoldIntro", imgui.ImVec2(0, 50), true)
                    imgui.TextWrapped(isRO and u8("Mai jos gasiti vehiculele serverului ce pot fi achizitionate cu Gold. Vehiculele nu pot fi vandute jucatorilor, doar returnate DealerShip-ului pentru 40'/. din valoare. Nu este necesar cont premium.") 
                    or "Below you can find the server vehicles that can be purchased with Gold. Vehicles cannot be sold to players, only returned to the Dealership for 40'/. of their value. Premium account is not required.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("LISTA VEHICULE:") or "VEHICLE LIST:")
                
                imgui.BeginChild("GoldList", imgui.ImVec2(0, 480), true)
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("MASINI:") or "CARS:")
                    imgui.Separator()
                    imgui.Text("Buffalo: 2.149")
                    imgui.Text("Premier: 299")
                    imgui.Text("Sabre: 1.699")
                    imgui.Text("Comet: 1.949")
                    imgui.Text("Sandking: 1.599")
                    imgui.Text("Super GT: 1.899")
                    imgui.Text("Feltzer: 999")
                    imgui.Text("Jester: 1.799")
                    imgui.Text("Sultan: 2.199")
                    imgui.Text("Elegy: 2.099")
                    imgui.Text("Cheetah: 2.299")
                    imgui.Text("Bullet: 2.849")
                    imgui.Text("Infernus: 2.999")
                    imgui.Text("Turismo: 2.499")
                    imgui.Text("Banshee: 2.599")
                    imgui.Text("Monster Truck: 3.799")
                    imgui.Text("Hotring: 3.799")
                    imgui.Spacing()
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("MOTO / BICICLETE:") or "MOTO / BIKES:")
                    imgui.Text("Freeway: 649")
                    imgui.Text("FCR-900: 899 ")
                    imgui.Text("NRG-500: 1.899")
                    imgui.Spacing()
                    imgui.Separator()
                    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), isRO and u8("ELICOPTERE:") or "HELICOPTERS:")
                    imgui.Text("Sparrow: 2.399")
                    imgui.Text("Maverick: 4.999")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("LEGENDA:") or "LEGEND:")
                
                imgui.BeginChild("GoldLegend", imgui.ImVec2(0, 0), true)
                    local legend = isRO and {
                        "Pret Dealership: Pretul bunului cumparat.",
                        "Refund: 40 la suta din valoare inapoi la DealerShip.",
                        "Viteza maxima: Limita vehiculului.",
                        "Numar de locuri: Capacitate maxima.",
                        "Tunabil: Numele tuning-ului sau 'Nu este tunabil'."
                    } or {
                        "Dealership Price: The purchase price.",
                        "Refund: 40 '/. of value back at the Dealership.",
                        "Max Speed: The vehicle's speed limit.",
                        "Seats: Maximum capacity.",
                        "Tunable: Tuning name or 'Not tunable'."
                    }
                    for _, l in ipairs(legend) do
                        imgui.BulletText(u8(l))
                    end
                imgui.EndChild()

                elseif selected_shop == 5 then -- HIDDEN COLOR
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- HIDDEN COLOR ---") or "--- HIDDEN COLOR ---")
                imgui.Separator()
                imgui.Spacing()

                -- Introducere
                imgui.BeginChild("HiddenIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Daca doresti o culoare aparte, speciala, pentru vehiculul tau, trebuie sa cumperi un set de culori ascunse (hidden). Pret: 600 Gold.") 
                    or "If you want a special, unique color for your vehicle, you must buy a set of hidden colors. Price: 600 Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("DETALII:") or "DETAILS:")
                
                imgui.BeginChild("HiddenDetails", imgui.ImVec2(0, 100), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold (vezi [/shop]).") or "Price: 600 Gold (see [/shop]).")
                    imgui.BulletText(isRO and u8("Durata: Permanent (pana la vanzarea vehiculului).") or "Duration: Permanent (until the vehicle is sold).")
                    imgui.BulletText(isRO and u8("Daca vinzi vehiculul, culorile dispar.") or "If you sell the vehicle, the colors disappear.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI (PASI):") or "HOW TO BUY (STEPS):")
                
                imgui.BeginChild("HiddenSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza [/shop] si selecteaza 'Hidden color'.",
                        "Apasati butonul 'Order'.",
                        "Anulati orice checkpoint rosu existent [/cancel checkpoint].",
                        "Mergeti la checkpointul rosu primit (CarColor biz).",
                        "Folositi [/hiddencolor] langa biz.",
                        "Selectati culorile si apasati 'Buy Color'."
                    } or {
                        "Access [/shop] and select 'Hidden color'.",
                        "Press the 'Order' button.",
                        "Cancel any active red checkpoint [/cancel checkpoint].",
                        "Go to the red checkpoint (CarColor biz).",
                        "Use [/hiddencolor] near the biz.",
                        "Select colors and press 'Buy Color'."
                    }
                    for _, s in ipairs(steps) do
                        imgui.BulletText(u8(s))
                    end
                imgui.EndChild()

                elseif selected_shop == 6 then -- EXTRA VEHICLE SLOT
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- EXTRA VEHICLE SLOT ---") or "--- EXTRA VEHICLE SLOT ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("SlotIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Garajul standard este limitat la 4 vehicule. Daca ai nevoie de mai mult spatiu, poti extinde capacitatea acestuia folosind Gold prin comanda /shop.") 
                    or "The standard garage is limited to 4 vehicles. If you need more space, you can expand its capacity using Gold via the /shop command.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("DURATA SI PRET:") or "DURATION AND PRICE:")
                
                imgui.BeginChild("SlotDetails", imgui.ImVec2(0, 70), true)
                    imgui.BulletText(isRO and u8("Pret: 800 Gold pentru un slot suplimentar.") or "Price: 800 Gold for an additional slot.")
                    imgui.BulletText(isRO and u8("Durata: Permanent.") or "Duration: Permanent.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("SlotSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Extra vehicle slot - 800 Gold'.",
                        "Citeste informatiile afisate pe ecran.",
                        "Apasati butonul 'Order'.",
                        "Slotul va fi adaugat instantaneu garajului tau."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Extra vehicle slot - 800 Gold'.",
                        "Read the information displayed on the screen.",
                        "Press the 'Order' button.",
                        "The slot will be added to your garage instantly."
                    }
                    for _, s in ipairs(steps) do
                        imgui.BulletText(u8(s))
                    end
                imgui.EndChild()

                elseif selected_shop == 7 then -- VEHICLE KM RESET
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- RESETARE KM VEHICUL ---") or "--- VEHICLE KM RESET ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("KMIntro", imgui.ImVec2(0, 90), true)
                    imgui.TextWrapped(isRO and u8("Doresti sa scapi de kilometrii parcursi si sa vinzi masina mai usor? Reseteaza kilometrajul la 0 si fa-o sa para ca noua!") 
                    or "Do you want to get rid of the miles driven and sell your car easier? Reset the mileage to 0 and make it look like new!")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET:") or "PRICE:")
                
                imgui.BeginChild("KMPrice", imgui.ImVec2(0, 45), true)
                    imgui.BulletText(isRO and u8("Pretul resetarii kilometrajului este de 600 Gold.") or "The price for resetting the mileage is 600 Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("KMSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Vehicle KM Reset - 600 Gold'.",
                        "Citeste informatiile afisate pe ecran.",
                        "Apasati butonul 'Order'.",
                        "Kilometrajul vehiculului va fi resetat instantaneu la 0."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Vehicle KM Reset - 600 Gold'.",
                        "Read the information displayed on the screen.",
                        "Press the 'Order' button.",
                        "The vehicle's mileage will be instantly reset to 0."
                    }
                    for _, s in ipairs(steps) do
                        imgui.BulletText(u8(s))
                    end
                imgui.EndChild()

                elseif selected_shop == 8 then -- VIP CAR
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- VIP CAR ---") or "--- VIP CAR ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("VIPIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Doresti un vehicul unic cu text personalizat? Converteste-ti masina intr-un vehicul VIP. Textul si culoarea pot fi modificate ulterior oricand!") 
                    or "Want a unique vehicle with custom text? Convert your car into a VIP vehicle. Text and color can be changed anytime later!")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI DURATA:") or "PRICE AND DURATION:")
                
                imgui.BeginChild("VIPDetails", imgui.ImVec2(0, 75), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Durata: Pana la vanzarea vehiculului (se pierde la vanzare).") or "Duration: Until the vehicle is sold (lost upon sale).")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("VIPSteps", imgui.ImVec2(0, 120), true)
                    local steps = isRO and {
                        "Acceseaza [/v] si alege vehiculul dorit.",
                        "Selecteaza 'Convert to VIP car (600 Gold)'.",
                        "Citeste informatiile si apasa 'Yes'.",
                        "Editeaza textul si culoarea din meniul [/v]."
                    } or {
                        "Access [/v] and choose your vehicle.",
                        "Select 'Convert to VIP car (600 Gold)'.",
                        "Read the info and press 'Yes'.",
                        "Edit text and color from the [/v] menu."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()
                
                imgui.Spacing()
                imgui.TextWrapped(isRO and u8("Nota: Vehiculele eligibile includ: Infernus, Bullet, Banshee, NRG-500, Sultan si multe altele (verifica lista completa in /v).") 
                or "Note: Eligible vehicles include: Infernus, Bullet, Banshee, NRG-500, Sultan and many others (check full list in /v).")

                elseif selected_shop == 9 then -- VEHICLE AGE
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- VEHICLE AGE ---") or "--- VEHICLE AGE ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("AgeIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Creste valoarea vehiculului tau adaugandu-i zile la varsta totala. Un vehicul mai vechi este mai pretios si mai atragator pentru cumparatori!") 
                    or "Increase the value of your vehicle by adding days to its total age. An older vehicle is more valuable and attractive to buyers!")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PACHETE SI PRETURI:") or "PACKAGES AND PRICES:")
                
                imgui.BeginChild("AgePackages", imgui.ImVec2(0, 100), true)
                    imgui.BulletText(isRO and u8("+ 30 zile: 400 Gold") or "+ 30 days: 400 Gold")
                    imgui.BulletText(isRO and u8("+ 180 zile: 2.000 Gold") or "+ 180 days: 2,000 Gold")
                    imgui.BulletText(isRO and u8("+ 365 zile: 4.000 Gold") or "+ 365 days: 4,000 Gold")
                    imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), isRO and u8("* Zilele raman permanent adaugate.") or "* Days are added permanently.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("AgeSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza garajul tau folosind [/vehicles].",
                        "Selecteaza unul dintre cele 3 pachete disponibile.",
                        "Citeste informatiile despre procesul de cumparare.",
                        "Apasati butonul 'Order'.",
                        "Zilele vor fi adaugate instantaneu la varsta vehiculului."
                    } or {
                        "Access your garage using [/vehicles].",
                        "Select one of the 3 available packages.",
                        "Read the information about the purchase process.",
                        "Press the 'Order' button.",
                        "The days will be added instantly to your vehicle's age."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 10 then -- VEHICLE 3D TEXT
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- VEHICUL CU 3D TEXT ---") or "--- VEHICLE 3D TEXT ---")
                imgui.Separator()
                imgui.Spacing()

                -- Introducere
                imgui.BeginChild("3DTextIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Adauga un text personalizat vizibil oricui pe vehiculul tau! Textul este dinamic si poate fi pozitionat oriunde in jurul masinii.") 
                    or "Add a custom text visible to everyone on your vehicle! The text is dynamic and can be positioned anywhere around the car.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("DETALII SI REGULI:") or "DETAILS AND RULES:")
                
                imgui.BeginChild("3DTextDetails", imgui.ImVec2(0, 150), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Maxim 60 de caractere.") or "Maximum 60 characters.")
                    imgui.BulletText(isRO and u8("Pozitie: Raza de 10 unitati (0-10).") or "Position: 10 unit radius (0-10).")
                    imgui.BulletText(isRO and u8("Format culori: {RRGGBB}Text.") or "Color format: {RRGGBB}Text.")
                    imgui.BulletText(isRO and u8("Nota: Se pierde la vanzarea vehiculului.") or "Note: Lost upon vehicle sale.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM ADAUGI / MODIFICI:") or "HOW TO ADD / MODIFY:")
                
                imgui.BeginChild("3DTextSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Foloseste [/vehicles] si alege vehiculul dorit.",
                        "Selecteaza 'Adauga 3D text pe masina'.",
                        "Modifica Text/Culoare/Pozitie direct din meniul [/vehicles].",
                        "Foloseste coduri RGB intre acolade {} pentru culori."
                    } or {
                        "Use [/vehicles] and choose your vehicle.",
                        "Select 'Add 3D text to car'.",
                        "Modify Text/Color/Position directly from [/vehicles].",
                        "Use RGB codes inside {} for colors."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 11 then -- EXTRA FAVORITE SLOT
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- SLOT FAVORITE EXTRA ---") or "--- EXTRA FAVORITE SLOT ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("FavIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Doresti sa adaugi mai multe vehicule in lista ta de favorite? Poti cumpara sloturi suplimentare pentru lista de vehicule favorite folosind Gold.") 
                    or "Want to add more vehicles to your favorites list? You can purchase additional slots for the favorite vehicles list using Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET:") or "PRICE:")
                
                imgui.BeginChild("FavPrice", imgui.ImVec2(0, 45), true)
                    imgui.BulletText(isRO and u8("Pret: 300 Gold per slot.") or "Price: 300 Gold per slot.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("FavSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza 'Extra Favorite Slot - 300 Gold'.",
                        "Confirma achizitia in dialogul aparut.",
                        "Apasati butonul 'Order'.",
                        "Vei primi instantaneu un slot in plus in lista de favorite."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select 'Extra Favorite Slot - 300 Gold'.",
                        "Confirm the purchase in the dialog that appears.",
                        "Press the 'Order' button.",
                        "You will instantly receive an extra slot in your favorites list."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 12 then -- VEHICLE COLORED PLATE
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- PLACUTA INMATRICULARE COLORATA ---") or "--- COLORED VEHICLE PLATE ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("PlateIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Personalizeaza numarul de inmatriculare al vehiculului tau alegand o culoare unica. Textul si culoarea pot fi modificate ulterior.") 
                    or "Customize your vehicle's license plate by choosing a unique color. The text and color can be modified later.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CARACTERISTICI:") or "FEATURES:")
                
                imgui.BeginChild("PlateDetails", imgui.ImVec2(0, 130), true)
                    imgui.BulletText(isRO and u8("Pret: 300 Gold.") or "Price: 300 Gold.")
                    imgui.BulletText(isRO and u8("Maxim 10 caractere (fara caractere speciale).") or "Max 10 characters (no special characters).")
                    imgui.BulletText(isRO and u8("Se pierde la vanzarea vehiculului.") or "Lost upon vehicle sale.")
                    imgui.BulletText(isRO and u8("Format culori: {RRGGBB} intre acolade.") or "Color format: {RRGGBB} inside braces.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM ADAUGI / MODIFICI:") or "HOW TO ADD / MODIFY:")
                
                imgui.BeginChild("PlateSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Foloseste [/vehicles] si alege vehiculul dorit.",
                        "Selecteaza 'Adauga placuta de inmatriculare colorata'.",
                        "Foloseste optiunea 'Schimba placuta de Inmatriculare'.",
                        "Modifica textul, alege culoare RGB sau din paleta prestabilita."
                    } or {
                        "Use [/vehicles] and choose your vehicle.",
                        "Select 'Add colored license plate'.",
                        "Use the 'Change license plate' option.",
                        "Modify text, choose RGB color or from the preset palette."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 13 then -- HOUSE INTERIORS
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- INTERIOARE CASA ---") or "--- HOUSE INTERIORS ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("HouseIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Infrumuseteaza-ti locuinta cu unul dintre cele aproximativ 40 de interioare disponibile. Un interior nou te va face cel mai invidiat vecin!") 
                    or "Beautify your home with one of the 40+ available interiors. A new interior will make you the most envied neighbor!")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PACHETE SI PRETURI:") or "PACKAGES AND PRICES:")
                
                imgui.BeginChild("HousePackages", imgui.ImVec2(0, 120), true)
                    imgui.BulletText(isRO and u8("Interior Mic: 1.400 Gold (6 variante)") or "Small Interior: 1,400 Gold (6 variants)")
                    imgui.BulletText(isRO and u8("Interior Mediu: 2.000 Gold (24 variante)") or "Medium Interior: 2,000 Gold (24 variants)")
                    imgui.BulletText(isRO and u8("Interior Mare: 2.600 Gold (10 variante)") or "Big Interior: 2,600 Gold (10 variants)")
                    imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), isRO and u8("* Interiorul este permanent, dar se reseteaza la vanzare.") or "* Interior is permanent, but resets upon sale.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("HouseSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Trebuie sa fii in exteriorul casei.",
                        "Acceseaza [/shop] si alege pachetul dorit.",
                        "Apasati butonul 'Order'.",
                        "Alege interiorul preferat din lista si apasa 'Select'."
                    } or {
                        "You must be outside the house.",
                        "Access [/shop] and choose your preferred package.",
                        "Press the 'Order' button.",
                        "Choose the interior from the list and press 'Select'."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 14 then -- HOUSE GARAGE
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- GARAJ CASA ---") or "--- HOUSE GARAGE ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("GarageIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Detinatorii de case pot achizitiona garaje speciale pentru a-si adaposti vehiculele in siguranta. Garajul se plaseaza in locatia curenta.") 
                    or "Homeowners can purchase special garages to shelter their vehicles safely. The garage is placed at your current location.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("TIPURI SI PRETURI:") or "TYPES AND PRICES:")
                
                imgui.BeginChild("GaragePackages", imgui.ImVec2(0, 100), true)
                    imgui.BulletText(isRO and u8("Garaj Mic (4 sloturi): 1.000 Gold") or "Small Garage (4 slots): 1,000 Gold")
                    imgui.BulletText(isRO and u8("Garaj Mediu (8 sloturi): 1.600 Gold") or "Medium Garage (8 slots): 1,600 Gold")
                    imgui.BulletText(isRO and u8("Garaj Mare (12 sloturi): 2.400 Gold") or "Big Garage (12 slots): 2,400 Gold")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), isRO and u8("ATENTIE:") or "WARNING:")
                imgui.TextWrapped(isRO and u8("Pozitia este definitiva! Nu exista optiune de editare ulterior. Garajul dispare la vanzarea casei.") 
                or "Position is final! There is no edit option later. The garage disappears upon selling the house.")

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("GarageSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza [/shop] si alege tipul de garaj.",
                        "Pozitioneaza-te unde vrei sa fie intrarea.",
                        "Citeste cu atentie informatiile despre plasare.",
                        "Apasati butonul 'Order' pentru a finaliza."
                    } or {
                        "Access [/shop] and choose the garage type.",
                        "Position yourself where you want the entrance.",
                        "Read carefully the placement information.",
                        "Press the 'Order' button to finish."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 15 then -- CLANS
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- CLANURI ---") or "--- CLANS ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("ClanIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Grupeaza-te cu prietenii tai si creati propriul clan! Beneficiati de sisteme de teritorii, socializare si posibilitati de castig.") 
                    or "Group up with your friends and create your own clan! Benefit from territory systems, social networking, and earning possibilities.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PACHETE (30 ZILE):") or "PACKAGES (30 DAYS):")
                
                imgui.BeginChild("ClanPackages", imgui.ImVec2(0, 130), true)
                    imgui.BulletText(isRO and u8("Small Clan (15 sloturi): 2.000 Gold") or "Small Clan (15 slots): 2,000 Gold")
                    imgui.BulletText(isRO and u8("Medium Clan (25 sloturi): 3.000 Gold") or "Medium Clan (25 slots): 3,000 Gold")
                    imgui.BulletText(isRO and u8("Big Clan (50 sloturi): 4.000 Gold") or "Big Clan (50 slots): 4,000 Gold")
                    imgui.BulletText(isRO and u8("Mega Clan (75 sloturi): 5.500 Gold") or "Mega Clan (75 slots): 5,500 Gold")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("ClanSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza [/shop] si alege pachetul dorit.",
                        "Apasati butonul 'Order'.",
                        "Introdu numele si tag-ul clanului (fara paranteze).",
                        "Re-logheaza-te pe server pentru sincronizare.",
                        "Contacteaza un admin forum pentru sectiunea speciala."
                    } or {
                        "Access [/shop] and choose the desired package.",
                        "Press the 'Order' button.",
                        "Enter the clan name and tag (without brackets).",
                        "Re-log on the server for synchronization.",
                        "Contact a forum admin for the special section."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 16 then -- CLAN NAME & TAG CHANGE
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- SCHIMBARE NUME & TAG CLAN ---") or "--- CLAN NAME & TAG CHANGE ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("ClanChangeIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Doresti un rebranding pentru clanul tau? Poti schimba numele si tag-ul acestuia direct din shop pentru 600 Gold.") 
                    or "Want a rebranding for your clan? You can change its name and tag directly from the shop for 600 Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("REGULI SI LIMITE:") or "RULES AND LIMITS:")
                
                imgui.BeginChild("ClanChangeDetails", imgui.ImVec2(0, 130), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Nume clan: 1-22 caractere.") or "Clan name: 1-22 characters.")
                    imgui.BulletText(isRO and u8("TAG clan: 1-4 caractere.") or "Clan TAG: 1-4 characters.")
                    imgui.TextColored(imgui.ImVec4(1, 0.2, 0.2, 1), isRO and u8("Atentie: Numele vulgare pot duce la stergerea clanului!") or "Warning: Vulgar names can lead to clan deletion!")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM SCHIMBI:") or "HOW TO CHANGE:")
                
                imgui.BeginChild("ClanChangeSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza 'Clan Name+Tag Change'.",
                        "Confirma achizitia in dialogul aparut.",
                        "Introdu noul nume dorit.",
                        "Introdu noul TAG dorit."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select 'Clan Name+Tag Change'.",
                        "Confirm the purchase in the dialog that appears.",
                        "Enter the desired new name.",
                        "Enter the desired new TAG."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 17 then -- CLAN COLOR
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- CULOARE CLAN ---") or "--- CLAN COLOR ---")
                imgui.Separator()
                imgui.Spacing()

                -- Introducere
                imgui.BeginChild("ClanColorIntro", imgui.ImVec2(0, 90), true)
                    imgui.TextWrapped(isRO and u8("Personalizeaza identitatea vizuala a clanului tau! Culoarea se aplica la tag, nume, peretii HQ-ului si teritorii.") 
                    or "Customize your clan's visual identity! The color applies to the tag, name, HQ walls, and territories.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI INFORMATII:") or "PRICE AND INFO:")
                
                imgui.BeginChild("ClanColorDetails", imgui.ImVec2(0, 100), true)
                    imgui.BulletText(isRO and u8("Prima schimbare: Gratuit.") or "First change: Free.")
                    imgui.BulletText(isRO and u8("Pret ulterior: 400 Gold.") or "Subsequent price: 400 Gold.")
                    imgui.BulletText(isRO and u8("Format necesar: Cod HEX (ex: 3399FF).") or "Required format: HEX code (e.g., 3399FF).")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM SCHIMBI CULOAREA:") or "HOW TO CHANGE COLOR:")
                
                imgui.BeginChild("ClanColorSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Foloseste comanda [/clancolor] in joc.",
                        "Alege codul HEX al culorii dorite (foloseste un 'HEX Picker').",
                        "Introdu comanda in format: [/clancolor COD_HEX].",
                        "Verifica previzualizarea si apasa 'Yes' pentru confirmare."
                    } or {
                        "Use command [/clancolor] in-game.",
                        "Choose the HEX code for the desired color (use a 'HEX Picker').",
                        "Enter the command as: [/clancolor HEX_CODE].",
                        "Check the preview and press 'Yes' to confirm."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()    

                elseif selected_shop == 18 then -- CLAN HQ CLAIM
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- REVENDICARE HQ CLAN ---") or "--- CLAN HQ CLAIM ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("HQIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Schimba locatia HQ-ului clanului tau! Poti alege dintr-o varietate de 71 de HQ-uri disponibile pe harta.") 
                    or "Change your clan's HQ location! You can choose from a variety of 71 available HQs on the map.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CONDITII:") or "REQUIREMENTS:")
                
                imgui.BeginChild("HQDetails", imgui.ImVec2(0, 110), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Nivel clan minim: 5.") or "Minimum clan level: 5.")
                    imgui.BulletText(isRO and u8("Prima revendicare: Gratuit (la atingerea nivelului 5).") or "First claim: Free (at reaching level 5).")
                    imgui.BulletText(isRO and u8("Verifica creditele cu [/claninfo].") or "Check credits with [/claninfo].")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM REVENDICI:") or "HOW TO CLAIM:")
                
                imgui.BeginChild("HQSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Cumpara 'HQ Claim' din [/shop].",
                        "Mergi la intrarea HQ-ului dorit.",
                        "Foloseste comanda [/claimhq] pentru a-l revendica.",
                        "HQ-ul va deveni proprietatea clanului tau."
                    } or {
                        "Purchase 'HQ Claim' from [/shop].",
                        "Go to the entrance of the desired HQ.",
                        "Use command [/claimhq] to claim it.",
                        "The HQ will become your clan's property."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 19 then -- CLAN HQ INTERIOR
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- INTERIOR HQ CLAN ---") or "--- CLAN HQ INTERIOR ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("HQIntIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Schimba aspectul interior al HQ-ului tau cu unul dintre interioarele predefinite disponibile, in functie de nivelul clanului tau.") 
                    or "Change the interior look of your HQ with one of the available predefined interiors, depending on your clan's level.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CONDITII:") or "REQUIREMENTS:")
                
                imgui.BeginChild("HQIntDetails", imgui.ImVec2(0, 110), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Nivel clan minim: 7.") or "Minimum clan level: 7.")
                    imgui.BulletText(isRO and u8("Primul interior: Gratuit (la nivelul 7).") or "First interior: Free (at level 7).")
                    imgui.BulletText(isRO and u8("Verifica creditele cu [/claninfo].") or "Check credits with [/claninfo].")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM MODIFICI INTERIORUL:") or "HOW TO CHANGE INTERIOR:")
                
                imgui.BeginChild("HQIntSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Cumpara 'Clan HQ Interior' din [/shop].",
                        "Pozitioneaza-te in fata HQ-ului tau.",
                        "Foloseste comanda [/interiorhq].",
                        "Alege interiorul dorit din lista si apasa 'Yes'."
                    } or {
                        "Purchase 'Clan HQ Interior' from [/shop].",
                        "Position yourself in front of your HQ.",
                        "Use command [/interiorhq].",
                        "Choose the desired interior from the list and press 'Yes'."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 20 then -- CLEAR FACTION PUNISH
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- CLEAR FACTION PUNISH ---") or "--- CLEAR FACTION PUNISH ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("FPIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Ai primit Faction Punish si vrei sa intri mai repede intr-o factiune? Poti sterge 10 puncte de FP direct din shop.") 
                    or "Did you get Faction Punish and want to join a faction faster? You can clear 10 FP points directly from the shop.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                
                imgui.BeginChild("FPDetails", imgui.ImVec2(0, 75), true)
                    imgui.BulletText(isRO and u8("Pret: 200 Gold pentru 10 puncte FP.") or "Price: 200 Gold for 10 FP points.")
                    imgui.BulletText(isRO and u8("Taxa fixa: Chiar daca ai sub 10 puncte, pretul ramane 200 Gold.") or "Fixed fee: Even if you have less than 10 points, the price is 200 Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("FPSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Clear 10 FP - 200 Gold'.",
                        "Citeste informatiile afisate pe ecran.",
                        "Apasati butonul 'Order'.",
                        "Punctele de FP vor fi sterse instantaneu."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Clear 10 FP - 200 Gold'.",
                        "Read the information displayed on the screen.",
                        "Press the 'Order' button.",
                        "The FP points will be removed instantly."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 21 then -- CHANGE NICKNAME
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- SCHIMBARE NUME ---") or "--- CHANGE NICKNAME ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("NickIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Ai nevoie de o noua identitate in joc? Poti schimba numele tau actual direct din magazinul comunitatii.") 
                    or "Do you need a new identity in-game? You can change your current name directly from the community shop.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET:") or "PRICE:")
                
                imgui.BeginChild("NickPrice", imgui.ImVec2(0, 45), true)
                    imgui.BulletText(isRO and u8("Pretul schimbarii numelui este de 600 Gold.") or "The price for changing your name is 600 Gold.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("NickSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Change nickname - 600 Gold'.",
                        "Citeste informatiile si apasa 'Order'.",
                        "Introdu noul nume in casuta aparuta.",
                        "Apasati butonul 'Ok' pentru a finaliza schimbarea."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Change nickname - 600 Gold'.",
                        "Read the info and press 'Order'.",
                        "Enter the new name in the box that appears.",
                        "Press the 'Ok' button to finish the change."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 22 then -- CLEAR WARN
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- STERGE AVERTISMENT (WARN) ---") or "--- CLEAR WARN ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("WarnIntro", imgui.ImVec2(0, 80), true)
                    imgui.TextWrapped(isRO and u8("Ai primit avertizari (warns) care iti afecteaza reputatia? Poti sterge un avertisment direct din magazinul comunitatii.") 
                    or "Have you received warnings (warns) that affect your reputation? You can clear one warning directly from the community shop.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                
                imgui.BeginChild("WarnDetails", imgui.ImVec2(0, 85), true)
                    imgui.BulletText(isRO and u8("Pret: 400 Gold per avertisment.") or "Price: 400 Gold per warning.")
                    imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), isRO and u8("* Istoricul ramane vizibil pe website.") or "* History remains visible on the website.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("WarnSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Clear 1 warn - 400 Gold'.",
                        "Citeste informatiile despre procesul de stergere.",
                        "Apasati butonul 'Order'.",
                        "Avertismentul va fi sters instantaneu din cont."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Clear 1 warn - 400 Gold'.",
                        "Read the information about the removal process.",
                        "Press the 'Order' button.",
                        "The warning will be instantly removed from your account."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 23 then -- CHANGE SEX
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- SCHIMBARE SEX ---") or "--- CHANGE SEX ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("SexIntro", imgui.ImVec2(0, 70), true)
                    imgui.TextWrapped(isRO and u8("Doresti sa iti schimbi identitatea vizuala? Poti schimba sexul personajului tau pentru a debloca noi skin-uri.") 
                    or "Do you want to change your visual identity? You can change your character's sex to unlock new skins.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI DETALII:") or "PRICE AND DETAILS:")
                
                imgui.BeginChild("SexDetails", imgui.ImVec2(0, 70), true)
                    imgui.BulletText(isRO and u8("Pret: 600 Gold.") or "Price: 600 Gold.")
                    imgui.BulletText(isRO and u8("Modificarea este permanenta (poate fi inversata prin alta achizitie).") or "The change is permanent (can be reversed by another purchase).")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM CUMPERI:") or "HOW TO BUY:")
                
                imgui.BeginChild("SexSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Acceseaza magazinul comunitatii prin [/shop].",
                        "Selecteaza item-ul 'Change sex - 600 Gold'.",
                        "Citeste informatiile si apasa 'Order'.",
                        "Sexul va fi schimbat instantaneu in cel opus.",
                        "Foloseste [/clothes] pentru a alege noile skin-uri."
                    } or {
                        "Access the community shop via [/shop].",
                        "Select the item 'Change sex - 600 Gold'.",
                        "Read the info and press 'Order'.",
                        "Your sex will be changed instantly to the opposite one.",
                        "Use [/clothes] to choose your new skins."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 24 then -- SAFEBOX
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- SAFEBOX ---") or "--- SAFEBOX ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("SBIntro", imgui.ImVec2(0, 40), true)
                    imgui.TextWrapped(isRO and u8("Depoziteaza arme, materiale si droguri oriunde pe harta in siguranta.") or "Store weapons, materials, and drugs anywhere on the map safely.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("CAPACITATEA UTILIZABILA DE FIECARE ELEMENT:") or "USABLE CAPACITY PER ELEMENT:")
                
                imgui.BeginChild("SBCapacity", imgui.ImVec2(0, 620), true)
                    imgui.Text("1 material - 1 unitate.")
                    imgui.Text("1 gram droguri - 1 unitate.")
                    imgui.Separator()
                    imgui.Spacing()

                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Deagle / SD Pistol:")
                    imgui.Text("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.")
                    imgui.Text("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 17 de unitati.")
                    imgui.Text("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 14 de unitati.")
                    imgui.Text("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 11 de unitati.")
                    imgui.Text("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 8 de unitati.")
                    imgui.Spacing()
                    imgui.Separator()

                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Shotgun / Combat:")
                    imgui.Text("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 40 de unitati.")
                    imgui.Text("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 35 de unitati.")
                    imgui.Text("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 30 de unitati.")
                    imgui.Text("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 25 de unitati.")
                    imgui.Text("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.")
                    imgui.Spacing()
                    imgui.Separator()

                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "M4 / AK47:")
                    imgui.Text("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 24 de unitati.")
                    imgui.Text("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 23 de unitati.")
                    imgui.Text("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 22 de unitati.")
                    imgui.Text("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 21 de unitati.")
                    imgui.Text("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 20 de unitati.")
                    imgui.Spacing()
                    imgui.Separator()

                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "MP5 / TEC-9:")
                    imgui.Text("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 15 de unitati.")
                    imgui.Text("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 14 de unitati.")
                    imgui.Text("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 13 de unitati.")
                    imgui.Text("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 12 de unitati.")
                    imgui.Text("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 10 de unitati.")
                    imgui.Spacing()
                    imgui.Separator()

                    imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), "Sniper / Sniper Rifle:")
                    imgui.Text("Skill 1 Distribuitor de Arme - 1 glont ~ ocupa 350 de unitati.")
                    imgui.Text("Skill 2 Distribuitor de Arme - 1 glont ~ ocupa 338 de unitati.")
                    imgui.Text("Skill 3 Distribuitor de Arme - 1 glont ~ ocupa 325 de unitati.")
                    imgui.Text("Skill 4 Distribuitor de Arme - 1 glont ~ ocupa 313 de unitati.")
                    imgui.Text("Skill 5 Distribuitor de Arme - 1 glont ~ ocupa 300 de unitati.")
                    imgui.Separator()
                imgui.EndChild()

                elseif selected_shop == 25 then -- MARATHON
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- MARATON ---") or "--- MARATHON ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("MarIntro", imgui.ImVec2(0, 60), true)
                    imgui.TextWrapped(isRO and u8("Eveniment lunar automat pentru toti jucatorii. Completeaza obiective, aduna puncte si revendica premii zilnice.") 
                    or "Automated monthly event for all players. Complete objectives, gather points and claim daily rewards.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("DETALII EVENIMENT:") or "EVENT DETAILS:")
                
                imgui.BeginChild("MarDetails", imgui.ImVec2(0, 130), true)
                    imgui.BulletText(isRO and u8("Participare automata pentru nivel 1+.") or "Automatic participation for level 1+.")
                    imgui.BulletText(isRO and u8("Acces: comanda [/maraton] sau [/marathon].") or "Access: [/maraton] or [/marathon] command.")
                    imgui.BulletText(isRO and u8("Punctele se reporteaza pentru ziua urmatoare.") or "Points carry over to the next day.")
                    imgui.BulletText(isRO and u8("Premiile se revendica prin butonul 'CLAIM'.") or "Rewards are claimed via the 'CLAIM' button.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), isRO and u8("VERSIUNEA PRO SI COMPLETE:") or "PRO VERSION AND COMPLETE:")
                
                imgui.BeginChild("MarPro", imgui.ImVec2(0, 100), true)
                    imgui.TextColored(imgui.ImVec4(0.2, 0.8, 1, 1), isRO and u8("Versiunea PRO:") or "PRO Version:")
                    imgui.TextWrapped(isRO and u8("Ofera premii mai valoroase si posibilitatea de a primi recompensele ambelor versiuni simultan.") or "Offers higher value rewards and the ability to receive rewards from both versions simultaneously.")
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("Optiunea Complete (150 Gold):") or "Complete option (150 Gold):")
                    imgui.TextWrapped(isRO and u8("Finalizeaza instant progresul zilei curente.") or "Instantly finish current day progress.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), isRO and u8("CUM SA PARTICIPATI:") or "HOW TO PARTICIPATE:")
                
                imgui.BeginChild("MarSteps", imgui.ImVec2(0, 0), true)
                    local steps = isRO and {
                        "Deschide interfata cu [/maraton].",
                        "Verifica punctele necesare la butonul 'POINTS'.",
                        "Efectueaza activitati pe server pentru a aduna puncte.",
                        "Revendica premiile zilnice folosind 'CLAIM'.",
                        "Foloseste 'GET PRO' pentru avantaje extra."
                    } or {
                        "Open the interface with [/maraton].",
                        "Check required points at the 'POINTS' button.",
                        "Perform activities on the server to gather points.",
                        "Claim daily rewards using 'CLAIM'.",
                        "Use 'GET PRO' for extra perks."
                    }
                    for _, s in ipairs(steps) do imgui.BulletText(u8(s)) end
                imgui.EndChild()

                elseif selected_shop == 26 then -- PRIVATE FREQUENCY
                imgui.TextColored(imgui.ImVec4(1, 0.8, 0, 1), isRO and u8("--- FRECVENTA PRIVATA ---") or "--- PRIVATE FREQUENCY ---")
                imgui.Separator()
                imgui.Spacing()

                imgui.BeginChild("FreqIntro", imgui.ImVec2(0, 75), true)
                    imgui.TextWrapped(isRO and u8("Comunica in siguranta cu prietenii tai. Ai control total asupra frecventei tale: parole, excluderi si administrare completa.") 
                    or "Communicate safely with your friends. You have full control over your frequency: passwords, bans, and full management.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(0, 1, 0.95, 1), isRO and u8("PRET SI DURATA:") or "PRICE AND DURATION:")
                
                imgui.BeginChild("FreqDetails", imgui.ImVec2(0, 75), true)
                    imgui.BulletText(isRO and u8("Pret: 299 Gold pentru 31 de zile.") or "Price: 299 Gold for 31 days.")
                    imgui.BulletText(isRO and u8("Prelungire: Se pot adauga 31 de zile prin achizitionare repetata.") or "Extension: You can add 31 days by purchasing again.")
                imgui.EndChild()

                imgui.Spacing()
                imgui.TextColored(imgui.ImVec4(1, 0.9, 0, 1), isRO and u8("COMENZI:") or "COMMANDS:")
                
                imgui.BeginChild("FreqCommands", imgui.ImVec2(0, 150), true)
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/myfreq")
                    imgui.TextWrapped(isRO and u8("Administrare frecventa (parola, excluderi, distrugere).") or "Frequency management (password, bans, destruction).")
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/setfreq")
                    imgui.TextWrapped(isRO and u8("Seteaza frecventa (10.0-79.9 private, 80.0-109.9 publice).") or "Set frequency (10.0-79.9 private, 80.0-109.9 public).")
                    imgui.Spacing()
                    imgui.TextColored(imgui.ImVec4(0.2, 1, 0.2, 1), "/wt")
                    imgui.TextWrapped(isRO and u8("Comanda pentru a vorbi (necesita Walkie-Talkie din 24/7).") or "Command to speak (requires Walkie-Talkie from 24/7).")
                imgui.EndChild()

                else
                    imgui.Text(isRO and u8("Selecteaza o categorie din stanga.") or "Select a category from the left.")
                end
            imgui.EndChild() 
            
            elseif active_tab == 8 then 
            local isRO = (iniData.settings.lang == 0)
            local w = imgui.GetWindowWidth()
            
            imgui.Spacing()
            imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), ">> H E L P E R - 2 <<")
            imgui.Separator()
            
            imgui.BeginChild("Helper2_InfoText", imgui.ImVec2(-1, 80), true)
                imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                imgui.TextWrapped(isRO and u8("Acest meniu contine scurtaturi si comenzi rapide pentru functia de Helper.") or "This menu contains shortcuts and quick commands for the Helper role.")                  
                imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                imgui.TextWrapped(isRO and u8("Comenzile automate includ anunturi pe chat-ul evenimentului (/e).") or "Automated commands include announcements on the event chat (/e).")  
                imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ") imgui.SameLine()
                imgui.TextWrapped(isRO and u8("Atentie: Utilizarea abuziva a comenzilor de helper poate aduce neplaceri.") or "Warning: Abusive use of Helper commands may lead to penalties.")
            imgui.EndChild()
            
            imgui.Spacing()
            
            imgui.BeginChild("Helper2_LongList", imgui.ImVec2(-1, 0), true)
                local list_title = isRO and u8(">> COMENZI SI SCURTATURI <<") or ">> COMMANDS AND SHORTCUTS <<"                
                imgui.TextColored(imgui.ImVec4(1.0, 1.0, 0.0, 1.0), list_title)
                imgui.Separator()
                
                local helper_cmds = {
                    {"/stev", isRO and u8("Scurtatura la /stopevent no winner") or "Shortcut for /stopevent no winner"},
                    {"/emoticon", isRO and u8("Anunta emoticon pe /e si opreste event") or "Announce emoticon on /e and stop event"},
                    {"/aiurea", isRO and u8("Anunta aiurea pe /e si opreste event") or "Announce aiurea on /e and stop event"},
                    {"/caps", isRO and u8("Anunta CapsLock pe /e si opreste event") or "Announce CapsLock on /e and stop event"},
                    {"/hpall", isRO and u8("Ofera HP maxim tuturor de la event") or "Give max HP to all event players"},
                    {"/armourall", isRO and u8("Ofera armura maxima tuturor de la event") or "Give max armour to all event players"},
                    {"/fzall", isRO and u8("Ingheata toti jucatorii de la event") or "Freeze all event players"},
                    {"/unfzall", isRO and u8("Dezgheata toti jucatorii de la event") or "Unfreeze all event players"},
                    {"/fz <id>", isRO and u8("Ingheata un jucator anume") or "Freeze a specific player"},
                    {"/unfz <id>", isRO and u8("Dezgheata un jucator anume") or "Unfreeze a specific player"},
                    {"/wagon", isRO and u8("Spawneaza un vagon (ID 570)") or "Spawn a wagon (ID 570)"},
                    {"/es", isRO and u8("Te pune /eventsupport automat si da /join") or "Auto-sets /eventsupport and performs /join"},
                    {"/ae <id>", isRO and u8("Accepta un event (ID 570)") or "Accept an event (ID 570)"}
                }

                for _, data in ipairs(helper_cmds) do
                    imgui.TextColored(imgui.ImVec4(0.26, 0.65, 0.39, 1), ">> ")
                    imgui.SameLine()
                    imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), data[1])
                    imgui.SameLine(180)
                    imgui.TextWrapped("> " .. data[2])
                    imgui.Separator()
                end
            imgui.EndChild()
   

            elseif active_tab == 9 then
                renderThemeSettings()
                
            else
                imgui.TextWrapped(isRO and u8("Aici poti adauga optiunile specifice pentru tabul ") .. tabs[active_tab] or ("Here you can add specific options for tab " .. tabs[active_tab]))
            end
        end

    imgui.EndChild()

    imgui.End()
end)

function main()
    while not isSampAvailable() do wait(100) end
    render_font = renderCreateFont("Arial", 11, 13)

    -- [ HANDLER PENTRU HELPER DUTY ] --
sampevents.onServerMessage = function(color, text)
    local cleanText = text:gsub("{%x%x%x%x%x%x}", "")
    
    -- --- ROMANA ---
    if cleanText:find("Acum esti la datorie ca Helper.") then
        isHelperDuty = true
    elseif cleanText:find("Nu mai esti la datorie ca Helper.") then
        isHelperDuty = false
    elseif cleanText:find("Nu ai putut raspunde la timp, nu mai esti la datorie.") then
        isHelperDuty = false
        
    -- --- ENGLEZA ---
    elseif cleanText:find("You are now on duty as a Helper.") then
        isHelperDuty = true
    elseif cleanText:find("You are no longer on duty as a Helper.") then
        isHelperDuty = false
    elseif cleanText:find("You failed to respond in time, you are now off duty.") then
        isHelperDuty = false
    end
end

    sampevents.onSendCommand = function(command)
        if command:lower():match("^/sleep") then
            if isHelperDuty then
                local msg = (iniData.settings.lang == 0) and 
                    "{FF0000}[Protectie Helper]{FFFFFF} Nu poti folosi comanda {FF0000}/sleep{FFFFFF} cat timp esti {00FF00}Helper Duty{FFFFFF}!" or 
                    "{FF0000}[Helper Protection]{FFFFFF} You cannot use {FF0000}/sleep{FFFFFF} while on {00FF00}Helper Duty{FFFFFF}!"
                sampAddChatMessage(msg, -1)
                return false
            end
        end
    end

    -- [ INREGISTRARE COMANDA PRINCIPALA MIMGUI ] --
    sampRegisterChatCommand(iniData.settings.cmd, function()
        WinState[0] = not WinState[0]
    end)

    -- [ INREGISTRARE COMENZI AUTOMATE VEHICULE ] --
   for _, data in ipairs(vehiclesData) do
    local vehicleCmd = tostring(data.Name):lower():gsub("%s+", ""):gsub("-", "")

    -- Comanda de informare personala
    sampRegisterChatCommand("." .. vehicleCmd, function()
        local isRO = (iniData.settings.lang == 0)
        local msg
        if isRO then
            msg = string.format("{00ccff}Salut! {FFFFFF}Un vehicul de tip {00ccff}%s{FFFFFF} costa {33aa33}%s{FFFFFF} in Dealership si prinde {ff6347}%s{FFFFFF}.", data.Name, data.Price, data.Speed)
        else
            msg = string.format("{00ccff}Hi! {FFFFFF}A vehicle of {00ccff}%s{FFFFFF} costs {33aa33}%s{FFFFFF} in Dealership and reaches {ff6347}%s{FFFFFF}.", data.Name, data.Price, data.Speed)
        end
        sampAddChatMessage(msg, -1)
    end)

    -- Comanda de anunt pe chat-ul serverului
    sampRegisterChatCommand("an" .. vehicleCmd, function()
        local isRO = (iniData.settings.lang == 0)
        local msg
        if isRO then
            msg = string.format("/an Salut! Un vehicul de tip %s costa %s in Dealership si prinde viteza maxima de %s.", data.Name, data.Price, data.Speed)
        else
            msg = string.format("/an Hi! A vehicle of %s costs %s in Dealership and reaches a top speed of %s.", data.Name, data.Price, data.Speed)
        end
        sampSendChat(msg)
    end)
end

   -- [ INREGISTRARE COMENZI AUTOMATE CUTII (CRATES) DIN HELPERHELP ] --
for _, data in ipairs(cratesData) do
    local crateColor = data.name:match("^(%w+)")
    local cmdName = (crateColor or "unknown"):lower() .. "crate"

    local itemsShort = {}
    for _, item in ipairs(data.items) do            
        local cleanItem = item:gsub(" %- Chance:.*", "")
        table.insert(itemsShort, cleanItem) 
    end
    local itemsString = table.concat(itemsShort, ", ")

    sampRegisterChatCommand("." .. cmdName, function()
        local isRO = (iniData.settings.lang == 0)
        local msg
        if isRO then
            msg = string.format("{FFFFFF}Salut! {00ff00}%s {FFFFFF}(%s / %s) contine: {00ff00}%s.", data.name, data.priceMP, data.priceGold, itemsString)
        else
            msg = string.format("{FFFFFF}Hi! {00ff00}%s {FFFFFF}(%s / %s) contains: {00ff00}%s.", data.name, data.priceMP, data.priceGold, itemsString)
        end
        sampAddChatMessage(msg, -1)
    end)

    sampRegisterChatCommand("an" .. cmdName, function()
        local isRO = (iniData.settings.lang == 0)
        local msg
        if isRO then
            msg = string.format("/an Salut! %s (%s / %s) contine: %s.", data.name, data.priceMP, data.priceGold, itemsString)
        else
            msg = string.format("/an Hi! %s (%s / %s) contains: %s.", data.name, data.priceMP, data.priceGold, itemsString)
        end
        sampSendChat(msg)
    end)
end

    -- [ INREGISTRARE COMENZI INTERES GENERAL DIN HELPERHELP ] --
   -- Pasnice
    sampRegisterChatCommand("anapplyp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti aplica intr-o factiune pasnica intrand pe rpg.b-zone.ro daca ai minim nivel 7." 
                        or "/an Hi! You can apply for a peaceful faction by visiting rpg.b-zone.ro if you are at least level 7."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".applyp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti aplica intr-o factiune pasnica intrand pe {09ff00}rpg.b-zone.ro {FFFFFF}daca ai minim {09ff00}nivel 7." 
                        or "{09ff00}Hi! {FFFFFF}You can apply for a peaceful faction by visiting {09ff00}rpg.b-zone.ro {FFFFFF}if you are at least {09ff00}level 7."
        sampAddChatMessage(msg, -1)
    end)

    -- Mafii
    sampRegisterChatCommand("anapplym", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti aplica intr-o mafie intrand pe rpg.b-zone.ro daca ai minim nivel 25." 
                        or "/an Hi! You can apply for a mafia by visiting rpg.b-zone.ro if you are at least level 25."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".applym", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti aplica intr-o mafie intrand pe {09ff00}rpg.b-zone.ro {FFFFFF}daca ai minim {09ff00}nivel 25." 
                        or "{09ff00}Hi! {FFFFFF}You can apply for a mafia by visiting {09ff00}rpg.b-zone.ro {FFFFFF}if you are at least {09ff00}level 25."
        sampAddChatMessage(msg, -1)
    end)

        -- Departament
    sampRegisterChatCommand("anapplypd", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti aplica intr-un departament intrand pe rpg.b-zone.ro daca ai minim nivel 15 si skill 5 detectiv." 
                        or "/an Hi! You can apply for a department by visiting rpg.b-zone.ro if you are at least level 15 and have detective skill 5."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".applyd", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti aplica intr-un departament intrand pe {09ff00}rpg.b-zone.ro {FFFFFF}daca ai minim {09ff00}nivel 15 si skill 5 detectiv." 
                        or "{09ff00}Hi! {FFFFFF}You can apply for a department by visiting {09ff00}rpg.b-zone.ro {FFFFFF}if you are at least {09ff00}level 15 and detective skill 5."
        sampAddChatMessage(msg, -1)
    end)

    -- Bani
    sampRegisterChatCommand("anbani", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti face bani lucrand la joburi, /tasks, /missions, Quest, Gift, /maraton, factiuni, /reward, Jocuri de Noroc, etc." 
                        or "/an Hi! You can make money by working at jobs, /tasks, /missions, Quest, Gift, /marathon, factions, /reward, Gambling, etc."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".bani", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti face bani lucrand la {09ff00}joburi, /tasks, /missions, Quest, Gift, /maraton, factiuni, /reward, Jocuri de Noroc, etc." 
                        or "{09ff00}Hi! {FFFFFF}You can make money working at {09ff00}jobs, /tasks, /missions, Quest, Gift, /marathon, factions, /reward, Gambling, etc."
        sampAddChatMessage(msg, -1)
    end)

    -- RP (Respect Points)
    sampRegisterChatCommand("anrp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Primesti un punct de respect per payday (2 in intervalul 19-22), poti face taskurile sau deschide cutia portocalie." 
                        or "/an Hi! You receive one respect point per payday (2 between 19-22), you can do tasks or open the orange crate."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".rp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Primesti un punct de respect per {09ff00}payday (2 in intervalul 19-22){FFFFFF}, poti face {09ff00}taskurile {FFFFFF}sau deschide {09ff00}cutia portocalie." 
                        or "{09ff00}Hi! {FFFFFF}You receive one respect point per {09ff00}payday (2 between 19-22){FFFFFF}, you can do {09ff00}tasks {FFFFFF}or open the {09ff00}orange crate."
        sampAddChatMessage(msg, -1)
    end)

        -- Gold
    sampRegisterChatCommand("angold", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti obtine de pe rpg.b-zone.ro, Quest, Gift, Obiective, /buylevel, /bonus, /rewards, /goldaward si /achievements." 
                        or "/an Hi! You can get Gold from rpg.b-zone.ro, Quests, Gift, Objectives, /buylevel, /bonus, /rewards, /goldaward, and /achievements."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".gold", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti obtine de pe {09ff00}rpg.b-zone.ro, {FFFFFF}Quest, Gift, Obiective, {09ff00}/buylevel, /bonus, /rewards, /goldaward si /achievements." 
                        or "{09ff00}Hi! {FFFFFF}You can get Gold from {09ff00}rpg.b-zone.ro, {FFFFFF}Quests, Gift, Objectives, {09ff00}/buylevel, /bonus, /rewards, /goldaward and /achievements."
        sampAddChatMessage(msg, -1)
    end)

    -- Mission Points (MP)
    sampRegisterChatCommand("anmp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Poti face rost de puncte de misiune realizand misiunile din (/misiuni) sau completand taskurile din (/tasks)." 
                        or "/an Hi! You can get mission points by doing missions from (/misiuni) or completing tasks from (/tasks)."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".mp", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti face rost de puncte de misiune realizand misiunile din {09ff00}(/misiuni) {FFFFFF}sau completand taskurile din {09ff00}(/tasks)." 
                        or "{09ff00}Hi! {FFFFFF}You can get mission points by doing missions from {09ff00}(/misiuni) {FFFFFF}or completing tasks from {09ff00}(/tasks)."
        sampAddChatMessage(msg, -1)
    end)

    -- Apply Factions
    sampRegisterChatCommand("anapplyf", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/an Salut! Acceseaza rpg.b-zone.ro > Factions si apasa pe butonul 'Apply' din dreptul factiunii unde doresti sa aplici." 
                        or "/an Hi! Visit rpg.b-zone.ro > Factions and click the 'Apply' button next to the faction you want to join."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".applyf", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Acceseaza {09ff00}rpg.b-zone.ro > Factions {FFFFFF}si apasa pe butonul {09ff00}'Apply' {FFFFFF}din dreptul factiunii unde doresti sa aplici." 
                        or "{09ff00}Hi! {FFFFFF}Visit {09ff00}rpg.b-zone.ro > Factions {FFFFFF}and click the {09ff00}'Apply' {FFFFFF}button next to the faction you want to join."
        sampAddChatMessage(msg, -1)
    end)

    --     -- Skin Upgrade
    -- sampRegisterChatCommand("anskinupgrade", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a da upgrade unui skin trebuie sa mergi la /gps, Locatii Importante, Trader Shop (LV). Apesi Y, Upgrade." 
    --                     or "/an Hi! To upgrade a skin you must go to /gps, Important Locations, Trader Shop (LV). Press Y, Upgrade."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinupgrade", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a da upgrade unui skin trebuie sa mergi la {09ff00}/gps, Locatii Importante, Trader Shop (LV){FFFFFF}. Apesi {09ff00}Y, Upgrade." 
    --                     or "{09ff00}Hi! {FFFFFF}To upgrade a skin you must go to {09ff00}/gps, Important Locations, Trader Shop (LV){FFFFFF}. Press {09ff00}Y, Upgrade."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Skin Fragments
    -- sampRegisterChatCommand("anskinfragments", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Poti obtine un fragment de la Maraton, Quest, Arheolog (sansa mica la skill 8+), Evenimente Speciale, Lime Crate." 
    --                     or "/an Hi! You can get a fragment from Marathon, Quest, Archaeologist (low chance at skill 8+), Special Events, Lime Crate."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinfragments", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti obtine un fragment de la {09ff00}Maraton, Quest, Arheolog (sansa mica la skill 8+), Evenimente Speciale, Lime Crate." 
    --                     or "{09ff00}Hi! {FFFFFF}You can get a fragment from {09ff00}Marathon, Quest, Archaeologist (low chance at skill 8+), Special Events, Lime Crate."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Skin Ticket
    -- sampRegisterChatCommand("anskinticket", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Poti obtine tichete din /shop, de la Maraton, Quest, Evenimente Speciale sau din 5 fragmente la Trader LV." 
    --                     or "/an Hi! You can get tickets from /shop, Marathon, Quest, Special Events, or from 5 fragments at Trader LV."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinticket", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti obtine tichete din {09ff00}/shop, {FFFFFF}de la {09ff00}Maraton, Quest, Evenimente Speciale {FFFFFF}sau din {09ff00}5 fragmente la Trader LV." 
    --                     or "{09ff00}Hi! {FFFFFF}You can get tickets from {09ff00}/shop, {FFFFFF}Marathon, Quest, Special Events, or from {09ff00}5 fragments at Trader LV."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Skin Diamond
    -- sampRegisterChatCommand("anskindiamond", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a transforma un skin Platinum intr-un skin Diamond trebuie sa ai 1.000.000$, 100 MP si un Tichet Diamond." 
    --                     or "/an Hi! To transform a Platinum skin into a Diamond skin you need $1,000,000, 100 MP, and a Diamond Ticket."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skindiamond", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a transforma un skin Platinum intr-un skin Diamond trebuie sa ai {09ff00}1.000.000$, 100 MP si un Tichet Diamond." 
    --                     or "{09ff00}Hi! {FFFFFF}To transform a Platinum skin into a Diamond skin you need {09ff00}$1,000,000, 100 MP, and a Diamond Ticket."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --  -- Skin Silver
    -- sampRegisterChatCommand("anskinsilver", function()
    -- local isRO = (iniData.settings.lang == 0)
    -- local msg = isRO and "/an Salut! Pentru a imbunatati un skin Bronze in Silver sau Silver in Platinum ai nevoie de 500.000$, 50 MP si 1x Tichet Upgrade." 
    --                 or "/an Hi! To upgrade a Bronze skin to Silver or Silver to Platinum you need $500,000, 50 MP, and 1x Upgrade Ticket."
    -- sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinsilver", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a imbunatati un skin Bronze in Silver sau Silver in Platinum ai nevoie de {09ff00}500.000$, 50 MP si 1x Tichet Upgrade." 
    --                     or "{09ff00}Hi! {FFFFFF}To upgrade a Bronze skin to Silver or Silver to Platinum you need {09ff00}$500,000, 50 MP, and 1x Upgrade Ticket."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --   -- Skin Silver
    -- sampRegisterChatCommand("anskinplatinum", function()
    -- local isRO = (iniData.settings.lang == 0)
    -- local msg = isRO and "/an Salut! Pentru a imbunatati un skin Bronze in Silver sau Silver in Platinum ai nevoie de 500.000$, 50 MP si 1x Tichet Upgrade." 
    --                 or "/an Hi! To upgrade a Bronze skin to Silver or Silver to Platinum you need $500,000, 50 MP, and 1x Upgrade Ticket."
    -- sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinplatinum", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a imbunatati un skin Bronze in Silver sau Silver in Platinum ai nevoie de {09ff00}500.000$, 50 MP si 1x Tichet Upgrade." 
    --                     or "{09ff00}Hi! {FFFFFF}To upgrade a Bronze skin to Silver or Silver to Platinum you need {09ff00}$500,000, 50 MP, and 1x Upgrade Ticket."
    --     sampAddChatMessage(msg, -1)
    -- end)

      -- Nu detinem informatii
    sampRegisterChatCommand("cninfo", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/cn Salut! Nu detinem aceasta informatie." 
                        or "/cn Hi! We do not have this information."
        sampSendChat(msg)
    end)

    sampRegisterChatCommand(".info", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "{09ff00}Salut! {FFFFFF}Nu detinem aceasta informatie." 
                        or "{09ff00}Hi! {FFFFFF}We do not have this information."
        sampAddChatMessage(msg, -1)
    end)

    --   -- Rotiri Wheel
    -- sampRegisterChatCommand("anroata", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Poti face rost de rotiri pentru Roata Norocului din quest-uri, maraton sau evenimente speciale." 
    --                     or "/an Hi! You can earn spins for the Wheel of Fortune through quests, marathons, or special events."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".roata", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti face rost de rotiri pentru Roata Norocului din quest-uri, maraton sau evenimente speciale.." 
    --                     or "{09ff00}Hi! {FFFFFF}You can earn spins for the Wheel of Fortune through quests, marathons, or special events."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Comenzi Job Clash
    -- sampRegisterChatCommand("anjobclash", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! La Job Clash, primele 3 locuri primesc: Loc 1: $200.000, Loc 2: $100.000, Loc 3: $50.000." 
    --                     or "/an Hi! At Job Clash, the top 3 players receive: 1st: $200,000, 2nd: $100,000, 3rd: $50,000."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".jobclash", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}La Job Clash, primele 3 locuri primesc: {09ff00}Loc 1: $200.000, Loc 2: $100.000, Loc 3: $50.000." 
    --                     or "{09ff00}Hi! {FFFFFF}At Job Clash, the top 3 players receive: {09ff00}1st: $200,000, 2nd: $100,000, 3rd: $50,000."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --   -- Comenzi Mester
    -- sampRegisterChatCommand("anmester", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a inchiria instrumentele necesare la Mester trebuie sa mergi la bizul cu ID: 160." 
    --                     or "/an Hi! To rent the necessary tools at Mester you need to go to business with ID: 160."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".mester", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a inchiria instrumentele necesare la Mester trebuie sa mergi la bizul cu ID: 160." 
    --                     or "{09ff00}Hi! {FFFFFF}To rent the necessary tools at Mester you need to go to business with ID: 160."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --     -- Comenzi Spawnchange
    -- sampRegisterChatCommand("anspawn", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a schimba spawnul trebuie sa tastezi comanda /spawnchange." 
    --                     or "/an Hi! To change your spawn you need to type the command /spawnchange."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".spawn", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a schimba spawnul trebuie sa tastezi comanda /spawnchange." 
    --                     or "{09ff00}Hi! {FFFFFF}To change your spawn you need to type the command /spawnchange."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --      -- Comenzi Paintball
    -- sampRegisterChatCommand("anpaint", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a parasi arena de Paintball, foloseste comanda /leavepaintball." 
    --                     or "/an Hi! To leave the Paintball arena, use the command /leavepaintball."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".paint", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a parasi arena de Paintball, foloseste comanda /leavepaintball." 
    --                     or "{09ff00}Hi! {FFFFFF}To leave the Paintball arena, use the command /leavepaintball."
    --     sampAddChatMessage(msg, -1)
    -- end)

    --        -- Comenzi Bike
    -- sampRegisterChatCommand("anbicicleta", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Poti face rost de o bicicleta de la Dealership, Spawn LS sau Skate Park." 
    --                     or "/an Hi! You can get a bike from the Dealership, LS Spawn, or Skate Park."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".bicicleta", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Poti face rost de o bicicleta de la Dealership, Spawn LS sau Skate Park." 
    --                     or "{09ff00}Hi! {FFFFFF}You can get a bike from the Dealership, LS Spawn, or Skate Park."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- sampRegisterChatCommand(".paint", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a parasi arena de Paintball, foloseste comanda /leavepaintball." 
    --                     or "{09ff00}Hi! {FFFFFF}To leave the Paintball arena, use the command /leavepaintball."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Comenzi Job Goal
    -- sampRegisterChatCommand("anjobgoal", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! La Job Goal, jucatorii care ating 100'/. primesc aleatoriu: 5-10 Gold, 5-10 RP si $25.000-$50.000." 
    --                     or "/an Hi! At Job Goal, players who reach 100'/. randomly receive: 5-10 Gold, 5-10 RP, and $25,000-$50,000."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".jobgoal", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}La Job Goal, jucatorii care ating 100'/. primesc aleatoriu: {09ff00}5-10 Gold, 5-10 RP si $25.000-$50.000." 
    --                     or "{09ff00}Hi! {FFFFFF}At Job Goal, players who reach 100'/. randomly receive: {09ff00}5-10 Gold, 5-10 RP, and $25,000-$50,000."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Skin Onyx
    -- sampRegisterChatCommand("anskinonyx", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Pentru a transforma un skin Diamond intr-un skin Onyx trebuie sa ai 2.000.000$, 200 MP si un Tichet Onyx." 
    --                     or "/an Hi! To transform a Diamond skin into an Onyx skin you need $2,000,000, 200 MP, and an Onyx Ticket."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".skinonyx", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a transforma un skin Diamond intr-un skin Onyx trebuie sa ai {09ff00}2.000.000$, 200 MP si un Tichet Onyx." 
    --                     or "{09ff00}Hi! {FFFFFF}To transform a Diamond skin into an Onyx skin you need {09ff00}$2,000,000, 200 MP, and an Onyx Ticket."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- -- Plate
    -- sampRegisterChatCommand("anplate", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "/an Salut! Foloseste comanda [/v] > Masini, alege vehiculul dorit, dupa care alege optiunea 'Schimba placuta de inmatriculare'." 
    --                     or "/an Hi! Use the command [/v] > Cars, choose the desired vehicle, then select the 'Change license plate' option."
    --     sampSendChat(msg)
    -- end)

    -- sampRegisterChatCommand(".plate", function()
    --     local isRO = (iniData.settings.lang == 0)
    --     local msg = isRO and "{09ff00}Salut! {FFFFFF}Foloseste comanda {09ff00}[/v] > Masini{FFFFFF}, alege vehiculul dorit, dupa care alege optiunea {09ff00}'Schimba placuta de inmatriculare'." 
    --                     or "{09ff00}Hi! {FFFFFF}Use the command {09ff00}[/v] > Cars{FFFFFF}, choose the desired vehicle, then select the {09ff00}'Change license plate' {FFFFFF}option."
    --     sampAddChatMessage(msg, -1)
    -- end)

    -- sampRegisterChatCommand("anreroll", function(arg)
    --     local isRO = (iniData.settings.lang == 0)
        
    --     if #arg == 0 then
    --         local msg = isRO and "{44A564}(Helper Help) {FFFFFF}Sintaxa: /anreroll <Diamond/Onyx>" 
    --                         or "{44A564}(Helper Help) {FFFFFF}Usage: /anreroll <Diamond/Onyx>"
    --         sampAddChatMessage(msg, -1)
    --         return
    --     end

    --     if arg:lower() == "diamond" then
    --         local msg = isRO and "/an Salut! Pentru a da reroll la un skin Diamond ai nevoie de: $1,000,000, 100MP si 1 Ticket Diamond." 
    --                         or "/an Hi! To reroll a Diamond skin you need: $1,000,000, 100MP and 1 Diamond Ticket."
    --         sampSendChat(msg)
    --     elseif arg:lower() == "onyx" then
    --         local msg = isRO and "/an Salut! Pentru a da reroll la un skin Onyx ai nevoie de: $2,000,000, 200MP si 1 Ticket Onyx." 
    --                         or "/an Hi! To reroll an Onyx skin you need: $2,000,000, 200MP and 1 Onyx Ticket."
    --         sampSendChat(msg)
    --     else
    --         local msg = isRO and "{44A564}(Helper Help) {FF0000}Eroare: {FFFFFF}Parametru invalid! Alege 'Diamond' sau 'Onyx'." 
    --                         or "{44A564}(Helper Help) {FF0000}Error: {FFFFFF}Invalid parameter! Choose 'Diamond' or 'Onyx'."
    --         sampAddChatMessage(msg, -1)
    --     end
    -- end)

    -- sampRegisterChatCommand(".reroll", function(arg)
    --     local isRO = (iniData.settings.lang == 0)
        
    --     if #arg == 0 then
    --         local msg = isRO and "{44A564}(Helper Help) {FFFFFF}Sintaxa: /.reroll <Diamond/Onyx>" 
    --                         or "{44A564}(Helper Help) {FFFFFF}Usage: /.reroll <Diamond/Onyx>"
    --         sampAddChatMessage(msg, -1)
    --         return
    --     end

    --     if arg:lower() == "diamond" then
    --         local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a da reroll la un skin {09ff00}Diamond {FFFFFF}ai nevoie de: {09ff00}$1,000,000, 100MP si 1 Ticket Diamond." 
    --                         or "{09ff00}Hi! {FFFFFF}To reroll a {09ff00}Diamond {FFFFFF}skin you need: {09ff00}$1,000,000, 100MP and 1 Diamond Ticket."
    --         sampAddChatMessage(msg, -1)
    --     elseif arg:lower() == "onyx" then
    --         local msg = isRO and "{09ff00}Salut! {FFFFFF}Pentru a da reroll la un skin {09ff00}Onyx {FFFFFF}ai nevoie de: {09ff00}$2,000,000, 200MP si 1 Ticket Onyx." 
    --                         or "{09ff00}Hi! {FFFFFF}To reroll an {09ff00}Onyx {FFFFFF}skin you need: {09ff00}$2,000,000, 200MP and 1 Onyx Ticket."
    --         sampAddChatMessage(msg, -1)
    --     else
    --         local msg = isRO and "{44A564} {FF0000}Eroare: {FFFFFF}Parametru invalid!" 
    --                         or "{44A564} {FF0000}Error: {FFFFFF}Invalid parameter!"
    --         sampAddChatMessage(msg, -1)
    --     end
    -- end)

    -- [ INREGISTRARE COMENZI ADMINISTRATIVE HELPER 2 ] --
    -- Stopevent
    sampRegisterChatCommand("stev", function()
        sampSendChat("/stopevent no winner")
    end)

    -- Emoticon
    sampRegisterChatCommand("emoticon", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/e RO: Evenimentul va fi oprit din cauza emoticonului." 
                        or "/e EN: The event will be stopped due to emoticon usage."
        sampSendChat(msg)
        sampSendChat("/stopevent no winner")
    end)

    -- Aiurea
    sampRegisterChatCommand("aiurea", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/e RO: Evenimentul va fi oprit din cauza unui mesaj nepotrivit." 
                        or "/e EN: The event will be stopped due to an inappropriate message."
        sampSendChat(msg)
        sampSendChat("/stopevent no winner")
    end)

    -- CapsLock
    sampRegisterChatCommand("caps", function()
        local isRO = (iniData.settings.lang == 0)
        local msg = isRO and "/e RO: Evenimentul va fi oprit din cauza folosirii CapsLock-ului." 
                        or "/e EN: The event will be stopped due to CapsLock usage."
        sampSendChat(msg)
        sampSendChat("/stopevent no winner")
    end)
    sampRegisterChatCommand("hpall", function() sampSendChat("/sethpall 100 0") end)
    sampRegisterChatCommand("armourall", function() sampSendChat("/setarmourall 100 0") end)
    sampRegisterChatCommand("fzall", function() sampSendChat("/freezeall 0") end)
    sampRegisterChatCommand("unfzall", function() sampSendChat("/unfreezeall 0") end)
    sampRegisterChatCommand("wagon", function() sampSendChat("/veh 590 0 0") end)
    sampRegisterChatCommand("es", function() sampSendChat("/eventsupport") sampSendChat("/join") end)

    sampRegisterChatCommand("fz", function(id)
        if #id > 0 then
            sampSendChat("/freeze " .. id)
        else
            sampAddChatMessage("{00ff00}Syntax: {FFFFFF}/fz <id>", -1)
        end
    end)

     sampRegisterChatCommand("ae", function(id)
        if #id > 0 then
            sampSendChat("/accept event " .. id)
        else
            sampAddChatMessage("{00ff00}Syntax: {FFFFFF}/ae <id>", -1)
        end
    end)

    sampRegisterChatCommand("unfz", function(id)
        if #id > 0 then
            sampSendChat("/unfreeze " .. id)
        else
            sampAddChatMessage("{00ff00}Syntax: {FFFFFF}/unfz <id>", -1)
        end
    end)

    sampRegisterChatCommand("gt", function(id)
        if #id > 0 then
            sampSendChat("/gethere " .. id)
        else
            sampAddChatMessage("{00ff00}Syntax: {FFFFFF}/gt <id>", -1)
        end
    end)

    local activeKeysStr = getKeyNameById(iniData.settings.key2)
    
    local cMain = "{f54242}" 
    local cWhite = "{FFFFFF}"
    local cGray  = "{B4B4B4}"
    sampAddChatMessage(cGray .. "______________________________________________________", -1)    
    if iniData.settings.lang == 0 then
        sampAddChatMessage(string.format("%s>> %sScriptul %sHelper Help v2.5 %sa fost incarcat cu succes!", cMain, cWhite, cMain, cWhite), -1)
        sampAddChatMessage(string.format("%s>> %sFoloseste comanda %s/%s %ssau tasta %s[%s] %spentru meniu.", cMain, cWhite, cMain, iniData.settings.cmd, cWhite, cMain, activeKeysStr, cWhite), -1)
        sampAddChatMessage(string.format("%s>> %sDiscord Support: %sallecsei %s| Inspirat de la %sTupi & Madalin", cMain, cWhite, cMain, cWhite, cWhite), -1)        
    else
        sampAddChatMessage(string.format("%s>> %sScript %sHelper Help v2.5 %shas been successfully loaded!", cMain, cWhite, cMain, cWhite), -1)
        sampAddChatMessage(string.format("%s>> %sUse command %s/%s %sor key %s[%s] %sfor the menu.", cMain, cWhite, cMain, iniData.settings.cmd, cWhite, cMain, activeKeysStr, cWhite), -1)
        sampAddChatMessage(string.format("%s>> %sDiscord Support: %sallecsei %s| Inspired by %sTupi & Madalin", cMain, cWhite, cMain, cWhite, cWhite), -1)        
    end
    
    sampAddChatMessage(cGray .. "______________________________________________________", -1)

    while true do
        wait(0)

        local x = iniData.settings.hduty_x 
        local y = iniData.settings.hduty_y 

        if isHelperDuty then
            local textPrimaParte = "Helper Duty "
            local textADouaParte = "(ON)"

            renderFontDrawText(render_font, textPrimaParte, x, y, 0xFFFFB870)
            local offset = renderGetFontDrawTextLength(render_font, textPrimaParte)

            local pulse = (math.sin(os.clock() * 5) + 1) / 2
            local g = math.floor(160 + pulse * 95) 
            local pulseGreen = 0xFF000000 + g * 256  
            renderFontDrawText(render_font, textADouaParte, x + offset, y, pulseGreen)
        end

        if not sampIsChatInputActive() and not sampIsDialogActive() then
            local k2 = iniData.settings.key2

            if k2 > 0 and isKeyJustPressed(k2) then
                WinState[0] = not WinState[0]
            end
        end
    end
end

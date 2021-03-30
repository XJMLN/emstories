local blips =  {}

function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
 end
local blipData = {
   -- Posterunki
   {text="Komisariat",x=440.81,y=-982.44,z=30.69,id=60,colour=0}, -- LS
   {text="Komisariat",x=1855.8,y=3682.13,z=34.27,id=60,colour=0}, -- sandy shores
   {text="Komisariat",x=-438.79,y=6020.92,z=31.49,id=60,colour=0}, -- paleto bay
   -- Myjnie samochodowe
   {text="Myjnia Samochodowa",x=25.71,y=-1391.99,z=28.65,id=100,colour=0},
   {text="Myjnia Samochodowa",x=-699.95,y=-932.92,z=19.01,id=100,colour=0},
   -- Szpitale
   --{text="Szpital",x=340.74,y=-1395.49,z=32.51,id=61,colour=1},
   --{text="Szpital",x=1839.02,y=3673.72,z=34.28,id=61,colour=1},
   {text="Szpital",x=362.59,y=-591.22,z=27.99,id=61,colour=1},
   {text="Szpital",x=-244.39,y=6327.79,z=31.74,id=61,colour=1},
   {text="Szpital",x=1839.98,y=3671.55,z=34.28,id=61,colour=1}, -- Sandy Shores
   --Remizy
   {text="Remiza Strażacka",x=205.33,y=-1651.64,z=29.4,id=60,colour=1}, -- LS
   --Stacje Paliw
   {text="Stacja Paliw",x=-2098.12,y=-317.57,z=13.02,id=361,colour=17},
   {text="Stacja Paliw",x=-68.54,y=-1763.24,z=28.96,id=361,colour=17},
   {text="Stacja Paliw",x=176.89,y=6601.08,z=31.45,id=361,colour=17},
   {text="Stacja Paliw",x=-319.05,y=-1471.19,z=29.87,id=361,colour=17},
   {text="Stacja Paliw",x=-1437.15,y=-276.59,z=45.52,id=361,colour=17},
   {text="Stacja Paliw",x=-526.51,y=-1211.859,z=17.5,id=361,colour=17},
   {text="Stacja Paliw",x=1209.17,y=-1403.8,z=34.54,id=361,colour=17},
   {text="Stacja Paliw",x=2007.36,y=3772.46,z=31.5,id=361,colour=17},
   {text="Stacja Paliw",x=1701.69,y=6418.58,z=31.96,id=361,colour=17},
   {text="Stacja Paliw",x=-2556.6,y=2331.11,z=32.38,id=361,colour=17},
   {text="Stacja Paliw",x=49.72,y=2779.26,z=58.04,id=361,colour=17},
   {text="Stacja Paliw",x=1039.35,y=2671.71,z=38.87,id=361,colour=17},
   {text="Stacja Paliw",x=822.74,y=-1028.0,z=25.0,id=361,colour=17},
   {text="Stacja Paliw",x=182.02,y=-1555.02,z=28.0,id=361,colour=17},
   {text="Stacja Paliw",x=1783.69,y=3330.06,z=40.58,id=361,colour=17},
   {text="Stacja Paliw",x=-1799.32,y=802.12,z=138.65,id=361,colour=17},
   {text="Stacja Paliw",x=822.29,y=-1028.12,z=25.58,id=361,colour=17},
   {text="Stacja Paliw",x=266.25,y=-1263.83,z=29.14,id=361,colour=17},

  {text="Sklep z ubraniami",x=-709.79,y=-153.19,z=37.2,id=73,colour=0},
  {text="Sklep z ubraniami",x=-1193.78,y=-768.9,z=17.1,id=73,colour=0},
  {text="Sklep z ubraniami",x=-1450.43,y=-237.53,z=49.6,id=73,colour=0},
  {text="Sklep z ubraniami",x=-163.37,y=-302.84,z=39.5,id=73,colour=0},
  {text="Sklep z ubraniami",x=125.83,y=-223.46,z=54.3,id=73,colour=0},
  {text="Sklep z ubraniami",x=-1193.78,y=-768.9,z=17.1,id=73,colour=0},
  {text="Sklep z ubraniami",x=425.52,y=-806.04,z=29.49,id=73,colour=0},
  {text="Sklep z ubraniami",x=76.67,y=-1389.37,z=29.1,id=73,colour=0},
  {text="Sklep z ubraniami",x=1.21,y=6512.64,z=31.88,id=73,colour=0},
  {text="Sklep z ubraniami",x=617.69,y=2765.24,z=42.09,id=73,colour=0},
}

Citizen.CreateThread(function()
    for i,v in pairs(blipData) do
        blips[i] = AddBlipForCoord(v.x,v.y,v.z)
        SetBlipSprite(blips[i],v.id)
        SetBlipDisplay(blips[i],4)
        SetBlipColour(blips[i],tonumber(v.colour))
        SetBlipAsShortRange(blips[i], true)
        SetBlipScale(blips[i],1.0)
        
        
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(v.text))
        EndTextCommandSetBlipName(blips[i])
    end
end)


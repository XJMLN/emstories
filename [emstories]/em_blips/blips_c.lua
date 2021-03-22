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
    {text="LSPD",x=-1093.38,y=-809.1,z=19.28,id=60,colour=3},
    {text="LSCS",x=1857.1,y=3679.54,z=33.78,id=60,colour=16},
    {text="BCSD",x=-439.92,y=6019.88,z=31.49,id=60,colour=25},
    {text="Posterunek",x=621.16,y=21.8,z=88.37,id=60,colour=0},
    {text="Posterunek",x=-562.23,y=-131.2,z=38.43,id=60,colour=0},
    {text="Posterunek",x=817.75,y=-1291.07,z=26.29,id=60,colour=0},
    {text="Posterunek",x=362.15,y=-1576.76,z=30.5,id=60,colour=0},
    {text="Posterunek",x=392.6,y=789.16,z=187.67,id=60,colour=0},

    {text="Mechanik",x=-1125.36,y=-840.46,z=13.43,id=72,colour=5}, --do poprawy
    {text="Mechanik",x=536.15,y=-183.24,z=54.35,id=72,colour=5},
    {text="Mechanik",x=-205.87,y=-1309.47,z=30.89,id=72,colour=5},
    {text="Mechanik",x=2005.65,y=3798.75,z=32.18,id=72,colour=5},
   {text="Mechanik",x=1765.55,y=3337.43,z=41.42,id=72,colour=5},
   {text="Mechanik",x=-337.55,y=-135.14,z=39.1,id=72,colour=5},
   {text="Mechanik",x=2511.98,y=4138.39,z=38.58,id=72,colour=5},
   {text="Mechanik",x=2660.85,y=3273.74,z=55.24,id=72,colour=5}, -- do poprawy
   {text="Mechanik",x=109.54,y=6627.76,z=31.79,id=72,colour=5}, -- te same kordy? sprawdzic
   {text="Mechanik",x=1542.24,y=6335.07,z=24.08,id=72,colour=5},
   {text="Mechanik",x=1682.41,y=6431.38,z=32.14,id=72,colour=5},
   {text="Mechanik",x=2552.97,y=4670.39,z=33.96,id=72,colour=5},
   {text="Mechanik",x=1174.66,y=2639.14,z=37.76,id=72,colour=5},
   {text="Mechanik",x=-2166.58,y=4283.77,z=48.96,id=72,colour=5},
   {text="Mechanik",x=258.5,y=2589.91,z=44.95,id=72,colour=5},
   {text="Mechanik",x=-3170.06,y=1101.21,z=20.75,id=72,colour=5},
   {text="Mechanik",x=-1131.8,y=2699.08,z=18.8,id=72,colour=5},
   {text="Mechanik",x=1301.87,y=4321.03,z=38.26,id=72,colour=5},
   {text="Mechanik",x=2577.58,y=361.73,z=108.46,id=72,colour=5},
   {text="Mechanik",x=-83.67,y=1879.94,z=197.28,id=72,colour=5},
   {text="Mechanik",x=635.76,y=251.91,z=103.15,id=72,colour=5}, -- do poprawy
   {text="Mechanik",x=-1157.59,y=-2021.84,z=13.13,id=72,colour=5},
   {text="Mechanik",x=756.84,y=-3195.32,z=6.07,id=72,colour=5},
   {text="Mechanik",x=1832.88,y=2542.12,z=45.88,id=72,colour=5},
   {text="Mechanik",x=461.54,y=-1014.89,z=28.07,id=72,colour=5},   
   {text="Mechanik",x=481.06,y=-1317.85,z=29.2,id=72,colour=5},



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


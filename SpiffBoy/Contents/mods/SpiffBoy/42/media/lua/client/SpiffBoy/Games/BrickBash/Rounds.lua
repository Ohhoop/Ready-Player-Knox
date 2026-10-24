require"SpiffBoy/Core/Core"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local a={}
SpiffBoy.BrickBash.Rounds=a

a.COLUMNS=14
a.BACKDROPS=4
a.ROUNDS_PER_BACKDROP=4

a.KINDS={
L={cell=1,shades={3},hits=1,points=50},
S={cell=0,shades={2},hits=1,points=60},
C={cell=2,shades={2},hits=1,points=70},
R={cell=3,shades={1},hits=1,points=80},
T={cells={6,5,4},shades={1},hits=3,points=120},
X={cell=9,shades={1},hits=1,points=90,explosive=true},
M={cell=7,shineCell=8,shades={1},shineShades={1},unbreakable=true},
}

a.LIST={
{
rows={
"..............",
"LLLLLLLLLLLLLL",
"SSSSSSSSSSSSSS",
"CCCCCCCCCCCCCC",
"RRRRRRRRRRRRRR",
"LLLLLLLLLLLLLL",
},
moving={},
},
{
rows={
"......LL......",
".....LSSL.....",
"....LSCCSL....",
"...LSCRRCSL...",
"..LSCRXXRCSL..",
".LSCRRRRRRCSL.",
"LLLLLLLLLLLLLL",
},
moving={},
},
{
rows={
"TTTTTTTTTTTTTT",
"..............",
"SSSSSSSSSSSSSS",
"CCCCCCCCCCCCCC",
"LLLLLLXXLLLLLL",
"RRRRRRRRRRRRRR",
},
moving={},
},
{
rows={
"LLLLLLLLLLLLLL",
"SSSSSSSSSSSSSS",
"CCCCCCCCCCCCCC",
"MMMMM....MMMMM",
"..............",
"..RRRRXXRRRR..",
"..LLLLLLLLLL..",
},
moving={},
},
{
rows={
"TTTTTTTTTTTTTT",
"SSSSSSSSSSSSSS",
"..............",
"....LLLLLL....",
"..............",
"....CCCCCC....",
"..............",
"RRRRRRRRRRRRRR",
},
moving={4,6},
},
{
rows={
"L.L.L.L.L.L.L.",
".S.S.S.S.S.S.S",
"C.C.C.C.C.C.C.",
".R.R.R.R.R.R.R",
"T.T.T.T.T.T.T.",
".X.X.X.X.X.X.X",
"L.L.L.L.L.L.L.",
},
moving={},
},
{
rows={
"..RR......RR..",
".RLLR....RLLR.",
".RLLRRRRRRLLR.",
"RSSSSSSSSSSSSR",
"RSTTSSSSSSTTSR",
"RSSSSSCCSSSSSR",
".RSSSCCCCSSSR.",
"..RRRRRRRRRR..",
},
moving={},
},
{
rows={
"..TTTTTTTTTT..",
"..TXSSSSSSXT..",
"..TSCCCCCCST..",
"..TSCLLLLCST..",
"..TSCCCCCCST..",
"..TTTTTTTTTT..",
"..............",
"MMMM......MMMM",
},
moving={},
},
{
rows={
"L............L",
"SL..........LS",
"CSL........LSC",
"RCSL......LSCR",
"TRCSL....LSCRT",
"MTRCSL..LSCRTM",
"XMTRCSLLSCRTMX",
},
moving={},
},
{
rows={
"SSSSSSSSSSSSSS",
"S............S",
"S.XXXXXXXXXX.S",
"S.XLLLLLLLLX.S",
"S.XXXXXXXXXX.S",
"S............S",
"SSSSSS..SSSSSS",
},
moving={},
},
{
rows={
"TTTTTTTTTTTTTT",
"CCCCCCCCCCCCCC",
"..............",
"MMM...........",
"..............",
"...........MMM",
"..............",
"LLLLLLLLLLLLLL",
"SSSSSSSSSSSSSS",
},
moving={4,6},
},
{
rows={
"T.R.C.S.L.S.C.",
"T.R.C.S.L.S.C.",
"T.R.C.S.L.S.C.",
"T.R.C.X.L.S.C.",
"T.R.C.S.L.S.C.",
"T.R.C.S.L.S.C.",
"M.M.M.M.M.M.M.",
},
moving={},
},
{
rows={
"RRRRRRRRRRRRRR",
".TCCCCCCCCCCT.",
"..TSSSSSSSST..",
"...TLLXXLLT...",
"..TSSSSSSSST..",
".TCCCCCCCCCCT.",
"RRRRRRRRRRRRRR",
},
moving={},
},
{
rows={
"XLLLLLLLLLLLLX",
"..............",
"...TTTTTTTT...",
"..............",
"SSSS......SSSS",
"..............",
"...CCCCCCCC...",
"..............",
"RRRRRRXXRRRRRR",
},
moving={3,7},
},
{
rows={
"TTTTTTTTTTTTTT",
"TSSSSSSSSSSSST",
"TSTTTTTTTTTTST",
"TSTCCCCCCCCTST",
"TSTCXXXXXXCTST",
"TSTCCCCCCCCTST",
"TSTTTT..TTTTST",
},
moving={},
},
{
rows={
"M.T.T.MM.T.T.M",
"MTTTTTMMTTTTTM",
"MXSSSXMMXSSSXM",
"MSCCCSMMSCCCSM",
"MSCLCSMMSCLCSM",
"MSSSSS..SSSSSM",
"..............",
"..LLLL..LLLL..",
},
moving={8},
},
}

a.CAMPAIGN_LENGTH=#a.LIST

local f={"L","S","C","R"}
local g={low=5,high=8}
local h={low=55,high=95}
local n=100
local o=4
local p=2
local q=40
local i=6
local r=5
local s=30
local j={low=3,high=6}
local k=a.COLUMNS/2

function a.backdropOf(number)
return math.floor((number-1)/a.ROUNDS_PER_BACKDROP)%a.BACKDROPS+1
end

local function t(left)
return left..string.reverse(left)
end

local function u(kind,width)
local b=k-width
return string.rep(".",b)..string.rep(kind,width*2)..string.rep(".",b)
end

local function v(random,kind,density,tough,allowMetal)
local d={}
for e=1,k do
local b="."
if random:int(1,100)<=density then
local c=random:int(1,100)
if c<=tough then
b="T"
elseif c<=tough+i then
b="X"
elseif allowMetal and c<=tough+i+r then
b="M"
else
b=kind
end
end
d[e]=b
end
return table.concat(d)
end

function a.generate(random,number)
local w=math.min(q,o+(number-1)*p)
local c=random:int(g.low,g.high)
local d={}
local e={}
for b=1,c do
local l=f[random:int(1,#f)]
if b>1 and b<c and random:int(1,100)<=s and#e==0 then
d[b]=u(l,random:int(j.low,j.high))
e[1]=b
else
local m=b==c
local x=m and n or random:int(h.low,h.high)
d[b]=t(v(random,l,x,w,not m))
end
end
return{rows=d,moving=e}
end

function a.definition(endless,number,random)
if endless then
return a.generate(random,number)
end
return a.LIST[number]
end

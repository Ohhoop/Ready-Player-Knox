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

local g={"L","S","C","R"}
local h={low=5,high=8}
local i={low=55,high=95}
local o=100
local p=4
local q=2
local r=40
local j=6
local s=5
local t=30
local k={low=3,high=6}
local l=a.COLUMNS/2

function a.backdropOf(b)
return math.floor((b-1)/a.ROUNDS_PER_BACKDROP)%a.BACKDROPS+1
end

local function u(b)
return b..string.reverse(b)
end

local function v(d,b)
local c=l-b
return string.rep(".",c)..string.rep(d,b*2)..string.rep(".",c)
end

local function w(e,m,n,c,x)
local f={}
for y=1,l do
local b="."
if e:int(1,100)<=n then
local d=e:int(1,100)
if d<=c then
b="T"
elseif d<=c+j then
b="X"
elseif x and d<=c+j+s then
b="M"
else
b=m
end
end
f[y]=b
end
return table.concat(f)
end

function a.generate(b,x)
local y=math.min(r,p+(x-1)*q)
local d=b:int(h.low,h.high)
local e={}
local f={}
for c=1,d do
local m=g[b:int(1,#g)]
if c>1 and c<d and b:int(1,100)<=t and#f==0 then
e[c]=v(m,b:int(k.low,k.high))
f[1]=c
else
local n=c==d
local z=n and o or b:int(i.low,i.high)
e[c]=u(w(b,m,z,y,not n))
end
end
return{rows=e,moving=f}
end

function a.definition(c,b,d)
if c then
return a.generate(d,b)
end
return a.LIST[b]
end

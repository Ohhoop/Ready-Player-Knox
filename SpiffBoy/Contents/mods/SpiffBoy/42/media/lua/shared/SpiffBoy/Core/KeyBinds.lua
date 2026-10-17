require"keyBinding"
require"SpiffBoy/Core/Core"

SpiffBoy.KeyBinds=SpiffBoy.KeyBinds or{}
local a=SpiffBoy.KeyBinds

a.SECTION="[SpiffBoy]"
a.BUTTONS={"up","down","left","right","a","b","start"}
a.RESUME="resume"
a.BINDS={
up={id="SB_Up",key=Keyboard.KEY_W,movement="Forward"},
down={id="SB_Down",key=Keyboard.KEY_S,movement="Backward"},
left={id="SB_Left",key=Keyboard.KEY_A,movement="Left"},
right={id="SB_Right",key=Keyboard.KEY_D,movement="Right"},
a={id="SB_A",key=Keyboard.KEY_L},
b={id="SB_B",key=Keyboard.KEY_P},
start={id="SB_Start",key=Keyboard.KEY_SPACE},
resume={id="SB_Resume",key=Keyboard.KEY_CAPITAL},
}

local function d()
local b={}
for c=1,#a.BUTTONS do
b[c]=a.BUTTONS[c]
end
b[#b+1]=a.RESUME
return b
end

a.ORDER=d()

local function c()
table.insert(keyBinding,{value=a.SECTION})
for f,e in ipairs(a.ORDER)do
local b=a.BINDS[e]
table.insert(keyBinding,{value=b.id,key=b.key})
end
end

c()

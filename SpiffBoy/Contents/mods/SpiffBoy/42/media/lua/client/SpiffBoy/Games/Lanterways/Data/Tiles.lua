require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways

local a={}
b.Tiles=a

a.LEGEND={
["."]={walk=true,kind="grass"},
[","]={walk=true,kind="path"},
[":"]={walk=true,kind="cobble"},
["_"]={walk=true,kind="boards"},
["-"]={walk=true,kind="flags"},
["="]={walk=true,kind="lanterway"},
['"']={walk=true,kind="tallgrass"},
["*"]={walk=true,kind="flowers"},
["%"]={walk=true,kind="cave"},
[";"]={walk=true,kind="soft"},
["+"]={walk=true,kind="rug"},
["~"]={walk=false,kind="fog"},
["#"]={walk=false,kind="rock",height=16},
["T"]={walk=false,kind="tree",height=22},
["^"]={walk=false,kind="bush",height=8},
["|"]={walk=false,kind="fence",height=8},
["W"]={walk=false,kind="wall",height=20},
["o"]={walk=false,kind="boulder",height=10},
["x"]={walk=false,kind="crate",height=11},
["C"]={walk=false,kind="cocoon",height=14},
["M"]={walk=false,kind="machine",height=18},
["X"]={walk=false,kind="void"},
["b"]={walk=false,kind="shelf",height=18},
["t"]={walk=false,kind="table",height=8},
["k"]={walk=false,kind="stove",height=12},
["d"]={walk=false,kind="bed",height=6},
["c"]={walk=false,kind="counter",height=9,over=true},
["p"]={walk=false,kind="pillar",height=24},
["s"]={walk=true,kind="stairs"},
}

function a.get(c)
return a.LEGEND[c]
end

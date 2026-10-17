require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways
local a=b.Scripts

a.chapter4={
{"flag","ch4"},
{"title","Chapter4","Chapter4Sub"},
}

a.ashgrave_speech={
{"music","city"},
{"say","ashgrave","Speech1"},
{"say","ashgrave","Speech2"},
{"say","ashgrave","Speech3"},
{"say",nil,"Speech4"},
{"say","pell","Speech5"},
{"say","ashgrave","Speech6"},
{"say","ashgrave","Speech7"},
{"say","ashgrave","Speech8"},
{"say","ashgrave","Speech9"},
{"say","ines","Speech10"},
{"emote","bram","heart"},
{"music","comic"},
{"say","bram","Speech11"},
{"say","pell","Speech12"},
{"say","bram","Speech13"},
{"say","ines","Speech14"},
{"join","ines"},
{"step",11},
{"stopmusic"},
}

a.warden_fight={
{"say",nil,"Warden1"},
{"say","ines","Warden2"},
{"battle",{"vaultwarden"},{noEscape=true,music="boss"}},
{"say",nil,"Warden3"},
{"give","heartwick",1},
{"music","sad"},
{"say","ottilie","Warden4"},
{"say","pell","Warden5"},
{"say","ines","Warden6"},
{"say","ottilie","Warden7"},
{"say","ines","Warden8"},
{"step",12},
{"stopmusic"},
}

a.betrayal={
{"spawn","ashgrave","ashgrave",21,26,"up"},
{"spawn","guardA","guard",19,27,"up"},
{"spawn","guardB","guard",23,27,"up"},
{"music","tension"},
{"face","player","down"},
{"say","ashgrave","Betray1"},
{"say","pell","Betray2"},
{"say","ashgrave","Betray3"},
{"say","ashgrave","Betray4"},
{"say","ines","Betray5"},
{"say","ashgrave","Betray6"},
{"say","ines","Betray7"},
{"say","ashgrave","Betray8"},
{"take","heartwick",1},
{"fade","out",40},
{"despawn","ashgrave"},
{"despawn","guardA"},
{"despawn","guardB"},
{"music","sad"},
{"say",nil,"Betray9"},
{"say",nil,"Betray10"},
{"say","bram","Betray11"},
{"shake",40},
{"wait",50},
{"step",13},
{"heal"},
{"warp","underfog",8,28,"up"},
}

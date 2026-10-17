require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways
local a=b.Scripts

a.chapter6={
{"flag","ch6"},
{"title","Chapter6","Chapter6Sub"},
{"say",nil,"Rise1"},
{"say","nim","Rise2"},
{"say","pell","Rise3"},
}

a.marta_night={
{"emote","marta","bang"},
{"say","marta","Night1"},
{"say","marta","Night2"},
{"say","pell","Night3"},
}

a.hesk_reveal={
{"music","tension"},
{"say","hesk","Reveal1"},
{"say","pell","Reveal2"},
{"say","hesk","Reveal3"},
{"say","pell","Reveal4"},
{"say","hesk","Reveal5"},
{"say","hesk","Reveal5b"},
{"say","hesk","Reveal6"},
{"say","pell","Reveal7"},
{"say","hesk","Reveal8"},
{"battle",{"snufferveteran","hesk","snufferveteran"},{noEscape=true,music="boss"}},
{"music","home"},
{"say","hesk","Reveal9"},
{"say","hesk","Reveal10"},
{"say","hesk","Reveal10b"},
{"say","hesk","Reveal10c"},
{"give","passagescore",1},
{"say","hesk","Reveal11"},
{"say","hesk","Reveal12"},
{"flag","bellposts"},
{"spawn","marta","marta",5,8,"up"},
{"move","marta","u"},
{"say","marta","Reveal13"},
{"say","hesk","Reveal14"},
{"say","bram","Reveal15"},
{"despawn","marta"},
{"say",nil,"LearnPeal"},
{"learn","pell","peal","passingpeal"},
{"step",17},
{"stopmusic"},
}

a.chapter7={
{"flag","ch7"},
{"title","Chapter7","Chapter7Sub"},
}

a.tower_blocked={
{"say",nil,"TowerBlocked"},
{"move","player","l"},
}

a.hobb_join={
{"say","hobb","HobbJoin1"},
{"say","pell","HobbJoin2"},
{"say","hobb","HobbJoin3"},
{"say","hobb","HobbJoin4"},
{"say","nim","HobbJoin5"},
{"say","hobb","HobbJoin6"},
{"join","hobb"},
{"say","hobb","HobbJoin7"},
{"give","eartrumpet",1},
{"step",18},
}

a.verdigris_fight={
{"shake",30},
{"say",nil,"Verdi1"},
{"say","hobb","Verdi2"},
{"battle",{"verdigris"},{noEscape=true,music="boss"}},
{"say","hobb","Ring1"},
{"music","bells"},
{"shake",60},
{"say",nil,"Ring2"},
{"say",nil,"Ring3"},
{"bright","hobb"},
{"say","hush","Ring4"},
{"say","hush","HushGift"},
{"flag","hushgift"},
{"give","murkmantle",1},
{"fade","out",40},
{"step",19},
{"warp","brassmouth",36,12,"right"},
{"music","love"},
{"say","tobin","Tobin1"},
{"say","ottilie","Tobin2"},
{"say","tobin","Tobin3"},
{"say","pell","Tobin4"},
{"say","bram","Tobin5"},
{"shake",40},
{"music","tension"},
{"say",nil,"Tobin6"},
{"say","ines","Tobin7"},
{"say","hush","Tobin8"},
{"say","pell","Tobin9"},
{"stopmusic"},
}

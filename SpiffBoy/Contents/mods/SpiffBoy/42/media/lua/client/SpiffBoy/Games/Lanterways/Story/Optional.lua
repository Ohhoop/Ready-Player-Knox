require"SpiffBoy/Games/Lanterways/Base"

local e=SpiffBoy.Lanterways
local a=e.Scripts

a.marta_honey={
{"say","bram","HonQuest1"},
{"emote","marta","heart"},
{"say","marta","HonQuest2"},
{"flag","honey"},
{"give","earlybell",1},
}

a.chart_coin={
{"say","ottilie","Chart1"},
{"say",nil,"Chart2"},
{"flag","c_tide3"},
{"give","luckypenny",1},
}

a.form_backpay={
{"say","clerk","Form1"},
{"say","clerk","Form2"},
{"take","form12b",1},
{"flag","form"},
{"gold",1200},
}

a.farrow_gorse={
{"if",{flag="shared"},"shared"},
{"say","gorse","GorseKept1"},
{"say","gorse","GorseKept2"},
{"end"},
{"label","shared"},
{"say","gorse","GorseShared1"},
{"if",{flag="gorsegift"},"done"},
{"say","gorse","GorseShared2"},
{"flag","gorsegift"},
{"give","litmatch",1},
{"label","done"},
}

a.trial_pell_enter={
{"say","pell","TPell1"},
}

a.trial_pell={
{"say",nil,"TPell2"},
{"battle",{"hollowwarden"},{noEscape=true,music="boss"}},
{"say","pell","TPell3"},
{"give","dawnstaff",1},
{"trialdone","pell"},
}

a.trial_bram_enter={
{"if",{notActive="bram"},"absent"},
{"say","bram","TBram1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_bram"}},
}

a.trial_bram={
{"if",{notActive="bram"},"absent"},
{"say","bram","TBram2"},
{"battle",{"kettlewraith"},{noEscape=true,music="boss"}},
{"say","bram","TBram3"},
{"give","grandmapan",1},
{"trialdone","bram"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_bram"}},
{"move","player","d"},
}

a.trial_ottilie_enter={
{"if",{notActive="ottilie"},"absent"},
{"say","ottilie","TOtt1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_ottilie"}},
}

a.trial_ottilie={
{"if",{notActive="ottilie"},"absent"},
{"say","ottilie","TOtt2"},
{"battle",{"currenteater"},{noEscape=true,music="boss"}},
{"say","ottilie","TOtt3"},
{"give","meridian",1},
{"trialdone","ottilie"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_ottilie"}},
{"move","player","l"},
}

a.trial_ines_enter={
{"if",{notActive="ines"},"absent"},
{"say","ines","TInes1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_ines"}},
}

a.trial_ines={
{"if",{notActive="ines"},"absent"},
{"say","ines","TInes2"},
{"battle",{"firstcaptain"},{noEscape=true,music="boss"}},
{"say","ines","TInes3"},
{"give","beacon",1},
{"trialdone","ines"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_ines"}},
{"move","player","u"},
}

a.trial_hush_enter={
{"if",{notActive="hush"},"absent"},
{"say","hush","THush1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_hush"}},
}

a.trial_hush={
{"if",{notActive="hush"},"absent"},
{"say","hush","THush2"},
{"battle",{"hollowsleeper"},{noEscape=true,music="boss"}},
{"say","hush","THush3"},
{"give","murkheart",1},
{"trialdone","hush"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_hush"}},
{"move","player","r"},
}

a.trial_nim_enter={
{"if",{notActive="nim"},"absent"},
{"say","nim","TNim1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_nim"}},
}

a.trial_nim={
{"if",{notActive="nim"},"absent"},
{"say","nim","TNim2"},
{"battle",{"oldmoth"},{noEscape=true,music="boss"}},
{"spawn","wenna","wenna",12,8,"up"},
{"move","wenna","uu"},
{"say","wenna","TNim3"},
{"despawn","wenna"},
{"give","thousandnet",1},
{"trialdone","nim"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_nim"}},
{"move","player","d"},
}

a.trial_hobb_enter={
{"if",{notActive="hobb"},"absent"},
{"say","hobb","THobb1"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_hobb"}},
}

a.trial_hobb={
{"if",{notActive="hobb"},"absent"},
{"say","hobb","THobb2"},
{"battle",{"drownedbell"},{noEscape=true,music="boss"}},
{"say","hobb","THobb3"},
{"give","passagebell",1},
{"trialdone","hobb"},
{"end"},
{"label","absent"},
{"say",nil,"TrialNeed",{text="Name_hobb"}},
{"move","player","l"},
}

a.ines_sleeper={
{"if",{notActive="ines"},"plain"},
{"say",nil,"InesSleeper1"},
{"say","ines","InesSleeper2"},
{"say","ines","InesSleeper3"},
{"if",{notMember="hush"},"done"},
{"say","hush","InesSleeper4"},
{"label","done"},
{"flag","dorran"},
{"end"},
{"label","plain"},
{"say",nil,"Cocoon0"},
}

a.rootmother_fight={
{"shake",40},
{"say",nil,"Root1"},
{"battle",{"rootmother"},{noEscape=true,music="secret"}},
{"say",nil,"Root2"},
{"flag","s_root"},
{"give","dawnember",2},
}

a.leviathan_fight={
{"shake",60},
{"say",nil,"Levi1"},
{"battle",{"leviathan"},{noEscape=true,music="secret"}},
{"say",nil,"Levi2"},
{"flag","s_levi"},
{"give","sparkjar",3},
}

local b={noEscape=true,forgiving=true,music="boss",seats=3}
local c={noEscape=true,forgiving=true,music="boss",noItems=true}

local function d(f)
return{noEscape=true,forgiving=true,music="boss",onlyElement=f}
end

a.arena={
{"choice","ArenaHello",{"Rule_three","Rule_noitems","Rule_element","Cancel"},{"three","noitems","element","leave"}},
{"label","three"},
{"say",nil,"ArenaRound",1},
{"battle",{"kindledguard","glarewisp"},b,"lost"},
{"say",nil,"ArenaRound",2},
{"battle",{"lampgolem"},b,"lost"},
{"say",nil,"ArenaRound",3},
{"battle",{"ashhound","ashhound","kindledguard"},b,"lost"},
{"say",nil,"ArenaWin"},
{"if",{flag="a_three"},"paid"},
{"flag","a_three"},
{"give","sparktin",1},
{"end"},
{"label","noitems"},
{"say",nil,"ArenaRound",1},
{"battle",{"clapperimp","rustrat","belfrybat"},c,"lost"},
{"say",nil,"ArenaRound",2},
{"battle",{"driftmaw","palehound"},c,"lost"},
{"say",nil,"ArenaRound",3},
{"battle",{"lampgolem","glarewisp"},c,"lost"},
{"say",nil,"ArenaWin"},
{"if",{flag="a_noitems"},"paid"},
{"flag","a_noitems"},
{"give","dawnember",2},
{"end"},
{"label","element"},
{"say",nil,"ArenaRound",1},
{"say",nil,"ArenaElement",{text="Element_flame"}},
{"battle",{"palehound","belfrybat","rustrat"},d("flame"),"lost"},
{"say",nil,"ArenaRound",2},
{"say",nil,"ArenaElement",{text="Element_sound"}},
{"battle",{"driftmaw","lampgolem"},d("sound"),"lost"},
{"say",nil,"ArenaRound",3},
{"say",nil,"ArenaElement",{text="Element_murk"}},
{"battle",{"glarewisp","clapperimp","kindledguard"},d("murk"),"lost"},
{"say",nil,"ArenaWin"},
{"if",{flag="a_element"},"paid"},
{"flag","a_element"},
{"give","litmatch",1},
{"end"},
{"label","paid"},
{"gold",500},
{"end"},
{"label","lost"},
{"say","guard","ArenaLost"},
{"heal"},
{"end"},
{"label","leave"},
}

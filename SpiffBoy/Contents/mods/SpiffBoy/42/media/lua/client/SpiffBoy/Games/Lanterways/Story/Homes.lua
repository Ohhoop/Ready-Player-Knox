require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways
local a=b.Scripts

a.home_prune_gift={
{"say","prune","Home_wickprune1"},
{"say","prune","Home_wickprune2"},
{"give","bun",2},
{"flag","h_prune"},
}

a.home_odge_recipes={
{"say",nil,"Look_wickodge_recipes"},
{"if",{active="bram"},"bram"},
{"end"},
{"label","bram"},
{"say","bram","Home_wickodge_bram"},
}

a.home_odge_buffet={
{"if",{flag="h_odge"},"empty"},
{"say",nil,"Look_wickodge_buffet"},
{"give","stew",1},
{"flag","h_odge"},
{"end"},
{"label","empty"},
{"say",nil,"Look_wickodge_empty"},
}

a.home_cards={
{"say","fisher","Home_brassfish1"},
{"choice",nil,{"HomeCardsYes","HomeCardsNo"},{"play","pass"}},
{"label","pass"},
{"say","fisher","Home_brassfish4"},
{"end"},
{"label","play"},
{"pay",20,"broke"},
{"say","fisher","Home_brassfish2"},
{"gold",60},
{"flag","h_cards"},
{"end"},
{"label","broke"},
{"say","fisher","Home_brassfish3"},
}

a.home_widow_gift={
{"say","guardwidow","Home_glimwidow1"},
{"say","guardwidow","Home_glimwidow2"},
{"give","brassbutton",1},
{"flag","h_widow"},
}

a.home_weaver_gift={
{"say","weaver","Home_mothweaver1"},
{"say","weaver","Home_mothweaver2"},
{"give","mothjar",1},
{"flag","h_weaver"},
}

a.home_sleeper={
{"if",{min=19},"bells"},
{"say",nil,"Look_mothsleeper_cocoon"},
{"end"},
{"label","bells"},
{"say",nil,"Look_mothsleeper_bells"},
}

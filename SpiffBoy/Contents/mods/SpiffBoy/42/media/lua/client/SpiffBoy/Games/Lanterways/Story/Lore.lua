require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/MurkSea"

local d=SpiffBoy.Lanterways
local a=d.Scripts
local c=d.MurkSea.sites

for e,b in ipairs({"rive","east","coast","tide","spire"})do
a["watch_"..b]={
{"shake",30},
{"sfx","bright"},
{"say",nil,"WatchLights"},
{"say","pell","WatchLights_"..b},
}
end

a.book_found={
{"wait",20},
{"say",nil,"BookFound1"},
{"emote","player","ask"},
{"say","pell","BookFound2"},
{"flag","j_book"},
{"page","book1"},
{"say",nil,"Page_book1"},
{"say","pell","BookFound3"},
{"say",nil,"BookAdded"},
}

a.book_table={
{"say",nil,"BookTable"},
}

for e,b in ipairs({"Sunken","Survey","Farrow"})do
a["sealed_"..string.lower(b)]={
{"say","pell","Sealed"..b},
{"back"},
}
end

for e,b in ipairs({"firstflame","drownedvillage","lissleaves","twofriends","firstsnuff","onebell","braskleaves","thevote","softvoice","lastferry"})do
a["echo_"..b]={
{"echo",b},
{"fade","out",30},
{"say",nil,"EchoHeard"},
{"say",nil,"Echo_"..b.."_1"},
{"say",nil,"Echo_"..b.."_2"},
{"say",nil,"Echo_"..b.."_3"},
{"fade","in",30},
}
end

a.quest_ferryman={
{"if",{flag="l_wreck"},"found"},
{"say","ferryman","Ferry1"},
{"say","ferryman","Ferry2"},
{"flag","q_ferry1"},
{"end"},
{"label","found"},
{"say","ferryman","Ferry3"},
{"say","ferryman","Ferry4"},
{"walkoff","ferryman","ferryDock"},
{"despawn","ferryman"},
{"flag","q_ferry"},
{"refresh"},
}

a.quest_ferry_ride={
{"choice","FerryAsk",{"FerryYes","FerryNo"},{"go","stay"}},
{"label","stay"},
{"end"},
{"label","go"},
{"warp","murksea",c.farshoalLanding.x+1,c.farshoalLanding.y,"right"},
}

a.quest_ferry_back={
{"choice","FerryBackAsk",{"FerryYes","FerryNo"},{"go","stay"}},
{"label","stay"},
{"end"},
{"label","go"},
{"warp","murksea",c.ferryDock.x+1,c.ferryDock.y,"right"},
}

a.quest_wisp={
{"say","wispchild","Wisp1"},
{"say","pell","Wisp2"},
{"say","wispchild","Wisp3"},
{"walkoff","wispchild","tallowbyNorth"},
{"despawn","wispchild"},
{"flag","q_wisp1"},
{"refresh"},
}

a.quest_wisp_reward={
{"say","miller","WispThanks1"},
{"say","miller","WispThanks2"},
{"flag","q_wisp"},
{"page","book2"},
{"say",nil,"Page_book2"},
}

a.quest_courier={
{"if",{flag="p_book4"},"one"},
{"goto","ask"},
{"label","one"},
{"if",{flag="p_book7"},"both"},
{"label","ask"},
{"say","courier","Courier1"},
{"say","courier","Courier2"},
{"flag","q_courier1"},
{"end"},
{"label","both"},
{"say","courier","Courier3"},
{"flag","q_courier"},
{"page","book5"},
{"say",nil,"Page_book5"},
{"gold",120},
{"refresh"},
}

a.quest_deserter={
{"say","deserter","Deserter1"},
{"say","pell","Deserter2"},
{"say","deserter","Deserter3"},
{"choice",nil,{"DeserterHome","DeserterGo"},{"home","gone"}},
{"label","home"},
{"say","deserter","Deserter4"},
{"flag","q_deserterhome"},
{"goto","after"},
{"label","gone"},
{"say","deserter","Deserter5"},
{"flag","q_desertergone"},
{"label","after"},
{"walkoff","deserter","farrowGate"},
{"despawn","deserter"},
{"flag","q_deserter1"},
{"refresh"},
}

a.quest_cartographer={
{"if",{flag="q_carto"},"done"},
{"if",{flag="l_tide1"},"one"},
{"goto","ask"},
{"label","one"},
{"if",{flag="l_tide2"},"two"},
{"goto","ask"},
{"label","two"},
{"if",{flag="l_tide3"},"finish"},
{"label","ask"},
{"say","cartographer","Carto1"},
{"say","cartographer","Carto2"},
{"flag","q_carto1"},
{"end"},
{"label","finish"},
{"say","cartographer","Carto3"},
{"say","cartographer","Carto4"},
{"flag","q_carto"},
{"say",nil,"CartoMap"},
{"end"},
{"label","done"},
{"say","cartographer","Carto5"},
}

a.quest_merchant={
{"if",{flag="l_rocks"},"one"},
{"goto","ask"},
{"label","one"},
{"if",{flag="l_eastlanding"},"lit"},
{"label","ask"},
{"say","merchant","Merchant1"},
{"say","merchant","Merchant2"},
{"flag","q_merchant1"},
{"end"},
{"label","lit"},
{"say","merchant","Merchant3"},
{"walkoff","merchant","merchantShop"},
{"despawn","merchant"},
{"flag","q_merchant"},
{"refresh"},
}

a.shop_murksea={{"say","merchant","MerchantHello"},{"shop","murksea"}}

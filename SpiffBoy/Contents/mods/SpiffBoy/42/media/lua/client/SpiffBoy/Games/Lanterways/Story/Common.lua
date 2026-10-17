require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways
local a=b.Scripts

a.bed_rest={
{"choice","BedAsk",{"Yes","No"},{"rest","leave"}},
{"label","rest"},
{"fade","out"},
{"heal"},
{"if",{min=17,max=18,notFlag="roof"},"roof"},
{"jingle","inn"},
{"fade","in"},
{"say",nil,"BedDone"},
{"end"},
{"label","roof"},
{"night",2},
{"fade","in"},
{"say",nil,"Roof1"},
{"say","pell","Roof2"},
{"say",nil,"Roof3"},
{"flag","roof"},
{"fade","out"},
{"night",0},
{"fade","in"},
{"end"},
{"label","leave"},
}

a.inn_talk={
{"choice","InnAsk",{"Yes","No"},{"stay","leave"},"@innprice"},
{"label","stay"},
{"pay","@innprice","poor"},
{"fade","out"},
{"heal"},
{"jingle","inn"},
{"fade","in"},
{"say","innkeeper","InnMorning"},
{"end"},
{"label","poor"},
{"say","innkeeper","InnPoor"},
{"end"},
{"label","leave"},
{"say","innkeeper","InnBye"},
}

a.wenna_rest={
{"choice","WennaAsk",{"Yes","No"},{"rest","leave"}},
{"label","rest"},
{"fade","out"},
{"heal"},
{"jingle","inn"},
{"fade","in"},
{"say","wenna","WennaMorning"},
{"end"},
{"label","leave"},
{"say","wenna","WennaBye"},
}

a.bellpost={
{"say",nil,"BellpostRing"},
{"travel"},
}

a.shop_tallowby={{"say","grocer","ShopHello"},{"shop","tallowby"}}
a.shop_wick_items={{"say","grocer","ShopHello"},{"shop","wickitems"}}
a.shop_wick_gear={{"say","smith","SmithHello"},{"shop","wickgear"}}
a.shop_brass_items={{"say","grocer","ShopHello"},{"shop","brassitems"}}
a.shop_brass_arms={{"say","smith","SmithHello"},{"shop","brassarms"}}
a.shop_brass_armor={{"say","tailor","TailorHello"},{"shop","brassarmor"}}
a.shop_glimmer_items={{"say","grocer","ShopHello"},{"shop","glimmeritems"}}
a.shop_glimmer_arms={{"say","smith","SmithHello"},{"shop","glimmerarms"}}
a.shop_glimmer_armor={{"say","tailor","TailorHello"},{"shop","glimmerarmor"}}
a.shop_moth={{"say","mothfolk","MothShopHello"},{"shop","moth"}}

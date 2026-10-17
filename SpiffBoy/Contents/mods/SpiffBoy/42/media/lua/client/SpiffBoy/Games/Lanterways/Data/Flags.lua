require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways

local a={}
b.Flags=a

a.NAMES={
"ch2","ch3","ch4","ch5","ch6","ch7","ch8","shared","campfire","bellposts",
"l_spur1","l_spur2","l_spur3","l_eastgate","l_eastside","l_southgate","l_tidegate",
"l_tide1","l_tide2","l_tide3","l_tide4",
"v_tallowby","v_wickhollow","v_brassmouth","v_glimmerhold","v_mothgrove",
"c_tal1","c_spur1","c_east1","c_east2","c_east3","c_wick1","c_press1",
"c_cave1","c_cave2","c_cave3","c_cave4","c_south1","c_south2","c_south3","c_chart1",
"c_bell1","c_bell2","c_bell3","c_bell4","c_tide1","c_tide2",
"c_vault1","c_vault2","c_vault3","c_vault4","c_under1","c_under2","c_under3","c_moth1",
"c_drift1","c_drift2","c_drift3","c_spireway1",
"c_spire1","c_spire2","c_spire3","c_spire4","c_spire5","c_spire6","c_spire7","c_spire8","c_spire9","c_spire10",
"c_tide3","b_pell","b_bram","b_ottilie","b_ines","b_hush","b_nim","b_hobb",
"t_pell","t_bram","t_ottilie","t_ines","t_hush","t_nim","t_hobb",
"honey","roof","form","gorsegift","hushgift","brasknim",
"l_sunken","l_survey","l_lowervault","l_cellar","l_farrow","v_farrow",
"s_root","s_levi","a_three","a_noitems","a_element",
"c_sunken1","c_hearth1","c_survey1","c_lower1","c_still1","c_canopy1","c_cellar1","c_farrow1",
"peal","dorran",
"w_rive","w_east","w_coast","w_tide","w_spire",
"l_landing","l_stair","l_hollowrest","l_eastlanding","l_orchard","l_nutshell","l_rocks","l_harbour","l_wreck",
"l_capital","l_ashpoint","l_farshoal","l_spire1","l_spire2",
"c_u1","c_u2","c_u3","c_u4","c_u5","c_u6","c_u7","c_u8","c_u9","c_u10","c_u11","c_u12",
"p_keeper1","p_keeper2","p_keeper3","p_keeper4","p_keeper5",
"p_pottle1","p_pottle2","p_pottle3","p_pottle4",
"p_liss1","p_liss2","p_liss3","p_liss4",
"p_hesk1","p_hesk2","p_hesk3","p_hesk4",
"p_rhyme1","p_rhyme2","p_rhyme3","p_rhyme4",
"p_brask1","p_brask2","p_brask3",
"e_firstflame","e_drownedvillage","e_lissleaves","e_twofriends","e_firstsnuff",
"e_onebell","e_braskleaves","e_thevote","e_softvoice","e_lastferry",
"q_ferry1","q_ferry","q_wisp1","q_wisp","q_courier1","q_courier","q_deserter1","q_deserterhome","q_desertergone",
"q_carto1","q_carto","q_merchant1","q_merchant",
"l_spurnorth","l_spursouth","l_knoll","l_rivehill","l_mossbank","l_reedbed","l_cairn","l_lowmarsh",
"l_frostcap","l_hornet","l_lanternrock","l_gullnest","l_saltflat","l_foam","l_shoalend","l_eelrock","l_cinder","l_embercap",
"h_prune","h_odge","h_cards","h_widow","h_weaver",
"j_book","p_book1","p_book2","p_book3","p_book4","p_book5","p_book6","p_book7","p_book8","p_book9","p_book10","p_book11","p_book12",
"p_book13","p_book14","p_book15","p_book16","p_book17","p_book18","p_book19","p_book20","p_book21","p_book22","p_book23","p_book24",
"l_landing_x1","l_landing_x2","l_landing_x3","l_landing_x4","l_landing_x5","l_landing_x6","l_spur_x1","l_spur_x2",
"l_spur_x3","l_spur_x4","l_spur_x5","l_knoll_x1","l_stair_x1","l_rivehill_x1","l_lowmarsh_x1","l_hollowrest_x1",
"l_reedbed_x1","l_eastlanding_x1","l_orchard_x1","l_orchard_x2","l_orchard_x3","l_orchard_x4","l_orchard_x5","l_orchard_x6",
"l_eastside_x1","l_reach_x1","l_eastwatch_x1","l_eastwatch_x2","l_frostcap_x1","l_hornet_x1","l_rocks_x1","l_harbour_x1",
"l_harbour_x2","l_harbour_x3","l_harbour_x4","l_harbour_x5","l_harbour_x6","l_wreck_x1","l_coastwatch_x1","l_coastwatch_x2",
"l_saltflat_x1","l_tidefirst_x1","l_chartisle_x1","l_survey_x1","l_maw_x1","l_tidewatch_x1","l_tidewatch_x2","l_capital_x1",
"l_capital_x2","l_capital_x3","l_capital_x4","l_capital_x5","l_spirewatch_x1","l_spirewatch_x2","l_cinder_x1","l_spirefoot_x1",
"l_embercap_x1",
}

a.INDEX={}
for c,d in ipairs(a.NAMES)do
a.INDEX[d]=c
end

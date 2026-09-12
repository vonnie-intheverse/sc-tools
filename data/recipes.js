/* ------------------------------------------------------------------
   Wikelo recipe data — shared by every page in this repo.
   PATCH DAY: edit this file only. Both trackers pick it up.
   Bump VERIFIED whenever you re-check against live contracts.
------------------------------------------------------------------- */
const VERIFIED = "Alpha 4.10 · September 2026";

const FAVOUR="Wikelo Favor", BIT="Polaris Bit";

const ROUTES=[
  {id:"mg",      give:"MG Scrip",                               rate:50},
  {id:"council", give:"Council Scrip",                          rate:50},
  {id:"carinite",give:"Carinite",                               rate:50},
  {id:"pearl",   give:"Irradiated Valakkar Pearl (Grade AA)",   rate:12}
];
const BITRATE={give:"Quantainium (SCU)",rate:24};

const r=(n,q)=>({n,q});
const CATALOG=[
 {id:"nox",g:"Starter & ATLS",reward:"Aopoa Nox Wikelo Special",contract:"Noxy Mod",req:[r(FAVOUR,4)]},
 {id:"pulse",g:"Starter & ATLS",reward:"Mirai Pulse Wikelo Special",contract:"Pulse Plus",req:[r(FAVOUR,4)]},
 {id:"ursa",g:"Starter & ATLS",reward:"RSI Ursa Medivac Wikelo Special",contract:"Make a Ursa Mod",req:[r(FAVOUR,4),r("Saldynium Ore",20),r("Jaclium Ore",20)]},
 {id:"ikti",g:"Starter & ATLS",reward:"Argo ATLS IKTI",contract:"Make ATLS shoot",req:[r(FAVOUR,2),r("Argo ATLS",1),r("Irradiated Valakkar Fang (Apex)",5),r("NN-13 Cannon",2)]},
 {id:"geoikti",g:"Starter & ATLS",reward:"Argo ATLS GEO IKTI",contract:"Make jumpy ATLS shoot",req:[r(FAVOUR,1),r("Argo ATLS",1),r("NN-13 Cannon",2),r("Irradiated Valakkar Fang (Apex)",5),r("Quantainium (SCU)",36)]},
 {id:"snow",g:"Starter & ATLS",reward:"ATLS GEO Snowland",contract:"ATLS Snowland Color",req:[r(FAVOUR,1),r("Argo ATLS",1),r("Irradiated Valakkar Pearl (Grade AAA)",1)]},
 {id:"orange",g:"Starter & ATLS",reward:"ATLS GEO Orange Line",contract:"ATLS Orange Line",req:[r(FAVOUR,1),r("Argo ATLS",1),r("Quantainium (SCU)",36),r("Copper (SCU)",8),r("Tungsten (SCU)",8),r("Corundum (SCU)",8)]},
 {id:"coolmetal",g:"Starter & ATLS",reward:"ATLS GEO Cool Metal",contract:"ATLS Cool Metal Color",req:[r(FAVOUR,1),r("Argo ATLS",1),r("Carinite (Pure)",1)]},
 {id:"golem",g:"Starter & ATLS",reward:"Drake Golem Wikelo Work Special",contract:"Golem Rocks",req:[r(FAVOUR,2),r("ASD Secure Drive",15)]},

 {id:"intrepid",g:"Cargo, industry & utility",reward:"Crusader Intrepid Wikelo Work Special",contract:"Upgrade Intrepid",req:[r(FAVOUR,3),r("Government Cartography Agency Medal (Pristine)",1)]},
 {id:"fortune",g:"Cargo, industry & utility",reward:"MISC Fortune Wikelo Special",contract:"Fortune ship for you",req:[r(FAVOUR,3),r("Carinite (Pure)",1)]},
 {id:"c1",g:"Cargo, industry & utility",reward:"Crusader C1 Spirit Wikelo Special",contract:"Spirit Cargo mod",req:[r(FAVOUR,8),r("Tevarin War Service Marker (Pristine)",1)]},
 {id:"zeuses",g:"Cargo, industry & utility",reward:"RSI Zeus Mk II ES Wikelo Work Special",contract:"Zeus Special",req:[r(FAVOUR,10),r("UEE 6th Platoon Medal (Pristine)",1)]},
 {id:"zeuscl",g:"Cargo, industry & utility",reward:"RSI Zeus Mk II CL Wikelo Special",contract:"Zeus Cargo Special",req:[r(FAVOUR,20),r("Carinite",15),r("Ace Interceptor Helmet",10),r("Carinite (Pure)",2)]},
 {id:"max",g:"Cargo, industry & utility",reward:"MISC Starlancer MAX Wikelo Work Special",contract:"More than a Max",req:[r(FAVOUR,30),r("Ace Interceptor Helmet",10),r("Carinite (Pure)",3),r("Irradiated Valakkar Pearl (Grade AAA)",3)]},
 {id:"taurus",g:"Cargo, industry & utility",reward:"RSI Constellation Taurus Wikelo War Special",contract:"Want Taurus ship",req:[r(FAVOUR,30),r("Carinite (Pure)",3),r("Irradiated Valakkar Pearl (Grade AAA)",3),r("Government Cartography Agency Medal (Pristine)",3)]},
 {id:"raft",g:"Cargo, industry & utility",reward:"Argo RAFT Wikelo Work Special",contract:"Ready for RAFT?",req:[r(FAVOUR,8),r("Irradiated Valakkar Fang (Adult)",10),r("Irradiated Valakkar Fang (Juvenile)",20),r("Irradiated Kopion Horn",5),r("Irradiated Valakkar Pearl (Grade AAA)",1)]},
 {id:"prospector",g:"Cargo, industry & utility",reward:"MISC Prospector Wikelo Work Special",contract:"Prospects Look Good",req:[r(FAVOUR,6),r("Carinite",20),r("Saldynium Ore",30),r("Jaclium Ore",40),r("Carinite (Pure)",1)]},
 {id:"terrapin",g:"Cargo, industry & utility",reward:"Anvil Terrapin Medic Wikelo Savior Special",contract:"What is Terrapin?",req:[r(FAVOUR,15),r("ASD Secure Drive",10),r("Tevarin War Service Marker (Pristine)",1)]},
 {id:"prowler",g:"Cargo, industry & utility",reward:"Esperia Prowler Utility Wikelo Work Special",contract:"Prowler More Utility",req:[r(FAVOUR,40),r("Yormandi Tongue",10),r("Yormandi Eye",20),r("Irradiated Valakkar Pearl (Grade AAA)",3),r("Carinite (Pure)",3)]},
 {id:"apollo",g:"Cargo, industry & utility",reward:"RSI Apollo Triage Wikelo Sneak Special",contract:"Red Fight Apollo",req:[r(FAVOUR,30),r("Savrilium (SCU)",48)]},

 {id:"peregrine",g:"Fighters & combat",reward:"Aegis Sabre Peregrine Wikelo Special",contract:"Peregrine Wikelo Mod",req:[r(FAVOUR,4),r("DCHS-05 Orbital Positioning Comp-Board",1)]},
 {id:"firebird",g:"Fighters & combat",reward:"Aegis Sabre Firebird Wikelo War Special",contract:"Firebird Mod",req:[r(FAVOUR,15),r("DCHS-05 Orbital Positioning Comp-Board",4),r("Ace Interceptor Helmet",3),r("Government Cartography Agency Medal (Pristine)",1)]},
 {id:"scorpius",g:"Fighters & combat",reward:"RSI Scorpius Wikelo Sneak Special",contract:"Build a Mod Scorpius",req:[r(FAVOUR,15),r("DCHS-05 Orbital Positioning Comp-Board",4),r("Tevarin War Service Marker (Pristine)",1)]},
 {id:"f7",g:"Fighters & combat",reward:"Anvil F7 Hornet Mk Wikelo",contract:"Wikelo Navy F7",req:[r(FAVOUR,16),r("DCHS-05 Orbital Positioning Comp-Board",3),r("Ace Interceptor Helmet",5),r("Government Cartography Agency Medal (Pristine)",1)]},
 {id:"guardian",g:"Fighters & combat",reward:"Mirai Guardian Wikelo War Special",contract:"Guardian Fight Mod",req:[r(FAVOUR,20),r("Irradiated Valakkar Pearl (Grade AA)",15),r("Ace Interceptor Helmet",10),r("Tevarin War Service Marker (Pristine)",1)]},
 {id:"guardianqi",g:"Fighters & combat",reward:"Mirai Guardian QI Wikelo Special",contract:"Guardian take down ship",req:[r(FAVOUR,25),r("Irradiated Valakkar Pearl (Grade AA)",15),r("DCHS-05 Orbital Positioning Comp-Board",15),r("UEE 6th Platoon Medal (Pristine)",2)]},
 {id:"guardianmx",g:"Fighters & combat",reward:"Mirai Guardian MX Wikelo War Special",contract:"Guardian WiK-X",req:[r(FAVOUR,25),r("Vanduul Plating",30),r("Vanduul Metal",30),r("Ace Interceptor Helmet",15),r("Large Artifact Fragment (Pristine)",2)]},
 {id:"f8war",g:"Fighters & combat",reward:"Anvil F8C Lightning Wikelo War Special",contract:"F8 War Mod",req:[r(FAVOUR,40),r("Carinite (Pure)",4),r("Irradiated Valakkar Pearl (Grade AAA)",4),r("Tevarin War Service Marker (Pristine)",4)]},
 {id:"f8sneak",g:"Fighters & combat",reward:"Anvil F8C Lightning Wikelo Sneak Special",contract:"Sneaky Stabber",req:[r(FAVOUR,40),r("DCHS-05 Orbital Positioning Comp-Board",15),r("Carinite (Pure)",3),r("Irradiated Valakkar Pearl (Grade AAA)",3)]},
 {id:"inferno",g:"Fighters & combat",reward:"Crusader Ares Inferno Wikelo War Special",contract:"Starfighter Inferno Special",req:[r(FAVOUR,10),r("Yormandi Tongue",5),r("Ace Interceptor Helmet",5),r("UEE 6th Platoon Medal (Pristine)",1)]},
 {id:"ion",g:"Fighters & combat",reward:"Crusader Ares Ion Wikelo Sneak Special",contract:"Sneaky Starfighter Ion",req:[r(FAVOUR,10),r("Yormandi Eye",10),r("Ace Interceptor Helmet",5),r("Tevarin War Service Marker (Pristine)",1)]},
 {id:"meteor",g:"Fighters & combat",reward:"RSI Meteor Wikelo Sneak Special",contract:"RSI Meteor Mod",req:[r(FAVOUR,10),r("Vanduul Plating",10),r("Vanduul Metal",10),r("Ace Interceptor Helmet",5),r("Large Artifact Fragment (Pristine)",1)]},

 {id:"l21stealth",g:"Wolf & metamaterial",reward:"Kruger L-21 Wolf Stealth Special",contract:"Where Wolf? Here Wolf",req:[r(FAVOUR,10),r("Vanduul Plating",10),r("Vanduul Metal",10),r("Large Artifact Fragment (Pristine)",1)]},
 {id:"l21war",g:"Wolf & metamaterial",reward:"Kruger L-21 Wolf Wikelo War Special",contract:"Most Special Wolf",rep:"Very Good Customer",req:[r(FAVOUR,5)]},
 {id:"l22",g:"Wolf & metamaterial",reward:"Kruger L-22 Alpha Wolf Wikelo War Special",contract:"Extra Special Wolf",req:[r("Metamaterial Test #146",1)]},
 {id:"clipper",g:"Wolf & metamaterial",reward:"Drake Clipper Wikelo War Special",contract:"Clipper Fight Now",req:[r("Metamaterial Test #152",1)]},

 {id:"tac",g:"Heavy & capital",reward:"MISC Starlancer TAC Wikelo War Special",contract:"New Move Big Starlancer Ship",req:[r(FAVOUR,50),r("Ace Interceptor Helmet",15),r("ASD Secure Drive",30),r("Irradiated Valakkar Pearl (Grade AAA)",3),r("Tevarin War Service Marker (Pristine)",3),r("DCHS-05 Orbital Positioning Comp-Board",3),r("Carinite (Pure)",3)]},
 {id:"a2",g:"Heavy & capital",reward:"Crusader A2 Hercules Wikelo War Special",contract:"Starlifter A2 War Mod",req:[r(FAVOUR,50),r(BIT,20),r("MG Scrip",20),r("ASD Secure Drive",6),r("Irradiated Valakkar Pearl (Grade AAA)",6),r("Tevarin War Service Marker (Pristine)",6),r("DCHS-05 Orbital Positioning Comp-Board",6),r("Carinite (Pure)",6)]},
 {id:"asgard",g:"Heavy & capital",reward:"Anvil Asgard Wikelo War Special",contract:"Asgard Fight Mod",req:[r(FAVOUR,50),r("ASD Secure Drive",3),r("RCMBNT-PWL-1",5),r("RCMBNT-PWL-2",5),r("RCMBNT-PWL-3",5),r("RCMBNT-RGL-1",5),r("RCMBNT-RGL-2",5),r("RCMBNT-RGL-3",5),r("RCMBNT-XTL-1",5),r("RCMBNT-XTL-2",5),r("RCMBNT-XTL-3",5)]},
 {id:"polaris",g:"Heavy & capital",reward:"RSI Polaris Wikelo Special",contract:"Now make Polaris. Short Time Deal.",req:[r(FAVOUR,50),r(BIT,15),r("DCHS-05 Orbital Positioning Comp-Board",10),r("Carinite",20),r("Irradiated Valakkar Fang (Apex)",20),r("MG Scrip",20),r("Ace Interceptor Helmet",15),r("Irradiated Valakkar Pearl (Grade AAA)",15),r("UEE 6th Platoon Medal (Pristine)",15),r("Carinite (Pure)",15),r("ASD Secure Drive",15),r("RCMBNT-PWL-1",1),r("RCMBNT-PWL-2",1),r("RCMBNT-PWL-3",1),r("RCMBNT-RGL-1",1),r("RCMBNT-RGL-2",1),r("RCMBNT-RGL-3",1),r("RCMBNT-XTL-1",1),r("RCMBNT-XTL-2",1),r("RCMBNT-XTL-3",1)]},
 {id:"idris",g:"Heavy & capital",reward:"Aegis Idris-P Wikelo War Special",contract:"Special Idris For Killing",rep:"Very Best Customer",req:[r(FAVOUR,50),r(BIT,50),r("DCHS-05 Orbital Positioning Comp-Board",50),r("Carinite",50),r("Irradiated Valakkar Fang (Apex)",50),r("MG Scrip",50),r("Ace Interceptor Helmet",50),r("Irradiated Valakkar Pearl (Grade AAA)",30),r("UEE 6th Platoon Medal (Pristine)",30),r("Carinite (Pure)",30),r("ASD Secure Drive",30),r("RCMBNT-PWL-1",5),r("RCMBNT-PWL-2",5),r("RCMBNT-PWL-3",5),r("RCMBNT-RGL-1",5),r("RCMBNT-RGL-2",5),r("RCMBNT-RGL-3",5),r("RCMBNT-XTL-1",5),r("RCMBNT-XTL-2",5),r("RCMBNT-XTL-3",5)]}
];
const GROUPS=["Starter & ATLS","Cargo, industry & utility","Fighters & combat","Wolf & metamaterial","Heavy & capital"];

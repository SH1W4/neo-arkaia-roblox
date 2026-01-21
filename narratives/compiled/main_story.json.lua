return [[
{
  "inkVersion": 20,
  "root": [
    [
      "^System: NEURAL LINK ESTABLISHED.", "\n",
      "^System: SYNC RATE: 100%.", "\n",
      "^System: WELCOME TO NEO-ARK.", "\n",
      "^Você desperta em uma plataforma flutuante. O céu é um glitch roxo infinito.", "\n",
      "^Diante de você, uma figura imponente se materializa.", "\n",
      {"->": "meet_hierophant"},
      ["done",{"#f":5,"#n":"g-0"}]
    ],
    null
  ],
  "meet_hierophant": [
    "^HIEROFANTE: Sincronizador. Você finalmente acordou.", "\n",
    "^HIEROFANTE: A Malha estava instável sem você.", "\n",
    ["ev",{"^->":"meet_hierophant.0.2.$r1"},{"temp=":"$r"},"str","^Onde estou?",{"#n":"$q"},"/str","/ev",{"*":".^.c-0","flg":18},{"s":["^Onde estou?",{"->":"$r","var":true},null]}],
    ["ev",{"^->":"meet_hierophant.0.3.$r1"},{"temp=":"$r"},"str","^Quem é você?",{"#n":"$q"},"/str","/ev",{"*":".^.c-1","flg":18},{"s":["^Quem é você?",{"->":"$r","var":true},null]}],
    ["ev",{"^->":"meet_hierophant.0.4.$r1"},{"temp=":"$r"},"str","^O que devo fazer?",{"#n":"$q"},"/str","/ev",{"*":".^.c-2","flg":18},{"s":["^O que devo fazer?",{"->":"$r","var":true},null]}],
    {"c-0":["ev",{"^->":"ask_location"},"/ev",{"->":"ask_location"},{"#f":5}],"c-1":["ev",{"^->":"ask_identity"},"/ev",{"->":"ask_identity"},{"#f":5}],"c-2":["ev",{"^->":"ask_mission"},"/ev",{"->":"ask_mission"},{"#f":5}]}
  ],
  "ask_location": [
    "^HIEROFANTE: Você está no Node Central. O último bastião de ordem no caos digital.", "\n",
    "^HIEROFANTE: Todo o resto... foi consumido pelos Echos.", "\n",
    {"->": "meet_hierophant"},
    ["done",{"#f":5}]
  ],
  "ask_identity": [
    "^HIEROFANTE: Sou K-7 Chronos. O Hierofante deste setor.", "\n",
    "^HIEROFANTE: Minha função é preservar o que resta da humanidade.", "\n",
    {"->": "meet_hierophant"},
    ["done",{"#f":5}]
  ],
  "ask_mission": [
    "^HIEROFANTE: Echos estão corrompendo a estrutura de dados.", "\n",
    "^HIEROFANTE: Sua missão é simples: Cace-os. Estabilize os Nodes. Sobreviva.", "\n",
    "^HIEROFANTE: Vá até o arsenal. Fale com Kira. Ela vai te equipar.", "\n",
    "ev", "str", "^talk_to_kira", "/str", {"x()": "activate_quest"}, "pop", "\n",
    "end",
    ["done",{"#f":5}]
  ]
}
]]

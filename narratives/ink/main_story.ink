=== prologue ===
System: NEURAL LINK ESTABLISHED.
System: SYNC RATE: 100%.
System: WELCOME TO NEO-ARK.

Você desperta em uma plataforma flutuante. O céu é um glitch roxo infinito.
Diante de você, uma figura imponente se materializa.

-> meet_hierophant

=== meet_hierophant ===
HIEROFANTE: Sincronizador. Você finalmente acordou.
HIEROFANTE: A Malha estava instável sem você.

* [Onde estou?]
    -> ask_location
* [Quem é você?]
    -> ask_identity
* [O que devo fazer?]
    -> ask_mission

=== ask_location ===
HIEROFANTE: Você está no Node Central. O último bastião de ordem no caos digital.
HIEROFANTE: Todo o resto... foi consumido pelos Echos.
-> meet_hierophant

=== ask_identity ===
HIEROFANTE: Sou K-7 Chronos. O Hierofante deste setor.
HIEROFANTE: Minha função é preservar o que resta da humanidade.
-> meet_hierophant

=== ask_mission ===
HIEROFANTE: Echos estão corrompendo a estrutura de dados.
HIEROFANTE: Sua missão é simples: Cace-os. Estabilize os Nodes. Sobreviva.
HIEROFANTE: Vá até o arsenal. Fale com Kira. Ela vai te equipar.

~ activate_quest("talk_to_kira")
-> END

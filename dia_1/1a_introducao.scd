// Intro ao SuperCollider

* uma linguagem de alto nível modelada em Smalltalk
* feito para música / síntese e controle de som,
  gráficos simples
  GUIs baseadas em Qt

* comunicação por OpenSoundControl, MIDI, HID, Serial

* ca. 4-500 primitivos escritos em C ++,
   tudo o mais é escrito em 'classes'
   no código do SuperCollider

* extensível com bibliotecas escritas em SC3 - Quarks
  cerca de 200 Quarks existentes, mais outros não publicados
Quarks.gui;
(Quarks.folder +/+ "*").pathMatch.size

* muitas variantes de sintaxe suportadas
(argumentos posicionais ou de palavra-chave, notação funcional)

		The Two Worlds in SC3:

SClang			-		SCServer

(Lang, client)

texto / código  -       som
discreto        -       contínuo
números         -       sinais
dados           -       buffer
agendamento     -       envelopes
objetos         -       geradores de unidades
mensagens       -       patching

[conexão : OSC = OpenSoundControl = protocolo UDP]

pi.sin;
sin(pi);
100 div: 2;
100.div(2);
div(100, 2);
100 / 2

* coleções ricas e métodos de coleção:

[1, 2, 3].do { |el| el.postln };
[1, 2, 3] * 10;
[1, 2, 3].collect { |el, i| el * i };
( a: 1, b: 2, c: 3, d: 4).select(_.even);
(1..10).reject { |el| el % 3 == 0 };

Set[1, 2, 3, 1];


// 3 most important shortcuts:
Mac: Cmd = Linux e Windows: Ctrl
Cmd-D para documentação
Cmd-enter para avaliar o código selecionado ou a linha atual
Cmd-. (ponto) para parar o som e as tarefas em execução


2 mundos - intérprete (sclang) e servidor de áudio (scserver)

HelpBrowser.openHelpFor("Guides/ClientVsServer")


just in time programming :
JITLib - alterar processos enquanto eles já estão em execução

código como interface:

s.boot;
Pdef(\x).play;
Pdef(\x, Pbind());
Pdef(\x, Pbind(\dur, 0.5));
Pdef(\x, Pbind(\degree, Pseq([0,1,2, 4], inf), \dur, 0.5));


Pdef(\x, Pbind(\degree, Pseq((0..7)), \dur, 1/4));
Pdef(\x, Pbind(\degree, Pseq((0..7).mirror1, 2), \dur, 1/4));

Pdef(\y, Pbind(\degree, Pseq((0..7).mirror1, 8) - 7, \dur, 1/8));
Pdef(\y).play;

History.start;
History.makeWin;

Pdef(\x).stop;
Pdef(\y).stop;

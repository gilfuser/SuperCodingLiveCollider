# SynthDef

Vimos que quando usamos play em Event, como em:
().play;

Ou em uma função, como em:
{ Pulse.ar * 0.2!2 }.play; // Cmd + . para parar

Uma SynthDef é criada nas internas.

SynthDef é uma definição de Synth, que fica armazenada no servidor quando usamos o método 'add'

SynthDef( \test, { Out.ar ( 0, VarSaw.ar * 0.2 ) } ).add;

x = Synth(\test)

* tem um nome 'test'

* uma função que contém um objeto do tipo Out, que contém:
    0 é o índice do canal por onde o áudio gerado vai sair
    VarSaw gera uma onda dente-de-serra

* add: adiciona a synthdef à biblioteca onde ficam armazenadas as definições de synths, no servidor.
       nenhum defFile é gravado; todas as operações ocorrem na memória

>> TEM QUE TER: Out (ou alguma variante), para enviar seu sinal (audio se for .ar) para um 'bus' (ex. canal de audio)

* veja mais em
Out.help;

x.free

s.meter

// com um argumento:
SynthDef( \test, { arg out; Out.ar ( out, VarSaw.ar * 0.2 ) } ).add;

x = Synth(\test)

// da esquerda (0) para a direita
x.set(\out, 1)


Mudar a SynthDef depois que o Synth já foi criado não muda o som, vc tem que criar um novo Synth.
argumentos são uma maneira de mudar os parâmetros

(
SynthDef(\test, { |out, freq = 220|
    Out.ar(out, VarSaw.ar( freq!2 ) * 0.2)
}).add;
)

x.free;

// vc pode especificar o valor de um argumento ao criar o Synth
x = Synth(\test, [\freq, 110]);

// e depois mudá-lo
x.set(\freq, 55);

(
x = SynthDef(\test, { |out, freq = 220|
    Out.ar(out, VarSaw.ar( freq!2 ) * 0.2)
}).add;
)
y = x.play // pode-se tocar assim também

y.free;

x.set(\freq, 110)

x.free

note que:
| out, freq = 220 |
é o mesmo que:
arg out, freq = 220;

argumentos_comuns: out, gate, amp e freq
Têm tratamento especial, como veremos mais adiante

* veja mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/10-SynthDefs-and-Synths")

(
x = SynthDef(\test, { |out, freq = 110|
    var detune = { ExpRand(1, 1.2) };
    var myRand = {Rand(0, 1.0)};
    var sig = VarSaw.ar( freq * detune, myRand, myRand, 0.05 )!10;
    sig = Splay.ar(sig);
    Out.ar(out, sig );
}).add;
)

x.play;
x.play;
x.play;

x.free;

EI! O que aconteceu aqui? Por que só o último Synth foi liberado do servidor?

Veja a resposta a essa pergunta e como evitar que isso aconteça em:
"./2b_envelopes.scd".resolveRelative.openOS;

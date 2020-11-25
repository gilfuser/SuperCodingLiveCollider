# SynthDef

().dump

().play

default synthDef its defined in the file Event.sc

you can get there by typing...
makeDefaultSynthDef

SynthDef(\default, { arg out=0, freq=440, amp=0.1, pan=0, gate=1;
    var z;
    z = LPF.ar(
        Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3, 0.3)),
        XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
    ) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
    OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}, [\ir]).add;

SynthDef tem que ter Out ou alguma variante, para enviar seu sinal para um bus ( argumento out no exemplo acima)

(
SynthDef(\test, { |out|
    Out.ar(out, VarSaw.ar * 0.2)
}).add;
)

x = Synth(\test)

x.free

s.meter

x.set(\out, 1)

x.free

Mudar a SynthDef depois que o Synth já foi criado nao muda o som, vc tem que criar um novo Synth

(
SynthDef(\test, { |out, freq = 220|
    Out.ar(out, VarSaw.ar( freq!2 ) * 0.2)
}).add;
)

x.set(\freq, 110)

x.free

'out' será 0 se nao for definido nenhum valor para ele

add: Adiciona a synthdef à biblioteca onde ficam armazenadas as definicoes de synths, no servidor. Nenhum defFile é gravado; todas as operações ocorrem na memória.


argumentos_comuns: out, gate, amp e freq
Sao entendidos em Patterns e convertidos automaticamente quando necessário
Tidal e FoxDot também contam com eles

SynthDef.help

Mais em
"./2b_envelopes.scd".resolveRelative.openOS
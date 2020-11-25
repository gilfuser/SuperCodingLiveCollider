(
SynthDef(\semEnvelope, {
    var freq = ExpRand(88, 880);
    var som = BlitB3.ar( [ freq, freq * 1.01 ], 0.2 );
    Out.ar(0, som )
}).add
)

x = Synth(\semEnvelope);
x = Synth(\semEnvelope);
x = Synth(\semEnvelope);
x = Synth(\semEnvelope);
free(x) // só termina o último Synth iniciado
       // já que a referência para os anteriores
       // se perdeu qdo vc reatribuiu novos Synths em x


(
SynthDef(\comEnvelope, {
    var freq = ExpRand(88, 880);
    var som = BlitB3.ar( [ freq, freq * 1.01 ], 0.2 );
    var env = EnvGen.kr( Env.perc, doneAction: Done.freeSelf );
    Out.ar(0, som * env );
}).add
)

x = Synth(\comEnvelope)

EnvGen "toca" o envelope especificado em Env

Env.new.plot

Env cria o envelope, como o ADSR (attack, decay, sustain e release), mas há também outros tipos. Veja em:
Env.help

O argumento doneAction: diz qual será a acao tomada quando o envelope chegar ao fim.

Done.help

Done.freeSelf termina o Synth que a contém. vc também encontrará o integer 2 no lugar.

0 significa "não faça nada"

// Line e XLine tb sao envelopes, mas nao tem gate ou trigger
play( { SinOsc.ar( XLine.kr( 20, 20000, 20, doneAction:2 )!2, 0, 0.05) } );

// experimentar tipos de Env e diferentes parâmetros
(
~myEnv = Env.perc();
play( { [Pulse.ar, Saw.ar].choose * ~myEnv.kr(doneAction: 2) * 0.1 } );
~myEnv.plot;
)

Env.perc().plot;


Env.foo(...).kr é o mesmo que EnvGen.kr(Env.foo(...))

# gate

gate é um argumento comumente utilizado e serve para que o
Synth seja iniciado ou liberado.
O gate é aberto quando passa de um valor nao-positivo para um positivo,
e é fechado quando o contrário acontece

(
SynthDef(\gateTest, { | out, gate=0 |
    var som = Klang.ar(`[ [[64, 63], [67, 68], [72, 71]].midicps, (1/3)!3, pi!3 ], 1, 0);
    var env = EnvGen.ar(Env.asr(0.2, 1, 4), gate, doneAction: Done.freeSelf);
    Out.ar(out, som * env * 0.1)
}).add
)

x = Synth(\gateTest)

x.set(\gate, 0)

t_gate, ou t_trig "fecha" automaticamente.
Nao serve para Envs com sustain pq pode nao da tempo de chegar a amplitude em sustain
se o Synth é liberado, nao pode mais ser acessado

(
SynthDef(\gateTest, { | out, t_gate=0 |
    var som = Klang.ar(`[ [[64, 63], [67, 68], [72, 71]].midicps, (1/3)!3, pi!3 ], 1, 0);
    var env = EnvGen.ar(Env.asr(), t_gate, doneAction: Done.freeSelf);
    Out.ar(out, som * env * 0.1)
}).add
)

x = Synth(\gateTest)

x.set(\t_gate, 1)
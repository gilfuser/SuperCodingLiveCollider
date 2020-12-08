# Envelopes

Nota: lembre-se de clicar entre os parêntesis e apertar Cmd + Shift + Espaco
      sempre que tiver curiosidade quanto aos argumentos de um objeto

(
SynthDef(\semEnvelope, {
    var freq = { ExpRand(44, 440) }; // teste depois sem as chaves'{}' e perceba a diferença
    var som = BlitB3.ar( [ freq, freq * 1.01 ], 0.2 );
    Out.ar(0, som )
}).add
)

x = Synth(\semEnvelope);
x = Synth(\semEnvelope);
x = Synth(\semEnvelope);
free(x)

    // só termina o último Synth iniciado
    // já que a referência para os anteriores
    // se perdeu qdo vc reatribuiu novos Synths em x

s.freeAll;

(
SynthDef(\comEnvelope, {
    var freq = ExpRand(88, 880);
    var som = BlitB3.ar( [ freq, freq * 1.01 ], 0.2 );
    var env = EnvGen.kr( Env.perc, doneAction: Done.freeSelf ); // <<
    Out.ar(0, som * env ); // << som * env
}).add
)

x = Synth(\comEnvelope)

Agora o Synth tem começo, meio e fim

EnvGen "toca" o envelope especificado em Env

Env().plot

* Env -> cria o envelope

* o argumento doneAction: -> diz qual será a ação tomada quando o envelope chegar ao fim.

* Done.freeSelf -> termina o Synth que a contém.

Done.freeSelf == 2 // ex. EnvGen.kr( Env.perc, doneAction: 2 );
o default é 0 e significa "não faça nada"

* saiba mais em:
Done.help;

Um envelope é o desenho do som em relacao ao tempo
pode ser da amplitude, frequência ou outro atributo qualquer,
mas geralmente é usado para modular a amplitude

Um desenho comum no mundo da síntese sonora é o ADSR (attack, decay, sustain e release)
Env.adsr().plot;
mas há também outros tipos.

// este é o "desenho" da amplitude de um som percussivo
Env.perc().plot;

// teste parâmetros diferentes.
Env(levels:[0,1,0], times: [1,1], curve: 'lin').plot;
Env(levels:[0.01,1,0.01], times: [1,1], curve: 'exp').plot;
Env(levels:[0,1,0], times: [1,1], curve: [-3,3]).plot;
Env(levels:[0,1,0], times: [1,1], curve: [2,-6]).plot;
Env(levels:[0,1,0,0.5,2,0], times: [1,1,0.25,2,1], curve: [2,-6,0,'exp',5]).plot;

// experimente tipos de Env e diferentes parâmetros. Veja em Env.help
(
~myEnv = Env.perc();
play( { [Pulse.ar, Saw.ar].choose * EnvGen.kr(~myEnv, doneAction: 2 ) * 0.1 } );
~myEnv.plot;

// Line, e XLine tb são envelopes, mas não tem gate ou trigger
play( { SinOsc.ar( XLine.kr( 20, 20000, 20, doneAction:2 )!2, 0, 0.05) } );
)

************* gate **************

gate é um argumento comumente utilizado e serve para que o
Synth seja iniciado ou liberado do servidor.
O gate é aberto quando passa de um valor não-positivo para um positivo,
e é fechado quando o contrário acontece

(
SynthDef(\gateTest, { | out, gate = 0 |
    var som = Klang.ar(`[ [[64, 63], [67, 68], [72, 71]].midicps, (1/3)!3, pi!3 ], 1, 0);
    var env = EnvGen.ar(Env.asr(0.2, 1, 4), gate, doneAction: Done.freeSelf);
    Out.ar(out, som * env * 0.1)
}).add
)

x = Synth(\gateTest)
// nada ainda. arg. gate ainda é 0, o Synth não foi iniciado

x.set(\gate, 1)
// agora sim. Pare mudando de novo para 0
x.set(\gate, 0)

// esse é o desenho da amplitude
// note que o Env pára no nó após 'attackTime' // veja os argumentos com Cmd + Shift + Espaço
// até que o gate volte a ser 0
// aí o segmento 'release' acontece
Env.asr(0.2, 1, 4).plot;

t_gate, ou t_trig 'fecha' automaticamente.
Não serve para Envs com sustain.


se o Synth é liberado, não pode mais ser acessado

(
SynthDef(\gateTest, { | out, t_gate = 0 |
    var som = Klang.ar(`[ [[64, 63], [67, 68], [72, 71]].midicps, (1/3)!3, pi!3 ], 1, 0);
    var env = EnvGen.ar(Env.asr(), t_gate, doneAction: Done.freeSelf);
    Out.ar(out, som * env * 0.1)
}).add
)

x = Synth(\gateTest)

x.set(\t_gate, 1) // funciona uma única vez, pois o Synth se auto-libera do servidor qdo chega ao final

Synth(\gateTest, [\t_gate, 1]); // assim vc pode tocar várias vezes

ou (mais simples) vc pode usar t_gate = 1 na própria SynthDef

* saiba mais em:
Env.help;

Se você quer finalmente saber como testar e tocar os sons que está criando
em sequências e/ou camadas, continue por aqui:
"../dia_3/3a_routines-e-tasks.scd".resolveRelative.openOS;

Se você quer saber como fazer SynthDefs que funcionam com o FoxDot "https://foxdot.org"
por favor, por aqui:
"./2c_synthdef-foxdot.scd".resolveRelative.openOS;

Ou se o seu barato é TidalCycles "https://tidalcycles.org" e quer fazer os próprios sons, por aqui:
"./2d_synthdef-tidal.scd".resolveRelative.openOS;


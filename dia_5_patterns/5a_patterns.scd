# Patterns

Patterns definem instrucoes; Streams as executa.

// Pattern é como uma receita ou partitura
// que pode ser usada em multiplas composicoes

// Routine
Event.parentEvents.printAll

Event.partialEvents.printAll

~test = 234

x = ()
x = (x: 6, y: 7, play: { (~x * ~y).postln });
x.play; // returns 6 * 7

x.play

a = (note: 2);
b = (note: [3, 5]);
Pseq([(note: 0), ()]).play;

r = Routine{
    "isto".yield;
    "nao".yield;q
    "é".yield;
    "código".yield;
    "é".yield;
    "poesia".yield;
}

r.next;

// asStream transforma internamente a Pattern em uma Routine, portanto, herda carecterísticas da classe Stream
x = Pseq(["isto", "nao", "é", "poesia", "mas", "sim", "é", "código"]).asStream

x.next;

(
    // a array para se iterar
a = [-100, 00, 300, 400];
    // faça a Pattern e transforme-a em um Stream
p = Pseq(a).asStream;
    // faça um Stream diretamente
r = Routine({ a.do({ arg v; v.yield}) });
    // confira os valor na 'Post window'
5.do({ Post << Char.tab << r.next << " " << p.next << Char.nl; });
)

a = Routine {
    (0..).do { |i|
        i.yield;
    };
};

a.nextN(10);

a = Pseries( 0, 1, inf );

a.nextN(10);


().play

( 'instrument': default, 'amp': 0.1, 'sustain': 0.8, 'freq': 261.6255653006 )

//menor exemplo possível

Pbind().play;

CmdPeriod.run; // ou Cmd + . entre os exemplos


Pbind cria um EventStreamPlayer, basicamente um tocador de Pattern,
que por sua vez é feito de Event

(
Pbind(
    \degree, -7
).play;
)
(
Pbind(
    \degree, 3,
    \dur, 0.5
).play;
)
(
Pbind(
    \degree, -7,
    \dur, 0.5,
    \legato, 0.2
).play;
)
(
Pbind(
    \degree, Pseq([-7, -5, -2, 0, 3, 5], inf),
    \dur, 0.5,
    \legato, 0.2
).play;
)
(
Pbind(
    \degree, Pseq([-7, -5, -2, 0, 3, 5], inf),
    \dur, Prand([0.25, 1, 0.75], inf),
    \legato, 0.2
).play;
)
(
Pbind(
    \degree, Pseq([-7, -5, -2, 0, 3, 5], inf),
    \dur, Prand([0.25, 1, 0.75], inf),
    \legato, Pbrown(0.02, 2.02, 0.01, inf),
).play;
)

"../libs/_SynthLib.scd".loadRelative;

(
SynthDef('glisson', { | out = 0, freq = 800, freq2 = 1200, sustain = 0.01, amp = 0.5, pan = 0.0 |
        var window, freqEnv, som;
        window = Env.sine(sustain, amp);
        freqEnv = Env([ freq, freq2 ], [ sustain ]);
        som = SinOsc.ar(EnvGen.ar(freqEnv));
        Out.ar(out, Pan2.ar( som, pan ) * EnvGen.ar(window, doneAction: 0) )
}).add;
)

(
Ndef(\sound, { |fadeTime = 1, gate = 1|
    var e = Env.adsr(fadeTime, 0.01, 0.4, fadeTime).ar(2, gate);
    SinOsc.ar(100 + (e * 700), SinOsc.ar(208) * (1 - e) * 6) * e * 0.1
}).play
)

(
Pbind(
    \instrument, \sound,
    \midinote, ( Pseq([-7, -5, -2, 0, 3, 5], inf) + 60 ),
    \freq2, (Pseq([-7, -5, -2, 0, 3, 5], inf, 3) + 60).midicps,
    \dur, Prand([0.25, 1, 0.75], inf),
    \legato, Pbrown(0.02, 1.52, 0.01, inf),
).play;
)



// sincronizar Pbinds

Pbind(
    \degree, -7,
).play(quant: 1);//

Pbind(
    \degree, 3,
    \dur, 1/5,
    \legato, 0.3
).play(quant: 1);

Especificar a nota com \degree, \note ou \midinote
para isso o \instrument (a SynthDef) deverá conter o argumento \freq
que será automaticamente convertido

\gate é outro argumento automágico
gerenciado pela Pbind
ao usá-lo na EnvGen, dentro da sua SynthDef,
você poderá usar \legato e \sustain

outros argumentos aumágicos ainda sao
\amp, \pan, entre outros.
veja em
Pbind.help

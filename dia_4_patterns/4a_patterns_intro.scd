# Patterns

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

// "../libs/_SynthLib.scd".loadRelative;

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

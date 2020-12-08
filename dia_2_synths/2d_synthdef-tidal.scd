# SynthDefs para TidalCycles

Veja antes de mais nada a explicação sobre como preparar SynthDefs para o Tidal, muito bem feita
pelo próprio Julian Hohrruber, o criador do SuperDirt:

( Platform.userAppSupportDir ++ "/downloaded-quarks/SuperDirt/synths/tutorial-synths.scd").openDocument

Aqui entao mostrarei como transformar uma SynthDef encontrada no sccode.org
em algo que possa ser usado no Tidal.

Vejamos...
tem muita coisa! escolhi isso porque parece uma boa candidata.
nao tem muitos argumentos, boa pra livecoding:
https://sccode.org/1-4UP
copiei só a SynthDef

(
SynthDef(\risset, {|out = 0, pan = 0, freq = 400, amp = 0.1, dur = 2, gate = 1|
    var amps = #[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
    var durs = #[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
    var frqs = #[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
    var dets = #[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
    var doneActionEnv = EnvGen.ar(Env.linen(0, dur, 0), gate, doneAction: 2);
    var src = Mix.fill(11, {|i|
        var env = EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5), gate);
        SinOsc.ar(freq*frqs[i] + dets[i], 0, amp*env);
    });
    src = src * doneActionEnv * 0.5; // make sure it releases node after the end.
    Out.ar(out, Pan2.ar(src, pan));
}).add;
)

Synth(\risset); // cool!

// inicie SuperDirt para testar propriamente o que vamos fazer
SuperDirt.start;

// em relacao aos argumentos:
// IMPORTANTE: nao pode haver o argumento 'gate'. Ele é gerenciado pelo SuperDirt
// 'out' nao deve ter um valor default
// falta acrescentar sustain para aproveitar o parâmetro 'legato', do Tidal
(
SynthDef(\risset, {|out, pan, freq = 400, amp = 0.1, dur = 2, sustain = 1|
    var amps = [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
    var durs = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
    var frqs = [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
    var dets = [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
    var doneActionEnv = EnvGen.ar( Env.linen(0, dur, 0), timeScale: sustain, doneAction: Done.freeSelf );
    var src = Mix.fill(11, { |i|
        var env = EnvGen.ar(Env.perc(0.005, dur * durs[i], amps[i], -4.5), timeScale: sustain );
        SinOsc.ar( freq * frqs[i] + dets[i], 0, amp * env);
    });
    src = src * doneActionEnv * 0.5;
    // o output deve ser gerenciado pelo SuperDirt:
    OffsetOut.ar( out, DirtPan.ar(src, ~dirt.numChannels, pan, doneActionEnv) );
}).add;
)

Basicamente é só isso nesse caso.

* saiba mais em:
VideoTutorial Eris Fairbanks
https://www.youtube.com/watch?v=qZKDI8sVy8Q

obs: a Eris põe vários argumentos na SynthDef que ela cria e depois não os usa. Isso não faz sentido, viu?
Tenha na sua SynthDef só os argumentos que vai usar.

e em:
( Platform.userAppSupportDir ++ "/downloaded-quarks/SuperDirt/synths/default-synths.scd").openDocument

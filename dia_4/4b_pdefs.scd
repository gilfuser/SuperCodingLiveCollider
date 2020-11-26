/// patterns go into Pdefs to be globally accessible!
s.boot

Pdef(\test).play;

Pdef(\test,
	Pbind(
		\note, Pbrown(0, 12, 5),
		\dur, Pwrand( [1/6, 1/3], [3/4, 1/4], inf )
	)
).quant(1)

Pdef(\test).gui;

(
    SynthDef(\pet, { arg out=0, sustain=1, freq = 440;
        var sig;
        sig = RLPF.ar(
            LFSaw.ar( freq ),
            LFNoise1.kr(1, 36, 110).midicps,
            0.1
        ) * EnvGen.kr(
                Env.perc, levelScale: 0.3, timeScale: sustain, doneAction: Done.freeSelf
            );
        //out = [out, DelayN.ar(out, 0.04, 0.04) ];
        4.do({ sig = AllpassN.ar(sig, 0.05, [0.05.rand, 0.05.rand], 4)  });
        Out.ar( out, sig  );
    }).add;
)

(
SynthDef( \pet, { | out = 0, sustain = 1, freq = 440, amp = 0.1 |
    var sig, env;
    sig = LFSaw.ar( freq, 0, amp );
    sig = RLPF.ar( sig, LFNoise1.kr(1, 24, 55).midicps,  rq: 0.1 );
    env = EnvGen.kr( Env.perc(0.01, 1.0), doneAction: Done.freeSelf, timeScale:sustain );
    sig = sig * env;
    Out.ar( out, sig!2 * env)
}).add;
)

a = Synth(\pet, [\freq, 110])

a.set(\gate, 0)

CmdPeriod.run

s.quit
s.makeWindow


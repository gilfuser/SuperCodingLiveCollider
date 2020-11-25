// A ordem aqui realmente nao importa.

Ndef(\test);
			// plays, but is still empty
Ndef(\test).play;
			// place UGen in the nodeproxy
Ndef(\test, { Saw.ar(80!2) * 0.1 });
			// replace it while running
Ndef(\test, { Pulse.ar([20, 19.9], 0.1) * 0.1 });

Ndef(\test).fadeTime = 0.5;

Ndef(\test, { Pulse.ar(rrand(50!2, 200), 0.1) * 0.1 });
Ndef(\test, { Blip.ar(rrand([50, 25], 200), 5) * 0.1 });
Ndef(\test, { Blip.ar(rrand(50, 200) * 0.5, rrand(5, 15 )) * 0.2 });

Ndef(\test).rebuild; // rrand escolherá um novo número

Ndef(\test, { arg freq=40, amp = 0.3; LPF.ar(Pulse.ar([freq, freq*1.01], 0.05), 1000) * amp });

			// change values while running
Ndef(\test).set(\freq, rrand(40, 200), \amp, 0.2);

			// a task changing the values
Tdef - TaskProxy with a name is a Tdef:
(
Tdef(\noodle, {
	inf.do({
        Ndef(\test).set(\freq, 300 + 500.rand);
        // Ndef(\test).rebuild;
        1.wait
    });
}).play;
)

NdefMixer(s);
Ndef(\test).gui;


(
Tdef(\noodle, {
	inf.do({
		Ndef(\test).set(\freq, 50 + 50.rand);
		(0.1 * [1, 2, 3].choose).postln.wait;
	});
}).play;
)
Ndef(\test).stop;
Ndef(\test).play;
Ndef(\test).fadeTime = 4;

Ndef(\test, { arg freq=40, amp = 0.4; Impulse.ar(freq, 0.1) * amp });

Ndef(\test, { arg freq=40, amp = 0.1; LFSaw.ar(freq) * amp });

Ndef(\test, { arg freq=40, amp = 0.1; Pulse.ar(freq, 0.02) * amp });

Ndef(\test).end(3);

// proxies can be treated like UGens!
Ndef(\dust, { Ringz.ar(Dust.ar(10), [ 300, 400, 450], 0.2) * 0.1 });

Ndef(\rev, { CombL.ar(Ndef(\dust).ar, 0.1, 0.03, 1) });
Ndef(\rev).play;

Ndef(\rev, { CombL.ar(Ndef(\dust).ar, 0.1, [0.01, 0.03, 0.02], 5) });

Ndef(\dust).play;
Ndef(\dust).scope;
Ndef(\dust).clear;
Ndef(\rev).clear;

Ndef(\rev).stop;

Ndef(\mod, { LFNoise0.kr([3, 5]).mean });

Ndef(\x, { Blip.ar(Ndef(\mod).kr.range(50, 500), 6) }).play;

///////////////////////////////////////////////////////////////////////

Ndef(\hocuspocus).clear;
(
Ndef(\hocuspocus, { |t_trig = 0, freq = 220, amp = 0.1, sustain = 0.8, pan, lag = 0.5, devi = 0.25|
	var env = EnvGen.kr(
		Env.linen(0.1, sustain - 0.15, 0.05),
		t_trig
	);
//	var slur = Line.kr(Rand(1-devi, 1), 1, 0.2);
	var freqmod = LFNoise2.kr(6) * (devi * 0.1) + 1;

	var snd;
	freq = freq.lag(lag);

	snd = Formant.ar(
		freq // * slur
			* freqmod,
		freq,
		freq * 1.5);

	Pan2.ar(snd * env, pan, amp);
});
)
Ndef(\hocuspocus).play;


Ndef(\hocuspocus).put(2, Ndef(\hocuspocus).source);
Ndef(\hocuspocus).put(3, Ndef(\hocuspocus).source);
Ndef(\hocuspocus).put(4, Ndef(\hocuspocus).source);
Ndef(\hocuspocus).put(1, Ndef(\hocuspocus).source);

Ndef(\hocuspocus).set(\t_trig, 1, \freq, rrand(220, 400));

[-0.8, -0.4, 0, 0.4, 0.8].do { |panval, i|
	Ndef(\hocuspocus).objects[i].set(\pan, panval);
};



Ndef(\hocuspocus).get(\freq);

Ndef(\hocuspocus).set(\t_trig, 1, \freq, rrand(220, 400), \lag, 0.1);

Spec.add(\devi, [0, 1]);
Ndef(\hocuspocus).play;
Tdef(\mel).play;

Tdef(\mel, { |envir|
	var notes = [60, 61, 63, 65, 68];
	var times = 1/[1, 2, 3, 4];
	50.do { |i|
		Ndef(\hocuspocus).set(
			\t_trig, 1,
			\freq, notes.wrapAt(i).midicps
		);
		times.wrapAt(i).wait;
	};
}).play;

s.scope;

Spec.add(\wetinf, [0, 1]);
Ndef(\hocuspocus).filter(inf, { |in|
	AdCVerb.ar(in * 0.1);
});

(
Ndef(\pinpin, { |amp = 0.2|
    Ringz.ar( Impulse.ar(1!2), 220 ) * amp
}).play
);

(
Ndef(\tiririn, { |amp = 0.2|
    Ringz.ar( Impulse.ar(1!2) ) * amp
}).play
)

Ndef(\tiririn).quant = 1;
Ndef(\pinpin).quant = 1;

(
Ndef(\tiririn, { |amp = 0.2|
    Ringz.ar( Impulse.ar(2!2) ) * amp
})
);

(
Ndef(\pinpin, { |amp = 0.2|
    Ringz.ar( Impulse.ar(3!2), 220 ) * amp
})
)


Ndef(\tiririn).quant = [1, 1/4];

Ndef(\tiririn).rebuild;

//////////////////////////////////////////////////////////////////////////////

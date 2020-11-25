Tdef referencia uma Task, que por sua vez é um processo que se pode pausar

(
Tdef(\x, {
	inf.do {
		"do".postln;
		0.5.wait;
	}
}).play;
)

// different wait times
(
Tdef(\x, {
	var dt, midinote;
	inf.do {
		"wait ".post;
		dt = [0.25, 0.5].choose;
		dt.postln.wait;
	}
}).play;
)

// play random notes
(
Tdef(\x, {
	var dt, midinote;
	inf.do {
		"wait ".post;
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72);
		(midinote: midinote, dur: 0.1).play;
		dt.postln.wait;
	}
}).play;
)
// different name, new Tdef
(
Tdef(\y, {
	var dt, midinote;
	inf.do {
		"wait ".post;
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72) - 12;
		(midinote: midinote, dur: 0.1, amp: 0.5).play;
		dt.postln.wait;
	}
}).play;
)

// rename, use \right instead
// make it play double time
Tdef(\x).stop;
Tdef(\right, {
	var dt, midinote;
	inf.do {
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72);
		(midinote: midinote, dur: 0.1).play;
		(dt * 0.5).wait;
	}
}).play;

Tdef(\y).source.postcs;
Tdef(\y).stop;
Tdef(\left, Tdef(\y).source).play;

TdefAllGui();

// access Tdef within itself
Tdef(\right, {
	var dt, midinote;
	Tdef(\right).source.postcs;
	inf.do {
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72);
		(midinote: midinote, dur: 0.1).play;
		(dt * 0.5).wait;
	}
}).play;

Tdef(\master, {
	Tdef(\left).play;
	2.wait;
	Tdef(\right).play;
	4.wait;
	Tdef(\left).stop;
	2.wait;
	Tdef(\left).play;
	Tdef(\right).play;
	4.wait;
	Tdef(\left).stop;
	Tdef(\right).stop;
	1.wait;
	(midinote: [36, 47, 58, 69]).play;
});
Tdef(\master).play;

// the magic of event
// this event gets all the default values ..
().play;

// shown here
( 'instrument': default, 'msgFunc': a Function, 'amp': 0.1, 'server': localhost,
  'sustain': 0.8, 'isPlaying': true, 'freq': 261.6255653006, 'hasGate': true, 'id': [ 2302 ] )

// and changed here
( 'instrument': \default, 'amp': 0.03, 'sustain': 0.1, 'freq': 261.6255653006 * 2 ).play;

Tdef(\mel, {
	var notes = [60, 61, 63, 65, 68];
	var times = 1/[1, 2, 3, 4];
	25.do { |i|
		(
			midinote: notes.wrapAt(i),
			sustain: times.wrapAt(i)
		).play;
		times.wrapAt(i).wait;
	};
}).play;


Tdef(\mel).set(\inst, \default);

Tdef(\mel, { |envir|
	var notes = [60, 61, 63, 65, 68];
	var times = 1/[1, 2, 3, 4];
	25.do { |i|
		(
			instrument: envir[\inst].postln,
			midinote: notes.wrapAt(i),
			sustain: times.wrapAt(i)
		).play;
		times.wrapAt(i).wait;
	};
}).play;

Tdef(\mel).set(\inst, \sinx);

SynthDef(\abracadabra, { |out, freq = (60.midicps), amp = 0.1, sustain = 0.8|
	var env = Line.kr(amp, 0, sustain);
	var snd = Saw.ar(freq + [0.3, -0.3]).sum;
	Out.ar(out, snd * env);
}).add;

(instrument: \abracadabra, midinote: 62).play;
(instrument: \abracadabra, sustain: 0.03).play;
(instrument: \abracadabra, midinote: -10).play;

(instrument: \abracadabra, sustain: 4).play;


Tdef(\mel).play;
Tdef(\mel).set(\inst, \abracadabra);
Tdef(\mel).set(\inst, nil);

Tdef(\mel).set(\inst, \hocuspocus);

// magic of vibrato
SynthDef(\abracadabra, { |out, freq = (60.midicps), amp = 0.1, sustain = 0.8|
	var env = Line.ar(amp, 0, sustain, doneAction: 2);
	var freqmod = SinOsc.kr(6).range(0.97, 1.03);
	var snd = Saw.ar(freq * freqmod + [0.3, -0.3]).sum;
	Out.ar(out, snd * env);
}).add;

s.scope;
(60, 60.1 .. 60.8).collect { |num| num + 0.1.rand2 }
(midinote: (60, 60.1 .. 60.8)).play;


// amateur choir - single voice
SynthDef(\hocuspocus, { |out, freq = (60.midicps), amp = 0.1, sustain = 0.8, pan|
	var env = EnvGen.kr(
		Env.linen(0.1, sustain - 0.15, 0.02),
		doneAction: 2
	);
	var slur = Line.kr(Rand(0.8, 0.96), 1, 0.2);
	var freqmod = LFNoise2.kr(6).range(0.97, 1.03);
	var snd = Formant.ar(
		freq * slur * freqmod,
		freq,
		freq * 1.5);
	Out.ar(out,
		Pan2.ar(snd * env, pan, amp)
	);
}).add;

(instrument: \hocuspocus, midinote: (60, 60.1 .. 60.8)).play;



Tdef(\mel, { |envir|
	var notes = [60, 61, 63, 65, 68];
	var times = 1/[1, 2, 3, 4];
	25.do { |i|
		(
			instrument: envir[\inst].postln,
			midinote: notes.wrapAt(i),
			pan: (0.8, 0.4 .. -0.8),
			ctranspose: [0,0,0,-12,-12],
			sustain: times.wrapAt(i)
		).play;
		times.wrapAt(i).wait;
	};
}).play


//////////////////////////////////////////////////////////////////////////////////////

"../libs/_SynthLib.scd".loadRelative;

/// some examples for glisson:
(
Tdef(\slowPulse, {
	100.do({ arg i;
		(instrument: \glisson,
			\freq: i % 5 * 300 + 1000,
			\freq2: i % 7 * 200 + 2000,
			\amp: 0.75,
			\sustain: 0.05,
		).play;
        1.wait;
        // [1, 0.5, 0.5].choose.wait;
	});
}).play(quant: 1);
)

(
Tdef(\slow2, {
	100.do({ arg i;
		(instrument: \glisson,
			\freq: i % 5 * 100 + 200,
			\freq2: i % 7 * 200 + 500,
			\sustain: 0.01,
            \amp: 0.5
		).play;
		// (1 / (i % 12 + 10)).wait;
        1.wait;
        // [1, 0.5, 0.5].choose.wait;
	});
}).play(quant: 1);
)

(
// tief, 3:2
Tdef(\low3_2, {
	100.do({ arg i;
		(instrument: \glisson,
			\freq: i % 3 * 200 + 500,
			\freq2: i % 8 * 300 + 2500,
			\sustain: 0.01,
            \amp: 0.5
			).play;
		// (1 / (i % 12 + 10)).wait;
		0.75.wait;
	});
}).play(quant: 1);
)

(
// high Ticks
Tdef(\highTick, {
	100.do({ arg i;
		(instrument: [ \grainXLine, \grainXLRev ].choose,
			\freq: i % 20 * 200 + 4000 + 200.rand,
			\sustain: 0.005,
			\amp: 0.5,
		).play;
		 [2, 1.5, 1.25, 0.75].choose.wait;
	});
}).play(quant: 1);
)

////////////////////////////////////////////////////////////////////////////////////////////////


Tdef(\tink);
// -> shows up on gui!
(
Tdef(\tink, {
	loop {
		(instrument: \glisson).play;
		1.wait;
	};
});
)
//////// better than loop { ... }:
//////// a fixed number of repeats, so the thing stops by itself:
(
Tdef(\tink, {
	42.do {
		(instrument: \glisson).play;
		1.wait;
	};
});
)

// -> on gui, src turns green
Tdef(\tink).play;
Tdef(\tink).stop;

// -> on gui, playbutton turns green

Tdef(\tink).set(\freq, 400);
// -> on gui, env button turns green

// click on env button:
// -> document 'edit me' shows envir settings
// alt-click on env button:
// -> TdefGui tink opens and shows settings

// use freq parameter inside the Tdefs environment:

Tdef(\tink).set(\freq, 4000);

Tdef(\tink, { |envir|
	42.do {
		(instrument: \glisson,
			freq: envir.freq ).play;
		1.wait;
	};
});

// set a range for random freq values:
Tdef(\tink).set(\minfreq, 400);
Tdef(\tink).set(\maxfreq, 4000);

Tdef(\tink, { |envir|
	32.do {
		var freq = exprand(envir.minfreq, envir.maxfreq);
		(instrument: \glisson, freq: freq ).play;
		1.wait;
	};
});

////// use the random range for freq (start freq) and freq2 (end freq):
Tdef(\tink, { |envir|
	42.do {
		var freq = exprand(envir.minfreq, envir.maxfreq);
		var freq2 = exprand(envir.minfreq, envir.maxfreq);
		(instrument: \glisson,
			freq: freq,
			freq2: freq2
		).play;
		1.wait;
	};
}).play;


Tdef(\tink).set(\sustain, 0.1);
Tdef(\tink).set(\maxfreq, 4000);
////// set ranges for parameters:
Tdef(\tink).addSpec(\sustain, [0.01, 1, \exp]);
Tdef(\tink).addSpec(\minfreq, \freq);
Tdef(\tink).addSpec(\maxfreq, \freq);

Tdef(\tink, { |envir|
	13.do {
		21.do {
			var freq = exprand(envir.minfreq, envir.maxfreq);
			var freq2 = exprand(envir.minfreq, envir.maxfreq);
			(instrument: \glisson,
				freq: freq,
				freq2: freq2,
				sustain: envir.sustain
			).play;
			// 1.wait;
			envir.sustain.wait;
		};
		1.wait;
	}
});


// get rid of unused \freq
Tdef(\tink).set(\freq, nil);

Tdef(\tink).gui;

"Tdef".help
veja
"Tdef as a time pattern"
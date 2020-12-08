# JITLib

"Passageiro para motorista de táxi: leve-me ao número 37.
Eu darei a você o nome da rua quando chegarmos lá."

////////////////////////////////////////////////////////////////////////

Proxies: Just In Time Programming (ou... LiveCoding! sacou?)
 			// = marcadores de posição substituíveis

* Flexibilidade na criação de Synths e rotas de sinal
* Sintaxe simplificada
* Uso de Proxy, um marcador de espaço. Representa algo que ainda não existe.
  para coisas como:
			Synths -> Ndef (NodeProxy, ProxySpace)
 			Tasks -> Tdef
            Patterns -> Pdef

Como Proxy é um conceito tao importante para a JITLib,
aí vao algumas traducoes possíveis:

Intermediário
Substituto
Alterno
Representante
Mediador

////////////////////////////////////////////////////////////////////////

s.boot;	// o servidor precisa estar funcionando

            ****************** Ndef *************************

NodeProxy definition -> placeholder (espaço reservado) para processos de síntese.

            // A ordem aqui realmente nao importa.
Ndef(\test);

			// toca, mas ainda está vazia
Ndef(\test).play;

			// insira UGen no espaço reservado
Ndef(\test, { Saw.ar(80!2) * 0.1 });

			// substitua enquanto roda
Ndef(\test, { Pulse.ar([20, 19.9], 0.1) * 0.1 });

Ndef(\test).fadeTime = 0.5;

Ndef(\test, { Pulse.ar(exprand(50!2, 200), 0.1) * 0.1 });
Ndef(\test, { Blip.ar(exprand([50, 25], 200), 5) * 0.1 });
Ndef(\test, { Blip.ar({exprand(50, 200)}!2 * 0.5, rrand(5, 15 )) * 0.2 });

Ndef(\test).rebuild; // exprand escolherá um novo número

Ndef(\test).fadeTime = 4;

Ndef(\test).stop;
Ndef(\test).play;
Ndef(\test).release; // apaga o conteúdo no espaço reservado

(
Ndef(\test, { arg freq = 40, amp = 0.3;
    LPF.ar( Pulse.ar ( [freq, freq * 1.01], 0.05 ), 1000 ) * amp
}).play;
)
			// mude valores enquanto roda. teste várias vezes
Ndef(\test).set(\freq, exprand(40, 400), \amp, 0.2);

Ndef(\test, { arg freq=40, amp = 0.4; Impulse.ar( [freq, freq * 1.01], 0.1 ) * amp } ).play;
Ndef(\test, { arg freq=40, amp = 0.1; Saw.ar( freq!2, amp ) * amp } );
Ndef(\test, { arg freq=40, amp = 0.1; Pulse.ar( [freq, freq * 1.01], 0.02, amp) });

Ndef(\test).end(3); // fade out

// proxies podem ser usadas como UGens!

Ndef(\dust, { Ringz.ar(Dust.ar(10), [ 300, 400, 450], 0.2) * 0.1 });

// note .ar (audio rate) Ndef(\dust).ar está sendo usada como fonte de áudio
Ndef(\rev, { CombL.ar( Ndef(\dust).ar, 0.1, 0.03, 1) });
Ndef(\rev).play;

Ndef(\rev, { CombL.ar(Ndef(\dust).ar, 0.1, [0.01, 0.03, 0.02], 5) });

Ndef(\dust).play;
Ndef(\dust).scope;
Ndef(\dust).clear;
Ndef(\rev).clear;

Ndef(\rev).stop;

Ndef(\mod, { LFNoise0.kr([1, 1.5]).exprange(0.065, 1.5) });

// note o .kr (control rate) Ndef(\mod).kr está sendo usada como modulador.
Ndef(\x, { |freq = 220| Blip.ar(Ndef(\mod).kr * freq, 6, 0.1) }).play;

Ndef(\mod, { LFNoise1.kr([1, 1.5]).exprange(0.065, 1.5) });

            // Tdef preview
			// uma task muda os valores
(
Tdef(\noodle, {
	inf.do({
        Ndef(\x).set(\freq, 300 + 500.rand);
        1.wait
    });
}).play;
)

(
Tdef(\noodle, {
	inf.do({
		Ndef(\x).set(\freq, exprand(25, 250));
		(0.1 * [1, 2, 3].choose).postln.wait;
	});
}).play;
)

Tdef(\noodle).pause;

// GUIs (Interface Gráfica para Usuária) de graça para todes!
NdefMixer(s);
Ndef(\test).gui;

Ndef(\x).end(3);

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

// sincronizar
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


Ndef(\tiririn).quant = [1, 1/4]; // offset

Ndef(\tiririn).rebuild;

//////////////////////////////////////////////////////////////////////////////


            ****************** Tdef *************************

      TaskProxy com um nome é uma Tdef. a versao JITLib para Task

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
		(instrument: \simples, midinote: midinote, dur: 0.1).play;
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

///////////////////////////////////////////////////////////////////////////////

**************** um pouco mais sobre os conceitos ******************

x + y // erro

x = NodeProxy.new;
y = NodeProxy.new;

x + y // viu? -> a BinaryOpPlug. Nenhum erro. Decida quando quiser.

JITLib pode ser usado em três estilos equivalentes com certos prós e contras

// o estilo profundo.
// Em última análize os outros dois se resumem a este
NodeProxy

a = NodeProxy.new;
a.source = 5;

//
ProxySpace

p = ProxySpace.new(s);
p[\a] = 5;

ou

p.push;

~a = 5;

p.pop;

//
Def (Ndef, Tdef, Pdef, Pdefn, MFdef, etc)

Ndef(\a, 5);

saiba mais em:
HelpBrowser.openHelpFor("Tutorials/JITLib/jitlib_basic_concepts_01");
veja "NodeProxy, ProxySpace, Ndef"

Por preferência pessoal vamos usar aqui o estilo Def


* saiba mais em:
HelpBrowser.openHelpFor("Overviews/JITLib")

    // complete o pacote
    // instale isso (caso ainda nao o tenha feito):
(
if ( Quarks.isInstalled("JITLibExtensions").not )
{
    Quarks.install("JITLibExtensions");
    thisProcess.recompile;
};
)

s.boot;
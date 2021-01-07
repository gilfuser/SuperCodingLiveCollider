# JITLib

"Passageiro para motorista de táxi: leve-me ao número 37.
Eu darei a você o nome da rua quando chegarmos lá."

////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////


            ****************** Ndef *************************

Definição de NodeProxy -> placeholder (espaço reservado) para processos de síntese.

            // A ordem aqui realmente não importa.
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
Safety('localhost').stop
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

    // mapping

Ndef(\mod, {LFSaw.kr(0.25, 1).exprange(88, 880)});

Ndef(\test).map(\freq, Ndef(\mod) );
Ndef(\test).unmap(\freq)

    // fading

Ndef(\test).fadeTime = 3;

// teste algumas das versoes da Ndef(\test) acima

Ndef(\test).end(3); // fade out

// Rotas de áudio

(
Ndef(\filter, {
    MoogVCF.ar( \in.ar(0!2), \fco.kr(220, 0.2, spec: \freq.asSpec), \res.kr(1, 0.2))
}).play
) // ainda nao faz som. Precisa de um input e `in` ainda nao contém uma funcao que gere som

Ndef(\pulse, { Pulse.ar([40,121],[0.3,0.7], 0.2) });

Ndef(\filter) <<> Ndef(\pulse); // agora sim. in - é automático.

// para parâmetros nao automáticos
(
Ndef(\filter, {
    MoogVCF.ar( \in1.ar(0!2) + \in2.ar(0!2), \fco.kr(220, 0.2, spec: \freq.asSpec), \res.kr(1, 0.2))
})
)

// tem-se que definir aqui
Ndef(\filter) <<>.in1 Ndef(\pulse);

Ndef(\pulse2, { Pulse.ar( [200, 82], SinOsc.kr(0.2).range(0.01, 0.99), 0.2 ) });

Ndef(\filter) <<>.in2 Ndef(\pulse2);

//para desfazer o caminho para um input
Ndef(\filter) <<>.in1 nil;



// proxies podem ser usadas como UGens!

Ndef(\dust, { Ringz.ar( Dust.ar(10), [ 300, 400, 450], 0.2 ) * 0.1 });()

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

// Tdef -> TaskProxy
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

// GUIs (Interface Gráfica para Usuária) grátis!
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

     // Argumento e NamedControl

// Veja essa Ndef
(
Ndef(\dubba, { |att = 0.002 rel = 4.0 freq = 128.9 dur = 0.137 legato = 1 amp = 0.2 |
	var sig, frecip, trig, trig2, env;
    frecip = ( freq / 440 + 0.001 ).reciprocal;
    trig = Trig1.kr( Impulse.kr( dur.reciprocal ), dur );
    trig2 = Trig1.kr( Impulse.kr( dur.reciprocal * 0.25 ), dur );
	env = EnvGen.kr( Env( [ 0, amp, 0 ], [ att, rel - att ] * legato * dur, [ 4, -4 ] ), trig );

    sig = SinOsc.ar( ( Lag3UD.kr( trig2, frecip / 1000, frecip, freq / 440 ) ).exprange( 0.44, 440 ) * [-0.1, 0, 0.1].midiratio, 0.5pi );
    sig = sig * env;
    sig = BPeakEQ.ar( sig, LFCub.kr(0.12, 1.5pi).exprange( 61.74, 164.81 ), 0.3, 2 );
    sig = (sig * 4).tanh;
    sig = (sig * Lag3UD.kr( trig2, 0.001, LFNoise2.kr(0.06).range( 0.5, 3) ).exprange(1, LFNoise2.kr(0.1).range(3, 10) ) ).tanh;
    sig = Compander.ar( sig, sig, 0.1, 1, 1/5, 0.05, 0.2 );
    sig = BLowPass4.ar( sig, Lag3UD.kr( trig2, 0.01, 1 ).exprange(61.74, 11175.303), LFNoise2.kr(0.12).range( 0.25, 0.5 ) );
	sig = [ (sig[0] + sig[1]), (sig[1] + sig[2]) ];
	sig = LeakDC.ar(sig);
    Limiter.ar(sig);
});
);

// Alguns argumentos - entre || - aparecem uma única vez.
// Esses sao bons candidatos para o uso de NamedControl

(
Ndef(\dubba, { |att = 0.002 freq = 128.9 dur = 0.137 |
	var sig, frecip, trig, trig2, env;
    freq = freq * LFNoise0.ar(0.12).range(0.25, 2).lag(1);
    frecip = ( freq / 440 + 0.001 ).reciprocal;
    trig = Trig1.kr( Impulse.kr( dur.reciprocal ), dur );
    trig2 = Trig1.kr( Impulse.kr( dur.reciprocal * 0.25 ), dur );
	env = EnvGen.kr( Env( [ 0, \amp.kr(0.2), 0 ], [ att, \rel.kr(4) - att ] * \legato.kr(1) * dur, [ 4, -4 ] ), trig );

    sig = SinOsc.ar( ( Lag3UD.kr( trig2, frecip / 1000, frecip, freq / 440 ) ).exprange( 0.44, 440 ) * [-0.1, 0, 0.1].midiratio, 0.5pi );
	sig = sig * env;
	sig = BPeakEQ.ar( sig, LFCub.kr(0.12, 1.5pi).exprange( 61.74, 164.81 ), 0.3, 2 );
	sig = (sig * 4).tanh;
	sig = (sig * Lag3UD.kr( trig2, 0.001, LFNoise2.kr(0.06).range( 0.5, 3) ).exprange(1, LFNoise2.kr(0.1).range(3, 10) ) ).tanh;
	sig = Compander.ar( sig, sig, 0.1, 1, 1/5, 0.05, 0.2 );
	sig = BLowPass4.ar( sig, Lag3UD.kr( trig2, 0.01, 1 ).exprange(61.74, 11175.303), LFNoise2.kr(0.12).range( 0.25, 0.5 ) );
	sig = [ (sig[0] + sig[1]), (sig[1] + sig[2]) ];
	sig = LeakDC.ar(sig);
    Limiter.ar(sig);
});
)

// Viram? Vc pode especificar além do valor default: lag, fixedLag (true ou false) e spec
\legato.kr(1, 0.2, spec: [0.1, 100, \exp]); // NOTA: spec nao está funcionando em NamedControl no momento (06/jan/2021).
// aqui "pulamos" fixedLag, por isso spec: tem que estar assim explícito

Ndef(\dubba).gui;

// O SC vai tentar adivinhar os valores mínimo e máximo dos parâmetros e a curva entre eles.
// Para se definir isso há duas formas. Uma é fazê-lo apenas para a Ndef (ou NodeProxy) e outra geral
Ndef(\dubba).addSpec(\legato, [0.1, 100, \exp]);

// cria uma Spec (especificacao de tipo de dado)

Spec.add(\legato, [0.08, 80, \exp]);

// veja as Specs que já existem em
HelpBrowser.openHelpFor("Classes/Spec");


// nao se pode fazer nenhum tipo de cálculo no valor do parâmetro. Algo como

Ndef(\test, { arg amp = 0.1 + 0.01; { Saw.ar([110, 111], mul: amp) } }) // ERRO!
// ou muito menos assim
Ndef(\test, { arg amp = 0.1; { Saw.ar([110, 111], mul: amp) } }) // ERRO!

// MAS Isso é permitido
Ndef(\test, { { Saw.ar([110, 111], mul: \amp.kr(0.1 + 0.01 ) ) } });


// se você cria uma Ndef com uma certa quantidade de canais
Ndef(\test, { Saw.ar( 110, mul: \amp.kr(0.1)) }).play; // toca somente no canal esquerdo ( OutputBus 0)

// e depois resolve mudar e acrescentar mais canais. fazer com que seja stereo, por exemplo
Ndef(\test, { Saw.ar( [110, 112], mul: \amp.kr(0.1)) });

// vai receber um aviso assim:
Ndef('test'): wrapped channels from 2 to 1 channels

// para que a Ndef se ajuste a quantos canais vc resolver criar é assim

// isso é para comecar do zero
Ndef('test').clear;

// crie a Ndef usando o método mold e seu argumento argReshaping na opcao \elastic
Ndef(\test).mold( 8, \audio, \elastic); // preparada para aceitar até 8 canais

// teste de novo
Ndef(\test, { Saw.ar( 110, mul: \amp.kr(0.1)) }).play; // 1 canal

Ndef(\test, { Saw.ar( [110, 112], mul: \amp.kr(0.1)) }); // 2 canais!

Ndef(\test, { Saw.ar( [110, 112, 115], mul: \amp.kr(0.1)) }); // 3 canais!

// se nada mudou com 3 canais é porque o terceiro está fora do que sua saída stereo pode reproduzir

// Com Splay os canais extra sao distribuídos na imagem stereo
Ndef(\test, { Splay.ar(Saw.ar( [110, 112, 115], mul: \amp.kr(0.1))) }); // 3 canais em 2

// adaptável a quantidade de canais de áudio disponível fisicamente
Ndef(\test).mold( s.options.numOutputBusChannels, \audio, \elastic);



//////////////////////////////////////////////////////////////////////////////


      ************************ Tdef *****************************

      TaskProxy com um nome é uma Tdef. A versão JITLib para Task

Tdef referencia uma Task, que por sua vez é um processo que se pode ser pausado

// sintetizadores para usarmos nos exemplos a seguir
(

SynthDef(\simples, { | out = 0, freq = 220, width = 0.5, amp = 0.2, gate = 1, sustain = 1, pan = 1 |
    var sig, env;
    sig = VarSaw.ar([freq, freq * 1.01], 0, width, amp);
    sig = SoftClipAmp.ar(sig, 32,  mul: amp );
    env = Env.perc().kr( doneAction: Done.freeSelf, gate: gate, timeScale: sustain);
    sig = sig * env;
    // sig = BMoog.ar(sig, 220,  q: 0.2,  mode: 0.0,  saturation: 0.95,  mul: 1.0,  add: 0.0);
    Out.ar( out, Pan2.ar(sig, pan) )
}).add;

SynthDef(\fm2, {| out=0, t_trig=1, freq=1040, decay=0.09, amp=0.6, sustain = 1|
	var snd, env = EnvGen.ar(Env.perc(0.01,decay*LFNoise2.kr(0.1,0.1,1)), t_trig, timeScale: sustain, doneAction: 2);
	snd = RLPF.ar(
		PMOsc.ar(freq, freq * IRand(2,4)/2, TRand.kr(0.5, 3, t_trig),0),
		SinOsc.kr([0.1, 0.11]).range(400, 1900),
		0.4
	);
	OffsetOut.ar(out, snd * env * amp);
}).add;

SynthDef(\abracadabra, { |out, freq = (60.midicps), amp = 0.1, sustain = 0.8|
	var env = Line.kr(amp, 0, sustain);
	var snd = Saw.ar(freq + [0.3, -0.3]).sum;
	Out.ar(out, snd * env);
}).add;

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

)

(
Tdef(\x, {
	inf.do {
		"do".postln;
		0.5.wait;
	}
}).play;
)

// diferentes tempos de espera
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

// toca notas aleatórias
(
Tdef(\x, {
	var dt, midinote;
	inf.do {
		"wait ".post;
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72);
		(instrument: \simples, midinote: midinote, legato: 0.5).play;
		dt.postln.wait;
	}
}).play;
)
// nome diferente, nova Tdef
(
Tdef(\y, {
	var dt, midinote;
	inf.do {
		"wait ".post;
		dt = [0.75, 1].choose;
		midinote = rrand(60, 72) - 12;
		(instrument: \simples, midinote: midinote, legato: 2).play;
		dt.postln.wait;
	}
}).play;
)

// rename, use \right instead
// make it play double time
Tdef(\x).stop;
(
Tdef(\right, {
	var dt, midinote;
	inf.do {
		dt = [0.25, 0.5].choose;
		midinote = rrand(60, 72);
		(instrument: \simples, midinote: midinote, dur: 0.1).play;
		(dt * 0.5).wait;
	}
}).play;
)
Tdef(\y).source.postcs;
Tdef(\y).stop;

// de uma para outra
Tdef(\left, Tdef(\y).source).play;

TdefAllGui();

// access Tdef within itself
(
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
)

(
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
)
Tdef(\master).play;

(
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
)

Tdef(\mel).set(\inst, \simples); // ainda nao funciona

// Tasks e Routines têm seu próprio Environment. Podemos acessá-los através do primeiro argumento. Aqui 'envir'
(
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
)

Tdef(\mel).set(\inst, \fm2);

(instrument: \abracadabra, midinote: 62).play;
(instrument: \abracadabra, sustain: 0.03).play;
(instrument: \abracadabra, midinote: -10).play;
(instrument: \abracadabra, sustain: 4).play;


Tdef(\mel).play;
Tdef(\mel).set(\inst, \abracadabra);
Tdef(\mel).set(\inst, nil);

Tdef(\mel).set(\inst, \hocuspocus);

(
// magic of vibrato
SynthDef(\abracadabra, { |out, freq = (60.midicps), amp = 0.1, sustain = 0.8|
	var env = Line.ar(amp, 0, sustain, doneAction: 2);
	var freqmod = SinOsc.kr(6).range(0.97, 1.03);
	var snd = Saw.ar(freq * freqmod + [0.3, -0.3]).sum;
	Out.ar(out, snd * env);
}).add;
)

s.scope;
(60, 60.1 .. 60.8).collect { |num| num + 0.1.rand2 }
(midinote: (60, 60.1 .. 60.8)).play;


(instrument: \hocuspocus, midinote: (60, 60.1 .. 60.8)).play;


(
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
)

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
        // 1.wait;
        [1, 0.5, 0.5].choose.wait;
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


Tdef(\tink).gui;
// -> shows up on gui!
(
Tdef(\tink, {
	loop {
		(instrument: \glisson).play;
		1.wait;
	};
});
)

//////// mais seguro que loop { ... }:
//////// um número fixo de repeticoes, assim ela para por si mesma:
(
Tdef(\tink, {
	42.do {
		(instrument: \glisson).play;
		1.wait;
	};
});
)

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
(
Tdef(\tink, { |envir|
	42.do {
		(instrument: \glisson,
			freq: envir.freq ).play;
		1.wait;
	};
});
)
// definir um intervalo para valores de freq aleatórios:
Tdef(\tink).set(\minfreq, 400);
Tdef(\tink).set(\maxfreq, 4000);

Tdef(\tink, { |envir|
	32.do {
		var freq = exprand(envir.minfreq, envir.maxfreq);
		(instrument: \glisson, freq: freq ).play;
		1.wait;
	};
});

////// use o intervalo aleatório para freq (freq inicial) e freq2 (freq final):
(
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
)

Tdef(\tink).set(\sustain, 0.1);
Tdef(\tink).set(\maxfreq, 4000);

////// defina o intervalo para os parâmetros:
Tdef(\tink).addSpec(\sustain, [0.01, 1, \exp]);
Tdef(\tink).addSpec(\minfreq, \freq);
Tdef(\tink).addSpec(\maxfreq, \freq);

(
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
)

// remova \freq, que nao está sendo usado
Tdef(\tink).set(\freq, nil);

Tdef(\tink).gui;

"Tdef".help
veja
"Tdef as a time pattern"

///////////////////////////////////////////////////////////////////////////////

# JITLib

            ****************** Ndef *************************

Definição de NodeProxy -> placeholder (espaço reservado) para processos de síntese.

            // A ordem aqui realmente não importa.
Ndef(\test);

			// toca, mas ainda está vazia
Ndef(\test).play;

			// insira UGen no espaço reservado
Ndef(\test, { Blip.ar( 70, MouseX.kr(2, 100, 1)) });

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

Ndef(\test, { arg freq = 40, amp = 0.4; Impulse.ar( [freq, freq * 1.01], 0.1 ) * amp } ).play;
Ndef(\test, { arg freq = 40, amp = 0.1; Saw.ar( freq!2, amp ) * amp } );
Ndef(\test, { arg freq = 40, amp = 0.1; Pulse.ar( [freq, freq * 1.01], 0.02, amp) });

// o valor mudado através de .set se mantém mesmo que os argumentos tenham valores default

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

Ndef(\dust, { Ringz.ar( Dust.ar(10), [ 300, 400, 450], 0.2 ) * 0.1 });

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
Ndef(\test).reshaping = \elastic;

// teste de novo
Ndef(\test, { Saw.ar( 110, mul: \amp.kr(0.1)) }).play; // 1 canal

Ndef(\test, { Saw.ar( [110, 112], mul: \amp.kr(0.1)) }); // 2 canais!

Ndef(\test, { Saw.ar( [110, 112, 115], mul: \amp.kr(0.1)) }); // 3 canais!

// se nada mudou com 3 canais é porque o terceiro está fora do que sua saída stereo pode reproduzir

// Com Splay os canais extra sao distribuídos na imagem stereo
Ndef(\test, { Splay.ar(Saw.ar( [110, 112, 115], mul: \amp.kr(0.1))) }); // 3 canais em 2


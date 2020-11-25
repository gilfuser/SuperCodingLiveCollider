
//// LIGADO AO SOM!
//// Para isso, o SuperCollider possui um assim chamado "servidor",
//// um segundo programa que faz toda a geração de som.
//// isso geralmente é armazenado na variável global s
s.dump;
s.boot; // diga ao servidor para iniciar
s.scope;

().play; // som de piano ruim - é uma cozinha ...

Funcoes se tornam SynthDefs ao se usar o método play,
sao entao compiladas e enviadas ao servidor

{ SinOsc.ar }.play;

// stop synthesis with Cmd-.

{ SinOsc.ar(400) }.play;

{ SinOsc.ar(600) * 0.1 }.scope;	// veja saída do audio

    // calcule com UGens.
{ SinOsc.ar * 0.2 }.play;

    // Aqui, somando dois sinais e multiplicando por 0.2
{ SinOsc.ar(300) + Dust.ar(400) * 0.2  }.scope;

	// arrays se tornam canais de audio
{ SinOsc.ar( [400, 402] ) }.play;
400!2
{ SinOsc.ar( 400!2 ) }.play;
{ [ SinOsc.ar(400), SinOsc.ar(500) ] }.play;
{ [ SinOsc.ar(200) * 0.2, Dust.ar(400) ] }.scope;

	// mude valores enquanto roda
x = { arg freq=200; Impulse.ar(freq) * 0.1 }.play;
x.set(\freq, 250);
x.set(\freq, 500);

// acesse a funcao através de uma variável (x)
// assim nao precisa mais de Cmd-. para pará-la
x.free;

x = { arg freq=200; Impulse.ar( [freq, freq * 1.01] ) * 0.1 }.play;
x.free;

// crackly noise
x = { Dust2.ar([30, 30]) }.play;
x.free;

x = { SinOsc.ar([332, 334]) * 0.1 }.play;
x.free;


			// tasks: time scheduling on the client
(
Task({
	inf.do({
		x.set(\freq, 300 + 200.rand);
		0.2.wait;
	});
}).play;
)

///////////////////////////////////////////////////////////////////////////////////



"Pattern Guide".help;

Pbind(\note, Pseq((0..7)), \dur, 1/8).play;

Pbind(\degree, Pseq((0..7)), \dur, 1/8).play;

///// moment in the restaurant:
//// load a library with a lot of so-called synthdefs
"../libs/_SynthLib.scd".resolveRelative.openOS;

"../libs/_SynthLib.scd".loadRelative;


q.synthDefs.cs; // that many
q.tonalDefs.cs; // the ones with frequency input / pitch

(instrument: 'grainXLine').play;
(instrument: 'grainSine', amp: 0.5, sustain: 0.02).play;

// try one of them:
(
Pbind(
	\instrument, \Mridangam,
	\degree, Pseq((0..7)),
	\dur, 1/8
).play;
)

(\instrument: \Mridangam, degree: 12).play;

(
Ndef(\sins).fadeTime = 3;
Ndef(\sins, {
	Splay.ar(
		SinOsc.ar({ exprand(50, 2000) }!12)
	) * 0.1
}).play;
)

(
Tdef(\sins, {
	loop {
		Ndef(\sins).rebuild;
		exprand(5, 20).wait;
	}
}).play;
)

Tdef(\sins).stop;
Ndef(\sins).end;

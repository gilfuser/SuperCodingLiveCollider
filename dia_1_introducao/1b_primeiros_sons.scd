
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

	// arrays se tornam canais de audio a.k.a Multichannel Expansions
{ SinOsc.ar( [400, 402] ) }.play;

* saiba mais em:
HelpBrowser.openHelpFor("Guides/Multichannel-Expansion");

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


Experimente outros sons avaliando direto na janela do Sistema de Ajuda. Desca direto para os exemplos, que em geral ficam na última parte da documentacao.
saiba mais em:

Blip.help;
Formant.help;
DynKlang.help;
Impulse.help;
Klang.help;
Pulse.help;
Saw.help;
SinOscFB.help;
SyncSaw.help;
VOsc.help;
VarSaw.help;
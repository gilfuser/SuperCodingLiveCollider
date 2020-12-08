
//// LIGADO AO SOM!
//// Para isso, o SuperCollider possui um assim chamado "servidor",
//// um segundo programa que faz toda a geração de som.
//// isso geralmente é armazenado na variável global s

s.dump;
s.boot; // diga ao servidor para iniciar
s.scope;

().play; // som de piano ruim - é uma cozinha ...

Funções se tornam SynthDefs ao se usar o método play,
são então compiladas e enviadas ao servidor

{ SinOsc.ar }.play;

    // pare síntese com Cmd + .

{ SinOsc.ar(200) }.play;

{ SinOsc.ar(600) * 0.1 }.scope;	// veja saída do audio

    // calcule com UGens.
{ SinOsc.ar * 0.2 }.play;

    // Aqui, somando dois sinais e multiplicando por 0.2
{ SinOsc.ar(300) + Dust.ar(400) * 0.2  }.scope;

	// arrays se tornam canais de audio a.k.a Multichannel Expansion
{ SinOsc.ar( [400, 402] ) }.play;

* saiba mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/06-Presented-in-Living-Stereo");

{ SinOsc.ar( 440!2 ) }.play; // 440!2 é o mesmo que [440, 440]
{ [ SinOsc.ar(400), SinOsc.ar(404) ] }.play;
{ [ SinOsc.ar(200), Dust.ar(400) ] * 0.2 }.scope;

    // acesse a função através de uma variável (x)
x = { arg freq=200; Impulse.ar(freq) * 0.1 }.play;

// assim nao precisa mais de Cmd + . para pará-la
x.free;

x = { SinOsc.ar([332, 334]) * 0.1 }.play;
x.free;

// crackly noise
x = { Dust2.ar([30, 30]) }.play;
x.free;

x = { arg freq=200; Impulse.ar( [freq, freq * 1.01] ) * 0.1 }.play;

	// mude valores enquanto roda
x.set(\freq, 250);
x.set(\freq, 500);
x.free;

Experimente outros sons avaliando direto na janela do Sistema de Ajuda. Desça direto para os exemplos, que em geral ficam na última parte da documentação.

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

Quando usamos o método 'play' em uma funcao ela é automagicamente transformada em uma SynthDef e instaciada em um Synth.

* saiba mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/04-Functions-and-Other-Functionality");

Continua em:
"../dia_2_synths/2a_synthdefs.scd".resolveRelative.openOS;
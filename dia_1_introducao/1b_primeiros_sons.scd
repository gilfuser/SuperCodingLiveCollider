
//// LIGADO AO SOM!
//// Para isso, o SuperCollider possui um "servidor" de som,
//// um segundo programa que faz toda a geração de som.
//// geralmente pode ser acessado através da variável global s

s.dump;
s.boot; // diga ao servidor de áudio para iniciar
s.scope;

().play; // som de piano padrão só pra testar

// o método.play toca uma função
{ SinOsc.ar }.play;

// use Cmd + . (ponto) entre um teste e outro.
// Mais adiante você encontrará formas mais flexíveis e dinâmicas de fazer testes

{ SinOsc.ar(200) }.play;

{ SinOsc.ar(600) }.scope;	// veja saída do audio

// calcule com UGens.
// multiplicar muda o volume, ou amplitude do som
{ SinOsc.ar * 0.2 }.play;

// um tipo de ruído
{ Dust(400) }.play;

// Aqui, somando dois sinais e multiplicando por 0.2
{ SinOsc.ar(300) + Dust.ar(400) * 0.2  }.scope;

	// arrays se tornam canais de audio (Multichannel Expansion)
{ SinOsc.ar( [400, 402] ) }.play;

* saiba mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/06-Presented-in-Living-Stereo");

{ SinOsc.ar( 440!2 ) }.play; // 440!2 é o mesmo que [440, 440]
{ [ SinOsc.ar(400), SinOsc.ar(404) ] }.play;
{ [ SinOsc.ar(200), Dust.ar(400) ] * 0.2 }.scope;

// acesse a função através de uma variável (x)
x = { arg freq=200; Impulse.ar(freq) * 0.1 }.play;

// assim nao precisa de Cmd + . para pará-la
x.free;

x = { SinOsc.ar([332, 334]) * 0.1 }.play;
x.free;

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

Quando usamos o método 'play' em uma função ela é automagicamente transformada em uma SynthDef (a definição de um sintetizador) e instaciada em um Synth (o sintetizador em si).

* saiba mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/04-Functions-and-Other-Functionality");

Continua em:
"../dia_2_synths/2a_synthdefs.scd".resolveRelative.openOS;
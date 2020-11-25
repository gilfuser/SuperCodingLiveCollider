# Faca Seus Próprios Sons Para FoxDot

From https://foxdot.org/docs/using-your-own-synthdefs/

Uma SynthDef funcional no FoxDot deve parecer assim:

SynthDef.new(\sine, { | amp = 1, sus = 1, pan = 0, bus = 0, freq = 0 |
    var som, env;
    freq = In.kr(bus, 1); // <<< atencao aqui
    som = SinOsc.ar(freq, mul: amp);
    env = EnvGen.ar(Env.perc(attackTime: 0.01, releaseTime: sus), doneAction: 0);
    som = (som * env);
    som = Pan2.ar(som, pan);
    ReplaceOut.ar(bus, som) // <<< e aqui
}).add;

Sobre os detalhes específicos e obrigatórios:

freq = In.kr(bus, 1);
In.kr lê o sinal do argumento 'bus'
saiba mais em
"Busses".help

ReplaceOut.ar(bus, som)
ReplaceOut.ar envia um sinal para um bus substituindo o conteúdo anterior.
saiba mais em
"ReplaceOut".help

note doneAction: 0
isso significa que o Synth nao é liberado pela automaticamente pela própria SynthDef. deve ser gerenciado pelo próprio FoxDot

Salve a SynthDef em um arquivo .scd de mesmo nome no diretório que aparece quando vc avalia
FoxDot.start

pra mim é
"~/.local/lib/python3.8/site-packages/FoxDot/osc/scsyndef/"

Para carregar a SynthDef durrante uma sessao de FoxDot, crie a SynthDef e use o método add para carregar no SuperCollider assim:

sine = FileSynthDef("sine")
sine.add()



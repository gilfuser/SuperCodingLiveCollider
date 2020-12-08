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

///////////////////////////////////////////////////////////////////////


            ****************** Tdef *************************

TaskProxy com um nome é uma Tdef. a versao JITLib para Task

			// uma task muda os valores
(
Tdef(\noodle, {
	inf.do({
        Ndef(\x).set(\freq, 300 + 500.rand);
        1.wait
    });
}).play;
)

// GUIs (Interface Gráfica para Usuária) de graça para todes!
NdefMixer(s);
Ndef(\test).gui;

(
Tdef(\noodle, {
	inf.do({
		Ndef(\x).set(\freq, exprand(25, 250));
		(0.1 * [1, 2, 3].choose).postln.wait;
	});
}).play;
)

Tdef(\noodle).pause;

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
//////////////////////////////////////////////////////////////////////////////

      ************************ ProxySpace *****************************

ProxySpace é um ambiente especial para NodeProxies
Variáveis de ambiente, aquelas que comecam com ~
ex. ~foo
viram NodeProxies

Compare este arquivo com
Document.open(thisProcess.nowExecutingPath.dirname ++ "/3b_jitlib_ndef.scd"); // execute essa linha
e perceba que NodeProxies criadas em um ProxySpace sao equivalentes a Ndefs



// Ainda no ambiente "normal" (topEnvironment) se você usa variáveis ambiente assim:
~lala = { Blip.ar( 70, MouseX.kr(2, 100, 1)) };
~abc = 7;

// os valores estao armazenados no ambiente
currentEnvironment.postln;

~lala.class; // Function
~abc.class; // Integer

saiba mais em:
Environment.help;

p = ProxySpace(s.boot, p);

q.pxMixer = ProxyMixer(p, 8); // espaco para 8 proxies
q.pxMixer.parent.alwaysOnTop_(true);
// Se você tiver JITLibExtensions instalado. ProxyMeter para ver os níveis dos proxies:
if (\ProxyMeter.asClass.notNil) { ProxyMeter.addMixer(q.pxMixer); };

// para que os proxys em p se adaptem ao número desejado de saídas de áudio.
// O default sao duas (stereo)
p.reshaping = \elastic;

p.play; // cria NodeProxy ~out

// push faz com que entremos no ambiente do ProxySpace
p.push;

// assume que é audio rate, dois canais

~test.play; ~test = { Blip.ar( 70, MouseX.kr(2, 100, 1), 0.5) };

~test = { Blip.ar( 70, [MouseX.kr(2, 100, 1), MouseY.kr(2, 100, 1)], 0.5) };

// Nao se pode definir o conteúdo e usar o método play de uma só vez como nas Ndefs. ex:
// ~test = { ... }.play; // ERRO!

~test.class; // NodeProxy
~test.source.class; // Function

~test = { Pulse.ar([20, 19.9], 0.1) * 0.1 };

    ******** fading *********

~test.fadeTime = 0.5;

// mude o conteúdo. O tempo de transicao é ditado pelo método fadeTime
~test = { Pulse.ar(exprand(50!2, 200), 0.1) * 0.2 };
~test = { Blip.ar(exprand([50, 25], 200), 5) * 0.2 };
~test = { Blip.ar({exprand(50, 200)}!2 * 0.5, rrand(5, 15 )) * 0.2 };

~test.rebuild; // exprand escolherá um novo número

~test.fadeTime = 4;
// teste de novo as versoes de ~test acima

// play/stop iniciam e interrompem o monitoramento do proxy
// nao interferem nos estados internos dele
~test.stop;
// o argumento vol ajusta o volume do monitoramento
~test.play(vol: 0.5);
~test.vol = 1;


// apaga o conteúdo no proxy após fade out também ditado pelo fadeTime
~test.release;
// envia um novo Synth. Veja que os valores gerados por exprand nao mudam
// porque o o Synth já foi criado
~test.send;

~test = { Blip.ar({ExpRand(50, 200)}!2 * 0.5, Rand(5, 15 )) * 0.2 };

~test.send;
// agora sim os valores mudam, porque estao sendo gerados por UGens
// que geram novos números a cada intância

(
~test = { arg freq = 40, amp = 0.3;
    LPF.ar( Pulse.ar ( [freq, freq * 1.01], 0.05 ), 1000 ) * amp
};
)
    ******** set *********
			// muda valores enquanto roda. teste várias vezes
~test.set(\freq, exprand(40, 400), \amp, 0.3);

~test = { arg freq = 40, amp = 0.8; Impulse.ar( [freq, freq * 1.01] ) * amp };
~test = { arg freq = 40, amp = 0.1; Saw.ar( freq!2, amp ) * amp };
~test = { arg freq = 40, amp = 0.1; Pulse.ar( [freq, freq * 1.01], 0.02, amp) };


    ******* mapping *******

// um Control Proxy (control rate)
~mod = { LFSaw.kr(0.25, 1).exprange(88, 880) };
// usado para controlar um parâmetro de outro proxy
~filter.map(\freq, ~mod);
~test.unmap(\freq); // desliga


    ******** Rotas de áudio *********

~filter.play;

~filter = { MoogVCF.ar( \in.ar(0!2), \fco.kr(220, 0.2, spec: \freq.asSpec), \res.kr(1, 0.2)) }; // ainda nao faz som. Precisa de um input e `in` ainda nao contém uma funcao que gere som

~pulse = { Pulse.ar( [80, 121], [0.3, 0.7], 0.5) };

~filter <<> ~pulse; // agora sim. in - é automático.

~filter.map(\fco, ~mod);

// para parâmetros nao automáticos
(
~filter = { MoogVCF.ar( \in1.ar(0!2) + \in2.ar(0!2), \fco.kr(220, 0.2, spec: \freq.asSpec), \res.kr(1, 0.2)) }
)

// tem-se que definir aqui
~filter <<>.in1 ~pulse;

~pulse2 = { Pulse.ar( [200, 82], SinOsc.kr(0.2).range(0.01, 0.99), 0.4 ) };

~filter <<>.in2 ~pulse2;

//para desfazer o caminho para um input
~filter <<>.in1 nil;

// proxies podem ser usadas diretamente como UGens!

~dust = { Ringz.ar( Dust.ar(10), [ 300, 400, 450], 0.2 ) * 0.1 };

// note que ~dust está sendo usada como fonte de áudio (ar)
~rev = { CombL.ar( ~dust, 0.1, 0.03, 1) }; ~rev.play;

~rev = { ( CombL.ar( ~dust, 0.1, [0.01, 0.03], 5) ) };

~dust.play;
~dust.scope;
~dust.clear(4);
~rev.clear;

~rev.stop;

~mod = { LFNoise0.kr([1, 1.5]).exprange(0.065, 1.5) };

// note o ~mod está sendo usada como modulador (kr)
~x = { |freq = 220| Blip.ar( ~mod * freq, 6, 0.1) }; ~x.play;

~mod = { LFNoise1.kr([100, 150]).exprange(0.065, 1.5) };

// Tdef -> TaskProxy
(
Tdef(\noodle, {
	inf.do({
        ~x.set(\freq, 300 + 500.rand);
        0.1.wait
    });
}).play;
)

(
Tdef(\noodle, {
	inf.do({
		~x.set(\freq, exprand(25, 250));
		(0.1 * [1, 2, 3].choose).wait;
	});
}).play;
)

Tdef(\noodle).pause;

~x.end(3);

~tiririn.play;
~pinpin.rebuild;
~pinpin.play;

~tiririn = { Ringz.ar( Impulse.ar(1) ) * \amp.kr(0.2) };
~pinpin = { Ringz.ar( Impulse.ar(1), 220 ) * \amp.kr(0.2) };

// sincronizar
~tiririn.quant = 1;
~pinpin.quant = 1;

~tiririn = { Ringz.ar( Impulse.ar([1,2]) ) * \amp.kr(0.2) };
~pinpin = { Ringz.ar( Impulse.ar([3,1.5]), 220 ) * \amp.kr(0.2) };

// pode-se escolher um clock e a quant para todo o proxy space e os proxys nele terao a mesma configuracao

p.makeTempoClock(1);

~tiririn = { Ringz.ar( Impulse.ar([1,2] * ~tempo ) ) * \amp.kr(0.2) };
~pinpin = { Ringz.ar( Impulse.ar([3,1.5] * ~tempo ), 220 ) * \amp.kr(0.2) };

p.clock.tempo = 1;

~tiririn.quant = [4, 1/2]; /* offset */ ~tiririn.rebuild;

(
Tdef(\q, {
    loop {
        8.do {~tiririn.quant_([1, 1/3]).rebuild;
            1.wait;
            ~tiririn.quant_([1, -1/2]).rebuild;
            1.wait;
        };
        8.do {
            ~tiririn.quant_([1, 1/2]).rebuild;
            1.wait;
            ~tiririn.quant_([1, -1/3]).rebuild;
            1.wait;
        }
    }
}).play(quant: 1)
)

// retorne para o ambiente "normal"
p.pop;

você ainda pode acessar os NodeProxies em p das seguintes formas:

p[\tiririn] = { Ringz.ar( Impulse.ar([1,2]), LFNoise0.kr(1!2).exprange(110, 220) ) * \amp.kr(0.2) };

ou

p.know = true;

(
p.pinpin = {
    Ringz.ar( Impulse.ar([3,1.5]), LFNoise0.kr(2!2).exprange(220, 440).lag(0.2) ) * \amp.kr(0.2)
};
)

// crie um proxy em p a partir do "lado de fora"
p.z.play.quant = 1; // cria já tocando e sincronizável

p.tiririn.fadeTime = 4;

p.tiririn.release;

p.z = p.tiririn.fold2(0.125);

p.z = { p.tiririn.fold2( SinOsc.kr(1/16).range(1/32, 1/8) ) };

p.tiririn.fadeTime = 0;

                            ------------- slots ---------------

Um NodeProxy pode conter vários objetos cuja ordem de execucao é determinada por um índice, que pode ser quanquer número inteiro positivo.

p.push;

~z.play;

~z = ~y * { SyncSaw.kr(1,[1.66,1.33],0.8) }

~y[0] = { SinOsc.ar(400)*0.2 }

~y[1] = { SinOsc.ar(500)*0.2 }

~y[0..4] = { SinOsc.ar( exprand(250, 1000), rand(0, 2pi)!2, 0.1 )}


                       ------------- NodeProxy roles ---------------

// adicione um filtro
~z[1] = \filter -> { |in| Limiter.ar( BBandPass.ar( in, LFNoise2.kr(0.5).exprange(200,1000), 0.2)) }
~z.set(\wet1, 0.5);

//misture o sinal nao-filtrado e filtrado (dry e wet)
~y.set(\wet5, 1);

~y[2..4] = nil;

~y[1] = \mix -> { SinOsc.ar(500)*0.2 }

~y.set(\mix1, 0.2)

veja mais em;

HelpBrowser.openHelpFor("Reference/NodeProxy_roles")


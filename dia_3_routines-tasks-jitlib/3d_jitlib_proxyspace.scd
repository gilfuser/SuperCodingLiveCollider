//////////////////////////////////////////////////////////////////////////////

      ************************ ProxySpace *****************************

ProxySpace é um ambiente que retorna NodeProxies. Na prática funciona muito parecido com Ndef

Compare com

Document.open(thisProcess.nowExecutingPath.dirname ++ "/3b_jitlib_ndef.scd");

Ainda no ambiente "normal" (topEnvironment) se você usa variáveis ambiente assim:

~lala = { Blip.ar( 70, MouseX.kr(2, 100, 1)) };
~abc = 7;

currentEnvironment.postln; // os valores estao armazenados no ambiente

~lala.class; // Function
~abc.class; // Integer

p = ProxySpace(s.boot, p);

// push substitui o ambiente atual (currentEnvironment) pelo ProxySpace
p.push;

// assume que é audio rate, dois canais
~test.play;

// Nao se pode definir o conteúdo e usar o método play de uma só vez como nas Ndefs. ex:
// ~test = { ... }.play; // ERRO!

~test = { Blip.ar( 70, MouseX.kr(2, 100, 1)) };

~test.class; // NodeProxy
~test.source.class; // Function

~test = { Pulse.ar([20, 19.9], 0.1) * 0.1 };

~test.fadeTime = 0.5;

~test = { Pulse.ar(exprand(50!2, 200), 0.1) * 0.2 };
~test = { Blip.ar(exprand([50, 25], 200), 5) * 0.2 };
~test = { Blip.ar({exprand(50, 200)}!2 * 0.5, rrand(5, 15 )) * 0.2 };

~test.rebuild; // exprand escolherá um novo número

~test.fadeTime = 4;

~test.stop;
~test.play;
~test.release; // apaga o conteúdo no espaço reservado

(
~test = { arg freq = 40, amp = 0.3;
    LPF.ar( Pulse.ar ( [freq, freq * 1.01], 0.05 ), 1000 ) * amp
};
)


			// mude valores enquanto roda. teste várias vezes
~test.set(\freq, exprand(40, 400), \amp, 0.3);

~test = { arg freq = 40, amp = 0.8; Impulse.ar( [freq, freq * 1.01] ) * amp };
~test = { arg freq = 40, amp = 0.1; Saw.ar( freq!2, amp ) * amp };
~test = { arg freq = 40, amp = 0.1; Pulse.ar( [freq, freq * 1.01], 0.02, amp) };

    // mapping

~mod = { LFSaw.kr(0.25, 1).exprange(88, 880) };

~test.map(\freq, ~mod);
~test.unmap(\freq)

    // fading

~test.fadeTime = 3;

// teste algumas das versoes de ~test acima

~test.end(3); // fade out

// Rotas de áudio

~filter.play;

~filter = { MoogVCF.ar( \in.ar(0!2), \fco.kr(220, 0.2, spec: \freq.asSpec), \res.kr(1, 0.2)) }; // ainda nao faz som. Precisa de um input e `in` ainda nao contém uma funcao que gere som

~pulse = { Pulse.ar( [80, 121], [0.3, 0.7], 0.5) };

~filter <<> ~pulse; // agora sim. in - é automático.

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

// reshaping elastic permite que os proxys em um ProxySpace se adaptem ao número desejado de saídas de áudio
p.reshaping = \elastic;

// proxies podem ser usadas como UGens!

~dust = { Ringz.ar( Dust.ar(10), [ 300, 400, 450], 0.2 ) * 0.1 };

// note .ar (audio rate) ~dust.ar está sendo usada como fonte de áudio
~rev = { CombL.ar( ~dust, 0.1, 0.03, 1) };
~rev.play;

~rev = { CombL.ar( ~dust, 0.1, [0.01, 0.03, 0.02], 5) };

~dust.play;
~dust.scope;
~dust.clear;
~rev.clear;

~rev.stop;

~mod.clear
~mod = { LFNoise0.kr([1, 1.5]).exprange(0.065, 1.5) };

// note o .kr (control rate) ~mod).kr está sendo usada como modulador.
~x = { |freq = 220| Blip.ar( ~mod * freq, 6, 0.1) };
~x.play

~mod = { LFNoise1.kr([1, 1.5]).exprange(0.065, 1.5) };

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

// GUIs (Interface Gráfica para Usuária) grátis!
m = ProxyMixer(p, 8);
p.do(_.play(0));

// se você tiver JITLibExtensions instalado, tente ProxyMeter para ver os níveis dos proxies:
if (\ProxyMeter.asClass.notNil) { ProxyMeter.addMixer(m); };


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

// o argumento vol ajusta o volume do monitor da proxy, criado com o método play
p.z.vol = 0.3;

                            ------------- slots ---------------

Um NodeProxy pode conter vários objetos cuja ordem de execucao é determinada por um índice, que pode ser quanquer número inteiro positivo.

p.push;

~z.stop;

~z = ~y * { SyncSaw.kr(1,[1.66,1.33],0.4) }

~y[0] = { SinOsc.ar(400) }

~y[1] = { SinOsc.ar(500) }

~y[0..4] = { SinOsc.ar( exprand(250, 1000), rand(0, 2pi) )}

~y = nil//{SinOsc.ar(LFSaw.ar(1,0,2000,2000).trunc(500),0,0.4)}



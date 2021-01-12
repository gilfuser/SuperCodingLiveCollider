Routine e Task servem para criar estruturas temporais.

Para organizar coisas no tempo precisamos de um relógio:
Clock
E agendar (Scheduling) eventos (Event) futuros

O SC tem três tipos de relógios:
SystemClock
TempoClock // é esse que vamos usar para fazer música
AppClock // serve mais para GUIs

(
r = Routine(
    {
        postln( "oi" );
        wait(1);
        postln( "que?" );
        1.wait;
        postln( "olá mundo" );
        wait(1);
        postln( "heim?" );
        wait(1);
        postln( "deixa pra lá" );
        wait(1);
        postln("fim");
    }
)
)

r.play;
r.play; // não funciona. Porque já tocou e chegou ao fim.

r.reset;

// agora pode tocar outra vez
r.play;

r.reset;

//passo a passo. repita várias vezes.
r.next

//eventualmente o resultado será 'nil'. porque não há um next (próximo) passo

// essa não tem fim: inf == infinito
   NÃO ESQUEÇA DO 'wait' entre os passos,
// ou todos os passos aconteceram infinitas vezes
// em um único instante.
// ou seja, seu computador pode travar.
(
r = Routine( {
    inf.do{
    postln( "que?" );
    1.wait; // pode ser assim
    postln( "olá mundo" );
    wait(1); // ou assim
    postln( "heim?" );
    wait(1);
    postln( "deixa pra lá" );
    wait(1);
    postln("fim");
    }
} )
)

(
SynthDef(\simples, { | out = 0, freq = 220, width = 0.5, amp = 0.2, gate = 1, iphase = 1.0 |
    var sig, env;
    sig = VarSaw.ar([freq, freq * 1.01], iphase, width, amp);
    sig = SoftClipAmp.ar(sig, 32,  mul: amp );
    env = Env.perc().kr( doneAction: Done.freeSelf, gate: gate);
    sig = sig * env;
    // sig = BMoog.ar(sig, 220,  q: 0.2,  mode: 0.0,  saturation: 0.95,  mul: 1.0,  add: 0.0);
    Out.ar( out, sig )
}).add
)

// cria e roda uma Routine ao mesmo tempo.
// dentro da funcao cria sintetizadores no estilo Event a partir da SynthDef acima.
(
Routine.run(
    {
        (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 0 ).play;
        wait(1);
        (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 2 ).play;
        (1/3).wait;
        (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 3 ).play;
        wait(2/3);
        (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 5 ).play;
        wait(1);
        (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 7 ).play;
    }
)
)

// assim como aqui
(
fork{
    wait(1);
    (1/3).wait;
    wait(2/3);
    (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 5 ).play;
    wait(1);
    (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: 7 ).play;
}
)

degree?

(
fork{
    [0, 2, 3, 5, 7].do{ |deg| (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: deg.post ).play;
        (" = " ++ (deg + 60).midicps ++ " Hz" ).postln;
        wait(0.5);
    }
}
)

//para serem usadas nas próximas Routines
w = Routine( { loop{ yield(1/4); yield(3/4); } });
x = Routine( { loop{ yield(1/4); yield(3/4); } });

x.next;

(
{
    Array.fib(6, 1, 1).do{ |deg| (instrument: \simples, iphase: rand(1.0), width: rand(1.0), degree: deg.postln ).play;
        wait(w.next);
    }
}.fork(quant: 4)
);

(
{
    Array.fib(6, 1, 1).mirror.pyramid(6).slide(3, 1).do{ |deg| (instrument: \simples, width: rand(1.0), degree: (deg -5).postln ).play;
        wait(w.next);
    }
}.fork(quant: 4)
);

(
{
    Array.fib(6, 1, 1).mirror.pyramid(7).slide(3, 1).do{ |deg| (instrument: \simples, width: rand(1.0), degree: (deg - 12).postln ).play;
        wait(x.next);
    }
}.fork(quant: 4)
);


Arrays e outras coleções são ricas em métodos que podem ser usados de maneiras musicais

* veja e teste em:
Array.help

Task funciona (quase) como Routine mas pode-se parar e retomar em qualquer momento com .pause .resume

(
x = Task( {
    inf.do{ |i| (instrument: \simples, degree: i%12 ).play; 1.wait; }
}).play(quant:1)
)

x.pause;

x.resume;

(
Task( {
    loop{ (instrument: \simples, degree: 3 ).play; 1.wait; }
}).play(quant:1)
)

x.pause;

//retome ainda sincronizada
x.resume(quant: 1);

saiba mais em:
HelpBrowser.openHelpFor("Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks")
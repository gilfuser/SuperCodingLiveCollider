# Routines

Routines são… Rotinas. Ou seja: faça isso, depois faça aquilo, depois aquilo outro. 

```supercollider
r = Routine(
    {
        "lalala".postln;
        wait(1);
        ().play;
        1 + 9;
        wait(1);
        "yield == wait".postln;
        yield(1);
        yield("yield != wait");
        "fim".postln;
        wait(1);
    }
)
```

A **Routine** acima está associada à variável `r` para que possa ser acessada. Contém uma função que com algumas ações a serem executadas, *waits* e *yield*.

A função contida na **Routine** pode ser iniciada ao se usar o método `next`. Ela ficará suspensa onde houver `wait` ou `yield`. Se este produzir um número será o tempo de espera até o próximo passo assim como `wait`, se nao, ele *entrega* o que está associado a ele.

```supercollider
r.next;
```

Quando *tocamos* uma **Routine** com o método `play` seu tempo é determinado por um **Clock**. Assim `1.wait` quer dizer: espere **1 beat** do relógio (Clock). Então falemos de **Clocks** e o que tem a ver com **Routine**.

---

# Clock

#### Do tutorial do Sistema de Ajuda [ Getting Started With SC - 14. Scheduling Events ](https://doc.sccode.org/Tutorials/Getting-Started/14-Scheduling-Events.html):

> Um relógio (*clock*) no SuperCollider tem duas funções principais. Ele sabe que horas são e em que momento as coisas devem acontecer, para que possa acordá-los no momento certo. <br/><br/>
O sequenciamento musical geralmente usa o **TempoClock**, porque pode-se alterar o seu **tempo** e ele também está ciente de alterações na métrica. Existem dois outros relógios: **SystemClock**, que sempre é executado em segundos, e **AppClock**, que também é executado em segundos, mas tem uma prioridade mais baixa de sistema (por isso é melhor para atualizações gráficas e outras atividades em que o tempo nao é crítico).

Além de monitorar o tempo os Clocks permitem agendar (*schedule*) tarefas para algum ponto futuro. Isso é feito através dos métodos `play`, `sched` ou `schedAbs`.

Os objetos afeitos a *agendamentos* por excelência são:
```
Function
Routine
Task
```

### Function

Exemplo com **SystemClock**
```supercollider
SystemClock.sched( 5, { "hello".postln } ); // 5 segundos
```
Com **TempoClock**

```supercollider
TempoClock.default.sched( 5, { "hello".postln } ); // 5 beats
```

Se a função retorna um número isso será entendido como o tempo de espera para que seja executada outra vez.

```supercollider
// 5 beats
TempoClock.default.sched( 5, {
    (degree: rand(12) ).play; // toca uma nota através do intrumento default em Event
    rrand(0.25, 1); // retorna um número entre 0.25 e 1.00
} ); 
```

Com a função acima ainda rodando mude o [tempo](https://pt.wikipedia.org/wiki/Tempo_(m%C3%BAsica)) de `TempoClock.default`

```supercollider
TempoClock.default.tempo = 2; // experimente outros valores
```

Pode-se ter tantos TempoClock quanto quiser.

```
~tC_1 = TempoClock(1).permanent_(true); // tempo inicial = 1
~tC_2 = TempoClock(1/3*8).permanent_(true); // permanent.true sobrevive a Cmd + .

~tC_1.sched(1, { ( degree: rand(-6) * 2 ).play; 1 });
~tC_2.sched(1, { ( degree: rand(12), legato: 0.25 ).play; rrand(0.25, 1) });
```

### Routine

Ao se usar o método `play` em uma **Routine** cria-se agendamentos a cada suspensão (`wait` ou `yield`) e retomada. Associando-a a um Clock, pode-se controlar a unidade de tempo.

```supercollider
(
r = Routine {
    99999.do { |i| // um número grande aqui é mais seguro que inf ou loop
        ( note: (i % 92 / 12).sin * 12 ).play;
        wait(1);
    }
}
)
```

Toca a Routine em um dos TempoClocks criados acima:

```supercollider
r.play( ~tC_1 );
```

Experimente mudar o tempo
```supercollider
~tC_1.tempo = 10;
```

Para *agendar* o início de `play` para um momento específico pode-se usar um segundo método: `quant`

```supercollider
r.stop;
r.play( ~tC_1, 4 ); // vai inciar daqui a 4 beats
```
**NOTA:** (1 beat = 1 segundo / clock tempo)

---

# Task

Tasks sao parecidas com Routines, com algumas vantagens e desvantagens. Elas podem ser pausadas e retomadas de qualquer ponto, mas nao permitem o uso de condicionais como **Routines**.

```supercollider
// exemplo semelhante à Routine mais acima
t = Task(
    {
        loop {
            "lalala".postln;
            wait(1);
            ().play;
            1 + 9;
            wait(1);
            "yield == wait".postln;
            yield(1);
            yield("yield != wait");
            "fim".postln;
            wait(1);
        }
    }, ~tC_1 // usa o Clock que criamos anteriormente
);

t.play( ~tC_2 /*pode-se trocar ou introduzit outro Clock aqui */, quant: 4 );
t.pause;
t.start;
t.resume;
t.reset;
t.stop;
```
---

# JITLib

## Biblioteca de programação Em Cima da Hora

Máxima flexibilidade no SuperCollider.

JITLib é sobre *proxies*. Veja em [3b_jitlib.scd](3b_jitlib_Defs.scd) breves explicações e o que isso significa na prática. Note que usamos mais frequentemente `Ndef`, `Tdef`, `Pdef` e `Pdefn`. Essas classes têm equivalentes que poderiam, com algumas diferenças sintáticas serem usadas. A saber:

| Defs | Proxies - nível profundo | Ambientes |
| ---- | --- | --- |
| Ndef | NodeProxy | ProxySpace |
| Tdef | TaskProxy ||
| Pdef | EventPatternProxy ||
| Pdefn | PatternProxy ||

É mais fácil entender JITLib ao se praticar e através de exemplos do que através da teoria. A documentação sobre o assunto no Sistema de Ajuda do SuperCollider é extensa e completa. Comece em [doc.sccode.org/Overviews/JITLib.html](http://doc.sccode.org/Overviews/JITLib.html) ou diretamente no SCIDE:

```supercollider
HelpBrowser.openHelpFor("Overviews/JITLib")
```


Proxies: Just In Time Programming (ou… LiveCoding!) <br/>
Proxies = marcadores de posição substituíveis.

* Flexibilidade na criação de sintetizadores e rotas de sinal.
* Sintaxe simplificada.
* Uso de Proxy, ou seja, marcador de espaço. Representa algo que ainda não existe. Para coisas como:
  
  Synths → Ndef (NodeProxy, ProxySpace) <br/>
  Tasks → Tdef <br/>
  Patterns → Pdef <br/>

A JITLib funciona a partir do conceito de **Proxy**. Aí vão algumas traduções possíveis para o português:

* Intermediário
* Substituto
* Alterno
* Representante
* Mediador

## Breve introdução

```supercollider
s.boot;	// o servidor precisa estar funcionando

x + y // erro. x e y ainda nao existem

x = NodeProxy.new;
y = NodeProxy.new;

// agora eles existem mas nao contém nada

x + y // viu? -> a BinaryOpPlug. Nenhum erro. Decida quando quiser.

// JITLib pode ser usado em estilos/técnicas equivalentes para criar 
// e lidar com NodeProxies

// Def (Ndef, Tdef, Pdef, Pdefn, MFdef, etc)

Ndef(\x, 5);

// o estilo profundo.
// Em última análize os outros dois se resumem a este
NodeProxy

x = NodeProxy.new;
x.source = 5;

// ProxySpace (Ambiente)

p = ProxySpace.new(s); // cria um Ambiente 'Environment'
p[\x] = 5;

// ou

p.push;

~x = 5;

p.pop;

```

Todo: JITLib ProxySpace

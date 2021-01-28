# Patterns

Muito do conteúdo aqui encontrado é baseado/inspirado por tutoriais e guias que estão no Sistema de Ajuda do SuperCollider. Entre outros:
* **[Getting Started / 16. Sequencing with Patterns](https://doc.sccode.org/Tutorials/Getting-Started/16-Sequencing-with-Patterns.html)**, uma introdução ao assunto
* **[Understanding Stream, Pattern and Event](https://doc.sccode.org/Tutorials/Streams-Patterns-Events1.html)** sobre a relação entre as três classes e os conceitos nelas envolvidos
* **[Patterns, A Practical Guide](http://distractionandnonsense.com/sc/A_Practical_Guide_to_Patterns.pdf)** se aprofunda em Patterns e os seus usos com uma parte final chamada
* **[Patterns Guide Cookbook](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing.html)** apenas com usos práticos explicados.
  
Veja na SCIDE:

```supercollider
HelpBrowser.openHelpFor("Tutorials/Getting-Started/16-Sequencing-with-Patterns");
HelpBrowser.openHelpFor("Tutorials/A-Practical-Guide/PG_01_Introduction");
HelpBrowser.openHelpFor("Tutorials/Streams-Patterns-Events1");
HelpBrowser.openHelpFor("Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing");
```

Segundo **Understanding Stream, Pattern and Event**

> Para entender a estrutura, uma série de conceitos deve ser abordada. Esses conceitos são incorporados às classes de **Streams**, **Patterns** e **Events**. Deve-se aprender esses conceitos na ordem apresentada. A estrutura é construída em camadas. Ao pular para ver as coisas legais primeiro, alguns pontos importantes são perdidos.

Bem, se é assim vamos a isso:

## Stream

> Um *stream* (**fluxo**, em português) representa uma ***sequência preguiçosa**** de valores, que são obtidos um a um através da mensagem `next`. A sequência pode ser reiniciada manualmente do início ao se enviar a mensagem `reset` para o objeto *stream*. Um *stream* pode ser de comprimento finito ou infinito. Quando um *stream* de comprimento finito termina, retorna `nil`.

*o termo “preguiçosa” em computação se significa algo que é calculado apenas no momento em que o resultado é necessário. No nosso caso os valores incluídos na “sequência preguiçosa” serão calculados apenas quando o objeto *stream* receber a mensagem `next`.

A classe **Stream** não é acessada diretamente, mas sim através das suas subclasses, como **Routine**, que também é subclasse de **Thread**.

**Routine** roda uma função e age como **Stream**. Tem capacidades herdadas de **[Thread](https://doc.sccode.org/Classes/Thread.html)**, como poder ser suspensa em qualquer ponto da sua execução (com a mensagem `yield` ou `wait`) e retomar desse ponto. O valor da função é o retornado a cada `yield`. Veja exemplos em [dia_3_routines-e-tasks](../dia_3_routines-e-tasks). Também herda de **Thread** as características de ter um **Clock** e um **tempo lógico**, associados. É assim que é possível parar e retomar depois de um tempo determinado por `wait` (*schedule*) ou voltar ao começo com `reset` (internamente `awake`) ou quando contém `loop` ou `inf.do`. Quando o valor retornado é `nil`, a **Routine** para.

> NOTA: Thread do SuperCollider não é um thread do sistema operacional. Embora tenham algumas semelhanças conceituais, eles não correspondem.

#### saiba mais sobre
* [**Clock**](https://doc.sccode.org/Classes/Clock.html)
* [**tempo lógico**](https://doc.sccode.org/Classes/Thread.html#-beats)

```supercollider
(
r = Routine { arg inval;
    inval.postln;
    inval = 123.yield;
    inval.postln;
}
)

// 'value' é sinônimo de 'next', assim como 'resume'
r.value("hello routine"); // passa-se o valor através do argumento 'inval'
r.value("goodbye routine");
```

Se (**yield** ou **wait**) retorna um número, pode-se utilizar o método ***play*** para que a **Routine** *toque* do começo ao fim, ou em *‘loop’*, ou tantas vezes quanto forem especificadas.

```supercollider
Routine {
    10.do({ arg a;
        a.postln;
        wait( 1 / (a + 1) ); // (a + 1) evita 1 / 0
    });
    // espere dois segundos antes de terminar
    2.wait;
    "fim".postln;
}.play;
```
## Pattern

Patterns não fazem nada por si só. São descrições, receitas, são partituras, algoritmos a serem usados para criar sequências e fluxos (*streams*) de dados, que podem ser números, ‘strings’, outras *patterns* ou outros objetos. São afeitas a composições musicais, sejam feitas na hora, gerativas ou determinísticas.

É fácil entender o uso prático de **patterns**. Veja exemplos e breve explicações teóricas no arquivo [5a_patterns.scd](5a_patterns.scd).

### Routine vs. Pattern

Adaptado de [doc.sccode.org/Classes/Pattern.html](https://doc.sccode.org/Classes/Pattern.html) 

```supercollider
(
a = [-100, 00, 300, 400];
    // faça a Pattern e transforme-a em um Stream (Routine)
p = Pseq(a).asStream;

    // faça um Stream diretamente
r = Routine({ a.do( { arg v; v.yield } ) });

    // confira os valores na 'Post window' lado a lado
5.do({ Post << Char.tab << r.next << " " << p.next << Char.nl; });
)
```

```supercollider
(
a = Routine {
        // série de 0 a 'n - 1'
    (0..).do { |i|
        i.yield;
    };
};
a.nextN(10); // mostre os primeiros 10 valores

        /*
        descreva uma série a partir de 0, 
        que avança em passos de 1 em 1.
        repita infinitamente
        transforme em Stream
        */
a = Pseries( 0, 1, inf ).asStream;

a.nextN(10); // mostre os primeiros 10 valores

// lembre-se que vc pode ver os parâmetros possíveis de um objeto
// com o cursor entre os parêtesis e pressionar Shift + Ctrl + Espaço
)
```

Para se obter os valores de um **Pattern** deve-se transformá-lo em um Stream. No caso acima através de `asStream`.

Experimente repetir a definição de 'a', mas sem a mensagem `asStream` e em seguida `a.nextN(10)`. O resultado será um array de 10 'Pseries', pois o `nextN` nesse caso nao é um método de **Stream**, mas sim de **Object**.

### 120 Patterns +

Existem mais de 120 diferentes **Patterns**, sem contar as extensões, que podem ser combinadas. O Sistema de Ajuda divide as divide em categorias assim:

* Composition (2)
* Data Sharing (6)
* Event (3)
* Filter (9)
* Function (6)
* Language Control (4)
* List (21)
* Math (13)
* Parallel (5)
* Random (13)
* Repetition (10)
* Server Control (6)
* Time (5)

Há também outras fora dessas categorias. Veja em [doc.sccode.org/Browse.html#Streams-Patterns-Events>Patterns](https://doc.sccode.org/Browse.html#Streams-Patterns-Events%3EPatterns).

Pode-se vê-las e navegar por suas documentações também por aqui: [doc.sccode.org/Overviews/Streams.html#Specific classes](https://doc.sccode.org/Overviews/Streams.html#Specific%20classes) ou no SC:

```supercollider
HelpBrowser.openHelpFor("Overviews/Streams");
```

O tutorial [A Practical Guide to Patterns - Basic Vocabulary](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.html) apresenta das 'patterns' mais frequentemente utilizadas às mais específicas e genéricas e em seguida faz a descrição funcional delas. Veja os exemplos no próprio tutorial, em [Understanding Stream, Pattern and Event - ListPattern](https://doc.sccode.org/Tutorials/Streams-Patterns-Events3.html) e/ou outros aqui em [5a_patterns.scd](5a_patterns.scd).

**Pattern** tem, entre outras, duas subclasses: **ListPatterns** e **FilterPatterns**. A primeira contém apenas uma lista (array) e número de repetições. A segunda serve para alterar os valores de outras 'patterns', ou **filtrar** valores.

## Event

[**Event**](https://doc.sccode.org/Classes/Event) é uma subclasse de [Environment](https://doc.sccode.org/Tutorials/Streams-Patterns-Events4.html#Environment), que pode ser entendido como **espaço de nomes**, uma coleção de pares nome/valor. 

### Environment

Ao fazer algo corriqueiro no SC como:

```supercollider
    // aqui um número, mas poderia ser qualquer objeto,
    // como por exemplo outro Environment
~nome = 2.5;
```

Acrescentamos o par `nome: 2.5` ao `currentEnvironment`, o que poderia ter sido feito desta forma:

```supercollider
currentEnvironment.put(\nome, 2.5);
```

Pode-se verificar o valor de `nome` assim:

```supercollider
~nome; // sim, simples assim.
```

ou

```supercollider
currentEnvironment.at(\nome); // não tão simples
```

Pode-se criar 'Environments' como espaços de nomes, mas isso não é tão usual. O uso de **Event** para o mesmo fim é mais usual, por duas razões práticas: a sua sintaxe simplificada e a sua extensa biblioteca de valores padrão, feita especialmente para fins musicais.

```supercollider
    // cria um Event na variável global 'q':
q = ();
    // veja tudo o que vem no **Event "padrao"**
Event.parentEvents.printAll
    // se vc quer ver tudo em muitos detalhes, avalie isso abaixo.
    // Nao se assuste, vc nao precisa entender como as funções aqui funcionam 
Event.default.postcs;
    // ao tentar usar o método 'play' em 'q',
    // como este não contem esse nome
    // ele o copiará do "Event padrao",
    // chamado de protoEvent, acessado com Event.default
    // junto com os valores necessários para funcionar.
q.play;
    // agora 'q' contém todos esses pares chave-valor,
    // como pode ser visto na Post window:
-> ( 'instrument': default, 'msgFunc': a Function, 'amp': 0.1, 'server': localhost, 
  'sustain': 0.8, 'isPlaying': true, 'freq': 261.6255653006, 'hasGate': true, 'id': [ 1097 ] )
  
    // se 'q' já contivesse seu próprio par com o nome 'play',
    // nada disso teria acontecido:
q = (); // sobrescreve o Event. Está de novo vazio.
x = (x: 6, y: 7, play: { (~x * ~y).postln });
x.play; // retorna 6 * 7
```

> A classe Event fornece uma grande biblioteca de instâncias de eventos padrão e funções de reprodução (***play***), por exemplo, para altura (***pitch***). Quando um 'event' é “tocado”, através da função ***play***, o seu tipo, por padrão **note** `(type: note)`, é usado para selecionar uma determinada função e um **'parent event'**.

## Pbind

As patterns das quais tratamos até aqui sao chamadas 'value patterns', porquê quando recebem a mensagem `next` retornam apenas valores. **Pbind** retorna um **Event**, portanto pertence à categoria das **event patterns**.

A **Pbind** conecta nomes a 'patterns' formando uma lista com pares 'chave-valor', concatena os nomes e valores respetivos e os inclui no “protoEvent” (o **Event padrão**), ou substitui os valores relativos se os nomes já existem.

O método `play` cria um objeto chamado **EventStreamPlayer**. O nome é autoexplicativo. Como já dito, não é a **Pbind** que vai “tocar”, porque 'patterns' são apenas as receitas, quem “tocam” são os 'streams'.

```supercollider
p = Pbind();
p.play; // cria um EventStreamPlayer, mas nao o associa a uma variável
p.stop; // tenta parar 'p', que é a Pbind

CmdPeriod.run; // equivale ao atalho Cmd + .

p = Pbind(...).play; // agora 'p' é o próprio EventStreamPlayer
p.stop; // entao ele pode ser parado
```

Ao testar o exemplo acima percebe-se de que a **Pbind** funciona mesmo estando “vazia”. Tome um instante para imaginar como isso é possível.

A resposta é que ela usa os parâmetros e funções padrão de **Event**. Perceba que o som é o mesmo de:
```supercollider
().play;
    // mude alguns dos valores padrao
( degree: 5, dur: 0.1, pan: -0.5).play;
```
O protótipo de 'event', o `Event.default`, cria um 'Synth' da 'SynthDef' chamada 'default'. Saiba mais sobre **SynthDef** e **Synth** em [dia_2_synths](../dia_2_synths)

Veja uma demonstração de como as chaves e valores em **Pbind** se modificam ao avançar um a um através da mensagem `next`:

```supercollider
(
p = Pbind(
\degree, Pseq( [0, -5, 4, 5, 6], 2),
\dur, Pseq( [0.5, 0.25, 0.125, 1, 1.5, 0.5, 1], 1)
).asStream;  // transforme em Stream para poder usar os valores 
)

// Note que é necessário passar um evento vazio para 'next', para que a Pbind tenha onde colocar os valores.
p.next(()); // () == Event.new

// output
-> a Routine
-> ( 'degree': 0, 'dur': 0.5 )
-> ( 'degree': -5, 'dur': 0.25 )
-> ( 'degree': 4, 'dur': 0.125 )
-> ( 'degree': 5, 'dur': 1 )
-> ( 'degree': 6, 'dur': 1.5 )
-> ( 'degree': 0, 'dur': 0.5 )
-> ( 'degree': -5, 'dur': 1 )
-> nil
```
Note que a Pbind avança até que o fim da 'pattern' que chega ao fim primeiro. Nesse caso a 'Pseq' em `dur`, que tem uma *array* com 7 valores e toca uma só vez. A 'Pseq' em `degree` tem uma *array* com 5 valores e repetiria duas vezes. 

### Conectar valores em Events a parâmetros em SynthDefs

Esse trecho é retirado e livremente traduzido do tutorial [A Practical Guide to Patterns / PG 03 What Is Pbind](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.html#Connecting%20Event%20values%20to%20SynthDef%20inputs)

A maioria das SynthDefs tem 'Control inputs', geralmente definidas por **argumentos** na função. Por exemplo, a SynthDef "default" (declarada em [Event.sc](https://github.com/supercollider/supercollider/blob/develop/SCClassLibrary/Common/Collections/Event.sc)) define cinco entradas: out, freq, amp, pan e gate.

```supercollider
SynthDef(\default, { arg out=0, freq=440, amp=0.1, pan=0, gate=1;
    var z;
    z = LPF.ar(
            Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3)),
            XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
        ) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
    OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}, [\ir]);
```

Quando um ***event*** toca um sintetizador, quaisquer valores nele armazenados com o mesmo nome de uma SynthDef *input* serão passados para o novo sintetizador. Compare o seguinte:

```supercollider
// Similar to Synth(\default, [freq: 293.3333, amp: 0.2, pan: -0.7])
(freq: 293.3333, amp: 0.2, pan: -0.7).play;

// Similar to Synth(\default, [freq: 440, amp: 0.1, pan: 0.7])
(freq: 440, amp: 0.1, pan: 0.7).play;
```

Isso leva a um ponto-chave: os nomes (**chaves**) que se usa para *patterns* (**valores**) na Pbind devem corresponder aos argumentos na SynthDef sendo tocada. Os nomes na Pbind determinam os nomes dos valores no Event resultante e esses valores são enviados para as entradas de controle (argumentos) correspondentes do 'Synth'.

A SynthDef a ser tocada é nomeado pela chave `instrument`. Para tocar uma *pattern* usando um Synth diferente, simplesmente nomeie-a na *pattern*.

```supercollider
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: Done.freeSelf) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;

p = Pbind(
        // Use \harpsi, nao \default
    \instrument, \harpsi,
    \degree, Pseries(0, 1, 8),
    \dur, 0.25
).play;
```

Na verdade, é uma simplificação exagerada dizer que os nomes na Pbind sempre devem corresponder aos argumentos da SynthDef a ser tocada.

Uma Pbind pode usar alguns valores no 'event' para cálculos intermediários (consulte o [Pattern Guide 06g: Compartilhamento de Dados](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.html)). Se esses valores intermediários tiverem nomes não encontrados na SynthDef, eles não serão enviados ao servidor. Não há nenhum requisito de que todos os itens num 'event' correspondam a um controle da SynthDef.

O protótipo de *event* padrão executa algumas conversões automáticas. Deve-se ter notado que os exemplos até agora usam 'degree' para especificar a altura (pitch), mas a SynthDef 'default' que é tocada não tem um argumento 'degree'. Funciona porque o evento padrão converte o 'degree' em 'freq', que é um argumento. As conversões mais importantes são para *pitch* e tempo. O tempo é simples; *pitch* é mais elaborado. Consulte o [Pattern Guide 07: Conversões de Valores](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_07_Value_Conversions.html) para obter uma explicação sobre esses cálculos automáticos.

---

Como já dito, é mais fácil entender **Patterns** na prática do que na teoria. Abra [5a_patterns.scd](5a_patterns.scd) no SuperCollider e teste os exemplos que lá estão. Eles acompanham o conteúdo encontrado aqui e vao além, com casos específicos, combinações de 'patterns' e estudos de caso. Muito compilado, copiado e/ou adaptado dos tutoriais e guias encontrados no Sistema de Ajuda do SC cujos 'links' e citações estão distribuídos por esse texto.

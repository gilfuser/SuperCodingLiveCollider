# SynthDef

A definicão de sintetizador é encontrada em toda parte nos códigos SC. É através dela que se cria sons que podem ser reutilizados e usados em Patterns, que é assunto para outro dia.



Quanto testamos sons com funções, por trás das cortinas o SC criou SynthDefs, por causa do método `.play`.

Assim isso:

`{ SinOsc.ar }.play;`

Virou isso:

`SynthDef.new( "temp__0", { Out.ar(0, SinOsc.ar ) } ).play;`

Ao executar aquilo vê-se isso:

`-> Synth('temp__0' : 1003)`

Mostra que foi criado um sintetizador no servidor de som.

A SynthDef é composta por um nome ("temp__0" no caso acima) e uma função (especificamente uma ugenGraphFunc) que *tem que ter por último* uma UGen do tipo **Out**. Se usar taxa de áudio, ou *áudio rate* (.ar) produzirá som, se for (*control rate*) poderá ser usada para modular algum parâmetro, por exemplo. Mais sobre *rates* em instantes.

SynthDefs servem para instruir o servidor de som sobre como produzir sons ou sinais de som. Conceitos de programação como comandos de decisão (`if true { faca isso } {se nao, isso }`) POO (Programação Orientada ao Objeto) nao fazem o menor sentido para o servidor. Por isso nao é possível usar `ifs` e outros recursos de programação dentro de SynthDefs, mas sim é possível usá-los para criar os Synths a partir delas.

## Synth

A realização, a materialização de uma **SynthDef**. Análogo, a uma **instância** de uma **classe**

### Exemplo minimalista da criação de um Synth, ou seja, um sintetizador

#### A receita

```supercollider
SynthDef.new(\exemplo, { Out.ar(0, Saw.ar) }).add;
```
#### O bolo

```supercollider
Synth.new(\exemplo);
```

Pare o som com `Cmd + .` <br/>

#### As partes

`.new` é o método… para criar. Pode ser omitido.

`/exemplo` é a chave, um nome. Pode ser um símbolo, como aqui denotado pelo `\ ` ou um *string* como em `"exemplo"`

`,` separa as partes e `{}` delimitam uma função.

`Out` cria um sinal em um **bus**, que é um canal, de áudio (o esquerdo e direito do seu boombox, por exemplo), ou de dados (OSC)

`.ar` **audio rate** A UGen **Out** enviará mensagens a uma taxa compatível com sinais de áudio digital. Por padrão 44100 por segundo.

`0` indica que os sinais serão enviados para o bus 0, por padrão, o canal esquerdo do sinal estéreo.

`Saw.ar` é o gerador do sinal a ser enviado. Ondas em formato dente-de-serra, também em *audio rate* usando os valores padrão de amplitude e frequência.

`.add` adiciona a SynthDef a uma “coleção” de SynthDefs que ficam armazenadas na memória para que se crie tantos sintetizadores quanto necessário a partir de cada SynthDef.

continua... (acessar através de variáveis, envelopes, Done actions)

---

#### Veja mais explicações nos exemplos práticos (.scd). Se sentir falta de algo, por favor diga em [Discussões](https://github.com/gilfuser/SuperCodingLiveCollider/discussions)


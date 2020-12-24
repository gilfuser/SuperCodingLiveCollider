// Intro ao SuperCollider

// NOTA:
Há muito a ser dito. Mesmo para uma introdução.
Ao final de cada parte há um "saiba mais em" que leva a alguma documentação do próprio sistema de ajuda.
Use essas indicações se tiver especial curiosidade sobre o assunto, se não, siga em frente.

* uma linguagem de alto nível modelada em Smalltalk
* feita para música / síntese e controle de som,
  gráficos simples
  GUIs baseadas em Qt

* comunicação por OpenSoundControl, MIDI, HID, Serial
[conexão : OSC = OpenSoundControl = protocolo UDP]

///////////////////////////////////////////////////////////////

		Os Dois Mundos em SC3:

SClang			-		SCServer

(Lang, client)

texto / código  -       som
discreto        -       contínuo
números         -       sinais
dados           -       buffer
agendamento     -       envelopes
objetos         -       geradores de unidades (UGen)
mensagens       -       patching

saiba mais em:
HelpBrowser.openHelpFor("Guides/ClientVsServer")

//////////////////////////////////////////////////////////////

Atalhos Importantes

Cmd -> Mac == Ctrl -> Win/Linux
Return == Enter

Shift + Return // avaliar uma linha. USE PARA TESTAR OS EXEMPLOS!

Cmd + Return // avaliar um bloco. Pode ser texto selecionado ou...

// colchetes permitem fácil seleção e escopo
(
(1,5 + 2,25).postln; // clique em qualquer lugar entre os parenteses e Cmd + Return
10 + 20;
4567;
"Oooooi!".postln;
1 + 3; // o ponto-vírgula tem que vir no final de cada linha quando uma outra abaixo for executada no mesmo comando.
().class;
)

().play


Cmd + . // Panic Button (Pára o som e outros processos)

Cmd + B // inicia o servidor. É igual a
s.boot;

Documentação
Cmd + D // com o cursor sobre a palavra
Cmd + Shift + D // abre janela onde se insere o termo.

Cmd + Shift + P // limpa a post window

Cmd + / // comenta e descomenta uma linha, ou uma parte selecionada *
*
// COMENTÁRIOS!
// Coisas que não fazem nada - exceto dizer aos leitores o que está acontecendo

// tudo à direita de "//" é um comentário, não um código

(
/*
tudo entre "/ *" e "* /" também é
um comentário e pode ter várias linhas
*/
123 / 456
)

Cmd + Shift + Espaço
Clique entre os parênteses onde vao os argumentos de um objeto para saber quais são.
teste aqui:
SinOsc.ar(   )

///////////////////////////////////////////////////////////////

* tudo é um objeto, tudo é uma classe POO (Programação Orientada ao Objeto)

* os objetos entendem mensagens
// Coisas a serem feitas = Métodos (Methods): (menssagens) diga a um objeto para fazer algo

objeto.menssagem(argumento); // "argumento" no SC é mesmo que um parâmetro

1.dump;
[0, 2, 3, 4].dump;
4.squared;
[0, 2, 3, 4].squared;
1000.postln;
s.dump	// o servidor de som

* muitas variantes de sintaxe suportadas
(argumentos posicionais ou de palavra-chave, notação funcional)

pi.sin;
sin(pi);
101 div: 2;
101.div(2);
div(101, 2);

//////////////////// Objetos Comuns ///////////////////////////

********* Números **********

// Números (integers = números inteiros, Float = frações, ... outros)

1
1.618034
pi // execute essa linha e veja na Post Window, no canto inferior direito
0.5pi

// Números entendem muitas operações matemáticas:

1 + 2;
1 + 2.0;
3 / 4;
13 % 5;
1 + 2 * 4; // executado sempre da esquerda para a direita
(1 + 2) * 4; // na dúvida use parênteses
1 + (2 * 4); // forçar da direita para a esquerda

2 ** 3;
2 ** 0.5;
2.sqrt;
2 ** (1/3);

// algumas operações matemáticas:
+, -, *, /, pow:, mod:, e muito muito mais

saiba mais em:
"Operators".help
SimpleNumber.help


************* Character, String, Symbol ******************

// Character, ou Char vem prescedido de "$"

$g
$g.ascii
$g.dump

// Strings são textos (feitos de Chars) entre aspas

"abcde".dump;
"abcde".at(3);
"abcde"[3]; // same as at
"abcde".scramble;
"abcde".reverse;

// Symbols sao String fixas. tem essas duas formas:

\isso == 'isso'

************         Coleções          ******************

// Arrays vêm entre colchetes.
// podem misturar todo tipo de coisa

[ "lala", 1, 1.5, \istoSim, pi, ().play ]

// acesse casa elemento pelo seu índice (posição na array)

[ "lala", 1, 1.5, \istoSim, pi, ().play ][2]
ou:
[ "lala", 1, 1.5, \istoSim, pi, ().play ].at(2) // teste outros números

* coleções tem muitos métodos, entendem muitas mensagens

[1, 2, 3].do { |el| el.postln };

[1, 2, 3] * 10;
[1, 2, 3] * [100, 200, 300];
[1, 2, 3] * [100, 200]; // expande segundo a lista mais longa
[1, 2, 3] *.t [100, 200]; // expande segundo uma matriz
[1, 2, 3].collect { |el, i| el * i }; // "el" e "i" sao argumentos que passam para a funcao o valor e o índice
( a: 1, b: 2, c: 3, d: 4).select(_.even);
(1..10).reject { |el| el % 3 == 0 };

1 + [ 2, 1.5 ];
1 ++ [ 2, 1.5 ]; // erro
[ 2, 1.5 ] ++ 1; // agora sim
// estritamente da esquerda para a direita[1, 2, 3] + 100 * [4, 5, 6];
[1, 2, 3] + (100 * [4, 5, 6]);
[1, 2, 3, 4].squared;
[1, 2, [3, 4]].squared; // listas podem ser aninhadas em listas

List[ 1, 2, 3 ];

// Set é um tipo de coleção desordenado, que nao admite repetiçoes.
Set[1, 2, 3, 1];

// Dictionaries (Dictionários), na verdade Eventos (Events): coleção de pares chave-valor
(a: 1, b: 2, c: 3);

-- saiba mais em:
Array.help;
List.help
Dictionary.help;
Event.help;
-- visao geral:
HelpBrowser.openHelpFor("Overviews/Collections")

// Para acessarmos coleçoes mais de uma vez precisamos armazená-las em...


//////////////////////// Variáveis ////////////////////////////////

    (Variables) Variáveis: Nomes para Coisas
    (Assignment) Atribuição: nome = objeto
    (Expression) Expressão: nome = objeto.menssagem(argumento);

As regras para todas as variáveis sao:
Nao é permitido:
* comecar com letra maiúscula
* comecar com número
* comecar com símbolos
É permitido:
* números, símbolos e letras maiúsculas no corpo do nome

************      variáveis locais       ******************

// em um escopo específico, em um bloco de texto como abaixo, ou uma função
(
var abc = 13; // Cmd + Return aqui
abc + 100;
)

************* variáveis globais: a - z ********************

// são as mais simples

a; // retorna nil porque ainda nao contém nada
a = 42;
b = 100;
c = a + b;
this.dump;

a = b = c = d = nil;

// NOTA!
evite usar a letra "s" pois é em geral usada para acessar o objeto Server

// PRÓS,
    elas permanecem até que você as altere,
    para que você possa continuar brincando com elas!
    "Programação de conversação" (ou "Programação interativa")

// CONTRAS:
    existem apenas 26 letras
    elas são difíceis de lembrar
    se vários programas usam os mesmos poucos nomes: confusão

    Solução para apenas 26: variáveis de ambiente...

*********** variáveis global(em um certo ambiente) ~nome **************

zahl1 = 23;	// erro
~zahl1 = 23;

~zahl1 + ~zahl2; // erro
~zahl2 = 100;

~zahl1 + ~zahl2;

~zahl1
~zahl2.dump

saiba porquê não sao exatamente globais aqui:
Environment.help;

Há uma terceira opção de variáveis que utilizam propriedades do objeto Event. Veja a seguir:

//////////////////////////////////////////////////////////////////

******************* Event *********************

().class

q = (); // dê um nome para poder acessá-lo

// para nao perder acidentalmente o conteúdo de q ao redefeni-lo.
q = q ? (); // a = a ? b significa: se a não for 'nil' a = a (ou seja, nada muda), se a for sim 'nil' a = b
* saiba mais em:
HelpBrowser.openHelpFor("Overviews/SymbolicNotations");

q[\myNumber] = 12;
q.myNumber = 12;		// em estilo mensagem
q.myNumber;

q.blip;
q.blip = { { Blip.ar * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };

q[\blip]; 	// a Function
q.blip;		// ... é executado!

q.blip = { |ev| ev.postln; { Blip.ar * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };
q.blip;		// posta o pseudo-object primeiro...

q.blip = { |ev| ev.postln; { Blip.ar(200, ev.myNumber) * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };
q.blip;		// usa a variável contida no objeto


// Com Event pode-se fazer objetos em tempo real através da adição de estado e comportamento!

q = ();
q.syndefs = ();
q.syndefs.karl = SynthDef(...);


********************** Functions *************************

Funções:
    preparar coisas para fazer em algum momento,
    faça-os mais tarde, geralmente várias vezes

f = { 10.rand };
f; // retorna o que é f: a Function
f.value;
			// polimorfismo
			// integer.rand cria um número inteiro aleatório
			// - float.rand cria float aleatório
f = { 10.0.rand };
f.value;
			// calcular com funções
g = f + 100;
g.value;

~func = { 12.squared }; // define o que fazer

~func.value; // agora faça isso
~func.value; // quantas vezes você quiser

~func = {5.rand}; // talvez mais interessante - resultados diferentes a cada vez

~func.value; // agora faça isso
~func.value; // quantas vezes você quiser

[~func.value, ~func.value, ~func.value]; // lista de 3 números aleatórios

// maneiras de fazer isso de forma mais flexível:
~my3numbers = Array.fill(3, ~func);
3.collect(~func);
~func.dup(3);
~func ! 3;

~my3numbers

Funções geralmente têm "argumentos":
algo que entra na função para controlar o que acontece. Parâmetros.
Uma Interface, uma Janela, um Canal_de_comunicação da função com o mundo fora dela

~square = { arg num; num * num };

~square.value;	// falha
~square.value(2);
~square.value(4);

	// "valores padrão": se não for passado ao chamar, use o padrão
(
~square = {
    arg num = 0;
    "whatever u want".postln;
    num * num;
};
)

~square.value;	// não falha
~square.value(9);

* saiba mais em:
Function.help

************  Boolean - true or false *************

1 > 2
2 > 1
12 == 12
1 <= 2
1 >= 2
(1 < 2) && (3 > 4) // isto E aquilo
(1 < 2) and: (3 > 4)
(1 < 2) || (3 > 4) // isto OU aquilo
(1 < 2) or: (3 > 4)


if (12 == 12) { "jaaaaaa".postln } { "oh nein.".postln };

if (6 == 9) { "jaaaaaa".postln } { "oh nein.".postln };
(
if ( 11.rand.postln > 5,
    "jaaaaa",
    "NEIN!"
)
)

* veja mais em:
HelpBrowser.openHelpFor("Reference/Control-Structures")

//////////////////////////////////////////////////////////////////

Por enquanto é só. No próximo episódio:

Primeiros SONS!

bem mais divertido
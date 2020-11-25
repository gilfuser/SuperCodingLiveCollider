

// ******* Objetos úteis comuns em SC: *********** //

// Números (integers = números inteiros, Float = frações, ... outros)

1
1.618034
pi
0.5pi

// pergunta - adicionar frações e inteiros?

1 + [ 2, 1.5 ];

// Números entendem muitas operações matemáticas:

1 + 2; //
3 / 4; //
1 + 2 * 4; // avaliado da esquerda para a direita
1 + (2 * 4); // na dúvida, coloque os parênteses

// algumas operações matemáticas:
+, -, *, /, pow:, mod:, e muito muito mais

veja em:
"Operators".help


// Coisas que não fazem nada - exceto dizer aos leitores o que está acontecendo
// COMENTÁRIOS!

// tudo à direita de "//" é um comentário, não um código
(
/* tudo entre "/ *" e "* /" também é
um comentário e pode ter várias linhas
*/
123 / 456
)

2 ** 3; //
2 ** 0.5; //
2.sqrt;
2 ** (1/3); //


O número pode assumir muitos significados,
dependendo de para que são usados:
frequências, cores, formas geométricas, qualquer coisa.


Tratamento:
intérprete orientado a texto

// interpretar linha ou área destacada (cmd-enter)
1 + 2;
[0, 2, 3, 4] + 3;

// tudo é um objeto e entende as mensagens
1.dump;
[0, 2, 3, 4].dump;
4.squared;
[0, 2, 3, 4].squared;

// colchetes permitem fácil seleção e escopo
(
(1,5 + 2,25).postln; // adicione .postln aqui
10 + 20;
4567;
)

// todas as operações matemáticas aqui:
SimpleNumber.help

////////////////////////////////////////////////////////////////


Orientação a objetos:
Tudo é um objeto (números, ...)
Os objetos recebem mensagens que lhes dizem o que fazer
se eles entenderem as mensagens, geralmente conseguem fazê-las.


// Coisas que te ajudam: Erros!
// continue respirando
// e leia as primeiras 5 linhas ...
1 + 12 				// error!
1 +-@ 2				// error

1 < 2				// retorna um booleano ...

// Coisas a serem feitas = Métodos (Methods): (menssagens) diga a um objeto para fazer algo

1000.postln;
1000.dump;
s.dump	// o servidor de som

10.00.dump;
1.23.dump;

10.squared

10.suqraed		// Error

1.asBinaryDigits
2.asBinaryDigits
3.asBinaryDigits
10.asBinaryDigits

2.0.dump
4.0.dump
-1.0.dump
1.0.dump

////////////////////////////////////////////////////////////////

// Collections, Arrays, Lists, Dictionaries
// Coleções, matrizes, listas, dicionários

Array.help;
List.help
Collection.help;
Dictionary.help;
Event.help;

[ 1, 2, 3 ];
[ 1, 2, 3 ].dump;

List[ 1, 2, 3 ];

(a: 1, b: 2, c: 3);

// listas (arrays) também são objetos
[1, 2, 3, 4].squared;
[1, 2, [3, 4]].squared; // listas podem ser aninhadas em listas

// estritamente da esquerda para a direita[1, 2, 3] + 100 * [4, 5, 6];
[1, 2, 3] + (100 * [4, 5, 6]);

Coleções (Collections) entendem toda a matemática que os números entendem:
[1, 2, 3] * 10;
[1, 2, 3] * [100, 200, 300];
[1, 2, 3] * [100, 200]; // expande segundo a lista mais longa
[1, 2, 3] *.t [100, 200]; // expande segundo uma matriz



// Characters, Strings, Symbols
$a.dump
"abcde".dump;
"abcde".at(3);
"abcde"[3]; // same as at
"abcde".scramble;
"abcde".reverse;

// symbols are like fixed strings ...
// two ways to write symbols
'abcde' == \abcde;
// they are used in many places for looking things up by name
~dict = ('a': "eiou", 'e': "aiou");
~dict['a'];


////////// how about remembering every bit of code we run?
History.start;
History.makeWin;
History.logFolder.openOS;

1 + 2 * 3;
"abcde".scramble;


//////////////////////// Variáveis: ///////////////////////////////


    (Variables) Variáveis: Nomes for Coisas
    (Assignment) Atribuição: <nome> = <algo>
    (Expression) Expressão: <coisa1> <façaAlgo> (coisa2) ...

	// as variáveis mais simples são globais: a - z

a = 42;
b = 100;
c = a + b;
this.dump;

a = b = c = d = nil;
thisProcess.recompile;

if (c == 142) { "jaaaaaa".postln } { "oh nein." };

     a - z são "variáveis globais":

// PRÓS,
    elas permanecem até que você as altere,
    para que você possa continuar brincando com eles!
    "Programação de conversação" (ou "Programação interativa")

// CONTRAS:
    existem apenas 26 letras
    eles são difíceis de lembrar
    se vários programas usam os mesmos poucos nomes, confusão

    Solução para apenas 26: variáveis de ambiente! ~<nome>

zahl1 = 23;	// error
~zahl1 = 23;	//
~zahl1 + ~zahl2;
~zahl2 = 100;
~zahl1 + ~zahl2;

~zahl1
~zahl2

(
var abc = 13;
abc + 100;
)


Variáveis tipificadas: (Typed variables) em muitas linguagens, deve-se declarar que tipo de objeto
pode ser atribuído a uma variável, por exemplo em Processing:

int num1 = 12;
float num2 = 34.56;

    Vantagem - o programa pode saber se um algoritmo funcionará
        (se os tipos estiverem corretos, por exemplo, multiplicar funcionaria)
    Desvantagem: se algo acontecer com números, matrizes, padrões,
        e outras coisas, deverá haver variantes diferentes para cada
        operação usada. então, mais trabalho de programação

    Compensação entre flexibilidade e risco de falha quando o programa é executado

(
var otto;
otto = 123;
"otto é agora: ".post; otto.postln;
otto = [123, 234,345];
"otto é agora: ".post; otto.postln;
otto = "eu sou uma string...";
"otto é agora: ".post; otto.postln;
)
otto = 6; 		// error!

Expressao:
sintaxe: variável = objeto.menssagem(argumento);

a = [1,2,3,4, 2].min(2.5);

a * 100;

// De volta às listas. Array nesse caso ///////////////////////////////////////////

~list = [ 1, 2, 3, 5 ];
~list.dump;
~list.at(0);  // at índice comeca com 0
~list.last;
~list.scramble;
~list.size;
~list.do { |element| element.postln };
~list.collect { |element| element.squared };

~list + 100; // torna-se uma coleção automagicamente

~list2 = ~list.collect { |element| element.squared };

~list
~list2

// e se digitarmos incorretamente ou dermos um comando que não existe?
~list.glitch;
///   DoesNotUnderstandError ...
// ERROR: Message 'glitch' not understood.
// RECEIVER:
// nil

x = Pseq([1,2,3]);
z = x.squared.asStream;
z.next;

// currentEnvironment
~myNumber = 12;

// dictionaries, or actually Events:
q = ();
q[\myNumber] = 12;
q.myNumber = 12;		// in message style
q.myNumber;
q.know_(false);
q.myNumber;			// error, redirection of doesNotUnderstand is turned off
q.know_(true);
q.myNumber;			// returns myNumber as if it were an instance variable

q.blip;
q.blip = { { Blip.ar * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };

q[\blip]; 	// a function
q.blip;		// ... is executed!

q.blip = { |ev| ev.postln; { Blip.ar * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };
q.blip;		// posts the pseudo-object first...

q.blip = { |ev| ev.postln; { Blip.ar(200, ev.myNumber) * XLine.kr(1, 0.01, 0.5, doneAction: 2) }.play };
q.blip;		// uses the object's instance variable


// Can make objects on the fly by adding state and behavior!

IdentityDictionary:doesNotUnderstand

q = ();
q.syndefs = ();
q.syndefs.karl = SynthDef(...);

Functions
Funções:
    preparar coisas para fazer em algum momento,
    faça-os mais tarde, geralmente várias vezes

Function.help


f = { 10.rand };
f.value;
			// polimorfismo
			// integer.rand cria um número inteiro aleatório
			// - float.rand cria flutuador aleatório
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
// perl:
	http://en.wikipedia.org/wiki/There\'s_more_than_one_way_to_do_it

Funções geralmente têm "argumentos":
algo que entra na função para controlar o que acontece.

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

~square.value;	// nao falha
~square.value(9);

////////////////////////

// Syntax colorize helps -
"Syntax Shortcuts".help;

///////////////////////

Boolean - true or false

1 > 2
2 > 1
12 == 12
if (12 == 12) { "jaaaaaa".postln } { "oh nein.".postln };

if (6 == 9) { "jaaaaaa".postln } { "oh nein.".postln };

////////////////////////////////////////////////////////

	Char(acters): letras simples, tecla pressionada

$a.dump
$a.ascii		 // converta para um número!
97.asAscii.dump; // converte o número de volta para ascii


O que é "Olá, mundo!" realmente?

"Olá, mundo!".dump;

"Olá, mundo!"[0].dump;

"Olá, mundo!".collect { arg char; char.ascii }; // falha, apenas caracteres permitidos em Strings

"Olá, mundo!".as(Array);
"Olá, mundo!".as(Array).postcs; // poste como string de compilação, ou seja, como código!

"Olá, mundo!".as(Array).collect { arg char; char.ascii }; // funciona


//////	Object Modelling

In fully dynamic languages (like Smalltalk), one can add Classes,
add/Change methods etc. at any time - live system (also Self).

concepts and objects co-evolve -> fluid working style called for.


////// Object Orientation, Behavior, and Polymorphism

An object is its behavior - behavior is what really matters!
Duck typing...

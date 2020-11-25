# JITLib

"Passageiro para motorista de táxi: leve-me ao número 37.
Eu darei a você o nome da rua quando chegarmos lá."

// try installing the most popular quark:
(
if ( Quarks.isInstalled("JITLibExtensions").not )
{ Quarks.isInstalled("JITLibExtensions") };
)

////////////////////////////////////////////////////////////////////////

... dê uma olhada em
"Overviews > JITLib"
HelpBrowser.openHelpFor("JITLib")

Proxies: Just In Time Programming
 			// = replaceable placeholders

* Flexibilidade na criacao de Synths e rotas de sinal
* Sintaxe simplificada
* Uso de Proxy, um marcador de espaco. Representa algo que ainda nao existe.
    para coisas como:
			Synths -> Ndef (NodeProxy, ProxySpace)
 			Tasks -> Tdef
            Patterns -> Pdef

Ndef, NodeProxy: placeholder (marcador de posicao) para processos de síntese.

s.boot;	// needs booted server

x + y // erro

x = NodeProxy.new;
y = NodeProxy.new;

x + y // viu? -> a BinaryOpPlug

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

"jitlib_basic_concepts_01".help;
veja "NodeProxy, ProxySpace, Ndef"

Por preferência pessoal vamos usar aqui o estilo Def
# JITLib

## Biblioteca de programação Em Cima da Hora

"Passageiro para motorista de táxi: leve-me ao número 37.
Darei a você o nome da rua quando chegarmos lá."

```supercollider
  // complete o pacote
  // instale isso (caso ainda nao o tenha feito):
  (
  if ( not(Quarks.isInstalled("JITLibExtensions")) )
  {
  Quarks.install("JITLibExtensions");
  thisProcess.recompile;
  };
  )
```

Máxima flexibilidade no SuperCollider.

JITLib é sobre *proxies*. Note que usamos mais frequentemente `Ndef`, `Tdef`, `Pdef` e `Pdefn`. Essas classes têm equivalentes que poderiam, com algumas diferenças sintáticas serem usadas. A saber:

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

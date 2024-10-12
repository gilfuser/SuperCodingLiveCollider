# Instalação do SuperCollider

#### O SC funciona em macOS, Linux e Windows, incluindo em computadores de placa única como Raspberry Pi e BeagleBone Black

Baixe aqui: [supercollider.github.io/downloads](https://supercollider.github.io/downloads)

Felizes utilizadoras de Mac e Windows podem simplesmente usar as versões já compiladas encontradas no *link* acima. Já utilizadoras de Linux terão que compilar por si mesmas.

Pessoas com a experiência necessária, ou aventureiras, têm a opção de fazer o *build* direto do repositório aqui: [github.com/supercollider/supercollider](https://github.com/supercollider/supercollider)

As questões específicas dos sistemas operacionais citados acima são tratadas nos *links* a seguir. <br/>
**Leia, por favor, a página referente ao seu sistema operacional:**
* [Linux](https://github.com/supercollider/supercollider/blob/develop/README_LINUX.md)
* [macOS](https://github.com/supercollider/supercollider/blob/develop/README_MACOS.md)
* [Windows](https://github.com/supercollider/supercollider/blob/develop/README_WINDOWS.md)

## Teste a instalação

Após instalar e abrir o SCIDE você estará frente ao paradigma da página em branco, de (quase) infinitas possibilidades.

### A primeira coisa a fazer é se certificar de que o servidor de som funciona:

Inicie o servidor: <br/>
execute* `s.boot` ou pressione `Ctrl + B`**.

*Na programação, executar é o processo de ler e agir de acordo com as instruções escritas em um programa. No SC faça isso posicionando o cursor na linha da instrução e pressione `Shift + Return`, ou, se a instrução tiver várias linhas, deixe o cursor em alguma delas e pressione `Ctrl + Return`.<br/>
** No decorrer do texto indicarei apenas `Ctrl`. Pessoas com Macs devem ler `Cmd`.

se deu certo verá que o que era branco assim: <br/>
![servidor antes de ligar](../img/servidor-antes.png)

ficou verde assim: <br/>
![servidor ligado](../img/servidor-depois.png)

Aí é só executar essa linha:<br/>
`().play`

e ouvirá o dó central do piano.

Se isso não acontecer, leia o que aparece na **post window**. Se não aparecer nenhuma explicação convincente, [conte aqui](https://github.com/gilfuser/SuperCodingLiveCollider/discussions) e tentaremos descobrir o porquê.

## Quarks

Do sistema de Ajuda:
> Quarks são pacotes de código SuperCollider contendo classes, métodos de extensão, documentação e plug-ins UGen de servidor. A classe Quarks gerencia o download desses pacotes e a instalação ou desinstalação.
 
Em termos simples, **Quarks** são partes extra que expandem as capacidades do SC. Há também plugins, os SC3-Plugins, que têm um papel semelhante, mas isso não vem ao caso agora.

Instalemos os **Quarks** de que vamos precisar mais adiante.

Pode-se ver todos os Quarks existentes ao executar `Quarks.gui`, baixar e instalar a partir da janela então aberta, ou instalar diretamente ao executar as seguintes linhas, que você pode copiar daqui e colar no SCIDE:

```supercollider
Quarks.install("adclib");
Quarks.install("Bjorklund");
Quarks.install("JITLibExtensions");
Quarks.install("HyperDisCo");
Quarks.install("Influx");
Quarks.install("KtlLoop");
Quarks.install("Modality-toolkit");
Quarks.install("StartupFile");
```

Em seguida tem-se que recompilar a biblioteca de classes. Vá em **Language > Recompile Class Library**

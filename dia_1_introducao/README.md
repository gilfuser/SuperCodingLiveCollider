# Introdução
**Se seu SuperCollider já está instalado e funcionando, abra os arquivos `.scd` e teste-os. Veja abaixo os conceitos básicos e algumas dicas importantes (que estão também nos arquivos `.scd`) para se começar a explorar o SC**

## O SuperCollider é composto por três componentes principais

### scsynth

Um servidor de áudio em tempo real, forma o núcleo da plataforma. Possui mais de 400 geradoras de unidades (“UGens”) para análise, síntese e processamento. A sua granularidade permite a combinação fluida de muitas técnicas de áudio conhecidas e desconhecidas, movendo-se entre a síntese aditiva e subtrativa, FM, síntese granular, FFT e modelagem física. Pode-se escrever as próprias UGens em C++, e a comunidade de utilizadoras já contribuiu com várias centenas de outras para o repositório de plugins sc3.

### sclang

Uma linguagem de programação interpretada. É focado no som, mas não se limita a nenhum domínio específico. **sclang** controla o **scsynth** via **Open Sound Control**. Pode-se usá-lo para composição e sequenciamento algorítmico, encontrando novos métodos de síntese de som, conectar o seu aplicativo a um equipamento físico externo, incluindo controladores MIDI, música em rede, escrevendo GUIs e exibições visuais ou para os seus experimentos de programação diários. Ele tem um estoque de extensões fornecidas pela utilizadora, chamadas Quarks.

### scide

É um editor para sclang com um sistema de ajuda integrado.

> O SuperCollider foi desenvolvido por James McCartney e originalmente lançado em 1996. Em 2002, ele generosamente o lançou como software livre sob a GNU General Public License. Agora é mantido e desenvolvido por uma comunidade ativa e entusiasta

conteúdo extraído do website [supercollider.github.io](https://supercollider.github.io/)

> **NOTA:** Há a possibilidade de usar o SC sem a SCIDE, mas deixemos isso para um momento futuro.

## Atalhos Importantes

Nos Macs há a tecla `Cmd`, que é equivalente ao `Ctrl` dos Linux e Windows. Para ser breve (e por motivos históricos), direi aqui apenas `Cmd`, mas leia `Ctrl` se esse for o seu caso. <br/>
`Enter` e `Return` aqui também sao equivalentes.<br/><br/>


|      atalho     |                           efeito                          |
|-----------------|-----------------------------------------------------------|
| Cmd + b         |     Inicia o servidor de som. É o mesmo que `s.boot`      |
|  Shift + Return |        executa uma linha (use para testar exemplos)       |
|   Cmd + Return  |          executa um bloco, ex. entre parêntesis           |
|     Cmd + .     |   **Panic Button!** interrompe o som e outros processos   |
| Cmd + d <br/>(sobre uma palavra) | abre a referência sobre a palavra no sistema de ajuda |
| Cmd + Shift + d |   abre uma janela onde se insere um termo a ser buscado   |
| Cmd + Shift + p |                  limpa a **post window**                  |
|  Cmd + /  |Comenta ou *descomenta* uma linha ([saiba mais](./1a_introducao.scd))|
| Cmd + Shift + Espaço |     mostra os parâmetros (argumentos) de uma UGen    |

Esses e outros atalhos podem ser encontrados no menu **Edit / Preferences** e então em **Shortcuts**. Pode-se até criar os próprios atalhos.

## Saiba mais

O tutorial "Getting Started" no Sistema de Ajuda tem tudo o que é mostrado aqui e mais. É um ótimo ponto de partida.

Acesse diretamente do SCIDE <br/>
`HelpBrowser.openHelpFor("Tutorials/Getting-Started/00-Getting-Started-With-SC");` <br/>
ou do navegador [aqui](https://doc.sccode.org/Tutorials/Getting-Started/00-Getting-Started-With-SC.html).
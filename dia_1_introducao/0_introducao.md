# Introdução

> SuperCollider é uma plataforma para síntese de áudio e composição algorítmica, usada por músicos, artistas e pesquisadores que trabalham com som. É um software gratuito e de código aberto disponível para Windows, macOS e Linux

## O SuperCollider apresenta três componentes principais

## scsynth

um servidor de áudio em tempo real, forma o núcleo da plataforma. Possui mais de 400 geradoras de unidades (“UGens”) para análise, síntese e processamento. Sua granularidade permite a combinação fluida de muitas técnicas de áudio conhecidas e desconhecidas, movendo-se entre a síntese aditiva e subtrativa, FM, síntese granular, FFT e modelagem física. Você pode escrever suas próprias UGens em C ++, e a comunidade de usuárias já contribuiu com várias centenas de outras para o repositório de plug-ins sc3.

## sclang

uma linguagem de programação interpretada. É focado no som, mas não se limita a nenhum domínio específico. **sclang** controla o **scsynth** via **Open Sound Control**, Você pode usá-lo para composição e sequenciamento algorítmico, encontrando novos métodos de síntese de som, conectando seu aplicativo a hardware externo, incluindo controladores MIDI, música em rede, escrevendo GUIs e exibições visuais ou para seus experimentos de programação diários. Ele tem um estoque de extensões fornecidas pelo usuário chamadas Quarks.

## scide

é um editor para sclang com um sistema de ajuda integrado

> O SuperCollider foi desenvolvido por James McCartney e originalmente lançado em 1996. Em 2002, ele generosamente o lançou como software livre sob a GNU General Public License. Agora é mantido e desenvolvido por uma comunidade ativa e entusiasta

conteúdo extraído do website [supercollider.github.io](https://supercollider.github.io/)
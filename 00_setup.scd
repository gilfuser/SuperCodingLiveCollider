// cria um dicionário que contém pares nome-coisa, ou mais corretamente chave-valor
q = q ? ();

q.thisfolder = q.thisfolder ?? { thisProcess.nowExecutingPath.dirname };

"libs/_SynthLib.scd".loadRelative;
/*
"libs/_SynthLib.scd".resolveRelative.openOS;
*/
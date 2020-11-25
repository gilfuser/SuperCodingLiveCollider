# SynthDefs para TidalCycles

( Platform.userAppSupportDir ++ "/downloaded-quarks/SuperDirt/synths/default-synths.scd").openDocument
( Platform.userAppSupportDir ++ "/downloaded-quarks/SuperDirt/synths/tutorial-synths.scd").openDocument

VideoTutorial Eris Fairbanks

https://www.youtube.com/watch?v=qZKDI8sVy8Q

SynthDef(\test, {
    arg out, sustain = 1, freq = 440, speed = 1, begin = 0, end = 1, pan, accelerate, offset, clamp = 1;
    var line, env, volume, tone, outAudio;
    freq=freq*speed;
    line = Line.ar(begin,end,sustain/speed,doneAction: Done.freeSelf);
    env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
    volume = IEnvGen.ar(env, line);
    tone = (Pulse.ar(freq,line)+Pulse.ar(freq*1.01,line)+Pulse.ar(freq*0.99,line))/3;
    outAudio = RLPF.ar(tone*volume, 20000*clamp*volume,0.3);
    OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;
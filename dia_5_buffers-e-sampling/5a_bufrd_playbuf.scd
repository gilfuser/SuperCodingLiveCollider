Buffers e Sampling


# PlayBuf

// read a whole sound into memory
// note: not *that* columbia, the first one
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // remember to free the buffer later.

SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: Done.freeSelf)
    )
}).play(s, [\out, 0, \bufnum, b]);

// loop is true
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1.0)
    )
}).play(s, [\out, 0, \bufnum, b]);


// trigger one shot on each pulse
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var trig;
    trig = Impulse.kr(2.0);
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, 0, 0)
    )
}).play(s, [\out, 0, \bufnum, b]);


// trigger one shot on each pulse
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var trig;
    trig = Impulse.kr(XLine.kr(0.1, 100, 30));
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, 5000, 0)
    )
}).play(s, [\out, 0, \bufnum, b]);


// mouse control of trigger rate and startpos
SynthDef(\help_PlayBuf, { arg out=0, bufnum=0;
    var trig;
    trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
    )
}).play(s, [\out, 0, \bufnum, b]);


// accelerating pitch
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var rate;
    rate = XLine.kr(0.1, 100, 60);
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, 1.0, 0.0, 1.0)
    )
}).play(s, [\out, 0, \bufnum, b]);


// sine wave control of playback rate. negative rate plays backwards
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var rate;
    rate = FSinOsc.kr(XLine.kr(0.2, 8, 30), 0, 3, 0.6);
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1, 0, 1)
    )
}).play(s, [\out, 0, \bufnum, b]);


// zig zag around sound
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var rate;
    rate = LFNoise2.kr(XLine.kr(1, 20, 60), 2);
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1, 0, 1)
    )
}).play(s, [\out, 0, \bufnum, b]);

b.free;

# BufRd

Read the content of a buffer at an index.

In comparison to PlayBuf : PlayBuf plays through the buffer by itself, BufRd only moves its read point by the phase input and therefore has no pitch input. BufRd has variable interpolation.

(
// read a whole sound into memory
s = Server.local;
// note: not *that* columbia, the first one
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)

//use any AUDIO rate ugen as an index generator

{ BufRd.ar(1, b, SinOsc.ar(0.1) * BufFrames.ir(b)) }.play;
{ BufRd.ar(1, b, LFNoise1.ar(1) * BufFrames.ir(b)) }.play;
{ BufRd.ar(1, b, LFNoise1.ar(10) * BufFrames.ir(b)) }.play;
{ BufRd.ar(1, b, LFTri.ar(0.1) + LFTri.ar(0.23) * BufFrames.ir(b)) }.play;
// original duration
{ BufRd.ar(1, b, LFSaw.ar(BufDur.ir(b).reciprocal).range(0, BufFrames.ir(b)) ) }.play;


//use a phasor index into the file

{ BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b))) }.play;


//change rate and interpolation
(
x = { arg rate=1, inter=2;
    BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)), 1, inter)
}.play;
)

x.set(\rate, 0.9);
x.set(\rate, 0.6);
x.set(\inter, 1);
x.set(\inter, 0);


//write into the buffer with a BufWr
(
y = { arg rate=1;
    var in;
    in = SinOsc.ar(LFNoise1.kr(2, 300, 400), 0, 0.1);
    BufWr.ar(in, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)));
    0.0 //quiet
}.play;
)

//read it with a BufRd
(
x = { arg rate=1;
    BufRd.ar(1, b, Phasor.ar(0, BufRateScale.kr(b) * rate, 0, BufFrames.kr(b)))
}.play;
)



x.set(\rate, 5);
y.set(\rate, 2.0.rand);
x.set(\rate, 2);

b.free
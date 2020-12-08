(
{
    var rho, theta, b1, b2, vib;
    theta = MouseX.kr(0.2pi, pi);
    rho = MouseY.kr(0.6, 0.99);
    b1 = 2.0 * rho * cos(theta);
    b2 = rho.squared.neg;

    vib = SOS.kr(LFSaw.kr(3.16, [0, 1]), 1.0, 0.0, 0.0, b1, b2);
    SinOsc.ar( vib * 200 + 600) * 0.1
}.play
)

(
a = SynthDef(\test, { | out, freq = 220, amp = 0.5 |
    var sig = VarSaw.ar( freq!2 );
    // var env = EnvGen.kr(
        // Env.perc(0.01, curve: [4, -4]), doneAction: Done.freeSelf
// );
    sig = sig; // * env;
    Out.ar(out, sig * amp );
}).add;
)

b = a.play

b.free

b = Routine( {
    loop{
    a.play;
    1.wait;
    }
}).play;

b.stop

(
Ndef(\test, { | freq = 220 |
    Blip.ar(freq) * 0.2;
}).play
)

Ndef(\test).gui

a = ();
(
a = SynthDef(\test,{ | freq = 110|
    var sig = Saw.ar(freq);
    var env = Env.perc().ar(doneAction: Done.freeSelf);
    sig = sig * env;
    Out.ar(0, sig);
}).add;
)

(
c = Routine( {
    loop{
b = Synth(\test);
        b.set(\freq, 220);
        // b.play;
        1.wait;
        b.set(\freq, 440);
        0.5.wait;
    }
}).play;
)

c.free
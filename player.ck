// takes a line with two tokens:
// a MIDI note (integer) and a pan value (float, -1 to 1)

// will this eat up memory eventually? yes.

// turn non-200s into something else -- (process2.pl)

Gain gleft => Dyno dleft => dac.left;
Gain gright => Dyno dright => dac.right;

0.5 => float maxAmp;
gleft.gain(maxAmp); 
gright.gain(maxAmp); 

dleft.thresh(maxAmp);  // set the threshold of the limiter
dleft.slopeBelow(1.0); // sound quieter than thresh is untouched
dleft.slopeAbove(0.0); // sound louder than thresh is squashed

dright.thresh(maxAmp);  // set the threshold of the limiter
dright.slopeBelow(1.0); // sound quieter than thresh is untouched
dright.slopeAbove(0.0); // sound louder than thresh is squashed

ConsoleInput in;
StringTokenizer tok;

string line;
string note;
string pan;
string strike;

while( true ) {
    in.prompt() => now;
    while( in.more() )
    {
        in.getLine() => line;
        <<< "", line >>>;
        tok.set(line);
        tok.next() => note;
        tok.next() => pan;
        tok.next() => strike;
        spork ~ plink(Std.atoi(note), Std.atof(pan), Std.atof(strike));
    }
    5::ms => now;
}  

fun void plink(int noteval, float panval, float strikeval)
{
    //ModalBar bar => JCRev r => Gain master => Pan2 p => dac;
    ModalBar bar => Gain master => Pan2 p => dac;
    10 => bar.preset;
    //0.1 => r.mix;
    0.1 => master.gain;
    //Math.random2(45, 55) => Std.mtof => bar.freq;
    noteval => Std.mtof => bar.freq;
    panval => p.pan;
    strikeval => bar.strike;
    3::second => now;
    p =< dac;
}
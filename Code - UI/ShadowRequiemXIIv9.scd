//Shadow Requiem XII v9

(
s.waitForBoot{
s.options.memSize = 2.pow(20);
s.options.numInputBusChannels = 0;
s.freeMyDefaultGroup;
~fx = Bus.audio(s, 2);
s.sync;
//-----------------------------------------------------LOAD SAMPLES
~elements = Array.new;
~elementsfolder = PathName.new("/Users/kostasstergiopoulos/Documents/SuperCollider Projects/ShadowRequiemXII Project v9/Sounds/");
~elementsfolder.entries.do({
    arg path;
~elements = ~elements.add(Buffer.read(s, path.fullPath));
});
s.sync;
//-------------------------------------------------- -GLOBAL VARIABLES
~synth1amp = 0.5;
~synth2amp = 0.5;
~synth3amp = 0.5;
~synth4amp = 0.5;
~synth5amp = 0.5;
~synth6amp = 0.5;
~synth1rate = 1;
~synth2rate = 1;
~synth3rate = 1;
~synth4rate = 1;
~synth5rate = 1;
~synth6rate = 1;
~synth1pos = 0;
~synth2pos = 0;
~synth3pos = 0;
~synth4pos = 0;
~synth5pos = 0;
~synth6pos = 0;
~synth1start = 0;
~synth2start = 0;
~synth3start = 0;
~synth4start = 0;
~synth5start = 0;
~synth6start = 0;
~synth1end = 493919;
~synth2end = 493919;
~synth3end = 493919;
~synth4end = 493919;
~synth5end = 493919;
~synth6end = 493919;
s.sync;
//------------------------------------------------------MAIN SYNTH
SynthDef.new(\element, {
	arg amp = 0.9, buf, start, end, rate = 1, gate = 1, pos = 0, pingpongfreq = 0.5, pingpong = 0;
	var sig, ptr, env;
	env = EnvGen.kr(Env.adsr(sustainLevel: 1,releaseTime: 0.01), gate, doneAction: 2);
	ptr = Phasor.ar(0, BufRateScale.kr(buf) * rate, start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * env * amp;
	sig = Balance2.ar(sig[0], sig[1], pos + LFTri.kr(pingpongfreq, mul:pingpong));
	sig = Clip.ar(sig, -0.9, 0.9);
	Out.ar(~fx, sig);
	Out.ar(0, sig);
}).add;
s.sync;
//------------------------------------------------------DELAY SYNTH
SynthDef(\delay, {
	arg amp =  0,max = 5, del = 0.7, dec = 5, pingpong = 0, pingpongfreq = 0.5;
	var sig, env;
	sig = In.ar(~fx, 2);
	env = EnvGen.kr(Env.adsr(sustainLevel: 1), doneAction: 2);
	sig = CombC.ar(sig, max, del, dec);
	sig = sig * env * amp;
	sig = Balance2.ar(sig[0], sig[1], LFTri.kr(pingpongfreq, mul:pingpong));
	sig = Clip.ar(sig, -0.9, 0.9);
	Out.ar(0, sig);
	}).add;
s.sync;
//------------------------------------------------------REVERB SYNTH
SynthDef(\reverb, {
	arg mix = 0, room = 0.9, damp = 0.2, pingpongfreq = 0.5, pingpong = 0;
	var sig, env;
	sig = In.ar(~fx, 2);
	env = EnvGen.kr(Env.adsr(sustainLevel: 1), doneAction: 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix, room, damp);
    sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], LFTri.kr(pingpongfreq, mul:pingpong));
	sig = Clip.ar(sig, -0.9, 0.9);
	Out.ar(0, sig);
}).add;
s.sync;
//--------------------------------------------------ACTIVATE REVERB & DELAY
~dl = Synth(\delay);
s.sync;
~rv = Synth(\reverb);
s.sync;
//------------------------------------------------------OSC DEFINITIONS
OSCdef.freeAll;
//------------------------------------------------------------TRIGGERS

OSCdef.new(\synth1gate,{
		arg msg;
		if(msg[1] == 1, {~synth1 = Synth(\element, [\buf, ~elements[rrand(0, 2)], \start, ~synth1start, \end, ~synth1end, \rate, ~synth1rate, \amp, ~synth1amp, \pos, ~synth1pos, \pingpong, ~synth1pingpong, \pingpongfreq, ~synth1pingfreq])},
		{~synth1.set(\gate, 0)});
	},
	'/1/trigger1'
          );
OSCdef.new(\synth2gate,{
		arg msg;
		if(msg[1] == 1, {~synth2 = Synth(\element, [\buf, ~elements[rrand(3, 5)], \start, ~synth2start, \end, ~synth2end, \rate, ~synth2rate, \amp, ~synth2amp, \pos, ~synth2pos, \pingpong, ~synth2pingpong, \pingpongfreq, ~synth2pingfreq])},
		{~synth2.set(\gate, 0)});
	},
	'/1/trigger2'
          );
OSCdef.new(\synth3gate,{
		arg msg;
		if (msg[1] == 1, {~synth3 = Synth(\element, [\buf, ~elements[rrand(6, 8)], \start, ~synth3start, \end, ~synth3end, \rate, ~synth3rate, \amp, ~synth3amp, \pos, ~synth3pos, \pingpong, ~synth3pingpong, \pingpongfreq, ~synth3pingfreq])},
		{~synth3.set(\gate, 0)});
	},
	'/2/trigger3'
          );
OSCdef.new(\synth4gate,{
		arg msg;
		if (msg[1] == 1, {~synth4 = Synth(\element, [\buf, ~elements[rrand(9, 11)], \start, ~synth4start, \end, ~synth4end, \rate, ~synth4rate, \amp, ~synth4amp, \pos, ~synth4pos, \pingpong, ~synth4pingpong, \pingpongfreq, ~synth4pingfreq])},
		{~synth4.set(\gate, 0)});
	},
	'/2/trigger4'
          );
OSCdef.new(\synth5gate,{
		arg msg;
		if (msg[1] == 1, {~synth5 = Synth(\element, [\buf, ~elements[rrand(12, 14)], \start, ~synth5start, \end, ~synth5end, \rate, ~synth5rate, \amp, ~synth5amp, \pos, ~synth5pos, \pingpong, ~synth5pingpong, \pingpongfreq, ~synth5pingfreq])},
		{~synth5.set(\gate, 0)});
	},
	'/3/trigger5'
          );
OSCdef.new(\synth6gate,{
		arg msg;
		if (msg[1] == 1, {~synth6 = Synth(\element, [\buf, ~elements[rrand(15, 17)], \start, ~synth6start, \end, ~synth6end, \rate, ~synth6rate, \amp, ~synth6amp, \pos, ~synth6pos, \pingpong, ~synth6pingpong, \pingpongfreq, ~synth6pingfreq])},
		{~synth6.set(\gate, 0)});
	},
	'/3/trigger6'
          );
//-----------------------------------RATES
OSCdef.new(\synth1rate,{
		arg msg;
		~synth1rate = msg[1].linlin(0,1,-4,4);
		~synth1.set(\rate, ~synth1rate);
	},
	'/1/rate1'
          );
OSCdef.new(\synth2rate,{
		arg msg;
		~synth2rate = msg[1].linlin(0,1,-4,4);
		~synth2.set(\rate, ~synth2rate);
	},
	'/1/rate2'
          );
OSCdef.new(\synth3rate,{
		arg msg;
		~synth3rate = msg[1].linlin(0,1,-4,4);
		~synth3.set(\rate, ~synth3rate);
	},
	'/2/rate3'
          );
OSCdef.new(\synth4rate,{
		arg msg;
		~synth4rate = msg[1].linlin(0,1,-4,4);
		~synth4.set(\rate, ~synth4rate);
	},
	'/2/rate4'
          );
OSCdef.new(\synth5rate,{
		arg msg;
		~synth5rate = msg[1].linlin(0,1,-4,4);
		~synth5.set(\rate, ~synth5rate);
	},
	'/3/rate5'
          );
OSCdef.new(\synth6rate,{
		arg msg;
		~synth6rate = msg[1].linlin(0,1,-4,4);
		~synth6.set(\rate, ~synth6rate);
	},
	'/3/rate6'
          );
//--------------------------------------------TRIM FROM START
OSCdef.new(\synth1start,{
		arg msg;
		~synth1start = msg[1].linlin(0,1,1,20000);
		~synth1.set(\start, ~synth1start);
	},
	'/1/start1'
          );
OSCdef.new(\synth2start,{
		arg msg;
		~synth2start = msg[1].linlin(0,1,1,20000);
		~synth2.set(\start, ~synth2start);
	},
	'/1/start2'
          );
OSCdef.new(\synth3start,{
		arg msg;
		~synth3start = msg[1].linlin(0,1,1,20000);
		~synth3.set(\start, ~synth3start);
	},
	'/2/start3'
          );
OSCdef.new(\synth4start,{
		arg msg;
		~synth4start = msg[1].linlin(0,1,1,20000);
		~synth4.set(\start, ~synth4start);
	},
	'/2/start4'
          );
OSCdef.new(\synth5start,{
		arg msg;
		~synth5start = msg[1].linlin(0,1,1,20000);
		~synth5.set(\start, ~synth5start);
	},
	'/3/start5'
          );
OSCdef.new(\synth6start,{
		arg msg;
		~synth6start = msg[1].linlin(0,1,1,20000);
		~synth6.set(\start, ~synth6start);
	},
	'/3/start6'
          );
//-------------------------------------TRIM FROM END
OSCdef.new(\synth1end,{
		arg msg;
		~synth1end = msg[1].linexp(0,1,493919,3000);
		~synth1.set(\end, ~synth1end);
	},
	'/1/end1'
          );
OSCdef.new(\synth2end,{
		arg msg;
		~synth2end = msg[1].linexp(0,1,493919,3000);
		~synth2.set(\end, ~synth2end);
	},
	'/1/end2'
          );
OSCdef.new(\synth3end,{
		arg msg;
		~synth3end = msg[1].linexp(0,1,493919,3000);
		~synth3.set(\end, ~synth3end);
	},
	'/2/end3'
          );
OSCdef.new(\synth4end,{
		arg msg;
		~synth4end = msg[1].linexp(0,1,493919,3000);
		~synth4.set(\end, ~synth4end);
	},
	'/2/end4'
          );
OSCdef.new(\synth5end,{
		arg msg;
		~synth5end = msg[1].linexp(0,1,493919,3000);
		~synth5.set(\end, ~synth5end);
	},
	'/3/end5'
          );
OSCdef.new(\synth6end,{
		arg msg;
		~synth6end = msg[1].linexp(0,1,493919,3000);
		~synth6.set(\end, ~synth6end);
	},
	'/3/end6'
          );
//--------------------------------------AMPLITUDE
OSCdef.new(\synth1amp,{
		arg msg;
		~synth1amp = msg[1].linlin(0,1,0,0.9);
		~synth1.set(\amp, ~synth1amp);
	},
	'/1/amp1'
	     );
OSCdef.new(\synth2amp,{
		arg msg;
		~synth2amp = msg[1].linlin(0,1,0,0.9);
		~synth2.set(\amp, ~synth2amp);
	},
	'/1/amp2'
	     );
OSCdef.new(\synth3amp,{
		arg msg;
		~synth3amp = msg[1].linlin(0,1,0,0.9);
		~synth3.set(\amp, ~synth3amp);
	},
	'/2/amp3'
	     );
OSCdef.new(\synth4amp,{
		arg msg;
		~synth4amp = msg[1].linlin(0,1,0,0.9);
		~synth4.set(\amp, ~synth4amp);
	},
	'/2/amp4'
	     );
OSCdef.new(\synth5amp,{
		arg msg;
		~synth5amp = msg[1].linlin(0,1,0,0.9);
		~synth5.set(\amp, ~synth5amp);
	},
	'/3/amp5'
	     );
OSCdef.new(\synth6amp,{
		arg msg;
		~synth6amp = msg[1].linlin(0,1,0,0.9);
		~synth6.set(\amp, ~synth6amp);
	},
	'/3/amp6'
	     );
//--------------------------------------PANORAMA POSITION
OSCdef.new(\synth1pos,{
		arg msg;
		~synth1pos = msg[1].linlin(0,1,-1,1);
		~synth1.set(\pos, ~synth1pos);
	},
	'/1/pos1'
	     );
OSCdef.new(\synth2pos,{
		arg msg;
		~synth2pos = msg[1].linlin(0,1,-1,1);
		~synth2.set(\pos, ~synth2pos);
	},
	'/1/pos2'
	     );
OSCdef.new(\synth3pos,{
		arg msg;
		~synth3pos = msg[1].linlin(0,1,-1,1);
		~synth3.set(\pos, ~synth3pos);
	},
	'/2/pos3'
	     );
OSCdef.new(\synth4pos,{
		arg msg;
		~synth4pos = msg[1].linlin(0,1,-1,1);
		~synth4.set(\pos, ~synth4pos);
	},
	'/2/pos4'
	     );
OSCdef.new(\synth5pos,{
		arg msg;
		~synth5pos = msg[1].linlin(0,1,-1,1);
		~synth5.set(\pos, ~synth5pos);
	},
	'/3/pos5'
	     );
OSCdef.new(\synth6pos,{
		arg msg;
		~synth6pos = msg[1].linlin(0,1,-1,1);
		~synth6.set(\pos, ~synth6pos);
	},
	'/3/pos6'
	     );
//----------------------------------------PING PONG EFFECT
OSCdef.new(\synth1pingpong,{
		arg msg;
		~synth1pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth1pingpong = msg[2];
		~synth1.set(\pingpongfreq, ~synth1pingfreq, \pingpong, ~synth1pingpong);
	},
	'/6/pingpong1'
	);
OSCdef.new(\synth2pingpong,{
		arg msg;
		~synth2pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth2pingpong = msg[2];
		~synth2.set(\pingpongfreq, ~synth2pingfreq, \pingpong, ~synth2pingpong);
	},
	'/6/pingpong2'
	);
OSCdef.new(\synth3pingpong,{
		arg msg;
		~synth3pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth3pingpong = msg[2];
		~synth3.set(\pingpongfreq, ~synth3pingfreq, \pingpong, ~synth3pingpong);
	},
	'/6/pingpong3'
	);
OSCdef.new(\synth4pingpong,{
		arg msg;
		~synth4pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth4pingpong = msg[2];
		~synth4.set(\pingpongfreq, ~synth4pingfreq, \pingpong, ~synth4pingpong);
	},
	'/6/pingpong4'
	);
OSCdef.new(\synth5pingpong,{
		arg msg;
		~synth5pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth5pingpong = msg[2];
		~synth5.set(\pingpongfreq, ~synth5pingfreq, \pingpong, ~synth5pingpong);
	},
	'/6/pingpong5'
	);
OSCdef.new(\synth6pingpong,{
		arg msg;
		~synth6pingfreq = msg[1].linlin(0,1,0.05,15);
		~synth6pingpong = msg[2];
		~synth6.set(\pingpongfreq, ~synth6pingfreq, \pingpong, ~synth6pingpong);
	},
	'/6/pingpong6'
	);
//----------------------------------DELAY & REVERB
OSCdef.new(\delayamount,{
		arg msg;
		~dl.set(\amp, msg[1].linlin(0,1,0,0.9));
	},
	'/4/delay'
	);
OSCdef.new(\delaytime,{
		arg msg;
		~dl.set(\del, msg[1].linlin(0,1,0.01, 2));
	},
	'/4/time'
	);
OSCdef.new(\delaydecay,{
		arg msg;
		~dl.set(\dec, msg[1].linlin(0,1,1,20), \max, msg[1].linlin(0,1,1,15));
	},
	'/4/decay'
	);
OSCdef.new(\delaypingpong,{
		arg msg;
		~dl.set(\pingpongfreq, msg[1].linlin(0,1,0.05,15), \pingpong, msg[2]);
	},
	'/4/delaypingpong'
	);

OSCdef.new(\reverbmix,{
		arg msg;
		~rv.set(\mix, msg[1]);
	},
	'/5/reverbmix'
	);
OSCdef.new(\reverbroom,{
		arg msg;
		~rv.set(\room, msg[1], \damp, msg[2]);
	},
	'/5/reverbroom'
	);
OSCdef.new(\reverbpingpong,{
		arg msg;
		~rv.set(\pingpongfreq, msg[1].linlin(0,1,0.05,15), \pingpong, msg[2]);
	},
	'/6/reverbpingpong'
	);

})









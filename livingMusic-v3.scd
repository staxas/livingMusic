// livingMusic 0.01 by Edwin Rietmeijer 2010

(
var dnaL, dnaR, modalSet, modalNote=0, listIndex=0, modalList, notes, ratios, dirNote=1, chngNote ;
var ratAdd=[1,3,8,15], ratDiv=[2,2,3,4], modalMaxDig, modalNrChk, oscModFrq, oscFrqVol, oscVolAvg, oscVol, oscVolTotal, oscFrqVolTotal, oscFrqVolAvg, nrOfNotes=1;
var arpSets, thisArpSet,currArpSet,nrOfArpNotes, currNote, noteSet,notesWritten,notesIndex,noteToAdd=40,noteList,noteLength,thisIndex=0,notesPlayed,maxLife,notesForNow,grow=true;
var newArpSet1, newArpSet2,loopLife,loops,mutate,myTempo;
var syn, sound;
var noteCalcFunc, noteListFunc, modalSysFunc,modalListFunc,arpNoteSizeFunc,ratioCalcFunc,oscVolCalcFunc,oscModFrqCalcFunc,oscModVolCalcFunc, synthDefFunc, maxLifeFunc,arpSetsFunc,tempoCalcFunc,loopLifeFunc,runAllFuncs;

currArpSet=List[0,0,0,0];
newArpSet1=List.new(0);
newArpSet2=List.new(0);

t=TempoClock.new;

t.tempo_(1);
t.tempo;

oscModFrq=[1,1,1,1];
oscVol=[1,1,1,1];
oscFrqVol=[1,1,1,1];

arpSets = [ [ [-2],[-1],[1],[2] ],[ [-2,1],[-1,1],[1,-1],[2,-1] ] ,[ [-2,1,-1],[-1,-1,1], [1,1,-1],[2,-1,1] ] , [ [ -2,1,-1,1 ] , [-1,1,-1,2] , [1,-1,1,-2] , [2, -1, 1, -1] ] ];

modalSet=List.new(0);
modalList=List.new(0);
notes=List.new(0);
1.do({arg i;notes.add(noteToAdd)});
nrOfNotes=notes.size;
noteList=List.new;
ratios=[1,2,3,4];
" ".postln;
" ".postln;

("DNA").postln;
dnaL=Array.fill(34, { (4.rand)+1 }).postln;
dnaR=Array.fill(34, { (4.rand)+1 }).postln;
" ".postln;

// ## tempo calculation routine
tempoCalcFunc ={
	myTempo	= ((dnaL.at(31) * dnaR.at(31))*10)+(dnaL.at(31) * dnaR.at(31));
	t.tempo_(myTempo/60);
	("Tempo: " ++ myTempo).postln;
	};
//    ## modal system calculation routine
modalSysFunc = {
	modalSet.clear;
	modalMaxDig = dnaL.at(30);
	modalNrChk = dnaR.at(30);
	modalNrChk.do ({ arg i ;
		modalSet.add(((modalMaxDig.rand)+1));
		});
	("ModalSet: " ++ modalSet).postln;
};
// -- end routine


// ## modal list calculation

modalListFunc ={
	modalList.clear;
	listIndex=0;
	modalNote=0;
	120.do({arg i; modalNote = modalNote + modalSet.at(listIndex); modalList.add	(modalNote);listIndex=listIndex+1;
	if (listIndex == modalSet.size,
		{listIndex=0})
		});
	};
// -- end routine


// ## increment note values routine
noteCalcFunc ={
	(notes.size).do({ arg i;
		dnaR.at(29).do({
			arg i2;
			chngNote=((dnaL.at(29).rand)+1)*dirNote;
			notes.put(i,notes.at(i)+chngNote);
			dirNote=dirNote * -1;
			if (notes.at(i)<20, {dirNote=1;});
			if (notes.at(i)>80, {dirNote=-1;});

			});
		});
		("Notes: " ++ notes) .postln;
	};
// -- end routine


// ## calculate arp note size
arpNoteSizeFunc={
	nrOfArpNotes=dnaL.at(28)*dnaR.at(28);
	("nrOfArpNotes: " ++ nrOfArpNotes).postln;
	("noteLength: " ++ noteLength=1/nrOfArpNotes).postln;
	};
// -- end routine


// ## calculate arpSets routine

arpSetsFunc={
	newArpSet1.clear;
	newArpSet2.clear;
	4.do({arg i; var genePlace = 24;
		thisArpSet = arpSets.at((dnaL.at(i+genePlace))-1);
		currArpSet.put(i,thisArpSet.at((dnaR.at(i+genePlace))-1));
		});

	((currArpSet.at(0)).size).do({arg i;
		newArpSet1.add((currArpSet.at(0)).at(i));
		});

	((currArpSet.at(1)).size).do({arg i;
		newArpSet1.add((currArpSet.at(1)).at(i));
		});
	("NewArpSet1: " ++ newArpSet1).postln;

	((currArpSet.at(2)).size).do({arg i;
		newArpSet2.add((currArpSet.at(2)).at(i));
		});

	((currArpSet.at(3)).size).do({arg i;
		newArpSet2.add((currArpSet.at(3)).at(i));
		});
	("NewArpSet2: " ++ newArpSet2).postln;
	};
// -- end routine


// ## calculate noteList from arpSets routine
noteListFunc ={
	noteList.clear;
	thisIndex=0;
	notesWritten=0;
	notesIndex=0;
	(notes.size).do({arg i;
		nrOfArpNotes.do({arg i2;
			currNote=notes.at(i);
			currNote=currNote+(newArpSet1.wrapAt(thisIndex)+newArpSet2.wrapAt(thisIndex));
			noteList.add(modalList.at(currNote));

			thisIndex = thisIndex + 1;
//			("CR: " ++ currNote ++ " TI: " ++ thisIndex).postln;
			});
	});
	};

// -- end routine


// ## ratio calculation routine
ratioCalcFunc = {
4.do({
	arg i; var genePlace = 4, locRat;
	locRat = (dnaL.at(i+genePlace)/dnaR.at(i+genePlace));
	locRat = (locRat+ratAdd.at(i))/ratDiv.at(i);
	ratios.put(i, locRat);
	});
			("Osc Ratios: " ++ ratios).postln;
" ".postln;
};
// -- end routine


// ## oscillator volume calculation routine
oscVolCalcFunc ={

oscVolTotal=0;

4.do({
	arg i; var genePlace=8;
	oscVol.put(i,dnaL.at(i+genePlace));
	oscVolTotal=oscVolTotal+dnaL.at(i+genePlace)+30;
	});

	("OscVolPre: " ++ (oscVol/4)).postln;
	("OscVolTotal: " ++ oscVolTotal).postln;
	("OscVolAvg: " ++ oscVolAvg=oscVolTotal/4).postln;

4.do({
	arg i; var genePlace=12, oscToCalc;
	oscToCalc=oscVolAvg-dnaL.at(i+genePlace);
	oscToCalc=oscToCalc/dnaR.at(i+genePlace);
	oscVol.put(i,(oscVol.at(i)+ oscToCalc)/4);
	});

	("OscVolPost: " ++ oscVol).postln;
" ".postln;
};
// -- end routine


// ## oscillator modulation frequency recalculate
oscModFrqCalcFunc={
4.do({ arg i; var genePlace = 16, locRat, newFrq;
	locRat = (dnaL.at(i+genePlace)/dnaR.at(i+genePlace));
	oscModFrq.put(i, oscModFrq.at(i) * locRat);
	});

	("oscModFrq: " ++ oscModFrq).postln;
" ".postln;
};
// -- end routine


// ## oscillator modulation volume calculation routine
oscModVolCalcFunc={

oscFrqVolTotal=0;

4.do({
	arg i; var genePlace=20;
	oscFrqVol.put(i,dnaL.at(i+genePlace));
	oscFrqVolTotal=oscFrqVolTotal+dnaL.at(i+genePlace);
	});





	("OscFrqVolPre: " ++ (oscFrqVol/4)).postln;
	("OscFrqTotal: " ++ oscFrqVolTotal).postln;
	("OscFrqVolAvg: " ++ oscFrqVolAvg=oscFrqVolTotal/4).postln;

4.do({
	arg i; var genePlace=20, oscToCalc;
	oscToCalc=oscFrqVolAvg-dnaL.at(i+genePlace);
	oscToCalc=oscToCalc/dnaR.at(i+genePlace);
	oscFrqVol.put(i,(oscFrqVol.at(i)+ oscToCalc)/4);
	});

	("OscFrqVolPost: " ++ oscFrqVol).postln;
" ".postln;
};
// -- end routine


// ## SynthDef routine
synthDefFunc ={
	SynthDef(\help_sinegrain,
		{ arg out=0, freq=440;
			var env;
			4.do({arg index;
			env = EnvGen.kr(Env.linen(((dnaL.at(25)/dnaR.at(25))*noteLength)+0.05, noteLength/2, ((dnaL.at(25)/dnaR.at(25))*noteLength)+0.05, (oscVol.at(index))*0.005), doneAction:2);
			Out.ar(0, SinOsc.ar(freq*ratios.at(index)+SinOsc.ar(oscModFrq.at(index),2,oscFrqVol.at(index)), 2, env));
			Out.ar(1, SinOsc.ar(freq*ratios.at(index)+SinOsc.ar(oscModFrq.at(index),2,oscFrqVol.at(index)), 2, env));
			})
		}).send(s);
	};
// -- end routine


// ##    max life calculation routine
maxLifeFunc = {
	maxLife=(dnaL.at(32) * dnaR.at(32));
	};
// -- end routine


// ## loop life calculation routine
loopLifeFunc={
	loopLife=dnaL.at(33)+dnaR.at(33);
	};

// -- end routine

// ## calculate initial values
runAllFuncs={
tempoCalcFunc.value;

modalSysFunc.value;

modalListFunc.value;

noteCalcFunc.value;

arpNoteSizeFunc.value;

arpSetsFunc.value;

noteListFunc.value;

ratioCalcFunc.value;

oscVolCalcFunc.value;

oscModFrqCalcFunc.value;

oscModVolCalcFunc.value;

synthDefFunc.value;

maxLifeFunc.value;

loopLifeFunc.value;

("LoopLife: " ++ loopLife).postln;

("MaxLife: " ++ maxLife).postln;

("NotesSize: " ++ notes.size).postln;

"".postln;
};
// -- end routine


// ## start music routine
runAllFuncs.value;
a = Pseq(noteList, inf).asStream;
loops = 0;
notesPlayed=0;
Routine({
	loop({
	nrOfNotes=nrOfArpNotes*notes.size;
	Synth(\help_sinegrain, [\freq, a.next.midicps]);
	(noteLength).wait;
	notesPlayed=notesPlayed+1;

	if (nrOfNotes==notesPlayed,
	{notesPlayed=0;noteCalcFunc.value;noteListFunc.value;loops = loops + 1});

	if ((loops+1) > (loopLife), {loops = 0;
		if (grow == true,
		{notes.add(noteToAdd); if (notes.size+1>maxLife, {grow=false})
			},{notes.removeAt(rand(notes.size));a = Pseq(noteList, inf).asStream;}
	);
	mutate=rand(8);
		if (mutate==0, {"!!!MUTATE!!!MUTATE!!!MUTATE!!!MUTATE!!!MUTATE!!!".postln;
		(dnaL.put(rand(34), rand(4)+1)).postln;
		(dnaR.put(rand(34), rand(4)+1)).postln;

				runAllFuncs.value;

		});
		"".postln;
("NotesSize: " ++ notes.size ++ "      MaxLife: " ++ maxLife ++ "      LoopLife: " ++ loopLife).postln;

		noteCalcFunc.value;noteListFunc.value;
		a = Pseq(noteList, inf).asStream;})
	})
}).play;
// -- end routine

)
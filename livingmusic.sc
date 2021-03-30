// livingMusic 0.01 by Edwin Rietmeijer 2010

(
var dnaL, dnaR, modalSet, modalNote=0, listIndex=0, modalList, notes, ratios, dirNote=1, chngNote ;
var ratAdd=[1,3,8,15], ratDiv=[2,2,3,4], modalMaxDig, modalNrChk, oscModFrq, oscFrqVol, oscVolAvg, oscVol, oscVolTotal, oscFrqVolTotal, oscFrqVolAvg, nrOfNotes=4;
var arpSets, thisArpSet,currArpSet,numOfArpNotes, startNote, noteSet, noteList,noteLength,thisIndex=0,notesPlayed,maxLife,notesForNow,grow=true;
var syn, sound;
var noteCalcFunc, noteListFunc,modalSysFunc,modalListFunc,arpNoteSizeFunc,ratioCalcFunc,oscVolCalcFunc,oscModFrqCalcFunc,oscModVolCalcFunc, synthDefFunc, maxLifeFunc;
var loops=0;
modalSet=List.new(0);


Tempo.bpm=60;
oscModFrq=[1,1,1,1];
oscVol=[1,1,1,1];
oscFrqVol=[1,1,1,1];

arpSets = [ [ [-2],[-1],[1],[2] ],[ [-2,1],[-1,1],[1,-1],[2,-1] ] ,[ [-2,1,-1],[-1,-1,1], [1,1,-1],[2,-1,1] ] , [ [ -2,1,-1,1 ] , [-1,1,-1,2] , [1,-1,1,-2] , [2, -1, 1, -1] ] ];

modalSet=List.new(0);
notes=List.new;
notes=[50,50,50,50];
nrOfNotes=notes.size;
noteList=List.new;
ratios=[1,2,3,4];
" ".postln;
" ".postln;

("DNA").postln;
dnaL=Array.fill(60, { (4.rand)+1 }).postln;
dnaR=Array.fill(60, { (4.rand)+1 }).postln;
" ".postln;

Tempo.bpm = (((dnaL.at(25) * dnaR.at(25))*10)+(dnaL.at(25) * dnaR.at(25))).postln;

//    ## modal system calculation routine
modalSysFunc = {
modalMaxDig = dnaL.at(22);
modalNrChk = dnaR.at(22);
modalNrChk.do ({ arg i ;
	modalSet.add(((modalMaxDig.rand)+1));
}); 
		("ModalSet: " ++ modalSet).postln;
" ".postln;
};
// -- end routine


// ## modal list calculation

modalListFunc ={
	
modalList=List.new(0);	
120.do({arg i; modalNote = modalNote + modalSet.at(listIndex); modalList.add(modalNote);listIndex=listIndex+1;
	if (listIndex == modalSet.size,{
		listIndex=0
		},{} )
		});
};
// -- end routine


// ## increment note values routine
noteCalcFunc ={
// ("dnaR0: " ++ dnaR.at(0) ++ " dnaL0: " ++ dnaL.at(0)).postln;
nrOfNotes.do({ arg i;
	dnaR.at(i).do({
		arg i; 
		chngNote=(dnaL.at(i).rand)*dirNote;
		notes.put(i,notes.at(i)+chngNote); 
//		("NoteIndex: " ++ i).postln;
		dirNote=dirNote * -1;
		if (notes.at(i)<20, {dirNote=1;});
		if (notes.at(i)>100, {dirNote=-1;});

		});
	});
		("Notes:" ++ notes) .postln;
" ".postln;
};
// -- end routine


// ## calculate arp note size
arpNoteSizeFunc={
numOfArpNotes=dnaL.at(23)*dnaR.at(23);
// dnaL.at(23).postln;
// dnaR.at(23).postln;
("numOfArpNotes: " ++ numOfArpNotes).postln;
("noteLength: " ++ noteLength=1/numOfArpNotes).postln;
};
// -- end routine

// ## calculate arpSets to arpNoteSets
noteListFunc ={
thisArpSet = arpSets.at(dnaL.at(24)-1);
currArpSet = thisArpSet.at(dnaR.at(24)-1);
("currArpSet: " ++ currArpSet).postln;
	nrOfNotes.do({arg ind;
		listIndex=0;
		startNote=notes.at(ind);
			numOfArpNotes.do({ arg i; 	noteList.add(modalList.at(startNote));
				startNote=startNote+currArpSet.at(thisIndex);
			//	("currArpSet: " ++ currArpSet.at(thisIndex)).postln;
				thisIndex = thisIndex + 1;
			//	("thisIndex: " ++ thisIndex).postln;
			//	("currArpSet.size: " ++ currArpSet.size).postln;
				if (thisIndex==(currArpSet.size), {thisIndex=0;});
			});
	});

noteList.postln;

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
	oscVolTotal=oscVolTotal+dnaL.at(i+genePlace);
	});
	

4.do({
	arg i; var genePlace=12;
		("dnaL: " ++ dnaL.at(i+genePlace) ++ " dnaR: " ++ dnaR.at(i+genePlace)).postln;
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
		("locRat: " ++ locRat).postln;

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
	

4.do({
	arg i; var genePlace=20;
		("dnaL: " ++ dnaL.at(i+genePlace) ++ " dnaR: " ++ dnaR.at(i+genePlace)).postln;
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
		env = EnvGen.kr(Env.linen(((dnaL.at(25)/dnaR.at(25))*noteLength)+0.05, noteLength/2, ((dnaL.at(25)/dnaR.at(25))*noteLength)+0.05, (oscVol.at(index))*0.25), doneAction:2);
//		("Env: " ++ ((dnaL.at(12)/2)*noteLength) " " ++ (noteLength/2) " " ++ ((dnaR.at(12)/2)*noteLength)).postln;
//		("Index:" ++ index ++ " Ratio: " ++ ratios.at(index) ++ " OscModFrq: " ++ oscModFrq.at(index)).postln;
		Out.ar(0, SinOsc.ar(freq*ratios.at(index)+SinOsc.ar(oscModFrq.at(index),2,oscFrqVol.at(index)), 2, env));
		Out.ar(1, SinOsc.ar(freq*ratios.at(index)+SinOsc.ar(oscModFrq.at(index),2,oscFrqVol.at(index)), 2, env));
		})
	}).send(s);
};
// -- end routine

// ## calculate max life
maxLifeFunc = {
maxLife=(dnaL.at(26) * dnaR.at(26))*4;
};
// -- end routine


modalSysFunc.value;

modalListFunc.value;

noteCalcFunc.value;

arpNoteSizeFunc.value;

noteListFunc.value;

ratioCalcFunc.value;

oscVolCalcFunc.value;

oscModFrqCalcFunc.value;

oscModVolCalcFunc.value;

synthDefFunc.value;

maxLifeFunc.value;

notes.size.postln;

a = Pseq(noteList, inf).asStream;
loops = 0;
notesPlayed=0;
notesForNow=nrOfNotes;
Routine({
	loop({
	Synth(\help_sinegrain, [\freq, a.next.midicps]);
	(noteLength).wait;
	loops = loops + 1;

	if (loops == 100, {loops = 0;
		if (grow == true,
		{notes.add(50)}
	);
	//	)
		
		/*
		if (notesForNow < maxLife, 
		{notes.add(50)}, 
		{notesForNow=maxLife;notes.removeAt(random(notes.size)) }
		})
		*/
		
//	dnaL.put(random(30), random(4)+1);
//	dnaR.put(random(30), random(4)+1);


		noteCalcFunc.value;noteListFunc.value;
a = Pseq(noteList, inf).asStream;})
	}) // end loops var check
}).play;
)

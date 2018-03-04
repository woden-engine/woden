
"Load Phanide"
Metacello new
  baseline: 'Phanide';
  repository: 'filetree://phanide/filetree';
  load.

"Load Lowtalk"
Metacello new
  baseline: 'Lowtalk';
  repository: 'filetree://lowtalk/filetree';
  load.

"Build the Lowtalk source code"
[
    | compilationTarget compilerClass compiler |
    compilationTarget := (Smalltalk globals at: #SLVMCompilationTarget) forCurrentImage.
    compilerClass := Smalltalk globals at: #LowtalkCompiler.

    compiler := compilerClass compilationTarget: compilationTarget.
    compiler
    	optimizationLevel: 1;
    	evaluateFileNamed: 'source/woden2.ltk';
	    buildModule;
    	ssaModule.

] value.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
  baseline: 'WodenEngine';
  repository: 'filetree://filetree';
  load.


"Save the image"
(Smalltalk saveAs: 'woden')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

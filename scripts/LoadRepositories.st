
"Load Phanide"
Metacello new
  baseline: 'Phanide';
  repository: 'tonel://phanide/tonel';
  load.

"Load Lowtalk"
Metacello new
  baseline: 'Lowtalk';
  repository: 'tonel://lowtalk/tonel';
  load.

"Build the Lowtalk source code"
SourceFiles deferFlushDuring: [
    | compilationTarget compilerClass compiler |
    compilationTarget := (Smalltalk globals at: #SLVMCompilationTarget) forCurrentImage.
    compilerClass := Smalltalk globals at: #LowtalkCompiler.

    compiler := compilerClass compilationTarget: compilationTarget.
    compiler
    	optimizationLevel: 1;
    	evaluateFileNamed: 'source/woden.ltk';
	    buildModule;
    	ssaModule.

].

"Load WodenEngine"
FileStream stdout nextPutAll: 'Loading Woden'; lf.
Metacello new
  baseline: 'WodenEngine';
  repository: 'tonel://tonel';
  load.


"Save the image"
(Smalltalk saveAs: 'woden')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

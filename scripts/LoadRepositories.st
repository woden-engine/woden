"Load Lowtalk"
Metacello new
    baseline: 'Lowtalk';
    repository: 'github://ronsaldo/lowtalk/tonel';
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

"Rebuild the field accessors"
FFIExternalStructure allSubclassesDo: #rebuildFieldAccessors.

"Patch the idle process, to reduce latency"
'scripts/idleProcess.st' asFileReference fileIn.

"Save the image"
(Smalltalk saveAs: 'woden')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

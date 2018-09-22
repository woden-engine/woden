
"Load Phanide"
Metacello new
    baseline: 'Phanide';
    repository: 'tonel://source-deps/phanide/tonel';
    load.

"Load Lowtalk"
Metacello new
    baseline: 'Lowtalk';
    repository: 'tonel://source-deps/lowtalk/tonel';
    load.

"Load BabylonGraphics API"
Metacello new
    baseline: 'Babylon';
    repository: 'tonel://source-deps/babylon-graphics/tonel';
    load: #(API).
Metacello new
    baseline: 'CyrusToolkit';
    repository: 'tonel://source-deps/babylon-graphics/tonel';
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

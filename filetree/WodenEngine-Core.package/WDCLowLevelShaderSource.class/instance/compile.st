compiling
compile
	| compiler newSource newDependencies oldDependencies |
	compiler := 	DASLCompiler new.
	newSource := (compiler 
		target: target;
		sourceFromFileNamed: entryFile;
		compile;
		generatedCode) asShaderCode.
		
	oldDependencies := dependencies ifNil: [ #() ].
	newDependencies := compiler processedDependencies collect: #asFileReference.
	
	dependencies := newDependencies.
	
	engine autoReloadChanges ifTrue: [
		(newDependencies asSet difference: oldDependencies asSet) do: [ :dep |
			PhanideFileSystemMonitor on: dep when: PhanideFileEventCloseWrite do: [ :event |
				[ 
					self reload
				] on: Error do: [ :err |
					err freeze.
					[ err debug ] fork
				]			
			].
		].
	].

	"Setting a variable is an atomic operation"
	source := newSource.
	
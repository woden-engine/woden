"
I am a cache from a high-level shader language into a low-level shader language..
"
Class {
	#name : #WDCLowLevelShaderSource,
	#superclass : #Object,
	#instVars : [
		'engine',
		'source',
		'target',
		'libraries',
		'entryFile',
		'dependencies',
		'librariesMutex',
		'entryPoints'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #compiling }
WDCLowLevelShaderSource >> applySourceToShaderHandle: shaderHandle [
	shaderHandle setShaderSource: AGPU_SHADER_LANGUAGE_SPIR_V sourceText: source sourceTextLength: source size
]

{ #category : #compiling }
WDCLowLevelShaderSource >> asShaderLibrary [
	| library |
	library := (WDCShaderLibrary for: engine)
		source: self;
		checkSession;
		yourself.
		
	librariesMutex critical: [ 
		libraries add: library
	].

	^ library
]

{ #category : #compiling }
WDCLowLevelShaderSource >> compile [
	| compiler newSource newDependencies oldDependencies newModule |
	compiler := 	DASLCompiler new.
	newModule := compiler 
		target: target;
		addIncludeDirectory: WodenCoreAssets location / #shaders;
		sourceFromFileNamed: entryFile;
		compile;
		generatedCode.
	newSource := newModule asShaderCode.
	entryPoints := newModule entryPoints.
		
	oldDependencies := dependencies ifNil: [ #() ].
	newDependencies := compiler processedDependencies collect: #asFileReference.
	
	dependencies := newDependencies.
	
	engine autoReloadChanges ifTrue: [
		(newDependencies asSet difference: oldDependencies asSet) do: [ :dep |
			OSIOFileSystemMonitor on: dep when: OSIOFileEventCloseWrite do: [ :event |
				engine resourceCache enqueueResourceReloadAction: [ self reload ]
			].
		].
	].

	"Setting a variable is an atomic operation"
	source := newSource.
	
]

{ #category : #accessing }
WDCLowLevelShaderSource >> dependencies [
	^ dependencies
]

{ #category : #accessing }
WDCLowLevelShaderSource >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
WDCLowLevelShaderSource >> engine [
	^ engine
]

{ #category : #accessing }
WDCLowLevelShaderSource >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCLowLevelShaderSource >> entryFile [
	^ entryFile
]

{ #category : #accessing }
WDCLowLevelShaderSource >> entryFile: anObject [
	entryFile := anObject
]

{ #category : #accessing }
WDCLowLevelShaderSource >> entryPoints [
	^ entryPoints
]

{ #category : #accessing }
WDCLowLevelShaderSource >> entryPoints: anObject [
	entryPoints := anObject
]

{ #category : #initialization }
WDCLowLevelShaderSource >> initialize [
	super initialize.
	librariesMutex := Semaphore forMutualExclusion.
	libraries := WeakSet new.
]

{ #category : #accessing }
WDCLowLevelShaderSource >> name [
	^ entryFile fullName
]

{ #category : #compiling }
WDCLowLevelShaderSource >> reload [
	engine trace: 'Recompiling shader {1}' format: { entryFile fullName }.
	self compile.
	libraries do: #reload
]

{ #category : #path }
WDCLowLevelShaderSource >> sessionChanged [
]

{ #category : #accessing }
WDCLowLevelShaderSource >> source [
	^ source
]

{ #category : #accessing }
WDCLowLevelShaderSource >> source: anObject [
	source := anObject
]

{ #category : #accessing }
WDCLowLevelShaderSource >> target [
	^ target
]

{ #category : #accessing }
WDCLowLevelShaderSource >> target: anObject [
	target := anObject
]

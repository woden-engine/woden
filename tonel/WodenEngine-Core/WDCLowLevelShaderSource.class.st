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
		'stages',
		'entryFile',
		'dependencies',
		'stagesMutex'
	],
	#category : 'WodenEngine-Core-Shaders'
}

{ #category : #initialization }
WDCLowLevelShaderSource >> addStage: aWDCShaderStage [
	stagesMutex critical: [ 
		stages add: aWDCShaderStage
	]

]

{ #category : #compiling }
WDCLowLevelShaderSource >> compile [
	| compiler newSource newDependencies oldDependencies |
	compiler := 	DASLCompiler new.
	newSource := (compiler 
		target: target;
		addIncludeDirectory: WodenCoreAssets location / #shaders;
		sourceFromFileNamed: entryFile;
		compile;
		generatedCode) asShaderCode.
		
	oldDependencies := dependencies ifNil: [ #() ].
	newDependencies := compiler processedDependencies collect: #asFileReference.
	
	dependencies := newDependencies.
	
	engine autoReloadChanges ifTrue: [
		(newDependencies asSet difference: oldDependencies asSet) do: [ :dep |
			PhanideFileSystemMonitor on: dep when: PhanideFileEventCloseWrite do: [ :event |
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

{ #category : #initialization }
WDCLowLevelShaderSource >> initialize [
	super initialize.
	stagesMutex := Semaphore forMutualExclusion.
	stages := IdentitySet new.
]

{ #category : #accessing }
WDCLowLevelShaderSource >> name [
	^ entryFile fullName
]

{ #category : #compiling }
WDCLowLevelShaderSource >> reload [
	engine trace: 'Recompiling shader {1}' format: { entryFile fullName }.
	self compile.
	stages do: #reload
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
WDCLowLevelShaderSource >> stages [
	^ stages
]

{ #category : #accessing }
WDCLowLevelShaderSource >> target [
	^ target
]

{ #category : #accessing }
WDCLowLevelShaderSource >> target: anObject [
	target := anObject
]

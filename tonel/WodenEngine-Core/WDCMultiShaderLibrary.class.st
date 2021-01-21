Class {
	#name : #WDCMultiShaderLibrary,
	#superclass : #WDCAbstractShaderLibrary,
	#instVars : [
		'stages',
		'modules'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #'resource building' }
WDCMultiShaderLibrary >> buildHandle [
	modules do: [ :each | each checkSession ].
	^ nil
]

{ #category : #initialization }
WDCMultiShaderLibrary >> createStageDescriptions [
	| newStages stageName newModules |
	newModules := OrderedCollection new.
	newStages := Dictionary new.
	source modules select: [ :module | module name isNotNil ] thenDo: [ :module |
		| moduleLibrary |
		moduleLibrary := WDCLowLevelShaderSource new
			engine: engine;
			entryFile: 'shader module' asFileReference;
			source: module asWDCShaderCode;
			asShaderLibrary.
		
		newModules add: moduleLibrary.
		
		module entryPoints do: [ :entryPoint |
			stageName := entryPoint name -> entryPoint stage.
			newStages at: stageName put: moduleLibrary.
		].
	].

	modules := newModules.
	stages := newStages.

]

{ #category : #accessing }
WDCMultiShaderLibrary >> getStage: stageName withEntryPoint: entryPoint [
	^ (stages at: entryPoint -> stageName) ifNotNil: [ :module | module getStage: stageName withEntryPoint: entryPoint ]
]

{ #category : #initialization }
WDCMultiShaderLibrary >> initialize [
	super initialize.
	modules := OrderedCollection new.
	stages := Dictionary new.
]

{ #category : #actions }
WDCMultiShaderLibrary >> reload [
	self
		createStageDescriptions;
		invalidateHandle;
		checkSession.
]

{ #category : #'session management' }
WDCMultiShaderLibrary >> reloadDependendants [
	modules do: [:each | each reload ].
]

{ #category : #'as yet unclassified' }
WDCMultiShaderLibrary >> sourceChanged [
	self 
		createStageDescriptions;
		invalidateHandle.
]

{ #category : #accessing }
WDCMultiShaderLibrary >> stages [
	^ stages
]

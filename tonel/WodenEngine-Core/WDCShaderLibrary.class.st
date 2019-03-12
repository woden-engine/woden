Class {
	#name : #WDCShaderLibrary,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'source',
		'stages'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #actions }
WDCShaderLibrary >> buildHandle [
	handle := self compileLibraryHandle.
]

{ #category : #actions }
WDCShaderLibrary >> compileLibraryHandle [
	| newHandle |
	newHandle := engine device createShader: AGPU_LIBRARY_SHADER.
	source applySourceToShaderHandle: newHandle.
	^ newHandle compileShader: ''.

]

{ #category : #initialization }
WDCShaderLibrary >> createStageDescriptions [
	| newStages stageName stage |
	newStages := Dictionary new.
	source entryPoints do: [ :entryPoint |
		stageName := entryPoint name -> entryPoint stage.

		stage := stages at: stageName ifAbsent: [
			(WDCAbstractShaderStage classForStageName: entryPoint stage) new
				shaderLibrary: self;
				entryPointName: entryPoint name
		].
		stage properties: entryPoint properties.
		
		newStages at: stageName put: stage
	].

	stages := newStages.
]

{ #category : #accessing }
WDCShaderLibrary >> getComputeStage: entryPoint [
	^ self getStage: #compute withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCShaderLibrary >> getFragmentStage: entryPoint [
	^ self getStage: #fragment withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCShaderLibrary >> getGeometryStage: entryPoint [
	^ self getStage: #geometry withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCShaderLibrary >> getStage: stageName withEntryPoint: entryPoint [
	^ stages at: entryPoint -> stageName
]

{ #category : #accessing }
WDCShaderLibrary >> getTessellationControlStage: entryPoint [
	^ self getStage: #tcontrol withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCShaderLibrary >> getTessellationEvaluationStage: entryPoint [
	^ self getStage: #teval withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCShaderLibrary >> getVertexStage: entryPoint [
	^ self getStage: #vertex withEntryPoint: entryPoint
]

{ #category : #initialization }
WDCShaderLibrary >> initialize [
	super initialize.
	stages := Dictionary new.
]

{ #category : #actions }
WDCShaderLibrary >> reload [
	self
		createStageDescriptions;
		invalidateHandle;
		checkSession.
]

{ #category : #'session management' }
WDCShaderLibrary >> reloadDependendants [
	stages do: #reload.
]

{ #category : #accessing }
WDCShaderLibrary >> source [
	^ source
]

{ #category : #accessing }
WDCShaderLibrary >> source: anObject [
	source := anObject.
	self 
		createStageDescriptions;
		invalidateHandle.
]

{ #category : #accessing }
WDCShaderLibrary >> stages [
	^ stages
]

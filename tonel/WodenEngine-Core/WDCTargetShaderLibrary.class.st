Class {
	#name : #WDCTargetShaderLibrary,
	#superclass : #WDCAbstractShaderLibrary,
	#instVars : [
		'stages'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #actions }
WDCTargetShaderLibrary >> buildHandle [
	handle := self compileLibraryHandle.
]

{ #category : #actions }
WDCTargetShaderLibrary >> compileLibraryHandle [
	| newHandle |
	newHandle := engine device createShader: AGPU_LIBRARY_SHADER.
	source applySourceToShaderHandle: newHandle.
	^ newHandle compileShader: ''.

]

{ #category : #initialization }
WDCTargetShaderLibrary >> createStageDescriptions [
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
WDCTargetShaderLibrary >> getStage: stageName withEntryPoint: entryPoint [
	^ stages at: entryPoint -> stageName
]

{ #category : #initialization }
WDCTargetShaderLibrary >> initialize [
	super initialize.
	stages := Dictionary new.
]

{ #category : #actions }
WDCTargetShaderLibrary >> reload [
	self
		createStageDescriptions;
		invalidateHandle;
		checkSession.
]

{ #category : #'session management' }
WDCTargetShaderLibrary >> reloadDependendants [
	stages do: #reload.
]

{ #category : #'as yet unclassified' }
WDCTargetShaderLibrary >> sourceChanged [
	self 
		createStageDescriptions;
		invalidateHandle.
]

{ #category : #accessing }
WDCTargetShaderLibrary >> stages [
	^ stages
]

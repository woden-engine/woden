Class {
	#name : #WDCRenderableDeformationState,
	#superclass : #Object,
	#instVars : [
		'engine',
		'renderableStateBindings'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCRenderableDeformationState >> createEngineDependantData [
	| shaderSignature |
	engine isDummyEngine ifTrue: [ ^ self ].
	shaderSignature := WDCSceneRenderingShaderSignature for: engine.
	renderableStateBindings := self requiresAccessFromTheCPU ifTrue: [
		engine frameBufferingCollect: [ :i |
			shaderSignature newRenderableState
		].
	] ifFalse: [ {shaderSignature newRenderableState} ]
	 
]

{ #category : #accessing }
WDCRenderableDeformationState >> currentRenderableStateBinding [
	^ self requiresAccessFromTheCPU
		ifTrue: [ renderableStateBindings at: engine bufferingFrameIndex ]
		ifFalse: [ renderableStateBindings first ]
]

{ #category : #accessing }
WDCRenderableDeformationState >> destroyEngineDependantData [
]

{ #category : #accessing }
WDCRenderableDeformationState >> engine: newEngine [
	engine == newEngine ifTrue: [ ^ self ].
	engine ifNotNil: [ self destroyEngineDependantData ].
	engine := newEngine.
	engine ifNotNil: [ self createEngineDependantData ].
]

{ #category : #testing }
WDCRenderableDeformationState >> isSkinningState [
	^ false
]

{ #category : #testing }
WDCRenderableDeformationState >> isTerrainDeformationState [
	^ false
]

{ #category : #testing }
WDCRenderableDeformationState >> isWaterDeformationState [
	^ false
]

{ #category : #enumerating }
WDCRenderableDeformationState >> precacheResources [
]

{ #category : #accessing }
WDCRenderableDeformationState >> requiresAccessFromTheCPU [
	^ self subclassResponsibility
]

{ #category : #'renderable state' }
WDCRenderableDeformationState >> updateCommonGpuStateForFrame: frameIndex [
]

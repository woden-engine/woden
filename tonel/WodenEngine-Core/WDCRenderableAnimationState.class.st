Class {
	#name : #WDCRenderableAnimationState,
	#superclass : #Object,
	#instVars : [
		'engine',
		'renderableStateBindings'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCRenderableAnimationState >> createEngineDependantData [
	| shaderSignature |
	shaderSignature := WDCSceneRenderingShaderSignature for: engine.
	renderableStateBindings := self requiresAccessFromTheCPU ifTrue: [
		engine frameBufferingCollect: [ :i |
			shaderSignature newRenderableState
		].
	] ifFalse: [ {shaderSignature newRenderableState} ]
	 
]

{ #category : #accessing }
WDCRenderableAnimationState >> currentRenderableStateBinding [
	^ self requiresAccessFromTheCPU
		ifTrue: [ renderableStateBindings at: engine bufferingFrameIndex ]
		ifFalse: [ renderableStateBindings first ]
]

{ #category : #accessing }
WDCRenderableAnimationState >> destroyEngineDependantData [
]

{ #category : #accessing }
WDCRenderableAnimationState >> engine: newEngine [
	engine == newEngine ifTrue: [ ^ self ].
	engine ifNotNil: [ self destroyEngineDependantData ].
	engine := newEngine.
	engine ifNotNil: [ self createEngineDependantData ].
]

{ #category : #accessing }
WDCRenderableAnimationState >> requiresAccessFromTheCPU [
	^ self subclassResponsibility
]

{ #category : #'renderable state' }
WDCRenderableAnimationState >> updateCommonGpuStateForFrame: frameIndex [
]

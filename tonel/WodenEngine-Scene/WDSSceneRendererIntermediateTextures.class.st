Class {
	#name : #WDSSceneRendererIntermediateTextures,
	#superclass : #Object,
	#instVars : [
		'signature',
		'usedInThisFrame',
		'sceneRenderer',
		'engine',
		'extent',
		'sampleCount'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'as yet unclassified' }
WDSSceneRendererIntermediateTextures >> applyToRenderingViewport: renderingViewport [
	usedInThisFrame := true
]

{ #category : #'multi eye rendering' }
WDSSceneRendererIntermediateTextures >> createRenderTargets [
	self subclassResponsibility
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> engine [
	^ engine
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> sceneRenderer [
	^ sceneRenderer
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> sceneRenderer: anObject [
	sceneRenderer := anObject
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> signature [
	^ signature
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> signature: anObject [
	signature := anObject.
	extent := signature first.
	sampleCount := signature second.
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> usedInThisFrame [
	^ usedInThisFrame
]

{ #category : #accessing }
WDSSceneRendererIntermediateTextures >> usedInThisFrame: anObject [
	usedInThisFrame := anObject
]

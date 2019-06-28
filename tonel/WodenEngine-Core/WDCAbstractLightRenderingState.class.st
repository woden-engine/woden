"
I represent the rendering state for a light. I am used for computing shadow mapping transforms.
"
Class {
	#name : #WDCAbstractLightRenderingState,
	#superclass : #Object,
	#instVars : [
		'shadowMapIndex',
		'engine',
		'mainCamera',
		'renderingLight'
	],
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #accessing }
WDCAbstractLightRenderingState >> engine [
	^ engine
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> globalTransform [
	^ renderingLight transform
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> light [
	^ renderingLight lightSource
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> mainCamera [
	^ mainCamera
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> mainCamera: anObject [
	mainCamera := anObject
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> renderingLight [
	^ renderingLight
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> renderingLight: anObject [
	renderingLight := anObject
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> scene [
	^ renderingLight node scene
]

{ #category : #'shadow mapping' }
WDCAbstractLightRenderingState >> setupShadowMapWithIndex: newShadowMapIndex [
	shadowMapIndex := newShadowMapIndex.
	shadowMapIndex < 0 ifTrue: [ ^ self ].
	self setupShadowMappingTransforms
]

{ #category : #'shadow mapping' }
WDCAbstractLightRenderingState >> setupShadowMappingTransforms [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractLightRenderingState >> shadowMapIndex [
	^ shadowMapIndex
]

{ #category : #'as yet unclassified' }
WDCAbstractLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	^ renderingLight lightSource viewStateForRenderingState: self cameraTransform: cameraTransform
]

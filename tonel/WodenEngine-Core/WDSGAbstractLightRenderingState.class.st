"
I represent the rendering state for a light. I am used for computing shadow mapping transforms.
"
Class {
	#name : #WDSGAbstractLightRenderingState,
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
WDSGAbstractLightRenderingState >> engine [
	^ engine
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> globalTransform [
	^ renderingLight transform
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> light [
	^ renderingLight lightSource
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> mainCamera [
	^ mainCamera
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> mainCamera: anObject [
	mainCamera := anObject
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> renderingLight [
	^ renderingLight
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> renderingLight: anObject [
	renderingLight := anObject
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> scene [
	^ renderingLight node scene
]

{ #category : #'shadow mapping' }
WDSGAbstractLightRenderingState >> setupShadowMapWithIndex: newShadowMapIndex [
	shadowMapIndex := newShadowMapIndex.
	shadowMapIndex < 0 ifTrue: [ ^ self ].
	self setupShadowMappingTransforms
]

{ #category : #'shadow mapping' }
WDSGAbstractLightRenderingState >> setupShadowMappingTransforms [
	self subclassResponsibility
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> shadowMapIndex [
	^ shadowMapIndex
]

{ #category : #'as yet unclassified' }
WDSGAbstractLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	^ renderingLight lightSource viewStateForRenderingState: self cameraTransform: cameraTransform
]

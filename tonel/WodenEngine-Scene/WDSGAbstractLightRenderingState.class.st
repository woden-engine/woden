"
I represent the rendering state for a light. I am used for computing shadow mapping transforms.
"
Class {
	#name : #WDSGAbstractLightRenderingState,
	#superclass : #Object,
	#instVars : [
		'light',
		'shadowMapIndex',
		'engine',
		'mainCamera'
	],
	#category : #'WodenEngine-Scene-Rendering'
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
WDSGAbstractLightRenderingState >> light [
	^ light
]

{ #category : #accessing }
WDSGAbstractLightRenderingState >> light: anObject [
	light := anObject
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
WDSGAbstractLightRenderingState >> scene [
	^ light scene
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
	^ light viewStateForRenderingState: self cameraTransform: cameraTransform
]

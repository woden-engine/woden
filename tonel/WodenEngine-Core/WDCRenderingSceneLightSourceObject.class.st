Class {
	#name : #WDCRenderingSceneLightSourceObject,
	#superclass : #WDCAbstractRenderingSceneObject,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCRenderingSceneLightSourceObject >> computeBoundingBox [
	| radius box |
	radius := self lightSource radius.
	box :=  self isSpotLight ifTrue: [ 
		BoxF32 min: (Float32x3 x: radius negated y: radius negated z: radius negated)
			max: (Float32x3 x: radius y: radius z: 0)
	] ifFalse: [ 
		BoxF32 halfExtent: (Float32x3 x: radius y: radius z: radius)
	].
	^ box transformedWith: self transform
]

{ #category : #accessing }
WDCRenderingSceneLightSourceObject >> isDirectionalLight [
	^ self lightSource isDirectionalLight
]

{ #category : #accessing }
WDCRenderingSceneLightSourceObject >> isLightSource [
	^ true
]

{ #category : #accessing }
WDCRenderingSceneLightSourceObject >> isSpotLight [
	^ self lightSource isSpotLight
]

{ #category : #accessing }
WDCRenderingSceneLightSourceObject >> lightSource [
	^ spatialObject
]

{ #category : #'shadow mapping' }
WDCRenderingSceneLightSourceObject >> setupRenderingWithShadowMap: shadowMapIndex mainCamera: mainCamera engine: engine [
	^ spatialObject lightRenderingStateClass new
		renderingLight: self;
		mainCamera: mainCamera;
		engine: engine;
		setupShadowMapWithIndex: shadowMapIndex;
		yourself
]

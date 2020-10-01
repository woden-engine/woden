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
	| radius |
	radius := self lightSource radius.
	^ BoxF32 halfExtent: (Float32x3 x: radius y: radius z: radius)
		center: self transform translation
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

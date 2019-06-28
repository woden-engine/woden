Class {
	#name : #WDCRenderingSceneLightSourceObject,
	#superclass : #WDCAbstractRenderingSceneObject,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

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

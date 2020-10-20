"
I represent a spot light rendering state.
"
Class {
	#name : #WDCSpotLightRenderingState,
	#superclass : #WDCShadowLightRenderingStateLayer,
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #'shadow mapping' }
WDCSpotLightRenderingState >> setupShadowMappingTransforms [
	| fov lightSource |
	lightSource := renderingLight lightSource.
	renderTransform := lightSource transform.
	fov := lightSource isSpotLight ifTrue: [ lightSource outerSpotCutoff * 2.0 ] ifFalse: [ 90.0 ].
	shadowProjectionMatrix := Float32x4x4 reverseDepthPerspectiveFovY: fov aspect: 1.0 near: 0.01 far: lightSource radius invertedY: engine projectionInvertedY.

]

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
	fov := lightSource isSpotLight ifTrue: [ lightSource outerSpotCutoff ] ifFalse: [ 45.0 ].
	shadowProjectionMatrix := (WMMatrix4F reverseDepthPerspectiveFovY: fov * 2.0 aspect: 1.0 near: 0.01 far: 30.0 invertedY: engine projectionInvertedY).

]

"
I represent a spot light rendering state.
"
Class {
	#name : #WDSGSpotLightRenderingState,
	#superclass : #WDSGShadowLightRenderingStateLayer,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'shadow mapping' }
WDSGSpotLightRenderingState >> setupShadowMappingTransforms [
	| fov |
	renderTransform := light renderTransform.
	fov := light isSpotLight ifTrue: [ light outerSpotCutoff ] ifFalse: [ 45.0 ].
	shadowProjectionMatrix := (WMMatrix4F reverseDepthPerspectiveFovY: fov * 2.0 aspect: 1.0 near: 0.01 far: 30.0 invertedY: engine projectionInvertedY).

]

"
I represent the light rendering state for a light without shadow mapping
"
Class {
	#name : #WDSGNonShadowingLightRenderingState,
	#superclass : #WDSGAbstractLightRenderingState,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'shadow mapping' }
WDSGNonShadowingLightRenderingState >> setupShadowMappingTransforms [
]

{ #category : #'as yet unclassified' }
WDSGNonShadowingLightRenderingState >> shadowMapMatrixForCameraTransform: cameraTransform [
	^ WMMatrix4F zeros
]

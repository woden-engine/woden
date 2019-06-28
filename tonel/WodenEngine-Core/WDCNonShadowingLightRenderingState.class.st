"
I represent the light rendering state for a light without shadow mapping
"
Class {
	#name : #WDCNonShadowingLightRenderingState,
	#superclass : #WDCAbstractLightRenderingState,
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #'shadow mapping' }
WDCNonShadowingLightRenderingState >> setupShadowMappingTransforms [
]

{ #category : #'as yet unclassified' }
WDCNonShadowingLightRenderingState >> shadowMapMatrixForCameraTransform: cameraTransform [
	^ WMMatrix4F zeros
]

"
I represent the state for a single shadow map rendering layer.
"
Class {
	#name : #WDCShadowLightRenderingStateLayer,
	#superclass : #WDCAbstractLightRenderingState,
	#instVars : [
		'shadowProjectionMatrix',
		'renderTransform'
	],
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #accessing }
WDCShadowLightRenderingStateLayer >> cascades [
	^ { self }
]

{ #category : #accessing }
WDCShadowLightRenderingStateLayer >> globalTransform [
	^ renderTransform
]

{ #category : #accessing }
WDCShadowLightRenderingStateLayer >> renderTransform [
	^ renderTransform
]

{ #category : #'shadow mapping' }
WDCShadowLightRenderingStateLayer >> roundCameraCoordinate: aCoordinate [
	^ aCoordinate roundDownTo: 0.5
]

{ #category : #'shadow mapping' }
WDCShadowLightRenderingStateLayer >> roundCameraPosition: aPosition [
	^ Float32x3
		x: (self roundCameraCoordinate: aPosition x)
		y: (self roundCameraCoordinate: aPosition y)
		z: (self roundCameraCoordinate: aPosition z)
]

{ #category : #'shadow mapping' }
WDCShadowLightRenderingStateLayer >> roundCameraTransform: cameraTransform [
	^ cameraTransform copy translation: (self roundCameraPosition: cameraTransform translation)
]

{ #category : #'as yet unclassified' }
WDCShadowLightRenderingStateLayer >> shadowMapMatrixForCameraTransform: cameraTransform [
	^ engine projectiveTextureBiasMatrix * (shadowProjectionMatrix * (renderTransform inverseMatrix4 * cameraTransform matrix4))
]

{ #category : #accessing }
WDCShadowLightRenderingStateLayer >> shadowProjectionMatrix [
	^ shadowProjectionMatrix
]

{ #category : #'as yet unclassified' }
WDCShadowLightRenderingStateLayer >> viewStateForCameraTransform: cameraTransform [
	| state |
	state := renderingLight lightSource viewStateForRenderingState: self cameraTransform: cameraTransform.
	state
		shadowMapLayer: shadowMapIndex asFloat;
		shadowMapTransform: (self shadowMapMatrixForCameraTransform: cameraTransform).
	^ state
]

{ #category : #'as yet unclassified' }
WDCShadowLightRenderingStateLayer >> viewportForShadowMap: renderTarget camera: camera [
	^ self viewportForShadowMap: renderTarget camera: camera submode: #full
]

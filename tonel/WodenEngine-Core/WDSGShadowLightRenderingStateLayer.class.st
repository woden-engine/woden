"
I represent the state for a single shadow map rendering layer.
"
Class {
	#name : #WDSGShadowLightRenderingStateLayer,
	#superclass : #WDSGAbstractLightRenderingState,
	#instVars : [
		'shadowProjectionMatrix',
		'renderTransform'
	],
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #accessing }
WDSGShadowLightRenderingStateLayer >> cascades [
	^ { self }
]

{ #category : #accessing }
WDSGShadowLightRenderingStateLayer >> globalTransform [
	^ renderTransform
]

{ #category : #accessing }
WDSGShadowLightRenderingStateLayer >> renderTransform [
	^ renderTransform
]

{ #category : #'shadow mapping' }
WDSGShadowLightRenderingStateLayer >> roundCameraCoordinate: aCoordinate [
	^ aCoordinate roundDownTo: 0.5
]

{ #category : #'shadow mapping' }
WDSGShadowLightRenderingStateLayer >> roundCameraPosition: aPosition [
	^ WMVector3F
		x: (self roundCameraCoordinate: aPosition x)
		y: (self roundCameraCoordinate: aPosition y)
		z: (self roundCameraCoordinate: aPosition z)
]

{ #category : #'shadow mapping' }
WDSGShadowLightRenderingStateLayer >> roundCameraTransform: cameraTransform [
	^ cameraTransform copy translation: (self roundCameraPosition: cameraTransform translation)
]

{ #category : #'as yet unclassified' }
WDSGShadowLightRenderingStateLayer >> shadowMapMatrixForCameraTransform: cameraTransform [
	^ engine projectiveTextureBiasMatrix * (shadowProjectionMatrix * (renderTransform inverseMatrix4 * cameraTransform matrix4))
]

{ #category : #accessing }
WDSGShadowLightRenderingStateLayer >> shadowProjectionMatrix [
	^ shadowProjectionMatrix
]

{ #category : #'as yet unclassified' }
WDSGShadowLightRenderingStateLayer >> viewStateForCameraTransform: cameraTransform [
	| state |
	state := renderingLight lightSource viewStateForRenderingState: self cameraTransform: cameraTransform.
	state
		shadowMapLayer: shadowMapIndex asFloat;
		shadowMapTransform: (self shadowMapMatrixForCameraTransform: cameraTransform).
	^ state
]

{ #category : #'as yet unclassified' }
WDSGShadowLightRenderingStateLayer >> viewportForShadowMap: renderTarget camera: camera [
	^ self viewportForShadowMap: renderTarget camera: camera submode: #full
]

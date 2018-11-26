"
I represent a directional light rendering state.
"
Class {
	#name : #WDSGDirectionalLightRenderingState,
	#superclass : #WDSGShadowLightRenderingStateLayer,
	#instVars : [
		'cameraFrustum'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSGDirectionalLightRenderingState >> cameraFrustum [
	^ cameraFrustum ifNil: [cameraFrustum := mainCamera frustum ]
]

{ #category : #'as yet unclassified' }
WDSGDirectionalLightRenderingState >> nearDistance: nearDistance farDistance: farDistance [
	cameraFrustum := mainCamera frustumForNearDistance: nearDistance farDistance: farDistance
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> setupShadowMappingTransforms [
	| mainCameraTransform frustumBox orientation worldCorner direction extraShadowDistanceFactor |
	mainCameraTransform := self roundCameraTransform: mainCamera renderTransform.

	orientation := light renderTransform matrix.
	extraShadowDistanceFactor := light extraShadowDistanceFactor.
	direction := orientation transformVector3: (WMVector3F z: 1.0).

	renderTransform := WMReversibleAffineTransformF new.
	renderTransform orthonormal: orientation translation: mainCameraTransform translation.
	
	frustumBox := WMBox3DF empty.
	self cameraFrustum corners do: [ :corner |
		worldCorner := mainCameraTransform transformPosition3: corner.
		
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: worldCorner).
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: worldCorner + (direction * extraShadowDistanceFactor)).
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: worldCorner - (direction * extraShadowDistanceFactor)).
	].

	shadowProjectionMatrix := WMMatrix4F reverseDepthOrthoLeft: frustumBox min x right: frustumBox max x
		bottom: frustumBox min y top: frustumBox max y
		near: frustumBox min z far: frustumBox max z
		invertedY: engine projectionInvertedY

]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	| state |
	state := super viewStateForCameraTransform: cameraTransform.
	state
		cascadeSplitOffsets: (WMVector4F x: 0.0 y: 1.0 z: 0.0 w: 0.0);
		cascadeFrustumPlane: (WMVector4F x: 0.0 y: 0.0 z: 0.0 w: 0.0).
	^ state
]

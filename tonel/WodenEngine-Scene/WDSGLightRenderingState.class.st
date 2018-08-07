"
I represent the rendering state for a light. I am used for computing shadow mapping transforms.
"
Class {
	#name : #WDSGLightRenderingState,
	#superclass : #Object,
	#instVars : [
		'light',
		'shadowMapIndex',
		'engine',
		'mainCamera',
		'shadowProjectionMatrix',
		'renderTransform'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSGLightRenderingState >> engine [
	^ engine
]

{ #category : #accessing }
WDSGLightRenderingState >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDSGLightRenderingState >> light [
	^ light
]

{ #category : #accessing }
WDSGLightRenderingState >> light: anObject [
	light := anObject
]

{ #category : #accessing }
WDSGLightRenderingState >> mainCamera [
	^ mainCamera
]

{ #category : #accessing }
WDSGLightRenderingState >> mainCamera: anObject [
	mainCamera := anObject
]

{ #category : #accessing }
WDSGLightRenderingState >> renderTransform [
	^ renderTransform
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> roundCameraCoordinate: aCoordinate [
	^ aCoordinate roundDownTo: 0.5
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> roundCameraPosition: aPosition [
	^ WMVector3F
		x: (self roundCameraCoordinate: aPosition x)
		y: (self roundCameraCoordinate: aPosition y)
		z: (self roundCameraCoordinate: aPosition z)
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> roundCameraTransform: cameraTransform [
	^ cameraTransform copy translation: (self roundCameraPosition: cameraTransform translation)
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> setupDirectionalShadowMapping [
	| mainCameraTransform worldFrustumBox frustumBox orientation worldCorner direction |
	mainCameraTransform := self roundCameraTransform: mainCamera renderTransform.

	orientation := light renderTransform matrix.
	direction := orientation transformVector3: (WMVector3F z: 1.0).

	worldFrustumBox := WMBox3DF empty.
	mainCamera frustum corners do: [ :corner |
		worldCorner := mainCameraTransform transformPosition3: corner.
		
		worldFrustumBox insertPoint: worldCorner + (direction * 10.0).
	].

	renderTransform := WMReversibleAffineTransformF new.
	renderTransform orthonormal: orientation translation: worldFrustumBox center.

	frustumBox := WMBox3DF empty.
	worldFrustumBox cornersDo: [ :corner |
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: corner).
	].

	shadowProjectionMatrix := WMMatrix4F reverseDepthOrthoLeft: frustumBox min x right: frustumBox max x
		bottom: frustumBox min y top: frustumBox max y
		near: frustumBox min z far: frustumBox max z
		invertedY: engine projectionInvertedY
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> setupShadowMapWithIndex: newShadowMapIndex [
	shadowMapIndex := newShadowMapIndex.
	shadowMapIndex < 0 ifTrue: [ ^ self ].
	
	light isSpotLight ifTrue: [ ^ self setupSpotLightShadowMapping. ].
	light isDirectionalLight ifTrue: [ ^ self setupDirectionalShadowMapping. ].
	shadowProjectionMatrix := WMMatrix4F identity. "Not supported light for shadow mapping"
]

{ #category : #'shadow mapping' }
WDSGLightRenderingState >> setupSpotLightShadowMapping [
	| fov |
	renderTransform := light renderTransform.
	fov := light isSpotLight ifTrue: [ light outerSpotCutoff ] ifFalse: [ 45.0 ].
	shadowProjectionMatrix := (WMMatrix4F reverseDepthPerspectiveFovY: fov * 2.0 aspect: 1.0 near: 0.01 far: 30.0 invertedY: engine projectionInvertedY).

]

{ #category : #accessing }
WDSGLightRenderingState >> shadowMapIndex [
	^ shadowMapIndex
]

{ #category : #'as yet unclassified' }
WDSGLightRenderingState >> shadowMapMatrixForCameraTransform: cameraTransform [
	^ shadowProjectionMatrix * (renderTransform inverseMatrix4 * cameraTransform matrix4)
]

{ #category : #'as yet unclassified' }
WDSGLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	^ light viewStateForRenderingState: self cameraTransform: cameraTransform
]

{ #category : #'as yet unclassified' }
WDSGLightRenderingState >> viewportForShadowMap: renderTarget camera: camera [
	^ self viewportForShadowMap: renderTarget camera: camera submode: #full
]

{ #category : #'as yet unclassified' }
WDSGLightRenderingState >> viewportForShadowMap: renderTarget camera: camera submode: submode [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: shadowProjectionMatrix.

	^ WDSGViewport new
		camera: self;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: renderTarget;
		bounds: renderTarget bounds;
		submode: submode
]

Extension { #name : #WDCShadowLightRenderingStateLayer }

{ #category : #'*WodenEngine-Scene' }
WDCShadowLightRenderingStateLayer >> viewportForShadowMap: renderTarget camera: camera submode: submode [
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

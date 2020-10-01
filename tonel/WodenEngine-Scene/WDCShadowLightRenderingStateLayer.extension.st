Extension { #name : #WDCShadowLightRenderingStateLayer }

{ #category : #'*WodenEngine-Scene' }
WDCShadowLightRenderingStateLayer >> viewportForShadowMap: renderTarget camera: camera submode: submode [
	| cameraState |
	cameraState := WDCCameraState new.
	cameraState
		projectionMatrix: shadowProjectionMatrix;
		clipMapCameraPosition: camera globalTransform translation.

	^ WDSGViewport new
		camera: self;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: renderTarget;
		bounds: renderTarget bounds;
		submode: submode
]

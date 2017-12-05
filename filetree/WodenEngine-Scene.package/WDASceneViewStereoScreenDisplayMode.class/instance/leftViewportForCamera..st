multi eye rendering
leftViewportForCamera: camera
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix;
		transform: self leftCameraTransform.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		bounds: leftRenderTarget bounds;
		submode: #full
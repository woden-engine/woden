multi eye rendering
rightViewportForCamera: camera
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix;
		transform: self rightCameraTransform.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		bounds: rightRenderTarget bounds;
		submode: #full
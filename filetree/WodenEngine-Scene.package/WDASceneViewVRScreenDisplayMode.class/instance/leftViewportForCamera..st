multi eye rendering
leftViewportForCamera: camera
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		bounds: leftRenderTarget bounds;
		cameraTransformFunction: [ :ct | self applyVRTransformToCamera: ct eye: (WMVector3F x: ipd * -0.5) ];
		submode: #full
multi eye rendering
rightViewportForCamera: camera
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		bounds: rightRenderTarget bounds;
		cameraTransformFunction: [ :ct | self applyVRTransformToCamera: ct eye: (WMVector3F x: ipd * 0.5) ];
		submode: #full
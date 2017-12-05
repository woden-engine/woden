as yet unclassified
viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveRenderTarget submode: submode
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: (self computeProjectionMatrixFor: camera).
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: resolveRenderTarget;
		bounds: renderTarget bounds;
		submode: submode
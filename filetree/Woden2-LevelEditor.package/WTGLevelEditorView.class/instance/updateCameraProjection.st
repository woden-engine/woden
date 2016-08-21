as yet unclassified
updateCameraProjection
	| aspect h w |
	aspect := self computeAspectRatio.
	cameraFrustum := WMFrustumF new.
	isPerspective ifTrue: [
		cameraFrustum reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: PerspectiveNearDistance far: PerspectiveFarDistance invertedY: editor engine projectionInvertedY.
	] ifFalse: [
		h := viewScale.
		w := h * aspect.
		cameraFrustum reverseDepthOrthoLeft: w negated right: w bottom: h negated top: h near: OrthographicNearDistance far: OrthographicFarDistance invertedY: editor engine projectionInvertedY.
	].

	camera state 
		projectionMatrix: cameraFrustum matrix.
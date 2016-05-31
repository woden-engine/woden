rendering
computeProjectionMatrixFor: aWindow
	| aspect h w |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	aspect := 1.0.
	h := 2.0.
	w := h * aspect.
	canvasViewport projectionMatrix: (WMMatrix4F orthoLeft: w negated right: w bottom: h negated top: h  near: -10.0 far: 10.0 invertedY: engine projectionInvertedY).
	Transcript show: canvasViewport projectionMatrix; cr.
rendering
computeProjectionMatrixFor: aWindow
	| aspect h w projectionMatrix viewMatrix |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	h := 2.0.
	w := h * aspect.
	viewMatrix := WMMatrix4F mat3: (WMMatrix3F yrot: DateAndTime millisecondClockValue *0.001 * Float pi).
	projectionMatrix := WMMatrix4F orthoLeft: w negated right: w bottom: h negated top: h  near: -10.0 far: 10.0 invertedY: engine projectionInvertedY.
	canvasViewport
		viewMatrix: viewMatrix;
		projectionMatrix: projectionMatrix.
	"Transcript
		show: canvasViewport viewMatrix; cr;
		show: canvasViewport projectionMatrix; cr;
		show: projectionMatrix; cr."
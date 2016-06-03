private
computeProjectionMatrix
	| w h |
	w := extent x asFloat.
	h := extent y asFloat.
	viewportUniformData projectionMatrix: (
		WMMatrix4F
			orthoLeft: 0.0 right: w
			bottom: h top: 0.0
			near: -10.0 far: 10.0
			invertedY: engine projectionInvertedY)
as yet unclassified
computeProjectionMatrixFor: camera
	| aspect target |
	target := view window validRenderTarget.
	aspect := target width asFloat / target height asFloat.
	^ camera isPerspective ifTrue: [
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	] ifFalse: [
		"TODO: Compute a proper orthographic projection"
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	]
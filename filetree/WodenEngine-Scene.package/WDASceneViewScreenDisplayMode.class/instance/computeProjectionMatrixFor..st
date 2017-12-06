as yet unclassified
computeProjectionMatrixFor: camera
	| aspect extent |
	extent := view window drawingSurfaceExtent.
	aspect := extent x asFloat / extent y asFloat.
	^ camera isPerspective ifTrue: [
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	] ifFalse: [
		"TODO: Compute a proper orthographic projection"
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	]
projections
reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	projectionMode == #stereo ifTrue: [
		^ self stereoReverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	].
	projectionMode == #vr ifTrue: [
		^ self vrReverseDepthPerspectiveNear: near far: far invertedY: invertedY
	].

	eyes do: [ :eye |
		eye reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	]
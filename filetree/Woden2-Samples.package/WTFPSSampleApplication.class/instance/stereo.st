initialize
stereo
	| transform |
	transform := WMReversibleAffineTransformF identity.
	camera ifNotNil: [
		transform := camera transform.
		scene remove: camera
	].

	camera := WTSMultiEyeCamera stereo.
	camera transform: transform.
	scene add: camera.
	stereoMode := true.
	
	camera stereoIPD: 0.065 focalDistance: 1.0
initialize
stereo
	camera ifNotNil: [ scene remove: camera ].
	camera := WTSMultiEyeCamera stereo.
	scene add: camera.
	stereoMode := true.
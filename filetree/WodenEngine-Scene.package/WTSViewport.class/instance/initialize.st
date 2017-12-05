initialization
initialize
	super initialize.
	filter := [ :object | true ].
	cameraTransformFunction := [ :x | x ]
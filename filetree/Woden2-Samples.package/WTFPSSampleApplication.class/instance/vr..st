initialize
vr: aHeadsetDescription
	self stereo.
	vrMode := true.
	vrSensorReader := WTVRSensorReader current.
	vrSensorReader activate.
	compositionPipelineState := engine pipelineStateNamed: #'composition.vr'.
	camera vrHeadsetDescription: aHeadsetDescription.
	
	aHeadsetDescription state storeBytesIn: compositionStateBuffer validPointer getHandle position: 1.
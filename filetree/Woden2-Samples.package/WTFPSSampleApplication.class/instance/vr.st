initialize
vr
	self stereo.
	vrMode := true.
	compositionPipelineState := engine pipelineStateNamed: #'composition.vr'.

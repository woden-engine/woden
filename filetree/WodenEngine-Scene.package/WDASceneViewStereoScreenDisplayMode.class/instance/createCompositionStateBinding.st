rendering process stages
createCompositionStateBinding
	compositionState := WTCompositionState new.
	compositionStateBinding := self shaderSignature newParameters.
	self createCompositionStateBuffer
rendering process stages
createCompositionStateBuffer
	compositionStateBuffer := engine createStreamingUniformBuffer: WTCompositionState structureSize.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.
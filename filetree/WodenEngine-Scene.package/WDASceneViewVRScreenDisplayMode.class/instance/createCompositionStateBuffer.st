rendering process stages
createCompositionStateBuffer
	compositionStateBuffer := engine createStreamingUniformBuffer: WTVRState structureSize.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.
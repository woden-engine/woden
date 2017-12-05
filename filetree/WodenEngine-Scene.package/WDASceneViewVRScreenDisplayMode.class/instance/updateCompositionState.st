rendering process stages
updateCompositionState
	super updateCompositionState.
	vrState := headsetDescription state.
	vrState compositionState: compositionState.
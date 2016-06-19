private
resetDrawState
	deferredDrawCommands removeAll.
	pathTransform loadIdentity.
	vertices removeAll.
	indices removeAll.
	colorRampEntries removeAll.
	colorRampDictionary removeAll.
	startIndex := 0.
	baseVertex := 0.
	
	currentShapeType := nil.
	currentPipelineState := nil.
	currentTexture := nil.
	currentFont := nil.
	currentTexcoord := WMVector2F new.
	
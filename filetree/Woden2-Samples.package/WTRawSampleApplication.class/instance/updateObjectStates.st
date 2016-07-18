rendering
updateObjectStates
	| states stateSize pointer baseOffset renderCameraObjectState |
	renderCameraObjectState := cameraObjectState copy.
	self simulateCamera: renderCameraObjectState time: accumulatedUpdateTime.
	
	states := {meshObjectState . renderCameraObjectState }.
"	Transcript show: cameraPosition; cr."
	stateSize := WTGenericObjectState structureSize alignedTo: 256.
	pointer := objectStateBuffer validPointer getHandle.
	baseOffset := (engine bufferingFrameIndex - 1) * stateSize * 2 + 1.
	states doWithIndex: [ :state :i |
		"Transcript show: i; show:' offset: '; show: (i-1) * stateSize + baseOffset - 1; cr."
		state storeBytesIn: pointer position: (i-1) * stateSize + baseOffset
	]
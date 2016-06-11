rendering
updateObjectStates
	| states stateSize pointer baseOffset |
	states := {meshObjectState . cameraObjectState }.
	cameraPosition := cameraPosition + (cameraVelocity * (cameraSpeed * 1.0 / 60.0)).
	cameraObjectState inverseModelMatrix: (WMMatrix4F translation: cameraPosition negated).
"	Transcript show: cameraPosition; cr."
	stateSize := WTObjectState structureSize alignedTo: 256.
	pointer := objectStateBuffer validPointer getHandle.
	baseOffset := (engine bufferingFrameIndex - 1) * stateSize * 2 + 1.
	states doWithIndex: [ :state :i |
		state storeBytesIn: pointer position: (i-1) * stateSize + baseOffset
	]
public
drawDuring: aBlock
	self checkSession.
	currentCanvas ifNotNil: [ ^ self attemptToRecurseDrawing ].
	changedData := true.
	synchronizationFence ifNotNil: [ synchronizationFence waitOnClient ].
	self resetDrawState.
	[
		currentCanvas := self newCanvas.
		aBlock value: currentCanvas.
	] ensure: [
		self releaseCanvas.
		currentCanvas := nil.
	].

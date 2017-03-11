public
drawDuring: aBlock
	self checkSession.
	currentCanvas ifNotNil: [ ^ self attemptToRecurseDrawing ].
	changedData := true.
	self waitFence.
	self resetDrawState.
	[
		currentCanvas := self newCanvas.
		aBlock value: currentCanvas.
	] ensure: [
		self releaseCanvas.
		currentCanvas := nil.
	].

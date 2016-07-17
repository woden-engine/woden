event handling
startDragController: aDrawToolController event: anEvent
	aDrawToolController ifNotNil: [
		aDrawToolController view: self.
	].

	self toolController: aDrawToolController.
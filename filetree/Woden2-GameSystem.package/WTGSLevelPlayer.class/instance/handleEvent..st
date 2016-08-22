as yet unclassified
handleEvent: anEvent
	super handleEvent: anEvent.
	playerEventHandler ifNotNil: [
		[
			playerEventHandler handleEvent: anEvent
		] on: Error do: [ :error |
			self releaseMouse.
			error freeze.
			[ error debug ] fork.
		]
	]
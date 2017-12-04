as yet unclassified
simulateTime: delta
	super simulateTime: delta.
	map ifNotNil: [
		[
			map simulateTime: delta
		] on: Error do: [ :error |
			self releaseMouse.
			error freeze.
			[ error debug ] fork.
		]
	].
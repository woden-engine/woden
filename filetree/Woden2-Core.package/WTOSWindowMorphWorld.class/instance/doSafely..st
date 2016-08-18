render thread
doSafely: aBlock
	aBlock on: Error do: [ :error |
		error freeze.
		[ error debug ] fork.
	]
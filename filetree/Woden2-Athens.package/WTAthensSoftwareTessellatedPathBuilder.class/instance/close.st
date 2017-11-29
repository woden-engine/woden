path commands
close
	closed ifTrue: [ ^ self ].
	backend subpathClosed.
	closed := false.

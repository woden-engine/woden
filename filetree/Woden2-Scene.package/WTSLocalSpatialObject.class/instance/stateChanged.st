changing
stateChanged
	super stateChanged.
	parent ifNotNil: [ parent addPendingUpdate: self ]
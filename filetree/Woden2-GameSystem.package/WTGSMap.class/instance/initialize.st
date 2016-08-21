initialization
initialize
	super initialize.
	entities := OrderedCollection new.
	editorMode := false.
	timeListeners := Set new.
	touchListeners := Set new.
	backgroundColor := Color veryDarkGray.
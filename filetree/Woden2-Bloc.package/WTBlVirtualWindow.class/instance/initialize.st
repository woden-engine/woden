accessing
initialize
	super initialize.
	position := 0@0.
	resizable := false.
	borderless := false.
	title := 'Untitled'.
	self initHostWindow.
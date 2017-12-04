initialization
initializeForNewSession
	engine checkSession.
	renderTarget := nil.
	lastMousePosition := 0@0.
	self checkRenderTarget.

	session := Smalltalk session.
	
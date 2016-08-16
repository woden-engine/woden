initialization
initializeApplication
	super initializeApplication.
	
	"Athens surfaces"
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].

	"Fps counter"
	fpsCount := 0.
	lastFpsDisplay := Time millisecondClockValue * 0.001.
	dragElement := nil.
	mouseFocusElement := nil.
	keyboardFocusElement := nil.

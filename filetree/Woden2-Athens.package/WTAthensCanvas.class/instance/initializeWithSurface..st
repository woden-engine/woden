initialization
initializeWithSurface: anAthensSurface
	super initializeWithSurface: anAthensSurface.
	paintOptions := WTAthensPaintOptions on: anAthensSurface.
	paintOptions composeDefault
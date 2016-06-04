initialization
initializeWithSurface: anAthensSurface
	super initializeWithSurface: anAthensSurface.
	paintMode := WTAthensPaintMode on: anAthensSurface.
	paintMode default
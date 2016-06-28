rendering
initializeApplication
	super initializeApplication.
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].
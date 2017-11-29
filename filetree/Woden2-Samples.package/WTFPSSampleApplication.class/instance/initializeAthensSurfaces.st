initialize
initializeAthensSurfaces
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].
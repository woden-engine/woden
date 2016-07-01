rendering
initializeApplication
	super initializeApplication.
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].
	mainBlocSpace := self createMainBlocSpace.
	mainBlocSpace ifNotNil: [ self activateBlocSpace: mainBlocSpace ].
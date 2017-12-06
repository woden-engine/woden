initialization
canvas
	(session ~~ TRPlatform current session or: [ canvas isNil ]) ifTrue: [ 
		canvas := self createCanvasWithExtent: extent asIntegerPoint.
		session := TRPlatform current session
	].
	^ canvas
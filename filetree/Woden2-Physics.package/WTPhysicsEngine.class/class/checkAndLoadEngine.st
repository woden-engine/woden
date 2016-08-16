accessing
checkAndLoadEngine
	(CurrentEngine == nil or: [ PhysicsSession ~~ Smalltalk session ]) ifTrue: [ 
		CurrentEngine := self pickEngine.
		PhysicsSession := Smalltalk session.
	].
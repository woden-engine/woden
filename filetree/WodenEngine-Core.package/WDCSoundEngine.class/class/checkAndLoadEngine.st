accessing
checkAndLoadEngine
	(CurrentEngine == nil or: [ SoundSession ~~ Smalltalk session ]) ifTrue: [ 
		CurrentEngine := self pickEngine.
		SoundSession := Smalltalk session.
	].
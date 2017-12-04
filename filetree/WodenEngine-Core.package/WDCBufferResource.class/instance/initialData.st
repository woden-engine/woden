resource building
initialData
	^ data isSessionPersistentExternalBuffer ifTrue: [ data data ] ifFalse: [ data ].
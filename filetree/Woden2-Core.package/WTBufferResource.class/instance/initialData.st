resource building
initialData
	^ data isSessionPersistentExternalBuffer ifTrue: [ data isSessionPersistentExternalBuffer ] ifFalse: [ false ].
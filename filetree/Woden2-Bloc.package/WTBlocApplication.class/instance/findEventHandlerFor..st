as yet unclassified
findEventHandlerFor: anEvent
	mainBlocSpace ifNotNil: [ ^ mainBlocSpace hostWindow eventHandler ].
	^ self
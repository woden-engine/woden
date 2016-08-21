event handling
onScrollEvent: event
	isPerspective ifTrue: [ ^ self ].
	
	event direction = Character arrowUp ifTrue: [ 
		viewScale := viewScale * 0.8.
	].
	event direction = Character arrowDown ifTrue: [ 
		viewScale := viewScale * 1.2.
	].
	selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]
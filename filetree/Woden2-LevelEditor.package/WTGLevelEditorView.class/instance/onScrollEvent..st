event handling
onScrollEvent: event
	isPerspective ifTrue: [
		event direction = Character arrowUp ifTrue: [ 
			cameraTransform translateByZ: -0.2.
		].
		event direction = Character arrowDown ifTrue: [ 
			cameraTransform translateByZ: 0.2.
		].
	] ifFalse: [
		event direction = Character arrowUp ifTrue: [ 
			viewScale := viewScale * 0.8.
		].
		event direction = Character arrowDown ifTrue: [ 
			viewScale := viewScale * 1.2.
		].
		selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]
	]
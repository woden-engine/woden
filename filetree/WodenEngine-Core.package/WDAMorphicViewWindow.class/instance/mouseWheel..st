event handling
mouseWheel: evt
	| osEvent |
	view ifNotNil: [
		osEvent := OSMouseWheelEvent new.
		self mouseEventCommon: evt putOn: osEvent.
		evt isUp ifTrue: [ evt scrollVertical: 1 ].
		evt isDown ifTrue: [ evt scrollVertical: -1 ].
		evt isLeft ifTrue: [ evt scrollHorizontal: -1 ].
		evt isRight ifTrue: [ evt scrollHorizontal: 1 ].
		view handleEvent: osEvent.
	].

	evt inspect
event handling
onKeyUpEvent: anEvent
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyUpEvent: anEvent ].
	keyValue := anEvent keyValue.
	
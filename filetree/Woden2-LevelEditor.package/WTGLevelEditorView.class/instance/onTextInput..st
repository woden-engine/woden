event handling
onTextInput: anEvent
	toolController ifNotNil: [ ^ toolController onTextInput: anEvent ].
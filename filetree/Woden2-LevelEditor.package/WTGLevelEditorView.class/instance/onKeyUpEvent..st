event handling
onKeyUpEvent: anEvent
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyUpEvent: anEvent ].
	keyValue := anEvent keyValue.
	
	keyValue = OSK_a ifTrue: [ cameraVelocity := WMVector3D x: 0.0 ].
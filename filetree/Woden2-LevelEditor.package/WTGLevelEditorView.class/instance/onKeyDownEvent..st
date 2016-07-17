event handling
onKeyDownEvent: anEvent
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyDownEvent: anEvent ].
	keyValue := anEvent keyValue.
	
	keyValue = OSK_KP_7 ifTrue: [ self topView ].
	keyValue = OSK_KP_1 ifTrue: [ self frontView ].
	keyValue = OSK_KP_3 ifTrue: [ self sideView ].
	
	keyValue = OSK_RETURN ifTrue: [ editor addCubeBrushAtSelectionCube ].
	
	((anEvent buttons anyMask: 2r01000000) and: [ keyValue = OSK_i ]) ifTrue: [ self inspect ].
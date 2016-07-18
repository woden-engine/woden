event handling
onKeyDownEvent: anEvent
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyDownEvent: anEvent ].
	keyValue := anEvent keyValue.

	(keyValue = OSK_MINUS or: [keyValue = OSK_KP_MINUS]) ifTrue: [ editor subtractSelectedBrushes ].
		
	keyValue = OSK_KP_7 ifTrue: [ self topView ].
	keyValue = OSK_KP_1 ifTrue: [ self frontView ].
	keyValue = OSK_KP_3 ifTrue: [ self sideView ].
	
	keyValue = OSK_RETURN ifTrue: [ editor addCubeBrushAtSelectionCube ].
	
	keyValue = OSK_DELETE ifTrue: [ editor removeSelectedComponents ].
	
	keyValue = OSK_w ifTrue: [ self wireframe ].
	keyValue = OSK_s ifTrue: [ self solid ].
	keyValue = OSK_t ifTrue: [ self textured ].	

	((anEvent buttons anyMask: 2r01000000) and: [ keyValue = OSK_i ]) ifTrue: [ self inspect ].
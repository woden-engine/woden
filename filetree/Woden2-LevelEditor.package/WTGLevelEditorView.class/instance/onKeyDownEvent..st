event handling
onKeyDownEvent: anEvent
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyDownEvent: anEvent ].
	keyValue := anEvent keyValue.

	(anEvent modifiers isCmd or: [ anEvent modifiers isCtrl ]) ifTrue: [
		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt ]) ifTrue: [
			keyValue = OSK_s ifTrue: [ editor saveAs ].
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt not ]) ifTrue: [ 
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt ]) ifTrue: [ 
			keyValue = OSK_i ifTrue: [ self inspect ]
		].

		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt not]) ifTrue: [ 
			keyValue = OSK_a ifTrue: [ editor addPointEntity: cameraTransform translation ].
			keyValue = OSK_l ifTrue: [ editor addLightEntity: cameraTransform translation ].
			keyValue = OSK_b ifTrue: [ editor makeBrushEntity ].
						
			keyValue = OSK_s ifTrue: [ editor save ].
			keyValue = OSK_o ifTrue: [ editor open ].
			keyValue = OSK_t ifTrue: [ editor openTextureTransformEditor ].
			
			keyValue = OSK_i ifTrue: [ editor inspectSelection ]
		].
	
	] ifFalse: [ 
		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt not]) ifTrue: [ 
			(keyValue = OSK_MINUS or: [keyValue = OSK_KP_MINUS]) ifTrue: [ editor subtractSelectedBrushes ].
		
			keyValue = OSK_KP_7 ifTrue: [ self topView ].
			keyValue = OSK_KP_1 ifTrue: [ self frontView ].
			keyValue = OSK_KP_3 ifTrue: [ self sideView ].
	
			keyValue = OSK_RETURN ifTrue: [ editor addCubeBrushAtSelectionCube ].	
			keyValue = OSK_DELETE ifTrue: [ editor removeSelectedComponents ].
	
			keyValue = OSK_w ifTrue: [ self wireframe ].
			keyValue = OSK_s ifTrue: [ self solid ].
			keyValue = OSK_t ifTrue: [ self textured ].	
				
			keyValue = OSK_f ifTrue: [ editor toggleFaceSelectMode ].	
		].

		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt ]) ifTrue: [ 
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt not ]) ifTrue: [ 
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt ]) ifTrue: [ 
		].
	]
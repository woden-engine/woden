as yet unclassified
updateGridTransform
	| orientation scale renderPriority u v cameraTranslation du dv translation |
	orientation := isPerspective ifTrue: [ WMMatrix3F lookAtBottom ] ifFalse: [ gridOrientation ].
	renderPriority := isPerspective
		ifTrue: [ WTSNode renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WTSNode renderPriorityEditorOpaqueBefore ].
		
	scale := gridSize / baseGridSize.
	u := orientation firstRow asWMVector3D.
	v := orientation secondRow asWMVector3D.
	
	cameraTranslation := cameraTransform translation.
	du := self roundFloor: (u dot: cameraTranslation) quantum: self primaryGridSize.
	dv := self roundFloor: (v dot: cameraTranslation) quantum: self primaryGridSize.
	
	translation := (u * du) + (v * dv).
	
	primaryGrid renderPriority: renderPriority + 1.
	primaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asWMVector3F.
		
	secondaryGrid renderPriority: renderPriority.
	secondaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asWMVector3F.
		
	centerAxis renderPriority: renderPriority + 2.
as yet unclassified
onDragEvent: event
	| newPosition u v rotation angle |
	newPosition := view globalPointToLocal: event position.
	
	u := startPosition asWMComplexF - pivotPoint asWMComplexF.
	v := newPosition asWMComplexF - pivotPoint asWMComplexF.
	(v closeTo: [ WMComplexF new ]) ifTrue: [ 
		angle := 0.0.
	] ifFalse: [ 
		rotation := v / u.
		angle := rotation angle.
	].

	onNewRotation value: angle
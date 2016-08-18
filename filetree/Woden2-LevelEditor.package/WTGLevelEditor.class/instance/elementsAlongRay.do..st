selection
elementsAlongRay: ray do: aBlock
	| selectionMode |
	selectionBoxView elementsAlongRay: ray do: aBlock.
	
	selectionMode := self isFaceSelectMode
		ifTrue: [ #face ]
		ifFalse: [ #brush ].
	map elementsAlongRay: ray mode: selectionMode do: aBlock
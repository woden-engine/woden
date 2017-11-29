selection
elementsAlongRay: ray do: aBlock
	| selectionMode |
	selectionMode := self isFaceSelectMode
		ifTrue: [ #face ]
		ifFalse: [ #entity"#brush" ].
	map elementsAlongRay: ray mode: selectionMode do: aBlock
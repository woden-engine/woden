as yet unclassified
expand: actualExpansion box: oldBox

	| left right bottom top near far |
	left := oldBox min x.
	right := oldBox max x.
	
	bottom := oldBox min y.
	top := oldBox max y.
	
	near := oldBox min z.
	far := oldBox max z.
	
	(direction x closeTo: 0.0) ifFalse: [ 
		direction x > 0.0
			ifTrue: [ right := right + actualExpansion x ]
			ifFalse: [ left := left - actualExpansion x ]
	].

	(direction y closeTo: 0.0) ifFalse: [ 
		direction y > 0.0
			ifTrue: [ top := top + actualExpansion y ]
			ifFalse: [ bottom := bottom - actualExpansion y ]
	].

	(direction z closeTo: 0.0) ifFalse: [ 
		direction z > 0.0
			ifTrue: [ far := far + actualExpansion z ]
			ifFalse: [ near := near - actualExpansion z ]
	].

	^ WMBox3DD empty
		insertPoint: (WMVector3D x: left y: bottom z: near);
		insertPoint: (WMVector3D x: right y: top z: far);
		yourself
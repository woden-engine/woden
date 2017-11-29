as yet unclassified
expand: actualExpansion direction: expandDirection box: oldBox

	| left right bottom top near far |
	
	left := oldBox min x.
	right := oldBox max x.
	
	bottom := oldBox min y.
	top := oldBox max y.
	
	near := oldBox min z.
	far := oldBox max z.
	
	(expandDirection x closeTo: 0.0) ifFalse: [ 
		expandDirection x > 0.0
			ifTrue: [ right := right + actualExpansion x ]
			ifFalse: [ left := left - actualExpansion x ]
	].

	(expandDirection y closeTo: 0.0) ifFalse: [ 
		expandDirection y > 0.0
			ifTrue: [ top := top + actualExpansion y ]
			ifFalse: [ bottom := bottom - actualExpansion y ]
	].

	(expandDirection z closeTo: 0.0) ifFalse: [ 
		expandDirection z > 0.0
			ifTrue: [ far := far + actualExpansion z ]
			ifFalse: [ near := near - actualExpansion z ]
	].

	^ WMBox3DD 
		nx: (left min: right) ny: (bottom min: top) nz: (near min: far)
		px: (left max: right) py: (bottom max: top) pz: (near max: far)
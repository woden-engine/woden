private
computeSubtreeBounds: subtreeRoot
	| bounds childBounds rootBounds childrenNodes w d pos |
	bounds := nil.
	childrenNodes := self childrenFor: subtreeRoot.
	childrenNodes do: [ :cn | 
		childBounds := self subtreeBounds: cn.
		bounds ifNil: [ bounds := childBounds ] ifNotNil: [ bounds := bounds merge: childBounds ]
	].

	w := subtreeRoot width.
	d := subtreeRoot depth.
	pos := subtreeRoot position.
	rootBounds := (w negated + pos x @ d negated + pos z) rectangle: (w + pos x @ d + pos z).
	bounds ifNil: [ bounds := rootBounds ]
			ifNotNil: [ bounds := bounds merge: (Rectangle center: bounds center extent: rootBounds extent) ].
	
	^ bounds.
space-calculation
recalculateFreeSpacesWith: aRectangle
	freeSpace := freeSpace inject: Set new into: [ :set :space |
		 set
			addAll: (self
				areasOverlaping: space
				outsideOf: (aRectangle expandBy: gap)); 
			yourself ].
		
	"remove subspaces"
	freeSpace := freeSpace reject: [ :subspace | 
		freeSpace anySatisfy: [ :space |
			space ~~ subspace and: [ 
				space containsRect: subspace ] ] ]
	
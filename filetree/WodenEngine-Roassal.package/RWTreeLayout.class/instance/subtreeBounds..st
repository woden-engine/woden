protected
subtreeBounds:  subtreeRoot
	^ self computeSubtreeBounds: subtreeRoot
"	| bounds |
	^ subtreeBounds at: subtreeRoot 
		ifAbsent: [ bounds := self computeSubtreeBounds: subtreeRoot.
			subtreeBounds at: subtreeRoot put: bounds.
			^ bounds ]"
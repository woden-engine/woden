Class {
	#name : #RWGridTreeLayout,
	#superclass : #RWTreeLayout,
	#category : 'Woden2-Roassal-Layout'
}

{ #category : #protected }
RWGridTreeLayout >> distributeSubtreeNodes: subtreeNodes withBounds: allBounds [
	| oldPositions delta oldShapes nodeBounds |
	oldPositions := Array new: subtreeNodes size.
	oldShapes := Array new: subtreeNodes size.
	
	subtreeNodes doWithIndex: [ :n :i |
		nodeBounds := allBounds at: i.
		oldPositions at: i put: n position.
		oldShapes at: i put: n shape.
		n shape: (RWNullShape new width: nodeBounds width; height: 1.0; depth: nodeBounds height; yourself).
	].

	RWXZGridLayout on: subtreeNodes.
	
	subtreeNodes doWithIndex: [ :n :i |
		n translateToY: (oldPositions at: i) y.
		n shape: (oldShapes at: i).
		delta := n position - (oldPositions at: i).
		self translate: delta subtree: n.
		(subtreeBounds at: n put: nil).
	].
]

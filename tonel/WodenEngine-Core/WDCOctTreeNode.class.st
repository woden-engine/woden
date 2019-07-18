Class {
	#name : #WDCOctTreeNode,
	#superclass : #WDCQuadTreeNode,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #'as yet unclassified' }
WDCOctTreeNode >> createChildrenNodes [
	^ boundingBox octants collect: [ :octant |
		self class new
			boundingBox: octant;
			maxDepth: maxDepth - 1;
			yourself.
	].
]

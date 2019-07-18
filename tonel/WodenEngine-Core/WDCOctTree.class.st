Class {
	#name : #WDCOctTree,
	#superclass : #WDCQuadTree,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #configuration }
WDCOctTree >> nodeClass [
	^ WDCOctTreeNode
]

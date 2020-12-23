Class {
	#name : #WCADSolidBSPInSetLeafNode,
	#superclass : #WCADSolidBSPLeafNode,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #testing }
WCADSolidBSPInSetLeafNode >> isInSetLeaf [
	^ true
]

{ #category : #building }
WCADSolidBSPInSetLeafNode >> unionWith: otherTree [
	^ self
]

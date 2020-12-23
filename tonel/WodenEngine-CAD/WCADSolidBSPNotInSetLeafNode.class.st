Class {
	#name : #WCADSolidBSPNotInSetLeafNode,
	#superclass : #WCADSolidBSPLeafNode,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #testing }
WCADSolidBSPNotInSetLeafNode >> isNotInSetLeaf [
	^ true
]

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> unionWith: otherTree [
	^ otherTree
]

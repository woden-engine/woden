Class {
	#name : #WCADSolidBSPInSetLeafNode,
	#superclass : #WCADSolidBSPLeafNode,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #building }
WCADSolidBSPInSetLeafNode >> complement [
	^ WCADSolidBSPNode notInSetLeaf
]

{ #category : #building }
WCADSolidBSPInSetLeafNode >> differenceWith: otherTree [
	^ otherTree complement
]

{ #category : #'as yet unclassified' }
WCADSolidBSPInSetLeafNode >> extractExteriorBoundaryFacesOf: listOfFaces [
	^ #()
]

{ #category : #'as yet unclassified' }
WCADSolidBSPInSetLeafNode >> extractInteriorBoundaryFacesOf: listOfFaces [
	^ listOfFaces
]

{ #category : #building }
WCADSolidBSPInSetLeafNode >> intersectionWith: otherTree [
	^ otherTree
]

{ #category : #testing }
WCADSolidBSPInSetLeafNode >> isInSetLeaf [
	^ true
]

{ #category : #building }
WCADSolidBSPInSetLeafNode >> symmetricDifferenceWith: otherTree [
	^ otherTree complement
]

{ #category : #building }
WCADSolidBSPInSetLeafNode >> unionWith: otherTree [
	^ self
]

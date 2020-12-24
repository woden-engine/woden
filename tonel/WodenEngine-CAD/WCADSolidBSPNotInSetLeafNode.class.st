Class {
	#name : #WCADSolidBSPNotInSetLeafNode,
	#superclass : #WCADSolidBSPLeafNode,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> complement [
	^ WCADSolidBSPNode inSetLeaf
]

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> differenceWith: otherTree [
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNotInSetLeafNode >> extractExteriorBoundaryFacesOf: listOfFaces [
	^ listOfFaces
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNotInSetLeafNode >> extractInteriorBoundaryFacesOf: listOfFaces [
	^ #()
]

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> intersectionWith: otherTree [
	^ self
]

{ #category : #testing }
WCADSolidBSPNotInSetLeafNode >> isNotInSetLeaf [
	^ true
]

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> symmetricDifferenceWith: otherTree [
	^ otherTree
]

{ #category : #building }
WCADSolidBSPNotInSetLeafNode >> unionWith: otherTree [
	^ otherTree
]

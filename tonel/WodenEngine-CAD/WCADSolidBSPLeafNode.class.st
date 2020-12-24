Class {
	#name : #WCADSolidBSPLeafNode,
	#superclass : #WCADSolidAbstractBSPNode,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #accessing }
WCADSolidBSPLeafNode class >> new [
	self error: 'Only a single null instance is allowed.'
]

{ #category : #accessing }
WCADSolidBSPLeafNode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]

{ #category : #'as yet unclassified' }
WCADSolidBSPLeafNode >> allFacesDo: aBlock [
	"Nothing is required here."
]

{ #category : #accessing }
WCADSolidBSPLeafNode >> faces [
	^ #()
]

{ #category : #accessing }
WCADSolidBSPLeafNode >> inside [
	^ self
]

{ #category : #testing }
WCADSolidBSPLeafNode >> isLeaf [
	^ true
]

{ #category : #building }
WCADSolidBSPLeafNode >> mergeWith: otherTree operateLeafWith: leafBlock [
	^ leafBlock value: self value: otherTree
]

{ #category : #accessing }
WCADSolidBSPLeafNode >> outside [
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidBSPLeafNode >> partitionWithPlane: partitionPlane [
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidBSPLeafNode >> transformNodesWith: aBlock [
	^ self
]

{ #category : #building }
WCADSolidBSPLeafNode >> unionWith: otherTree [
	self subclassResponsibility
]

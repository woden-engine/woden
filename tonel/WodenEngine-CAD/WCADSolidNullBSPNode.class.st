Class {
	#name : #WCADSolidNullBSPNode,
	#superclass : #WCADSolidAbstractBSPNode,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #accessing }
WCADSolidNullBSPNode class >> new [
	self error: 'Only a single null instance is allowed.'
]

{ #category : #accessing }
WCADSolidNullBSPNode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
]

{ #category : #'as yet unclassified' }
WCADSolidNullBSPNode >> allFacesDo: aBlock [
	"Nothing is required here."
]

{ #category : #accessing }
WCADSolidNullBSPNode >> faces [
	^ #()
]

{ #category : #accessing }
WCADSolidNullBSPNode >> inside [
	^ self
]

{ #category : #testing }
WCADSolidNullBSPNode >> isNullNode [
	^ true
]

{ #category : #accessing }
WCADSolidNullBSPNode >> outside [
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidNullBSPNode >> partitionWithPlane: partitionPlane [
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidNullBSPNode >> transformNodesWith: aBlock [
	^ self
]

{ #category : #building }
WCADSolidNullBSPNode >> unionWith: otherTree [
	^ otherTree
]

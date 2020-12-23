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

{ #category : #testing }
WCADSolidNullBSPNode >> isNullNode [
	^ true
]

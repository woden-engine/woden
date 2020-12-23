Class {
	#name : #WCADSolidBSPNode,
	#superclass : #WCADSolidAbstractBSPNode,
	#instVars : [
		'plane',
		'faces',
		'inside',
		'outside'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #'instance creation' }
WCADSolidBSPNode class >> fromConvexFaces: convexFaces [
	| result |
	result := self null.
	convexFaces do: [ :each |
		result := self new
			inside: result;
			plane: each plane;
			addFace: each;
			yourself
	].
	^ result
]

{ #category : #'instance creation' }
WCADSolidBSPNode class >> null [
	^ WCADSolidNullBSPNode uniqueInstance
]

{ #category : #adding }
WCADSolidBSPNode >> addFace: face [
	faces add: face
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> allFacesDo: aBlock [
	inside allFacesDo: aBlock.
	faces do: aBlock.
	outside allFacesDo: aBlock.
]

{ #category : #accessing }
WCADSolidBSPNode >> faces [

	^ faces
]

{ #category : #accessing }
WCADSolidBSPNode >> faces: anObject [

	faces := anObject
]

{ #category : #initialization }
WCADSolidBSPNode >> initialize [
	super initialize.
	faces := OrderedCollection new.
	inside := self class null.
	outside := self class null.
]

{ #category : #accessing }
WCADSolidBSPNode >> inside [

	^ inside
]

{ #category : #accessing }
WCADSolidBSPNode >> inside: anObject [

	inside := anObject
]

{ #category : #accessing }
WCADSolidBSPNode >> outside [

	^ outside
]

{ #category : #accessing }
WCADSolidBSPNode >> outside: anObject [

	outside := anObject
]

{ #category : #accessing }
WCADSolidBSPNode >> plane [

	^ plane
]

{ #category : #accessing }
WCADSolidBSPNode >> plane: anObject [

	plane := anObject
]

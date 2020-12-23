Class {
	#name : #WCADSolidBSPNode,
	#superclass : #WCADSolidAbstractBSPNode,
	#instVars : [
		'faces',
		'plane',
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

{ #category : #adding }
WCADSolidBSPNode >> addFaces: newFaces [
	faces addAll: newFaces
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

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> partitionWithPlane: partitionPlane [
	"Parallel case."
	| insidePartition outsidePartition |
	(plane closeTo: partitionPlane) ifTrue: [
		^ self
	].

	"Anti parallel case."
	(plane closeTo: partitionPlane) ifTrue: [
		^ self copy
			plane: plane negated;
			inside: outside;
			outside: inside;
			yourself
	].

	insidePartition := inside partitionWithPlane: partitionPlane.
	outsidePartition := outside partitionWithPlane: partitionPlane.
	
	faces do: [ :each |
		| facePartition |
		facePartition := each splitWithPlane: partitionPlane.
		facePartition first ifNotNil: [ :insideFace | 
			insidePartition isNullNode ifTrue: [
				insidePartition := self class new plane: plane
			].			
			insidePartition addFace: insideFace
		].
		facePartition second ifNotNil: [ :outsideFace |
			outsidePartition isNullNode ifTrue: [
				outsidePartition := self class new plane: plane
			].
			outsidePartition addFace: outsideFace
		].
	].
	
	^ self class new
		plane: partitionPlane;
		inside: insidePartition;
		outside: outsidePartition;
		yourself
]

{ #category : #accessing }
WCADSolidBSPNode >> plane [

	^ plane
]

{ #category : #accessing }
WCADSolidBSPNode >> plane: anObject [
	plane := anObject.
]

{ #category : #copying }
WCADSolidBSPNode >> postCopy [
	super postCopy.
	faces := faces copy.
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> transformNodesWith: aBlock [
	^ aBlock value: (self copy
		inside: (inside transformNodesWith: aBlock);
		outside: (outside transformNodesWith: aBlock);
		yourself)
]

{ #category : #building }
WCADSolidBSPNode >> unionWith: otherTree [
	| otherTreePartition insideUnion outsideUnion |
	otherTree isNullNode ifTrue: [ ^ self ].
	otherTreePartition := otherTree partitionWithPlane: plane.
	insideUnion := inside unionWith: otherTreePartition inside.
	outsideUnion := outside unionWith: otherTreePartition outside.	
	^ self class new
		plane: plane;
		addFaces: faces;
		addFaces: otherTreePartition faces;
		inside: insideUnion;
		outside: outsideUnion;
		yourself
]

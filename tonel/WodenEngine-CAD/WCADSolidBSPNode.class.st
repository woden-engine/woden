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
	result := self inSetLeaf.
	convexFaces reverseDo: [ :each |
		result := self new
			inside: result;
			plane: each plane;
			addFace: each;
			yourself
	].
	^ result
]

{ #category : #'instance creation' }
WCADSolidBSPNode class >> inSetLeaf [
	^ WCADSolidBSPInSetLeafNode uniqueInstance
]

{ #category : #'instance creation' }
WCADSolidBSPNode class >> notInSetLeaf [
	^ WCADSolidBSPNotInSetLeafNode uniqueInstance
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

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> condensed [
	(inside isLeaf and: [ inside == outside and: [ faces isEmpty ] ]) ifTrue: [ ^ inside ].
	^ self
]

{ #category : #accessing }
WCADSolidBSPNode >> faces [

	^ faces
]

{ #category : #initialization }
WCADSolidBSPNode >> initialize [
	super initialize.
	faces := OrderedCollection new.
	inside := self class notInSetLeaf.
	outside := self class notInSetLeaf.
]

{ #category : #accessing }
WCADSolidBSPNode >> inside [

	^ inside
]

{ #category : #accessing }
WCADSolidBSPNode >> inside: anObject [

	inside := anObject
]

{ #category : #building }
WCADSolidBSPNode >> mergeWith: otherTree operateLeafWith: aBlock [
	| otherTreePartition insideMerged outsideMerged |
	otherTree isLeaf ifTrue: [ ^ aBlock value: otherTree value: self ].
	
	otherTreePartition := otherTree partitionWithPlane: plane operateLeafWith: aBlock.
	otherTreePartition isLeaf ifTrue: [ ^ aBlock value: otherTreePartition value: self ].
	
	insideMerged := inside mergeWith: otherTreePartition inside operateLeafWith: aBlock.
	outsideMerged := outside mergeWith: otherTreePartition outside operateLeafWith: aBlock.	
	^ self class new
		plane: plane;
		addFaces: faces;
		addFaces: otherTreePartition faces;
		inside: insideMerged;
		outside: outsideMerged;
		yourself
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
WCADSolidBSPNode >> partitionWithPlane: partitionPlane operateLeafWith: aBlock [
	"Parallel case."
	| insidePartitioned outsidePartitioned insideFaces outsideFaces |
	(plane closeTo: partitionPlane) ifTrue: [
		self halt.
		^ self
	].

	"Anti parallel case."
	(plane negated closeTo: partitionPlane) ifTrue: [
		self halt.
		^ self copy
			plane: partitionPlane;
			inside: outside;
			outside: inside;
			yourself
	].

	insidePartitioned := inside partitionWithPlane: partitionPlane operateLeafWith: aBlock.
	outsidePartitioned := outside partitionWithPlane: partitionPlane operateLeafWith: aBlock.
	
	insideFaces := OrderedCollection new.
	outsideFaces := OrderedCollection new.
	faces do: [ :each |
		| facePartition |
		facePartition := each splitWithPlane: partitionPlane.
		facePartition first ifNotNil: [ :face | 
			insideFaces add: face
		].
		facePartition second ifNotNil: [ :face |
			outsideFaces add: face
		].
	].
	
	^ self class new
		plane: partitionPlane;
		inside: (self class new
			plane: plane;
			addFaces: insideFaces;
			inside: insidePartitioned inside;
			outside: outsidePartitioned inside;
			condensed);
		outside: (self class new
			plane: plane;
			addFaces: outsideFaces;
			inside: insidePartitioned outside;
			outside: outsidePartitioned outside;
			condensed);
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

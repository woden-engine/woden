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

{ #category : #building }
WCADSolidBSPNode >> complement [
	^ self class new
		plane: plane negated;
		addFaces: (faces collect: [:each | each flipped ]);
		inside: outside complement;
		outside: inside complement;
		yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> condensed [
	(inside isLeaf and: [ inside == outside ]) ifTrue: [ ^ inside ].
	^ self
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> extractExteriorBoundaryFacesOf: listOfFaces [
	| facePlane insideFaces outsideFaces |
	listOfFaces ifEmpty: [ ^ #() ].
	
	facePlane := listOfFaces first plane.
	(facePlane closeTo: plane negated precision: Epsilon) ifTrue: [
		^ self extractExteriorBoundaryFacesOf: (listOfFaces collect: [:each | each flipped ])
	].

	(facePlane closeTo: plane precision: Epsilon) ifTrue: [
		^ (inside extractInteriorBoundaryFacesOf: (outside extractExteriorBoundaryFacesOf: listOfFaces))
	].

	insideFaces := OrderedCollection new.
	outsideFaces := OrderedCollection new.
	listOfFaces do: [ :each |
		| facePartition |
		facePartition := each splitWithPlane: plane.
		facePartition first ifNotNil: [ :exteriorFace |
			insideFaces add: exteriorFace
		].
		facePartition second ifNotNil: [ :exteriorFace |
			outsideFaces add: exteriorFace
		]
	].

	^ (inside extractExteriorBoundaryFacesOf: insideFaces) , (outside extractExteriorBoundaryFacesOf: outsideFaces)
]

{ #category : #'as yet unclassified' }
WCADSolidBSPNode >> extractInteriorBoundaryFacesOf: listOfFaces [
	| facePlane insideFaces outsideFaces |
	listOfFaces ifEmpty: [ ^ #() ].
	
	facePlane := listOfFaces first plane.
	(facePlane closeTo: plane negated precision: Epsilon) ifTrue: [
		^ self extractInteriorBoundaryFacesOf: (listOfFaces collect: [:each | each flipped ])
	].

	(facePlane closeTo: plane precision: Epsilon) ifTrue: [
		^ (inside extractInteriorBoundaryFacesOf: (outside extractInteriorBoundaryFacesOf: listOfFaces))
	].

	insideFaces := OrderedCollection new.
	outsideFaces := OrderedCollection new.
	listOfFaces do: [ :each |
		| facePartition |
		facePartition := each splitWithPlane: plane.
		facePartition first ifNotNil: [ :exteriorFace |
			insideFaces add: exteriorFace
		].
		facePartition second ifNotNil: [ :exteriorFace |
			outsideFaces add: exteriorFace
		]
	].

	^ (inside extractInteriorBoundaryFacesOf: insideFaces) , (outside extractInteriorBoundaryFacesOf: outsideFaces)
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
WCADSolidBSPNode >> mergeWith: otherTree operateLeafWith: leafBlock [
	| otherTreePartition insideMerged outsideMerged result rawFaces |
	otherTree isLeaf ifTrue: [ ^ leafBlock value: otherTree value: self ].
	
	otherTreePartition := otherTree partitionWithPlane: plane.
	otherTreePartition isLeaf ifTrue: [ ^ leafBlock value: otherTreePartition value: self ].
	
	insideMerged := inside mergeWith: otherTreePartition inside operateLeafWith: leafBlock.
	outsideMerged := outside mergeWith: otherTreePartition outside operateLeafWith: leafBlock.
	result := self class new
		plane: plane;
		inside: insideMerged;
		outside: outsideMerged;
		yourself.
		
	rawFaces := faces , otherTreePartition faces.
	^ result
		addFaces: (result extractExteriorBoundaryFacesOf: rawFaces);
		condensed

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
	| insidePartitioned outsidePartitioned insideFaces outsideFaces |
	(plane closeTo: partitionPlane precision: Epsilon) ifTrue: [
		^ self
	].

	"Anti parallel case."
	(plane closeTo: partitionPlane negated precision: Epsilon) ifTrue: [
		^ self class new
			plane: plane negated;
			inside: outside;
			outside: inside;
			addFaces: (faces collect: [:f | f flipped]);
			yourself
	].

	insidePartitioned := inside partitionWithPlane: partitionPlane.
	outsidePartitioned := outside partitionWithPlane: partitionPlane.
	
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
		condensed
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

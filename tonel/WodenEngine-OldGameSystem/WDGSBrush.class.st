Class {
	#name : #WDGSBrush,
	#superclass : #WDGSModelingComponent,
	#instVars : [
		'faces',
		'positions'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #construction }
WDGSBrush class >> box: box [
	^ (self faces: { 
		WDGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: box min x negated. "Left"
		WDGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: box max x . "Right"
		WDGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: box min y negated. "Bottom"
		WDGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: box max y . "Top"
		WDGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: box min z negated. "Front"
		WDGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: box max z . "Back"
	}) triangulate
]

{ #category : #'as yet unclassified' }
WDGSBrush class >> cubeSize: size [
	| hsize |
	hsize := size * 0.5.
	^ (self faces: { 
		WDGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: hsize . "Left"
		WDGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: hsize . "Right"
		WDGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: hsize . "Bottom"
		WDGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: hsize . "Top"
		WDGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: hsize . "Front"
		WDGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: hsize . "Back"
	}) triangulate
]

{ #category : #construction }
WDGSBrush class >> faces: anArrayOfFaces [
	^ self new faces: anArrayOfFaces
]

{ #category : #serialization }
WDGSBrush class >> jsonTypeName [
	^ 'brush'
]

{ #category : #construction }
WDGSBrush class >> unitBox [
	^ self cubeSize: 1.
]

{ #category : #adding }
WDGSBrush >> addPosition: aPosition [
	| index |
	index := positions size.
	positions add: aPosition.
	^ index
]

{ #category : #transformations }
WDGSBrush >> applyTransformation: transformation [
	self modifyPositionsApplying: [ :v | transformation transformPosition3: v ]
]

{ #category : #serialization }
WDGSBrush >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'brush' .
		'color' . color asWodenJsonData .
		'faces' . faces collect: #asJsonData
	}
]

{ #category : #rendering }
WDGSBrush >> buildSolidModelInto: aMeshBuilder [
	faces do: [ :face | face buildSolidModelInto: aMeshBuilder ].
]

{ #category : #rendering }
WDGSBrush >> buildWireModelInto: aMeshBuilder [
	aMeshBuilder
		beginLines;
		currentColor: self currentColor asFloat32x4.
	positions do: [ :position |
		aMeshBuilder addP: position asFloat32x3.
	].

	faces do: [ :face | face buildWireModelInto: aMeshBuilder ].
]

{ #category : #clipping }
WDGSBrush >> clipWithPlane: aPlane [
	^ self clipWithPlane: aPlane material: faces first material
]

{ #category : #clipping }
WDGSBrush >> clipWithPlane: aPlane material: aMaterial [
	| frontFaces backFaces side backBrush frontBrush negatedPlane |
	negatedPlane := aPlane negated.
	faces detect: [ :face |
		(face plane closeTo: aPlane) or: [face plane closeTo: negatedPlane]] ifFound: [ ^ nil ].
	(self intersectsWithPlane: aPlane) ifFalse: [ ^ nil ].
	
	frontFaces := OrderedCollection new.
	backFaces := OrderedCollection new.
	faces do: [ :face |
		side := face sideOfPlane: aPlane.
		side = 0 ifTrue: [
			frontFaces add: face copy.
			backFaces add: face copy.
		] ifFalse: [ 
			side < 0 ifTrue: [ backFaces add: face copy]
			ifFalse: [ frontFaces add: face copy]
		]
	].

	self assert: frontFaces isNotEmpty.
	self assert: backFaces isNotEmpty.
	backFaces add: ((WDGSBrushFace plane: aPlane) material: aMaterial).
	frontFaces add: ((WDGSBrushFace plane: aPlane negated) material: aMaterial).
	backBrush := self class faces: backFaces asArray.
	frontBrush := self class faces: frontFaces asArray .
	backBrush triangulate.
	frontBrush triangulate.
	^ { backBrush . frontBrush }
	
]

{ #category : #private }
WDGSBrush >> computeBoundingBox [
	boundingBox
		makeEmpty;
		insertPoints: positions
]

{ #category : #clipping }
WDGSBrush >> containsBrush: aBrush [
	aBrush positions do: [ :vert | (self containsPoint: vert) ifFalse: [^ false ] ].
	^ true
]

{ #category : #testing }
WDGSBrush >> containsPoint: aPoint [
	faces do: [ :face | (face plane isInFront: aPoint) ifTrue: [ ^false ] ].
	^ true
]

{ #category : #intersection }
WDGSBrush >> containsPointInside: aPoint [
	faces do: [ :face | (face plane isBehind: aPoint) ifFalse: [ ^false ] ].
	^ true
]

{ #category : #physics }
WDGSBrush >> createAxisAlignedCollisionShapeComponent [
	| bbox |
	bbox := self boundingBox.
	^ WDPhyCompoundCollisionShapeComponent new
		translation: bbox center asFloat32x3;
		shape: (WDPhyBoxCollisionShape new halfExtent: bbox halfExtent asFloat32x3);
		yourself
]

{ #category : #physics }
WDGSBrush >> createCollisionShapeComponent [
	| center centeredPositions |
	self isAxisAlignedBoxBrush ifTrue: [ 
		^ self createAxisAlignedCollisionShapeComponent
	].
		
	center := self boundingBox center.
	centeredPositions := SLVMNativeArray for: Float32x3 new: positions size.
	positions doWithIndex: [ :p :i |
		centeredPositions at: i put: (p - center) asFloat32x3
	].

	^ WDPhyCompoundCollisionShapeComponent new
		translation: center asFloat32x3;
		shape: (WDPhyConvexHullCollisionShape new points: centeredPositions);
		yourself
]

{ #category : #selection }
WDGSBrush >> elementsAlongRay: ray mode: mode do: aBlock [
	| distance intersectionPoint result bestDistance |
	(ray intersectionDistanceWithBox: boundingBox) ifNil: [ ^ self ].
	bestDistance := nil.
	
	faces do: [ :face |
		distance := ray intersectionDistanceWithPlane: face plane.
		distance ifNotNil: [
			intersectionPoint := ray pointAtDistance: distance.
			(intersectionPoint isNotNil and: [self isPoint: intersectionPoint behindOtherFaces: face]) ifTrue: [
				mode == #face ifTrue: [
					result := ray testResultForDistance: distance value: face.
					aBlock value: result
				] ifFalse: [
					(bestDistance isNil or: [ bestDistance > distance ]) ifTrue: [
						bestDistance := distance
					]
				]
			]
		]
	].

	bestDistance ifNotNil: [
		result := ray testResultForDistance: bestDistance value: self.
		aBlock value: result.
	]
]

{ #category : #accessing }
WDGSBrush >> faces [
	^ faces
]

{ #category : #accessing }
WDGSBrush >> faces: anArrayOfFaces [
	faces := anArrayOfFaces.
	faces do: [ :face | face addedToBrush: self ].
]

{ #category : #initialization }
WDGSBrush >> initialize [
	super initialize.
	faces := #().
	positions := StdnVector newFor: Float64x3.
]

{ #category : #private }
WDGSBrush >> intersectFace: f1 with: f2 with: f3 [
	| p1 p2 p3 pos index |
	"Compute the intersection between the planes"
	p1 := f1 plane.
	p2 := f2 plane.
	p3 := f3 plane.
	pos := p1 intersect: p2 intersect: p3.
	pos ifNil: [ ^ self ].
	
	"Add the index"
	index := self addPosition: (self roundPosition: pos).
	f1 addIndex: index.
	f2 addIndex: index.
	f3 addIndex: index.
]

{ #category : #intersection }
WDGSBrush >> intersectsWithBrushProperly: brush [
	"Make sure we don't share a face."
	faces do: [ :myface |
		| plane  |
		plane := myface plane negated.
		brush faces do: [:face |
			(face plane closeTo: plane) ifTrue: [ ^ false ].
		]
	].

	positions do: [ :vert | (brush containsPointInside: vert) ifTrue: [ ^ true ] ].
	faces do: [ :face |
		face edgesDo: [ :start :end |
			(brush intersectsWithEdgeProperly: (face positionAt: start) end: (face positionAt: end)) ifTrue: [^ true]
		].
	].

	^ false
]

{ #category : #intersection }
WDGSBrush >> intersectsWithEdgeProperly: start end: end [
	(start closeTo: end) ifTrue: [^ self containsPointInside: start].
	((self containsPointInside: start) or: [ self containsPointInside: end ]) ifTrue: [ ^ true ].
	
	faces do: [ :face |
		| inside intersection |
		intersection := face plane intersectWithSegment: start end: end.
		
		inside := true.
		intersection ifNotNil: [
			faces do: [ :otherFace |
				inside ifTrue: [
					(face ~~ otherFace and: [(otherFace plane isBehind: intersection) not]) ifTrue: [ inside := false ]
				]
			].
		
			inside ifTrue: [ ^ true ].
		]
	].

	^ false
]

{ #category : #intersection }
WDGSBrush >> intersectsWithFaceProperly: face [
	| reversedPlane |
	reversedPlane := face plane negated.
	self faces do: [ :myface |
		((myface plane closeTo: face plane) or: [myface plane closeTo: reversedPlane]) ifTrue: [ ^ false ]
	].
	
	face positionsDo: [ :vert | (self containsPointInside: vert) ifTrue: [ ^ true ] ].
	face edgesDo: [ :start :end | (self intersectsWithEdgeProperly: (face positionAt: start) end: (face positionAt: end)) ifTrue: [^ true ] ].
	^ false
]

{ #category : #intersection }
WDGSBrush >> intersectsWithPlane: aPlane [
	| front back |
	front := false.
	back := false.
	positions do: [ :vert |
		(aPlane isInFront: vert) ifTrue: [ front := true ] ifFalse: [ back := true ].
		(front and: back) ifTrue: [ ^ true ].
	].
	^ front and: back
]

{ #category : #physics }
WDGSBrush >> isAxisAlignedBoxBrush [
	self flag: 'Implement myself properly.'.
	^ true
]

{ #category : #testing }
WDGSBrush >> isBrush [
	^ true
]

{ #category : #testing }
WDGSBrush >> isPoint: point behindOtherFaces: frontFace [
	faces do: [ :face |
		(face ~~ frontFace and: [ (face plane pointDistance: point) > 0.0 ]) ifTrue: [ 
			^ false
		]
	].
	^ true
]

{ #category : #'as yet unclassified' }
WDGSBrush >> isUsedInPlayMode [
	^ true
]

{ #category : #testing }
WDGSBrush >> isValid [
	^ faces size >= 3
]

{ #category : #serialization }
WDGSBrush >> loadFromJson: jsonData [
	jsonData at: 'color' ifPresent: [ :jsonColor |
		color := Color loadWodenJsonData: jsonColor
	].

	jsonData at: 'faces' ifPresent: [ :jsonFaces |
		self faces: (jsonFaces collect: [ :jsonFace | WDGSBrushFace loadFromJson: jsonFace ])
	].

	self triangulate.
]

{ #category : #accessing }
WDGSBrush >> material: aMaterialName [
	faces do: [ :face | face material: aMaterialName ]
]

{ #category : #transformations }
WDGSBrush >> modifyPositionsApplying: aBlock [
	| newPosition |
	1 to: positions size do: [ :i |
		newPosition := aBlock value: (positions at: i).
		positions at: i put: (self roundPosition: newPosition).
	].
	self rebuildPlanes.
	self computeBoundingBox.
	self invalidateModels.
]

{ #category : #accessing }
WDGSBrush >> numberOfFaces [
	^ faces size
]

{ #category : #accessing }
WDGSBrush >> positions [
	^ positions
]

{ #category : #copying }
WDGSBrush >> postCopy [
	super postCopy.
	positions := positions copy.
	faces := faces collect: #copy.
	faces do: [ :face | face addedToBrush: self].

]

{ #category : #transformations }
WDGSBrush >> rebuildPlanes [
	faces do: #rebuildPlane
]

{ #category : #memento }
WDGSBrush >> restoreTransformMemento: aValue [
	super restoreTransformMemento: aValue first.
	positions := aValue second copy
]

{ #category : #private }
WDGSBrush >> roundPosition: aPosition [
	^ aPosition
]

{ #category : #clipping }
WDGSBrush >> subtract: aBrush [ 
	| brushes |
	brushes := OrderedCollection new.
	self subtract: aBrush into: brushes.
	^ brushes
]

{ #category : #clipping }
WDGSBrush >> subtract: brush into: aCollection [
	| remaining clipResult |
	(brush containsBrush: self) ifTrue: [ ^ self ].
	
	remaining := self.
	brush faces do: [ :face |
		(self intersectsWithFaceProperly: face) ifTrue: [
			clipResult := remaining clipWithPlane: face plane material: face material.
			clipResult ifNotNil: [ 
				aCollection add: clipResult second.
				remaining := clipResult first.
			]
		]
	].

	"Check if nothing was subtracted from me"
	aCollection ifEmpty: [ aCollection add: self ].
	
]

{ #category : #enumerating }
WDGSBrush >> textureTransformsDo: aBlock [
	faces do: [ :face | face textureTransformsDo: aBlock ]
]

{ #category : #memento }
WDGSBrush >> transformMemento [
	^ {super transformMemento . positions copy}
]

{ #category : #transformations }
WDGSBrush >> translateBy: translation [
	self modifyPositionsApplying: [ :vertex | vertex + translation ]
]

{ #category : #private }
WDGSBrush >> triangulate [
	| faceCount f1 f2 f3|
	faceCount := self numberOfFaces.
	positions removeAll.
	faces do: [ :face | face clearIndices ].

	1 to: faceCount do: [ :i |
		f1 := faces at: i.
		i + 1 to: faceCount do: [ :j |
			f2 := faces at: j.
			j + 1 to: faceCount do: [ :k |
				f3 := faces at: k.
				(i ~~ j and: [j ~~ k]) ifTrue: [ self intersectFace: f1 with: f2 with: f3 ]
			]
		]
	].

	faces do: [ :face | face fixWinding ].
	self computeBoundingBox.
]

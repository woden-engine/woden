Class {
	#name : #WTGSBrush,
	#superclass : #WTGSComponent,
	#instVars : [
		'faces',
		'positions',
		'boundingBox',
		'color'
	],
	#classVars : [
		'BrushColors'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #construction }
WTGSBrush class >> box: box [
	^ (self faces: { 
		WTGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: box min x negated. "Left"
		WTGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: box max x . "Right"
		WTGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: box min y negated. "Bottom"
		WTGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: box max y . "Top"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: box min z negated. "Front"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: box max z . "Back"
	}) triangulate
]

{ #category : #'as yet unclassified' }
WTGSBrush class >> cubeSize: size [
	| hsize |
	hsize := size * 0.5.
	^ (self faces: { 
		WTGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: hsize . "Left"
		WTGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: hsize . "Right"
		WTGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: hsize . "Bottom"
		WTGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: hsize . "Top"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: hsize . "Front"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: hsize . "Back"
	}) triangulate
]

{ #category : #construction }
WTGSBrush class >> faces: anArrayOfFaces [
	^ self new faces: anArrayOfFaces
]

{ #category : #'class initialization' }
WTGSBrush class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	BrushColors := {
		Color green muchDarker.
		Color blue .
		Color cyan .
		Color yellow .
		Color magenta .
	}.
]

{ #category : #serialization }
WTGSBrush class >> jsonTypeName [
	^ 'brush'
]

{ #category : #construction }
WTGSBrush class >> unitCube [
	^ self cubeSize: 1.
]

{ #category : #adding }
WTGSBrush >> addPosition: aPosition [
	| index |
	index := positions size.
	positions add: aPosition.
	^ index
]

{ #category : #adding }
WTGSBrush >> addedToEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity ifNotNil: [
		entity
			ensureSpatialObject;
			ensureRenderingModels;
			invalidateModels
	].
]

{ #category : #transformations }
WTGSBrush >> applyTransformation: transformation [
	self modifyPositionsApplying: [ :v | transformation transformPosition3: v ]
]

{ #category : #serialization }
WTGSBrush >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'brush' .
		'color' . color asWodenJsonData .
		'faces' . faces collect: #asJsonData
	}
]

{ #category : #accessing }
WTGSBrush >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WTGSBrush >> bucket [
	^ #modeling
]

{ #category : #rendering }
WTGSBrush >> buildSolidModelInto: aMeshBuilder [
	faces do: [ :face | face buildSolidModelInto: aMeshBuilder ].
]

{ #category : #rendering }
WTGSBrush >> buildWireModelInto: aMeshBuilder [
	aMeshBuilder
		beginLines;
		currentColor: self currentColor asWMVector4F.
	positions do: [ :position |
		aMeshBuilder addP: position asWMVector3F.
	].

	faces do: [ :face | face buildWireModelInto: aMeshBuilder ].
]

{ #category : #changing }
WTGSBrush >> changedSelectionState [
	self invalidateModels
]

{ #category : #clipping }
WTGSBrush >> clipWithPlane: aPlane [
	^ self clipWithPlane: aPlane material: faces first material
]

{ #category : #clipping }
WTGSBrush >> clipWithPlane: aPlane material: aMaterial [
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
	backFaces add: ((WTGSBrushFace plane: aPlane) material: aMaterial).
	frontFaces add: ((WTGSBrushFace plane: aPlane negated) material: aMaterial).
	backBrush := self class faces: backFaces asArray.
	frontBrush := self class faces: frontFaces asArray .
	backBrush triangulate.
	frontBrush triangulate.
	^ { backBrush . frontBrush }
	
]

{ #category : #accessing }
WTGSBrush >> color [
	^ color
]

{ #category : #private }
WTGSBrush >> computeBoundingBox [
	boundingBox
		makeEmpty;
		insertPoints: positions
]

{ #category : #clipping }
WTGSBrush >> containsBrush: aBrush [
	aBrush positions do: [ :vert | (self containsPoint: vert) ifFalse: [^ false ] ].
	^ true
]

{ #category : #testing }
WTGSBrush >> containsPoint: aPoint [
	faces do: [ :face | (face plane isInFront: aPoint) ifTrue: [ ^false ] ].
	^ true
]

{ #category : #intersection }
WTGSBrush >> containsPointInside: aPoint [
	faces do: [ :face | (face plane isBehind: aPoint) ifFalse: [ ^false ] ].
	^ true
]

{ #category : #accessing }
WTGSBrush >> currentColor [
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ color]
]

{ #category : #accessing }
WTGSBrush >> currentTexturedColor [
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ Color white]
]

{ #category : #selection }
WTGSBrush >> elementsAlongRay: ray mode: mode do: aBlock [
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
WTGSBrush >> faces [
	^ faces
]

{ #category : #accessing }
WTGSBrush >> faces: anArrayOfFaces [
	faces := anArrayOfFaces.
	faces do: [ :face | face addedToBrush: self ].
]

{ #category : #initialization }
WTGSBrush >> generateColor [
	^ BrushColors atRandom
]

{ #category : #initialization }
WTGSBrush >> initialize [
	super initialize.
	faces := #().
	positions := SLVMNativeOrderedCollection for: WMVector3D.
	color := self generateColor.
	boundingBox := WMBox3DD empty.
]

{ #category : #private }
WTGSBrush >> intersectFace: f1 with: f2 with: f3 [
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
WTGSBrush >> intersectsWithBrushProperly: brush [
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
WTGSBrush >> intersectsWithEdgeProperly: start end: end [
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
WTGSBrush >> intersectsWithFaceProperly: face [
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
WTGSBrush >> intersectsWithPlane: aPlane [
	| front back |
	front := false.
	back := false.
	positions do: [ :vert |
		(aPlane isInFront: vert) ifTrue: [ front := true ] ifFalse: [ back := true ].
		(front and: back) ifTrue: [ ^ true ].
	].
	^ front and: back
]

{ #category : #rendering }
WTGSBrush >> invalidateModels [
	entity ifNotNil: [ entity invalidateModels ]
]

{ #category : #rendering }
WTGSBrush >> invalidateTexturedModel [
	entity ifNotNil: [ entity invalidateTexturedModel ]
]

{ #category : #testing }
WTGSBrush >> isBrush [
	^ true
]

{ #category : #testing }
WTGSBrush >> isPoint: point behindOtherFaces: frontFace [
	faces do: [ :face |
		(face ~~ frontFace and: [ (face plane pointDistance: point) > 0.0 ]) ifTrue: [ 
			^ false
		]
	].
	^ true
]

{ #category : #'as yet unclassified' }
WTGSBrush >> isUsedInPlayMode [
	^ true
]

{ #category : #testing }
WTGSBrush >> isValid [
	^ faces size >= 3
]

{ #category : #serialization }
WTGSBrush >> loadFromJson: jsonData [
	jsonData at: 'color' ifPresent: [ :jsonColor |
		color := Color loadWodenJsonData: jsonColor
	].

	jsonData at: 'faces' ifPresent: [ :jsonFaces |
		self faces: (jsonFaces collect: [ :jsonFace | WTGSBrushFace loadFromJson: jsonFace ])
	].

	self triangulate.
]

{ #category : #accessing }
WTGSBrush >> map [
	^ entity map
]

{ #category : #accessing }
WTGSBrush >> material: aMaterialName [
	faces do: [ :face | face material: aMaterialName ]
]

{ #category : #transformations }
WTGSBrush >> modifyPositionsApplying: aBlock [
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
WTGSBrush >> numberOfFaces [
	^ faces size
]

{ #category : #accessing }
WTGSBrush >> positions [
	^ positions
]

{ #category : #copying }
WTGSBrush >> postCopy [
	super postCopy.
	positions := positions copy.
	faces := faces collect: #copy.
	faces do: [ :face | face addedToBrush: self].

]

{ #category : #transformations }
WTGSBrush >> rebuildPlanes [
	faces do: #rebuildPlane
]

{ #category : #adding }
WTGSBrush >> removedFromEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super removedFromEntity: anEntity.

]

{ #category : #memento }
WTGSBrush >> restoreTransformMemento: aValue [
	positions := aValue copy.
	self invalidateModels.
]

{ #category : #private }
WTGSBrush >> roundPosition: aPosition [
	^ aPosition
]

{ #category : #clipping }
WTGSBrush >> subtract: aBrush [ 
	| brushes |
	brushes := OrderedCollection new.
	self subtract: aBrush into: brushes.
	^ brushes
]

{ #category : #clipping }
WTGSBrush >> subtract: brush into: aCollection [
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
WTGSBrush >> textureTransformsDo: aBlock [
	faces do: [ :face | face textureTransformsDo: aBlock ]
]

{ #category : #memento }
WTGSBrush >> transformMemento [
	^ positions copy
]

{ #category : #transformations }
WTGSBrush >> translateBy: translation [
	self modifyPositionsApplying: [ :vertex | vertex + translation ]
]

{ #category : #private }
WTGSBrush >> triangulate [
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

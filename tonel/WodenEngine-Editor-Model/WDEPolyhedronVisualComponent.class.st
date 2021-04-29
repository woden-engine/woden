Class {
	#name : #WDEPolyhedronVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'faces',
		'boundingBox',
		'vertices'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEPolyhedronVisualComponent >> accept: visitor [
	^ visitor visitPolyhedronVisualComponent: self
]

{ #category : #converting }
WDEPolyhedronVisualComponent >> asPolyhedronVisualComponent [
	^ self
]

{ #category : #accessing }
WDEPolyhedronVisualComponent >> boundingBox [
	boundingBox ifNil: [ self computeBoundingBox ].
	^ boundingBox
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> buildMeshWith: meshBuilder modelTransform: modelTransform [
	faces do: [ :each | each buildMeshWith: meshBuilder modelTransform: modelTransform ].
	^ meshBuilder
		computeTangentsBitangents;
		computeBoundingBox;
		mesh
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	faces do: [ :each | each buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform ].
	^ meshBuilder
		computeTangentsBitangents;
		computeBoundingBox;
		mesh
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	meshBuilder currentMaterial: renderMaterial.
	faces do: [ :each | each buildWireMeshWith: meshBuilder ].
	^ meshBuilder
		computeBoundingBox;
		mesh
]

{ #category : #accessing }
WDEPolyhedronVisualComponent >> children [
	^ faces
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> clipAgainstPlane: plane [
	| classification frontFaces backFaces planeInFront planeInBack frontPolyhedron backPolyhedron |
	classification := plane classifyVertices: vertices epsilon: Epsilon.
	self assert: classification ~~ #inside.
	classification == #front ifTrue: [ ^ { self . nil } ].
	classification == #back ifTrue: [ ^ { nil . self } ].
	self assert: classification == #frontAndBack.
	
	frontFaces := OrderedCollection new.
	backFaces := OrderedCollection new.
	
	planeInFront := false.
	planeInBack := false.
	faces do: [ :eachFace |
		| faceClassification |
		faceClassification := plane classifyVertices: eachFace vertices epsilon: Epsilon.
		faceClassification == #inside ifTrue: [
			| normalDirection |
			normalDirection := eachFace plane normal dot: plane normal.
			normalDirection > 0 ifTrue: [
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				backFaces add: eachFace copy.
				planeInBack := true.
			] ifFalse: [ 
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				frontFaces add: (eachFace copy plane: eachFace plane negated).
				planeInFront := true.
			].
		].
		faceClassification == #front ifTrue: [ 
			frontFaces add: eachFace copy		
		].
		faceClassification == #back ifTrue: [ 
			backFaces add: eachFace copy
		].
		faceClassification == #frontAndBack ifTrue: [ 
			frontFaces add: eachFace copy.
			backFaces add: eachFace copy.
		].
	].

	planeInBack ifFalse: [
		backFaces add: (WDEPolyhedronFace plane: plane)
	].
	planeInFront ifFalse: [
		frontFaces add: (WDEPolyhedronFace plane: plane negated)
	].

	frontPolyhedron := self class new faces: frontFaces;
		computeVerticesFromPlanes;
		computeBoundingBox;
		yourself.
	backPolyhedron := self class new faces: backFaces;
		computeVerticesFromPlanes;
		computeBoundingBox;
		yourself.
	^ { frontPolyhedron . backPolyhedron }
]

{ #category : #'display box access' }
WDEPolyhedronVisualComponent >> computeBoundingBox [
	boundingBox := BoxF32 empty.
	vertices do: [ :eachVertex |
		boundingBox insertPoint: eachVertex
	]
]

{ #category : #constructing }
WDEPolyhedronVisualComponent >> computeVerticesFromPlanes [
	faces do: [ :each | each vertices: OrderedCollection new ].
	vertices := OrderedCollection new.
	
	1 to: faces size do: [ :firstFaceIndex |
		| firstFace |
		firstFace := faces at: firstFaceIndex.
		firstFaceIndex + 1 to: faces size do: [ :secondFaceIndex |
			firstFaceIndex  ~~ secondFaceIndex ifTrue: [ 
				| secondFace |
				secondFace := faces at: secondFaceIndex.
				secondFaceIndex  + 1 to: faces size do: [ :thirdFaceIndex |
					(firstFaceIndex ~~ thirdFaceIndex and: [ secondFace ~~ thirdFaceIndex ]) ifTrue: [
						| intersectionPoint thirdFace |
						thirdFace := faces at: thirdFaceIndex.
						intersectionPoint := firstFace plane intersectionWith: secondFace plane with: thirdFace plane.
						intersectionPoint ifNotNil: [
							vertices add: intersectionPoint.
							firstFace vertices add: intersectionPoint.
							secondFace vertices add: intersectionPoint.
							thirdFace vertices add: intersectionPoint.
						].
					]
				]
			].
		]
	].

	faces do: [ :each |
		each
			vertices: each vertices asArray;
			sortVerticesCounterClockwise
	].
	vertices := vertices asArray.
]

{ #category : #constructing }
WDEPolyhedronVisualComponent >> constructFacesForBox: box [
	self
		faces: {
			WDEPolyhedronFace name: #Left plane: (PlaneF32 normal: (Float32x3 x: -1) distance: box min x negated).
			WDEPolyhedronFace name: #Right plane: (PlaneF32 normal: (Float32x3 x: 1) distance: box max x).
			WDEPolyhedronFace name: #Front plane: (PlaneF32 normal: (Float32x3 z: -1) distance: box min z negated).
			WDEPolyhedronFace name: #Back plane: (PlaneF32 normal: (Float32x3 z: 1) distance: box max z).

			WDEPolyhedronFace name: #Bottom plane: (PlaneF32 normal: (Float32x3 y: -1) distance: box min y negated).
			WDEPolyhedronFace name: #Top plane: (PlaneF32 normal: (Float32x3 y: 1) distance: box max y).
		};
		computeVerticesFromPlanes;
		computeBoundingBox
]

{ #category : #serialization }
WDEPolyhedronVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#faces . faces collect: [ :each | each encodeForJSON ] .
		#vertices . vertices collect: [ :each | each encodeForJSON ] .
		#boundingBox . boundingBox encodeForJSON .
	}
]

{ #category : #accessing }
WDEPolyhedronVisualComponent >> entityTransformChanged [
	(faces anySatisfy: [ :each | each hasTexture ]) ifTrue: [
		self raiseChangedEvent
	].

]

{ #category : #accessing }
WDEPolyhedronVisualComponent >> faces [

	^ faces
]

{ #category : #accessing }
WDEPolyhedronVisualComponent >> faces: anObject [
	| level |
	level := self level.
	faces do: [ :each |
		each parent: nil.
		level ifNotNil: [ each removedFromLevel: level ].
	].
	faces := anObject.
	faces do: [ :each |
		each parent: self.
		level ifNotNil: [ each addedToLevel: level ]
	]
]

{ #category : #initialization }
WDEPolyhedronVisualComponent >> initialize [
	super initialize.
	faces := #().
	vertices := #().
]

{ #category : #testing }
WDEPolyhedronVisualComponent >> isPolyhedronVisualComponent [
	^ true
]

{ #category : #serialization }
WDEPolyhedronVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	jsonData at: 'faces' ifPresent: [ :facesData |
		self faces: (facesData collect: [ :each | WDELevelElement loadFromJson: each context: context ]).
	].
	jsonData at: 'vertices' ifPresent: [ :verticesData |
		vertices := verticesData collect: [ :each | Float32x3 loadFromJson: each ].
	].
	jsonData at: 'boundingBox' ifPresent: [ :bbox |
		boundingBox := BoxF32 loadFromJson: bbox.
	].
]

{ #category : #memento }
WDEPolyhedronVisualComponent >> materialStateMemento [
	^ faces collect: [ :each | each materialStateMemento ]
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> polytopeConvexHullVertices [
	^ vertices
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> polytopeEnclosingPlanes [
	^ faces collect: [ :each | each plane ]
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> polytopeSupportFunction [
	^ [:direction |
		| result bestSoFar |
		result := vertices first.
		bestSoFar := result dot: direction.
		
		vertices allButFirstDo: [:vertex |
			| nextDot |
			nextDot := vertex dot: direction.
			nextDot > bestSoFar ifTrue: [ 
				result := vertex.
				bestSoFar := nextDot
			]
		].
	
		result
	]
]

{ #category : #copying }
WDEPolyhedronVisualComponent >> postCopy [
	| copiedFaces |
	super postCopy.
	
	copiedFaces := (self faces collect: [:each | each copy]).
	faces := #().
	self faces: copiedFaces.
	vertices := vertices copy.
	
]

{ #category : #memento }
WDEPolyhedronVisualComponent >> restoreMaterialStateMemento: memento [
	faces doWithIndex: [ :faceMemento :faceIndex |
		(faces at: faceIndex)
			restoreMaterialStateMemento: faceMemento
	].
	self changed
]

{ #category : #memento }
WDEPolyhedronVisualComponent >> restoreTransformStateMemento: memento [
	memento first doWithIndex: [ :faceMemento :index |
		(faces at: index)
			restoreTransformStateMemento: faceMemento
	].
	vertices := memento second.
	self computeBoundingBox.
	self changed
]

{ #category : #initialization }
WDEPolyhedronVisualComponent >> setMaterial: newMaterial [
	faces do: [ :each | each setMaterial: newMaterial ].
	self changed.
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> subtract: otherVisualComponent withTransform: transform [
	| otherPlanes otherPlaneClassifications clippingPlanes result remaining |
	(self hasIntersectionWith: otherVisualComponent withTransform: transform) ifFalse: [
		^ super subtract: otherVisualComponent withTransform: transform
	].

	otherPlanes := otherVisualComponent polytopeEnclosingPlanes.
	otherPlanes ifEmpty: [ ^ self subtract: otherVisualComponent withTransform: transform ].
	
	otherPlanes := otherPlanes collect: [ :each | each transformedWith: transform ].
	
	otherPlaneClassifications := otherPlanes collect: [ :eachPlane | eachPlane classifyVertices: vertices epsilon: Epsilon ].

	"Am I fully contained in the other polytope?"
	(otherPlaneClassifications allSatisfy: [:each | #(back inside) includes: each ]) ifTrue: [ ^ #() ].
	
	"Am I fully outside the other polytope?"
	(otherPlaneClassifications anySatisfy: [:each | #(front inside) includes: each ]) ifTrue: [ ^ { self } ].
	
	"We only clip against front and back planes."
	clippingPlanes := OrderedCollection new.
	otherPlaneClassifications doWithIndex: [ :classification :index |
		classification == #frontAndBack ifTrue: [ 
			clippingPlanes add: (otherPlanes at: index)
		].
	].

	self assert: clippingPlanes isNotEmpty.
	result := OrderedCollection new. 
	remaining := self.
	clippingPlanes do: [ :plane |
		| frontAndBack front back |
		frontAndBack := remaining clipAgainstPlane: plane.
		front := frontAndBack first.
		back := frontAndBack second.
		front ifNotNil: [
			result add: front
		].

		self assert: back isNotNil.
		remaining := back
	].
	
	^ result
]

{ #category : #memento }
WDEPolyhedronVisualComponent >> transformStateMemento [
	^ {
		faces collect: [ :each | each transformStateMemento ] .
		vertices
	}
]

{ #category : #constructing }
WDEPolyhedronVisualComponent >> transformWith: transform [
	faces do: [ :each | each transformWith: transform ].
	vertices := vertices collect: [ :each | transform transformPosition: each ].
	self computeBoundingBox.
	self changed
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> validateMaterialList [
	faces do: [ :each | each validateMaterialList ]
]

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

{ #category : #accessing }
WDEPolyhedronVisualComponent >> boundingBox [
	boundingBox ifNil: [ self computeBoundingBox ].
	^ boundingBox
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
WDEPolyhedronVisualComponent >> planesForCollisionConvexHull [
	^ faces collect: [ :each | each plane ]
]

{ #category : #'as yet unclassified' }
WDEPolyhedronVisualComponent >> pointsForCollisionConvexHull [
	^ vertices
]

{ #category : #copying }
WDEPolyhedronVisualComponent >> postCopy [
	super postCopy.
	self faces: self faces copy.
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

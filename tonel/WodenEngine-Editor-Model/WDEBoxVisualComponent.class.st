Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'box',
		'materialAttributes'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEBoxVisualComponent >> accept: visitor [
	^ visitor visitBoxVisualComponent: self
]

{ #category : #converting }
WDEBoxVisualComponent >> asPolyhedronVisualComponent [
	| polyhedron |
	polyhedron := self class polyhedronBox: box.
	polyhedron faces do: [ :each | each materialAttributes: materialAttributes ].
	^ polyhedron
]

{ #category : #accessing }
WDEBoxVisualComponent >> boundingBox [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box: anObject [
	box := anObject.
	self changed.
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	| renderMaterial |
	renderMaterial := materialAttributes asRenderMaterialForEngine: meshBuilder engine levelEditorSession: levelEditorSession.

	^ meshBuilder
		currentMaterial: renderMaterial;
		transform: self boundingBox reversibleTransformToConvertUnitBoxToMe;
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		planeTextureTransform: materialAttributes textureTransform withModelTransform: modelTransform;
		computeTangentsBitangents;
		computeBoundingBox;
		mesh.

]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	^ meshBuilder
		currentMaterial: renderMaterial;
		transform: self boundingBox reversibleTransformToConvertUnitBoxToMe;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		computeBoundingBox;
		mesh.

]

{ #category : #serialization }
WDEBoxVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#box . box encodeForJSON.
		#material . materialAttributes encodeForJSON
	}
]

{ #category : #accessing }
WDEBoxVisualComponent >> entityTransformChanged [
	materialAttributes hasTexture ifTrue: [
		self raiseChangedEvent
	].

]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> hasIntersectionWith: otherVisualComponent withTransform: transform [
	^ otherVisualComponent hasIntersectionWithBoxVisualComponent: self withTransform: transform inverse
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> hasIntersectionWithBoxVisualComponent: otherBox withTransform: otherTransform [
	otherTransform matrix isIdentity ifFalse: [
		^ super hasIntersectionWithBoxVisualComponent: otherBox withTransform: otherTransform
	].

	^ box hasIntersectionWithBox: (otherBox box transformedWith: otherTransform)
]

{ #category : #initialization }
WDEBoxVisualComponent >> initialize [
	super initialize.
	box := BoxF32 unitBox.
	materialAttributes := WDEFaceMaterialAttributes new.
]

{ #category : #testing }
WDEBoxVisualComponent >> isBoxVisualComponent [
	^ true
]

{ #category : #serialization }
WDEBoxVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	box := BoxF32 loadFromJson: (jsonData at: 'box').
	jsonData at: 'material' ifPresent: [ :data |
		materialAttributes loadFromJson: data context: context
	].
	
]

{ #category : #accessing }
WDEBoxVisualComponent >> materialAttributes [

	^ materialAttributes
]

{ #category : #accessing }
WDEBoxVisualComponent >> materialAttributes: newMaterialAttributes [
	materialAttributes := newMaterialAttributes copy.
]

{ #category : #memento }
WDEBoxVisualComponent >> materialStateMemento [
	^ materialAttributes materialStateMemento
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> polytopeConvexHullVertices [
	^ box corners
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> polytopeSupportFunction [
	^ [:direction | box positiveVertex: direction ]
]

{ #category : #memento }
WDEBoxVisualComponent >> restoreMaterialStateMemento: memento [
	materialAttributes restoreMaterialStateMemento: memento
]

{ #category : #memento }
WDEBoxVisualComponent >> restoreTransformStateMemento: memento [
	self box: memento
]

{ #category : #initialization }
WDEBoxVisualComponent >> setMaterial: newMaterial [
	materialAttributes material: newMaterial.
	self changed
]

{ #category : #memento }
WDEBoxVisualComponent >> transformStateMemento [
	^ self box
]

{ #category : #transforms }
WDEBoxVisualComponent >> transformWith: transform [
	self box: (self box transformedWith: transform)
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> validateMaterialList [
	self level validateMaterial: materialAttributes material
]

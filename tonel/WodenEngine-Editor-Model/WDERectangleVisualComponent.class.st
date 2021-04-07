Class {
	#name : #WDERectangleVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'rectangle',
		'materialAttributes'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDERectangleVisualComponent >> accept: visitor [
	^ visitor visitRectangleVisualComponent: self
]

{ #category : #accessing }
WDERectangleVisualComponent >> boundingRectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		vector2PropertyNamed: 'Texture Scale' selector: #textureScale;
		vector2PropertyNamed: 'Texture Offset' selector: #textureOffset
]

{ #category : #'as yet unclassified' }
WDERectangleVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
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
WDERectangleVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	^ meshBuilder
		currentMaterial: renderMaterial;
		transform: self boundingBox reversibleTransformToConvertUnitBoxToMe;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		computeBoundingBox;
		mesh.

]

{ #category : #serialization }
WDERectangleVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#rectangle . rectangle encodeForJSON.
		#material . materialAttributes encodeForJSON
	}
]

{ #category : #accessing }
WDERectangleVisualComponent >> entityTransformChanged [
	materialAttributes hasTexture ifTrue: [
		self raiseChangedEvent
	]
]

{ #category : #initialization }
WDERectangleVisualComponent >> initialize [
	super initialize.
	rectangle := RectangleF32 unitRectangle.
	materialAttributes := WDEFaceMaterialAttributes new.
]

{ #category : #testing }
WDERectangleVisualComponent >> isRectangleVisualComponent [
	^ true
]

{ #category : #serialization }
WDERectangleVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	rectangle := RectangleF32 loadFromJson: (jsonData at: 'rectangle').
	jsonData at: 'material' ifPresent: [ :index |
		material := context getMaterialWithIndex: index
	].
	jsonData at: 'textureScale' ifPresent: [ :scale |
		textureScale := Float32x2 loadFromJson: scale.
	].
	jsonData at: 'textureOffset' ifPresent: [ :offset |
		textureOffset := Float32x2 loadFromJson: offset.
	].
]

{ #category : #memento }
WDERectangleVisualComponent >> materialStateMemento [
	^ materialAttributes material
]

{ #category : #'as yet unclassified' }
WDERectangleVisualComponent >> pointsForCollisionConvexHull [
	^ self boundingBox corners
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle: anObject [
	rectangle := anObject.
	self changed.
]

{ #category : #memento }
WDERectangleVisualComponent >> restoreMaterialStateMemento: memento [
	materialAttributes material: memento
]

{ #category : #memento }
WDERectangleVisualComponent >> restoreTransformStateMemento: memento [
	self rectangle: memento
]

{ #category : #initialization }
WDERectangleVisualComponent >> setMaterial: newMaterial [
	self material: newMaterial
]

{ #category : #memento }
WDERectangleVisualComponent >> transformStateMemento [
	^ self rectangle
]

{ #category : #transforms }
WDERectangleVisualComponent >> transformWith: transform [
	self rectangle: (self rectangle asBox transformedWith: transform) asRectangleXY.

]

{ #category : #'as yet unclassified' }
WDERectangleVisualComponent >> validateMaterialList [
	self level validateMaterial: materialAttributes material
]

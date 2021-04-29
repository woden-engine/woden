Class {
	#name : #WDEPolyhedronFace,
	#superclass : #WDELevelElement,
	#instVars : [
		'parent',
		'plane',
		'vertices',
		'materialAttributes'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #accessing }
WDEPolyhedronFace class >> name: faceName plane: plane [
	^ self new name: faceName; plane: plane; yourself
]

{ #category : #accessing }
WDEPolyhedronFace class >> plane: plane [
	^ self new plane: plane
]

{ #category : #visiting }
WDEPolyhedronFace >> accept: visitor [
	^ visitor visitPolyhedronFace: self
]

{ #category : #'as yet unclassified' }
WDEPolyhedronFace >> buildMeshWith: meshBuilder modelTransform: modelTransform [
	meshBuilder currentMaterial: (materialAttributes asRenderMaterialForEngine: meshBuilder engine).
	self doBuildMeshWith: meshBuilder modelTransform: modelTransform
]

{ #category : #'as yet unclassified' }
WDEPolyhedronFace >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	meshBuilder currentMaterial: (materialAttributes asRenderMaterialForEngine: meshBuilder engine levelEditorSession: levelEditorSession).
	self doBuildMeshWith: meshBuilder modelTransform: modelTransform
]

{ #category : #'as yet unclassified' }
WDEPolyhedronFace >> buildWireMeshWith: meshBuilder [
	meshBuilder beginLines.
	vertices do: [ :each | meshBuilder addP: each ].
	1 to: vertices size - 1 do: [ :i |
		meshBuilder
			addI1: i i2: i + 1
	].
	meshBuilder addI1: vertices size i2: 1
]

{ #category : #'as yet unclassified' }
WDEPolyhedronFace >> doBuildMeshWith: meshBuilder modelTransform: modelTransform [
	| normal normalAxis tangent bitangent textureMatrix |
	meshBuilder beginTriangles.
	normal := plane normal.
	normalAxis := meshBuilder computeNormalAxis: normal.
	tangent := meshBuilder tangentForAxis: normalAxis.
	bitangent := meshBuilder bitangentForAxis: normalAxis.
	textureMatrix := materialAttributes textureTransform.
		
	vertices do: [ :each |
		| uv worldVertex |
		worldVertex := modelTransform transformPosition: each.
		uv := Float32x2 x: (tangent dot: worldVertex) y: (bitangent dot: worldVertex).

		meshBuilder addP: each N: normal TC: (textureMatrix transformVector2: uv)
	].

	3 to: vertices size do: [ :i |
		meshBuilder addI1: 1 i2: i - 1 i3: i
	]
]

{ #category : #serialization }
WDEPolyhedronFace >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#plane . plane encodeForJSON.
		#vertices . vertices collect: [ :each | each encodeForJSON ] .
		#material . materialAttributes encodeForJSON
	}
]

{ #category : #testing }
WDEPolyhedronFace >> hasTexture [
	^ materialAttributes hasTexture
]

{ #category : #initialization }
WDEPolyhedronFace >> initialize [
	super initialize.
	materialAttributes := WDEFaceMaterialAttributes new.
	vertices := #().
]

{ #category : #serialization }
WDEPolyhedronFace >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	
	jsonData at: 'plane' ifPresent: [ :data |
		plane := PlaneF32 loadFromJson: data
	].

	jsonData at: 'vertices' ifPresent: [ :data |
		vertices := data collect: [ :each | Float32x3 loadFromJson: each ] as: Array
	].

	jsonData at: 'material' ifPresent: [ :data |
		materialAttributes loadFromJson: data context: context
	].
	
]

{ #category : #accessing }
WDEPolyhedronFace >> materialAttributes [

	^ materialAttributes
]

{ #category : #accessing }
WDEPolyhedronFace >> materialAttributes: newMaterialAttributes [

	materialAttributes := newMaterialAttributes copy
]

{ #category : #memento }
WDEPolyhedronFace >> materialStateMemento [
	^ materialAttributes materialStateMemento
]

{ #category : #accessing }
WDEPolyhedronFace >> parent [
	^ parent
]

{ #category : #accessing }
WDEPolyhedronFace >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
WDEPolyhedronFace >> plane [

	^ plane
]

{ #category : #accessing }
WDEPolyhedronFace >> plane: anObject [

	plane := anObject
]

{ #category : #copying }
WDEPolyhedronFace >> postCopy [
	super postCopy.
	materialAttributes := materialAttributes copy.
	parent := nil.
]

{ #category : #memento }
WDEPolyhedronFace >> restoreMaterialStateMemento: memento [
	materialAttributes restoreMaterialStateMemento: memento
]

{ #category : #memento }
WDEPolyhedronFace >> restoreTransformStateMemento: memento [
	vertices := memento first.
	plane := memento second.
]

{ #category : #initialization }
WDEPolyhedronFace >> setMaterial: newMaterial [
	materialAttributes material: newMaterial.
	parent ifNotNil: [ parent changed ].
]

{ #category : #sorting }
WDEPolyhedronFace >> sortVerticesCounterClockwise [
	| centroid normal |
	centroid := vertices sum / vertices size.
	normal := plane normal.
	vertices sort: [ :a :b |
		|u v |
		u := a - centroid.
		v := b - centroid.
		((u cross: v) dot: normal) >= 0
	].
]

{ #category : #memento }
WDEPolyhedronFace >> transformStateMemento [
	^ { vertices . plane }
]

{ #category : #transforms }
WDEPolyhedronFace >> transformWith: transform [
	vertices := vertices collect: [ :each | transform transformPosition: each ].
	plane := plane transformedWith: transform
]

{ #category : #'as yet unclassified' }
WDEPolyhedronFace >> validateMaterialList [
	self level validateMaterial: materialAttributes material
]

{ #category : #accessing }
WDEPolyhedronFace >> vertices [

	^ vertices
]

{ #category : #accessing }
WDEPolyhedronFace >> vertices: anObject [

	vertices := anObject
]

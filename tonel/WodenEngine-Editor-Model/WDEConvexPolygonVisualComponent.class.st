Class {
	#name : #WDEConvexPolygonVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'vertices',
		'boundingRectangle',
		'topFaceAttributes',
		'bottomFaceAttributes',
		'sideFaceAttributes'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEConvexPolygonVisualComponent >> accept: visitor [
	^ visitor visitConvexPolygonVisualComponent: self
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> backFaceOffset [
	^ self sectorLayer layerHalfThickness negated
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> backVertices [
	| offset |
	offset := self backFaceOffset.
	^ self vertices collect: [ :each | Float32x3 xy: each z: offset ]
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> bottomFaceAttributes [

	^ bottomFaceAttributes
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> boundingRectangle [
	^ boundingRectangle
]

{ #category : #rendering }
WDEConvexPolygonVisualComponent >> buildMeshWith: meshBuilder modelTransform: modelTransform [

	self extrudedFacesDo: [ :faceVertices :faceNormal |
		| normalAxis tangent bitangent textureMatrix faceAttributes |
		faceAttributes := self faceAttributesForNormal: faceNormal.
		meshBuilder
			currentMaterial: (faceAttributes materialAttributes asRenderMaterialForEngine: meshBuilder engine);
			beginTriangles.

		normalAxis := meshBuilder computeNormalAxis: faceNormal.
		tangent := meshBuilder tangentForAxis: normalAxis.
		bitangent := meshBuilder bitangentForAxis: normalAxis.
		textureMatrix := faceAttributes materialAttributes textureTransform.

		faceVertices do: [ :each |
			| uv worldVertex |
			worldVertex := modelTransform transformPosition: each.
			uv := Float32x2 x: (tangent dot: worldVertex) y: (bitangent dot: worldVertex).

			meshBuilder addP: each N: faceNormal TC: (textureMatrix transformVector2: uv)
		].
		3 to: faceVertices size do: [ :i |
			meshBuilder addI1: 1 i2: i - 1 i3: i
		].
	].

	^ meshBuilder
		computeTangentsBitangents;
		computeBoundingBox;
		mesh
]

{ #category : #rendering }
WDEConvexPolygonVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	self extrudedFacesDo: [ :faceVertices :faceNormal |
		| normalAxis tangent bitangent textureMatrix faceAttributes |
		faceAttributes := self faceAttributesForNormal: faceNormal.
		meshBuilder
			currentMaterial: (faceAttributes materialAttributes asRenderMaterialForEngine: meshBuilder engine levelEditorSession: levelEditorSession);
			beginTriangles.

		normalAxis := meshBuilder computeNormalAxis: faceNormal.
		tangent := meshBuilder tangentForAxis: normalAxis.
		bitangent := meshBuilder bitangentForAxis: normalAxis.
		textureMatrix := faceAttributes materialAttributes textureTransform.

		faceVertices do: [ :each |
			| uv worldVertex |
			worldVertex := modelTransform transformPosition: each.
			uv := Float32x2 x: (tangent dot: worldVertex) y: (bitangent dot: worldVertex).

			meshBuilder addP: each N: faceNormal TC: (textureMatrix transformVector2: uv)
		].
		3 to: faceVertices size do: [ :i |
			meshBuilder addI1: 1 i2: i - 1 i3: i
		].
	].

	^ meshBuilder
		computeTangentsBitangents;
		computeBoundingBox;
		mesh
]

{ #category : #rendering }
WDEConvexPolygonVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	meshBuilder
		currentMaterial: renderMaterial.
		
	self extrudedFacesDo: [ :faceVertices :faceNormal |
		meshBuilder
			beginLines.
		faceVertices do: [ :each | meshBuilder addP: each ].
		1 to: faceVertices size - 1 do: [ :i |
			meshBuilder
				addI1: i i2: i + 1
		].
		meshBuilder addI1: faceVertices size i2: 1.
	].

	^ meshBuilder
		computeBoundingBox;
		mesh
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> children [
	^ { topFaceAttributes . bottomFaceAttributes . sideFaceAttributes }
]

{ #category : #private }
WDEConvexPolygonVisualComponent >> computeBoundingRectangle [
	boundingRectangle := RectangleF32 encompassing: vertices.
]

{ #category : #'as yet unclassified' }
WDEConvexPolygonVisualComponent >> constructForRectangle: rectangle [
	self vertices: rectangle corners.
]

{ #category : #serialization }
WDEConvexPolygonVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#vertices . vertices collect: [ :each | each encodeForJSON ].
		#boundingRectangle . boundingRectangle encodeForJSON .
		#topFace . topFaceAttributes encodeForJSON.
		#bottomFace . bottomFaceAttributes encodeForJSON.
		#sideFace . sideFaceAttributes encodeForJSON.
	}
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> entityTransformChanged [
	self hasTexture ifTrue: [
		self raiseChangedEvent
	]
]

{ #category : #rendering }
WDEConvexPolygonVisualComponent >> extrudedFacesDo: aBlock [
	| frontNormal frontVertices backNormal backVertices vertexCount |

	"Front face"
	frontNormal := Float32x3 z: 1.
	frontVertices := self frontVertices.
	aBlock value: frontVertices value: frontNormal.

	"Back face"
	backNormal := Float32x3 z: -1.
	backVertices := self backVertices.
	aBlock value: backVertices reversed value: backNormal.

	"Side faces"
	vertexCount := frontVertices size.
	1 to: vertexCount do: [ :vs |
		| ve faceVertices u v normal |
		ve := vs \\ vertexCount + 1.
		faceVertices := {
			frontVertices at: ve.
			frontVertices at: vs.
			backVertices at: vs.
			backVertices at: ve.
		}.
		
		u := faceVertices second - faceVertices first.
		v := faceVertices third - faceVertices first.
		normal := (u cross: v) normalized.
		aBlock value: faceVertices value: normal.
	]
]

{ #category : #'as yet unclassified' }
WDEConvexPolygonVisualComponent >> faceAttributesForNormal: normal [
	normal y > 0 ifTrue: [ ^ topFaceAttributes ].
	normal y < 0 ifTrue: [ ^ bottomFaceAttributes ].
	^ sideFaceAttributes
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> frontFaceOffset [
	^ self sectorLayer layerHalfThickness
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> frontVertices [
	| offset |
	offset := self frontFaceOffset.
	^ self vertices collect: [ :each | Float32x3 xy: each z: offset ]
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> hasTexture [
	^ topFaceAttributes materialAttributes hasTexture or:
	[ bottomFaceAttributes materialAttributes hasTexture or: [
	  sideFaceAttributes materialAttributes hasTexture ] ]
]

{ #category : #initialization }
WDEConvexPolygonVisualComponent >> initialize [
	super initialize.
	vertices := {}.
	boundingRectangle := RectangleF32 new.
	topFaceAttributes := WDEPolygonSideAttributes new name: 'Top'; parent: self; yourself.
	bottomFaceAttributes := WDEPolygonSideAttributes new name: 'Bottom'; parent: self; yourself.
	sideFaceAttributes := WDEPolygonSideAttributes new name: 'Side'; parent: self; yourself.

]

{ #category : #testing }
WDEConvexPolygonVisualComponent >> isConvexPolygonVisualComponent [
	^ true
]

{ #category : #serialization }
WDEConvexPolygonVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	jsonData at: 'vertices' ifPresent: [ :verticesData |
		vertices := verticesData collect: [ :each | Float32x2 loadFromJson: each ].
	].
	jsonData at: 'boundingRectangle' ifPresent: [ :brect |
		boundingRectangle := RectangleF32  loadFromJson: brect.
	].

	jsonData at: 'topFace' ifPresent: [ :attr |
		topFaceAttributes loadFromJson: attr context: context
	].

	jsonData at: 'bottomFace' ifPresent: [ :attr |
		bottomFaceAttributes loadFromJson: attr context: context
	].

	jsonData at: 'sideFace' ifPresent: [ :attr |
		sideFaceAttributes loadFromJson: attr context: context
	].

]

{ #category : #memento }
WDEConvexPolygonVisualComponent >> materialStateMemento [
	^ {
		topFaceAttributes materialStateMemento .
		bottomFaceAttributes materialStateMemento .
		sideFaceAttributes materialStateMemento
	}
]

{ #category : #representations }
WDEConvexPolygonVisualComponent >> polygonConvexHullVertices [
	^ vertices
]

{ #category : #copying }
WDEConvexPolygonVisualComponent >> postCopy [
	super postCopy.
	
	vertices := vertices copy.
	topFaceAttributes := topFaceAttributes copy parent: self.
	bottomFaceAttributes := bottomFaceAttributes copy parent: self.
	sideFaceAttributes := sideFaceAttributes copy parent: self.
]

{ #category : #memento }
WDEConvexPolygonVisualComponent >> restoreMaterialStateMemento: memento [
	topFaceAttributes restoreMaterialStateMemento: memento first.
	bottomFaceAttributes restoreMaterialStateMemento: memento second.
	sideFaceAttributes restoreMaterialStateMemento: memento third
]

{ #category : #memento }
WDEConvexPolygonVisualComponent >> restoreTransformStateMemento: memento [
	self vertices: memento
]

{ #category : #initialization }
WDEConvexPolygonVisualComponent >> setMaterial: newMaterial [
	topFaceAttributes setMaterial: newMaterial.
	bottomFaceAttributes setMaterial: newMaterial.
	sideFaceAttributes setMaterial: newMaterial.
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> sideFaceAttributes [

	^ sideFaceAttributes
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> topFaceAttributes [

	^ topFaceAttributes
]

{ #category : #memento }
WDEConvexPolygonVisualComponent >> transformStateMemento [
	^ self vertices
]

{ #category : #transforms }
WDEConvexPolygonVisualComponent >> transformWith: transform [
	self vertices: (self vertices collect: [ :each | (transform transformPosition: (Float32x3 xy: each z: 0)) xy ])

]

{ #category : #'as yet unclassified' }
WDEConvexPolygonVisualComponent >> validateMaterialList [
	topFaceAttributes validateMaterialList.
	bottomFaceAttributes validateMaterialList.
	sideFaceAttributes validateMaterialList.
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> vertices [

	^ vertices
]

{ #category : #accessing }
WDEConvexPolygonVisualComponent >> vertices: aCollectionOfVertices [
	vertices := Array withAll: aCollectionOfVertices.
	self
		computeBoundingRectangle;
		changed.
]

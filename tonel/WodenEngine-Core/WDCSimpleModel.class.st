"
I represent an offline simple 3D model. A simple 3D model is a model that does not involve a complex scene graph. I can be converted into a generic renderable.

I am created by converting a 3D model from a 3D design application.
"
Class {
	#name : #WDCSimpleModel,
	#superclass : #WDCAbstractModel,
	#instVars : [
		'vertices',
		'indices',
		'submeshes',
		'boundingBox',
		'armature'
	],
	#classVars : [
		'VertexChannelDescriptions'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'model conversion' }
WDCSimpleModel class >> convertModelFile: aFileName modifyingWith: aBlock [
	| fileRef loadedModel targetFileRef |
	fileRef := aFileName asFileReference.
	loadedModel := self loadFromFile: fileRef.
	aBlock value: loadedModel.

	targetFileRef := fileRef withExtension: 'fmdl'.
	loadedModel saveTo: targetFileRef
]

{ #category : #'model conversion' }
WDCSimpleModel class >> modelConversionScript [
	<script>
	#(
		('core-assets/models/demos/magnum.wmjson' 'materials/demos/magnum.json')
		('core-assets/models/demos/magnum_fps.wmjson' 'materials/demos/magnum_fps.json')
	) do: [ :asset |
		self convertModelFile: asset first modifyingWith: [ :loadedModel |
			loadedModel combineSubmeshesWithMaterial: asset second.
		]
	]

]

{ #category : #accessing }
WDCSimpleModel >> armature [
	^ armature
]

{ #category : #accessing }
WDCSimpleModel >> armature: anObject [
	armature := anObject
]

{ #category : #accessing }
WDCSimpleModel >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCSimpleModel >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #modifiers }
WDCSimpleModel >> combineSubmeshes [
	submeshes := {WDCModelSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: submeshes first material;
		yourself
	}
]

{ #category : #modifiers }
WDCSimpleModel >> combineSubmeshesWithMaterial: aMaterial [
	self combineSubmeshes.
	submeshes first material: aMaterial.
]

{ #category : #'as yet unclassified' }
WDCSimpleModel >> createIndexBufferFor: anEngine [
	^ anEngine createIndex: indices elementSize elements: indices size immutableBuffer: indices rawData
]

{ #category : #'as yet unclassified' }
WDCSimpleModel >> createVertexBindingFor: anEngine [
	^ vertices createVertexBindingFor: anEngine
]

{ #category : #accessing }
WDCSimpleModel >> indices [
	^ indices
]

{ #category : #accessing }
WDCSimpleModel >> indices: anObject [
	indices := anObject
]

{ #category : #modifiers }
WDCSimpleModel >> mapMaterials: aDictionary [
	submeshes do: [ :submesh | submesh material: (aDictionary at: submesh material) ]
]

{ #category : #'as yet unclassified' }
WDCSimpleModel >> meshFor: anEngine [
	| mesh |
	mesh := WDCGenericMesh new.
	mesh
		vertexData: vertices;
		boundingBox: boundingBox copy;
		vertexBinding: (self createVertexBindingFor: anEngine);
		indexBuffer: (self createIndexBufferFor: anEngine);
		submeshes: (submeshes collect: [:sm | sm subMeshFor: anEngine]).
		
	armature ifNotNil: [
		^ WDCSkinnedRenderableMesh new
			mesh: mesh;
			armature: armature;
			yourself
	].

	^ mesh
]

{ #category : #fileout }
WDCSimpleModel >> saveTo: aFileName [
	WDCAbstractModelWriter save: self toFile: aFileName
]

{ #category : #accessing }
WDCSimpleModel >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDCSimpleModel >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WDCSimpleModel >> vertices [
	^ vertices
]

{ #category : #accessing }
WDCSimpleModel >> vertices: anObject [
	vertices := anObject
]

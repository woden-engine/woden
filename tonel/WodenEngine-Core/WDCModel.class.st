"
I represent an offline 3D model. I am created by converting a 3D model from a 3D design application.
"
Class {
	#name : #WDCModel,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'indices',
		'submeshes',
		'boundingBox',
		'armature',
		'actions'
	],
	#classVars : [
		'VertexChannelDescriptions'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCModel >> actions [
	^ actions
]

{ #category : #accessing }
WDCModel >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
WDCModel >> armature [
	^ armature
]

{ #category : #accessing }
WDCModel >> armature: anObject [
	armature := anObject
]

{ #category : #accessing }
WDCModel >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCModel >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #modifiers }
WDCModel >> combineSubmeshes [
	submeshes := {WDCModelSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: submeshes first material;
		yourself
	}
]

{ #category : #modifiers }
WDCModel >> combineSubmeshesWithMaterial: aMaterial [
	self combineSubmeshes.
	submeshes first material: aMaterial.
]

{ #category : #'as yet unclassified' }
WDCModel >> createIndexBufferFor: anEngine [
	^ anEngine createIndex: indices elementSize elements: indices size immutableBuffer: indices rawData
]

{ #category : #'as yet unclassified' }
WDCModel >> createVertexBindingFor: anEngine [
	^ vertices createVertexBindingFor: anEngine
]

{ #category : #accessing }
WDCModel >> indices [
	^ indices
]

{ #category : #accessing }
WDCModel >> indices: anObject [
	indices := anObject
]

{ #category : #modifiers }
WDCModel >> mapMaterials: aDictionary [
	submeshes do: [ :submesh | submesh material: (aDictionary at: submesh material) ]
]

{ #category : #'as yet unclassified' }
WDCModel >> meshFor: anEngine [
	| mesh |
	armature ifNotNil: [
		mesh := WDCSkinnedGenericMesh new.
		mesh
			armature: armature;
			actions: actions
	] ifNil: [ 
		mesh := WDCGenericMesh new.
	].
	mesh
		boundingBox: boundingBox copy;
		vertexBinding: (self createVertexBindingFor: anEngine);
		indexBuffer: (self createIndexBufferFor: anEngine);
		submeshes: (submeshes collect: [:sm | sm subMeshFor: anEngine]).
	^ mesh
]

{ #category : #accessing }
WDCModel >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDCModel >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WDCModel >> vertices [
	^ vertices
]

{ #category : #accessing }
WDCModel >> vertices: anObject [
	vertices := anObject
]

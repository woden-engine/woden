Class {
	#name : #WTModel,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'indices',
		'submeshes',
		'boundingBox',
		'armature',
		'actions'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTModel >> actions [
	^ actions
]

{ #category : #accessing }
WTModel >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
WTModel >> armature [
	^ armature
]

{ #category : #accessing }
WTModel >> armature: anObject [
	armature := anObject
]

{ #category : #accessing }
WTModel >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WTModel >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #modifiers }
WTModel >> combineSubmeshes [
	submeshes := {WTModelSubmesh new
		firstIndex: 0;
		indexCount: indices size;
		primitiveType: AGPU_TRIANGLES;
		material: submeshes first material;
		yourself
	}
]

{ #category : #modifiers }
WTModel >> combineSubmeshesWithMaterial: aMaterial [
	self combineSubmeshes.
	submeshes first material: aMaterial.
]

{ #category : #'as yet unclassified' }
WTModel >> createIndexBufferFor: anEngine [
	^ anEngine createIndex: indices elementSize elements: indices size immutableBuffer: indices rawData
]

{ #category : #'as yet unclassified' }
WTModel >> createVertexBindingFor: anEngine [
	| result vertexLayout |
	vertexLayout := anEngine vertexLayoutFor: vertices elementType behavior.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }.
	^ result
]

{ #category : #'as yet unclassified' }
WTModel >> createVertexBufferFor: anEngine [
	^ anEngine createVertex: vertices elementSize elements: vertices size immutableBuffer: vertices rawData 
]

{ #category : #accessing }
WTModel >> indices [
	^ indices
]

{ #category : #accessing }
WTModel >> indices: anObject [
	indices := anObject
]

{ #category : #modifiers }
WTModel >> mapMaterials: aDictionary [
	submeshes do: [ :submesh | submesh material: (aDictionary at: submesh material) ]
]

{ #category : #'as yet unclassified' }
WTModel >> meshFor: anEngine [
	| mesh |
	armature ifNotNil: [
		mesh := WTSkinnedGenericMesh new.
		mesh
			armature: armature;
			actions: actions
	] ifNil: [ 
		mesh := WTGenericMesh new.
	].
	mesh
		boundingBox: boundingBox copy;
		vertexBinding: (self createVertexBindingFor: anEngine);
		indexBuffer: (self createIndexBufferFor: anEngine);
		submeshes: (submeshes collect: [:sm | sm subMeshFor: anEngine]).
	^ mesh
]

{ #category : #accessing }
WTModel >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WTModel >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WTModel >> vertices [
	^ vertices
]

{ #category : #accessing }
WTModel >> vertices: anObject [
	vertices := anObject
]

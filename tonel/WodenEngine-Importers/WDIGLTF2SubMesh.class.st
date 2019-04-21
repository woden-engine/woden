Class {
	#name : #WDIGLTF2SubMesh,
	#superclass : #WDSSceneAssetModelLoader,
	#instVars : [
		'vertexData',
		'indexBufferAccessor',
		'material',
		'primitiveType'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #converting }
WDIGLTF2SubMesh >> asWDCGenericSubmesh [
	^ WDCGenericSubmesh new
		material: material;
		indexBuffer: indexBufferAccessor asIndexBuffer;
		firstIndex: indexBufferAccessor asFirstIndexIndex;
		indexCount: indexBufferAccessor count;
		primitiveType: primitiveType;
		yourself
]

{ #category : #accessing }
WDIGLTF2SubMesh >> indexBufferAccessor [
	^ indexBufferAccessor
]

{ #category : #accessing }
WDIGLTF2SubMesh >> indexBufferAccessor: anObject [
	indexBufferAccessor := anObject
]

{ #category : #accessing }
WDIGLTF2SubMesh >> material [
	^ material
]

{ #category : #accessing }
WDIGLTF2SubMesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDIGLTF2SubMesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDIGLTF2SubMesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #accessing }
WDIGLTF2SubMesh >> vertexData [
	^ vertexData
]

{ #category : #accessing }
WDIGLTF2SubMesh >> vertexData: anObject [
	vertexData := anObject
]

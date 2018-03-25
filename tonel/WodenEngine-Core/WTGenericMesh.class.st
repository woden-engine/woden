Class {
	#name : #WTGenericMesh,
	#superclass : #WTRenderable,
	#instVars : [
		'vertexBinding',
		'indexBuffer',
		'submeshes'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WTGenericMesh >> createSceneDependentDataFor: engine into: bindings [
	^ nil
]

{ #category : #accessing }
WTGenericMesh >> indexBuffer [
	^ indexBuffer
]

{ #category : #accessing }
WTGenericMesh >> indexBuffer: anObject [
	indexBuffer := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #'extra per object rendering data' }
WTGenericMesh >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
	
]

{ #category : #rendering }
WTGenericMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	stateTracker
		useVertexBinding: vertexBinding;
		useIndexBuffer: indexBuffer.
	submeshes do: [ :sm | sm renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
]

{ #category : #rendering }
WTGenericMesh >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	listBuilder
		useVertexBinding: vertexBinding validHandle;
		useIndexBuffer: indexBuffer validHandle.
	submeshes do: [ :sm | sm renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
]

{ #category : #accessing }
WTGenericMesh >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WTGenericMesh >> submeshes: anObject [
	submeshes := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #accessing }
WTGenericMesh >> vertexBinding [
	^ vertexBinding
]

{ #category : #accessing }
WTGenericMesh >> vertexBinding: anObject [
	vertexBinding := anObject.
	modificationCount := modificationCount + 1.
]

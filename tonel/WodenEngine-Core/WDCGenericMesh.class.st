Class {
	#name : #WDCGenericMesh,
	#superclass : #WDCRenderable,
	#instVars : [
		'vertexBinding',
		'indexBuffer',
		'submeshes'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WDCGenericMesh >> createSceneDependentDataFor: engine into: bindings [
	^ nil
]

{ #category : #accessing }
WDCGenericMesh >> indexBuffer [
	^ indexBuffer
]

{ #category : #accessing }
WDCGenericMesh >> indexBuffer: anObject [
	indexBuffer := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #'extra per object rendering data' }
WDCGenericMesh >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
	
]

{ #category : #rendering }
WDCGenericMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	stateTracker
		useVertexBinding: vertexBinding;
		useIndexBuffer: indexBuffer.
	submeshes do: [ :sm | sm renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
]

{ #category : #rendering }
WDCGenericMesh >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	listBuilder
		useVertexBinding: vertexBinding validHandle;
		useIndexBuffer: indexBuffer validHandle.
	submeshes do: [ :sm | sm renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
]

{ #category : #accessing }
WDCGenericMesh >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDCGenericMesh >> submeshes: anObject [
	submeshes := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #accessing }
WDCGenericMesh >> vertexBinding [
	^ vertexBinding
]

{ #category : #accessing }
WDCGenericMesh >> vertexBinding: anObject [
	vertexBinding := anObject.
	modificationCount := modificationCount + 1.
]

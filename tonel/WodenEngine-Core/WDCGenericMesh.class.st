"
I am a generic mesh renderable
"
Class {
	#name : #WDCGenericMesh,
	#superclass : #WDCRenderable,
	#instVars : [
		'vertexData',
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

{ #category : #'as yet unclassified' }
WDCGenericMesh >> engineChangedTo: newEngine [
	indexBuffer ifNotNil: [ indexBuffer engineChangedTo: newEngine ].
	vertexData ifNotNil: [ vertexData engineChangedTo: newEngine ].
	vertexBinding ifNotNil: [ vertexBinding engineChangedTo: newEngine ].
	(vertexBinding isNil and: [ vertexData isNotNil ]) ifTrue: [
		vertexBinding := vertexData createVertexBindingFor: newEngine
	].

	submeshes do: [ :sm | sm engineChangedTo: newEngine ]
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

{ #category : #rendering }
WDCGenericMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	stateTracker withVertexData: vertexData do: [
		stateTracker
			useVertexBinding: vertexBinding.
		indexBuffer ifNotNil: [ stateTracker useIndexBuffer: indexBuffer ].
		
		submeshes do: [ :sm | sm renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
	]

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

{ #category : #accessing }
WDCGenericMesh >> vertexData [
	^ vertexData
]

{ #category : #accessing }
WDCGenericMesh >> vertexData: anObject [
	vertexData := anObject
]

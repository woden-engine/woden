"
I am a generic mesh renderable
"
Class {
	#name : #WDCGenericMesh,
	#superclass : #WDCImmutableRenderable,
	#instVars : [
		'vertexData',
		'vertexBinding',
		'indexBuffer',
		'submeshes'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCGenericMesh >> engine: newEngine [
	indexBuffer ifNotNil: [ indexBuffer engine: newEngine ].
	vertexData ifNotNil: [ vertexData engine: newEngine ].
	vertexBinding ifNotNil: [ vertexBinding engine: newEngine ].
	(vertexBinding isNil and: [ vertexData isNotNil ]) ifTrue: [
		vertexBinding := vertexData createVertexBindingFor: newEngine
	].

	submeshes do: [ :sm | sm engine: newEngine ]
]

{ #category : #accessing }
WDCGenericMesh >> indexBuffer [
	^ indexBuffer
]

{ #category : #accessing }
WDCGenericMesh >> indexBuffer: anObject [
	indexBuffer := anObject
]

{ #category : #enumerating }
WDCGenericMesh >> precacheResources [
	super precacheResources.
	submeshes do: #precacheResources
]

{ #category : #rendering }
WDCGenericMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	stateTracker withVertexData: vertexData do: [
		self setupObjectRenderingStatesOn: stateTracker.
		stateTracker
			useVertexBinding: vertexBinding.
		indexBuffer ifNotNil: [ stateTracker useIndexBuffer: indexBuffer ].
		
		submeshes do: [ :sm | sm renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex ]
	]

]

{ #category : #accessing }
WDCGenericMesh >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDCGenericMesh >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WDCGenericMesh >> vertexBinding [
	^ vertexBinding
]

{ #category : #accessing }
WDCGenericMesh >> vertexBinding: anObject [
	vertexBinding := anObject
]

{ #category : #accessing }
WDCGenericMesh >> vertexData [
	^ vertexData
]

{ #category : #accessing }
WDCGenericMesh >> vertexData: anObject [
	vertexData := anObject
]

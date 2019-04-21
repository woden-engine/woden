"
I represent a mesh vertx channel.
"
Class {
	#name : #WDCMeshImplicitVertexChannel,
	#superclass : #WDCAbstractMeshVertexChannel,
	#instVars : [
		'description',
		'data'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> alignment [
	^ description alignment
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> at: anIndex [
	^ data at: anIndex
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> at: anIndex put: aValue [
	^ data at: anIndex put: aValue
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> binding [
	^ description binding
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> byteSize [
	^ data rawDataSize
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> bytes [
	^ data rawData
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> data [
	^ data
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> data: anObject [
	data := anObject
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> description [
	^ description
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> description: anObject [
	description := anObject
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> name [
	^ description name
]

{ #category : #printing }
WDCMeshImplicitVertexChannel >> printOn: aStream [
	aStream print: 'binding: '; print: self binding
]

{ #category : #accessing }
WDCMeshImplicitVertexChannel >> size [
	^ data size
]

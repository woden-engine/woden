"
I represent a mesh vertx channel.
"
Class {
	#name : #WDCMeshVertexChannel,
	#superclass : #Object,
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
WDCMeshVertexChannel >> alignment [
	^ description alignment
]

{ #category : #accessing }
WDCMeshVertexChannel >> at: anIndex [
	^ data at: anIndex
]

{ #category : #accessing }
WDCMeshVertexChannel >> at: anIndex put: aValue [
	^ data at: anIndex put: aValue
]

{ #category : #accessing }
WDCMeshVertexChannel >> binding [
	^ description binding
]

{ #category : #accessing }
WDCMeshVertexChannel >> byteSize [
	^ data rawDataSize
]

{ #category : #accessing }
WDCMeshVertexChannel >> bytes [
	^ data rawData
]

{ #category : #accessing }
WDCMeshVertexChannel >> data [
	^ data
]

{ #category : #accessing }
WDCMeshVertexChannel >> data: anObject [
	data := anObject
]

{ #category : #accessing }
WDCMeshVertexChannel >> description [
	^ description
]

{ #category : #accessing }
WDCMeshVertexChannel >> description: anObject [
	description := anObject
]

{ #category : #accessing }
WDCMeshVertexChannel >> name [
	^ description name
]

{ #category : #printing }
WDCMeshVertexChannel >> printOn: aStream [
	aStream print: 'binding: '; print: self binding
]

{ #category : #accessing }
WDCMeshVertexChannel >> size [
	^ data size
]

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

{ #category : #printing }
WDCMeshVertexChannel >> printOn: aStream [
	aStream print: 'binding: '; print: self binding
]

{ #category : #accessing }
WDCMeshVertexChannel >> size [
	^ data size
]

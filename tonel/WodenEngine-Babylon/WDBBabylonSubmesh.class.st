Class {
	#name : #WDBBabylonSubmesh,
	#superclass : #Object,
	#instVars : [
		'startIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #accessing }
WDBBabylonSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WDBBabylonSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WDBBabylonSubmesh >> material [
	^ material
]

{ #category : #accessing }
WDBBabylonSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDBBabylonSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDBBabylonSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #accessing }
WDBBabylonSubmesh >> startIndex [
	^ startIndex
]

{ #category : #accessing }
WDBBabylonSubmesh >> startIndex: anObject [
	startIndex := anObject
]

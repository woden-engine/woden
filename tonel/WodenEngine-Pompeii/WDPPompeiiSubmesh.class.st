Class {
	#name : #WDPPompeiiSubmesh,
	#superclass : #Object,
	#instVars : [
		'startIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #accessing }
WDPPompeiiSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WDPPompeiiSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WDPPompeiiSubmesh >> material [
	^ material
]

{ #category : #accessing }
WDPPompeiiSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDPPompeiiSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDPPompeiiSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #accessing }
WDPPompeiiSubmesh >> startIndex [
	^ startIndex
]

{ #category : #accessing }
WDPPompeiiSubmesh >> startIndex: anObject [
	startIndex := anObject
]

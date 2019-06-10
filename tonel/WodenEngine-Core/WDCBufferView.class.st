Class {
	#name : #WDCBufferView,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'offset',
		'length'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #accessing }
WDCBufferView >> buffer [
	^ buffer
]

{ #category : #accessing }
WDCBufferView >> buffer: anObject [
	buffer := anObject
]

{ #category : #'as yet unclassified' }
WDCBufferView >> engineChangedTo: anEngine [
	buffer engineChangedTo: anEngine
]

{ #category : #accessing }
WDCBufferView >> length [
	^ length
]

{ #category : #accessing }
WDCBufferView >> length: anObject [
	length := anObject
]

{ #category : #accessing }
WDCBufferView >> offset [
	^ offset
]

{ #category : #accessing }
WDCBufferView >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
WDCBufferView >> readStream [
	^ buffer readStreamFrom: offset withSize: length
]

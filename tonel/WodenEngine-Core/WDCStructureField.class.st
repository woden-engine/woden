Class {
	#name : #WDCStructureField,
	#superclass : #Object,
	#instVars : [
		'type',
		'name',
		'binding',
		'offset'
	],
	#category : 'WodenEngine-Core-Structures'
}

{ #category : #accessing }
WDCStructureField >> binding [
	^ binding
]

{ #category : #accessing }
WDCStructureField >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
WDCStructureField >> name [
	^ name
]

{ #category : #accessing }
WDCStructureField >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCStructureField >> offset [
	^ offset
]

{ #category : #accessing }
WDCStructureField >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
WDCStructureField >> type [
	^ type
]

{ #category : #accessing }
WDCStructureField >> type: anObject [
	type := anObject
]

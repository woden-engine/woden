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

{ #category : #'as yet unclassified' }
WDCStructureField class >> name: fieldName typeNamed: fieldTypeName binding: fieldBinding [
	^ self new
		name: fieldName;
		type: (WDCStructureFieldType typeNamed: fieldTypeName);
		binding: fieldBinding;
		offset: 0;
		yourself.
]

{ #category : #accessing }
WDCStructureField >> alignment [
	^ type alignment
]

{ #category : #converting }
WDCStructureField >> asWodenVertexStructureDescription [
	^ WDCStructureDescription new
		name: self name;
		size: type size;
		alignment: type alignment;
		fields: { self }
]

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
WDCStructureField >> size [
	^ type size
]

{ #category : #accessing }
WDCStructureField >> type [
	^ type
]

{ #category : #accessing }
WDCStructureField >> type: anObject [
	type := anObject
]

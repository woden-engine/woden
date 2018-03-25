Class {
	#name : #WDCStructureDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'size',
		'alignment',
		'fields'
	],
	#category : 'WodenEngine-Core-Structures'
}

{ #category : #accessing }
WDCStructureDescription >> alignment [
	^ alignment
]

{ #category : #accessing }
WDCStructureDescription >> alignment: anObject [
	alignment := anObject
]

{ #category : #accessing }
WDCStructureDescription >> fields [
	^ fields
]

{ #category : #accessing }
WDCStructureDescription >> fields: anObject [
	fields := anObject
]

{ #category : #initialization }
WDCStructureDescription >> initialize [
	type := #generic.
	size := 0.
	alignment := 1.

]

{ #category : #accessing }
WDCStructureDescription >> name [
	^ name
]

{ #category : #accessing }
WDCStructureDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCStructureDescription >> size [
	^ size
]

{ #category : #accessing }
WDCStructureDescription >> size: anObject [
	size := anObject
]

{ #category : #accessing }
WDCStructureDescription >> type [
	^ type
]

{ #category : #accessing }
WDCStructureDescription >> type: anObject [
	type := anObject
]

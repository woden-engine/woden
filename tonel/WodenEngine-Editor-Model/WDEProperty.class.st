Class {
	#name : #WDEProperty,
	#superclass : #Object,
	#instVars : [
		'object',
		'name',
		'selector'
	],
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEProperty class >> name: propertyName selector: selector [
	^ self new
		name: propertyName;
		selector: selector;
		yourself
]

{ #category : #'as yet unclassified' }
WDEProperty >> formatValue: value [
	^ value asString
]

{ #category : #'as yet unclassified' }
WDEProperty >> getFormattedValue [
	^ self formatValue: self getValue
]

{ #category : #'as yet unclassified' }
WDEProperty >> getValue [
	^ object perform: self readSelector
]

{ #category : #accessing }
WDEProperty >> name [
	^ name
]

{ #category : #accessing }
WDEProperty >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDEProperty >> object [
	^ object
]

{ #category : #accessing }
WDEProperty >> object: anObject [
	object := anObject
]

{ #category : #parsing }
WDEProperty >> parseText: text [
	^ text
]

{ #category : #parsing }
WDEProperty >> parseTextAndSetValue: text [
	| parsedValue |
	parsedValue :=  [
		self parseText: text
	] on: Error do: [ ^ self ].
	
	self setValue: parsedValue.
]

{ #category : #'as yet unclassified' }
WDEProperty >> readSelector [
	^ self selector
]

{ #category : #accessing }
WDEProperty >> selector [
	^ selector
]

{ #category : #accessing }
WDEProperty >> selector: anObject [
	selector := anObject
]

{ #category : #'as yet unclassified' }
WDEProperty >> setValue: newValue [
	^ object perform: self writeSelector with: newValue
]

{ #category : #'as yet unclassified' }
WDEProperty >> writeSelector [
	^ (self selector , ':') asSymbol
]

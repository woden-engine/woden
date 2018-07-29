"
I represent an element int PLY 3D model format.
"
Class {
	#name : #WDIStanfordPLYElement,
	#superclass : #Object,
	#instVars : [
		'name',
		'count',
		'properties',
		'propertyDictionary',
		'values'
	],
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #adding }
WDIStanfordPLYElement >> addProperty: aProperty [
	propertyDictionary at: aProperty name put: aProperty.
	properties add: aProperty.
	aProperty index: properties size.
	
]

{ #category : #accessing }
WDIStanfordPLYElement >> count [
	^ count
]

{ #category : #accessing }
WDIStanfordPLYElement >> count: anObject [
	count := anObject
]

{ #category : #accessing }
WDIStanfordPLYElement >> indexOfProperty: propertyName [
	^ (propertyDictionary at: propertyName) index
]

{ #category : #initialization }
WDIStanfordPLYElement >> initialize [
	super initialize.
	properties := OrderedCollection new.
	propertyDictionary := Dictionary new.
]

{ #category : #accessing }
WDIStanfordPLYElement >> name [
	^ name
]

{ #category : #accessing }
WDIStanfordPLYElement >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDIStanfordPLYElement >> properties [
	^ properties
]

{ #category : #accessing }
WDIStanfordPLYElement >> properties: anObject [
	properties := anObject
]

{ #category : #accessing }
WDIStanfordPLYElement >> propertyDictionary [
	^ propertyDictionary
]

{ #category : #accessing }
WDIStanfordPLYElement >> values [
	^ values
]

{ #category : #accessing }
WDIStanfordPLYElement >> values: anObject [
	values := anObject
]

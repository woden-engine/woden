"
I am a list property. I am used for holding the vertex indices of the faces.
"
Class {
	#name : #WDIStanfordPLYPropertyList,
	#superclass : #WDIStanfordPLYProperty,
	#instVars : [
		'countType',
		'elementType'
	],
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #'as yet unclassified' }
WDIStanfordPLYPropertyList class >> typeName [
	^ #list
]

{ #category : #accessing }
WDIStanfordPLYPropertyList >> countType [
	^ countType
]

{ #category : #accessing }
WDIStanfordPLYPropertyList >> countType: anObject [
	countType := anObject
]

{ #category : #accessing }
WDIStanfordPLYPropertyList >> elementType [
	^ elementType
]

{ #category : #accessing }
WDIStanfordPLYPropertyList >> elementType: anObject [
	elementType := anObject
]

{ #category : #'instance creation' }
WDIStanfordPLYPropertyList >> readFrom: inputStream [
	| count |
	count := countType readFrom: inputStream.
	^ (1 to: count) collect: [ :i | elementType readFrom: inputStream ]
]

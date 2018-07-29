"
I represent a property of an element in a PLY model.
"
Class {
	#name : #WDIStanfordPLYProperty,
	#superclass : #Object,
	#instVars : [
		'name',
		'index'
	],
	#category : #'WodenEngine-Importers-PLY'
}

{ #category : #'as yet unclassified' }
WDIStanfordPLYProperty class >> findPropertyClassFromType: typeName [
	self allSubclassesDo: [ :sc |
		sc typeName = typeName ifTrue: [ ^ sc ]
	].

	self error: 'Failed to find ply property type.'
]

{ #category : #'as yet unclassified' }
WDIStanfordPLYProperty class >> typeName [
	^ nil
]

{ #category : #accessing }
WDIStanfordPLYProperty >> index [
	^ index
]

{ #category : #accessing }
WDIStanfordPLYProperty >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDIStanfordPLYProperty >> name [
	^ name
]

{ #category : #accessing }
WDIStanfordPLYProperty >> name: anObject [
	name := anObject
]

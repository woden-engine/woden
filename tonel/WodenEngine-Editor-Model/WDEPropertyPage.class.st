Class {
	#name : #WDEPropertyPage,
	#superclass : #Object,
	#instVars : [
		'title',
		'properties'
	],
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #initialization }
WDEPropertyPage >> initialize [
	super initialize.
	title := 'Properties'.
	properties := #().
]

{ #category : #accessing }
WDEPropertyPage >> properties [
	^ properties
]

{ #category : #accessing }
WDEPropertyPage >> properties: anObject [
	properties := anObject
]

{ #category : #accessing }
WDEPropertyPage >> title [
	^ title
]

{ #category : #accessing }
WDEPropertyPage >> title: anObject [
	title := anObject
]

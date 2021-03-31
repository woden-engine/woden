Class {
	#name : #WDEEntityPropertyDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'type'
	],
	#category : #'WodenEngine-Editor-Model-EntityDescription'
}

{ #category : #serialization }
WDEEntityPropertyDescription >> loadFromJson: jsonData [
	jsonData isString ifTrue: [
		type := jsonData.
		^ self
	].

	type := jsonData at: 'type' ifAbsent: [ type ].
]

{ #category : #accessing }
WDEEntityPropertyDescription >> name [

	^ name
]

{ #category : #accessing }
WDEEntityPropertyDescription >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDEEntityPropertyDescription >> type [

	^ type
]

{ #category : #accessing }
WDEEntityPropertyDescription >> type: anObject [

	type := anObject
]

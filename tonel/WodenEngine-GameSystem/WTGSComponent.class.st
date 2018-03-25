Class {
	#name : #WTGSComponent,
	#superclass : #WTGSMapNode,
	#instVars : [
		'entity'
	],
	#classVars : [
		'JsonTypeMap'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WTGSComponent class >> initialize [
	super initialize.
	
	JsonTypeMap := Dictionary new.
	self allSubclassesDo: [ :sc |
		sc jsonTypeName ifNotNil: [ JsonTypeMap at: sc jsonTypeName put: sc ]
	]
]

{ #category : #serialization }
WTGSComponent class >> jsonTypeName [
	^ nil
]

{ #category : #serialization }
WTGSComponent class >> loadFromJson: jsonData [
	JsonTypeMap ifEmpty: [ self initialize ].
	^ (JsonTypeMap at: (jsonData at: 'type') ifAbsent: [ ^ nil ]) new loadFromJson: jsonData
]

{ #category : #adding }
WTGSComponent >> addedToEntity: anEntity [
	entity := anEntity
]

{ #category : #adding }
WTGSComponent >> addedToScene: anScene [
]

{ #category : #serialization }
WTGSComponent >> asJsonData [
	^ nil.
]

{ #category : #accessing }
WTGSComponent >> bucket [
	^ #generic
]

{ #category : #accessing }
WTGSComponent >> entity [
	^ entity
]

{ #category : #testing }
WTGSComponent >> isBrush [
	^ false
]

{ #category : #testing }
WTGSComponent >> isSingleton [
	^ false
]

{ #category : #testing }
WTGSComponent >> isUsedInPlayMode [
	^ true
]

{ #category : #accessing }
WTGSComponent >> levelPlayer [
	^ self map levelPlayer
]

{ #category : #accessing }
WTGSComponent >> map [
	^ entity map
]

{ #category : #copying }
WTGSComponent >> playModeCopyWith: copyDictionary [
	^ self copy
]

{ #category : #'as yet unclassified' }
WTGSComponent >> postCopy [
	super postCopy.
	entity := nil
]

{ #category : #'as yet unclassified' }
WTGSComponent >> removeFromEntity [
	entity ifNotNil: [ entity removeComponent: self ]
]

{ #category : #adding }
WTGSComponent >> removeFromMap [
	self removeFromEntity
]

{ #category : #adding }
WTGSComponent >> removedFromEntity: anEntity [
	entity := nil
]

{ #category : #accessing }
WTGSComponent >> scene [
	^ entity scene
]

{ #category : #accessing }
WTGSComponent >> selected: anObject [
	selected := anObject
]

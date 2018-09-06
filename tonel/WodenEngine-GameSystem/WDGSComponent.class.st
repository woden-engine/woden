Class {
	#name : #WDGSComponent,
	#superclass : #WDGSMapNode,
	#instVars : [
		'entity'
	],
	#classVars : [
		'JsonTypeMap'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WDGSComponent class >> initialize [
	super initialize.
	
	JsonTypeMap := Dictionary new.
	self allSubclassesDo: [ :sc |
		sc jsonTypeName ifNotNil: [ JsonTypeMap at: sc jsonTypeName put: sc ]
	]
]

{ #category : #serialization }
WDGSComponent class >> jsonTypeName [
	^ nil
]

{ #category : #serialization }
WDGSComponent class >> loadFromJson: jsonData [
	JsonTypeMap ifEmpty: [ self initialize ].
	^ (JsonTypeMap at: (jsonData at: 'type') ifAbsent: [ ^ nil ]) new loadFromJson: jsonData
]

{ #category : #adding }
WDGSComponent >> addedToEntity: anEntity [
	entity := anEntity
]

{ #category : #adding }
WDGSComponent >> addedToScene: anScene [
]

{ #category : #serialization }
WDGSComponent >> asJsonData [
	^ nil.
]

{ #category : #accessing }
WDGSComponent >> bucket [
	^ #generic
]

{ #category : #accessing }
WDGSComponent >> cameraSceneNode [
	^ entity cameraSceneNode
]

{ #category : #accessing }
WDGSComponent >> entity [
	^ entity
]

{ #category : #testing }
WDGSComponent >> isBrush [
	^ false
]

{ #category : #testing }
WDGSComponent >> isSingleton [
	^ false
]

{ #category : #testing }
WDGSComponent >> isUsedInPlayMode [
	^ true
]

{ #category : #accessing }
WDGSComponent >> levelPlayer [
	^ self map levelPlayer
]

{ #category : #accessing }
WDGSComponent >> map [
	^ entity map
]

{ #category : #copying }
WDGSComponent >> playModeCopyWith: copyDictionary [
	^ self copy
]

{ #category : #'as yet unclassified' }
WDGSComponent >> postCopy [
	super postCopy.
	entity := nil
]

{ #category : #'as yet unclassified' }
WDGSComponent >> removeFromEntity [
	entity ifNotNil: [ entity removeComponent: self ]
]

{ #category : #adding }
WDGSComponent >> removeFromMap [
	self removeFromEntity
]

{ #category : #adding }
WDGSComponent >> removedFromEntity: anEntity [
	entity := nil
]

{ #category : #accessing }
WDGSComponent >> scene [
	^ entity scene
]

{ #category : #accessing }
WDGSComponent >> selected: anObject [
	selected := anObject
]

{ #category : #accessing }
WDGSComponent >> view [
	^ entity view
]

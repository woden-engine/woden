Class {
	#name : #WDGSModel,
	#superclass : #WDGSComponent,
	#instVars : [
		'modelName',
		'model'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSModel class >> jsonTypeName [
	^ 'model'
]

{ #category : #adding }
WDGSModel >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	entity ensureSpatialObject
]

{ #category : #adding }
WDGSModel >> addedToScene: anScene [
	(model isNil and: [ modelName isNotEmpty ]) ifTrue: [
		self loadAndSetModel
	]

]

{ #category : #serialization }
WDGSModel >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'model'.
		'name' . modelName .
	 }
]

{ #category : #'as yet unclassified' }
WDGSModel >> loadAndSetModel [
	| sceneNodeComponent |
	entity ifNil: [ ^ self ].
	self scene ifNil: [ ^ self ].
	sceneNodeComponent := entity sceneNodeComponent.
	sceneNodeComponent ifNil: [ ^ self ].
	model ifNil: [
		self loadModel
	].

	model ifNotNil: [
		sceneNodeComponent node renderable: model.
	]
]

{ #category : #serialization }
WDGSModel >> loadFromJson: jsonData [
	modelName := jsonData at: 'model' ifAbsent: [ '' ]

]

{ #category : #'as yet unclassified' }
WDGSModel >> loadModel [
	| engine |
	engine := self engine.
	model := engine resourceCache loadMesh: modelName
]

{ #category : #accessing }
WDGSModel >> model [
	^ model
]

{ #category : #accessing }
WDGSModel >> model: anObject [
	model := anObject
]

{ #category : #accessing }
WDGSModel >> modelName [
	^ modelName
]

{ #category : #accessing }
WDGSModel >> modelName: anObject [
	modelName := anObject.
	model := nil.
	self loadAndSetModel
]

{ #category : #'as yet unclassified' }
WDGSModel >> postCopy [
	model := nil
]

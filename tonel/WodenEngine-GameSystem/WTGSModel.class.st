Class {
	#name : #WTGSModel,
	#superclass : #WTGSComponent,
	#instVars : [
		'modelName',
		'model'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WTGSModel class >> jsonTypeName [
	^ 'model'
]

{ #category : #adding }
WTGSModel >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	entity ensureSpatialObject
]

{ #category : #adding }
WTGSModel >> addedToScene: anScene [
	(model isNil and: [ modelName isNotEmpty ]) ifTrue: [
		self loadAndSetModel
	]

]

{ #category : #serialization }
WTGSModel >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'model'.
		'name' . modelName .
	 }
]

{ #category : #'as yet unclassified' }
WTGSModel >> loadAndSetModel [
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
WTGSModel >> loadFromJson: jsonData [
	modelName := jsonData at: 'model' ifAbsent: [ '' ]

]

{ #category : #'as yet unclassified' }
WTGSModel >> loadModel [
	| engine |
	engine := self engine.
	model := engine resourceCache loadMesh: modelName
]

{ #category : #accessing }
WTGSModel >> model [
	^ model
]

{ #category : #accessing }
WTGSModel >> model: anObject [
	model := anObject
]

{ #category : #accessing }
WTGSModel >> modelName [
	^ modelName
]

{ #category : #accessing }
WTGSModel >> modelName: anObject [
	modelName := anObject.
	model := nil.
	self loadAndSetModel
]

{ #category : #'as yet unclassified' }
WTGSModel >> postCopy [
	model := nil
]

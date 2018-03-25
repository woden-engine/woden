Class {
	#name : #WTGSSceneNode,
	#superclass : #WTGSComponent,
	#instVars : [
		'node'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WTGSSceneNode class >> fuelIgnoredInstanceVariableNames [
	^ #('node')
]

{ #category : #adding }
WTGSSceneNode >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	self addedToScene: anEntity scene.
	node ifNotNil: [
		anEntity spatialDescription ifNotNil: [ :desc | node transform: desc transform ]
	].

	self updatePointEntityState.
]

{ #category : #adding }
WTGSSceneNode >> addedToScene: anScene [
	(anScene isNil or: [ node scene == anScene ]) ifTrue: [ ^ self ].
	node removeFromScene.
	anScene add: node
]

{ #category : #accessing }
WTGSSceneNode >> bucket [
	^ #sceneNode
]

{ #category : #'as yet unclassified' }
WTGSSceneNode >> isSingleton [
	^ true
]

{ #category : #'as yet unclassified' }
WTGSSceneNode >> isUsedInPlayMode [
	^ false
]

{ #category : #accessing }
WTGSSceneNode >> node [
	^ node
]

{ #category : #accessing }
WTGSSceneNode >> node: anObject [
	node := anObject
]

{ #category : #adding }
WTGSSceneNode >> removedFromScene: anScene [
	node scene == anScene ifTrue: [
		node removeFromScene.
	]
]

{ #category : #adding }
WTGSSceneNode >> updatePointEntityState [
	entity ifNil: [ ^ nil ].
	entity pointEntity: (node isNil or: [ node canBeRendered not ])
]

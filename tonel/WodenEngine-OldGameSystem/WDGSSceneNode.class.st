Class {
	#name : #WDGSSceneNode,
	#superclass : #WDGSComponent,
	#instVars : [
		'node'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSSceneNode class >> fuelIgnoredInstanceVariableNames [
	^ #('node')
]

{ #category : #adding }
WDGSSceneNode >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	self addedToScene: anEntity scene.
	node ifNotNil: [
		anEntity spatialDescription ifNotNil: [ :desc | node transform: desc transform ]
	].

	self updatePointEntityState.
]

{ #category : #adding }
WDGSSceneNode >> addedToScene: anScene [
	(anScene isNil or: [ node scene == anScene ]) ifTrue: [ ^ self ].
	node removeFromScene.
	anScene add: node
]

{ #category : #accessing }
WDGSSceneNode >> bucket [
	^ #sceneNode
]

{ #category : #'as yet unclassified' }
WDGSSceneNode >> isSingleton [
	^ true
]

{ #category : #'as yet unclassified' }
WDGSSceneNode >> isUsedInPlayMode [
	^ false
]

{ #category : #accessing }
WDGSSceneNode >> node [
	^ node
]

{ #category : #accessing }
WDGSSceneNode >> node: anObject [
	node := anObject
]

{ #category : #adding }
WDGSSceneNode >> removedFromScene: anScene [
	node scene == anScene ifTrue: [
		node removeFromScene.
	]
]

{ #category : #adding }
WDGSSceneNode >> updatePointEntityState [
	entity ifNil: [ ^ nil ].
	entity pointEntity: (node isNil or: [ node canBeRendered not ])
]

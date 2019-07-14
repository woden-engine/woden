Class {
	#name : #WDESComponent,
	#superclass : #WDESNode,
	#instVars : [
		'ownerEntity'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #notifications }
WDESComponent >> addedToPhysicsWorld: physicsWorld [
]

{ #category : #notifications }
WDESComponent >> addedToScene: scene [
]

{ #category : #testing }
WDESComponent >> isBehaviorComponent [
	^ false
]

{ #category : #testing }
WDESComponent >> isCameraSceneNodeComponent [
	^ false
]

{ #category : #testing }
WDESComponent >> isCharacterBehaviorComponent [
	^ false
]

{ #category : #testing }
WDESComponent >> isTickingComponent [
	^ false
]

{ #category : #accessing }
WDESComponent >> ownerEntity [
	^ ownerEntity
]

{ #category : #accessing }
WDESComponent >> ownerEntity: anObject [
	ownerEntity := anObject
]

{ #category : #accessing }
WDESComponent >> physicsWorld [
	^ ownerEntity ifNotNil: [ownerEntity physicsWorld]
]

{ #category : #copying }
WDESComponent >> postCopy [
	ownerEntity := nil.
]

{ #category : #notifications }
WDESComponent >> removedFromPhysicsWorld: physicsWorld [
]

{ #category : #notifications }
WDESComponent >> removedFromScene: scene [

]

{ #category : #accessing }
WDESComponent >> scene [
	^ ownerEntity ifNotNil: [ownerEntity scene]
]

{ #category : #accessing }
WDESComponent >> sector [
	^ ownerEntity ifNotNil: [ownerEntity sector]
]

{ #category : #accessing }
WDESComponent >> universe [
	^ ownerEntity ifNotNil: [ownerEntity universe]
]

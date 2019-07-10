Class {
	#name : #WDESSceneComponent,
	#superclass : #WDESComponentWithShape,
	#instVars : [
		'sceneNode'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESSceneComponent >> attachToEntity: anEntity [
	anEntity sceneComponent: self
]

{ #category : #'as yet unclassified' }
WDESSceneComponent >> detachFromEntity: anEntity [
	anEntity sceneComponent: nil
]

{ #category : #accessing }
WDESSceneComponent >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDESSceneComponent >> sceneNode: anObject [
	sceneNode := anObject
]

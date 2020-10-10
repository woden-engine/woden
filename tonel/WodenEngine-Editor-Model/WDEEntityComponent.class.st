Class {
	#name : #WDEEntityComponent,
	#superclass : #WDELevelElement,
	#instVars : [
		'parentEntity'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDEEntityComponent >> boundingBox [
	^ BoxF32 empty
]

{ #category : #accessing }
WDEEntityComponent >> parentEntity [
	^ parentEntity
]

{ #category : #accessing }
WDEEntityComponent >> parentEntity: anObject [
	parentEntity := anObject
]

{ #category : #accessing }
WDEEntityComponent >> treeDisplayName [
	^ self class name , ': ', self name
]

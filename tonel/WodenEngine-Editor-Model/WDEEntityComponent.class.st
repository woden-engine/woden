Class {
	#name : #WDEEntityComponent,
	#superclass : #WDELevelElement,
	#instVars : [
		'parentEntity',
		'changedEventHolder'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDEEntityComponent >> boundingBox [
	^ BoxF32 empty
]

{ #category : #updating }
WDEEntityComponent >> changed [
	changedEventHolder value: changedEventHolder value not
]

{ #category : #initialization }
WDEEntityComponent >> initialize [
	super initialize.
	changedEventHolder := false asValueHolder.
]

{ #category : #testing }
WDEEntityComponent >> isEntityComponent [
	^ true
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
WDEEntityComponent >> sectorLayer [
	^ parentEntity sectorLayer
]

{ #category : #accessing }
WDEEntityComponent >> treeDisplayName [
	^ self class name , ': ', self name
]

{ #category : #initialization }
WDEEntityComponent >> whenChangedDo: aBlock [
	changedEventHolder whenChangedDo: aBlock
]

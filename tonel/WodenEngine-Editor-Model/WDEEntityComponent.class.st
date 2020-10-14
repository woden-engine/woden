Class {
	#name : #WDEEntityComponent,
	#superclass : #WDELevelElement,
	#instVars : [
		'changedEventHolder',
		'parent'
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
WDEEntityComponent >> parent [
	^ parent
]

{ #category : #accessing }
WDEEntityComponent >> parent: aParent [
	parent := aParent
]

{ #category : #initialization }
WDEEntityComponent >> whenChangedDo: aBlock [
	changedEventHolder whenChangedDo: aBlock
]

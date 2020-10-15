Class {
	#name : #WDEEntityComponent,
	#superclass : #WDELevelElement,
	#instVars : [
		'changedEventHolder',
		'parent'
	],
	#category : #'WodenEngine-Editor-Model-Level'
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

{ #category : #copying }
WDEEntityComponent >> postCopy [
	super postCopy.
	parent := nil.
	changedEventHolder := false asValueHolder.
]

{ #category : #initialization }
WDEEntityComponent >> setVisualColor: aColor [
	"Nop by default"
]

{ #category : #initialization }
WDEEntityComponent >> whenChangedDo: aBlock [
	changedEventHolder whenChangedDo: aBlock
]

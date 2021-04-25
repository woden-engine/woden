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
	self raiseChangedEvent
]

{ #category : #'as yet unclassified' }
WDEEntityComponent >> destroyAnnouncers [
	super destroyAnnouncers.
	changedEventHolder destroyAnnouncer.
]

{ #category : #accessing }
WDEEntityComponent >> entity [
	^ parent
]

{ #category : #accessing }
WDEEntityComponent >> entityTransformChanged [
	"By default do nothing."
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

{ #category : #'as yet unclassified' }
WDEEntityComponent >> makeSimilarForEntity: newEntity [
	^ self copy
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

{ #category : #updating }
WDEEntityComponent >> raiseChangedEvent [
	changedEventHolder value: changedEventHolder value not
]

{ #category : #'as yet unclassified' }
WDEEntityComponent >> sectorDimensionalityChanged [
	self changed.
	super sectorDimensionalityChanged.
]

{ #category : #'as yet unclassified' }
WDEEntityComponent >> sectorLayerThicknessChanged [
	self changed.
	super sectorLayerThicknessChanged.
]

{ #category : #initialization }
WDEEntityComponent >> whenChangedDo: aBlock [
	changedEventHolder whenChangedDo: aBlock
]

{ #category : #initialization }
WDEEntityComponent >> whenChangedDoNow: aBlock [
	self whenChangedDo: aBlock.
	aBlock value
]

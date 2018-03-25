Class {
	#name : #WTRenderable,
	#superclass : #Object,
	#instVars : [
		'boundingBox',
		'modificationCount'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTRenderable >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WTRenderable >> boundingBox: anObject [
	boundingBox := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #initialization }
WTRenderable >> initialize [
	super initialize.
	modificationCount := 0.
	boundingBox := WMBox3DF empty.
]

{ #category : #accessing }
WTRenderable >> renderModificationCountFor: mode submode: submode [
	^ modificationCount
]

{ #category : #rendering }
WTRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WTRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

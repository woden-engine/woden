"
I represent an abstract renderable. An abstract renderable is an object that is rendered in a scene.
"
Class {
	#name : #WDCRenderable,
	#superclass : #Object,
	#instVars : [
		'boundingBox',
		'modificationCount'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCRenderable >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCRenderable >> boundingBox: anObject [
	boundingBox := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #initialization }
WDCRenderable >> initialize [
	super initialize.
	modificationCount := 0.
	boundingBox := WMBox3DF empty.
]

{ #category : #accessing }
WDCRenderable >> renderModificationCountFor: mode submode: submode [
	^ modificationCount
]

{ #category : #rendering }
WDCRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

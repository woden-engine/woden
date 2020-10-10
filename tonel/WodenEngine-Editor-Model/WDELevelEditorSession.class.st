Class {
	#name : #WDELevelEditorSession,
	#superclass : #Object,
	#instVars : [
		'level'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #initialization }
WDELevelEditorSession >> initialize [
	super initialize.
	level := nil asValueHolder.
]

{ #category : #accessing }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : #accessing }
WDELevelEditorSession >> level: anObject [
	level value: anObject
]

{ #category : #enumerating }
WDELevelEditorSession >> whenLevelChangedDo: aBlock [
	level whenChangedDo: aBlock
]

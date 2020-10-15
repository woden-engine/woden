Class {
	#name : #WDELevelElementTemplate,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #accessing }
WDELevelElementTemplate >> children [
	^ #()
]

{ #category : #accessing }
WDELevelElementTemplate >> name [
	^ name
]

{ #category : #accessing }
WDELevelElementTemplate >> name: anObject [
	name := anObject
]

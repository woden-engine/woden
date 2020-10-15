Class {
	#name : #WDELevelElementEntityTemplate,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'prototype'
	],
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype [
	^ prototype
]

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype: anObject [
	prototype := anObject
]

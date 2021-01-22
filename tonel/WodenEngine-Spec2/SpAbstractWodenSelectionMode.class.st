Class {
	#name : #SpAbstractWodenSelectionMode,
	#superclass : #Object,
	#traits : 'SpTObservable',
	#classTraits : 'SpTObservable classTrait',
	#instVars : [
		'widget'
	],
	#category : #'WodenEngine-Spec2'
}

{ #category : #'instance creation' }
SpAbstractWodenSelectionMode class >> on: aWidget [

	^ self new
		widget: aWidget;
		yourself
]

{ #category : #accessing }
SpAbstractWodenSelectionMode >> transmission [
	self subclassResponsibility
]

{ #category : #accessing }
SpAbstractWodenSelectionMode >> widget [

	^ widget
]

{ #category : #accessing }
SpAbstractWodenSelectionMode >> widget: anObject [

	widget := anObject
]

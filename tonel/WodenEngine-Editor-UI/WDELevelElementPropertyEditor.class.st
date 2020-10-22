Class {
	#name : #WDELevelElementPropertyEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'propertiesNotebook'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelElementPropertyEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #propertiesNotebook;
		yourself
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> initializePresenters [
	propertiesNotebook := self newNotebook.
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> modelChanged [
	propertiesNotebook removeAll.
	self propertyPages do: [ :each |
		propertiesNotebook addPageTitle: each title provider: [ WDEPropertyPagePresenter on: each].
	].

	propertiesNotebook pages ifNotEmpty: [
		propertiesNotebook selectPageIndex: 1
	]
]

{ #category : #accessing }
WDELevelElementPropertyEditor >> propertiesNotebook [
	^ propertiesNotebook
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> propertyPages [
	^ (self model
		ifNil: [#()]
		ifNotNil: [ :model | model propertyPages ])
		sorted: [ :a :b | a title <= b title ]
]

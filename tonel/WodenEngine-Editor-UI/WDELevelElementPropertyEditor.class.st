Class {
	#name : #WDELevelElementPropertyEditor,
	#superclass : #SpPresenterWithModel,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelElementPropertyEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		beNotHomogeneous;
		yourself
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> modelChanged [
	| newLayout |
	newLayout := self defaultSpec.
	self propertyPages do: [ :each |
		newLayout add: (WDEPropertyPagePresenter on: each)
	].
	self layout: newLayout
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> propertyPages [
	^ (self model
		ifNil: [#()]
		ifNotNil: [ :model | model propertyPages ])
		sorted: [ :a :b | a title <= b title ]
]

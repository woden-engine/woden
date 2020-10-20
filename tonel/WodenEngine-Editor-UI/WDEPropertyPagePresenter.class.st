Class {
	#name : #WDEPropertyPagePresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'title'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDEPropertyPagePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		beNotHomogeneous;
		add: #title expand: false;
		yourself
]

{ #category : #initialization }
WDEPropertyPagePresenter >> initializePresenters [
	title := self newLabel.

]

{ #category : #initialization }
WDEPropertyPagePresenter >> modelChanged [
	| newLayout grid |
	newLayout := self class defaultSpec.
	title label: self model title.
	grid := SpGridLayout new
		beColumnHomogeneous;
		beRowNotHomogeneous;
		borderWidth: 0;
		yourself.
	self model properties doWithIndex: [ :each :row |
		grid
			add: (self newLabel label: each name) at: 1@row;
			add: (each buildSpecPresenter) at: 2@row
	].
	newLayout add: grid.
	self layout: newLayout
]

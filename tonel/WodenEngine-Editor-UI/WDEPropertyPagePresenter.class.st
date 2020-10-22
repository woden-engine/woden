Class {
	#name : #WDEPropertyPagePresenter,
	#superclass : #SpPresenterWithModel,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDEPropertyPagePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		beNotHomogeneous;
		yourself
]

{ #category : #initialization }
WDEPropertyPagePresenter >> modelChanged [
	| grid |
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
	self layout: grid
]

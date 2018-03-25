Class {
	#name : #RWBuilder,
	#superclass : #RWObject,
	#instVars : [
		'view',
		'shapeBuilder',
		'metricNormalizer'
	],
	#category : 'Woden2-Roassal-Builder'
}

{ #category : #'as yet unclassified' }
RWBuilder >> addElementOn: anObject [
	| element |
	element := self elementOn: anObject.
	view add: element.
	^ element
]

{ #category : #'as yet unclassified' }
RWBuilder >> build [
	"Simply render the view"
	self renderIn: view.
	^ view
]

{ #category : #'as yet unclassified' }
RWBuilder >> cleanView [
	view edges copy do: #remove.
	view elements copy do: #remove.
]

{ #category : #'as yet unclassified' }
RWBuilder >> createView [
	^ RWView new
]

{ #category : #'as yet unclassified' }
RWBuilder >> initialize [
	super initialize.
	view := self createView.
]

{ #category : #'as yet unclassified' }
RWBuilder >> renderIn: aView [
	"You may want to override this method to fill the view"
]

{ #category : #'as yet unclassified' }
RWBuilder >> view [
	^ view
]

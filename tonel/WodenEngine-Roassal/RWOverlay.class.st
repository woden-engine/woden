Class {
	#name : #RWOverlay,
	#superclass : #RWObject,
	#instVars : [
		'view'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #internal }
RWOverlay >> addedIn: aView [
	view := aView
]

{ #category : #rendering }
RWOverlay >> drawOnBabylonCanvas: canvas [
	"This is the place for drawing the overlay."
]

{ #category : #removing }
RWOverlay >> remove [
	view removeOverlay: self.
	view := nil.
]

{ #category : #accessing }
RWOverlay >> view [
	^ view
]

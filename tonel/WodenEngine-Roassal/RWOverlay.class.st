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
RWOverlay >> buildUISceneGraphWith: builder [
	^ builder null
]

{ #category : #rendering }
RWOverlay >> drawOnScaledBabylonCanvas: canvas [
	"This is the place for drawing the overlay with a scaled logical height."
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

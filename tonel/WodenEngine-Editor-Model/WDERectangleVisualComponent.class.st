Class {
	#name : #WDERectangleVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'rectangle',
		'color'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDERectangleVisualComponent >> accept: visitor [
	^ visitor visitRectangleVisualComponent: self
]

{ #category : #accessing }
WDERectangleVisualComponent >> boundingRectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleVisualComponent >> color [
	^ color
]

{ #category : #accessing }
WDERectangleVisualComponent >> color: anObject [
	color := anObject.
	self changed.
]

{ #category : #initialization }
WDERectangleVisualComponent >> initialize [
	super initialize.
	color := Float32x4 ones.
	rectangle := RectangleF32 unitRectangle.
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle: anObject [
	rectangle := anObject.
	self changed.
]

{ #category : #memento }
WDERectangleVisualComponent >> restoreTransformStateMemento: memento [
	self rectangle: memento
]

{ #category : #memento }
WDERectangleVisualComponent >> transformStateMemento [
	^ self rectangle
]

{ #category : #transforms }
WDERectangleVisualComponent >> transformWith: transform [
	self rectangle: (self rectangle asBox transformedWith: transform) asRectangleXY.

]

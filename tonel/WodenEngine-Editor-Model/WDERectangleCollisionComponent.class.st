Class {
	#name : #WDERectangleCollisionComponent,
	#superclass : #WDECollisionComponent2D,
	#instVars : [
		'rectangle'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDERectangleCollisionComponent >> accept: visitor [
	^ visitor visitRectangleCollisionComponent: self
]

{ #category : #initialization }
WDERectangleCollisionComponent >> initialize [
	super initialize.
	rectangle := RectangleF32 unitRectangle.
]

{ #category : #accessing }
WDERectangleCollisionComponent >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleCollisionComponent >> rectangle: anObject [
	rectangle := anObject.
	self changed.
]

{ #category : #memento }
WDERectangleCollisionComponent >> restoreTransformStateMemento: memento [
	self rectangle: memento
]

{ #category : #memento }
WDERectangleCollisionComponent >> transformStateMemento [
	^ self rectangle
]

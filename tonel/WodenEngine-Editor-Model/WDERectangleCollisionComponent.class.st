Class {
	#name : #WDERectangleCollisionComponent,
	#superclass : #WDECollisionComponent2D,
	#instVars : [
		'rectangle'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDERectangleCollisionComponent >> accept: visitor [
	^ visitor visitRectangleCollisionComponent: self
]

{ #category : #serialization }
WDERectangleCollisionComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#rectangle . rectangle encodeForJSON.
	}
]

{ #category : #initialization }
WDERectangleCollisionComponent >> initialize [
	super initialize.
	rectangle := RectangleF32 unitRectangle.
]

{ #category : #testing }
WDERectangleCollisionComponent >> isRectangleCollisionComponent [
	^ true
]

{ #category : #serialization }
WDERectangleCollisionComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	rectangle := RectangleF32 loadFromJson: (jsonData at: 'rectangle').
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

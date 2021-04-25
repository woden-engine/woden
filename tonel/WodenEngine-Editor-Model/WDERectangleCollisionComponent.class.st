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
WDERectangleCollisionComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	rectangle := RectangleF32 loadFromJson: (jsonData at: 'rectangle').
]

{ #category : #'as yet unclassified' }
WDERectangleCollisionComponent >> makeSimilarForEntity: newEntity [
	| entityBox |
	entityBox := newEntity localBoundingBox.
	
	^ self copy box: (RectangleF32 min: entityBox min xy max: entityBox max xy); yourself
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

{ #category : #transforms }
WDERectangleCollisionComponent >> transformWith: transform [
	self rectangle: (self rectangle asBox transformedWith: transform) asRectangleXY.

]

Class {
	#name : #WDERectangleVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'rectangle',
		'color'
	],
	#category : #'WodenEngine-Editor-Model-Level'
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
	color := anObject asFloat32x4.
	self changed.
]

{ #category : #serialization }
WDERectangleVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#rectangle . rectangle encodeForJSON.
		#color . color encodeForJSON.
	}
]

{ #category : #initialization }
WDERectangleVisualComponent >> initialize [
	super initialize.
	color := Float32x4 ones.
	rectangle := RectangleF32 unitRectangle.
]

{ #category : #testing }
WDERectangleVisualComponent >> isRectangleVisualComponent [
	^ true
]

{ #category : #serialization }
WDERectangleVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	rectangle := RectangleF32 loadFromJson: (jsonData at: 'rectangle').
	jsonData at: 'color' ifPresent: [ :data |
		color := Float32x4 loadFromJson: data
	].

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

{ #category : #initialization }
WDERectangleVisualComponent >> setVisualColor: aColor [
	self color: aColor
]

{ #category : #memento }
WDERectangleVisualComponent >> transformStateMemento [
	^ self rectangle
]

{ #category : #transforms }
WDERectangleVisualComponent >> transformWith: transform [
	self rectangle: (self rectangle asBox transformedWith: transform) asRectangleXY.

]

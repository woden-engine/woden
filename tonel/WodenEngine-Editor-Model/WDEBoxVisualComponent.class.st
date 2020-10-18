Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'box',
		'color'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEBoxVisualComponent >> accept: visitor [
	^ visitor visitBoxVisualComponent: self
]

{ #category : #accessing }
WDEBoxVisualComponent >> boundingBox [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box: anObject [
	box := anObject.
	self changed.
]

{ #category : #accessing }
WDEBoxVisualComponent >> color [
	^ color
]

{ #category : #accessing }
WDEBoxVisualComponent >> color: anObject [
	color := anObject asFloat32x4.
	self changed.
]

{ #category : #serialization }
WDEBoxVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#box . box encodeForJSON.
		#color . color encodeForJSON.
	}
]

{ #category : #initialization }
WDEBoxVisualComponent >> initialize [
	super initialize.
	color := Float32x4 ones.
	box := BoxF32 unitBox.
]

{ #category : #testing }
WDEBoxVisualComponent >> isBoxVisualComponent [
	^ true
]

{ #category : #serialization }
WDEBoxVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	box := BoxF32 loadFromJson: (jsonData at: 'box').
	jsonData at: 'color' ifPresent: [ :data |
		color := Float32x4 loadFromJson: data
	].

]

{ #category : #memento }
WDEBoxVisualComponent >> restoreTransformStateMemento: memento [
	self box: memento
]

{ #category : #initialization }
WDEBoxVisualComponent >> setVisualColor: aColor [
	self color: aColor
]

{ #category : #memento }
WDEBoxVisualComponent >> transformStateMemento [
	^ self box
]

{ #category : #transforms }
WDEBoxVisualComponent >> transformWith: transform [
	self box: (self box transformedWith: transform)
]

Class {
	#name : #WDEVisualComponent2D,
	#superclass : #WDEVisualComponent,
	#instVars : [
		'boundingBox'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #testing }
WDEVisualComponent2D class >> isAbstract [
	^ self == WDEVisualComponent2D
]

{ #category : #accessing }
WDEVisualComponent2D >> boundingBox [
	^ boundingBox ifNil: [ boundingBox :=
			BoxF32
				min: (Float32x3 xy: self boundingRectangle min z: self sectorLayer defaultMinZ)
				max: (Float32x3 xy: self boundingRectangle max z: self sectorLayer defaultMaxZ)
		]
]

{ #category : #accessing }
WDEVisualComponent2D >> boundingRectangle [
	^ self subclassResponsibility
]

{ #category : #updating }
WDEVisualComponent2D >> changed [
	boundingBox := nil.
	super changed.
]

{ #category : #testing }
WDEVisualComponent2D >> isVisualComponent2D [
	^ true
]

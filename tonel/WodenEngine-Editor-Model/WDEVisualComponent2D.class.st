Class {
	#name : #WDEVisualComponent2D,
	#superclass : #WDEVisualComponent,
	#instVars : [
		'boundingBox'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #testing }
WDEVisualComponent2D class >> isAbstract [
	^ self == WDEVisualComponent2D
]

{ #category : #accessing }
WDEVisualComponent2D >> boundingBox [
	^ boundingBox ifNil: [
		| halfThickness |
		halfThickness := self sectorLayer layerHalfThickness.
		boundingBox :=
		BoxF32
			min: (Float32x3 xy: self boundingRectangle min z: halfThickness negated)
			max: (Float32x3 xy: self boundingRectangle max z: halfThickness)
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

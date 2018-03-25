Class {
	#name : #WTAthensGradientPaint,
	#superclass : #AthensAbstractPaint,
	#instVars : [
		'colorRamp'
	],
	#category : 'Woden2-Athens-Paint'
}

{ #category : #converting }
WTAthensGradientPaint >> asAthensPaintOn: aCanvas [
	^ self
]

{ #category : #accessing }
WTAthensGradientPaint >> colorRamp [
	^ colorRamp collect: [ :el | el edge -> el color asColor ]
]

{ #category : #accessing }
WTAthensGradientPaint >> colorRamp: aRamp [
	colorRamp removeAll.
	aRamp do: [ :assoc |
		colorRamp add: (WTColorRampEntry new
			edge: assoc key asFloat;
			color: assoc value asWMVector4F;
			yourself)
	]
]

{ #category : #initialization }
WTAthensGradientPaint >> initialize [
	super initialize.
	colorRamp := SLVMNativeOrderedCollection for: WTColorRampEntry.
]

{ #category : #accessing }
WTAthensGradientPaint >> rawColorRamp [
	^ colorRamp
]

"
I am a renderable with different alternatives.
"
Class {
	#name : #WDCRenderableWithAlternatives,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'alternatives'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #adding }
WDCRenderableWithAlternatives >> addAlternative: alternative submode: submode [
	^ alternatives at: submode put: alternative
]

{ #category : #adding }
WDCRenderableWithAlternatives >> addDefaultAlternative: alternative [
	^ self addAlternative: alternative submode: #default
]

{ #category : #'as yet unclassified' }
WDCRenderableWithAlternatives >> alternativeForSubmode: submode [
	^ alternatives at: submode ifAbsent: [ self defaultAlternative ]
]

{ #category : #'as yet unclassified' }
WDCRenderableWithAlternatives >> defaultAlternative [
	^ alternatives at: #default ifAbsentPut: [ WDCNullRenderable new ]
]

{ #category : #initialization }
WDCRenderableWithAlternatives >> initialize [
	super initialize.
	alternatives := Dictionary new.
]

{ #category : #copying }
WDCRenderableWithAlternatives >> postCopy [
	super postCopy.
	alternatives := alternatives copy.
]

{ #category : #rendering }
WDCRenderableWithAlternatives >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	| alternative |
	alternative := self alternativeForSubmode: stateTracker submode.
	^ alternative renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]

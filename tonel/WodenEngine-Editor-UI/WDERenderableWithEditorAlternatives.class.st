Class {
	#name : #WDERenderableWithEditorAlternatives,
	#superclass : #WDCImmutableRenderable,
	#instVars : [
		'wireFrameRenderable',
		'colorRenderable',
		'shadedRenderable'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> colorRenderable [
	^ colorRenderable ifNil: [ shadedRenderable ]
]

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> colorRenderable: anObject [

	colorRenderable := anObject
]

{ #category : #rendering }
WDERenderableWithEditorAlternatives >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	| submode |
	submode := stateTracker sceneSubMode.
	submode isWireFrame ifTrue: [
		^ self wireFrameRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
	].

	submode isColorMode ifTrue: [
		^ self colorRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex		
	].

	^ self shadedRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> shadedRenderable [

	^ shadedRenderable
]

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> shadedRenderable: aRenderable [
	shadedRenderable := aRenderable.
	self
		boundingBox: aRenderable boundingBox;
		renderPriority: aRenderable renderPriority;
		blendingMode: aRenderable blendingMode;
		depthWriteMask: aRenderable depthWriteMask;
		depthTestingEnabled: aRenderable depthTestingEnabled;
		subRenderMode: aRenderable subRenderMode
]

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> wireFrameRenderable [

	^ wireFrameRenderable ifNil: [ colorRenderable ifNil: [ shadedRenderable ] ]
]

{ #category : #accessing }
WDERenderableWithEditorAlternatives >> wireFrameRenderable: anObject [

	wireFrameRenderable := anObject
]

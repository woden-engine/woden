Class {
	#name : #WDCAnimatedRenderable,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'animationState',
		'engine'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCAnimatedRenderable >> animationState [
	^ animationState ifNil: [ animationState := self createAnimationState ]
]

{ #category : #accessing }
WDCAnimatedRenderable >> createAnimationState [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAnimatedRenderable >> engine: newEngine [
	engine := newEngine.
	self animationState engine: newEngine
]

{ #category : #copying }
WDCAnimatedRenderable >> postCopy [
	super postCopy.
	animationState := animationState copy.
]

{ #category : #'renderable state' }
WDCAnimatedRenderable >> updateCommonGpuStateForFrame: frameIndex [
	self animationState updateCommonGpuStateForFrame: frameIndex
]

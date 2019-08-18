Class {
	#name : #WDCDeformableRenderable,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'engine',
		'deformationState'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCDeformableRenderable >> createDeformationState [
	self subclassResponsibility
]

{ #category : #accessing }
WDCDeformableRenderable >> deformationState [
	^ deformationState ifNil: [ deformationState := self createDeformationState ]
]

{ #category : #accessing }
WDCDeformableRenderable >> deformationState: aDeformationState [
	deformationState := aDeformationState
]

{ #category : #'as yet unclassified' }
WDCDeformableRenderable >> engine: newEngine [
	engine := newEngine.
	self deformationState engine: newEngine
]

{ #category : #copying }
WDCDeformableRenderable >> postCopy [
	super postCopy.
	deformationState := deformationState copy.
]

{ #category : #enumerating }
WDCDeformableRenderable >> precacheResources [
	super precacheResources.
	deformationState precacheResources.
]

{ #category : #'renderable state' }
WDCDeformableRenderable >> updateCommonGpuStateForFrame: frameIndex [
	self deformationState updateCommonGpuStateForFrame: frameIndex
]

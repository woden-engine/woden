"
I am a rendering process. I am used to handle the explicit double and triple buffering, to solve synchronization issues.
"
Class {
	#name : #WDCRenderingProcess,
	#superclass : #Object,
	#traits : 'TWDCRenderingDependencyGraphNode',
	#classTraits : 'TWDCRenderingDependencyGraphNode classTrait',
	#instVars : [
		'suspended'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCRenderingProcess >> continousUpdating [
	^ false
]

{ #category : #initialization }
WDCRenderingProcess >> initialize [
	super initialize.
	suspended := false.
]

{ #category : #accessing }
WDCRenderingProcess >> name [
	^ self class name
]

{ #category : #testing }
WDCRenderingProcess >> needsToRender [
	^ true
]

{ #category : #'rendering process stages' }
WDCRenderingProcess >> processEvents [
]

{ #category : #path }
WDCRenderingProcess >> sessionChanged [
]

{ #category : #accessing }
WDCRenderingProcess >> suspend [
	suspended := true
]

{ #category : #accessing }
WDCRenderingProcess >> suspended [
	^ suspended
]

{ #category : #accessing }
WDCRenderingProcess >> suspended: anObject [
	suspended := anObject
]

{ #category : #accessing }
WDCRenderingProcess >> unsuspend [
	suspended := false
]

{ #category : #'rendering process stages' }
WDCRenderingProcess >> updateForDeltaMicroseconds: delta [
]

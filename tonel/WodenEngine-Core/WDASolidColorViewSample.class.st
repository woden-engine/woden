"
I am a sample Woden application with a single solid color view.

| model |
model := WDAModel new.
model openInMorphicWith: WDASolidColorViewSample.
"
Class {
	#name : #WDASolidColorViewSample,
	#superclass : #WDAViewWithStateTracker,
	#instVars : [
		'color'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #accessing }
WDASolidColorViewSample >> color [
	^ color
]

{ #category : #accessing }
WDASolidColorViewSample >> color: anObject [
	color := anObject
]

{ #category : #initialization }
WDASolidColorViewSample >> initialize [
	super initialize.
	color := Color blue
]

{ #category : #'rendering process stages' }
WDASolidColorViewSample >> setupMainRenderpass [
	super setupMainRenderpass.
	renderPass setColorClearValue: 0 value: color asFloat32x4 asAGPUColor4f.
]

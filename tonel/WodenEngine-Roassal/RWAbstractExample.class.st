Class {
	#name : #RWAbstractExample,
	#superclass : #RWObject,
	#category : 'WodenEngine-Roassal-Examples'
}

{ #category : #gtinspector }
RWAbstractExample class >> gtExamplesProvider [
	^ self new
]

{ #category : #gtinspector }
RWAbstractExample class >> gtInspectorPreviewIn: composite [
	<gtInspectorPresentationOrder: 4>
	<gtInspectorTag: #examples>
	^ self new gtInspectorPreviewIn: composite
]

{ #category : #accessing }
RWAbstractExample >> label [
	^ 'fill please'
]

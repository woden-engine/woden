Class {
	#name : #RWCylinderLine,
	#superclass : #RWLine,
	#instVars : [
		'slices',
		'radius',
		'capStart',
		'capEnd'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWCylinderLine >> capEnd [
	^ capEnd
]

{ #category : #accessing }
RWCylinderLine >> capEnd: anObject [
	capEnd := anObject
]

{ #category : #accessing }
RWCylinderLine >> capStart [
	^ capStart
]

{ #category : #accessing }
RWCylinderLine >> capStart: anObject [
	capStart := anObject
]

{ #category : #hooks }
RWCylinderLine >> createComponentRenderableFor: edge [
	| component |
	component := WDCCylinderLineMeshComponent new.
	self updateMeshComponent: component forElement: edge.
	^ component
]

{ #category : #initialization }
RWCylinderLine >> initialize [
	super initialize.
	
	radius := 0.1.
	slices := 16.
	capStart := true.
	capEnd := true.
]

{ #category : #accessing }
RWCylinderLine >> radius [
	^ radius
]

{ #category : #accessing }
RWCylinderLine >> radius: anObject [
	radius := anObject
]

{ #category : #accessing }
RWCylinderLine >> slices [
	^ slices
]

{ #category : #accessing }
RWCylinderLine >> slices: anObject [
	slices := anObject
]

{ #category : #hooks }
RWCylinderLine >> updateMeshComponent: meshComponent forElement: edge [
	meshComponent
		slices: slices;
		radius: radius;
		capStart: capStart;
		capEnd: capEnd;
		startPoint: edge fromPosition;
		endPoint: edge toPosition
		
]

Class {
	#name : #WDEModelPaletteElement,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'model',
		'entityPrototype'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'single color materials' }
WDEModelPaletteElement class >> referencePath: path [
	^ self new 
		model: (WDEFileReferenceModel new
			path: path;
			yourself);
		yourself
]

{ #category : #accessing }
WDEModelPaletteElement >> entityPrototype [
	^ entityPrototype ifNil: [ entityPrototype := WDEEntity new makeEntity3D
		className: 'Model';
		localBoundingBox: BoxF32 unitBox;
		addComponent: model copy;
		yourself
 	]
]

{ #category : #'as yet unclassified' }
WDEModelPaletteElement >> instantiateInSectorLayer: sectorLayer placingInPoint: point session: levelSession [
	| oldSelection element |
	oldSelection := levelSession selection.
	levelSession
		doWith: [
			element := sectorLayer instanceEntityPrototype: self entityPrototype andPlaceAt: point.
			levelSession selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			levelSession selection: oldSelection.
			element removeFromParent.
		].

	Transcript show: 'TODO: place model in point '; show: point; cr.
]

{ #category : #testing }
WDEModelPaletteElement >> isPointElementTemplate [
	^ true
]

{ #category : #accessing }
WDEModelPaletteElement >> model [

	^ model
]

{ #category : #accessing }
WDEModelPaletteElement >> model: anObject [

	model := anObject
]

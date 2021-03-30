Class {
	#name : #WDEMaterialPaletteElement,
	#superclass : #WDEPaletteElement,
	#instVars : [
		'material',
		'thumbnail'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> dielectricBaseColor: albedo roughness: roughness [
	^ self new 
		material: (WDEMetallicRoughnessMaterial new
			baseColor: albedo;
			roughnessFactor: roughness;
			metallicFactor: 0.0;
			yourself);
		yourself
]

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> metallicBaseColor: albedo roughness: roughness [
	^ self new 
		material: (WDEMetallicRoughnessMaterial new
			baseColor: albedo;
			roughnessFactor: roughness;
			metallicFactor: 1.0;
			yourself);
		yourself
]

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> referencePath: path [
	^ self new 
		material: (WDEFileReferenceMaterial new
			path: path;
			yourself);
		yourself
]

{ #category : #'as yet unclassified' }
WDEMaterialPaletteElement >> activateInLevelSession: levelSession [
	| oldSelection memento |
	oldSelection := levelSession selection.
	oldSelection selectedItems ifEmpty: [ ^ self ].
	
	memento := oldSelection materialStateMemento.
	levelSession doWith: [
		levelSession selection selectedItems do: [ :each |
			each setMaterial: material
		]
	] undoWith: [
		oldSelection restoreMaterialStateMemento: memento
	].


]

{ #category : #accessing }
WDEMaterialPaletteElement >> material [

	^ material
]

{ #category : #accessing }
WDEMaterialPaletteElement >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDEMaterialPaletteElement >> thumbnailFor: levelEditorSession engine: engine [
	^ thumbnail ifNil: [ thumbnail := material ifNotNil: [ material makeThumbnailForSession: levelEditorSession engine: engine ] ]
]

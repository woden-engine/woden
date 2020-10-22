Class {
	#name : #WDEMaterialPaletteElement,
	#superclass : #WDEPaletteElement,
	#instVars : [
		'albedo',
		'metallic',
		'thumbnail'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDEMaterialPaletteElement class >> dielectricAlbedo: albedo [
	^ self new albedo: albedo asFloat32x4; metallic: 0.0; yourself
]

{ #category : #'as yet unclassified' }
WDEMaterialPaletteElement class >> metallicAlbedo: albedo [
	^ self new albedo: albedo asFloat32x4; metallic: 1.0; yourself
]

{ #category : #'as yet unclassified' }
WDEMaterialPaletteElement >> activateInLevelSession: levelSession [
	self flag: 'TODO: Set this in an edition operation.'.
	self flag: 'TODO: Change the actual material.'.
	levelSession selection selectedItems do: [ :each |
		each setVisualColor: albedo
	]
]

{ #category : #accessing }
WDEMaterialPaletteElement >> albedo [
	^ albedo
]

{ #category : #accessing }
WDEMaterialPaletteElement >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDEMaterialPaletteElement >> metallic [
	^ metallic
]

{ #category : #accessing }
WDEMaterialPaletteElement >> metallic: anObject [
	metallic := anObject
]

{ #category : #accessing }
WDEMaterialPaletteElement >> thumbnail [
	^ thumbnail ifNil: [ thumbnail := (Form extent: 16@16 depth: 32) fillColor: albedo asColor ]
]

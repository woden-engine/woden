Class {
	#name : #WDEGenericMaterialPaletteProvider,
	#superclass : #WDEMaterialPaletteProvider,
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDEGenericMaterialPaletteProvider >> basicDielectrics [
	| category |
	category :=  WDEPaletteCategory new
		name: 'Basic Dielectric'.
		
	{	
		'Empty' . WDEMaterialPaletteElement new.
		'White' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.8 g: 0.8 b: 0.8) roughness: 0.6.
		'Red' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.8 g: 0.05 b: 0.05) roughness: 0.6.
		'Green' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.05 g: 0.8 b: 0.0) roughness: 0.6.
		'Blue' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.05 g: 0.05 b: 0.8) roughness: 0.6.
		'Yellow' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.8 g: 0.8 b: 0.05) roughness: 0.6.
		'Cyan' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.05 g: 0.8 b: 0.8) roughness: 0.6.
		'Magenta' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.05 g: 0.05 b: 0.8) roughness: 0.6.
		'Black' . WDEMaterialPaletteElement dielectricBaseColor: (Color r: 0.05 g: 0.05 b: 0.05) roughness: 0.6.
	} pairsDo: [ :templateName :element |
		element name: templateName.
		category addTemplate: element
	].
	^ category
]

{ #category : #'as yet unclassified' }
WDEGenericMaterialPaletteProvider >> basicMetals [
	| category |
	category :=  WDEPaletteCategory new
		name: 'Basic Metals'.
		
	{
		"Linear RGB values from: https://seblagarde.wordpress.com/2011/08/17/feeding-a-physical-based-lighting-mode/"
		'Aluminium' . WDEMaterialPaletteElement metallicBaseColor: (Float32x4 x: 0.913183 y: 0.921494 z: 0.924524 w: 1) roughness: 0.2.
		'Gold' . WDEMaterialPaletteElement metallicBaseColor: (Float32x4 x: 1 y: 0.765557 z: 0.336057 w: 1) roughness: 0.2.
	} pairsDo: [ :templateName :element |
		element name: templateName.
		category addTemplate: element
	].
	^ category
]

{ #category : #'as yet unclassified' }
WDEGenericMaterialPaletteProvider >> topLevelPaletteCategories [
	^ {
		self basicDielectrics.
		self basicMetals.
	}
]

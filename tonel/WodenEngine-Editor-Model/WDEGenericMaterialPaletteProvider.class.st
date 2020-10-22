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
		'Default' . WDEMaterialPaletteElement metallicAlbedo: (Color r: 0.8 g: 0.8 b: 0.8).
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
		'Aluminium' . WDEMaterialPaletteElement metallicAlbedo: (Float32x4 x: 0.913183 y: 0.921494 z: 0.924524 w: 1).
		'Gold' . WDEMaterialPaletteElement metallicAlbedo: (Float32x4 x: 1 y: 0.765557 z: 0.336057 w: 1).
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

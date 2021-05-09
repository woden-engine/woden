Class {
	#name : #WDELevelGenericElementTemplateProvider,
	#superclass : #WDELevelElementTemplateProvider,
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> bspGeometryCategory [
	^ self makeCategoryNamed: 'BSP Geometry' withElements: {
		'Box' . WDEEntity bspBoxPrototype.
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> extrudedGeometry2DCategory [
	^ self makeCategoryNamed: 'Extruded Geometry 2D' withElements: {
		'Rectangle' . WDEEntity extrudedRectanglePrototype.
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> lightsCategory [
	^ self makeCategoryNamed: 'Light Sources' withElements: {
		'Point Light' . WDEEntity pointLightPrototype.
		'Spot Light' . WDEEntity spotLightPrototype.
		'Directional Light' . WDEEntity directionalLightPrototype.
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> makeCategoryNamed: categoryName withElements: elements [
	| category |
	category :=  WDEPaletteCategory new
		name: categoryName.
		
	elements pairsDo: [ :templateName :prototype |
		category addTemplate: (
		WDELevelElementEntityTemplate new
			name: templateName;
			prototype: prototype;
			yourself
		)
	].
	^ category
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> topLevelPaletteCategories [
	^ {
		self lightsCategory.
		self extrudedGeometry2DCategory.
		self bspGeometryCategory.
	}
]

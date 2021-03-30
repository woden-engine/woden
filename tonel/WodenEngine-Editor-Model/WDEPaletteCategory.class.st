Class {
	#name : #WDEPaletteCategory,
	#superclass : #WDEPaletteTreeNode,
	#instVars : [
		'name',
		'templates',
		'subcategories',
		'subcategoryDictionary'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #accessing }
WDEPaletteCategory >> addSubCategory: aSubCategory [
	subcategories add: aSubCategory.
	subcategoryDictionary at: aSubCategory name put: aSubCategory
]

{ #category : #accessing }
WDEPaletteCategory >> addTemplate: aTemplate [
	templates add: aTemplate
]

{ #category : #converting }
WDEPaletteCategory >> asPaletteElement [
	^ nil
]

{ #category : #accessing }
WDEPaletteCategory >> children [
	^ subcategories , templates
]

{ #category : #accessing }
WDEPaletteCategory >> getOrCreateSubcategoryNamed: subcategoryName [
	^ subcategoryDictionary at: subcategoryName ifAbsentPut: [ 
		| subcategory |
		subcategory := self class new name: subcategoryName; yourself.
		subcategories add: subcategory.
		subcategory
	]
]

{ #category : #'as yet unclassified' }
WDEPaletteCategory >> getOrCreateSubcategoryWithPath: path [
	| category |
	category := self.
	path do: [ :each |
		category := category getOrCreateSubcategoryNamed: each
	].
	^ category
]

{ #category : #initialization }
WDEPaletteCategory >> initialize [
	subcategories := OrderedCollection new.
	subcategoryDictionary := Dictionary new.
	templates := OrderedCollection new.
	
]

{ #category : #accessing }
WDEPaletteCategory >> name [
	^ name
]

{ #category : #accessing }
WDEPaletteCategory >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDEPaletteCategory >> subcategories [
	^ subcategories
]

{ #category : #accessing }
WDEPaletteCategory >> templates [
	^ templates
]

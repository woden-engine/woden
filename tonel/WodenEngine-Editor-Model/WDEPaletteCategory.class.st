Class {
	#name : #WDEPaletteCategory,
	#superclass : #WDEPaletteTreeNode,
	#instVars : [
		'name',
		'templates',
		'subcategories'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #accessing }
WDEPaletteCategory >> addSubCategory: aSubCategory [
	subcategories add: aSubCategory
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

{ #category : #initialization }
WDEPaletteCategory >> initialize [
	subcategories := OrderedCollection new.
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

Class {
	#name : #WDELevelElementTemplateCategory,
	#superclass : #Object,
	#instVars : [
		'name',
		'templates',
		'subcategories'
	],
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #accessing }
WDELevelElementTemplateCategory >> addSubCategory: aSubCategory [
	subcategories add: aSubCategory
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> addTemplate: aTemplate [
	templates add: aTemplate
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> children [
	^ subcategories , templates
]

{ #category : #initialization }
WDELevelElementTemplateCategory >> initialize [
	subcategories := OrderedCollection new.
	templates := OrderedCollection new.
	
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> name [
	^ name
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> subcategories [
	^ subcategories
]

{ #category : #accessing }
WDELevelElementTemplateCategory >> templates [
	^ templates
]

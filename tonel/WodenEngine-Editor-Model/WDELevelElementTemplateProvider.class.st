Class {
	#name : #WDELevelElementTemplateProvider,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #'as yet unclassified' }
WDELevelElementTemplateProvider class >> allTopLevelTemplateCategories [
	| topLevelTemplateCategories |
	topLevelTemplateCategories := OrderedCollection new.
	self withAllSubclassesDo: [ :each |
		topLevelTemplateCategories addAll: each topLevelTemplateCategories
	].
	^ topLevelTemplateCategories
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplateProvider class >> topLevelTemplateCategories [
	^ self new topLevelTemplateCategories
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplateProvider >> topLevelTemplateCategories [
	^ #()
]

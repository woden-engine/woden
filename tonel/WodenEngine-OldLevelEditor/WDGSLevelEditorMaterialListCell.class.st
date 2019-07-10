Class {
	#name : #WDGSLevelEditorMaterialListCell,
	#superclass : #Object,
	#instVars : [
		'thumbnail',
		'category',
		'label',
		'value'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-OldLevelEditor-View'
}

{ #category : #'as yet unclassified' }
WDGSLevelEditorMaterialListCell >> <= other [
	category = other category ifTrue: [ 
		^ label <= other label
	].
	^ category <= other category
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> category [
	^ category
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> category: anObject [
	category := anObject
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> label [
	^ label
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> label: anObject [
	label := anObject
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> thumbnail [
	^ thumbnail
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> thumbnail: anObject [
	thumbnail := anObject
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> value [
	^ value
]

{ #category : #accessing }
WDGSLevelEditorMaterialListCell >> value: anObject [
	value := anObject
]

Class {
	#name : #WTGLevelEditorMaterialListCell,
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
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGLevelEditorMaterialListCell >> <= other [
	category = other category ifTrue: [ 
		^ label <= other label
	].
	^ category <= other category
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> category [
	^ category
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> category: anObject [
	category := anObject
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> label [
	^ label
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> label: anObject [
	label := anObject
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> thumbnail [
	^ thumbnail
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> thumbnail: anObject [
	thumbnail := anObject
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> value [
	^ value
]

{ #category : #accessing }
WTGLevelEditorMaterialListCell >> value: anObject [
	value := anObject
]

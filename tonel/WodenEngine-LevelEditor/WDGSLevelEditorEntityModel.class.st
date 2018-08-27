Class {
	#name : #WDGSLevelEditorEntityModel,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'entity'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorEntityModel >> entity [
	^ entity
]

{ #category : #accessing }
WDGSLevelEditorEntityModel >> entity: anObject [
	entity := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorEntityModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: entity.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorEntityModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WDGSLevelEditorSelectionBox empty
		addElement: entity.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorEntityModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: entity.
]

Class {
	#name : #WTGLevelEditorEntityModel,
	#superclass : #WTGLevelEditorElementModel,
	#instVars : [
		'entity'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #accessing }
WTGLevelEditorEntityModel >> entity [
	^ entity
]

{ #category : #accessing }
WTGLevelEditorEntityModel >> entity: anObject [
	entity := anObject
]

{ #category : #'as yet unclassified' }
WTGLevelEditorEntityModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: entity.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorEntityModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox empty
		addElement: entity.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorEntityModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: entity.
]

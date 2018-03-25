Class {
	#name : #WTGLevelEditorBrushModel,
	#superclass : #WTGLevelEditorElementModel,
	#instVars : [
		'brush'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #accessing }
WTGLevelEditorBrushModel >> brush [
	^ brush
]

{ #category : #accessing }
WTGLevelEditorBrushModel >> brush: anObject [
	brush := anObject
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: brush.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox new
		addElement: brush.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: brush.
]

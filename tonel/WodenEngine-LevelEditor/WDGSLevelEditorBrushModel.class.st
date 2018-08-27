Class {
	#name : #WDGSLevelEditorBrushModel,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'brush'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorBrushModel >> brush [
	^ brush
]

{ #category : #accessing }
WDGSLevelEditorBrushModel >> brush: anObject [
	brush := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: brush.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WDGSLevelEditorSelectionBox new
		addElement: brush.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: brush.
]

Class {
	#name : #WDGSLevelEditorBrushFaceModel,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'face'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorBrushFaceModel >> face [
	^ face
]

{ #category : #accessing }
WDGSLevelEditorBrushFaceModel >> face: anObject [
	face := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushFaceModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: face.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushFaceModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WDGSLevelEditorSelection new
		addElement: face.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorBrushFaceModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: face.
]

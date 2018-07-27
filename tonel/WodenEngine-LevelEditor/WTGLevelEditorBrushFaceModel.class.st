Class {
	#name : #WTGLevelEditorBrushFaceModel,
	#superclass : #WTGLevelEditorElementModel,
	#instVars : [
		'face'
	],
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #accessing }
WTGLevelEditorBrushFaceModel >> face [
	^ face
]

{ #category : #accessing }
WTGLevelEditorBrushFaceModel >> face: anObject [
	face := anObject
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushFaceModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: face.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushFaceModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WTGLevelEditorSelection new
		addElement: face.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorBrushFaceModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: face.
]

Class {
	#name : #WTGLevelEditorElementModel,
	#superclass : #WTSNodeModel,
	#instVars : [
		'visibleView'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #accessing }
WTGLevelEditorElementModel >> view [
	^ visibleView
]

{ #category : #accessing }
WTGLevelEditorElementModel >> view: anObject [
	visibleView := anObject
]

{ #category : #'as yet unclassified' }
WTGLevelEditorElementModel >> view: view selectAddOnEditor: editor [
	"By default, do nothing"
]

{ #category : #'as yet unclassified' }
WTGLevelEditorElementModel >> view: view selectSingleOnEditor: editor [
	"By default, do nothing"
]

{ #category : #'as yet unclassified' }
WTGLevelEditorElementModel >> view: view selectToggleOnEditor: editor [
	"By default, do nothing"
]

{ #category : #testing }
WTGLevelEditorElementModel >> visibleForView: aView [
	^ visibleView isNil or: [ visibleView == aView ]
]

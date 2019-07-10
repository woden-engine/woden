Class {
	#name : #WDGSLevelEditorElementModel,
	#superclass : #WDSGNodeModel,
	#instVars : [
		'visibleView'
	],
	#category : #'WodenEngine-OldLevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorElementModel >> view [
	^ visibleView
]

{ #category : #accessing }
WDGSLevelEditorElementModel >> view: anObject [
	visibleView := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorElementModel >> view: view selectAddOnEditor: editor [
	"By default, do nothing"
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorElementModel >> view: view selectSingleOnEditor: editor [
	"By default, do nothing"
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorElementModel >> view: view selectToggleOnEditor: editor [
	"By default, do nothing"
]

{ #category : #testing }
WDGSLevelEditorElementModel >> visibleForView: aView [
	^ visibleView isNil or: [ visibleView == aView ]
]

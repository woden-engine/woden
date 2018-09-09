Class {
	#name : #WDGSLevelEditorModelingComponentModel,
	#superclass : #WDGSLevelEditorElementModel,
	#instVars : [
		'component'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #accessing }
WDGSLevelEditorModelingComponentModel >> component [
	^ component
]

{ #category : #accessing }
WDGSLevelEditorModelingComponentModel >> component: anObject [
	component := anObject
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorModelingComponentModel >> view: view selectAddOnEditor: editor [
	editor selection addElement: component.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorModelingComponentModel >> view: view selectSingleOnEditor: editor [
	| newSelection |
	newSelection := WDGSLevelEditorSelectionBox new
		addElement: component.
	editor selection: newSelection.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorModelingComponentModel >> view: view selectToggleOnEditor: editor [
	editor selection toggleSelectedElement: component.
]

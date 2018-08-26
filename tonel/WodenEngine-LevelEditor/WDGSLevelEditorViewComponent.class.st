Class {
	#name : #WDGSLevelEditorViewComponent,
	#superclass : #VsTkPanelWidget,
	#instVars : [
		'editor'
	],
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #'instance creation' }
WDGSLevelEditorViewComponent class >> for: anEditor [
	^ self new editor: anEditor
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> editor [
	^ editor
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> engine [
	^ editor engine
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> model [
	^ editor model
]

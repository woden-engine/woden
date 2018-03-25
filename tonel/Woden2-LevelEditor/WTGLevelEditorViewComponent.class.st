Class {
	#name : #WTGLevelEditorViewComponent,
	#superclass : #BlElement,
	#instVars : [
		'editor'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'instance creation' }
WTGLevelEditorViewComponent class >> for: anEditor [
	^ self new editor: anEditor
]

{ #category : #accessing }
WTGLevelEditorViewComponent >> editor [
	^ editor
]

{ #category : #accessing }
WTGLevelEditorViewComponent >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
WTGLevelEditorViewComponent >> engine [
	^ editor engine
]

{ #category : #accessing }
WTGLevelEditorViewComponent >> scene [
	^ editor scene
]

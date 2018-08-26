Class {
	#name : #WDGSLevelEditorModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'map'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #'as yet unclassified' }
WDGSLevelEditorModel >> defaultViewClass [
	^ WDGSLevelEditorMainFrame
]

{ #category : #accessing }
WDGSLevelEditorModel >> map [
	^ map
]

{ #category : #accessing }
WDGSLevelEditorModel >> map: anObject [
	map := anObject
]

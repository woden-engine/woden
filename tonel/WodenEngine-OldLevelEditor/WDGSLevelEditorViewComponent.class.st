Class {
	#name : #WDGSLevelEditorViewComponent,
	#superclass : #AnObsoleteCyTkPanelWidget,
	#instVars : [
		'mainFrame'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-OldLevelEditor-View'
}

{ #category : #'instance creation' }
WDGSLevelEditorViewComponent class >> for: aMainFrame [
	^ self new mainFrame: aMainFrame
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> editor [
	^ mainFrame model
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> engine [
	^ self editor engine
]

{ #category : #initialization }
WDGSLevelEditorViewComponent >> initialize [
	super initialize.
	self backgroundColor: Color veryDarkGray
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> mainFrame [
	^ mainFrame
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> mainFrame: anObject [
	mainFrame := anObject
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> model [
	^ self mainFrame model
]

{ #category : #accessing }
WDGSLevelEditorViewComponent >> scene [
	^ self model scene
]

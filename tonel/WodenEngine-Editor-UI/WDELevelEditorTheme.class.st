Class {
	#name : #WDELevelEditorTheme,
	#superclass : #Object,
	#instVars : [
		'highlightColor',
		'boxCornerHandleColor',
		'highlightedBoxCornerHandleColor',
		'boxManipulatorColor',
		'highlightedBoxManipulatorColor',
		'boxPlacementManipulatorColor',
		'highlightedBoxPlacementManipulatorColor',
		'selectionManipulatorColor',
		'highlightedSelectionManipulatorColor'
	],
	#classVars : [
		'Current'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDELevelEditorTheme class >> current [
	^ Current ifNil: [ Current := self new ]
]

{ #category : #accessing }
WDELevelEditorTheme class >> current: newTheme [
	Current := newTheme
]

{ #category : #initialization }
WDELevelEditorTheme class >> reset [
	<script>
	Current := self new
]

{ #category : #accessing }
WDELevelEditorTheme >> boxCornerHandleColor [

	^ boxCornerHandleColor
]

{ #category : #accessing }
WDELevelEditorTheme >> boxCornerHandleColor: anObject [

	boxCornerHandleColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> boxManipulatorColor [

	^ boxManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> boxManipulatorColor: anObject [

	boxManipulatorColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> boxPlacementManipulatorColor [

	^ boxPlacementManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> boxPlacementManipulatorColor: anObject [

	boxPlacementManipulatorColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightColor [

	^ highlightColor
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightColor: anObject [

	highlightColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxCornerHandleColor [

	^ highlightedBoxCornerHandleColor
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxCornerHandleColor: anObject [

	highlightedBoxCornerHandleColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxManipulatorColor [

	^ highlightedBoxManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxManipulatorColor: anObject [

	highlightedBoxManipulatorColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxPlacementManipulatorColor [

	^ highlightedBoxPlacementManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedBoxPlacementManipulatorColor: anObject [

	highlightedBoxPlacementManipulatorColor := anObject
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedSelectionManipulatorColor [

	^ highlightedSelectionManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> highlightedSelectionManipulatorColor: anObject [

	highlightedSelectionManipulatorColor := anObject
]

{ #category : #initialization }
WDELevelEditorTheme >> initialize [
	super initialize.
	highlightColor := Color r: 0.5 g: 0.6 b: 0.9 alpha: 0.1.

	boxCornerHandleColor := Color gray: 0.7.
	highlightedBoxCornerHandleColor := Color gray: 0.9.

	boxManipulatorColor := Color r: 0.85 g: 0.85 b: 0.5 alpha: 0.1.
	highlightedBoxManipulatorColor := Color r: 0.95 g: 0.95 b: 0.6 alpha: 0.1.
	
	boxPlacementManipulatorColor := (Color gray: 0.7) alpha: 0.1.
	highlightedBoxPlacementManipulatorColor := (Color gray: 0.9) alpha: 0.1.
	
	selectionManipulatorColor := Color r: 0.95 g: 0.85 b: 0.6 alpha: 0.1.
	highlightedSelectionManipulatorColor := Color r: 0.95 g: 0.95 b: 0.6 alpha: 0.1.
]

{ #category : #accessing }
WDELevelEditorTheme >> selectionManipulatorColor [

	^ selectionManipulatorColor
]

{ #category : #accessing }
WDELevelEditorTheme >> selectionManipulatorColor: anObject [

	selectionManipulatorColor := anObject
]

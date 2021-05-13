Class {
	#name : #WDEPaletteTreeNode,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDEPaletteTreeNode >> activateInLevelSession: levelSession [
	"This gives an opportunity to apply the palette element to the selected elements."
]

{ #category : #testing }
WDEPaletteTreeNode >> canBePlacedInLevel [
	^ false
]

{ #category : #accessing }
WDEPaletteTreeNode >> name [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDEPaletteTreeNode >> thumbnailFor: levelEditorSession engine: engine [
	^ nil
]

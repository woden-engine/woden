Class {
	#name : #WDEPaletteElement,
	#superclass : #WDEPaletteTreeNode,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #converting }
WDEPaletteElement >> asPaletteElement [
	^ self
]

{ #category : #accessing }
WDEPaletteElement >> children [
	^ #()
]

{ #category : #accessing }
WDEPaletteElement >> name [
	^ name
]

{ #category : #accessing }
WDEPaletteElement >> name: anObject [
	name := anObject
]

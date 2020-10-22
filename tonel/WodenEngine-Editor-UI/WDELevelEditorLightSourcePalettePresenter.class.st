Class {
	#name : #WDELevelEditorLightSourcePalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorLightSourcePalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelLightSourcePaletteCategories
]

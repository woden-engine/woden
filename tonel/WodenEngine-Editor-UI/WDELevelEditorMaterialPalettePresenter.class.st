Class {
	#name : #WDELevelEditorMaterialPalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorMaterialPalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topMaterialPaletteCategories
]

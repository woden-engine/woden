Class {
	#name : #WDELevelGenericElementTemplateProvider,
	#superclass : #WDELevelElementTemplateProvider,
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> genericCategory [
	| category |
	category :=  WDELevelElementTemplateCategory new
		name: 'World Entities'.
		
	{
		'Point 2D' . WDEEntity point2DPrototype.
		'Point 3D' . WDEEntity point3DPrototype.
		'Solid Wall 2D' . WDEEntity solidWall2DPrototype.
		'Solid Wall 3D' . WDEEntity solidWall3DPrototype.
	} pairsDo: [ :categoryName :prototype |
		category addTemplate: (
		WDELevelElementEntityTemplate new
			name: categoryName;
			prototype: prototype
		)
	].
	^ category
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> topLevelTemplateCategories [
	^ {
		self genericCategory
	}
]

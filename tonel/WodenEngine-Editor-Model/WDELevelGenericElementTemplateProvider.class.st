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
		'Point' . WDEEntity pointPrototype.
		'Solid Wall 2D' . WDEEntity solidWall2DPrototype.
		'Solid Wall 3D' . WDEEntity solidWall3DPrototype.
	} pairsDo: [ :templateName :prototype |
		category addTemplate: (
		WDELevelElementEntityTemplate new
			name: templateName;
			prototype: prototype;
			yourself
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

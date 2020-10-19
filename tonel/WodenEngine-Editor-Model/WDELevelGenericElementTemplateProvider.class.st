Class {
	#name : #WDELevelGenericElementTemplateProvider,
	#superclass : #WDELevelElementTemplateProvider,
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> genericCategory [
	| category |
	category :=  WDELevelElementTemplateCategory new
		name: 'Basic Entities'.
		
	{
		'Point' . WDEEntity pointPrototype.
		'Solid Wall 2D' . WDEEntity solidWall2DPrototype.
		'Solid Wall 3D' . WDEEntity solidWall3DPrototype.
		'Point Light' . WDEEntity pointLightPrototype.
		'Spot Light' . WDEEntity spotLightPrototype.
		'Directional Light' . WDEEntity directionalLightPrototype.
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

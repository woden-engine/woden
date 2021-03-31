Class {
	#name : #WDEGameSettings,
	#superclass : #Object,
	#instVars : [
		'entityDescriptions'
	],
	#category : #'WodenEngine-Editor-Model-GameSettings'
}

{ #category : #'as yet unclassified' }
WDEGameSettings class >> allSettings [
	^ self withAllSubclasses
		reject: [ :each | each isAbstract  ]
		thenCollect: [ :each | each new ]
]

{ #category : #accessing }
WDEGameSettings class >> default [
	^ WDEWodenGameSettings new
]

{ #category : #testing }
WDEGameSettings class >> isAbstract [
	^ self == WDEGameSettings
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> createMaterialCategoriesFromFilesInFolders: folders [
	| topLevelCategory |
	topLevelCategory := WDEPaletteCategory new name: self name , ' Assets'.
	folders select: [ :eachFolder | eachFolder exists ] thenDo: [ :eachFolder |
		eachFolder allChildren do: [ :eachChild |
			(eachChild isFile and: [#(wmat wtmat ) includes: eachChild extension]) ifTrue: [
				| categoryPath category materialPath |
				categoryPath := eachChild parent relativeTo: eachFolder.
				category := topLevelCategory getOrCreateSubcategoryWithPath: categoryPath.
				materialPath := (eachChild relativeTo: eachFolder) fullName.
				category addTemplate: 
					((WDEMaterialPaletteElement referencePath: materialPath)
						name: eachChild basenameWithoutExtension)
			]
		]
	].

	^ { topLevelCategory }
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> createRenderingMaterialForPath: path engine: engine [
	^ engine defaultMaterial
]

{ #category : #palettes }
WDEGameSettings >> entityDescriptions [
	^ entityDescriptions ifNil: [ entityDescriptions := self fetchEntityDescriptions ]
]

{ #category : #palettes }
WDEGameSettings >> fetchEntityDescriptions [
	^ WDEEntityDescriptions new
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> makeThumbnailForMaterialWithPath: path engine: engine [
	| thumbnailValue |
	thumbnailValue := (self createRenderingMaterialForPath: path engine: engine) thumbnail value.
	thumbnailValue isColor ifTrue: [ 
		^ (Form extent: 16@16 depth: 32) fillColor: thumbnailValue
	].
	thumbnailValue isForm ifTrue: [
		(thumbnailValue width >16 or: thumbnailValue height > 16) ifTrue: [
			^ thumbnailValue scaledToSize: (thumbnailValue width min: 16) @ (thumbnailValue height min: 16)
		].
	
		^ thumbnailValue
	].
	^ nil

]

{ #category : #accessing }
WDEGameSettings >> name [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> playLevelInSession: levelEditorSession [
	self inform: 'TODO: play level in editor session.'
]

{ #category : #palettes }
WDEGameSettings >> topLevelElementTemplateCategories [
	^ self topLevelEntityCategories
]

{ #category : #palettes }
WDEGameSettings >> topLevelEntityCategories [
	| category |
	category := self entityDescriptions makeEntityTemplateCategoryNamed: self name , ' Entities'.
	^ category isEmpty ifTrue: [ #() ] ifFalse: [ { category } ]
]

{ #category : #palettes }
WDEGameSettings >> topMaterialPaletteCategories [
	^ #()
]

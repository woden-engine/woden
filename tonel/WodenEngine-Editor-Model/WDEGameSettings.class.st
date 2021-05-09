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
WDEGameSettings >> createMaterialCategoriesFromFilesInFolders: searchFolders [
	^ self createPaletteCategory: self name , ' Materials' forFilesWithExtensions: self materialExtensions inFolders: searchFolders with: [:materialPath |
		(WDEMaterialPaletteElement referencePath: materialPath fullName)
			name: materialPath basenameWithoutExtension
	]
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> createModelCategoriesFromFilesInFolders: searchFolders [
	^ self createPaletteCategory: self name , ' Models' forFilesWithExtensions: self modelExtensions inFolders: searchFolders with: [:modelPath |
		(WDEModelPaletteElement referencePath: modelPath fullName)
			name: modelPath basenameWithoutExtension
	]
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> createPaletteCategory: categoryName forFilesWithExtensions: extensions inFolders: searchFolders with: paletteElementCreationBlock [
		| topLevelCategory |
	topLevelCategory := WDEPaletteCategory new name: categoryName.
	searchFolders select: [ :eachFolder | eachFolder exists ] thenDo: [ :eachFolder |
		eachFolder allChildren do: [ :eachChild |
			(eachChild isFile and: [extensions includes: eachChild extension]) ifTrue: [
				| categoryPath category assetPath |
				categoryPath := eachChild parent relativeTo: eachFolder.
				category := topLevelCategory getOrCreateSubcategoryWithPath: categoryPath.
				assetPath := eachChild relativeTo: eachFolder.
				category addTemplate: (paletteElementCreationBlock value: assetPath)
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
WDEGameSettings >> getOrCreateModelAssetForPath: path engine: engine [
	^ nil
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

{ #category : #'as yet unclassified' }
WDEGameSettings >> materialExtensions [
	^ #(wmat wtmat )
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> modelExtensions [
	^ #(obj gltf glb)
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
	^ self topLevelModelsCategories , self topLevelEntityCategories
]

{ #category : #palettes }
WDEGameSettings >> topLevelEntityCategories [
	| category |
	category := self entityDescriptions makeEntityTemplateCategoryNamed: self name , ' Entities'.
	^ category isEmpty ifTrue: [ #() ] ifFalse: [ { category } ]
]

{ #category : #palettes }
WDEGameSettings >> topLevelModelsCategories [
	^ #()
]

{ #category : #palettes }
WDEGameSettings >> topMaterialPaletteCategories [
	^ #()
]

Class {
	#name : #WDEWodenGameSettings,
	#superclass : #WDEGameSettings,
	#instVars : [
		'materialSearchPaths',
		'assetSearchPaths',
		'modelSearchPaths'
	],
	#category : #'WodenEngine-Editor-Model-GameSettings'
}

{ #category : #palettes }
WDEWodenGameSettings >> assetSearchPaths [
	^ assetSearchPaths ifNil: [ assetSearchPaths := self defaultAssetSearchPaths ]
]

{ #category : #'as yet unclassified' }
WDEWodenGameSettings >> createRenderingMaterialForPath: path engine: engine [
	| solvedPath |
	self materialSearchPaths do: [ :searchPath |
		solvedPath := searchPath resolve: path asFileReference.
		solvedPath exists ifTrue: [
			^ engine resourceCache loadMaterial: solvedPath
		]
	].

	^ super createRenderingMaterialForPath: path engine: engine
]

{ #category : #palettes }
WDEWodenGameSettings >> defaultAssetSearchPaths [
	^ WDCEngine default assetSearchPaths
]

{ #category : #'as yet unclassified' }
WDEWodenGameSettings >> getOrCreateModelAssetForPath: path engine: engine [
	| solvedPath |
	self materialSearchPaths do: [ :searchPath |
		solvedPath := searchPath resolve: path asFileReference.
		solvedPath exists ifTrue: [
			^ engine resourceCache load3DModel: solvedPath
		]
	].

	^ super getOrCreateModelAssetForPath: path engine: engine
]

{ #category : #palettes }
WDEWodenGameSettings >> materialSearchPaths [
	^ materialSearchPaths ifNil: [ materialSearchPaths := self assetSearchPaths ]
]

{ #category : #palettes }
WDEWodenGameSettings >> modelSearchPaths [
	^ modelSearchPaths ifNil: [ modelSearchPaths := self assetSearchPaths ]
]

{ #category : #accessing }
WDEWodenGameSettings >> name [
	^ 'Woden'
]

{ #category : #'as yet unclassified' }
WDEWodenGameSettings >> playLevelInSession: levelEditorSession [
	| universe |
	universe := WDESSimpleUniverse for: WDCEngine default.
	universe loadSectorsFromEditorLevel: levelEditorSession level.

	universe createSimulationModel
		openInVR
		spawnPlayer.
]

{ #category : #palettes }
WDEWodenGameSettings >> topLevelModelsCategories [
	^ self createModelCategoriesFromFilesInFolders: self modelSearchPaths
]

{ #category : #palettes }
WDEWodenGameSettings >> topMaterialPaletteCategories [
	^ self createMaterialCategoriesFromFilesInFolders: self materialSearchPaths
]

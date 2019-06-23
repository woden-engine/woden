Class {
	#name : #WDCMultiTextureView,
	#superclass : #Object,
	#instVars : [
		'textures'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCMultiTextureView >> gtInspectorTextures: composite [
	<gtInspectorPresentationOrder: 0>  
	| browser |
	browser := composite tabulator.
	browser
		title: 'Textures';
		column: #one.
	browser transmit
		to: #one;
		andShow: [ :a |
			textures select: [:kv | kv value isNotNil and: [kv value canBeDecoded]] thenDo: [ :tex |
				(tex value gtInspectorFormIn: a) title: tex key
			]
	].
	^ browser

"	| rowBrowser |
	^ composite tabulator
		title: 'Textures';
		with:  [ :t |
			]
		]"
]

{ #category : #'as yet unclassified' }
WDCMultiTextureView >> saveToDisk: namePrefix [
	| fileName |
	textures do: [ :assoc |
		fileName := namePrefix , assoc key , '.png'.
		PNGReadWriter putForm: (assoc value firstLayerLevelAsForm) onFileNamed: fileName
	]
]

{ #category : #accessing }
WDCMultiTextureView >> textures [
	^ textures
]

{ #category : #accessing }
WDCMultiTextureView >> textures: anObject [
	textures := anObject
]

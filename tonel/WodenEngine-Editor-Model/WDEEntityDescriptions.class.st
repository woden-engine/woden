Class {
	#name : #WDEEntityDescriptions,
	#superclass : #Object,
	#instVars : [
		'entities'
	],
	#category : #'WodenEngine-Editor-Model-EntityDescription'
}

{ #category : #serialization }
WDEEntityDescriptions class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #adding }
WDEEntityDescriptions >> addEntityDescription: desc [
	entities at: desc className put: desc
]

{ #category : #'as yet unclassified' }
WDEEntityDescriptions >> boundingBoxForEntityWithClassName: entityClassName [
	^ entities at: entityClassName ifPresent: [ :found | found boundingBox ] ifAbsent: [ nil ]
]

{ #category : #accessing }
WDEEntityDescriptions >> entities [

	^ entities
]

{ #category : #initialization }
WDEEntityDescriptions >> initialize [
	super initialize.
	entities := Dictionary new.
]

{ #category : #serialization }
WDEEntityDescriptions >> loadFromJson: jsonData [
	jsonData at: 'entities' ifPresent: [ :dict |
		dict keysAndValuesDo: [ :className :value |
			| desc |
			desc := WDEEntityDescription new
				className: className;
				loadFromJson: value;
				yourself.
			self addEntityDescription: desc
		]
	]
]

{ #category : #'as yet unclassified' }
WDEEntityDescriptions >> makeEntityTemplateCategoryNamed: categoryName [
	| topLevelCategory |
	topLevelCategory := WDEPaletteCategory new
			name: categoryName;
			yourself.

	entities values select: [:eachValue |
		eachValue shouldBeExposedToTheUser
	] thenDo: [ :eachValue |
		| categoryPath category|
		categoryPath := (eachValue editorCategory splitOn: $/) select: [ :each | each isNotEmpty ].
		category := topLevelCategory getOrCreateSubcategoryWithPath: categoryPath.
		category addTemplate: (WDELevelElementEntityTemplate new
			name: eachValue className;
			prototype: eachValue makeEntityPrototype;
			yourself
		)
	].
	topLevelCategory sortRecursively.
	^ topLevelCategory
]

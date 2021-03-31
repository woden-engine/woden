Class {
	#name : #WDEEntityDescription,
	#superclass : #Object,
	#instVars : [
		'className',
		'isMetadata',
		'needsTicking',
		'properties',
		'isAvailableInEditor',
		'isMapIntrinsic',
		'classDescription',
		'editorCategory',
		'type',
		'previewModel',
		'boundingBox'
	],
	#category : #'WodenEngine-Editor-Model-EntityDescription'
}

{ #category : #adding }
WDEEntityDescription >> addPropertyDescription: propertyDescription [
	properties at: propertyDescription name put: propertyDescription
]

{ #category : #accessing }
WDEEntityDescription >> boundingBox [

	^ boundingBox
]

{ #category : #accessing }
WDEEntityDescription >> boundingBox: anObject [

	^ boundingBox := anObject
]

{ #category : #accessing }
WDEEntityDescription >> classDescription [

	^ classDescription
]

{ #category : #accessing }
WDEEntityDescription >> classDescription: anObject [

	classDescription := anObject
]

{ #category : #accessing }
WDEEntityDescription >> className [
	^ className
]

{ #category : #accessing }
WDEEntityDescription >> className: anObject [

	className := anObject
]

{ #category : #accessing }
WDEEntityDescription >> editorCategory [

	^ editorCategory
]

{ #category : #accessing }
WDEEntityDescription >> editorCategory: anObject [

	editorCategory := anObject
]

{ #category : #initialization }
WDEEntityDescription >> initialize [
	super initialize.
	type := #point.
	className := ''.
	classDescription := ''.
	previewModel := ''.
	editorCategory := ''.
	needsTicking := ''.
	isAvailableInEditor := true.
	isMetadata := ''.
	isMapIntrinsic := false.
	properties := Dictionary new.
	boundingBox := BoxF32 point: Float32x3 zeros.
]

{ #category : #accessing }
WDEEntityDescription >> isAvailableInEditor [

	^ isAvailableInEditor
]

{ #category : #accessing }
WDEEntityDescription >> isAvailableInEditor: anObject [

	isAvailableInEditor := anObject
]

{ #category : #accessing }
WDEEntityDescription >> isMapIntrinsic [

	^ isMapIntrinsic
]

{ #category : #accessing }
WDEEntityDescription >> isMapIntrinsic: anObject [

	isMapIntrinsic := anObject
]

{ #category : #accessing }
WDEEntityDescription >> isMetadata [

	^ isMetadata
]

{ #category : #accessing }
WDEEntityDescription >> isMetadata: anObject [

	isMetadata := anObject
]

{ #category : #serialization }
WDEEntityDescription >> loadFromJson: jsonData [
	type := (jsonData at: #type ifAbsent: [type]) asSymbol.
	previewModel := jsonData at: #previewModel ifAbsent: [previewModel].
	jsonData at: #boundingBox ifPresent: [:bbox |
		boundingBox := BoxF32 loadFromJson: bbox
	].

	classDescription := jsonData at: #classDescription ifAbsent: [classDescription].
	editorCategory := jsonData at: #editorCategory ifAbsent: [editorCategory].
	isMapIntrinsic := jsonData at: #isMapIntrinsic ifAbsent: [isMapIntrinsic].
	isAvailableInEditor := jsonData at: #isAvailableInEditor ifAbsent: [isAvailableInEditor].
	isMetadata := jsonData at: #isMetadata ifAbsent: [isMetadata].
	needsTicking := jsonData at: #needsTicking ifAbsent: [needsTicking].
	
	jsonData at: 'properties' ifPresent: [ :dict |
		dict keysAndValuesDo: [ :name :value |
			| prop |
			prop := WDEEntityPropertyDescription new
				name: name;
				loadFromJson: value;
				yourself.
			self addPropertyDescription: prop
		]
	]
]

{ #category : #'as yet unclassified' }
WDEEntityDescription >> makeEntityPrototype [
	| result |
	result := WDEEntity new
		className: className;
		yourself.

	(#(solid) includes: type) ifTrue: [
		result addComponent: (WDECollisionComponent box: boundingBox)
	].

	(#(solid nonSolid) includes: type) ifTrue: [
		result localBoundingBox: boundingBox.
		result addComponent: (WDEVisualComponent box: boundingBox)
	].

	^ result
]

{ #category : #accessing }
WDEEntityDescription >> needsTicking [

	^ needsTicking
]

{ #category : #accessing }
WDEEntityDescription >> needsTicking: anObject [

	needsTicking := anObject
]

{ #category : #accessing }
WDEEntityDescription >> previewModel [

	^ previewModel
]

{ #category : #accessing }
WDEEntityDescription >> previewModel: anObject [

	previewModel := anObject
]

{ #category : #accessing }
WDEEntityDescription >> properties [
	^ properties
]

{ #category : #accessing }
WDEEntityDescription >> properties: anObject [

	properties := anObject
]

{ #category : #asserting }
WDEEntityDescription >> shouldBeExposedToTheUser [
	^ isAvailableInEditor and: [ isMapIntrinsic not ]
]

{ #category : #accessing }
WDEEntityDescription >> type [

	^ type
]

{ #category : #accessing }
WDEEntityDescription >> type: anObject [

	type := anObject
]

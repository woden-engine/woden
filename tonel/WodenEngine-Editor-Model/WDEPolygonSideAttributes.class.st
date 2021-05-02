Class {
	#name : #WDEPolygonSideAttributes,
	#superclass : #WDELevelElement,
	#instVars : [
		'parent',
		'materialAttributes'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEPolygonSideAttributes >> accept: visitor [
	^ visitor visitPolygonSideAttributes: self
]

{ #category : #serialization }
WDEPolygonSideAttributes >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#material . materialAttributes encodeForJSON
	}
]

{ #category : #initialization }
WDEPolygonSideAttributes >> initialize [
	super initialize.
	materialAttributes := WDEFaceMaterialAttributes new.
]

{ #category : #serialization }
WDEPolygonSideAttributes >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.

	jsonData at: 'material' ifPresent: [ :data |
		materialAttributes loadFromJson: data context: context
	].
	
]

{ #category : #accessing }
WDEPolygonSideAttributes >> materialAttributes [

	^ materialAttributes
]

{ #category : #accessing }
WDEPolygonSideAttributes >> materialAttributes: anObject [

	materialAttributes := anObject
]

{ #category : #memento }
WDEPolygonSideAttributes >> materialStateMemento [
	^ materialAttributes materialStateMemento
]

{ #category : #accessing }
WDEPolygonSideAttributes >> parent [
	^ parent
]

{ #category : #accessing }
WDEPolygonSideAttributes >> parent: anObject [

	parent := anObject
]

{ #category : #copying }
WDEPolygonSideAttributes >> postCopy [
	super postCopy.
	materialAttributes := materialAttributes copy.
	parent := nil.
]

{ #category : #memento }
WDEPolygonSideAttributes >> restoreMaterialStateMemento: memento [
	materialAttributes restoreMaterialStateMemento: memento
]

{ #category : #initialization }
WDEPolygonSideAttributes >> setMaterial: newMaterial [
	materialAttributes material: newMaterial.
	parent ifNotNil: [ parent changed ].
]

{ #category : #'as yet unclassified' }
WDEPolygonSideAttributes >> validateMaterialList [
	self level validateMaterial: materialAttributes material
]

Class {
	#name : #WDEPropertyPageBuilder,
	#superclass : #Object,
	#instVars : [
		'object',
		'properties',
		'page'
	],
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #building }
WDEPropertyPageBuilder class >> for: anObject buildWith: aBlock [
	^ self new object: anObject; buildWith: aBlock
]

{ #category : #building }
WDEPropertyPageBuilder >> addProperty: aProperty [
	aProperty object: object.
	properties add: aProperty
]

{ #category : #building }
WDEPropertyPageBuilder >> booleanPropertyNamed: name selector: selector [
	^ self addProperty: (WDEBooleanProperty name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> buildWith: aBlock [
	properties := OrderedCollection new.
	page := WDEPropertyPage new.
	aBlock value: self.
	properties sort: [ :a :b | a name <= b name].
	^ page
		properties: properties;
		yourself
]

{ #category : #building }
WDEPropertyPageBuilder >> integerPropertyNamed: name selector: selector [
	^ self addProperty: (WDEScalarProperty name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> linearColor3PropertyNamed: name selector: selector [
	^ self addProperty: (WDELinearColor3Property name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> linearColor4PropertyNamed: name selector: selector [
	^ self addProperty: (WDELinearColor4Property name: name selector: selector)
]

{ #category : #accessing }
WDEPropertyPageBuilder >> object [
	^ object
]

{ #category : #accessing }
WDEPropertyPageBuilder >> object: anObject [
	object := anObject
]

{ #category : #building }
WDEPropertyPageBuilder >> propertyNamed: name selector: selector alternatives: alternative [
	^ self addProperty: ((WDEAlternativeProperty name: name selector: selector)
		alternatives: alternative;
		yourself)
]

{ #category : #building }
WDEPropertyPageBuilder >> quaternionPropertyNamed: name selector: selector [
	^ self addProperty: (WDEQuaternionProperty name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> scalarPropertyNamed: name selector: selector [
	^ self addProperty: (WDEScalarProperty name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> stringPropertyNamed: name selector: selector [
	^ self addProperty: (WDEStringProperty name: name selector: selector)
]

{ #category : #accessing }
WDEPropertyPageBuilder >> title: newTitle [
	page title: newTitle
]

{ #category : #building }
WDEPropertyPageBuilder >> vector2PropertyNamed: name selector: selector [
	^ self addProperty: (WDEVector2Property name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> vector3PropertyNamed: name selector: selector [
	^ self addProperty: (WDEVector3Property name: name selector: selector)
]

{ #category : #building }
WDEPropertyPageBuilder >> vector4PropertyNamed: name selector: selector [
	^ self addProperty: (WDEVector4Property name: name selector: selector)
]

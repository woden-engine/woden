Class {
	#name : #WDCMaterial,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : 'WodenEngine-Core-Material'
}

{ #category : #'instance creation' }
WDCMaterial class >> for: aWTEngine [
	^ self new engine: aWTEngine
]

{ #category : #testing }
WDCMaterial class >> isMaterialClass [
	^ true
]

{ #category : #rendering }
WDCMaterial >> activateForwardOn: stateTracker [
	^ false
]

{ #category : #rendering }
WDCMaterial >> activateOn: stateTracker [
	^ stateTracker mode activateMaterial: self on: stateTracker
]

{ #category : #rendering }
WDCMaterial >> activateShadowOn: stateTracker [
	^ false
]

{ #category : #accessing }
WDCMaterial >> engine [
	^ engine
]

{ #category : #accessing }
WDCMaterial >> engine: anObject [
	engine := anObject
]

{ #category : #testing }
WDCMaterial >> isMaterial [
	^ true
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference color: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :colorData |
				colorData isString ifTrue: [
					self halt
				] ifFalse: [
					WMVector4F x: (colorData at: 1) 
							y: (colorData at: 2)
							z: (colorData at: 3)
							w: (colorData at: 4 ifAbsent: [ 1.0 ])
				] 
		]
		ifAbsent: [ aBlock value asWMVector4F ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference optionalSRGBTexture: name [
	^ self parse: data at: fileReference srgbTexture: name ifAbsent: nil
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference optionalTexture: name [
	^ self parse: data at: fileReference texture: name ifAbsent: nil
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference srgbColor: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :colorData |
				colorData isString ifTrue: [
					self halt
				] ifFalse: [
					(Color r: (colorData at: 1) 
							g: (colorData at: 2)
							b: (colorData at: 3)
							alpha: (colorData at: 4 ifAbsent: [ 1.0 ])) asWMVector4F
				] 
		]
		ifAbsent: [ aBlock value asWMVector4F ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference srgbTexture: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadSRGBTexture: textureName ]
		ifAbsent: aBlock .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference texture: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadTexture: textureName ]
		ifAbsent: aBlock .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference vector3: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :colorData |
					WMVector3F x: (colorData at: 1) 
							y: (colorData at: 2)
							z: (colorData at: 3)
		]
		ifAbsent: [ aBlock value asWMVector3F ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: materialFileReference data: aDictionary [
	self subclassResponsibility
	
]

{ #category : #parsing }
WDCMaterial >> parseError: errorMessage at: fileReference [
	self error: fileReference printString , ': ' , errorMessage
]

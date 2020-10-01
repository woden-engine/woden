Class {
	#name : #WDCMaterial,
	#superclass : #WDCResourceWithDependants,
	#instVars : [
		'engine'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Material'
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
WDCMaterial >> activateDepthNormalOn: stateTracker [
	^ false
]

{ #category : #rendering }
WDCMaterial >> activateDepthOnlyOn: stateTracker [
	^ false
]

{ #category : #rendering }
WDCMaterial >> activateForwardOn: stateTracker [
	^ false
]

{ #category : #rendering }
WDCMaterial >> activateOn: stateTracker [
	^ stateTracker mode activateMaterial: self on: stateTracker
]

{ #category : #'as yet unclassified' }
WDCMaterial >> concreteMaterialFor: anEngine [
	^ self copy engine: anEngine; concretizeMaterial
]

{ #category : #'as yet unclassified' }
WDCMaterial >> concretizeMaterial [
	"This is the place for concretizing the textures."
]

{ #category : #accessing }
WDCMaterial >> engine [
	^ engine
]

{ #category : #accessing }
WDCMaterial >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCMaterial >> engineChangedTo: newEngine [
	engine == newEngine ifTrue: [ ^ self ].
	^ (self concreteMaterialFor: newEngine)
		invalidateCache
]

{ #category : #shaders }
WDCMaterial >> fetchFragmentShader: shaderName [
	^ engine loadFragmentShader: shaderName
]

{ #category : #shaders }
WDCMaterial >> fetchVertexShader: shaderName [
	^ engine loadVertexShader: shaderName
]

{ #category : #'state binding' }
WDCMaterial >> invalidateCache [
]

{ #category : #testing }
WDCMaterial >> isMaterial [
	^ true
]

{ #category : #testing }
WDCMaterial >> isMaterialDescription [
	^ engine isNil
]

{ #category : #testing }
WDCMaterial >> isTranslucentMaterial [
	^ false
]

{ #category : #parsing }
WDCMaterial >> parse: data at: materialFileReference array: name size: size nativeType: nativeType ifAbsent: ifAbsentBlock [
	| result |
	result := SLVMNativeArray for: nativeType new: size.
	result atAllPut: ifAbsentBlock value.
	data at: name ifPresent: [ :array |
		array withIndexDo: [ :element :index |
			index <= size ifTrue: [
				result at: index put: (nativeType loadFromJson: element)
			]
		]
	].
	^ result
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference color: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :colorData |
				colorData isString ifTrue: [
					self halt
				] ifFalse: [
					Float32x4 x: (colorData at: 1) 
							y: (colorData at: 2)
							z: (colorData at: 3)
							w: (colorData at: 4 ifAbsent: [ 1.0 ])
				] 
		]
		ifAbsent: [ aBlock value asFloat32x4 ] .
	
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
WDCMaterial >> parse: data at: fileReference scalar: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :scalar | scalar ]
		ifAbsent: [ aBlock value asFloat ] .
	
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
							alpha: (colorData at: 4 ifAbsent: [ 1.0 ])) asFloat32x4
				] 
		]
		ifAbsent: [ aBlock value asFloat32x4 ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: materialFileReference srgbTexture: name arrayOfSize: size [
	| result |
	result := Array new: size.
	data at: name ifPresent: [ :textureNames |
		textureNames doWithIndex: [ :textureName :index |
			index <= size ifTrue: [
				result at: index put: (engine resourceCache loadSRGBTexture: textureName)
			]
		]
	].

	^ result
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference srgbTexture: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadSRGBTexture: textureName ]
		ifAbsent: aBlock .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: materialFileReference texture: name arrayOfSize: size [
	| result |
	result := Array new: size.
	data at: name ifPresent: [ :textureNames |
		textureNames doWithIndex: [ :textureName :index |
			index <= size ifTrue: [
				result at: index put: (engine resourceCache loadTexture: textureName)
			]
		]
	].

	^ result
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference texture: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :textureName | engine resourceCache loadTexture: textureName ]
		ifAbsent: aBlock .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference vector2: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :vector2 |
					Float32x2 x: (vector2 at: 1) 
							y: (vector2 at: 2)
		]
		ifAbsent: [ aBlock value asFloat32x2 ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference vector3: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :vector3 |
					Float32x3 x: (vector3 at: 1) 
							y: (vector3 at: 2)
							z: (vector3 at: 3)
		]
		ifAbsent: [ aBlock value asFloat32x3 ] .
	
]

{ #category : #parsing }
WDCMaterial >> parse: data at: fileReference vector4: name ifAbsent: aBlock [
	^ data at: name
		ifPresent: [ :vector4 |
					Float32x4 x: (vector4 at: 1) 
							y: (vector4 at: 2)
							z: (vector4 at: 3)
							w: (vector4 at: 4)
		]
		ifAbsent: [ aBlock value asFloat32x4 ]
	
]

{ #category : #parsing }
WDCMaterial >> parse: materialFileReference data: aDictionary [
	self subclassResponsibility
	
]

{ #category : #parsing }
WDCMaterial >> parseError: errorMessage at: fileReference [
	self error: fileReference printString , ': ' , errorMessage
]

{ #category : #enumerating }
WDCMaterial >> precacheResources [
]

{ #category : #testing }
WDCMaterial >> requiresTangentSpaceData [
	^ false
]

{ #category : #'as yet unclassified' }
WDCMaterial >> setupRenderableTranslucency: renderable [
]

{ #category : #preview }
WDCMaterial >> thumbnail [
	^ WDCResourceThumbnail type: self class name value: Color magenta
]

Class {
	#name : #WDPPompeiiDriver,
	#superclass : #PompeiiDriver,
	#instVars : [
		'engine',
		'colorShader',
		'vertexShader',
		'colorFontShader',
		'textureColorShader',
		'textureArrayColorShader',
		'formTextureCache',
		'textureMaterialCache',
		'textureArrayMaterialCache'
	],
	#classVars : [
		'PrimitiveTypeMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiDriver class >> forEngine: anEngine [
	^ self basicNew initializeWithEngine: anEngine; yourself
]

{ #category : #initialization }
WDPPompeiiDriver class >> initialize [
	PrimitiveTypeMap := Dictionary newFromPairs: { 
		PompeiiSubmesh2D points . AGPU_POINTS .
		PompeiiSubmesh2D lines . AGPU_LINES .
		PompeiiSubmesh2D triangles . AGPU_TRIANGLES .
	}.

]

{ #category : #testing }
WDPPompeiiDriver class >> isSupported [
	^ true
]

{ #category : #shaders }
WDPPompeiiDriver >> colorFontShader [
	^ colorFontShader ifNil: [ colorFontShader := engine loadFragmentShader: 'shaders/pompeii/textColorFragment.dastrel' ]
]

{ #category : #shaders }
WDPPompeiiDriver >> colorShader [
	^ colorShader ifNil: [ colorShader := engine loadFragmentShader: 'shaders/pompeii/colorFragment.dastrel' ]
]

{ #category : #'as yet unclassified' }
WDPPompeiiDriver >> convertMaterial: aMaterial [
	self flag: 'Implement myself'.
	^ aMaterial
]

{ #category : #'shape convertion' }
WDPPompeiiDriver >> convertMesh2D: aPompeiiMesh [
	| vertices indices indexCount glSubmesh submeshes |
	vertices := SLVMNativeArray for: WDPCanvasVertex2D new: aPompeiiMesh vertices size.
	indices := SLVMNativeOrderedCollection for: #uint.
	aPompeiiMesh vertices doWithIndex: [ :vertex :index |
		vertices at: index put: vertex asWDPCanvasVertex2D
	].
	
	indexCount := 0.
	submeshes := aPompeiiMesh submeshes collect: [ :submesh |
		submesh indices do: [ :index |
			indices add: index
		].
		glSubmesh := WDPPompeiiSubmesh new
			startIndex: indexCount;
			indexCount: submesh indices size;
			primitiveType: (self mapPrimitiveType: submesh primitiveType);
			material: (self convertMaterial: submesh material);
			yourself.
		indexCount := indexCount + glSubmesh indexCount.
		glSubmesh
	].

	^ WDPPompeiiMesh2D new
		vertices: vertices asByteArray;
		indices: indices asByteArray;
		submeshes: submeshes;
		yourself
]

{ #category : #texture }
WDPPompeiiDriver >> convertTexture: aTexture [
	^ formTextureCache at: aTexture ifAbsentPut: [ aTexture asSRGBTextureFor: engine ]
]

{ #category : #texture }
WDPPompeiiDriver >> convertTextureArray: aTextureArray [
	^ formTextureCache at: aTextureArray ifAbsentPut: [ aTextureArray asSRGBTextureFor: engine ]
]

{ #category : #'instance creation' }
WDPPompeiiDriver >> createFontCache: aLogicalFont [
	^ WDPPompeiiFontCache new driver: self; font: aLogicalFont; yourself
]

{ #category : #'as yet unclassified' }
WDPPompeiiDriver >> createMaterialForTexture: aTexture [
	^ textureMaterialCache at: aTexture ifAbsentPut: [
		WDPPompeiiTextureMaterial new
			driver: self;
			texture: (self convertTexture: aTexture);
			yourself
		]
]

{ #category : #'as yet unclassified' }
WDPPompeiiDriver >> createMaterialForTextureArray: aTextureArray element: aTextureElementIndex [
	^ textureArrayMaterialCache at: {aTextureArray . aTextureElementIndex} ifAbsentPut: [
		WDPPompeiiTextureArrayElementMaterial new
			driver: self;
			textureArray: (self convertTextureArray: aTextureArray);
			elementIndex: aTextureElementIndex;
			yourself
		]
]

{ #category : #accessing }
WDPPompeiiDriver >> engine [
	^ engine
]

{ #category : #initialization }
WDPPompeiiDriver >> initialize [
	super initialize.
	engine ifNil: [ engine := WDCEngine default ].
	engine pompeiiDriver: self.
	formTextureCache := WeakValueDictionary new.
	textureMaterialCache := WeakValueDictionary new.
	textureArrayMaterialCache := WeakValueDictionary new.
]

{ #category : #initialization }
WDPPompeiiDriver >> initializeWithEngine: anEngine [
	engine := anEngine.
	self initialize
]

{ #category : #'as yet unclassified' }
WDPPompeiiDriver >> mapPrimitiveType: primitiveType [
	^ PrimitiveTypeMap at: primitiveType
]

{ #category : #'instance creation' }
WDPPompeiiDriver >> surfaceWithExtent: anExtent [
	^ WDPPompeiiSurface extent: anExtent driver: self
]

{ #category : #'instance creation' }
WDPPompeiiDriver >> surfaceWithExtent: anExtent sampleCount: aSampleCount [
	^ WDPPompeiiSurface extent: anExtent driver: self sampleCount: aSampleCount
]

{ #category : #shaders }
WDPPompeiiDriver >> textureArrayColorShader [
	^ textureArrayColorShader ifNil: [ textureArrayColorShader := engine loadFragmentShader: 'shaders/pompeii/texturedArrayFragment.dastrel' ]
]

{ #category : #shaders }
WDPPompeiiDriver >> textureColorShader [
	^ textureColorShader ifNil: [ textureColorShader := engine loadFragmentShader: 'shaders/pompeii/texturedFragment.dastrel' ]
]

{ #category : #shaders }
WDPPompeiiDriver >> vertexShader [
	^ vertexShader ifNil: [ vertexShader := engine loadVertexShader: 'shaders/pompeii/genericVertex.dastrel' ]
]

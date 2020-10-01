Class {
	#name : #WDBBabylonDriver,
	#superclass : #BabylonDriver,
	#instVars : [
		'engine',
		'colorShader',
		'vertexShader',
		'colorFontShader',
		'textureColorShader',
		'textureArrayColorShader',
		'formTextureCache',
		'textureMaterialCache',
		'textureArrayMaterialCache',
		'grayTextureColorShader',
		'basicShaderLibrary',
		'grayTextureArrayColorShader'
	],
	#classVars : [
		'PrimitiveTypeMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon-Driver'
}

{ #category : #'as yet unclassified' }
WDBBabylonDriver class >> forEngine: anEngine [
	^ self basicNew initializeWithEngine: anEngine; yourself
]

{ #category : #initialization }
WDBBabylonDriver class >> initialize [
	PrimitiveTypeMap := Dictionary newFromPairs: { 
		BabylonSubmesh2D points . AGPU_POINTS .
		BabylonSubmesh2D lines . AGPU_LINES .
		BabylonSubmesh2D triangles . AGPU_TRIANGLES .
	}.

]

{ #category : #testing }
WDBBabylonDriver class >> isSupported [
	^ true
]

{ #category : #shaders }
WDBBabylonDriver >> basicShaderLibrary [
	^ basicShaderLibrary ifNil: [ basicShaderLibrary := engine loadShaderLibrary: 'shaders/babylon/basicShaders.dastrel' ]
]

{ #category : #shaders }
WDBBabylonDriver >> colorFontShader [
	^ colorFontShader ifNil: [ colorFontShader := self basicShaderLibrary getFragmentStage: #colorFont ]
]

{ #category : #shaders }
WDBBabylonDriver >> colorShader [
	^ colorShader ifNil: [ colorShader := self basicShaderLibrary getFragmentStage: #color ]
]

{ #category : #'as yet unclassified' }
WDBBabylonDriver >> convertMaterial: aMaterial [
	self flag: 'Implement myself'.
	^ aMaterial
]

{ #category : #'shape convertion' }
WDBBabylonDriver >> convertMesh2D: aPompeiiMesh [
	| vertices indices indexCount glSubmesh submeshes |
	vertices := SLVMNativeArray for: WDBCanvasVertex2D new: aPompeiiMesh vertices size.
	indices := SLVMNativeOrderedCollection for: #uint.
	aPompeiiMesh vertices doWithIndex: [ :vertex :index |
		vertices at: index put: vertex asWDBCanvasVertex2D
	].
	
	indexCount := 0.
	submeshes := aPompeiiMesh submeshes collect: [ :submesh |
		submesh indices do: [ :index |
			indices add: index
		].
		glSubmesh := WDBBabylonSubmesh new
			startIndex: indexCount;
			indexCount: submesh indices size;
			primitiveType: (self mapPrimitiveType: submesh primitiveType);
			material: (self convertMaterial: submesh material);
			yourself.
		indexCount := indexCount + glSubmesh indexCount.
		glSubmesh
	].

	^ WDBBabylonMesh2D new
		vertices: vertices asByteArray;
		indices: indices asByteArray;
		submeshes: submeshes;
		yourself
]

{ #category : #texture }
WDBBabylonDriver >> convertTexture: aTexture [
	^ formTextureCache at: aTexture ifAbsentPut: [ aTexture asSRGBTextureFor: engine ]
]

{ #category : #texture }
WDBBabylonDriver >> convertTextureArray: aTextureArray [
	^ formTextureCache at: aTextureArray ifAbsentPut: [ aTextureArray asSRGBTextureFor: engine ]
]

{ #category : #'instance creation' }
WDBBabylonDriver >> createFontCache: aLogicalFont [
	^ WDBBabylonFontCache new driver: self; font: aLogicalFont; yourself
]

{ #category : #'as yet unclassified' }
WDBBabylonDriver >> createMaterialForTexture: aTexture [
	^ textureMaterialCache at: aTexture ifAbsentPut: [
		WDBBabylonTextureMaterial new
			driver: self;
			texture: (self convertTexture: aTexture);
			yourself
		]
]

{ #category : #'as yet unclassified' }
WDBBabylonDriver >> createMaterialForTextureArray: aTextureArray element: aTextureElementIndex [
	^ textureArrayMaterialCache at: {aTextureArray . aTextureElementIndex} ifAbsentPut: [
		WDBBabylonTextureArrayElementMaterial new
			driver: self;
			textureArray: (self convertTextureArray: aTextureArray);
			elementIndex: aTextureElementIndex;
			yourself
		]
]

{ #category : #accessing }
WDBBabylonDriver >> engine [
	^ engine
]

{ #category : #shaders }
WDBBabylonDriver >> grayTextureArrayColorShader [
	^ grayTextureArrayColorShader ifNil: [ grayTextureArrayColorShader := self basicShaderLibrary getFragmentStage: #grayTexturedArray ]
]

{ #category : #shaders }
WDBBabylonDriver >> grayTextureColorShader [
	^ grayTextureColorShader ifNil: [ grayTextureColorShader := self basicShaderLibrary getFragmentStage: #grayTextured ]
]

{ #category : #initialization }
WDBBabylonDriver >> initialize [
	super initialize.
	engine ifNil: [ engine := WDCEngine default ].
	engine babylonDriver: self.
	formTextureCache := WeakValueDictionary new.
	textureMaterialCache := WeakValueDictionary new.
	textureArrayMaterialCache := WeakValueDictionary new.
]

{ #category : #initialization }
WDBBabylonDriver >> initializeWithEngine: anEngine [
	engine := anEngine.
	self initialize
]

{ #category : #'as yet unclassified' }
WDBBabylonDriver >> mapPrimitiveType: primitiveType [
	^ PrimitiveTypeMap at: primitiveType
]

{ #category : #'instance creation' }
WDBBabylonDriver >> surfaceWithExtent: anExtent [
	^ WDBBabylonSurface extent: anExtent driver: self
]

{ #category : #'instance creation' }
WDBBabylonDriver >> surfaceWithExtent: anExtent sampleCount: aSampleCount [
	^ WDBBabylonSurface extent: anExtent driver: self sampleCount: aSampleCount
]

{ #category : #shaders }
WDBBabylonDriver >> textureArrayColorShader [
	^ textureArrayColorShader ifNil: [ textureArrayColorShader := self basicShaderLibrary getFragmentStage: #texturedArray ]
]

{ #category : #shaders }
WDBBabylonDriver >> textureColorShader [
	^ textureColorShader ifNil: [ textureColorShader := self basicShaderLibrary getFragmentStage: #textured ]
]

{ #category : #shaders }
WDBBabylonDriver >> vertexShader [
	^ vertexShader ifNil: [ vertexShader := self basicShaderLibrary getVertexStage: #vertex ]
]

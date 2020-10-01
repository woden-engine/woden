Class {
	#name : #WDIGLTF2Importer,
	#superclass : #WDSSceneAssetModelLoader,
	#instVars : [
		'loadingDirectory',
		'buffers',
		'bufferViews',
		'accessors',
		'materials',
		'meshes',
		'nodes',
		'scenes',
		'convertedVertexChannels',
		'meshesToCleanup',
		'currentGLTFJson',
		'images',
		'samplers',
		'textures',
		'defaultMaterial'
	],
	#classVars : [
		'FullTypeToPixelName',
		'TypeToVectorSize'
	],
	#pools : [
		'AGPUConstants',
		'WDCVertexBindingConstants',
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #'class initialization' }
WDIGLTF2Importer class >> initialize [
	TypeToVectorSize := Dictionary newFromPairs: #(
		'SCALAR' 1
		'VEC2' 2
		'VEC3' 3
		'VEC4' 4
	).
	
	FullTypeToPixelName := Dictionary newFromPairs: { 
		{GL_UNSIGNED_BYTE . 'SCALAR'} . #byte.
		{GL_UNSIGNED_BYTE . 'VEC2'} . #byte2.
		{GL_UNSIGNED_BYTE . 'VEC3'} . #byte3.
		{GL_UNSIGNED_BYTE . 'VEC4'} . #byte4.

		{GL_UNSIGNED_SHORT . 'SCALAR'} . #ushort.
		{GL_UNSIGNED_SHORT . 'VEC2'} . #ushort2.
		{GL_UNSIGNED_SHORT . 'VEC3'} . #ushort3.
		{GL_UNSIGNED_SHORT . 'VEC4'} . #ushort4.

		{GL_UNSIGNED_INT . 'SCALAR'} . #uint.
		{GL_UNSIGNED_INT . 'VEC2'} . #uint2.
		{GL_UNSIGNED_INT . 'VEC3'} . #R32G32B32_UINT.
		{GL_UNSIGNED_INT . 'VEC4'} . #uint4.

		{GL_FLOAT . 'SCALAR'} . #float.
		{GL_FLOAT . 'VEC2'} . #float2.
		{GL_FLOAT . 'VEC3'} . #R32G32B32_FLOAT.
		{GL_FLOAT . 'VEC4'} . #float4.
	}
]

{ #category : #loading }
WDIGLTF2Importer >> cleanupMeshes [
	| indexBuffersToConvert indexCountToConvert indexBufferUsedByMesh haveTheSameIndexBuffer vertexDataToGenerateTangentSpace |
	"We may need to convert some index buffers"
	indexBuffersToConvert := IdentitySet new.
	vertexDataToGenerateTangentSpace := IdentityDictionary new.
	indexCountToConvert := 0.
	meshesToCleanup do: [ :mesh |
		mesh submeshes do: [ :submesh |
			(submesh material requiresTangentSpaceData and: [submesh vertexData hasVertexTangents not]) ifTrue: [
				(vertexDataToGenerateTangentSpace at: submesh vertexData ifAbsentPut: [ OrderedCollection new ])
					add: submesh
			].
		
			submesh indexBufferAccessor type size < 2 ifTrue: [
				(indexBuffersToConvert includes: submesh indexBufferAccessor) ifFalse: [ 
					indexBuffersToConvert add: submesh indexBufferAccessor.
					indexCountToConvert := indexCountToConvert + submesh indexBufferAccessor count
				].
			].
		]
	].

	vertexDataToGenerateTangentSpace ifNotEmpty: [ 
		self generateMissingVertexTangentSpaceFrames: vertexDataToGenerateTangentSpace
	].

	indexBuffersToConvert ifNotEmpty: [
		self convertIndices: indexCountToConvert withAccessors: indexBuffersToConvert
	].

	"We now have all the meshes and submeshes with the proper format."
	meshesToCleanup do: [ :mesh |
		mesh submeshes: (mesh submeshes collect: #asWDCGenericSubmesh) asArray.
		mesh submeshes ifNotEmpty: [ 
			indexBufferUsedByMesh := mesh submeshes first indexBuffer.
			haveTheSameIndexBuffer := mesh submeshes detect: [ :submesh | submesh indexBuffer ~~ indexBufferUsedByMesh] ifFound: [ false ] ifNone: [ true ].
			haveTheSameIndexBuffer ifTrue: [
				mesh indexBuffer: indexBufferUsedByMesh.
				mesh submeshes do: [ :sm | sm indexBuffer: nil ]
			].
		]
	].

]

{ #category : #'as yet unclassified' }
WDIGLTF2Importer >> computeTangent4WithTangent: rawTangent bitangent: rawBitangent normal: normal [
	| tangent bitangent scaleFactor |
	
	((rawTangent closeTo: Float32x3 zeros) and: [ rawBitangent closeTo: Float32x3 zeros ]) ifTrue: [ 
		^ self computeTangent4WithTangent: (Float32x3 x: 1.0) bitangent: (Float32x3 y: 1.0) normal: normal
	].

	"Gram schmidth orthogonalization"
	tangent := (rawTangent - (normal * (normal dot: rawTangent))) normalized.
	bitangent := (rawBitangent - (normal * (normal dot: rawBitangent)) - (tangent * (tangent dot: rawBitangent))) normalized.
	scaleFactor := (normal cross: tangent) dot: bitangent.
	^ Float32x4 x: tangent x y: tangent y z: tangent z w: scaleFactor.

]

{ #category : #loading }
WDIGLTF2Importer >> convertIndices: indexCountToConvert withAccessors: indexBuffersToConvert [
	| newIndexType newIndexDataArray destIndex sourceIndices newIndexBuffer startOffset |
	newIndexType := indexCountToConvert > ((1<<16) - 2)
		ifTrue: [ WDCStructureFieldType typeNamed: #uint ]
		ifFalse: [ WDCStructureFieldType typeNamed: #ushort ].

	newIndexDataArray := SLVMNativeArray for: newIndexType slvmType new: indexCountToConvert.
	newIndexBuffer := WDCBufferResource new
		description: (AGPUBufferDescription new
			size: newIndexDataArray rawData size;
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			usage_modes: AGPU_ELEMENT_ARRAY_BUFFER;
			main_usage_mode: AGPU_ELEMENT_ARRAY_BUFFER;
			stride: newIndexDataArray elementSize;
			yourself);
		data: newIndexDataArray rawData;
		yourself.
		
	destIndex := 1.
	indexBuffersToConvert do: [ :accessor |
		startOffset := destIndex - 1.
		sourceIndices := accessor asNativeArrayReference.
		sourceIndices do: [ :index |
			newIndexDataArray at: destIndex put: index.
			destIndex := destIndex + 1
		].
	
		accessor
			bufferView: (WDCBufferView new
				buffer: newIndexBuffer;
				offset: startOffset;
				length: (destIndex - startOffset) * newIndexType size;
				yourself);
				type: newIndexType.
	].

]

{ #category : #'as yet unclassified' }
WDIGLTF2Importer >> generateMissingVertexTangentSpaceFrames: vertexDataWithSubmeshesDictionary [
	| encodedTangent4 tangent4BufferView encodedTangent4Data |
	encodedTangent4 := StdnVector newFor: Float32x4.
	tangent4BufferView := WDCBufferView new.
	
	vertexDataWithSubmeshesDictionary keysAndValuesDo: [ :vertex :submeshes |
		self generateVertexDataTangentSpaceFrame: vertex submeshes: submeshes into: encodedTangent4 withBufferView: tangent4BufferView
	].
	
	encodedTangent4Data := encodedTangent4 asByteArray.
	tangent4BufferView 
		buffer: (WDCBufferResource new
			description: (AGPUBufferDescription new
				size: encodedTangent4Data size;
				heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
				usage_modes: AGPU_ARRAY_BUFFER;
				main_usage_mode: AGPU_ARRAY_BUFFER;
				yourself);
			data: encodedTangent4Data;
			yourself);
		offset: 0;
		length: encodedTangent4Data size.

]

{ #category : #'as yet unclassified' }
WDIGLTF2Importer >> generateVertexDataTangentSpaceFrame: vertexData submeshes: submeshes into: encodedTangents4 withBufferView: tangent4BufferView [
	| positionChannel texcoordsChannel normalsChannel vertexCount tangents bitangents triangleIterator i1 i2 i3 p1 p2 p3 tc1 tc2 tc3 u v du1 dv1 du2 dv2 det den tangent bitangent normal tangent4Accessor channel |
	positionChannel := vertexData positionsChannel asNativeArrayReference.
	texcoordsChannel := vertexData texcoordsChannel asNativeArrayReference.
	normalsChannel := vertexData normalsChannel asNativeArrayReference.
	
	self assert: positionChannel size = texcoordsChannel size.
	self assert: texcoordsChannel size = normalsChannel size.
	
	vertexCount := positionChannel size.
	tangents := (Array new: vertexCount) atAllPut: Float32x3 new.
	bitangents := (Array new: vertexCount) atAllPut: Float32x3 new.
	
	triangleIterator := WDCSubmeshTriangleIterator new submeshes: submeshes.
	triangleIterator do: [ :triangle |
		i1 := triangle first + 1.
		i2 := triangle second + 1.
		i3 := triangle third + 1.
		
		p1 := (positionChannel at: i1) asWMVector3.
		p2 := (positionChannel at: i2) asWMVector3.
		p3 := (positionChannel at: i3) asWMVector3.

		tc1 := texcoordsChannel at: i1.
		tc2 := texcoordsChannel at: i2.
		tc3 := texcoordsChannel at: i3.

		u := p2 - p1.
		v := p3 - p1.
		
		du1 := tc2 x - tc1 x.
		dv1 := tc2 y - tc1 y.
		
		du2 := tc3 x - tc1 x.
		dv2 := tc3 y - tc1 y.
		
		det := (du1*dv2) - (du2*dv1).
		(det closeTo: 0.0) ifFalse: [ 
			den := 1.0 / det.
			
			tangent := (u * (den*dv2))  - (v * (den*dv1)).
			bitangent := (v * (den*du1)) - (u * (den*du2)).
			
			tangents at: i1 put: (tangents at: i1) + tangent.
			tangents at: i2 put: (tangents at: i2) + tangent.
			tangents at: i3 put: (tangents at: i3) + tangent.

			bitangents at: i1 put: (bitangents at: i1) + bitangent.
			bitangents at: i2 put: (bitangents at: i2) + bitangent.
			bitangents at: i3 put: (bitangents at: i3) + bitangent.
		].
	].

	tangent4Accessor := WDCBufferAccessor new
		type: (WDCStructureFieldType typeNamed: #float4);
		bufferView: tangent4BufferView;
		byteOffset: encodedTangents4 size * Float32x4 instanceSize;
		count: vertexCount;
		yourself.

	channel := WDCMeshExplicitVertexChannel new
		binding: Tangents4VertexBindingLocation;
		accessor: tangent4Accessor;
		yourself.
	vertexData addChannel: channel.

	1 to: vertexCount do: [ :vertexIndex |
		tangent := tangents at: vertexIndex.
		bitangent := bitangents at: vertexIndex.
		normal := (normalsChannel at: vertexIndex) asFloat32x3.

		encodedTangents4 add: (self computeTangent4WithTangent: tangent bitangent: bitangent normal: normal)
	].

]

{ #category : #loading }
WDIGLTF2Importer >> getBinaryDataChunkWithIndex: binaryChunkIndex [
	self error: 'Missing required binary data specification.'
]

{ #category : #loading }
WDIGLTF2Importer >> loadAccessorFrom: accessorDescription [
	| bufferView componentType type count pixelFormatName byteOffset minValues maxValues max min |
	bufferView := bufferViews at: (accessorDescription at: 'bufferView') + 1.
	componentType := accessorDescription at: 'componentType'.
	type := accessorDescription at: 'type'.
	count := accessorDescription at: 'count'.
	byteOffset := accessorDescription at: 'byteOffset' ifAbsent: [0].
	minValues := accessorDescription at: 'min' ifAbsent: [nil].
	maxValues := accessorDescription at: 'max' ifAbsent: [nil].

	min := max := nil.	
	(minValues isNotNil and: [ maxValues isNotNil ]) ifTrue: [ 
		type = 'SCALAR' ifTrue: [
			min := minValues first.
			max := maxValues first.
		].

		type = 'VEC2' ifTrue: [
			min := Float32x2 x: minValues first y: minValues second.
			max := Float32x2 x: maxValues first y: maxValues second.
		].

		type = 'VEC3' ifTrue: [
			min := Float32x3 x: minValues first y: minValues second z: minValues third.
			max := Float32x3 x: maxValues first y: maxValues second z: maxValues third.
		].

		type = 'VEC4' ifTrue: [
			min := Float32x4 x: minValues first y: minValues second z: minValues third w: minValues fourth.
			max := Float32x4 x: maxValues first y: maxValues second z: maxValues third w: maxValues fourth.
		].

	].

	pixelFormatName := FullTypeToPixelName at: { componentType . type }.
	accessors add: (WDCBufferAccessor new
		bufferView: bufferView;
		byteOffset: byteOffset;
		type: (WDCStructureFieldType typeNamed: pixelFormatName);
		count: count;
		min: min;
		max: max;
		yourself)
]

{ #category : #loading }
WDIGLTF2Importer >> loadAccessorsFrom: elements [
	accessors := OrderedCollection new.
	elements do: [ :el | self loadAccessorFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadBinaryDataFromURI: uri [
	| absolutePath |
	absolutePath := loadingDirectory resolve: uri asFileReference.
	^ absolutePath binaryReadStreamDo: [ :in | in contents ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadBuffer: bufferIndex from: bufferDescription [
	| byteLength description data |
	data := bufferDescription at: 'uri'
		ifPresent: [ :uri | self loadBinaryDataFromURI: uri ]
		ifAbsent: [ self getBinaryDataChunkWithIndex: bufferIndex ].
	byteLength := bufferDescription at: 'byteLength'.
	description := AGPUBufferDescription new
		size: byteLength;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_ARRAY_BUFFER | AGPU_ELEMENT_ARRAY_BUFFER;
		main_usage_mode: AGPU_ARRAY_BUFFER | AGPU_ELEMENT_ARRAY_BUFFER;
		yourself.
	self assert: data size >= byteLength.
	buffers add: (WDCBufferResource new
		description: description;
		data: data;
		yourself)
]

{ #category : #loading }
WDIGLTF2Importer >> loadBufferViewFrom: viewDescription [
	bufferViews add: (WDCBufferView new
		buffer: (buffers at: (viewDescription at: 'buffer') + 1);
		offset: (viewDescription at: 'byteOffset' ifAbsent: [0]);
		length: (viewDescription at: 'byteLength');
		yourself)
]

{ #category : #loading }
WDIGLTF2Importer >> loadBufferViewsFrom: elements [
	bufferViews := OrderedCollection new.
	elements do: [ :el | self loadBufferViewFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadBuffersFrom: elements [
	buffers := OrderedCollection new.
	elements doWithIndex: [ :el :index | self loadBuffer: index from: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadImageFrom: imageDescription [
	| imageData imageReader imageName image |
	imageData := nil.
	imageReader := nil.
	imageName := imageDescription at: 'name' ifAbsent: [  ].

	imageDescription at: 'uri' ifPresent: [ :uri |
		imageData := self loadBinaryDataFromURI: uri.
		imageReader := imageDescription at: 'mimeType' ifPresent: [ :mimeType |
			WDCTextureReader loaderForMimeType: mimeType
		] ifAbsent: [
			WDCTextureReader loaderForExtension: (ZnUrl fromString: uri) path asFileReference extension.
		]
	].

	imageDescription at: 'bufferView' ifPresent: [ :bufferViewIndex |
		imageData := bufferViews at: bufferViewIndex + 1.
		imageReader := WDCTextureReader loaderForMimeType: (imageDescription at: 'mimeType')
	].

	image := WDIGLTF2Image new
		name: imageName;
		imageData: imageData;
		imageReader: imageReader;
		yourself.
	images add: image
]

{ #category : #loading }
WDIGLTF2Importer >> loadImagesFrom: elements [
	images := OrderedCollection new.
	elements do: [ :element | self loadImageFrom: element ].
]

{ #category : #loading }
WDIGLTF2Importer >> loadMaterialFrom: materialDescription [
	| material materialReference |
	material := nil.
	materialReference := nil.
	materialDescription at: 'extras' ifPresent: [ :extras |
		extras at: 'woden.material.override' ifPresent: [ :materialName |
			materialReference := WDCMaterialReference new name: materialName
		]
	].

	material ifNil: [ 
		materialDescription at: 'pbrMetallicRoughness' ifPresent: [ :description |
			material := self loadMetallicRoughnessMaterial: description commonDescription: materialDescription
		].
	].

	material ifNil: [ material := WDCMetallicRoughnessMaterial new ].
	materialReference ifNotNil: [ 
		materialReference fallbackMaterial: material.
		materials add: materialReference
	] ifNil: [ 
		materials add: material
	].

]

{ #category : #loading }
WDIGLTF2Importer >> loadMaterialsFrom: elements [
	materials := OrderedCollection new.
	elements do: [ :el | self loadMaterialFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadMeshFrom: meshDescription [
	| name renderable meshComponents |
	name := meshDescription at: 'name' ifAbsent: [nil].
	renderable := nil.
	meshDescription at: 'primitives' ifPresent: [ :primitives |
		meshComponents := self loadMeshPrimitives: primitives.
		meshComponents size = 1 ifTrue: [
			renderable := meshComponents first.
		] ifFalse: [
			renderable := WDCCompositeRenderable new
				renderables: meshComponents asArray;
				yourself
		]
	].

	meshDescription at: 'extras' ifPresent: [ :extras |
		extras at: 'woden.renderable.type' ifPresent: [ :type |
			type = 'water' ifTrue: [ renderable := renderable asWaterRenderable ]
		]
	].

	meshes add: (renderable
		name: name;
		yourself)
]

{ #category : #loading }
WDIGLTF2Importer >> loadMeshPrimitives: primitives [
	| submeshes convertedMeshes vertexDataMeshDictionary mesh |
	submeshes := primitives collect: [ :submeshDescription |
		self loadSubMeshFrom: submeshDescription
	].

	convertedMeshes := OrderedCollection new.
	vertexDataMeshDictionary := Dictionary new.
	
	submeshes do: [ :submesh |
		mesh := vertexDataMeshDictionary at: submesh vertexData ifAbsentPut: [
			| newMesh positionsAccessor |
			positionsAccessor := submesh vertexData positionsChannel accessor.
			newMesh := WDCGenericMesh new
				vertexData: submesh vertexData;
				submeshes: OrderedCollection new;
				boundingBox: (BoxF32 min: positionsAccessor min max: positionsAccessor max);
				yourself.
			convertedMeshes add: newMesh.
			meshesToCleanup add: newMesh.
			vertexDataMeshDictionary at: submesh vertexData put: newMesh.
			newMesh
		].
	
		mesh submeshes add: submesh.
		submesh material setupRenderableTranslucency: mesh
	].
	
	^ convertedMeshes
]

{ #category : #loading }
WDIGLTF2Importer >> loadMeshesFrom: elements [
	meshes := OrderedCollection new.
	meshesToCleanup := OrderedCollection new.
	convertedVertexChannels := Dictionary new.
	elements do: [ :el | self loadMeshFrom: el ].
	self cleanupMeshes
]

{ #category : #loading }
WDIGLTF2Importer >> loadMetallicRoughnessMaterial: description commonDescription: commonDescription [
	| material occlusionTexture metallicRoughnessTexture |
	material := WDCMetallicRoughnessMaterial new.
	description at: 'baseColorFactor' ifPresent: [ :baseColor |
		material albedoColor: (Float32x4 x: baseColor first y: baseColor second z: baseColor third w: baseColor fourth)
	] ifAbsent: [
		material albedoColor: (Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0)
	].

	material
		metallicFactor: (description at: 'metallicFactor' ifAbsent: [1.0]);
		roughnessFactor: (description at: 'roughnessFactor' ifAbsent: [1.0]).
		
	description at: 'baseColorTexture' ifPresent: [ :textureDescription |
		material albedoTexture: (textures at: (textureDescription at: 'index') + 1) asSRGBTexture
	].

	commonDescription at: 'normalTexture' ifPresent: [ :textureDescription |
		material normalTexture: (textures at: (textureDescription at: 'index') + 1) asNormalTexture
	].
	
	occlusionTexture := nil.
	commonDescription at: 'occlusionTexture' ifPresent: [ :textureDescription |
		occlusionTexture := textures at: (textureDescription at: 'index') + 1
	].

	metallicRoughnessTexture := nil.
	description at: 'metallicRoughnessTexture' ifPresent: [ :textureDescription |
		metallicRoughnessTexture := textures at: (textureDescription at: 'index') + 1.
	].

	(occlusionTexture isNotNil or: [ metallicRoughnessTexture isNotNil ]) ifTrue: [ 
		metallicRoughnessTexture ifNotNil: [ 
			material metallicRoughnessTexture: (metallicRoughnessTexture asMetallicRoughnessTextureCombinedWithAO: occlusionTexture)
		] ifNil: [ 
			material metallicRoughnessTexture: occlusionTexture asTexture
		].
	].

	material doubleSided: (commonDescription at: 'doubleSided' ifAbsent: [false]).
	commonDescription at: 'alphaMode' ifPresent: [ :alphaMode |
		alphaMode = 'MASK' ifTrue: [
			material alphaCutoff: (commonDescription at: 'alphaCutoff' ifAbsent: [0.5])
		].
		alphaMode = 'BLEND' ifTrue: [
			material translucent: true
		].
	].

	commonDescription at: 'emissiveFactor' ifPresent: [ :factor |
		material emissionColor: (Float32x4 x: factor first y: factor second z: factor third w: 0.0)
	] ifAbsent: [
		material emissionColor: Float32x4 zeros
	].

	commonDescription at: 'emissiveTexture' ifPresent: [ :textureDescription |
		material emissionTexture: (textures at: (textureDescription at: 'index') + 1) asSRGBTexture
	].

	^ material
]

{ #category : #loading }
WDIGLTF2Importer >> loadNode: node childrenFrom: nodeDescription [
	nodeDescription at: 'children' ifPresent: [ :children |
		children do: [ :childIndex |
			node addChild: (nodes at: childIndex + 1)
		]
	]
	
]

{ #category : #loading }
WDIGLTF2Importer >> loadNodeFrom: nodeDescription [
	| node cameraDescription perspective matrix |
	nodeDescription at: 'mesh' ifPresent: [ :meshIndex |
		node := WDSGSpatialObject new.
		node renderable: (meshes at: meshIndex + 1)
	].

	nodeDescription at: 'camera' ifPresent: [ :cameraIndex |
		node := WDSGCamera new.
		cameraDescription := (currentGLTFJson at: 'cameras') at: cameraIndex + 1.
		perspective := cameraDescription at: 'perspective'.
		node
			fieldOfView: (perspective at: 'yfov') radiansToDegrees;
			nearDistance: (perspective at: 'znear');
			farDistance: (perspective at: 'zfar').
	].

	node ifNil: [ node := WDSGSpatialObject new ].
	
	nodeDescription at: 'matrix' ifPresent: [ :matrixElements |
		node transform: (ReversibleAffineTransform3dF32 fromInvertibleMatrix4: (Float32x4x4 newFrom: matrixElements) transposed).
	].

	nodeDescription at: 'scale' ifPresent: [ :scaleComponent |
		node transform scaleByX: scaleComponent first y: scaleComponent second z: scaleComponent third
	].

	nodeDescription at: 'rotation' ifPresent: [ :rotationComponent |
		node transform applyOrthonormalMatrix: (QuaternionF32 r: rotationComponent fourth i: rotationComponent first j: rotationComponent second k: rotationComponent third) asFloat32x3x3
	].

	nodeDescription at: 'translation' ifPresent: [ :translationComponent |
		node transform translateToX: translationComponent first y: translationComponent second z: translationComponent third
	].


	node name: (nodeDescription at: 'name' ifAbsent: [ nil ]).
	nodes add: node.

]

{ #category : #loading }
WDIGLTF2Importer >> loadNodesFrom: elements [
	nodes := OrderedCollection new.
	elements do: [ :el | self loadNodeFrom: el ].
	elements doWithIndex: [ :el :index | self loadNode: (nodes at: index) childrenFrom: el]
]

{ #category : #loading }
WDIGLTF2Importer >> loadSamplerFrom: samplerDescription [
	| sampler |
	sampler := WDIGLTF2Sampler new.
	self flag: 'TODO: Parse the sampler description.'.
	samplers add: sampler
]

{ #category : #loading }
WDIGLTF2Importer >> loadSamplersFrom: elements [
	samplers := OrderedCollection new.
	elements do: [ :el | self loadSamplerFrom: el ].
]

{ #category : #loading }
WDIGLTF2Importer >> loadSceneFrom: sceneDescription [
	| scene |
	scene := WDSGScene new.
	scene name: (sceneDescription at: 'name' ifAbsent: [ nil ]).
	sceneDescription at: 'nodes' ifPresent: [ :nodeIndices |
		nodeIndices do: [ :nodeIndex |
			scene add: (nodes at: nodeIndex + 1 )
		]
	].
	
	scenes add: scene
]

{ #category : #loading }
WDIGLTF2Importer >> loadScenesFrom: elements [
	scenes := OrderedCollection new.
	elements do: [ :el | self loadSceneFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadSubMeshFrom: submeshDescription [
	| vertexChannels attributes channel vertexData indexBufferAccessor material |
	attributes := submeshDescription at: 'attributes'.
	indexBufferAccessor := accessors at: (submeshDescription at: 'indices') + 1.
	submeshDescription at: 'material' ifPresent: [ :materialIndex |
		material := materials at: materialIndex + 1.
	] ifAbsent: [ 
		material := self validDefaultMaterial
	].

	vertexChannels := OrderedCollection new.
	attributes keysAndValuesDo: [ :attributeName :attributeBinding |
		channel := self loadVertexChannel: attributeName boundTo: (accessors at: attributeBinding + 1).
		channel binding ifNotNil: [ 
			vertexChannels add: channel
		].
	].

	vertexChannels := vertexChannels asArray.
	vertexChannels sort: [ :a :b | a binding <= b binding ].
	
	vertexData := convertedVertexChannels at: vertexChannels ifAbsentPut: [ WDCMeshExplicitSeparatedVertexData new
		channels: vertexChannels;
		vertexCount: vertexChannels first accessor count;
		yourself
	].

	^ WDIGLTF2SubMesh new
		vertexData: vertexData;
		indexBufferAccessor: indexBufferAccessor;
		material: material;
		primitiveType: AGPU_TRIANGLES;
		yourself

]

{ #category : #loading }
WDIGLTF2Importer >> loadTextureFrom: textureDescription [
	| texture |
	texture := WDIGLTF2Texture new.
	textureDescription at: 'sampler' ifPresent: [ :samplerIndex |
		texture sampler: (samplers at: samplerIndex + 1)
	].

	textureDescription at: 'source' ifPresent: [ :sourceIndex |
		texture image: (images at: sourceIndex + 1)
	].

	textures add: texture	
]

{ #category : #loading }
WDIGLTF2Importer >> loadTexturesFrom: elements [
	textures := OrderedCollection new.
	elements do: [ :el | self loadTextureFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadVertexChannel: vertexChannelName boundTo: accessor [
	^ convertedVertexChannels at: {vertexChannelName . accessor} ifAbsentPut: [
		WDCMeshExplicitVertexChannel new
			binding: (WDCMeshExplicitVertexChannel getBindingNamed: vertexChannelName ifAbsent: [nil]);
			accessor: accessor;
			yourself
	]
	
]

{ #category : #accessing }
WDIGLTF2Importer >> loadingDirectory [
	^ loadingDirectory
]

{ #category : #accessing }
WDIGLTF2Importer >> loadingDirectory: anObject [
	loadingDirectory := anObject
]

{ #category : #loading }
WDIGLTF2Importer >> processGLTFJson: json [
	| asset |
	currentGLTFJson := json.
	asset := WDSSceneAssetModel new.

	json at: 'buffers' ifPresent: [ :elements | self loadBuffersFrom: elements ].
	json at: 'bufferViews' ifPresent: [ :elements | self loadBufferViewsFrom: elements ].
	json at: 'accessors' ifPresent: [ :elements | self loadAccessorsFrom: elements ].
	json at: 'samplers' ifPresent: [ :elements | self loadSamplersFrom: elements ].
	json at: 'images' ifPresent: [ :elements | self loadImagesFrom: elements ].
	json at: 'textures' ifPresent: [ :elements | self loadTexturesFrom: elements ].
	json at: 'materials' ifPresent: [ :elements | self loadMaterialsFrom: elements ].
	json at: 'meshes' ifPresent: [ :elements | self loadMeshesFrom: elements ].
	json at: 'nodes' ifPresent: [ :elements | self loadNodesFrom: elements ].
	json at: 'scenes' ifPresent: [ :elements | self loadScenesFrom: elements ].
	
	asset scenes: scenes asArray.
	json at: 'scene' ifPresent: [ :mainSceneIndex |
		asset mainScene: (scenes at: mainSceneIndex + 1)
	].
	^ asset
]

{ #category : #'as yet unclassified' }
WDIGLTF2Importer >> validDefaultMaterial [
	^ defaultMaterial ifNil: [ defaultMaterial := WDCMetallicRoughnessMaterial new  ]
]

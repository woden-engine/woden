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
		'currentGLTFJson'
	],
	#classVars : [
		'FullTypeToPixelName',
		'TypeToVectorSize'
	],
	#pools : [
		'AGPUConstants',
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
	| indexBuffersToConvert indexCountToConvert indexBufferUsedByMesh haveTheSameIndexBuffer |
	"We may need to convert some index buffers"
	indexBuffersToConvert := IdentitySet new.
	indexCountToConvert := 0.
	meshesToCleanup do: [ :mesh |
		mesh submeshes do: [ :submesh |
			submesh indexBufferAccessor type size < 2 ifTrue: [
				(indexBuffersToConvert includes: submesh indexBufferAccessor) ifFalse: [ 
					indexBuffersToConvert add: submesh indexBufferAccessor.
					indexCountToConvert := indexCountToConvert + submesh indexBufferAccessor count
				].
			].
		]
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
			usage: AGPU_STATIC;
			binding: AGPU_ELEMENT_ARRAY_BUFFER;
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

{ #category : #loading }
WDIGLTF2Importer >> getBinaryDataChunkWithIndex: binaryChunkIndex [
	self error: 'Missing required binary data specification.'
]

{ #category : #loading }
WDIGLTF2Importer >> loadAccessorFrom: accessorDescription [
	| bufferView componentType type count pixelFormatName |
	bufferView := bufferViews at: (accessorDescription at: 'bufferView') + 1.
	componentType := accessorDescription at: 'componentType'.
	type := accessorDescription at: 'type'.
	count := accessorDescription at: 'count'.
	pixelFormatName := FullTypeToPixelName at: { componentType . type }.
	accessors add: (WDCBufferAccessor new
		bufferView: bufferView;
		type: (WDCStructureFieldType typeNamed: pixelFormatName);
		count: count;
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
		usage: AGPU_STATIC;
		binding: AGPU_ARRAY_BUFFER | AGPU_ELEMENT_ARRAY_BUFFER;
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
		offset: (viewDescription at: 'byteOffset');
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
WDIGLTF2Importer >> loadMaterialFrom: materialDescription [
	| material |
	material := nil.
	materialDescription at: 'pbrMetallicRoughness' ifPresent: [ :description |
		material := self loadMetallicRoughnessMaterial: description
	].
	material ifNil: [ material := WDCMetallicRoughnessMaterial new ].
	materials add: material
]

{ #category : #loading }
WDIGLTF2Importer >> loadMaterialsFrom: elements [
	materials := OrderedCollection new.
	elements do: [ :el | self loadMaterialFrom: el ]
]

{ #category : #loading }
WDIGLTF2Importer >> loadMeshFrom: meshDescription [
	| name renderable |
	name := meshDescription at: 'name'.
	renderable := nil.
	meshDescription at: 'primitives' ifPresent: [ :primitives |
		meshes := self loadMeshPrimitives: primitives.
		meshes size = 1 ifTrue: [
			renderable := meshes first.
		] ifFalse: [
			"TODO: Mult mesh renderable"
			self halt.
		]
	].

	^ renderable
		name: name;
		yourself
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
			| newMesh |
			newMesh := WDCGenericMesh new
				vertexData: submesh vertexData;
				submeshes: OrderedCollection new;
				yourself.
			convertedMeshes add: newMesh.
			meshesToCleanup add: newMesh.
			vertexDataMeshDictionary at: submesh vertexData put: newMesh.
			newMesh
		].
	
		mesh submeshes add: submesh
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
WDIGLTF2Importer >> loadMetallicRoughnessMaterial: description [
	| material |
	material := WDCMetallicRoughnessMaterial new.
	description at: 'baseColorFactor' ifPresent: [ :baseColor |
		material albedoColor: (WMVector4F x: baseColor first y: baseColor second z: baseColor third w: baseColor fourth)
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
		matrix := WMMatrix4F newFrom: matrixElements.
		self halt
	].

	nodeDescription at: 'scale' ifPresent: [ :scaleComponent |
		node transform scaleByX: scaleComponent first y: scaleComponent second z: scaleComponent third
	].

	nodeDescription at: 'rotation' ifPresent: [ :rotationComponent |
		node transform applyOrthonormalMatrix: (WMQuaternionF r: rotationComponent fourth i: rotationComponent first j: rotationComponent second k: rotationComponent third) asWMMatrix3F
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
	material := materials at: (submeshDescription at: 'material') + 1.

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

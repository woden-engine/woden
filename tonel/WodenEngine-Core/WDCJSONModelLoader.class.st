"
I am custom JSON based woden model loader.
"
Class {
	#name : #WDCJSONModelLoader,
	#superclass : #WDCModelLoader,
	#instVars : [
		'interleaveVertexData',
		'vertices',
		'submeshes',
		'indices',
		'baseIndex',
		'addExplicitWhiteColor'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCJSONModelLoader class >> convert: modelFileName materialMap: materialMapOrArray toFuel: fuelModel [
	| model materialMap |
	model := self new loadFromFileNamed: modelFileName.
	materialMap := materialMapOrArray.
	materialMap isArray ifTrue: [
		materialMap := Dictionary newFrom: materialMap.
	].

	model mapMaterials: materialMap.
	FLSerializer serialize: model toFileNamed: fuelModel
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader class >> convert: modelFileName singleMaterial: materialName toFuel: fuelModel [
	| model |
	model := self new loadFromFileNamed: modelFileName.
	model combineSubmeshesWithMaterial: materialName.
	FLSerializer serialize: model toFileNamed: fuelModel
]

{ #category : #accessing }
WDCJSONModelLoader class >> extension [
	^ 'wmjson'
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> createWhiteColorChannelOfSize: vertexCount [
	| description channelData vectorClass white |
	description := WDCSeparatedVertexData vertexChannelDescriptions at: #colors.

	vectorClass := description type slvmType.
	
	vectorClass ifNil: [
		self error: 'Cannot decoded channel without an associated class.'
	].
	
	channelData := SLVMNativeArray for: vectorClass new: vertexCount.
	white := vectorClass x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	1 to: vertexCount do: [ :i | channelData at: i put: white ].

	^ WDCMeshVertexChannel new
		description: description;
		data: channelData;
		yourself
]

{ #category : #initialization }
WDCJSONModelLoader >> initialize [
	super initialize.
	interleaveVertexData := false.
	addExplicitWhiteColor := true.
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadAction: actionData [
	| actionBones |
	actionBones := (actionData at: 'bones') collect: [:actionBone | self loadActionBone: actionBone ].
	^ WDCAnimationAction new
		name: (actionData at: 'name');
		bones: actionBones;
		yourself
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadActionBone: actionBoneData [
	| boneIndex keyframes keyframesData |
	boneIndex := actionBoneData at: 'index'.
	keyframesData := actionBoneData at: 'keyframes'.
	keyframes := SLVMNativeArray for: WTAnimationActionBoneFrame new: keyframesData size.
	keyframesData doWithIndex: [ :kf :index |
		keyframes at: index put: (WTAnimationActionBoneFrame new
			rotation: (self loadQuaternion: (kf at: 'rotation'));
			translation: (self loadVector3: (kf at: 'translation'));
			yourself
		)
	].

	^ WDCAnimationActionBone new
		boneIndex: boneIndex;
		keyframes: keyframes;
		yourself
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadActions: actionsData [
	| actions |
	actions := Dictionary new.
	actionsData do: [ :actionData |
		actions at: (actionData at: 'name') put: (self loadAction: actionData).
	].

	^ actions
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadArmature: armatureData [
	| bones names location orientation parentIndex boneParents |
	names := armatureData collect: [ :boneData | boneData at: 'name' ].
	boneParents := SLVMNativeArray for: #int new: armatureData size.
	bones := SLVMNativeArray for: WTAnimationActionBoneFrame new: armatureData size.
	armatureData doWithIndex: [ :boneData :index |
		location := self loadVector3: (boneData at: 'location').
		orientation := self loadQuaternion: (boneData at: 'orientation').
		parentIndex := boneData at: 'parent'.
		boneParents at: index put: parentIndex.
		bones at: index put: (WTAnimationActionBoneFrame new
			translation: location;
			rotation: orientation;
			yourself)
	].

	^ WDCModelArmature new names: names; boneParents: boneParents; bones: bones; yourself
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadBoneWeightsChannelClass: vectorClass elements: channelElements sourceData: sourceData [
	| result sourceIndex x y z w sum den |
	result := SLVMNativeArray for: vectorClass new: channelElements.
	sourceIndex := 1.
	1 to: channelElements do: [ :destIndex |
		x := sourceData at: sourceIndex.
		y := sourceData at: sourceIndex + 1.
		z := sourceData at: sourceIndex + 2.
		w := sourceData at: sourceIndex + 3.
		
		sum := x + y + z + w.
		den := (sum closeTo: 0.0) ifTrue: [ 1.0 ] ifFalse: [ sum ].
		result at: destIndex put: (vectorClass x: x / den y: y / den z: z / den w: w / den).
		sourceIndex := sourceIndex + 4
	].
	^ result
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadBoundingBox: bboxData [
	| min max |
	min := WMVector3F x: (bboxData at: 1) y: (bboxData at: 2) z: (bboxData at: 3).
	max := WMVector3F x: (bboxData at: 4) y: (bboxData at: 5) z: (bboxData at: 6).
	^ WMBox3DF min: min max: max
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadChannelNamed: channelName vectorSize: vectorSize vectorClass: vectorClass elements: channelElements sourceData: sourceData [
	channelName = #boneWeights ifTrue: [ ^ self loadBoneWeightsChannelClass: vectorClass elements: channelElements sourceData: sourceData ].
	vectorSize = 1 ifTrue: [ ^ self loadScalarChannelClass: vectorClass elements: channelElements sourceData: sourceData].
	vectorSize = 2 ifTrue: [ ^ self loadVector2ChannelClass: vectorClass elements: channelElements sourceData: sourceData].
	vectorSize = 3 ifTrue: [ ^ self loadVector3ChannelClass: vectorClass elements: channelElements sourceData: sourceData].
	vectorSize = 4 ifTrue: [ ^ self loadVector4ChannelClass: vectorClass elements: channelElements sourceData: sourceData].
	self error: 'Cannot load channel with vector size ' , vectorSize printString
]

{ #category : #private }
WDCJSONModelLoader >> loadFrom: jsonData [
	| boundingBox armature actions |
	self loadVertices: (jsonData at: 'vertices').
	submeshes := self loadSubmeshes: (jsonData at: 'submeshes').
	boundingBox := self loadBoundingBox: (jsonData at: 'boundingBox').
	armature := nil.
	actions := nil.
	jsonData at: 'armature' ifPresent: [ :armatureData | armature := self loadArmature: armatureData ].
	jsonData at: 'actions' ifPresent: [ :actionsData | actions := self loadActions: actionsData ].
	^ WDCModel new
		vertices: vertices;
		indices: indices;
		submeshes: submeshes;
		boundingBox: boundingBox;
		armature: armature;
		actions: actions;
		yourself.
]

{ #category : #loading }
WDCJSONModelLoader >> loadFromFileReference: fileReference [
	^ self loadFrom: (NeoJSONReader fromString: fileReference contents)
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadInterleavedVertices: verticesData [
	| positions normals texcoords tangents4 numberOfVertices vertex normal boneIndices boneWeights isSkinned vertexClass weights den vertexBuffer |
	positions := verticesData at: 'positions' ifAbsent: [ self error: 'Position data is not present.' ].
	normals := verticesData at: 'normals' ifAbsent: [ nil ].
	texcoords := verticesData at: 'texcoords' ifAbsent: [ nil].
	tangents4 := verticesData at: 'tangents4' ifAbsent: [ nil ].
	boneIndices := verticesData at: 'boneIndices' ifAbsent: [ nil ].
	boneWeights := verticesData at: 'boneWeights' ifAbsent: [ nil ].
	
	isSkinned := boneIndices isNotNil and: [ boneWeights isNotNil ].
	vertexClass := isSkinned ifTrue: [ WTSkinnedGenericVertexF ] ifFalse: [ WTGenericVertexF ].
	numberOfVertices := positions size // 3.
	vertexBuffer := SLVMNativeArray for: vertexClass new: numberOfVertices.
	1 to: numberOfVertices do: [ :i |
		vertex := vertexClass new.
		vertex position: (WMVector3F x: (positions at: i*3 - 2) y: (positions at: i*3 - 1) z: (positions at: i*3)).
		
		vertex color: (WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0).
		
		texcoords ifNotNil: [ 
			vertex texcoord: (WMVector2F x: (texcoords at: i*2 - 1) y: (texcoords at: i*2)).
		].
	
		normals ifNotNil: [ 
			normal := (WMVector3F x: (normals at: i*3 - 2) y: (normals at: i*3 - 1) z: (normals at: i*3)).
			vertex normal: normal.
		].

		tangents4 ifNotNil: [
			vertex
				tangent4: (WMVector4F x: (tangents4 at: i*4 - 3) y: (tangents4 at: i*4 - 2) z: (tangents4 at: i*4 - 1) w: (tangents4 at: i*4))
		].
	
		isSkinned ifTrue: [
			vertex boneIndices: (WMVector4US
				x: (boneIndices at: i*4 - 3)
				y: (boneIndices at: i*4 - 2)
				z: (boneIndices at: i*4 - 1)
				w: (boneIndices at: i*4)).
			weights := (WMVector4F
				x: (boneWeights at: i*4 - 3)
				y: (boneWeights at: i*4 - 2)
				z: (boneWeights at: i*4 - 1)
				w: (boneWeights at: i*4)).
			den := weights x + weights y + weights z + weights w.
			(den closeTo: 0.0) ifFalse: [ weights := weights / den ].
			vertex boneWeights: weights.
		].
	
		vertexBuffer at: i put: vertex.
	].
	vertices := WDCInterleavedVertexData new
		data: vertexBuffer;
		vertexClass: vertexClass;
		yourself
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadQuaternion: quaternionData [
	^ WMQuaternionF 
		r: (quaternionData at: 1) asFloat
		i: (quaternionData at: 2) asFloat
		j: (quaternionData at: 3) asFloat
		k: (quaternionData at: 4) asFloat
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadScalarChannelClass: vectorClass elements: channelElements sourceData: sourceData [
	| result |
	result := SLVMNativeArray for: vectorClass new: channelElements.
	1 to: channelElements do: [ :destIndex |
		result at: destIndex put: (sourceData at: destIndex) 
	].
	^ result
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadSeparatedVertices: verticesData [
	| channels channelIndex vertexCount channel |
	channels := Array new: verticesData size.
	channelIndex := 1.
	vertexCount := SmallInteger maxVal.
	verticesData keysAndValuesDo: [ :key :value |
		channel := (self loadVertexChannel: key data: value).
		channels at: channelIndex put: channel. 
		channelIndex := channelIndex + 1.

		vertexCount := vertexCount min: channel size.		
	].

	channels sort: [ :a :b | a binding <= b binding ].
	
	vertices := WDCSeparatedVertexData new
		channels: channels;
		vertexCount: vertexCount;
		yourself.
		
	addExplicitWhiteColor ifTrue: [ 
		verticesData at: #colors ifAbsent: [
			vertices generateWhiteColorChannel
		]
	].
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadSubmesh: submeshData [
	| triangles numberOfTriangles submesh |
	triangles := submeshData at: 'triangles'.
	numberOfTriangles := triangles size.
	submesh := WDCModelSubmesh new
		firstIndex: baseIndex;
		indexCount: numberOfTriangles;
		primitiveType: AGPU_TRIANGLES;
		material: (submeshData at: 'material');
		yourself.
	
	1 to: numberOfTriangles do: [ :i |
		indices at: baseIndex + i put: (triangles at: i)
	].

	baseIndex := baseIndex + triangles size.
	^ submesh
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadSubmeshes: submeshesData [
	| totalNumberOfIndices |
	totalNumberOfIndices := 0.
	submeshesData do: [ :sm | totalNumberOfIndices := totalNumberOfIndices + (sm at: 'triangles') size ].
	vertices size < 1610000 ifTrue: [
		indices := SLVMNativeArray for: #ushort new: totalNumberOfIndices
	] ifFalse: [
		indices := SLVMNativeArray for: #uint new: totalNumberOfIndices
	].
	
	baseIndex := 0.
	^ submeshesData collect: [ :sm | self loadSubmesh: sm ].

]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadVector2ChannelClass: vectorClass elements: channelElements sourceData: sourceData [
	| result sourceIndex |
	result := SLVMNativeArray for: vectorClass new: channelElements.
	sourceIndex := 1.
	1 to: channelElements do: [ :destIndex |
		result at: destIndex put: (vectorClass
			x: (sourceData at: sourceIndex)
			y: (sourceData at: sourceIndex + 1)
		).
		sourceIndex := sourceIndex + 2
	].
	^ result
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadVector3: vectorData [
	^ WMVector3F
		x: (vectorData at: 1) asFloat
		y: (vectorData at: 2) asFloat
		z: (vectorData at: 3) asFloat
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadVector3ChannelClass: vectorClass elements: channelElements sourceData: sourceData [
	| result sourceIndex |
	result := SLVMNativeArray for: vectorClass new: channelElements.
	sourceIndex := 1.
	1 to: channelElements do: [ :destIndex |
		result at: destIndex put: (vectorClass
				x: (sourceData at: sourceIndex)
				y: (sourceData at: sourceIndex + 1)
				z: (sourceData at: sourceIndex + 2)
		).
		sourceIndex := sourceIndex + 3
	].
	^ result
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadVector4ChannelClass: vectorClass elements: channelElements sourceData: sourceData [
	| result sourceIndex |
	result := SLVMNativeArray for: vectorClass new: channelElements.
	sourceIndex := 1.
	1 to: channelElements do: [ :destIndex |
		result at: destIndex put: (vectorClass
			x: (sourceData at: sourceIndex)
			y: (sourceData at: sourceIndex + 1)
			z: (sourceData at: sourceIndex + 2)
			w: (sourceData at: sourceIndex + 3)
		).
		sourceIndex := sourceIndex + 4
	].
	^ result
]

{ #category : #'vertex data loading' }
WDCJSONModelLoader >> loadVertexChannel: channelName data: sourceData [
	| description channelData vectorSize rows channelElements vectorClass |
	description := WDCSeparatedVertexData vertexChannelDescriptions at: channelName ifAbsent: [
		self error: 'Unsupported/unknown vertex channel ' , channelName printString
	].

	vectorClass := description type slvmType.
	vectorSize := description type components.
	rows := description type rows.
	self assert: rows = 1.
	channelElements := sourceData size // (vectorSize * rows).
	
	vectorClass ifNil: [
		self error: 'Cannot decoded channel without an associated class.'
	].
	
	channelData := self loadChannelNamed: channelName vectorSize: vectorSize vectorClass: vectorClass elements: channelElements sourceData: sourceData.

	^ WDCMeshVertexChannel new
		description: description;
		data: channelData;
		yourself
]

{ #category : #'as yet unclassified' }
WDCJSONModelLoader >> loadVertices: verticesData [
	^ interleaveVertexData
		ifTrue: [ self loadInterleavedVertices: verticesData ]
		ifFalse: [ self loadSeparatedVertices: verticesData ]
]

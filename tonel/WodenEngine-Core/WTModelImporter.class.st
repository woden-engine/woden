Class {
	#name : #WTModelImporter,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'submeshes',
		'indices',
		'baseIndex'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WTModelImporter class >> convert: modelFileName materialMap: materialMapOrArray toFuel: fuelModel [
	| model materialMap |
	model := self new importFromFileNamed: modelFileName.
	materialMap := materialMapOrArray.
	materialMap isArray ifTrue: [
		materialMap := Dictionary newFrom: materialMap.
	].

	model mapMaterials: materialMap.
	FLSerializer serialize: model toFileNamed: fuelModel
]

{ #category : #'as yet unclassified' }
WTModelImporter class >> convert: modelFileName singleMaterial: materialName toFuel: fuelModel [
	| model |
	model := self new importFromFileNamed: modelFileName.
	model combineSubmeshesWithMaterial: materialName.
	FLSerializer serialize: model toFileNamed: fuelModel
]

{ #category : #'as yet unclassified' }
WTModelImporter class >> scriptsUsed [
	"
	model := WTModelImporter new
		importFromFileNamed: 'magnum_357.wmjson'.
	model combineSubmeshesWithMaterial: 'materials/demos/magnum.json'.
	FLSerializer serialize: model toFileNamed: 'magnum.fmdl'.
	
	model := WTModelImporter new
		importFromFileNamed: 'magnum_357_fps.wmjson'.
	model combineSubmeshesWithMaterial: 'materials/demos/magnum_fps.json'.
	FLSerializer serialize: model toFileNamed: 'magnum_fps.fmdl'.

	"
]

{ #category : #'as yet unclassified' }
WTModelImporter >> importFromFileNamed: fileName [
	^ self loadFrom: (NeoJSONReader fromString: fileName asFileReference contents)
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadAction: actionData [
	| actionBones |
	actionBones := (actionData at: 'bones') collect: [:actionBone | self loadActionBone: actionBone ].
	^ WTAnimationAction new
		name: (actionData at: 'name');
		bones: actionBones;
		yourself
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadActionBone: actionBoneData [
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

	^ WTAnimationActionBone new
		boneIndex: boneIndex;
		keyframes: keyframes;
		yourself
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadActions: actionsData [
	| actions |
	actions := Dictionary new.
	actionsData do: [ :actionData |
		actions at: (actionData at: 'name') put: (self loadAction: actionData).
	].

	^ actions
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadArmature: armatureData [
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

	^ WTModelArmature new names: names; boneParents: boneParents; bones: bones; yourself
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadBoundingBox: bboxData [
	| min max |
	min := WMVector3F x: (bboxData at: 1) y: (bboxData at: 2) z: (bboxData at: 3).
	max := WMVector3F x: (bboxData at: 4) y: (bboxData at: 5) z: (bboxData at: 6).
	^ WMBox3DF min: min max: max
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadFrom: jsonData [
	| boundingBox armature actions |
	self loadVertices: (jsonData at: 'vertices').
	submeshes := self loadSubmeshes: (jsonData at: 'submeshes').
	boundingBox := self loadBoundingBox: (jsonData at: 'boundingBox').
	armature := nil.
	actions := nil.
	jsonData at: 'armature' ifPresent: [ :armatureData | armature := self loadArmature: armatureData ].
	jsonData at: 'actions' ifPresent: [ :actionsData | actions := self loadActions: actionsData ].
	^ WTModel new
		vertices: vertices;
		indices: indices;
		submeshes: submeshes;
		boundingBox: boundingBox;
		armature: armature;
		actions: actions;
		yourself.
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadQuaternion: quaternionData [
	^ WMQuaternionF 
		r: (quaternionData at: 1) asFloat
		i: (quaternionData at: 2) asFloat
		j: (quaternionData at: 3) asFloat
		k: (quaternionData at: 4) asFloat
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadSubmesh: submeshData [
	| triangles numberOfTriangles submesh |
	triangles := submeshData at: 'triangles'.
	numberOfTriangles := triangles size.
	submesh := WTModelSubmesh new
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
WTModelImporter >> loadSubmeshes: submeshesData [
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

{ #category : #'as yet unclassified' }
WTModelImporter >> loadVector3: vectorData [
	^ WMVector3F
		x: (vectorData at: 1) asFloat
		y: (vectorData at: 2) asFloat
		z: (vectorData at: 3) asFloat
]

{ #category : #'as yet unclassified' }
WTModelImporter >> loadVertices: verticesData [
	| positions normals texcoords tangents4 numberOfVertices vertex normal boneIndices boneWeights isSkinned vertexClass weights den |
	positions := verticesData at: 'positions' ifAbsent: [ self error: 'Position data is not present.' ].
	normals := verticesData at: 'normals' ifAbsent: [ nil ].
	texcoords := verticesData at: 'texcoords' ifAbsent: [ nil].
	tangents4 := verticesData at: 'tangents4' ifAbsent: [ nil ].
	boneIndices := verticesData at: 'boneIndices' ifAbsent: [ nil ].
	boneWeights := verticesData at: 'boneWeights' ifAbsent: [ nil ].
	
	isSkinned := boneIndices isNotNil and: [ boneWeights isNotNil ].
	vertexClass := isSkinned ifTrue: [ WTSkinnedGenericVertexF ] ifFalse: [ WTGenericVertexF ].
	numberOfVertices := positions size // 3.
	vertices := SLVMNativeArray for: vertexClass new: numberOfVertices.
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
	
		vertices at: i put: vertex.
	].

]

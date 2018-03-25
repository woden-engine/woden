Class {
	#name : #WTGESelectionBoxView,
	#superclass : #Object,
	#instVars : [
		'editor',
		'node',
		'manipulatorBoxes',
		'manipulatorNodes',
		'boxMesh',
		'manipulatorMesh',
		'mouseOverIndex',
		'manipulatorNodesInstanceGroup',
		'view'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGESelectionBoxView >> createManipulatorsAtPositions: positions center: center [
	| halfExtent baseBox manipulatorBox manip |
	halfExtent := 0.08 * self manipBoxScale.
	baseBox := WMBox3DD halfExtent: (WMVector3D x: halfExtent y: halfExtent z: halfExtent).
	positions doWithIndex: [ :corner :index |
		manipulatorBox := baseBox translatedBy: corner.
		manipulatorBoxes at: index put: manipulatorBox.
		manip := manipulatorNodes at: index.
		manip model direction: (corner - center) normalized.
		manip visible: manipulatorBox isEmpty not.
		manip visible ifTrue: [ manip transform setForBox: manipulatorBox ]
	].
]

{ #category : #initialization }
WTGESelectionBoxView >> createSelectionBox [
	node := WTSSpatialObject new
		model: (WTGLevelEditorElementModel new view: view);
		renderable: boxMesh;
		visible: false;
		renderPriority: WTSNode renderPriorityEditorTranslucentAfter;
		yourself.
	editor scene add: node.
]

{ #category : #initialization }
WTGESelectionBoxView >> createSelectionBoxManipulatorMesh [
	| flatColorMaterial |
	flatColorMaterial := editor engine resourceCache loadMaterial: 'materials/basic/flat-xray.json'.
	manipulatorMesh := (WTGenericMeshBuilder for: editor engine)
		material: flatColorMaterial;
		color: (Color white alpha: 1.0);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.
]

{ #category : #initialization }
WTGESelectionBoxView >> createSelectionBoxManipulators [
	| manipulatorNode corners |
	corners := WMBox3DD unitCube manipulationCorners.
	manipulatorNodesInstanceGroup := WTSSpatialObjectInstanceGroup new
		model: (WTGLevelEditorElementModel new view: view);
		useViewportCamera: true;
		depthSorted: true;
		renderable: manipulatorMesh;
		renderPriority: WTSNode renderPriorityEditorTranslucentAfter + 1;
		yourself.
		
	editor scene add: manipulatorNodesInstanceGroup.
	
	manipulatorNodes := corners collectWithIndex: [ :corner :index |				
		manipulatorNode := WTSLocalShapedSpatialObject new
			visible: false;
			renderPriority: WTSNode renderPriorityEditorTranslucentAfter + 1;
			yourself.
		manipulatorNode model: (WTGLevelEditorBoxManipulator new
				node: manipulatorNode;
				boxIndex: index;
				direction: corner normalized).

		manipulatorNodesInstanceGroup addChild: manipulatorNode.
		manipulatorNode
	].

	manipulatorBoxes := corners collect: [ :i | WMBox3DD empty ].
]

{ #category : #initialization }
WTGESelectionBoxView >> createSelectionBoxMesh [
	| selectionCubeMaterial |
	selectionCubeMaterial := editor engine resourceCache loadMaterial: 'materials/basic/stipple.json'.
	boxMesh := (WTGenericMeshBuilder for: editor engine)
		material: selectionCubeMaterial;
		color: Color white;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.

]

{ #category : #rendering }
WTGESelectionBoxView >> createTranslationAndRotationManipulators [
	node transform setForBox: editor selectionBox box.
	self createManipulatorsAtPositions: editor selectionBox box rotationManipulationCorners center: editor selectionBox box center.

]

{ #category : #rendering }
WTGESelectionBoxView >> createTranslationAndScaleManipulators [
	node transform setForBox: editor selectionBox box.
	self createManipulatorsAtPositions: editor selectionBox box manipulationCorners center: editor selectionBox box center.

]

{ #category : #rendering }
WTGESelectionBoxView >> createTranslationManipulators [
	node transform setForBox: editor selectionBox box.
	self createManipulatorsAtPositions: { editor selectionBox box center} center: editor selectionBox box center
]

{ #category : #accessing }
WTGESelectionBoxView >> editor [
	^ editor
]

{ #category : #accessing }
WTGESelectionBoxView >> editor: anObject view: aView [
	editor := anObject.
	view := aView.
	
	self
		createSelectionBoxManipulatorMesh;
		createSelectionBoxManipulators;
		createSelectionBoxMesh;
		createSelectionBox;
		updateColors
]

{ #category : #selection }
WTGESelectionBoxView >> elementsAlongRay: ray do: aBlock [
	| distance model |
	distance := nil.
	manipulatorBoxes doWithIndex: [ :box :index |
		(box isEmpty not and: [ (distance := ray intersectionDistanceWithBox: box) isNotNil ]) ifTrue: [
			model := (manipulatorNodes at: index) model.
			aBlock value: (WMRayIntersectionTestResult priority: -1 distance: distance value: model)
		]
	].
]

{ #category : #rendering }
WTGESelectionBoxView >> makeManipulatorsEmpty [
	manipulatorBoxes do: [ :box | box makeEmpty ].
	manipulatorNodes do: [ :mnode | mnode visible: false ].
	
]

{ #category : #'as yet unclassified' }
WTGESelectionBoxView >> manipBoxScale [
	view isPerspective ifTrue: [ ^ 0.3 ].
	^ view viewScaleFactor
]

{ #category : #accessing }
WTGESelectionBoxView >> manipulatorBoxes [
	^ manipulatorBoxes
]

{ #category : #accessing }
WTGESelectionBoxView >> manipulatorNodes [
	^ manipulatorNodes
]

{ #category : #accessing }
WTGESelectionBoxView >> mouseOverIndex [
	^ mouseOverIndex
]

{ #category : #accessing }
WTGESelectionBoxView >> mouseOverIndex: anObject [
	mouseOverIndex := anObject.
	self updateColors
]

{ #category : #accessing }
WTGESelectionBoxView >> node [
	^ node
]

{ #category : #rendering }
WTGESelectionBoxView >> updateColors [
	| selectionBox |
	selectionBox := editor selectionBox.
	node color: selectionBox color.
	manipulatorNodes doWithIndex: [ :box :index |
		box color: (index = mouseOverIndex ifTrue: [ selectionBox highlightColor ] ifFalse: [ selectionBox color ])  
	]
]

{ #category : #rendering }
WTGESelectionBoxView >> updateNodes [
	node visible: editor selectionBox isEmpty not.
	node visible ifFalse: [
		self makeManipulatorsEmpty.
		^ self.
	].

	self makeManipulatorsEmpty.
	editor selectionBox isPointSelection ifTrue: [ 
		editor selectionBox rotationMode ifTrue: [
			self createTranslationAndRotationManipulators.
		] ifFalse: [
			self createTranslationManipulators.
		]
	] ifFalse: [ 
		editor selectionBox rotationMode ifTrue: [
			self createTranslationAndRotationManipulators.
		] ifFalse: [
			self createTranslationAndScaleManipulators.
		]
	].

	self updateColors.
]

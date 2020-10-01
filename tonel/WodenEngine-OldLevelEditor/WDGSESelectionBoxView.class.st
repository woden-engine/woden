Class {
	#name : #WDGSESelectionBoxView,
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
	#category : #'WodenEngine-OldLevelEditor-View'
}

{ #category : #'as yet unclassified' }
WDGSESelectionBoxView >> createManipulatorsAtPositions: positions center: center [
	| halfExtent baseBox manipulatorBox manip |
	halfExtent := 0.08 * self manipBoxScale.
	baseBox := WMBox3DD halfExtent: (WMVector3D x: halfExtent y: halfExtent z: halfExtent).
	positions doWithIndex: [ :corner :index |
		manipulatorBox := baseBox translatedBy: corner.
		manipulatorBoxes at: index put: manipulatorBox.

		manip := manipulatorNodes at: index.
		manip model direction: (corner - center) normalized.
		manip visible: manipulatorBox isEmpty not.
		manip visible ifTrue: [ manip transform setForBox: manipulatorBox asWMBox3DF ]
	].
]

{ #category : #initialization }
WDGSESelectionBoxView >> createSelectionBox [
	node := WDSGSpatialObject new
		model: (WDGSLevelEditorElementModel new view: view);
		renderable: boxMesh;
		visible: false;
		renderPriority: WDSGNode renderPriorityEditorTranslucentAfter;
		yourself.
	editor scene add: node.
]

{ #category : #initialization }
WDGSESelectionBoxView >> createSelectionBoxManipulatorMesh [
	| flatColorMaterial |
	flatColorMaterial := editor engine resourceCache loadMaterial: 'materials/basic/flat-xray.json'.
	manipulatorMesh := (WDCGenericMeshBuilder for: editor engine)
		material: flatColorMaterial;
		color: (Color white alpha: 1.0);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.
]

{ #category : #initialization }
WDGSESelectionBoxView >> createSelectionBoxManipulators [
	| manipulatorNode corners |
	corners := WMBox3DD unitCube manipulationCorners.
	manipulatorNodesInstanceGroup := WDSGSpatialObjectInstanceGroup new
		model: (WDGSLevelEditorElementModel new view: view);
		useViewportCamera: true;
		depthSorted: true;
		renderable: manipulatorMesh;
		renderPriority: WDSGNode renderPriorityEditorTranslucentAfter + 1;
		yourself.
		
	editor scene add: manipulatorNodesInstanceGroup.
	
	manipulatorNodes := corners collectWithIndex: [ :corner :index |				
		manipulatorNode := WDSGLocalShapedSpatialInstanceObject new
			visible: false;
			renderPriority: WDSGNode renderPriorityEditorTranslucentAfter + 1;
			yourself.
		manipulatorNode model: (WDGSLevelEditorBoxManipulator new
				node: manipulatorNode;
				boxIndex: index;
				direction: corner normalized).

		manipulatorNodesInstanceGroup addChild: manipulatorNode.
		manipulatorNode
	].

	manipulatorBoxes := corners collect: [ :i | WMBox3DD empty ].
]

{ #category : #initialization }
WDGSESelectionBoxView >> createSelectionBoxMesh [
	| selectionCubeMaterial |
	selectionCubeMaterial := editor engine resourceCache loadMaterial: 'materials/basic/stipple.json'.
	boxMesh := (WDCGenericMeshBuilder for: editor engine)
		material: selectionCubeMaterial;
		color: Color white;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.

]

{ #category : #rendering }
WDGSESelectionBoxView >> createTranslationAndRotationManipulators [
	node transform setForBox: editor selectionBox box asWMBox3DF.
	self createManipulatorsAtPositions: editor selectionBox box rotationManipulationCorners center: editor selectionBox box center.

]

{ #category : #rendering }
WDGSESelectionBoxView >> createTranslationAndScaleManipulators [
	node transform setForBox: editor selectionBox box asWMBox3DF.
	self createManipulatorsAtPositions: editor selectionBox box manipulationCorners center: editor selectionBox box center.
]

{ #category : #rendering }
WDGSESelectionBoxView >> createTranslationManipulators [
	node transform setForBox: editor selectionBox box asWMBox3DF.
	self createManipulatorsAtPositions: { editor selectionBox box center} center: editor selectionBox box center
]

{ #category : #accessing }
WDGSESelectionBoxView >> editor [
	^ editor
]

{ #category : #accessing }
WDGSESelectionBoxView >> editor: anObject view: aView [
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
WDGSESelectionBoxView >> elementsAlongRay: ray do: aBlock [
	| distance model |
	distance := nil.
	manipulatorBoxes doWithIndex: [ :box :index |
		(box isEmpty not and: [ (distance := ray intersectionDistanceWithBox: box) isNotNil ]) ifTrue: [
			model := (manipulatorNodes at: index) model.
			aBlock value: (WDCRayIntersectionTestResultF64 new priority: -1; distance: distance; value: model)
		]
	].
]

{ #category : #rendering }
WDGSESelectionBoxView >> makeManipulatorsEmpty [
	manipulatorBoxes do: [ :box | box makeEmpty ].
	manipulatorNodes do: [ :mnode | mnode visible: false ].
	
]

{ #category : #'as yet unclassified' }
WDGSESelectionBoxView >> manipBoxScale [
	view isPerspective ifTrue: [ ^ 0.3 ].
	^ view viewScaleFactor
]

{ #category : #accessing }
WDGSESelectionBoxView >> manipulatorBoxes [
	^ manipulatorBoxes
]

{ #category : #accessing }
WDGSESelectionBoxView >> manipulatorNodes [
	^ manipulatorNodes
]

{ #category : #accessing }
WDGSESelectionBoxView >> mouseOverIndex [
	^ mouseOverIndex
]

{ #category : #accessing }
WDGSESelectionBoxView >> mouseOverIndex: anObject [
	mouseOverIndex := anObject.
	self updateColors
]

{ #category : #accessing }
WDGSESelectionBoxView >> node [
	^ node
]

{ #category : #rendering }
WDGSESelectionBoxView >> updateColors [
	| selectionBox |
	selectionBox := editor selectionBox.
	node color: selectionBox color.
	manipulatorNodes doWithIndex: [ :box :index |
		box color: (index = mouseOverIndex ifTrue: [ selectionBox highlightColor ] ifFalse: [ selectionBox color ])  
	]
]

{ #category : #rendering }
WDGSESelectionBoxView >> updateNodes [
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

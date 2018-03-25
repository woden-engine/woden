Class {
	#name : #RWExample,
	#superclass : #RWObject,
	#category : 'Woden2-Roassal-Examples'
}

{ #category : #'as yet unclassified' }
RWExample >> allClasses [
	" 
	self new allClasses
	"
	| view els elementClass |
	view := RWView new.
	els := RWCube elementsOn: Object withAllSubclasses.
	els do: [ :el |
		el when: RWMouseButtonDown do: [ :ev |
			elementClass := ev element model.
			self inform: 'Class ' , elementClass name.
			elementClass inspect.
			ev element  shape color: Color darkGray.
			ev element changed.
		]
	].
	view addAll: els.
	RWCubeLayout on: view elements.
	view @ RWMouseKeyControl.
	view open
]

{ #category : #layout }
RWExample >> circleLayout [
	" 
	self new circleLayout
	"
	| v  |
	v := RWView new.
	1 to: 10 do: [ :i |
		v add: RWCube element.
	].

	RWCircleLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> clickAddAbove [
	" 
	self new clickAddAbove
	"
	| v e cube position action |
	cube := RWCube new.
	v := RWView new.
	
	action := [ :ev |
			position := ev element position.
			position y: position y + 1.05. 
			e := cube element.
			e translateTo: position;
				when: RWMouseButtonDown do: action.
			v add: e
	].
	
	1 to: 1024 do: [ :i |
		e := cube element.
		e when: RWMouseButtonDown do: action.
		v add: e.
	].
	(RWXZGridLayout gap: 0.05) on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 3.0 z: 0.0).
	^ v

]

{ #category : #'as yet unclassified' }
RWExample >> clickGreen [
	" 
	self new clickGreen
	"
	| v e |
	v := RWView new.

	1 to: 100 do: [ :i |
		e := RWCube element.
		e when: RWMouseButtonDown do: [ :ev |
			ev element shape color: Color green.
			ev element changed.
		].
		v add: e.
	].
	RWXZGridLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0).
	v open.

]

{ #category : #'as yet unclassified' }
RWExample >> clickLeds [
	" 
	self new clickLeds
	"
	| v e colors cube |
	colors := {  Color gray . Color red . Color green . Color blue . Color yellow . Color white}.
	cube := RWCube new.
	cube color: [ :val | colors at: val ].
	
	v := RWView new.
	
	1 to: 1024 do: [ :i |
		e := cube elementOn: 1.
		e when: RWMouseButtonDown do: [ :ev |
			ev element model: ev element model + 1.
			ev element model > colors size ifTrue: [ ev element model: 1 ].
			ev element changed.
		].
		e when: RWMouseButtonUp do: [ :ev |
			ev element model: ev element model + 1.
			ev element model > colors size ifTrue: [ ev element model: 1 ].
			ev element changed.
		].

		v add: e.
	].
	(RWXZGridLayout gap: 0.05) on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 3.0 z: 0.0).
	^ v

]

{ #category : #'as yet unclassified' }
RWExample >> cubeLayout [
	" 
	self new cubeLayout
	"
	| v  |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #trees }
RWExample >> differentShapes [
	"
	self new differentShapes
	"
	| view  |
	view := RWView new.
	view addAll: ( RWCylinder elementsOn: (1 to: 4)).
	view addAll: ( RWCube elementsOn: (1 to: 4)).
	view addAll: ( RWUVSphere elementsOn: (1 to: 4)).
	view addAll: ( RWPyramid elementsOn: (1 to: 4)).

	RWXZGridLayout on: view elements.
	view @ RWMouseKeyControl .
	view open.
]

{ #category : #'as yet unclassified' }
RWExample >> edges [
	"
	self new edges
	"

	| v el1 el2 |
	v := RWView new.

	el1 := RWCube element.
	el2 := RWCube element.

	v addAll: { el1 . el2 }.

	RWXZGridLayout on: v elements.

	v add: (RWLine green edgeFrom: el1 to: el2 ).

	v addInteraction: RWMouseKeyControl.
	^ v 
]

{ #category : #'as yet unclassified' }
RWExample >> eventHandling [
	"
	self new eventHandling
	"

	| v cube |
	v := RWView new.
	cube := RWCube element.
	v add: cube.

	cube when: RWMouseEnter do: [ :evt |
		evt element color: Color blue.
		evt signalUpdate.
	].

	cube when: RWMouseLeave do: [ :evt |
		evt element color: Color gray.
		evt signalUpdate.
	].

	cube when: RWMouseButtonDown do: [ :evt |
		evt element color: Color random.
		evt signalUpdate.
	].

	v addInteraction: OrbitController new.
	^ v
]

{ #category : #'as yet unclassified' }
RWExample >> fallingCubeLayout [
	" 
	self new fallingCubeLayout
	"
	| v floor |
	v := RWView new.
	1 to: 300 do: [ :i |
		v add: (RWCube element mass: 1.0).
	].

	v camera translateByZ: 6.0.
	RWCubeLayout on: v elements.

	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -10.0.
	v add: floor.

	v addInteraction: RWMouseKeyControl.
	v withPhysics.
	^ v
]

{ #category : #'as yet unclassified' }
RWExample >> fallingLineLayout [
	" 
	self new fallingLineLayout
	"
	| v floor |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: (RWCube element mass: 1.0).
	].

	v camera translateByZ: 3.0. 
	RWYLineLayout on: v elements.

	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -10.0.
	v add: floor.

	v addInteraction: RWMouseKeyControl.
	v withPhysics.
	v open
]

{ #category : #layout }
RWExample >> gridLayout [
	" 
	self new gridLayout
	"
	| v  |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWXZGridLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> growingCubes [
	" 
	self new growingCubes
	"
	| v shape es |
	v := RWView new.
	shape := RWCube new size: #yourself.
	es := shape elementsOn: (1 to: 3 by: 0.5).
	v addAll: es.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 5.0 y: 0.0 z: 10.0). 
	RWXLineLayout on: es.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> manyCubeLayout [
	" 
	self new manyCubeLayout
	"
	| v  |
	v := RWView new.
	1 to: 100000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> mediumCubeLayout [
	" 
	self new mediumCubeLayout
	"
	| v  |
	v := RWView new.
	1 to: 9261 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #shapes }
RWExample >> oneCone [
	" 
	self new oneCone
	"
	| v |
	v := RWView new.
	v add: RWCone element.
	v camera translateByZ: 3.0. 
	v  @ RWMouseKeyControl.
	v open
]

{ #category : #shapes }
RWExample >> oneCube [
	" 
	self new oneCube
	"
	| v |
	v := RWView new.
	v add: RWCube element.
	v open
]

{ #category : #shapes }
RWExample >> oneCylinder [
	" 
	self new oneCylinder
	"
	| v |
	v := RWView new.
	v add: RWCylinder element.
	v  @ RWMouseKeyControl.
	v open
]

{ #category : #shapes }
RWExample >> onePyramid [
	" 
	self new onePyramid
	"
	| v |
	v := RWView new.
	v add: RWPyramid element.
	v  @ RWMouseKeyControl.
	v open
]

{ #category : #shapes }
RWExample >> oneRedCube [
	" 
	self new oneRedCube
	"
	| v |
	v := RWView new.
	v add: RWCube red element.
	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #shapes }
RWExample >> oneUVSphere [
	" 
	self new oneUVSphere
	"
	| v |
	v := RWView new.
	v add: RWUVSphere element.
	v  @ RWMouseKeyControl.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> someEdges [
"
self new someEdges
"

| v els |
v := RWView new.

els := RWCube blue elementsOn: (1 to: 10).
v addAll: els.

RWXZGridLayout on: els.

1 to: 10 do: [ :i |
	1 to: 10 do: [ :j |
		i ~~ j ifTrue: [ v add: (RWLine green edgeFrom: (els at: i) to: (els at: j))]
	].
].

v addInteraction: RWMouseKeyControl.
v open.

]

{ #category : #trees }
RWExample >> spheroids [
	"
	self new spheroids
	"
	| view shape |
	view := RWView new.
	shape := RWUVSphere new .
	shape width: [ :v | (v log + 1) ];
		height: [ :v | (v log + 2)];
		depth: [ :v | (v log + 3) ].

	view addAll: ( shape elementsOn: (1 to: 1000)).

	RWCubeLayout on: view elements.
	view @ RWMouseKeyControl .
	view open.
]

{ #category : #shapes }
RWExample >> threeCubes [
	" 
	self new threeCubes
	"
	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> threeCubesAndLight [
	" 
	self new threeCubesAndLight
	"
	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWPointLight new color: Color red).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	^ v
]

{ #category : #'as yet unclassified' }
RWExample >> threeCubesAndLightWithShadows [
	" 
	self new threeCubesAndLightWithShadows
	"
	| v floor light|
	v := RWView new.
	v add: (RWCube element).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	
	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor translateByY: -0.6.
	v add: floor.
	
	light := RWSpotLight new.
	light lookDown;
		color: Color lightGray;
		translateByX: 2.0 y: 3.0 z: 0.0;
		influenceRadius: 10.0;
		castShadows: true.
	v add: light.
	v addInteraction: RWMouseKeyControl.
	v withShadows.
	v open
]

{ #category : #'as yet unclassified' }
RWExample >> threeCubesAndLightWithShadowsAndPhysics [
	" 
	self new threeCubesAndLightWithShadowsAndPhysics
	"
	| v floor light|
	v := RWView new.
	v add: (RWCube element mass: 1.0).
	v add: (RWCube element mass: 1.0).
	v add: (RWCube element mass: 1.0).
	RWXLineLayout on: v elements.

	v add: (RWCube element mass: 1.0; translateByY: 2.0; translateByX: 0.7).
		
	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -1.0.
	v add: floor.
	
	light := RWSpotLight new.
	light lookDown;
		color: Color lightGray;
		translateByX: 2.0 y: 3.0 z: 0.0;
		influenceRadius: 10.0;
		castShadows: true.
	v add: light.
	v addInteraction: RWMouseKeyControl.
	v withShadows;
		withPhysics.
	v open
]

{ #category : #trees }
RWExample >> translucentShape [
	"
	self new translucentShape open
	"
	| view translucentShape opaqueShape elements |
	view := RWView new.

	translucentShape := RWCube blue translucent.
	opaqueShape := RWCube red.

	elements := (translucentShape elementsOn: (1 to: 30)) , (opaqueShape elementsOn: (1 to: 30)).

	RWCubeLayout on: elements.
	view addAll: elements.
	view addInteraction: RWMouseKeyControl.
	^ view
]

{ #category : #trees }
RWExample >> treeSimple [
	"
	self new treeSimple
	"
	| view  objects associations elements assocWithElements|
	view := RWView new.
	objects := { 1 . 2 . 3 . 4 }.
	associations := { 1 -> 2 . 2 -> 3 . 2 -> 4 }.
	
	elements := objects collect: [ :o | RWCube blue elementOn:  o ].
"	elements do: [ :e | e addInteraction: RWPopup ]."
	view addAll: elements.
	
	assocWithElements := associations collect: [ :a | (view elementFromModel: a key) -> (view elementFromModel: a value)].
	view addAll: (RWEdge linesFor: assocWithElements).
	
	RWGridTreeLayout on: view elements.
	view addInteraction: RWMouseKeyControl.
"	view openWithOverlay."
	view open
]

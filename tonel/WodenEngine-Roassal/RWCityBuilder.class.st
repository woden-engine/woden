Class {
	#name : #RWCityBuilder,
	#superclass : #RWCityNeighborBuilder,
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

{ #category : #examples }
RWCityBuilder class >> buildRoassal3VisualizationForClass: classElement in: canvas [
	| elements title |
	elements := classElement model methods collect: [ :method | RSBox new
			width: 100;
			height: (method linesOfCode max: 1)*10;
			color: ((Color r: 0.2 g: 0.8 b: 0.2) interpolateTo: (Color r: 0.8 g: 0.0 b: 0.2) at: method linesOfCode / 100.0);
			model: method;
			yourself].
	elements sort: [ :a :b | a model linesOfCode <= b model linesOfCode ].
	RSGridLayout on: elements.

	canvas addAll: elements.

	elements do: [ :box |
		|label |
		label := RSLabel new
			color: Color black;
			text: box model name.
		canvas add: label.
		RSLocation new center; stick: label on: box.
	].

	title := RSLabel new
		fontSize: 20;
		color: Color black;
		text: 'Array';
		yourself.
	canvas add: title.
	RSLocation new above; stick: title on: (elements as: RSGroup).

	canvas @ RSCanvasController.

]

{ #category : #defaults }
RWCityBuilder class >> defaultBaseBorder [
	^ 1.0
]

{ #category : #accessing }
RWCityBuilder class >> defaultBaseColor [
	^ Color darkGray
]

{ #category : #defaults }
RWCityBuilder class >> defaultBaseHeight [
	^ 1.0
]

{ #category : #examples }
RWCityBuilder class >> exampleCollectionWithAllSubclasses [
	| b |
	b := RWCityBuilder new.
	b
		sortByVolume;
		buildingsFor: Collection withAllSubclasses with: [ :building |
			building
				height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
				width: [ :cls | cls slots size/5.0 + 1 ];
				depth: [ :cls | cls slots size/5.0 + 1 ];
					color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
						(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
				highlightable;
				tooltip;
				inspectable
	].
	b build inspect
]

{ #category : #examples }
RWCityBuilder class >> exampleCollectionWithAllSubclassesFromDataSet [
	| b dataset |
	dataset := RWDatasetCode loadFromJson: WodenCoreAssets coreAssetsLocation / 'datasets' / 'code' / 'collectionWithAllSubclasses.json'.
	b := RWCityBuilder new.
	b
		sortByVolume;
		buildingsFor: dataset classes with: [ :building |
			building
				height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
				width: [ :cls | cls instanceVariables size/5.0 + 1 ];
				depth: [ :cls | cls instanceVariables size/5.0 + 1 ];
					color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
						(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
				highlightable;
				tooltip;
				inspectable
	].
	b build inspect
]

{ #category : #examples }
RWCityBuilder class >> exampleCollections [
	| b packages |
	b := RWCityBuilder new.
	packages := RPackage organizer packages select: [ :each | each name beginsWith: 'Collections-' ].
	b
		sortByVolume;
		baseHeight: 2;
		neighborsFor: packages with: [ :neighbor :package |
			neighbor
				baseHeight: 1.0;
				baseColor: [:p | Color green lighter interpolateTo: Color red lighter at:
							((p linesOfCode + 1) log / 5 min: 1.0)];
				sortByVolume;
				highlightable;
				tooltip: #name;
				inspectable;
				buildingsFor: package classes with: [ :building |
					building
						height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
						width: [ :cls | cls slots size/10.0 + 1 ];
						depth: [ :cls | cls slots size/10.0 + 1 ];
						color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
							(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
						highlightable;
						tooltip;
						inspectable
		]
	].
	b build inspect
]

{ #category : #examples }
RWCityBuilder class >> exampleCollectionsFromDataSet [
	| b dataset |
	b := RWCityBuilder new.
	dataset := RWDatasetCode loadFromJson: WodenCoreAssets coreAssetsLocation / 'datasets' / 'code' / 'collectionPackages.json'.
	b
		sortByVolume;
		baseHeight: 2;
		neighborsFor: dataset packages with: [ :neighbor :package |
			neighbor
				baseHeight: 1.0;
				baseColor: [:p | Color green lighter interpolateTo: Color red lighter at:
							((p linesOfCode + 1) log / 5 min: 1.0)];
				sortByVolume;
				highlightable;
				tooltip: #name;
				inspectable;
				buildingsFor: package classes with: [ :building |
					building
						height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
						width: [ :cls | cls instanceVariables size/10.0 + 1 ];
						depth: [ :cls | cls instanceVariables size/10.0 + 1 ];
						color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
							(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
						highlightable;
						tooltip;
						inspectable
		]
	].
	b build inspect
]

{ #category : #examples }
RWCityBuilder class >> examplePrintableCollectionWithAllSubclasses [
	| b |
	b := RWCityBuilder new.
	b
		sortByVolume;
		buildingsFor: Collection withAllSubclasses with: [ :building |
			building
				height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
				width: [ :cls | cls slots size/5.0 + 1 ];
				depth: [ :cls | cls slots size/5.0 + 1 ];
				color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
					(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
				highlightable;
				tooltip;
				inspectable
	].
	b
		scaleToFitInMaxBaseSize: 0.10;
		attachVRTracker.
	true
		ifTrue: [ b build exportPrintableModelToFileNamed: 'collection-subclasses.obj' ]
		ifFalse: [ b build inspect ]
]

{ #category : #examples }
RWCityBuilder class >> examplePrintableCollectionWithAllSubclassesFromDataSet [
	| b dataset |
	dataset := RWDatasetCode loadFromJson: WodenCoreAssets coreAssetsLocation / 'datasets' / 'code' / 'collectionWithAllSubclasses.json'.
	b := RWCityBuilder new.
	b
		sortByVolume;
		buildingsFor: dataset classes with: [ :building |
			building
				height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
				width: [ :cls | cls instanceVariables size/5.0 + 1 ];
				depth: [ :cls | cls instanceVariables size/5.0 + 1 ];
				color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
					(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
				highlightable;
				tooltip;
				inspectable
	].
	b
		scaleToFitInMaxBaseSize: 0.10;
		attachVRTracker.
	true ifTrue: [
		b build exportPrintableModelToFileNamed: 'collection-subclasses.obj'
	] ifFalse: [
		b build
			makeDefaultView
			addTrackedStylusControlAttachedToTrackerWithIndex: 1;
			openInVR
	]
]

{ #category : #examples }
RWCityBuilder class >> examplePrintableCollections [
	| b packages |
	b := RWCityBuilder new.
	packages := RPackage organizer packages select: [ :each | each name beginsWith: 'Collections-' ].
	b
		sortByBaseArea;
		baseHeight: 2;
		neighborsFor: packages with: [ :neighbor :package |
			neighbor
				baseHeight: 1.0;
				baseColor: [:p | Color green lighter interpolateTo: Color red lighter at:
							((p linesOfCode + 1) log / 5 min: 1.0)];
				sortByVolume;
				highlightable;
				tooltip: #name;
				inspectable;
				buildingsFor: package classes with: [ :building |
					building
						height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
						width: [ :cls | cls slots size/10.0 + 1 ];
						depth: [ :cls | cls slots size/10.0 + 1 ];
						color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
							(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
						highlightable;
						tooltip;
						inspectable
		]
	].
	b
		scaleToFitInMaxBaseSize: 0.15;
		attachVRTracker.
	true
		ifTrue: [ b build exportPrintableModelToFileNamed: 'collections.obj' ]
		ifFalse: [ b build inspect ]
]

{ #category : #examples }
RWCityBuilder class >> examplePrintableCollectionsFromDataSet [
	| b dataset |
	b := RWCityBuilder new.
	dataset := RWDatasetCode loadFromJson: WodenCoreAssets coreAssetsLocation / 'datasets' / 'code' / 'collectionPackages.json'.

	b
		sortByBaseArea;
		baseHeight: 2;
		neighborsFor: dataset packages with: [ :neighbor :package |
			neighbor
				baseHeight: 1.0;
				baseColor: [:p | Color green lighter interpolateTo: Color red lighter at:
							((p linesOfCode + 1) log / 5 min: 1.0)];
				sortByVolume;
				highlightable;
				tooltip: #name;
				inspectable;
				buildingsFor: package classes with: [ :building |
					building
						height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
						width: [ :cls | cls instanceVariables size/10.0 + 1 ];
						depth: [ :cls | cls instanceVariables size/10.0 + 1 ];
						color: [ :cls | Color green lighter interpolateTo: Color red lighter at:
							(cls linesOfCode / (cls numberOfMethods * 12 max: 1) min: 1.0)];
						highlightable;
						"tooltip;"
						popupRoassal3: [:canvas :classElement |
							self buildRoassal3VisualizationForClass: classElement in: canvas
						];
						inspectable
		]
	].
	b
		scaleToFitInMaxBaseSize: 0.15;
		attachVRTracker.
	false
		ifTrue: [ b build exportPrintableModelToFileNamed: 'collections.obj' ]
		ifFalse: [ b build makeDefaultView
			addTrackedStylusControlAttachedToTrackerWithIndex: 2;
			openInVR ]
]

{ #category : #'element building' }
RWCityBuilder >> neighborFor: anElement with: aBlock [
	| neighborBuilder |
	neighborBuilder := RWCityNeighborBuilder on: anElement.
	aBlock cull: neighborBuilder cull: anElement cull: self.
	buildingGroup addChild: neighborBuilder build.
	
]

{ #category : #'element building' }
RWCityBuilder >> neighborsFor: aCollection with: aBlock [
	aCollection do: [ :each |
		self neighborFor: each with: aBlock
	]
]

{ #category : #'as yet unclassified' }
RWCityBuilder >> sortByBuildingCount [
	self sortBy: [ :each | each children size ]
]

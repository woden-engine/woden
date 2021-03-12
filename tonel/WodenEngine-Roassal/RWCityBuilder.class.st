Class {
	#name : #RWCityBuilder,
	#superclass : #RWCityNeighborBuilder,
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

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
		neighborsFor: packages with: [ :neighbor :package |
			neighbor
				sortByVolume;
				highlightable;
				tooltip: #name;
				inspectable;
				buildingsFor: package classes with: [ :building |
					building
						height: [ :cls | cls numberOfMethods sqrt + 0.1 ];
						highlightable;
						tooltip;
						inspectable
		]
	].
	b build inspect
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

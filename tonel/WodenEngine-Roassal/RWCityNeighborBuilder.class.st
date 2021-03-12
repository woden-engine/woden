Class {
	#name : #RWCityNeighborBuilder,
	#superclass : #RWCitySectionBuilder,
	#instVars : [
		'buildingGroup',
		'baseHeight',
		'baseBorder',
		'baseColor',
		'buildingSortBlock'
	],
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

{ #category : #defaults }
RWCityNeighborBuilder class >> defaultBaseBorder [
	^ 0.25
]

{ #category : #accessing }
RWCityNeighborBuilder class >> defaultBaseColor [
	^ Color lightGray
]

{ #category : #defaults }
RWCityNeighborBuilder class >> defaultBaseHeight [
	^ 0.25
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseColor [

	^ baseColor
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseColor: anObject [

	baseColor := anObject
]

{ #category : #building }
RWCityNeighborBuilder >> build [
	self buildBuildingGroup.
	self buildBase.

	^ buildingGroup
]

{ #category : #building }
RWCityNeighborBuilder >> buildBase [
	| boundingBox base |
	baseHeight <= 0 ifTrue: [ ^ self ].
	
	boundingBox := RWBoundingBox for: buildingGroup children.
	base := (RWCube new
		color: baseColor;
		height: baseHeight;
		width: boundingBox width + baseBorder;
		depth: boundingBox depth + baseBorder;
		elementOn: element)
			addInteractions: interactions;
			translateToY: baseHeight * -0.5.
	buildingGroup addChild: base
]

{ #category : #building }
RWCityNeighborBuilder >> buildBuildingGroup [
	| sortedBuildings |
	sortedBuildings := buildingGroup children.
	buildingSortBlock ifNotNil: [ sortedBuildings := buildingGroup children sorted: buildingSortBlock ].
	RWXZGridLayout on: sortedBuildings.
	RWAlign elements: sortedBuildings abovePoint: Float32x3 zeros.
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> buildingCount [
	^ buildingGroup children size
]

{ #category : #'element building' }
RWCityNeighborBuilder >> buildingFor: anElement with: aBlock [
	^ self buildingsFor: { anElement } with: aBlock
]

{ #category : #accessing }
RWCityNeighborBuilder >> buildingGroup [
	^ buildingGroup
]

{ #category : #'element building' }
RWCityNeighborBuilder >> buildingsFor: aCollectionOfElements with: aBlock [
	| builder |
	builder := RWCityBuildingBuilder new.
	aBlock cull: builder cull: self.
	buildingGroup addAll: (builder buildElementsFor: aCollectionOfElements)
]

{ #category : #initialization }
RWCityNeighborBuilder >> initialize [
	super initialize.
	buildingGroup := RWGroup new.
	baseColor := self class defaultBaseColor.
	baseHeight := self class defaultBaseHeight.
	baseBorder := self class defaultBaseBorder.
	buildingSortBlock := nil.
]

{ #category : #sorting }
RWCityNeighborBuilder >> sortBy: attributeBlock [
	buildingSortBlock := [ :a :b | (attributeBlock value: a) <= (attributeBlock value: b) ]
]

{ #category : #sorting }
RWCityNeighborBuilder >> sortByArea [
	self sortBy: [ :each | each area ]
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> sortByVolume [
	self sortBy: [ :each | each volume ]
]

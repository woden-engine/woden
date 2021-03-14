Class {
	#name : #RWCityNeighborBuilder,
	#superclass : #RWCitySectionBuilder,
	#instVars : [
		'buildingGroup',
		'baseHeight',
		'baseBorder',
		'baseColor',
		'buildingSortBlock',
		'shouldAttachVRTracker',
		'scaleMaxWidth',
		'scaleMaxHeight',
		'scaleMaxDepth'
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

{ #category : #building }
RWCityNeighborBuilder >> applyScaleFactor [
	| extent currentScaleFactor |
	extent := buildingGroup boundingBox extent.
	
	currentScaleFactor := 1.0.
	scaleMaxWidth ifNotNil: [
		currentScaleFactor := currentScaleFactor max: (extent x / scaleMaxWidth)
	].
	scaleMaxHeight ifNotNil: [
		currentScaleFactor := currentScaleFactor max: (extent y / scaleMaxHeight)
	].
	scaleMaxDepth ifNotNil: [
		currentScaleFactor := currentScaleFactor max: (extent z / scaleMaxDepth)
	].

	buildingGroup scaleBy: 1.0 / currentScaleFactor 
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> attachVRTracker [
	shouldAttachVRTracker := true
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseBorder [

	^ baseBorder rwValue: element
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseBorder: anObject [

	baseBorder := anObject
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseColor [

	^ baseColor rwValue: element
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseColor: anObject [

	baseColor := anObject
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseHeight [

	^ baseHeight rwValue: element
]

{ #category : #accessing }
RWCityNeighborBuilder >> baseHeight: anObject [

	baseHeight := anObject
]

{ #category : #building }
RWCityNeighborBuilder >> build [
	self buildBuildingGroup.
	self buildBase.
	self applyScaleFactor.
	self buildVRTrackerAttachment.

	^ buildingGroup
]

{ #category : #building }
RWCityNeighborBuilder >> buildBase [
	| boundingBox base |
	baseHeight <= 0 ifTrue: [ ^ self ].
	
	boundingBox := RWBoundingBox for: buildingGroup children.
	base := RWCube new
		color: self baseColor;
		height: self baseHeight;
		width: boundingBox width + self baseBorder;
		depth: boundingBox depth + self baseBorder;
		elementOn: element.
	base
        addInteractions: interactions;
		translateToY: base height * -0.5.
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
RWCityNeighborBuilder >> buildVRTrackerAttachment [
	| attachment groupWithAttachment attachmentBase attachmentBbox attachmentHeightOffset |
	shouldAttachVRTracker ifFalse: [ ^ self ].
	attachment := (RWModelShape modelNamed: 'models/vr/tracker-mount.obj') element.
	attachmentBbox := attachment localBoundingBox.
	attachmentHeightOffset := (attachmentBbox min y min: 0.0) negated.
	attachmentBase := RWCube new
		width: attachmentBbox width;
		height: buildingGroup height - attachmentHeightOffset;
		depth: attachmentBbox depth / 3;
		element.
	RWAlign elements: {buildingGroup . attachmentBase} abovePoint: Float32x3 zeros.
	attachment
		translateToY: attachmentBase height + attachmentHeightOffset;
		translateToZ: (buildingGroup depth /2) negated - attachmentBbox min z - attachment depth.
	attachmentBase
		translateToZ: (buildingGroup depth /2) negated - (attachmentBase depth / 2).

	groupWithAttachment := RWGroup new
		addChild: buildingGroup;
		addChild: attachment;
		addChild: attachmentBase.
		
	groupWithAttachment attachTrackerAt: (RWVRTrackerAttachment new attachmentPointTransform: attachment transform).
	
	buildingGroup := groupWithAttachment.
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
	scaleMaxWidth := nil.
	scaleMaxHeight := nil.
	scaleMaxDepth := nil.
	shouldAttachVRTracker := false.
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> scaleToFitInMaxBaseSize: maxBaseSize [
	scaleMaxWidth := maxBaseSize.
	scaleMaxDepth := maxBaseSize.
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> scaleToFitInMaxHeight: maxBaseSize [
	scaleMaxHeight := maxBaseSize.
]

{ #category : #sorting }
RWCityNeighborBuilder >> sortBy: attributeBlock [
	buildingSortBlock := [ :a :b | (attributeBlock value: a) <= (attributeBlock value: b) ]
]

{ #category : #sorting }
RWCityNeighborBuilder >> sortByArea [
	self sortBy: [ :each | each area ]
]

{ #category : #sorting }
RWCityNeighborBuilder >> sortByBaseArea [
	self sortBy: [ :each | each width * each depth ]
]

{ #category : #'as yet unclassified' }
RWCityNeighborBuilder >> sortByVolume [
	self sortBy: [ :each | each volume ]
]

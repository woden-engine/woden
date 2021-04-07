Class {
	#name : #WDELevelVisitor,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDELevelVisitor >> visitBoxCollisionComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitBoxVisualComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitDirectionalLightSourceVisualComponent: component [
	^ self visitLightSourceVisualComponent: component
]

{ #category : #visiting }
WDELevelVisitor >> visitEntity: entity [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitLevel: level [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitLevelElement: element [
	^ element accept: self
]

{ #category : #visiting }
WDELevelVisitor >> visitLightSourceVisualComponent: level [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitPointLightSourceVisualComponent: component [
	^ self visitLightSourceVisualComponent: component
]

{ #category : #visiting }
WDELevelVisitor >> visitPolyhedronConvexHullCollisionComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitPolyhedronFace: entity [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitPolyhedronVisualComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitRectangleCollisionComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitRectangleVisualComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitSector: sector [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitSectorLayer: sectorLayer [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelVisitor >> visitSpotLightSourceVisualComponent: component [
	^ self visitLightSourceVisualComponent: component
]

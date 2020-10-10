Class {
	#name : #WDELevelVisitor,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model'
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

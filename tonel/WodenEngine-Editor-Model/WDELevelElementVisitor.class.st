Class {
	#name : #WDELevelElementVisitor,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDELevelElementVisitor >> visitBoxCollisionComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitBoxVisualComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitEntity: entity [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitLevel: level [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitLevelElement: element [
	^ element accept: self
]

{ #category : #visiting }
WDELevelElementVisitor >> visitRectangleCollisionComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitRectangleVisualComponent: component [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitSector: sector [
	self subclassResponsibility
]

{ #category : #visiting }
WDELevelElementVisitor >> visitSectorLayer: sectorLayer [
	self subclassResponsibility
]

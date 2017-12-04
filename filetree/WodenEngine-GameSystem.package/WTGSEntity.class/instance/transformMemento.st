memento
transformMemento
	| spatialDesc |
	spatialDesc := self spatialDescription.
	spatialDesc ifNil: [ ^ nil ].
	^ spatialDesc transformMemento
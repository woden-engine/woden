memento
restoreTransformMemento: memento
	memento do: [ :assoc | assoc key restoreTransformMemento: assoc value ]
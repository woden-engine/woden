memento
transformMemento
	^ elements collect: [:element | element -> element transformMemento ]
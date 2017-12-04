as yet unclassified
update: delta
	velocity := velocity - (WMVector3D y: 9.8 * delta).
	position := position + (velocity * delta).
	
	node transform
		translation: position asWMVector3F.
	node stateChanged
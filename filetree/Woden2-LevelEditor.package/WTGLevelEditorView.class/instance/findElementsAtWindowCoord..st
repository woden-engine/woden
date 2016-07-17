selection
findElementsAtWindowCoord: coord
	| ray elements|
	ray := self rayAtWindowCoord: coord.
	elements := OrderedCollection new.
	self elementsAlongRay: ray do: [ :result |
		elements add: result
	].

	elements sort: [:a :b | a < b].
	^ elements
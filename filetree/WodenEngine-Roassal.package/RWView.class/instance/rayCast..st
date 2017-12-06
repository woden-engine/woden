ray casting
rayCast: ray
	| bestDistance bestResult distanceResult distance result |
	bestDistance := Float infinity.
	bestResult := nil.
	elements do: [ :element |
		distanceResult := element rayCast: ray.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance ]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
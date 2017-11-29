comparing
= other
	^ self class = other class and:
		[ firstIndex = other firstIndex and:
		[ indexCount = other indexCount and:
		[ material = other material and:
		[ primitiveType = other primitiveType ]]]]
as yet unclassified
renderOn: listBuilder mode: renderMode submode: submode
	material ifNil: [ ^ self ].
	(material activateOn: listBuilder primitiveType: primitiveType mode: renderMode submode: submode) ifFalse: [ ^ self].
	listBuilder drawElements: indexCount instance_count: 1 first_index: firstIndex base_vertex: 0 base_instance: 0
linear algebra
eigenValues
	<var: #det type: #double>
	| det first second |
	det := ((m11 + m22)*(m11 + m22)) - ((4.0 asNativeDouble) * ((m11*m22) - (m12*m21))).
	det >= 0 ifTrue: [
		det := det sqrt.
		first := (m11 + m22 - det) / (2.0 asNativeDouble).
		second := (m11 + m22 + det) / (2.0 asNativeDouble).
		nil
	] ifFalse: [
		det := det negated sqrt.
		first := WMComplexD r: m11 + m22 i: det negated.
		second := WMComplexD r: m11 + m22 i: det.
		nil
	].
	^ { first . second }
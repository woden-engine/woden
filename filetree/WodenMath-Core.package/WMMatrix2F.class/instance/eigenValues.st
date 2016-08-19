linear algebra
eigenValues
	<var: #det type: #float>
	| det first second |
	det := ((m11 + m22)*(m11 + m22)) - ((4.0 asNativeFloat) * ((m11*m22) - (m12*m21))).
	det >= 0 ifTrue: [
		det := det sqrt.
		first := (m11 + m22 - det) / (2.0 asNativeFloat).
		second := (m11 + m22 + det) / (2.0 asNativeFloat).
		nil
	] ifFalse: [
		det := det negated sqrt.
		first := WMComplexF r: m11 + m22 i: det negated.
		second := WMComplexF r: m11 + m22 i: det.
		nil
	].
	^ { first . second }
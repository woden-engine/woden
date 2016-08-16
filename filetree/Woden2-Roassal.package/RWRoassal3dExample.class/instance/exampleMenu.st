sources
exampleMenu

| classes v n shape es |

classes := RTObject withAllSubclasses.
v := RWView new.
n := RTMultiLinearColorForIdentity new objects: classes.
shape := RWUVSphere new size: [ :c | (c numberOfMethods / 100) + 1 ] ; color: [ :cls | (n rtValue: cls) asWDColor ].
es := shape elementsOn: classes.
es @ (RWMenuActivable new action: #inspect; item: 'browse class' action: [ :e | e model browse ]).
v addAll: es.
RWCubeLayout on: es.

^	 v
Define a popup on the element. Here is an example:
-=-=-=-=-=-=
v := RWView new.

c := RWCube element.
v add: c.

c addInteraction: RWPopup.

v open
-=-=-=-=-=-=
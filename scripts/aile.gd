extends Node2D

var rad
var newsprite
var newpoly
var posx
var posy
var max_ampl
var flexionspeed 
var retourspeed
var fex
var isflexion = true
var flexioncd = 0

var colorlist = {
	1 : "8EFFDB",
	2 : "B5623F",
	3 : "00004C",
	4 : "543732",
	5 : "3D3D3D",
	6 : "161616",
	7 : "FFFFFF",
	8 : "898989",
	9 : "B58765",
	10 : "AF7360",
}


func creatingaile(x, y, ailecolor, dg):
	var newsprite = Sprite2D.new()
	newsprite.texture = load("res://img/ailes.png")
	newsprite.scale = Vector2(4, 4)
	newsprite.hframes = 1
	newsprite.vframes = 10
	newsprite.frame = ailecolor-1
	if dg == 0:
		newsprite.rotation = PI
	newsprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	posx = 100*cos(0)
	posy = -100*sin(0)
	newsprite.position = Vector2(posx, posy)
	newpoly = Polygon2D.new()
	newpoly.set_polygon(PackedVector2Array([Vector2(0+5*sin(0), 0+5*cos(0)),
								  Vector2(posx+5*sin(0), posy+5*cos(0)),
								  Vector2(posx-5*sin(0), posy-5*cos(0)),
								  Vector2(0-5*sin(0),0-5*cos(0)),
								]))
	
	newpoly.color = colorlist[ailecolor]
	newpoly.z_index = -1
	position.x = x
	position.y = y
	add_child(newpoly)
	add_child(newsprite)
	#body.add_child(newbody)
	rotation = rad
	if fex == 0:
		isflexion = true
	else: isflexion = false


func rotato(xspeed, gravity, number, oldrot):
	var numbere = 0.0
	numbere = number
	if numbere == 0:
		numbere = 0.25
	if isflexion:
		if flexioncd < max_ampl :
			rotation += flexionspeed
			flexioncd += flexionspeed
			#if cos(newbody.rotation) >= 0:
			var forcerotation = rotation - oldrot - PI/2
			var newforcex = cos(forcerotation) * flexionspeed * 10 / (numbere*4)
			var newforcey = sin(forcerotation) * flexionspeed * 30 / (numbere*4)
			xspeed += newforcex
			gravity += newforcey
		else:
			isflexion = false
			flexioncd = 0
			if fex == 0:
				rotation = max_ampl + rad
			else:
				rotation = rad
	else:
		if flexioncd < max_ampl :
			rotation -= retourspeed
			flexioncd += retourspeed
			var forcerotation = rotation - oldrot + PI/2
			var newforcex = cos(forcerotation) * retourspeed * 10 / (numbere*4)
			var newforcey = sin(forcerotation) * retourspeed * 30 / (numbere*4)
			xspeed += newforcex
			gravity += newforcey
			
		else:
			isflexion = true
			flexioncd = 0
			if fex == 0:
				rotation = rad
			else: rotation = rad - max_ampl
	return Vector2(xspeed, gravity)


extends Node2D
var newsprite
var old = 6400
var frame = 0

func _ready():
	for i in range(20):
		addwater(i, $o1)
	for i in range(20):
		addwater(i, $o2)
	$o2.position.x += 6400

func addwater(x, contenant):
	newsprite = Sprite2D.new()
	newsprite.texture = load("res://img/eau animéecopie.png")
	newsprite.vframes = 49
	newsprite.scale = Vector2(10, 10)
	newsprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	newsprite.position = Vector2(x*32*10 - 1000, 3145)
	
	
	newsprite.z_index = 2
	contenant.add_child(newsprite)
	
func waterupdate(x, xspeed, dead):
	if x >= old:
		old += 6400
		if ((old-6400)/6400)%2 == 1:
			$o1.position.x += 6400*2
		else: $o2.position.x += 6400*2
		
	if dead == true or xspeed <= 10:
		frame += 1
		if frame%2 == 0:
			for i in $o1.get_children():
				i.frame += 1
			for i in $o2.get_children():
				i.frame += 1
		if frame%(47*2) == 0:
			for i in $o1.get_children():
				i.frame = 0
			for i in $o2.get_children():
				i.frame = 0

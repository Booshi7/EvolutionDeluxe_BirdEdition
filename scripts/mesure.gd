extends Node2D
var antisemite = 0
var addition = 0
var prochain = -1000
var prochainy = 700
var additiony = 0

func _ready():
	for i in range(-5, 5):
		if i%5 == 0:
			creationx(i, 1) 
		else:
			creationx(i) 
			
	for i in range(-20, 11):
		if i%5 == 0:
			creationy(i, 1) 
		else:
			creationy(i) 


func _process(delta):
	pass

func déplacement(positionx, positiony):
	position = Vector2(positionx, positiony)
	$Distance.position.x = -positionx
	if -positionx <= prochain:
		addition += 1
		if $Distance.get_children()[0].get_child_count() == 0:
			creationx(4 + addition)
		else:
			creationx(4 + addition, 1)
		$Distance.get_children()[0].queue_free()
		prochain -= 450
		
	$Hauteur.position.y = -positiony
	
	

func creationx(x, big = 0): #-1300, 1300
	var xx = x*450
	var newpoly = Polygon2D.new()
	if big == 0:
		newpoly.set_polygon(PackedVector2Array([Vector2(5, -10),
								  Vector2(5, 10),
								  Vector2(-5, 10),
								  Vector2(-5, -10),
								]))
	else:
		newpoly.set_polygon(PackedVector2Array([Vector2(5, -20),
								  Vector2(5, 20),
								  Vector2(-5, 20),
								  Vector2(-5, -20),
								]))
		var newtext = Label.new()
		newtext.text = str(x)
		newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		newtext.label_settings = LabelSettings.new()
		newtext.label_settings.font_size = 50
		newtext.label_settings.font_color = "000000"
		newtext.label_settings.outline_size = 5
		newtext.size[0] = 500
		newtext.position.y = - 80
		newtext.position.x = -250
		newpoly.add_child(newtext)
		
	newpoly.color = Color.BLACK
	newpoly.position = Vector2(xx, 620)
	$Distance.add_child(newpoly)
	
	
func creationy(y, big = 0): #-1300, 1300
	var yy = y*313
	var newpoly = Polygon2D.new()
	if big == 0:
		newpoly.set_polygon(PackedVector2Array([Vector2(10, -5),
								  Vector2(10, 5),
								  Vector2(-10, 5),
								  Vector2(-10, -5),
								]))
	else:
		newpoly.set_polygon(PackedVector2Array([Vector2(20, -5),
								  Vector2(20, 5),
								  Vector2(-20, 5),
								  Vector2(-20, -5),
								]))
		var newtext = Label.new()
		newtext.text = str(-y + 10)
		newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		newtext.label_settings = LabelSettings.new()
		newtext.label_settings.font_size = 50
		newtext.label_settings.font_color = "000000"
		newtext.label_settings.outline_size = 5
		newtext.size[0] = 100
		newtext.position.y = -38
		newtext.position.x = -120
		newpoly.add_child(newtext)
		
	newpoly.color = Color.BLACK
	newpoly.position = Vector2(1120, yy)
	$Hauteur.add_child(newpoly)

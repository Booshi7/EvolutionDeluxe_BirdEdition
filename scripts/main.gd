extends Node2D
var birds
var instantiatebird
var bestdist = 0
var disto = 0
var bestcam
var chrono = 0
var bestlist = []
var isalldead = false
var stats = []

func _ready():
	var loadgame = FileAccess.open("birds.json", FileAccess.READ)
	var json_string = loadgame.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var node_data = json.get_data()
	birds = node_data["birds"]
	
	var loadbird = load("res://scene/bird.tscn")
	for i in birds:
		instantiatebird = loadbird.instantiate()
		$Everybirds.add_child(instantiatebird)
		instantiatebird.createbody(i)
	#var loadbg = load("res://scene/background.tscn")
	#var loadeau = load("res://scene/eau.tscn")
	#var loadmesure = load("res://scene/mesure.tscn")
	#add_child(loadbg.instantiate())
	#add_child(loadeau.instantiate())
	#add_child(loadmesure.instantiate())



func _process(delta):
	chrono += 1
	#if isalldead == true:
		#chrono = 1200
	if chrono >= 1200:
		#get_tree().quit()
		if chrono == 1200:
					killall()
					for i in $Everybirds.get_children():
						bestlist.append([i.distance, i.datas])
					chrono += 1
					print("o")
					bestlist.sort_custom(custsort)
					stats.append([[bestlist[0][0], bestlist[bestlist.size()-1][0], bestlist[bestlist.size()/2 -1][0],bestlist[(bestlist.size()/10)*9 -1][0],bestlist[(bestlist.size()/10) -1][0]],
						[bestlist[0][1], bestlist[bestlist.size()-1][1], bestlist[bestlist.size()/2 -1][1]]])
					print(stats)
	else:
		bestdist = 0
		for i in $Everybirds.get_children():
			disto = i.distance
			if disto > bestdist:
				bestdist = disto
				bestcam = i.get_node("Camera2D")
		if bestcam != null:
			bestcam.make_current()

func killall():
	for i in $Everybirds.get_children():
		i.dead = true
		
func custsort(a, b):
	if a[0]<b[0]:
		return false
	else:
		return true

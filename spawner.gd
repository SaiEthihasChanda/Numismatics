extends Spatial

signal loose
signal respawn
var yes = 0
const filepath = "user://purchases.dat"
const filegamesound = "user://gamesoundsetting.dat"
const music = "user://musicsetting.dat"
const shadows = "user://shadows.dat"
#const filepath2 = "user://purchases.dat"
var time = 0
var period = 0.5
var magnitude = 0.01



var p = Array()
var valid = Array()
var shield = 0
signal ded
signal sheilddown
var alive = 0

func _ready():
	#$AdMob.load_rewarded_video()
	
	
	
	var file = File.new()
	if not file.file_exists(filegamesound):
		file.open(filegamesound, File.WRITE)
		file.close()
		
	file.open(filegamesound, File.READ)
	var Text = file.get_as_text()
	if int(Text) == 0 :
		AudioServer.set_bus_mute(AudioServer.get_bus_index("game sound"), true)
		
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("game sound"), false)
	file.close()
	if not file.file_exists(music):
		file.open(music, File.WRITE)
		file.close()
		
	file.open(music, File.READ)
	Text = file.get_as_text()
	if int(Text) == 0 :
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
		
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), false)
	file.close()
	if not file.file_exists(shadows):
		file.open(shadows, File.WRITE)
		file.close()
		
	file.open(shadows, File.READ)
	Text = file.get_as_text()
	if int(Text) == 0 :
		get_node("Room_one/DirectionalLight").shadow_enabled = false
		
	else:
		get_node("Room_one/DirectionalLight").shadow_enabled = true
	file.close()
	file.open(filepath, File.READ)
	Text = file.get_as_text()
	if "freeze" in Text:
		get_node("Timefreezebutton").show()
	else:
		get_node("Timefreezebutton").hide()
		
	#SilentWolf.Scores.wipe_leaderboard("Numismatic")
	SilentWolf.Auth.auto_login_player()
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
	file = File.new()
	if not file.file_exists(filepath):
		pass
	file.open(filepath,File.READ)
	Text = file.get_as_text()
	
	if "sheild" in Text:
		shield = 1
		get_node("Room_one/character/Spatial2").show()
		get_node("Room_one/character/AudioStreamPlayer").play()
	if "freeze" in Text:
		get_node("Timefreezebutton").show()
	else:
		emit_signal("sheilddown")
	file.close()

	
		 
	
	

func shake_camera():
	var campos = get_node("Room_one/InterpolatedCamera").get_translation()
	while time < period:
		time += get_process_delta_time()
		time = min(time , period)
		var offset = Vector3()
		offset.x = rand_range(-period , period)
		offset.z = rand_range(-period , period)
		#period.y = 0;
		var newcampos = campos
		newcampos +=offset
		get_node("Room_one/InterpolatedCamera").set_translation(newcampos)
		yield(get_tree(),"idle_frame")
		
		pass
	get_node("Room_one/InterpolatedCamera").set_translation(campos)
		
		
		
		
		
func _on_enemy_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		shake_camera()
		shake_camera()
		#get_node("Room_one/explosion").hide()
		
		#
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox").show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
		
		
		#var texture = preload("res://textures/Chip001_2k_Color.jpg")
	
		
		
		
	
		
		
		

func _on_Timer_timeout():
	get_tree().change_scene("res://main.tscn")
	


func _on_Button_pressed():
	get_node("Room_one/loosebox/pane1/Button").queue_free()
	emit_signal("respawn")


func _on_Spatial_respawn():
	$Room_one/Timer.start()


func _on_Button2_pressed():
	get_tree().change_scene("res://menu.tscn")


	


func _process(_delta):
	
	#get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
	
	var file = File.new()
	if not file.file_exists(filepath):
		pass
	file.open(filepath,File.READ)
	var Text = file.get_as_text()
	file.close()
	if "recon" in Text:
	
		if yes == 0:
			get_node("Room_one/draw").hide()
		if yes == 1:
			get_node("Room_one/draw").show()
			
			
			p.clear()
			for laka in range(0,675):
					
					
					p.append(get_node("Room_one/character").transform.origin)
					var v = get_node("Room_one/coins").get_child(laka).transform.origin
					if v != Vector3(100,100,100):
						p.append(get_node("Room_one/coins").get_child(laka).transform.origin)
					
					
					var ig = get_node("Room_one/draw")
					ig.clear()
					var m = SpatialMaterial.new()
					m.flags_use_point_size = true
					m.params_point_size = 5
					m.vertex_color_use_as_albedo = true
					m.flags_unshaded = true
					ig.set_material_override(m)
					
					
					#ig.set_line_width(2)
					
					
					
						
					ig.begin(Mesh.PRIMITIVE_LINES)
					ig.set_color(Color(1, 1, 0)) # yellow color
					
					for x in p:
						ig.add_vertex(x)
						#ig.set_color(Color(1, 1, 0)) # yellow color
						
					ig.end()
					
		else:
			yes=0
		


func _on_reconbutton_pressed():
	yes = 1


func _on_recontimer_timeout():
	yes = 0
	
	get_node("Room_one/draw").hide()






	


func _on_Timefreezebutton_pressed():
	get_node("Timefreezebutton/AnimationPlayer").play("freeze")
	get_node("Timefreezebutton/AudioStreamPlayer2D").play()
	get_node("Timefreezebutton").hide()
	get_node("freezetimer").start()
	
	var bad = get_node("Room_one/enemies").get_children()
	for i in bad:
		i.set_process(false)
		i.get_node("AnimationPlayer").stop(false)


func _on_freezetimer_timeout():
	get_node("Timefreezebutton/AnimationPlayer").play_backwards("freeze")
	get_node("Timefreezebutton/AudioStreamPlayer").play()
	#get_node("Timefreezebutton").queue_free()
	var bad = get_node("Room_one/enemies").get_children()
	for i in bad:
		i.set_process(true)
		i.get_node("AnimationPlayer").play()
	




func _on_enemy9_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		
		
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy2_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy3_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy4_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy5_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy6_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy7_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_enemy8_body_entered(body):
	if body.name=="character" and shield == 1:
		Input.vibrate_handheld(300)
		get_node("Room_one/character/AudioStreamPlayer2").play()
		shake_camera()
		
		get_node("Room_one/character/AudioStreamPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer").stop()
		get_node("Room_one/character/Spatial2/AnimationPlayer2").play("shielddown")
		yield(get_node("Room_one/character/Spatial2/AnimationPlayer2"), "animation_finished")
		#get_node("Room_one/character/AudioStreamPlayer").play("shielddown")
		get_node("Room_one/character/Spatial2").queue_free()
		shield = 0
		emit_signal("sheilddown")
		return
	
		
	
	
	
	if body.name=="character" and shield == 0 and alive == 0:
		var explodeplace = get_node("Room_one/character").translation
		get_node("Room_one/explosion").show()
		get_node("Room_one/explosion").translation = Vector3(explodeplace.x , explodeplace.y , explodeplace.z)
		get_node("Room_one/explosion/AnimationPlayer").play("kaboom")
		shake_camera()
		emit_signal("ded")
		emit_signal("loose")
		alive = 1
		$Room_one/loosebox.show()
		get_node("Room_one/loosebox/AnimationPlayer").play("transition")
		return
	


func _on_score_win():
	get_node("Room_one/Winbox").show()
	alive = 0
	#var pos = get_node("Room_one/character").translation
	#get_node("Room_one/character").translation = Vector3(pos.x , pos.y+10, pos.z)
	
	#emit_signal("ded")
	emit_signal("loose")
	get_node("Room_one/loosebox").hide()
	get_node("Room_one/explosion").hide()
	
	#emit_signal("ded")
	








func _on_playagain_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_Menu_pressed():
	get_tree().change_scene("res://menu.tscn")


func _on_numismaticboard_pressed():
	get_tree().change_scene("res://addons/silent_wolf/examples/CustomLeaderboards/ReverseLeaderboard.tscn")


func _on_continue_pressed():
	$AdMob.show_rewarded_video()


func _on_AdMob_rewarded_video_closed():
	$Room_one/loosebox.hide()
	get_node("Room_one/loosebox").hide()
	
	#get_node("Room_one/loosebox/AnimationPlayer").play("transition")
	
	alive = 0


func _on_part2_pressed():
	$Room_one/Winbox.hide()

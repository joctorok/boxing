extends Node

var CurrentVolume = 1.0

var VolumeLabel

#var for the master AudioBus
var masterBus 


func _ready():
	VolumeLabel = get_node("VolumeLabel")
	masterBus = AudioServer.get_bus_index("Master")
	pass

#Checks if current event is  "-" or "+"
func _input(event):
	if event.is_action_pressed("Volume_Down"):
		TurnVolumeDown()
	elif event.is_action_pressed("Volume_Up"):
		TurnVolumeUp()
	pass

#test fucntion to see if the volume goes up
func TurnVolumeUp():
	
	if !VolumeLabel.CurrentDisplayValue == 100:
		CurrentVolume = clamp(CurrentVolume + 1.0, -80.0, 0.0)
		$VolumeBeepSound.play()
		AudioServer.set_bus_volume_db(masterBus, CurrentVolume)
		PassToVolumeLabel(true)
	elif VolumeLabel.CurrentDisplayValue == 100:
		$VolumeMaxSound.play()
	pass

#test fucntion to see if the volume goes up
func TurnVolumeDown():
	if !get_node("VolumeLabel").CurrentDisplayValue == 0:
		CurrentVolume = clamp(CurrentVolume - 1.0, -80.0, 0.0)
		$VolumeBeepSound.play()
		AudioServer.set_bus_volume_db(masterBus, CurrentVolume)
		PassToVolumeLabel(false)
	elif VolumeLabel.CurrentDisplayValue == 0:
		$VolumeMaxSound.play()
		AudioServer.set_bus_volume_db(masterBus, -80.0)
	pass

func PassToVolumeLabel(x):
	get_node("VolumeLabel").ChangeLabel(x)
	pass



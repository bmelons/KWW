extends HitscanWeapon


@export var altHand:Texture2D

func _ready():
	Camera = Main.player.cam
	Main.player.rh.texture = hand
	Main.player.lh.texture = altHand
	Main.player.icon.frame = iconFrame

func _add_fire():
	if beamorigin == Main.player.bulletpoint:
		beamorigin = Main.player.bulletpoint2
	else:
		beamorigin == Main.player.bulletpoint

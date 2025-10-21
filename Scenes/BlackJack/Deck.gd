extends Node2D
const CARD_SCENE_PATH = "res://Scenes/BlackJack/card.tscn"
var card_draw_speed = 0.2
var card_database_reference
var player_deck =  ["king_heart", "queen_heart", "jack_heart", "ten_heart", "nine_heart", "eight_heart", "seven_heart", "six_heart", "five_heart", "four_heart", "three_heart", "two_heart", "one_heart",
 "king_spade", "queen_spade", "jack_spade", "ten_spade", "nine_spade", "eight_spade", "seven_spade", "six_spade", "five_spade", "four_spade", "three_spade", "two_spade", "one_spade",
 "king_diamond", "queen_diamond", "jack_diamond", "ten_diamond", "nine_diamond", "eight_diamond", "seven_diamond", "six_diamond", "five_diamond", "four_diamond", "three_diamond", "two_diamond", "one_diamond",
 "king_club", "queen_club", "jack_club", "ten_club", "nine_club", "eight_club", "seven_club", "six_club", "five_club", "four_club", "three_club", "two_club", "one_club"]
var total_in_deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_in_deck = player_deck.size()
	$RichTextLabel.text = str(player_deck.size()) + "/" + str(total_in_deck)
	card_database_reference = preload("res://Scenes/BlackJack/Database.gd")
	player_deck.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func DrawCard(destination):
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/Sprite2D.visible = false
	$RichTextLabel.text = str(player_deck.size()) + "/" + str(total_in_deck)
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/Cards/" + card_drawn_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../CardSlotManager".AddCardToHand(new_card, destination, card_draw_speed)
	
	# $"../PlayerHand".AddCardToHand(new_card, card_draw_speed)
	new_card.get_node("AnimationPlayer").play("card_flip")

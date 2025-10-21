extends Node2D

var player_slot 
var dealer_slot
var deck = ["king_heart", "queen_heart", "jack_heart", "ten_heart", "nine_heart", "eight_heart", "seven_heart", "six_heart", "five_heart", "four_heart", "three_heart", "two_heart", "one_heart",
 "king_spade", "queen_spade", "jack_spade", "ten_spade", "nine_spade", "eight_spade", "seven_spade", "six_spade", "five_spade", "four_spade", "three_spade", "two_spade", "one_spade",
 "king_diamond", "queen_diamond", "jack_diamond", "ten_diamond", "nine_diamond", "eight_diamond", "seven_diamond", "six_diamond", "five_diamond", "four_diamond", "three_diamond", "two_diamond", "one_diamond",
 "king_club", "queen_club", "jack_club", "ten_club", "nine_club", "eight_club", "seven_club", "six_club", "five_club", "four_club", "three_club", "two_club", "one_club"]
const CARD_SCENE_PATH = "res://Scenes/NewBlackJack/card.tscn"
var deck_reference 
var card_scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_slot = $"../SlotManager/PlayerSlot"
	dealer_slot = $"../SlotManager/DealerSlot"
	deck.shuffle()
	card_scene = preload(CARD_SCENE_PATH)
	deck_reference = $Deck

func CreateCard(card_name):
	
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/Cards/" + card_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.name = card_name
	return new_card
func SetDeckText():
	$Deck/DeckTotal.text = str(deck.size()) + "/52"
func Draw(destination):
	var card = deck[0]
	destination.AddCard(card)
	deck.erase(deck[0])
	var card_node = CreateCard(card)
	$CardManager.add_child(card_node)
	card_node.position = deck_reference.position
# or wherever your deck is located
	card_node.z_index = 12
	AnimateCardToPosition(card_node, Vector2(destination.position.x + destination.card_offset_pos,destination.position.y), 0.4)
	card_node.get_node("AnimationPlayer").play("new_card_flip")
	destination.AddPos()
	SetScores()
	SetDeckText()

func Deal():
	Draw(player_slot)
	Draw(dealer_slot)
	Draw(player_slot)
func SetScores():
	$PlayerScore.text = "Your Score\n" + str(player_slot.hand_value)
	$DealerScore.text = "Dealer Score\n" + str(dealer_slot.hand_value)
func AnimateCardToPosition(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func _on_hit_pressed() -> void:
	# Draw 1 card to player
	Draw(player_slot)
	pass # Replace with function body.


func _on_deal_pressed() -> void:
	Deal()


func _on_dealer_draw_pressed() -> void:
	Draw(dealer_slot)


func _on_reset_pressed() -> void:
	player_slot.Clear()
	dealer_slot.Clear()
	for child in $CardManager.get_children():
		child.queue_free()
	SetScores()
	

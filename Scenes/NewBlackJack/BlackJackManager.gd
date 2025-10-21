extends Node2D
# TO DO
# Game doesnt recognize natural 21s for the player, it makes them press stand

# Variables
var player_chips = 5000 # NEED TO GET THIS REFEREENCE FROM THE GENUINE PLAYER
var player_slot 
var pot = 0
var dealer_slot
var deck_node_reference 
var card_scene
var deck = CreateDeck()
var game_state = ["bet", "action", "show_down", "clean_up"]
var game_state_index = 0
const CARD_SCENE_PATH = "res://Scenes/NewBlackJack/card.tscn"

# Fundamentals #
func _ready() -> void:
	player_slot = $"../SlotManager/PlayerSlot"
	dealer_slot = $"../SlotManager/DealerSlot"
	deck.shuffle()
	card_scene = preload(CARD_SCENE_PATH)
	deck_node_reference = $Deck
	ChangeButtonsZ(-2)

func CreateCard(card_name):
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/Cards/" + card_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.position = $Deck.GetPositionTopCard()
	new_card.name = card_name
	return new_card

func Draw(destination):
	await get_tree().create_timer(0.2).timeout
	var card = deck[0]
	destination.AddCard(card)
	deck.erase(deck[0])
	var card_node = CreateCard(card)
	$CardManager.add_child(card_node)
	card_node.position = deck_node_reference.position
	card_node.z_index = 12
	AnimateCardToPosition(card_node, Vector2(destination.position.x + destination.card_offset_pos,destination.position.y), 0.4)
	card_node.get_node("AnimationPlayer").play("new_card_flip")
	destination.AddPos()
	SetScores()
	SetDeckText()
	deck_node_reference.UpdateSize(deck.size())

func Deal():
	Draw(player_slot)
	Draw(dealer_slot)
	Draw(player_slot)
	if CheckBust(player_slot.hand_value):
		game_state_index = 3
		CleanUp("player_lose")
	else:
		game_state_index = 1
		if player_slot.hand_value == 21:
			HandleShowdown()
		else:
			ChangeButtonsZ(2)
		
func CheckBust(hand_value):
	if hand_value > 21:
		return true
	return false

# Game Logic
func HandleBet(bet_amount):
	if game_state[game_state_index] == "bet":
		# LET THEM PICK UP AND THROW THEIR CHIPS
		# READ CHIPS THROWN IN
		if player_chips >= bet_amount:
			pot += bet_amount
			player_chips -= bet_amount
			game_state_index = 1
			Deal()
			UpdateChips()
	else:
		return

func HandleShowdown():
	game_state_index = 3
	while dealer_slot.hand_value < 17:
		await Draw(dealer_slot)
	if CheckBust(dealer_slot.hand_value):
		CleanUp("player_win")
	else:
		if player_slot.hand_value > dealer_slot.hand_value:
			CleanUp("player_win")
		elif player_slot.hand_value == dealer_slot.hand_value:
			CleanUp("push")
		else:
			CleanUp("player_lose")
	

func CleanUp(determination):
	await get_tree().create_timer(1.5).timeout
	ChangeButtonsZ(-2)
	if determination == "player_win":
		player_chips += pot * 2
	elif determination == "push":
		player_chips += pot
	ClearAll()
	UpdateChips()
	pot = 0
	game_state_index = 0
	return
	
# Button Presses
func _on_hit_pressed() -> void:
	if game_state[game_state_index] == "action":
		Draw(player_slot)
		await get_tree().create_timer(1.5).timeout
		if CheckBust(player_slot.hand_value):
			await get_tree().create_timer(1.5).timeout
			CleanUp("player_lose")

func _on_double_pressed() -> void:
	game_state_index = 2
	player_chips -= pot
	UpdateChips()
	pot *= 2
	Draw(player_slot)
	if CheckBust(player_slot.hand_value):
		CleanUp("player_lose")
	else:
		HandleShowdown()
	
func _on_stand_pressed() -> void:
	if game_state[game_state_index] == "action":
		HandleShowdown()
	
func _on_bet_500_pressed() -> void:
	HandleBet(500)
# Helper Functions #
func CreateDeck():
	return ["king_heart", "queen_heart", "jack_heart", "ten_heart", "nine_heart", "eight_heart", "seven_heart", "six_heart", "five_heart", "four_heart", "three_heart", "two_heart", "one_heart",
 "king_spade", "queen_spade", "jack_spade", "ten_spade", "nine_spade", "eight_spade", "seven_spade", "six_spade", "five_spade", "four_spade", "three_spade", "two_spade", "one_spade",
 "king_diamond", "queen_diamond", "jack_diamond", "ten_diamond", "nine_diamond", "eight_diamond", "seven_diamond", "six_diamond", "five_diamond", "four_diamond", "three_diamond", "two_diamond", "one_diamond",
 "king_club", "queen_club", "jack_club", "ten_club", "nine_club", "eight_club", "seven_club", "six_club", "five_club", "four_club", "three_club", "two_club", "one_club"]

func ClearAll():
	player_slot.Clear()
	dealer_slot.Clear()
	for child in $CardManager.get_children():
		child.queue_free()
	SetScores()
	pot = 0
	
	
func SetScores():
	$PlayerScore.text = "Your Score\n" + str(player_slot.hand_value)
	$DealerScore.text = "Dealer Score\n" + str(dealer_slot.hand_value)
	
	
func ChangeButtonsZ(value):
	for child in $"../ButtonManager".get_children():
		child.z_index = value
		if value > 0:
			child.disabled = false
		else:
			child.disabled = true
		
func AnimateCardToPosition(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func SetDeckText():
	$Deck/DeckTotal.text = str(deck.size()) + "/52"
	
func UpdateChips():
	$PlayerChips.text = str(player_chips)

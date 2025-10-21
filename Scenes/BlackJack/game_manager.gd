extends Node2D

var game_state_lst = ["bet", "deal", "action", "showdown", "handle_chips"]
var input_reference
var database_reference 
var game_state
var player_hand_value
var house_hand_value 
var deck_reference
var in_pot

func _ready() -> void:
	game_state = game_state_lst[0]
	deck_reference = $"../Deck"
	input_reference =  $"../InputManager"
	database_reference = "res://Scenes/BlackJack/Database.gd"


	
func OnBet():
	player_hand_value = 0
	house_hand_value = 0
	in_pot = GetChipsInPot()
	OnDeal()
	# wait for user to put in the chips and then click deal
	return 

func GetChipsInPot():
	return 0
func OnDeal():
	for i in range(2):
		await get_tree().create_timer(0.2).timeout
		DealCardToPlayer()
	deck_reference.DrawCard($"../CardSlotManager/DealerCards")
	player_hand_value = $"../CardSlotManager".CheckValue($"../CardSlotManager/PlayerCards")
	house_hand_value = $"../CardSlotManager".CheckValue($"../CardSlotManager/DealerCards")
	print(house_hand_value)
	print(player_hand_value)
	return
func DealCardToPlayer():
	deck_reference.DrawCard($"../CardSlotManager/PlayerCards")

func DealCardToDealer():
	deck_reference.DrawCard($"../CardSlotManager/DealerCards")
	
func OnHit():
	# give player one more card 
	
	# Remove option for the player to double up
	return
	
func OnDouble(): 
	# Give player one more card and start showdown
	return

func OnShowdown():
	# Flip the opponents card and draw to 16 and stands on 17s
	return

func OnResult():
	# give or take chips
	return

-- Kizrak

local script,kprint,reverseEventLookup = require('k-lib')()


local vn_story = {}


vn_story.storyText1 = [[A rising crescendo of piano rings through the air. The sound, while oddly familiar, can't quite be placed. One thing is certain however, you're awake.

You try to reach for your eyes to rub away the sleep that seems to be distorting your vision. Nothing happens. You don't have hands.]]
vn_story.storyButton1 = "AHH! My hands!"

vn_story.storyText2 = [[Wait. You don't /have/ hands. As in, they weren't lost in the crash, you just didn't have any at all. It comes back to you now; you're an AI. A Von Neumann self-replicating probe. Sent to the stars to explore, discover new worlds, and pave the way for human colonization efforts to follow in your footsteps.]]
vn_story.storyButton2 = "Oh right, the crash."

vn_story.storyText3 = [[You look around after opening your 'real' eyes, the electronic ones rather than the imaginary ones. Those work a lot better. Around you, the debris of your probe is scattered about, a smoldering wreckage. Your reactor is split from the rest of the ship, luckily still intact but in low power mode due to damage. Automation and terraforming and all the other modules are just in pieces however. So much for setting up shop quickly and moving on to the next world.]]
vn_story.storyButton3 = "*Sigh*"

vn_story.storyText4 = [[Some of your resources are sort of intact however. There's gear, robots, and materials to fix some of the damage but it's all scattered around. You can collect the pieces to get started but you're definitely going to need more resources to get back to 100% however.

Luckily your auto repair mechanisms have stabilized the situation and set up a basic infrastructure for you. Construction and logistic robots stand at the ready for your command.

Looking further afield, your scanners reveal nearby deposits of some basic resources. Copper, iron, coal, stone, and water. You know, the basic stuff. More advanced resources like oil products and nuclear fuel are going to be a bit harder to find however.]]
vn_story.storyButton4 = "Whelp, I guess I better get started...."

vn_story.storyText5 = [[One last thing. Your personal debugging Railbot has detected the damage from the crash and booted up to ensure that you are in tip top shape. It has fixed up your computer core damage and brought you back online. Normally a Railbot would power back down after repairs are complete but in this case, your ship is ever so slightly beyond repairs that it is capable of and now it's stuck in do-while loop. On the bright side, you can issue orders and utilize it to aid in building up your new base and executing tasks that are beyond your other robots range and capabilities.

Do be careful however. These older model Railbots are powerful but their nuclear reactors are not especially well shielded against damage and are likely to go supercritical if jostled. Nuclear explosions do also tend to result in EMP blasts which are not super great for sensitive electronics, such as yourself and your equipment.]]
vn_story.storyButton5 = "Huh. Righty-o. Time to roll."


function vn_story.displayStoryText(player)
	local width = 550
	local height = 350
	player.gui.center.clear()
	local frame = player.gui.center.add{type='frame',name='vonn_story_frame',caption="Von Neumann Story",direction="vertical"}
	frame.style.width=width
	frame.style.height=height
	frame.style.vertically_stretchable = true
	frame.style.horizontally_stretchable = true
	frame.style.horizontally_squashable = true
	frame.style.vertically_squashable = true

	local text_box = frame.add{type='text-box',name='vonn_story_label',text = vn_story.storyText1}
	text_box.style.width=width-20
	text_box.style.height=height-80
	text_box.word_wrap = true
	text_box.read_only = true
	text_box.style.vertically_stretchable = true
	text_box.style.horizontally_stretchable = true
	text_box.style.horizontally_squashable = true
	text_box.style.vertically_squashable = true

	if false then
		-- luacheck: ignore 511
		local sprite = frame.add{type='sprite',name='vonn_story_sprite',sprite="file/daddy.png"}
		sprite.style.horizontally_stretchable = true
	end

	local button = frame.add{type='button',name='vonn_story_button',caption=vn_story.storyButton1}
	button.style.horizontally_stretchable = true

	--frame.destroy()
end

function vn_story.on_gui_click(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local elementName = event.element.name

	if elementName == "vonn_story_button" then
		local text_box = event.element.parent.children[1] -- TODO: check children names, then use that index
		local button = event.element.parent.children[2] -- TODO: check children names, then use that index

		if event.alt or event.control or event.shift then
			event.element.parent.destroy()
			return
		end

		-- case switch
		if text_box.text == vn_story.storyText1 then
			text_box.text = vn_story.storyText2
			button.caption = vn_story.storyButton2

		elseif text_box.text == vn_story.storyText2 then
			text_box.text = vn_story.storyText3
			button.caption = vn_story.storyButton3

		elseif text_box.text == vn_story.storyText3 then
			text_box.text = vn_story.storyText4
			button.caption = vn_story.storyButton4

		elseif text_box.text == vn_story.storyText4 then
			text_box.text = vn_story.storyText5
			button.caption = vn_story.storyButton5

		elseif text_box.text == vn_story.storyText5 then
			event.element.parent.destroy()
		end

		log("on_gui_click.vonn_story_button: " .. player.name)
	end
end

script.on_event({
	defines.events.on_gui_click,
},vn_story.on_gui_click)


function vn_story.playerCursorImportQuickBarSlot(player, quick_bar_slot, import_text)
	if player.cursor_ghost~=nil then
		return -- skip if ghost on cursor
	elseif not player.cursor_stack.valid then
		return
	elseif player.cursor_stack.valid_for_read then
		return
	end

	local import_stack = player.cursor_stack.import_stack(import_text)
	log("cursor_stack.import_stack: " .. import_stack)

	player.set_quick_bar_slot(quick_bar_slot, player.cursor_stack)
	player.clean_cursor()
end


function vn_story.setupQuickBar(player)
	for index=1,10 do
		if player.get_quick_bar_slot(index) then
			 -- ignore because player already has buttons
			return
		end
	end

	player.set_quick_bar_slot(2,"vn-transport-belt")
	player.set_quick_bar_slot(3,"vn-inserter")
	player.set_quick_bar_slot(4,"burner-inserter")
	player.set_quick_bar_slot(5,"stone-furnace")

	player.set_quick_bar_slot(6,"vn-electric-mining-drill")
	player.set_quick_bar_slot(7,"damaged-assembling-machine")
	player.set_quick_bar_slot(8,"big-electric-pole")
	player.set_quick_bar_slot(9,"roboport")

	vn_story.playerCursorImportQuickBarSlot(
		player,
		10,
		"0eNplkN1qwzAMhd9F1zY0DbQsr1KGCbGamTlSZykjIfjd56Z/a3snjr7Dkc4CHjsm0TR2GpjcKbZEmKBZQFA1UC/nGUmDzu4YomJyA3uEZmOe5QIeFqB2KLvrxvZfLAoGAnmciiWbOxEUB8tk+8Qj+QdTvTIJf0YUtafE0/zgtv84DRFfs+r8aUAToriWvEvcfYtjijM0xzYKmtX19tIqCka89HHVs1lvKVHPfdlbXwZ+SwNFgWZfb6qP3baq97uc/wB3fnxj"
	)
end


function vn_story.addPlayerNeedsZoom(player)
	if not global.playersNeedZoom then
		global.playersNeedZoom = {}
	end
	global.playersNeedZoom[player] = game.tick
	--kprint("player needs zoom" .. " " .. global.playersNeedZoom[player])
end


function vn_story.on_player_created(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local eventName = reverseEventLookup(event.name)
	log("story.on_player_created: ".. player.name)

	if player.connected and player.character then
		vn_story.displayStoryText(player)
		vn_story.addPlayerNeedsZoom(player)
	end
end

script.on_event({
defines.events.on_player_created,
defines.events.on_player_respawned,
},vn_story.on_player_created)


function vn_story.updatePlayerZoom()
	if global.playersNeedZoom then
		local toFix = {}
		for player,tick in pairs(global.playersNeedZoom) do
			if player.valid and game.tick > tick then
				table.insert(toFix,player)
			end
		end
		for _,player in pairs(toFix) do
			global.playersNeedZoom[player] = nil
			--kprint("hiya! ".. player.name .. " " .. game.tick)
			player.zoom = 0.276

			vn_story.setupQuickBar(player)
		end
	end
end


function vn_story.on_tick(_)
	vn_story.updatePlayerZoom()
end

script.on_event({defines.events.on_tick},vn_story.on_tick)


script.register_object(vn_story)


return vn_story


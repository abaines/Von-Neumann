Mod To-Do:
-Update mod description to give idea of gameplay
-Update intro text
-Version indicator in-game?
-Tutorial button in top left?
-Disable player based items (armor, guns, etc)
-Unlock nightvision for godmode without armor when researched?
-Improve 'disallowed action' texts: e.g. "Thuro tried to pick up inserter" -> "Thuro tried to pick up inserter but that is not allowed, use robots!"
-More toolbars to deal with ghost on toolbar issue?
-Maybe give player some basic decon BPs (tree/rock only, ground item only) as starter?
-Prevent player trying to ghost unique items: repaired lab, chest, assemblers, electricity generator
-When items are spilled, don't say player tried to pick them up?
-Scenario ends if main structure is destroyed?

Interesting notes:
-Once a roboport is placed, robots will try to service the area even before it has power (e.g. pick up decon marked items)


-Give players 1 roboport and 5 logic&construction robots with each research, they could just be spilled on ground

-Spread out tutorial buildings
-Biters drop computers because they are competing AIs
-Can we make invisible players?
-Can god players see through fog-of-war? Can I control fog-of-war?

-Give error messages to players making error
-Each research gives more robot/ports
-Disabled research prevents future research?

-Make railbot construction cost energy

-Give way to locate Railbot
-Disable recipes

0.17.75:
- Added filtering support for several common Lua events.

0.17.69:
- Added LuaStyle::rich_text_setting read/write for labels, text boxes, and text fields.
- Added LuaPlayer::request_translation().


grey belts


/c rendering.draw_circle{target={32,0},surface="nauvis",radius=0.1,color={0,1,0},width=1,filled=false,draw_on_ground=false}

/c rendering.draw_polygon{vertices={{target={32,0}},{target={0,32}},{target={32,32}}},surface="nauvis",color={0,0,1}}

/c rendering.draw_line{from={0,0},to={32,32},surface="nauvis",color={0,0,1},width=1}


Angels Petrochem Incompatibility.
https://mods.factorio.com/mod/vonNeumann/discussion/5de1b62f082e2b000b9923c8


data.raw["character-corpse"]["character-corpse"].time_to_live


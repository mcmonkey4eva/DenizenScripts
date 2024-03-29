# |------------------------------------
# | D E N I Z E N   E S S E N T I A L S
# |
# | Essentials rewritten in Denizen!
# | dEssentials: Things a servers needs in one easy package!
# | -----------------------------------
#
# @author mcmonkey
# @version 0.1
# @denizen-version 0.9.7
# @denizen-build 1596
# @date 2015-07-16
#
# @special_thanks_to Oz (some contributions)
# @special_thanks_to Fortifier42 (updates)
#
# @recommended dWorldEditor http://mcmonkey.org/denizen/repo/entry/22
# @recommended dRegions http://mcmonkey.org/denizen/repo/entry/23
# @recommended dSentry http://mcmonkey.org/denizen/repo/entry/0
#
# Installation:
# Just drop it in your scripts folder and reload :D
# We recommend installation of a permissions plugin for full support.
#
# Usage:
# Use similarly to Essentials.
#
# Ignoring:
# We are not replacing /xp, /weather, /give ... at this time
# because Minecraft and Denizen provide sufficient default commands.
#
# Commands/Permissions:
# /name      -> short description                    -> permission
# ---------------------- Core        -------------------------------------------
# ---------------------- Teleporting -------------------------------------------
# /spawn     -> warp to the world spawn              -> denizen.essentials.user.spawn
# /setspawn  -> set the world spawn point            -> denizen.essentials.admin.setspawn
# /warp      -> warp to a teleport point             -> denizen.essentials.user.warp
# /setwarp   -> set a teleport point                 -> denizen.essentials.admin.setwarp
# ---------------------- Items       -------------------------------------------
# /itemdb    -> shows information on an item         -> denizen.essentials.user.itemdb
# /item      -> gives an item to the player          -> denizen.essentials.admin.item
# /invsee    -> shows a player's inventory           -> denizen.essentials.admin.invsee
# /endersee  -> shows a player's enderchest          -> denizen.essentials.admin.endersee
# /enchant   -> allows you to easily enchant an item -> denizen.essentials.admin.enchant
# ---------------------- Control     -------------------------------------------
# /time      -> sets the world's time                -> denizen.essentials.admin.time
# /day       -> sets the time to day                 -> denizen.essentials.admin.time
# /night     -> sets the time to night               -> denizen.essentials.admin.time
# /speed     -> sets a player's speed                -> denizen.essentials.admin.speed
# /butcher   -> removes entities within area         -> denizen.essentials.admin.butcher
# ---------------------- Fun         -------------------------------------------
# /celebrate -> launches a celebration show          -> denizen.essentials.user.celebrate
# ---------------------- Utility     -------------------------------------------
# sign coloring                                     -> denizen.essentials.utility.signcolor
# chat coloring                                     -> denizen.essentials.utility.chatcolor
# ------------------------------------------------------------------------------

dessentials_core_placeholder:
    type: data
    description: This is here so the YAML file doesn't show an error for being empty. This file will eventually be used for 'core' commands, if any are chosen.

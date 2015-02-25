# +--------------------
# |
# | C h a t   P i n g s
# |
# | Alerts when somebody says your name
#
# @author mcmonkey
# @date 2014 / 11 / 19
# @build 1534
# @version 1.1
#
# Installation:
# Just put the script in your scripts folder and reload.
#
# Usage:
# Just say someone's name, everything is automatic.
#
#
# ---------------------------- END HEADER ----------------------------

chat_ping_world:
    type: world
    debug: false
    events:
        on player chats:
        - foreach <server.list_online_players> {
          - if <context.message.contains[<def[value].name>]> || <context.message.contains[<def[value].name.display.strip_color>]> {
            - announce to_console "<&6>Denizen<&co> <&7><player.name> mentions <%value%.name>"
            - narrate targets:%value% "<player.name><&b> mentioned you!"
            - playsound <def[value].location> sound:successful_hit
            }
          }




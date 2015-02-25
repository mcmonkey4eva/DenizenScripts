# +--------------------
# |
# | C h a t   A l e r t
# |
# | Makes a little noise when somebody speaks.
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
# Type /alertme or /chatalert to opt out of chat noises.
#
#
# ---------------------------- END HEADER ----------------------------

chat_alert_world:
    type: world
    debug: false
    events:
        on player chats:
        - playsound <server.list_online_players.exclude[<server.get_online_players_flagged[chatalert_optout]>]> sound:NOTE_STICKS

chat_alert_command:
    type: command
    debug: false
    name: chatalert
    aliases:
    - alertme
    description: Sets whether you get chat alert noises.
    usage: /chatalert
    script:
    - if <player.flag[chatalert_optout]||false> {
      - flag player chatalert_optout:!
      - narrate "<&b>Now receiving chat alert noises."
      }
      else {
      - flag player chatalert_optout:true
      - narrate "<&c>No longer receiving chat alert noises."
      }





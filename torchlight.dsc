# +----------------------
# | Torch Light
# |
# | Light from your torch without placing it!
# +----------------------
#
# @author mcmonkey
# @denizen-version 0.9.6
# @version 1.0
#
# Installation:
# Just drop it in your scripts folder :)
#
# Usage:
# Hold a torch and run around!
#
# +----------------------

torch_light_world:
    type: world
    debug: false
    events:
        on player steps on block:
        - if <player.has_flag[torch_light_prev]> {
          - showfake m@air <context.previous_location> duration:1t
          - flag player torch_light_prev:!
          }
        - if <player.item_in_hand.material.name> == torch && !<context.location.add[0,1,0].material.is_solid> {
          - showfake m@torch <context.location.add[0,1,0]> duration:1d
          - flag player torch_light_prev
          }


# |----------------------
# |
# | Sample Inventory Menu
# |
#
# @author mcmonkey
# @date 2014 / 10 / 19
# @build 1534
# @version 1.0
#
# Installation:
# To test this, simple put the script in your folder
# and reload scripts. Do /sampleinvmenu to open the menu.
# Note: You need permission denizen.sampleinvmenu to run the command.
# Note: You need permission denizen.sampleinvmenu.god to use the 'god' item.
# This is meant to be used as a basis for your own inventory menus,
# not used directly.
#
#
# ---------------------------- END HEADER ----------------------------

# The command handler
sim_handler_command:
    type: command
    name: sampleinvmenu
    description: Opens a sample inventory-menu.
    usage: /sampleinvmenu
    # Only show help if the player has the permission node
    allowed help:
    - determine <player.has_permission[denizen.sampleinvmenu]||false>
    script:
    # No servers
    - if <context.server>:
      - narrate "<&c>This is a player-only command."
      - stop
    # Need permission
    - if !<player.has_permission[denizen.sampleinvmenu]||false>:
      - narrate "<&c>You lack the permission for this command."
      - stop
    # Show the inventory to the linked player
    - inventory open d:in@sim_inventory

# The world event based handler
sim_handler_world:
    type: world
    events:
        on player clicks sim_god_item in inventory:
        # Confirm permission node
        - if !<player.has_permission[denizen.sampleinvmenu.god]||false>:
          - narrate "<&c>You lack the permission for this menu item."
          - stop
        - narrate "<&2>At this point, you'd receive god!"
        # Prevent the click
        - determine cancelled
        on player clicks sim_potato_item in inventory:
        # Player already has the inventory open, so they have all permissions needed already.
        - narrate "<&2>Here's a potato."
        # Prevent the click
        - determine passively cancelled
        # Editing inventories in an inventory event is bad...
        # Wait a tick before giving the potato to be safe.
        - wait 1t
        - give potato


# The main inventory script
sim_inventory:
    type: inventory
    inventory: chest
    # Shows at the top of the inventory
    title: <&b><&l>Sample Inventory Menu
    size: 27
    slots:
    # Place both items in the top and middle center.
    # Fill the [] with your other inventory-menu items.
    - "[] [] [] [] [sim_god_item] [] [] [] []"
    - "[] [] [] [] [sim_potato_item] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"

# Here and below: the items for the inventory
# Note: These items are to never be used outside the menu inventory!
sim_god_item:
    type: item
    material: diamond_block
    display name: <&b>God
    lore:
    - <&e>Gives you godmode.

sim_potato_item:
    type: item
    material: potato_item
    display name: <&b>Potato
    lore:
    - <&e>Gives you a potato.

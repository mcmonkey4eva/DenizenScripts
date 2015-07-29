# See dArrowTypes-Core.yml for information

darrowtypes_explosion_task:
    type: task
    definitions: projectile|location|power
    script:
    - explode power:<def[power]> <def[location]>

darrowtypes_small_bomb_arrow:
    type: item
    material: arrow
    display name: Small Bomb Arrow
    lore:
    - This arrow causes a
    - small explosion on
    - impact.
    dat_settings:
        weight: 2
        is_bomb: true
        impact_script_task: darrowtypes_explosion_task
        impact_script_defs: 1

darrowtypes_large_bomb_arrow:
    type: item
    material: arrow
    display name: Large Bomb Arrow
    lore:
    - This arrow causes a
    - large explosion on
    - impact.
    dat_settings:
        weight: 3
        is_bomb: true
        impact_script_task: darrowtypes_explosion_task
        impact_script_defs: 3

darrowtypes_weak_bpg:
    type: item
    material: bow
    display name: Weak BPG Launcher
    lore:
    - This bow will shoot
    - bomb arrows!
    dat_settings:
        strength: 2.5
        bombs: true

darrowtypes_strong_bpg:
    type: item
    material: bow
    display name: Strong BPG Launcher
    lore:
    - This bow will shoot
    - large bomb arrows!
    dat_settings:
        strength: 4
        bombs: true

darrowtypes_cannon:
    type: item
    material: bow
    display name: Cannon
    lore:
    - This high-power device
    - (formerly known as a bow)
    - will launch everything at
    - maximum force!
    dat_settings:
        strength: 6
        bombs: true

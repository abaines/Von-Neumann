-- From Factorio 1.0.0

local sb = serpent.block -- luacheck: ignore 211


data:extend{
{
  close_sound = {
    {
      filename = "__base__/sound/machine-close.ogg",
      volume = 0.5
    }
  },
  collision_box = {
    {
      -2.2000000000000002,
      -1.2
    },
    {
      2.2000000000000002,
      1.2
    }
  },
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",
  energy_source = {
    emissions_per_minute = 4,
    type = "electric",
    usage_priority = "secondary-input"
  },
  energy_usage = "60kW",
  entity_info_icon_shift = {
    1,
    0
  },
  flags = {
    "not-deconstructable",
    "placeable-player",
    "player-creation",
    "hidden"
  },
  icon = "__vonNeumann__/graphics/icons/crash-site-lab-repaired.png",
  icon_mipmaps = 4,
  icon_size = 64,
  inputs = {
    "automation-science-pack"
  },
  integration_patch = {
    filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-ground.png",
    frame_count = 1,
    height = 170,
    hr_version = {
      filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-ground.png",
      frame_count = 1,
      height = 344,
      line_length = 1,
      priority = "very-low",
      scale = 0.5,
      shift = {
        -1.53125,
        0.34375
      },
      width = 700
    },
    line_length = 1,
    priority = "very-low",
    shift = {
      -1.5,
      0.375
    },
    width = 352
  },
  integration_patch_render_layer = "decals",
  light = {
    color = {
      b = 1,
      g = 1,
      r = 1
    },
    intensity = 0.9,
    shift = {
      1.5,
      0.5
    },
    size = 12
  },
  map_color = {
    a = 1,
    b = 0.57999999999999998,
    g = 0.36499999999999999,
    r = 0
  },
  max_health = 150,
  name = "crash-site-lab-repaired",
  off_animation = {
    layers = {
      {
        animation_speed = 0.3333333333333333,
        filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-repaired.png",
        frame_count = 1,
        height = 126,
        hr_version = {
          animation_speed = 0.3333333333333333,
          filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-repaired.png",
          frame_count = 1,
          height = 252,
          line_length = 1,
          priority = "very-low",
          repeat_count = 24,
          scale = 0.5,
          shift = {
            -0.5625,
            0.4375
          },
          width = 488
        },
        line_length = 1,
        priority = "very-low",
        repeat_count = 24,
        shift = {
          -0.5625,
          0.4375
        },
        width = 244
      },
      {
        animation_speed = 0.3333333333333333,
        draw_as_shadow = true,
        filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-repaired-shadow.png",
        frame_count = 1,
        height = 148,
        hr_version = {
          animation_speed = 0.3333333333333333,
          draw_as_shadow = true,
          filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-repaired-shadow.png",
          frame_count = 1,
          height = 302,
          line_length = 1,
          priority = "very-low",
          repeat_count = 24,
          scale = 0.5,
          shift = {
            -0.34375,
            0.375
          },
          width = 696
        },
        line_length = 1,
        priority = "very-low",
        repeat_count = 24,
        shift = {
          -0.375,
          0.375
        },
        width = 350
      }
    }
  },
  on_animation = {
    layers = {
      {
        animation_speed = 0.3333333333333333,
        filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-repaired.png",
        frame_count = 1,
        height = 126,
        hr_version = {
          animation_speed = 0.3333333333333333,
          filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-repaired.png",
          frame_count = 1,
          height = 252,
          line_length = 1,
          priority = "very-low",
          repeat_count = 24,
          scale = 0.5,
          shift = {
            -0.5625,
            0.4375
          },
          width = 488
        },
        line_length = 1,
        priority = "very-low",
        repeat_count = 24,
        shift = {
          -0.5625,
          0.4375
        },
        width = 244
      },
      {
        animation_speed = 0.3333333333333333,
        blend_mode = "additive",
        filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-repaired-beams.png",
        frame_count = 24,
        height = 50,
        hr_version = {
          animation_speed = 0.3333333333333333,
          blend_mode = "additive",
          filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-repaired-beams.png",
          frame_count = 24,
          height = 100,
          line_length = 6,
          priority = "very-low",
          scale = 0.5,
          shift = {
            1.15625,
            -0.625
          },
          width = 130
        },
        line_length = 6,
        priority = "very-low",
        shift = {
          1.125,
          -0.625
        },
        width = 68
      },
      {
        animation_speed = 0.3333333333333333,
        draw_as_shadow = true,
        filename = "__vonNeumann__/graphics/entity/crash-site-lab/crash-site-lab-repaired-shadow.png",
        frame_count = 1,
        height = 148,
        hr_version = {
          animation_speed = 0.3333333333333333,
          draw_as_shadow = true,
          filename = "__vonNeumann__/graphics/entity/crash-site-lab/hr-crash-site-lab-repaired-shadow.png",
          frame_count = 1,
          height = 302,
          line_length = 1,
          priority = "very-low",
          repeat_count = 24,
          scale = 0.5,
          shift = {
            -0.34375,
            0.375
          },
          width = 696
        },
        line_length = 1,
        priority = "very-low",
        repeat_count = 24,
        shift = {
          -0.375,
          0.375
        },
        width = 350
      }
    }
  },
  open_sound = {
    {
      filename = "__base__/sound/machine-open.ogg",
      volume = 0.5
    }
  },
  researching_speed = 1,
  selection_box = {
    {
      -2.5,
      -1.5
    },
    {
      2.5,
      1.5
    }
  },
  type = "lab",
  vehicle_impact_sound = {
    {
      filename = "__base__/sound/car-metal-impact-2.ogg",
      volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-3.ogg",
      volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-4.ogg",
      volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-5.ogg",
      volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-6.ogg",
      volume = 0.5
    }
  },
  working_sound = {
    audible_distance_modifier = 0.7,
    fade_in_ticks = 4,
    fade_out_ticks = 20,
    sound = {
      filename = "__base__/sound/lab.ogg",
      volume = 0.7
    }
  }
}
}


--log("crash-site-lab-repaired:\n"..sb( data.raw['lab']['crash-site-lab-repaired'] ))


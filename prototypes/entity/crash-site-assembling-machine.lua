-- From Factorio 1.0.0

local sb = serpent.block -- luacheck: ignore 211


data:extend{
{
  alert_icon_shift = {
    -0.09375,
    -0.375
  },
  animation = {
    layers = {
      {
        animation_speed = 2,
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-1-repaired.png",
        frame_count = 20,
        height = 92,
        hr_version = {
          animation_speed = 2,
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-1-repaired.png",
          frame_count = 20,
          height = 182,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            -0.375,
            0.09375
          },
          width = 282
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          -0.375,
          0.0625
        },
        width = 142
      },
      {
        animation_speed = 2,
        draw_as_shadow = true,
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-1-repaired-shadow.png",
        frame_count = 20,
        height = 84,
        hr_version = {
          animation_speed = 2,
          draw_as_shadow = true,
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-1-repaired-shadow.png",
          frame_count = 20,
          height = 168,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            0.125,
            0.1875
          },
          width = 278
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          0.125,
          0.1875
        },
        width = 140
      }
    }
  },
  close_sound = {
    {
      filename = "__base__/sound/machine-close.ogg",
      volume = 0.5
    }
  },
  collision_box = {
    {
      -1.2,
      -0.7
    },
    {
      1.2,
      0.7
    }
  },
  corpse = "big-remnants",
  crafting_categories = {
    "crafting",
    "basic-crafting",
    "advanced-crafting"
  },
  crafting_speed = 0.3,
  dying_explosion = "medium-explosion",
  energy_source = {
    emissions_per_minute = 4,
    type = "electric",
    usage_priority = "secondary-input"
  },
  energy_usage = "90kW",
  flags = {
    "not-deconstructable",
    "hidden",
    "not-rotatable"
  },
  icon = "__vonNeumann__/graphics/icons/crash-site-assembling-machine-1-repaired.png",
  icon_mipmaps = 4,
  icon_size = 64,
  ingredient_count = 2,
  integration_patch = {
    filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-1-ground.png",
    frame_count = 1,
    height = 116,
    hr_version = {
      filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-1-ground.png",
      frame_count = 1,
      height = 234,
      line_length = 1,
      priority = "very-low",
      scale = 0.5,
      shift = {
        -0.96875,
        0.375
      },
      width = 446
    },
    line_length = 1,
    priority = "very-low",
    shift = {
      -0.75,
      0.375
    },
    width = 208
  },
  integration_patch_render_layer = "decals",
  map_color = {
    a = 1,
    b = 0.57999999999999998,
    g = 0.36499999999999999,
    r = 0
  },
  max_health = 300,
  name = "crash-site-assembling-machine-1-repaired",
  open_sound = {
    {
      filename = "__base__/sound/machine-open.ogg",
      volume = 0.5
    }
  },
  resistances = {
    {
      percent = 70,
      type = "fire"
    }
  },
  selection_box = {
    {
      -1.5,
      -1
    },
    {
      1.5,
      1
    }
  },
  type = "assembling-machine",
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
    sound = {
      {
        filename = "__base__/sound/assembling-machine-repaired-1.ogg",
        volume = 0.8
      }
    }
  },
  working_visualisations = {
    {
      animation = {
        animation_speed = 2,
        blend_mode = "additive",
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-1-repaired-light.png",
        frame_count = 20,
        height = 64,
        hr_version = {
          animation_speed = 2,
          blend_mode = "additive",
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-1-repaired-light.png",
          frame_count = 20,
          height = 120,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            0.375,
            -0.25
          },
          width = 162
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          0.3125,
          -0.3125
        },
        width = 78
      }
    }
  }
}
}


data:extend{
{
  alert_icon_shift = {
    -0.09375,
    -0.375
  },
  animation = {
    layers = {
      {
        animation_speed = 0.66666666666666661,
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-2-repaired.png",
        frame_count = 20,
        height = 98,
        hr_version = {
          animation_speed = 0.66666666666666661,
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-2-repaired.png",
          frame_count = 20,
          height = 200,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            -0.125,
            -0.34375
          },
          width = 198
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          -0.125,
          -0.3125
        },
        width = 100
      },
      {
        animation_speed = 0.66666666666666661,
        draw_as_shadow = true,
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-2-repaired-shadow.png",
        frame_count = 20,
        height = 86,
        hr_version = {
          animation_speed = 0.66666666666666661,
          draw_as_shadow = true,
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-2-repaired-shadow.png",
          frame_count = 20,
          height = 174,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            0.09375,
            -0.28125
          },
          width = 208
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          0.0625,
          -0.25
        },
        width = 106
      }
    }
  },
  close_sound = {
    {
      filename = "__base__/sound/machine-close.ogg",
      volume = 0.5
    }
  },
  collision_box = {
    {
      -0.7,
      -1.2
    },
    {
      0.7,
      1.2
    }
  },
  corpse = "big-remnants",
  crafting_categories = {
    "crafting",
    "basic-crafting",
    "advanced-crafting"
  },
  crafting_speed = 1,
  dying_explosion = "medium-explosion",
  energy_source = {
    emissions_per_minute = 4,
    type = "electric",
    usage_priority = "secondary-input"
  },
  energy_usage = "90kW",
  flags = {
    "not-deconstructable",
    "hidden",
    "not-rotatable"
  },
  icon = "__vonNeumann__/graphics/icons/crash-site-assembling-machine-2-repaired.png",
  icon_mipmaps = 4,
  icon_size = 64,
  ingredient_count = 2,
  integration_patch = {
    filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-2-ground.png",
    frame_count = 1,
    height = 106,
    hr_version = {
      filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-2-ground.png",
      frame_count = 1,
      height = 238,
      line_length = 1,
      priority = "very-low",
      scale = 0.5,
      shift = {
        -0.25,
        -0.3125
      },
      width = 290
    },
    line_length = 1,
    priority = "very-low",
    shift = {
      -0.25,
      -0.125
    },
    width = 146
  },
  integration_patch_render_layer = "decals",
  map_color = {
    a = 1,
    b = 0.57999999999999998,
    g = 0.36499999999999999,
    r = 0
  },
  max_health = 300,
  name = "crash-site-assembling-machine-2-repaired",
  open_sound = {
    {
      filename = "__base__/sound/machine-open.ogg",
      volume = 0.5
    }
  },
  resistances = {
    {
      percent = 70,
      type = "fire"
    }
  },
  selection_box = {
    {
      -1,
      -1.5
    },
    {
      1,
      1.5
    }
  },
  type = "assembling-machine",
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
    fade_in_ticks = 4,
    fade_out_ticks = 20,
    sound = {
      {
        filename = "__base__/sound/assembling-machine-repaired-1.ogg",
        volume = 0.8
      }
    }
  },
  working_visualisations = {
    {
      animation = {
        animation_speed = 0.66666666666666661,
        blend_mode = "additive",
        filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/crash-site-assembling-machine-2-repaired-light.png",
        frame_count = 20,
        height = 62,
        hr_version = {
          animation_speed = 0.66666666666666661,
          blend_mode = "additive",
          filename = "__vonNeumann__/graphics/entity/crash-site-assembling-machine/hr-crash-site-assembling-machine-2-repaired-light.png",
          frame_count = 20,
          height = 124,
          line_length = 5,
          priority = "very-low",
          scale = 0.5,
          shift = {
            -0.21875,
            -0.125
          },
          width = 174
        },
        line_length = 5,
        priority = "very-low",
        shift = {
          -0.25,
          -0.1875
        },
        width = 84
      }
    }
  }
}
}


for k,v in pairs(data.raw["assembling-machine"]) do
	log(sb(k))
end
log("crash-site-assembling-machine-1-repaired:\n"..sb(data.raw["assembling-machine"]["crash-site-assembling-machine-1-repaired"]))
log("crash-site-assembling-machine-2-repaired:\n"..sb(data.raw["assembling-machine"]["crash-site-assembling-machine-2-repaired"]))

data.raw["assembling-machine"]["crash-site-assembling-machine-1-repaired"].energy_source.drain="0kW"
data.raw["assembling-machine"]["crash-site-assembling-machine-2-repaired"].energy_source.drain="0kW"


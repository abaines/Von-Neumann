-- From Factorio 1.0.0

local sb = serpent.block -- luacheck: ignore 211


data:extend{
{
  allow_copy_paste = false,
  animation = {
    layers = {
      {
        animation_speed = 0.3333333333333333,
        filename = "__vonNeumann__/graphics/entity/crash-site-generator/crash-site-generator.png",
        frame_count = 5,
        height = 128,
        hr_version = {
          animation_speed = 0.3333333333333333,
          filename = "__vonNeumann__/graphics/entity/crash-site-generator/hr-crash-site-generator.png",
          frame_count = 5,
          height = 252,
          line_length = 5,
          priority = "very-low",
          repeat_count = 16,
          scale = 0.5,
          shift = {
            -0.34375,
            -0.71875
          },
          width = 286
        },
        line_length = 5,
        priority = "very-low",
        repeat_count = 16,
        shift = {
          -0.3125,
          -0.75
        },
        width = 142
      },
      {
        animation_speed = 0.3333333333333333,
        filename = "__vonNeumann__/graphics/entity/crash-site-generator/crash-site-generator-beams.png",
        frame_count = 16,
        height = 116,
        hr_version = {
          animation_speed = 0.3333333333333333,
          filename = "__vonNeumann__/graphics/entity/crash-site-generator/hr-crash-site-generator-beams.png",
          frame_count = 16,
          height = 232,
          line_length = 4,
          priority = "very-low",
          repeat_count = 5,
          scale = 0.5,
          shift = {
            -0.25,
            -0.9375
          },
          width = 224
        },
        line_length = 4,
        priority = "very-low",
        repeat_count = 5,
        shift = {
          0.75,
          -0.9375
        },
        width = 48
      },
      {
        animation_speed = 0.3333333333333333,
        draw_as_shadow = true,
        filename = "__vonNeumann__/graphics/entity/crash-site-generator/crash-site-generator-shadow.png",
        frame_count = 1,
        height = 78,
        hr_version = {
          animation_speed = 0.3333333333333333,
          draw_as_shadow = true,
          filename = "__vonNeumann__/graphics/entity/crash-site-generator/hr-crash-site-generator-shadow.png",
          frame_count = 1,
          height = 152,
          line_length = 1,
          priority = "very-low",
          repeat_count = 80,
          scale = 0.5,
          shift = {
            0.78125,
            0.15625
          },
          width = 474
        },
        line_length = 1,
        priority = "very-low",
        repeat_count = 80,
        shift = {
          0.8125,
          0.125
        },
        width = 236
      }
    }
  },
  collision_box = {
    {
      -1.5,
      -0.9
    },
    {
      0.9,
      0.9
    }
  },
  continuous_animation = true,
  corpse = "medium-remnants",
  energy_production = "500GW",
  energy_source = {
    buffer_capacity = "10GJ",
    input_flow_limit = "0kW",
    output_flow_limit = "500GW",
    type = "electric",
    usage_priority = "tertiary"
  },
  energy_usage = "0kW",
  flags = {
    "not-deconstructable",
    "placeable-player",
    "player-creation",
    "hidden",
    "not-rotatable"
  },
  icon = "__vonNeumann__/graphics/icons/crash-site-generator.png",
  icon_mipmaps = 4,
  icon_size = 64,
  integration_patch = {
    filename = "__vonNeumann__/graphics/entity/crash-site-generator/crash-site-generator-ground.png",
    frame_count = 1,
    height = 180,
    hr_version = {
      filename = "__vonNeumann__/graphics/entity/crash-site-generator/hr-crash-site-generator-ground.png",
      frame_count = 1,
      height = 360,
      line_length = 1,
      priority = "very-low",
      scale = 0.5,
      shift = {
        -0.875,
        -1.1875
      },
      width = 384
    },
    line_length = 1,
    priority = "very-low",
    shift = {
      -0.875,
      -1.1875
    },
    width = 192
  },
  integration_patch_render_layer = "decals",
  light = {
    color = {
      b = 1,
      g = 1,
      r = 1
    },
    intensity = 0.75,
    shift = {
      1,
      -2.1875
    },
    size = 6
  },
  map_color = {
    a = 1,
    b = 0.57999999999999998,
    g = 0.36499999999999999,
    r = 0
  },
  max_health = 150,
  name = "crash-site-generator",
  selection_box = {
    {
      -1.5,
      -0.9
    },
    {
      0.9,
      0.9
    }
  },
  type = "electric-energy-interface",
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
  }
}
}


--log("crash-site-generator:\n"..sb( data.raw['electric-energy-interface']['crash-site-generator'] ))


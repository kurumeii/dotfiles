local MiniAnimate = require('mini.animate')

MiniAnimate.setup({
  cursor = {
    enable = false,
    timing = MiniAnimate.gen_timing.linear({
      duration = 100,
      unit = 'total',
    }),
  },
  scroll = {
    enable = true,
    timing = MiniAnimate.gen_timing.linear({
      duration = 100,
      unit = 'total',
    }),
    subscroll = MiniAnimate.gen_subscroll.equal({
      predicate = function(total_scroll)
        return total_scroll > 1
      end,
    }),
  },
  resize = { enable = true, timing = MiniAnimate.gen_timing.linear({
    duration = 50,
    unit = 'total',
  }) },
  open = { enable = true },
  close = { enable = true },
})

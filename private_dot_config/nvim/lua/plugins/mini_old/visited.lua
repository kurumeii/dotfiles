require('mini.visits').setup()

MiniVisits.list_paths(nil, {
  sort = MiniVisits.gen_sort.z(),
  filter = MiniVisits.gen_filter.default(),
})

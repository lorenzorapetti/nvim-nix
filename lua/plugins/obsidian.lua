require('obsidian').setup {
  legacy_commands = false,
  workspaces = {
    {
      name = 'Personal',
      path = '~/Nextcloud/Obsidian/Personal',
    },
    {
      name = 'Work',
      path = '~/Nextcloud/Obsidian/Work',
    },
  },
  picker = {
    name = 'snacks.picker',
  },
  daily_notes = {
    folder = '5 - Journal',
    date_format = 'YYYY/MMM/YYYY-MM-DD',
  },
}

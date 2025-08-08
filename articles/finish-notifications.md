# Finish Notifications on macOS

Make your agent pop a macOS Notification Center banner and play a brief system sound when a task completes.

## Install
The script lives at `~/bin/notify_done.sh` and prefers `terminal-notifier` (banner + sound). It falls back to AppleScript + `afplay`, and then to `say`.

```bash
# Recommended install for banners
brew install terminal-notifier

# Example usage
/Users/erick/bin/notify_done.sh "Lint + tests finished" Ping
```

- First arg: message
- Second arg (optional): system sound (e.g., `Ping`, `Pop`, `Frog`)
- Auto-emoji: the script appends a relevant emoji based on keywords (tests🧪, deploy🚀, lint🧹, fishing🎣, etc.)

## Cursor Rule
Add a completion reminder so the agent triggers a toast:

```
- When a task completes, run: /Users/erick/bin/notify_done.sh "${TASK_NAME:-Task finished}" Ping  # terminal-notifier + emoji
```

Stored in `.cursor/rules` for this repo.

## Notes
- With `terminal-notifier`, macOS shows a proper Notification Center banner with the chosen sound.
- Without it, the script still uses AppleScript + `afplay`.
- Change the default sound globally by editing the second parameter in `.cursor/rules`.

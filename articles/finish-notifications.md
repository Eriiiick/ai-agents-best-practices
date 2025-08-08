# Finish Notifications on macOS

Make your agent pop a macOS notification and play a brief system sound when a task completes.

## Install
The repo includes a tiny script at `~/bin/notify_done.sh` using built-in `osascript` and `afplay`.

```bash
/Users/erick/bin/notify_done.sh "Lint + tests finished" Submarine
```

- First arg: message
- Second arg (optional): system sound (e.g., `Submarine`, `Ping`, `Pop`)

## Cursor Rule
Add a completion reminder so the agent triggers a toast:

```
- When a task completes, run: /Users/erick/bin/notify_done.sh "${TASK_NAME:-Task finished}" Submarine
```

Stored in `.cursor/rules` for this repo.

## Notes
- Notifications use Notification Center via AppleScript. If blocked, it falls back to `say` plus the sound.
- You can change the default sound globally by editing the second parameter in `.cursor/rules`.

# filters-fix

Fixes for NVIDIA App overlay/filters. Blocks or patches the connection so filters work properly.

**Run as Administrator** (right-click → Run as administrator).

---

## Quick Start

Run **`filters-fix.bat`** as Administrator for a menu:

- Type `1` — Block NVIDIA (permanent)
- Type `2` — Restore connection (undo)
- Type `3` — Temp fix (temporary block)
- Type `0` — Exit

---

## Scripts

| Script | Description |
|--------|-------------|
| **temp_fix.ps1** | Temporary fix that blocks the connection with NVIDIA App. If your PC restarts or turns off, you need to run it again. |
| **block_nvidia_perm.ps1** | Permanent fix. Adds firewall rules to block the NVIDIA App connection. Survives reboots. |
| **block_nvidia_ctrlz.ps1** | Undo. Removes the firewall rules and restores the connection with NVIDIA App. |

---

## Usage

**Recommended:** Run `filters-fix.bat` as Administrator for the menu.

Or run scripts manually in PowerShell as Administrator:

- `.\temp_fix.ps1` — Temporary block
- `.\block_nvidia_perm.ps1` — Permanent block
- `.\block_nvidia_ctrlz.ps1` — Restore connection

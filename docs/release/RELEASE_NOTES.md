## 🚀 Changelog [v1.2.0] — OBS Studio 33 Compatibility Update

* **[OBS 33 Support]** Updated image loading to use the new `gs_image_file_ex` API introduced in OBS Studio 33.0.0 (#12, #13).
* **[OBS 33 Support]** Updated property buttons to `obs_properties_add_button2` to resolve OBS 33 deprecation errors.
* **[Modern Plugin Packaging]** Migrated installation directory to the official OBS Studio plugin path (`C:\ProgramData\obs-studio\plugins\flood-tuber`) so the plugin is no longer flagged as a "Legacy Plugin" in OBS 33 (#3).
* **[Automatic Cleanup & Migration]** The installer now automatically cleans up legacy files from `C:\Program Files\obs-studio`, and existing scenes using built-in avatars automatically migrate to the new `ProgramData` path without breaking.
* **[Localization]** Added French (`fr-FR`) localization for plugin settings and UI.

> **📌 Version Compatibility Note:**
> * **OBS Studio 33.0.0 and newer:** Use **v1.2.0** (this release).
> * **OBS Studio 32.x and older:** Please continue using **[v1.1.0](https://github.com/justflood/flood-tuber/releases/tag/v1.1.0)**.

---

## ❤️ Special Thanks & Credits
Huge thanks to the community members who helped make this release happen:
* **@IamS3pt1m** — For submitting PR #13 (`gs_image_file_ex` support for OBS 33) and reporting Issue #12.
* **@Poste2Travail (Mardios Lambda)** — For the `obs_properties_add_button2` fixes, adding the French (`fr-FR`) localization, testing on OBS 33, and helping community members on Discord with workarounds!
* **@shinyflvre** — For reporting the standard OBS `ProgramData` plugin folder structure (#3).

---

## 📦 Downloads
Choose the version that best fits your needs:

* **`FloodTuber-Installer-1.2.0.exe`** *(Recommended)*
  Automatically installs to `C:\ProgramData\obs-studio\plugins\flood-tuber` and removes outdated files from previous installations.
* **`FloodTuber-Portable-v1.2.0.zip`**
  For manual setup. Extract the `flood-tuber` folder directly into `C:\ProgramData\obs-studio\plugins\`.

---

## ⚠️ Windows SmartScreen Warning (Important)
Since this project is open-source and independently developed, it does not currently hold a code signing certificate. Because of this, Windows might display a **"Windows protected your PC"** warning during installation.

This is **completely normal behavior** for unsigned open-source software.

**To proceed with the installation, follow these steps:**
1. Click on `More Info` on the warning screen.
2. Click the `Run Anyway` button that appears at the bottom right.

---

### 🔒 SHA-256 Checksums

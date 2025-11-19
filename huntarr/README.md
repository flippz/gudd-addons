# Home Assistant Add-on: Huntarr

[![Release][release-shield]][release] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield]

Huntarr is an automatic missing content hunter for Sonarr, Radarr, Lidarr, Readarr, and Whisparr.

## About

Huntarr continually searches your media libraries for missing content and items that need quality upgrades. It automatically triggers searches for both missing items and those below your quality cutoff. It's designed to run continuously while being gentle on your indexers, helping you gradually complete your media collection with the best available quality.

**The problem:** Your *arr apps only monitor RSS feeds for new releases. They don't go back and search for missing episodes/movies already in your library.

**The solution:** Huntarr systematically scans your entire library, finds all missing content, and searches for it in small batches that won't overwhelm your indexers or get you banned. It's the difference between having a "mostly complete" library and actually having everything you want.

## Features

- 🔄 **Continuous Automation** - Runs continuously to find and upgrade media
- 🎯 **Smart Searching** - Finds missing content and quality upgrades
- 🔌 **Multi-App Support** - Works with Sonarr, Radarr, Lidarr, Readarr, and Whisparr
- 🚦 **API Management** - Implements hourly caps to prevent overloading indexers
- ⏱️ **Batch Processing** - Controls how many items to process per cycle
- 📊 **Web Interface** - Clean UI for monitoring and configuration
- 🔧 **Customizable** - Adjustable intervals and processing limits

## Installation

1. Add this repository to your Home Assistant instance
2. Install the "Huntarr" add-on
3. Start the add-on
4. Access the web UI through the add-on page or via port 9705

## Configuration

Add-on configuration:

```yaml
TZ: America/New_York
env_vars: []
```

### Option: `TZ`

Set your timezone for accurate scheduling.

### Option: `env_vars`

Add additional environment variables if needed.

```yaml
env_vars:
  - name: VARIABLE_NAME
    value: "value"
```

## Initial Setup

After starting the addon:

1. Access the Huntarr web interface
2. Configure your *arr applications (Sonarr, Radarr, etc.)
   - Add API URL and API key for each service
3. Configure your settings:
   - Set the number of items to process per cycle
   - Configure the wait interval between cycles
   - Set API hourly caps to prevent indexer overload
4. Start hunting for missing content!

## How It Works

### Continuous Automation Cycle

1. **Connect & Analyze** - Huntarr connects to your *arr instances and analyzes your media libraries
2. **Hunt Missing Content** - Efficiently finds content you're missing
3. **Hunt Quality Upgrades** - Finds content below your quality cutoff
4. **API Management** - Manages API calls to prevent overloading indexers
5. **Repeat & Rest** - Waits for your configured interval before starting the next cycle

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Community Forum][forum]
- The [GitHub Issue Tracker][issue]
- [Huntarr Discord][discord]

## Authors & Contributors

The original setup of this repository is by [alexbelgium][alexbelgium].

Huntarr is created and maintained by [PlexGuide][plexguide].

## License

MIT License

Copyright (c) 2019-2025 alexbelgium

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[release-shield]: https://img.shields.io/badge/version-8.2.10-blue.svg
[release]: https://github.com/alexbelgium/hassio-addons/tree/master/huntarr
[forum]: https://community.home-assistant.io/t/alexbelgium-repo-60-addons
[issue]: https://github.com/alexbelgium/hassio-addons/issues
[discord]: https://discord.com/invite/PGJJjR5Cww
[alexbelgium]: https://github.com/alexbelgium
[plexguide]: https://github.com/plexguide

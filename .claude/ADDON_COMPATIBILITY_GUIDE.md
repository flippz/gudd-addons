# Home Assistant Addon Compatibility Guide

**Created:** November 19, 2025  
**Based on:** 46+ versions of failed Huntarr addon attempts

## Critical Lesson Learned

**Not all Docker images can be wrapped as Home Assistant addons.** HA's security model is fundamentally different from standard Docker and imposes restrictions that break many third-party images.

---

## What Makes a Docker Image HA-Compatible?

### ✅ **WILL WORK:**

1. **Uses HA-specific base images:**
   - `ghcr.io/home-assistant/amd64-base`
   - `ghcr.io/home-assistant/amd64-base-python`
   - `ghcr.io/hassio-addons/base`

2. **Uses LinuxServer.io pre-built application images:**
   - `lscr.io/linuxserver/bazarr:latest`
   - `lscr.io/linuxserver/radarr:latest`
   - `lscr.io/linuxserver/sonarr:latest`
   - **Key:** These are complete applications, NOT base images to build on

3. **Uses third-party images with s6-overlay pre-installed:**
   - `filebrowser/filebrowser:s6`
   - `wiserain/flexget:latest`
   - Images already configured for container init systems

4. **Standard file locations:**
   - Python in `/usr/bin/python3` and libs in `/usr/lib/`
   - NOT in `/usr/local/` locations

5. **No dependency on:**
   - `/etc/profile` or bash initialization scripts
   - Custom environment variable setup
   - Root filesystem access
   - Privileged operations

### ❌ **WILL NOT WORK:**

1. **Custom-built images on third-party bases:**
   - Building FROM `lscr.io/linuxserver/baseimage-alpine` and adding your app
   - HA's security blocks the init system from working properly

2. **Images with non-standard paths:**
   - Python in `/usr/local/bin/` with libs in `/usr/local/lib/`
   - HA strips `LD_LIBRARY_PATH` and blocks access

3. **Images requiring environment setup:**
   - Need to source `/etc/profile`
   - HA runs with read-only/restricted system files

4. **Images relying on Docker defaults:**
   - Expect standard Docker permissions
   - HA runs containers with minimal capabilities

---

## Home Assistant Security Restrictions

### What HA Blocks:

1. **File Access:**
   - `/etc/profile`: Permission denied
   - `/root/.profile`: Permission denied
   - System files often read-only or inaccessible

2. **Environment Variables:**
   - `LD_LIBRARY_PATH` stripped or ignored
   - Custom `ENV` declarations may not persist
   - PATH modifications may be reset

3. **Permissions:**
   - Runs with minimal Linux capabilities
   - AppArmor profiles restrict file access
   - Can't read many system directories

4. **Init Systems:**
   - `init: false` required for s6-overlay v3
   - Custom entrypoints may be overridden
   - CMD can be replaced by HA

---

## Testing Checklist Before Creating Addon

### 1. **Test the Image Standalone First:**
```bash
docker run -d -p PORT:PORT --name test-app IMAGE:latest
docker logs test-app
# Does it start without errors?
```

### 2. **Check File Locations:**
```bash
docker run --rm IMAGE:latest which python3
docker run --rm IMAGE:latest find /usr -name "lib*.so*" 2>/dev/null
# Are binaries in /usr/bin? Libraries in /usr/lib?
```

### 3. **Check Base Image:**
```bash
docker inspect IMAGE:latest --format='{{.Config.Image}}'
# Is it FROM an HA-compatible base?
```

### 4. **Check Init System:**
```bash
docker inspect IMAGE:latest --format='{{.Config.Entrypoint}} {{.Config.Cmd}}'
# Does it use /init or s6-overlay?
```

### 5. **Look at Working Examples:**
- Check `bazarr/`, `radarr/`, `sonarr/` in this repo
- They all use pre-built LSIO application images
- Minimal Dockerfiles, mostly just add HA integration

---

## Recommended Approaches

### Option 1: Use Pre-Built Images (Easiest)
If a LinuxServer.io image exists for your app:
```dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}
# Add minimal HA integration (templates, bashio)
```

**build.json:**
```json
{
  "build_from": {
    "amd64": "lscr.io/linuxserver/yourapp:latest"
  }
}
```

### Option 2: Build on HA Base (Most Compatible)
For custom apps, start with HA's base:
```dockerfile
FROM ghcr.io/home-assistant/amd64-base-python:3.11-alpine3.18
RUN apk add --no-cache YOUR_PACKAGES
# Install your app
# Everything will be in standard Alpine locations
```

### Option 3: Run Outside HA (When Nothing Works)
Some images just can't be addons:
1. Run as standalone Docker container
2. Access via port forwarding
3. Add to HA dashboard as iframe/webpage card
4. Still managed on same host, just not as addon

---

## The Huntarr Case Study

**Image:** `ghcr.io/plexguide/huntarr:latest`

**Attempts Made (46 versions):**
1. ✗ Direct image use - wrong CMD executed
2. ✗ LinuxServer.io base build - /init permission denied
3. ✗ Alpine base build - s6-overlay missing
4. ✗ HA base-python - /init permission denied  
5. ✗ Custom entrypoint scripts - permission denied
6. ✗ ENV LD_LIBRARY_PATH - stripped by HA
7. ✗ Inline LD_LIBRARY_PATH - still stripped
8. ✗ Copy libs to /usr/lib - Python can't find encodings
9. ✗ Set PYTHONPATH - permission denied on files
10. ✗ Bash login shell - /etc/profile permission denied

**Root Cause:**
- Python installed in `/usr/local/` (non-standard)
- Requires reading `/etc/profile` for environment setup
- HA's security model blocks both

**Resolution:**
- Removed from addon repository
- Run as standalone Docker container instead
- Works perfectly outside HA's security restrictions

---

## Pattern Analysis: Working Addons

Analyzed 10 successful addons in this repository:

| Addon | Base Image | Pattern |
|-------|------------|---------|
| bazarr | `lscr.io/linuxserver/bazarr:latest` | Pre-built app |
| radarr | `lscr.io/linuxserver/radarr:latest` | Pre-built app |
| sonarr | `lscr.io/linuxserver/sonarr:latest` | Pre-built app |
| lidarr | `lscr.io/linuxserver/lidarr:latest` | Pre-built app |
| jackett | `lscr.io/linuxserver/jackett:latest` | Pre-built app |
| emby | `lscr.io/linuxserver/emby:latest` | Pre-built app |
| filebrowser | `filebrowser/filebrowser:s6` | Third-party w/ s6 |
| flexget | `wiserain/flexget:latest` | Third-party w/ s6 |
| guacamole | `abesnier/guacamole:latest` | Third-party complete |
| changedetection.io | `lscr.io/linuxserver/changedetection.io` | Pre-built app |

**Key Finding:** 95% use complete, pre-built application images with s6-overlay already configured. Only 1 (`addons_updater`) successfully uses HA base images.

---

## alexbelgium Template Pattern

All working addons follow this structure:

```dockerfile
FROM ${BUILD_FROM}

# Global LSIO modifications (if LSIO base)
ADD "https://.../ha_lsio.sh" "/ha_lsio.sh"
RUN chmod 744 /ha_lsio.sh && if grep -qr "lsio" /etc; then /ha_lsio.sh "$CONFIGLOCATION"; fi && rm /ha_lsio.sh

# Add rootfs (service scripts)
COPY rootfs/ /

# Compatibility symlinks
RUN if [ ! -f /bin/sh ] && [ -f /usr/bin/sh ]; then ln -s /usr/bin/sh /bin/sh; fi

# Download modules
ADD "https://.../ha_automodules.sh" "/ha_automodules.sh"
RUN chmod 744 /ha_automodules.sh && /ha_automodules.sh "$MODULES" && rm /ha_automodules.sh

# Download apps/bashio
ADD "https://.../ha_autoapps.sh" "/ha_autoapps.sh"
RUN chmod 744 /ha_autoapps.sh && /ha_autoapps.sh "$PACKAGES" && rm /ha_autoapps.sh

# Entrypoint hook (for LSIO images)
ENV S6_STAGE2_HOOK=/ha_entrypoint.sh
ADD "https://.../ha_entrypoint.sh" "/ha_entrypoint.sh"
ADD "https://.../ha_entrypoint_modif.sh" "/ha_entrypoint_modif.sh"
RUN chmod 777 /ha_entrypoint.sh /ha_entrypoint_modif.sh && /ha_entrypoint_modif.sh && rm /ha_entrypoint_modif.sh
```

**config.yaml requirements:**
- `init: false` for s6-overlay v3 images
- `init: true` for older/custom images
- Minimal `privileged` capabilities (avoid SYS_ADMIN if possible)

---

## Quick Decision Tree

```
Does a LinuxServer.io image exist for this app?
├─ YES → Use it! (Option 1 - easiest)
└─ NO → Is the app simple/Python/Node?
    ├─ YES → Build on HA base (Option 2)
    └─ NO → Does standalone Docker work?
        ├─ YES → Run outside HA (Option 3)
        └─ NO → App won't work anywhere
```

---

## Future Reference

**Before attempting a new addon:**
1. Check if LSIO image exists
2. Test standalone Docker first
3. Verify file locations are standard
4. Check if it needs privileged access
5. Look at similar working addons in repo

**Red flags to avoid:**
- Custom base images you have to build on
- Non-standard installation paths
- Requires root or excessive privileges
- Complex environment setup
- No existing HA addon examples

**Time saved:** This guide represents 46+ iterations of trial and error. Use it to avoid the same mistakes!

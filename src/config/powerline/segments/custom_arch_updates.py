#!/usr/bin/env python3
#
# A custom segment for the Python-based 'powerline-status'
# This shows the number of available Arch Linux updates.
#
# Requires the 'pacman-contrib' package (for 'checkupdates').
#
# To use:
# 1. Place this file in ~/.config/powerline/segments/custom_arch_updates.py
# 2. Add the segment to your theme's .json file.
# 3. Add the highlight group to your colorscheme's .json file.
#

from powerline.lib.threaded import ThreadedSegment
import subprocess
import os

# Set a custom environment to avoid locale issues
safe_env = os.environ.copy()
safe_env['LANG'] = 'C'
safe_env['LC_ALL'] = 'C'

class ArchUpdatesSegment(ThreadedSegment):
    # How often to re-run 'checkupdates' (in seconds).
    # 1800s = 30 minutes.
    interval = 1800

    def update(self, *args, **kwargs):
        """
        Runs 'checkupdates' and returns the count.
        This method is run in a background thread.
        """
        try:
            # Run 'checkupdates'
            # - capture_output=True: Captures stdout and stderr
            # - text=True: Decodes stdout/stderr as text
            # - check=False: We will manually check the return code
            # - env=safe_env: Prevents locale errors
            result = subprocess.run(
                ['checkupdates'],
                capture_output=True,
                text=True,
                check=False,
                env=safe_env
            )

            # Handle errors (e.g., network issues, command not found)
            if result.returncode != 0:
                if hasattr(self, 'log'):
                    log_msg = f"checkupdates failed: {result.stderr.strip()}"
                    self.log(log_msg)
                return None

            # Process the output
            output = result.stdout.strip()

            if not output:
                return 0  # No updates

            # Count the lines
            return len(output.splitlines())

        except FileNotFoundError:
            if hasattr(self, 'log'):
                self.log("'checkupdates' command not found. Please install 'pacman-contrib'.")
            return None
        except Exception as e:
            if hasattr(self, 'log'):
                self.log(f"Error in arch_updates segment: {e}")
            return None

    def render(self, count, *args, **kwargs):
        """
        Renders the segment based on the count from update_object.
        """
        # If count is 0 or None (error), don't render anything
        if not count:
            return None

        # Return the list of dictionaries that powerline expects
        return [{
            'contents': '⇪' + str(count),
            'divider_highlight_group': 'background:divider',
            'highlight_groups': ['arch_updates', 'arch_updates_count']
        }]

# This is the segment object that powerline will load.
# The `module` key in your JSON config will point to this file,
# and the `name` key will point to this `arch_updates` object.
arch_updates = ArchUpdatesSegment()

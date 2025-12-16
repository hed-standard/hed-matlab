#!/usr/bin/env python
"""
Patch sphinxcontrib-matlabdomain to fix compatibility issues with Sphinx 7.x+

This script fixes a bug in sphinxcontrib-matlabdomain where it uses
inspect.get_members() which doesn't exist in Python's standard library.
The correct function is inspect.getmembers(), but it has a different signature.
"""

import sys
from pathlib import Path
import importlib.util


def find_matlabdomain_file():
    """Find the mat_documenters.py file in installed packages."""
    try:
        # Use importlib to find the module spec
        spec = importlib.util.find_spec("sphinxcontrib.mat_documenters")

        if spec and spec.origin:
            return Path(spec.origin)

        # If that doesn't work, try to find the sphinxcontrib package directory
        import sphinxcontrib

        # sphinxcontrib is often a namespace package, so __file__ might be None
        if hasattr(sphinxcontrib, "__path__"):
            # Iterate through the package paths
            for pkg_path in sphinxcontrib.__path__:
                pkg_path = Path(pkg_path)

                # Check for mat_documenters.py directly in sphinxcontrib
                mat_doc_file = pkg_path / "mat_documenters.py"
                if mat_doc_file.exists():
                    return mat_doc_file

                # Check in nested matlab subdirectory
                mat_doc_file = pkg_path / "matlab" / "mat_documenters.py"
                if mat_doc_file.exists():
                    return mat_doc_file

                print(f"Searched in: {pkg_path}")

        print("Could not locate mat_documenters.py")
        return None

    except ImportError as e:
        print(f"Error importing sphinxcontrib: {e}")
        return None
    except Exception as e:
        print(f"Error finding sphinxcontrib.mat_documenters: {e}")
        return None


def patch_file(file_path):
    """Apply the patch to fix the inspect.get_members issue."""
    if not file_path:
        print("mat_documenters.py not found - this may be expected for newer versions")
        print("Skipping patch (not required)")
        return True  # Return success since patch may not be needed

    if not file_path.exists():
        print("Error: mat_documenters.py not found")
        return True  # Return success since file doesn't exist

    print(f"Checking {file_path}...")

    try:
        content = file_path.read_text(encoding="utf-8")

        # Check if already patched
        if "for name in dir(self.object)" in content:
            print("Already patched, skipping.")
            return True

        # Apply the patch only if the buggy code exists
        old_code = "members = inspect.get_members(self.object, attr_getter=self.get_attr)"

        if old_code in content:
            new_code = (
                "members = [(name, self.get_attr(self.object, name)) for name in dir(self.object)]"
            )
            content = content.replace(old_code, new_code)
            file_path.write_text(content, encoding="utf-8")
            print("✓ Patch applied successfully!")
            return True
        else:
            print("✓ Bug not found in current version - patch not needed")
            return True

    except Exception as e:
        print(f"Error applying patch: {e}")
        return False


if __name__ == "__main__":
    file_path = find_matlabdomain_file()
    success = patch_file(file_path)
    sys.exit(0 if success else 1)

#!/usr/bin/env python
"""
Patch sphinxcontrib-matlabdomain to fix compatibility issues with Sphinx 7.x+

This script fixes a bug in sphinxcontrib-matlabdomain 0.22.1 where it uses
inspect.get_members() which doesn't exist in Python's standard library.
The correct function is inspect.getmembers(), but it has a different signature.
"""

import sys
from pathlib import Path

def find_matlabdomain_file():
    """Find the mat_documenters.py file in installed packages."""
    try:
        import sphinxcontrib.mat_documenters as md
        return Path(md.__file__)
    except Exception as e:
        print(f"Error finding sphinxcontrib.mat_documenters: {e}")
        return None

def patch_file(file_path):
    """Apply the patch to fix the inspect.get_members issue."""
    if not file_path or not file_path.exists():
        print("Error: mat_documenters.py not found")
        return False
    
    print(f"Patching {file_path}...")
    
    try:
        content = file_path.read_text(encoding='utf-8')
        
        # Check if already patched
        if 'for name in dir(self.object)' in content:
            print("Already patched, skipping.")
            return True
        
        # Apply the patch
        old_code = 'members = inspect.get_members(self.object, attr_getter=self.get_attr)'
        new_code = 'members = [(name, self.get_attr(self.object, name)) for name in dir(self.object)]'
        
        if old_code in content:
            content = content.replace(old_code, new_code)
            file_path.write_text(content, encoding='utf-8')
            print("✓ Patch applied successfully!")
            return True
        else:
            print("Warning: Expected code pattern not found. The package may have been updated.")
            return False
            
    except Exception as e:
        print(f"Error applying patch: {e}")
        return False

if __name__ == "__main__":
    file_path = find_matlabdomain_file()
    success = patch_file(file_path)
    sys.exit(0 if success else 1)

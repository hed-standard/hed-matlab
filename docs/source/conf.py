# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
from datetime import date




# -- Project information -----------------------------------------------------

project = 'HED MATLAB'
copyright = '2017-{}, HED Working Group'.format(date.today().year)
author = 'HED Working Group'

# The full version, including alpha/beta/rc tags
version = '1.0.0'
release = '1.0.0'

# -- General configuration ---------------------------------------------------
matlab_src_dir = os.path.abspath(os.path.join("..", ".."))
# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "myst_parser",
    "sphinxcontrib.matlab",
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.intersphinx",
    "sphinx_design",
    "sphinx_copybutton",
]

# MATLAB-specific configurations
matlab_src_dir = os.path.abspath(os.path.join("..", ".."))
matlab_short_links = False
matlab_auto_warn_missing_crefs = True

primary_domain = "mat"
autosummary_generate = True
autodoc_default_flags = ['members', 'inherited-members']
add_module_names = False
myst_all_links_external = False
myst_heading_anchors = 4
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "html_admonition",
    "html_image",
    "linkify",
    "replacements",
    "smartquotes",
    "substitution",
    "tasklist",
    "attrs_inline",
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']
source_suffix = ['.rst', '.md']
master_doc = 'index'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', '_templates', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# Syntax highlighting style for light mode
pygments_style = 'sphinx'
# Syntax highlighting style for dark mode
pygments_dark_style = 'monokai'

html_theme = "sphinx_book_theme"
html_title = "HED MATLAB"

# Theme options for sphinx-book-theme
html_theme_options = {
    "repository_url": "https://github.com/VisLab/hed-matlab",
    "use_repository_button": True,
    "use_issues_button": True,
    "use_edit_page_button": True,
    "path_to_docs": "docs/source",
    "show_toc_level": 2,
    "navigation_with_keys": False,
    "show_navbar_depth": 1,
    "use_download_button": True,
    "toc_title": None,
    "use_fullscreen_button": False,
}

# Force the sidebar to use toctree titles instead of page titles
html_sidebars = {"**": ["navbar-logo", "search-field", "sbt-sidebar-nav.html"]}
# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

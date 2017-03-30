scap:
  lookup:
    # Set the SCAP driver. Must be one of 'oscap' or 'scc'.
    driver: scc

    # Set the filesystem path where scan results will be stored.
    output_dir:

    # Configuration dictionary used to sync content to a system
    content:
      local_dir:  # Local directory to sync scap guides
      source: salt://scap/content/guides

    # Configuration dictionary used by the `oscap` driver.
    oscap:
      xccdf: ''  # Path to xccdf.xml, relative to content.local_dir
      cpe: ''    # Path to cpe.xml, relative to content.local_dir
      profile: common

    # Configuration dictionary used by the `scc` driver.
    scc:
      version: ''
      pkg:
        source: https://url/to/scc.rpm
      guide_patterns:
        # List of path-patterns relative to content.source. These patterns will
        # be matched by globbing '*' to the end, and every match will result in
        # a scap scan using scc.
        - disa/stig-el6

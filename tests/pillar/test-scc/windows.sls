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
      version: '4.1.1'
      pkg:
        source: https://url/to/scc.rpm
      guide_patterns:
        # List of path-patterns relative to content.source. These patterns will
        # be matched by globbing '*' to the end, and every match will result in
        # a scap scan using scc.
        - disa/stig-dotnet4
        - disa/stig-ie8
        - disa/stig-ie9
        - disa/stig-ie10
        - disa/stig-ie11
        - disa/stig-win8
        - disa/stig-win10
        - disa/stig-ws2008r2-dc
        - disa/stig-ws2008r2-ms
        - disa/stig-ws2012-dc
        - disa/stig-ws2012-ms

[![license](https://img.shields.io/github/license/plus3it/scap-formula.svg)](./LICENSE)
[![Travis Build Status](https://travis-ci.org/plus3it/scap-formula.svg?branch=master)](https://travis-ci.org/plus3it/scap-formula)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/plus3it/scap-formula?branch=master&svg=true)](https://ci.appveyor.com/project/plus3it/scap-formula)

# scap-formula
Salt formula to run SCAP scans. To learn more about SCAP, see these links:

-   <https://scap.nist.gov/>
-   <https://www.open-scap.org/features/scap-components/>

## Drivers

This formula supports multiple SCAP "*drivers*". A *driver* is a software
package that executes the SCAP scan. The *driver* is specified by setting the
salt grain, `scap:driver`, or the salt pillar, `scap:lookup:driver`, to one of the
values below:

-   oscap
-   scc

The grain takes precedence over the pillar.

### `oscap`

The `oscap` *driver* is based on the openscap software package. This is an open
source project for managing security compliance and vulnerability assessments
using SCAP (and other standards, but SCAP in the context of this project).

-   <https://github.com/OpenSCAP/openscap/>

#### `oscap` Dependencies

The `oscap` utility currently is available only for Linux-based systems. For
RHEL and CentOS, it is in a default-included and enabled repo, and so can
typically be relied on to be available for these systems.

### `scc`

The `scc` *driver* is based on the SCAP Compliance Checker (scc). It is
important to know that package is not a publicly available software package. It
is developed by the U.S. Navy SPAWAR Systems Command. You must have a U.S.
Government CAC, or a .gov or .mil email address, to get access to the software.
See the site below for details.

-   <http://www.public.navy.mil/spawar/Atlantic/ProductsServices/Pages/SCAP.aspx>

#### `scc` Dependencies

-   **Windows**: Package definition for SCC must be available in the winrepo
database. The installer can be obtained from the site(s) listed above.
-   **Linux**: Package definition for SCC must be in an available yum repo, or
the rpm must be hosted at the url specified by the pillar
`scap:lookup:scc:pkg:source`.

## Available States

### `scap`

Install the SCAP *driver* package.

### `scap.content`

Sync SCAP security guides to the local system. This project bundles SCAP guides
provided by the OpenSCAP project as well as DISA. The OpenSCAP content is
compatible with the `oscap` driver, and the DISA content is compatible with
both the `oscap` and `scc` drivers. The OpenSCAP content is not *inherently*
incompatible with `scc`, but the current structure of this project does not
yet allow them to be used together (easily).

### scap.scan

Execute SCAP scans for the content specified in the pillar configuration.

When using the `oscap` driver, this state will make some educated guesses about
the system type and which security guide to use. In this case, it also defaults
to the "common" profile. In case the default is not right for your use case,
this behavior is configurable through the pillar `scap:lookup:oscap`.

When using the `scc` driver, some pillar configuration is required. Otherwise,
no scan will be performed. The required pillar key is
`scap:lookup:scc:guide_patterns`, and it should be a list of file path patterns
that represent the security guides to use to scan the system. The paths are
relative to the `content.source` pillar key. The pattern will be matched by
globbing a `*` to the end of the value.

## Configuration
Every option available in the SCAP formula can be set via pillar. Below is an
example pillar file to identify all the keys and their usage.

```
scap:
  lookup:
    # Set the SCAP driver. Must be one of 'oscap' or 'scc'.
    driver:

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
        - disa/stig-el6
```

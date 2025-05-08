# Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit
helps, and credit will always be given.

## Bug Reports

When reporting a bug please include:

*   Your operating system name and version.
*   Any details about your local setup that might be helpful in
    troubleshooting.
*   Detailed steps to reproduce the bug.

## Feature Requests and Feedback

The best way to send feedback is to file an issue on GitHub.

If you are proposing a feature:

*   Explain in detail how it would work.
*   Keep the scope as narrow as possible, to make it easier to implement.
*   Remember that this is a community-driven, open-source project, and that
    code contributions are welcome. :)

## Development Guide

### Environment Requirements

Your development-system should have the following contents installed:

* A `git` client
* The `make` utility
* An Docker-compatible container-manager (for Entrprise Linux systems, 
  this can be satisfied with the installation of the `podman` and 
  `podman-docker` RPMs)

Note: For some distributions, the `git` and `make` tools are part of a 
"development" package-group

### Environment Setup

To set up the `scap-formula` content for local modifications:

1.  Fork the [scap-formula](https://github.com/plus3it/scap-formula) repository
    (look for the `Fork` button).

1.  Clone your fork locally:

    ```shell
    git clone https://github.com/<GITHUB_USERID>/scap-formula.git && cd scap-formula
    ```

1.  Add the main (plus3it) project as a remote:

    ```shell
    git remote add upstream https://github.com/plus3it/scap-formula.git
    ```

1. Ensure all remotes'/branches' contents are fully up-to-date:

    ```shell
    git fetch --all --tags -p
    ```

1.  Create a branch for local development:

    ```shell
    git checkout upstream/master -b <NAME_OF_YOUR_BUGFIX_OR_FEATURE>
    ```

### Modification of (Local) Repository Contents

1.  Make desired modifications (most frequently, this will be adding, modifying
    or removing content builder-options from the [`scripts/build_ssg_content.sh`](/scripts/build_ssg_content.sh)
    file)

1.  When desired modifications have been completed, build the content updates:

    * In the root of your local repository, execute the `make` command
    * If the `make` command fails, executing `bash ./scripts/build_in_docker.sh`
        from the root of your local repository can be substituted

    This will result in output similar to the [linked log-file](/scap/content/guides/openscap/build-content.log)

1.  If the preceding step succeeds, submit a PR containing both your
    content-modifications and the fruits of the build-actions

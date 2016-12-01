There are several kinds of packages we can support:

- Operating system packages:
  - They are installable with `apt-get`
  - Problems:
    - there may be a lot to install and many machines share the same packages. We could allow the computers to use a package cache.

- Custom installed packages:
  - They are installable with additional shell scripts.
  - The problems are: updates and bugs:
    - When the package is included in one computer but does not work, a new update is filed.
      The update needs to work on new computers and on old ones.
    - Solutions:
      - Databases solve this with migrations.
      - One can create a folder and delete it and install everything again.
        - Problem: Changes in other folders should also be reverted.
          - Solution: Create an uninstall script.

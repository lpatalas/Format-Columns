# Change Log

## 0.2.1

- **BUGFIX**: `FollowSymlink` parameter was specified by `Show-ChildItemColumns` when running on PowerShell Desktop but it's not supported on this edition. In this version both `FollowSymlink` and `UseTransaction` are available on `Show-ChildItemColumns` but they are passed to underlying `Get-ChildItem` only when applicable.

## 0.2.0

- Initial release
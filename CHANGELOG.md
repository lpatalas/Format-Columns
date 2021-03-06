# Change Log

## 0.2.5 (2021-02-27)

- **BUGFIX**: Minor fixes in documentation of `Show-Columns` cmdlet.

## 0.2.4 (2019-06-26)

- **CHANGE**: Made `-Property` parameter optional. If not specified then `ToString()` method
  is called on each input item to get presented label.

## 0.2.3 (2019-06-24)

- **CHANGE**: Made `-Property` and `-Group` parameters positional.
- **BUGFIX**: Fixed typo in documentation of `Show-Columns` `-Property` parameter.

## 0.2.2 (2019-06-15)

- **BUGFIX**: Calling `Get-ChildItemColumns` with `-Path` parameter set to wildcard sometimes caused the function to enumerate child directories recursively as if `-Depth 0` has been specified. Now it behaves the same as standard `Get-ChildItems` cmdlet.

## 0.2.1 (2018-12-10)

- **BUGFIX**: `FollowSymlink` parameter was specified by `Show-ChildItemColumns` when running on PowerShell Desktop but it's not supported on this edition. In this version both `FollowSymlink` and `UseTransaction` are available on `Show-ChildItemColumns` but they are passed to underlying `Get-ChildItem` only when applicable.

## 0.2.0 (2018-12-02)

- Initial release

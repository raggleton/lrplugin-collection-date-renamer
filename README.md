# Collection Date Rename Lightroom Plug-in

This Lightroom Classic plug-in renames Collections from my silly date format into a format that automatically sorts by date when sorted alpabetically.
This is the only way to ensure Lightroom sorts by date, since it only sorts alphabetically.

Renames collections from
```
<day>_<month>_<year>_<description>
```

to 
```
<year>-<month>-<day>_<description>
```

Similarly, for Collections with a range of date

```
<day>_<month>_<year>-<day>_<month>_<year>_<description>
```

it renames them to

```
<year>-<month>-<day>to<year>-<month>-<day>_<description>
```

## Installation

1. Clone/download the repo
2. In Lightroom Classic, go `File` -> `Plug-in Manager`
3. Click `Add` in the bottom left
4. Navigate to your cloned repo, and select the `date_rename.lrdevplugin`, click `Add Plug-in`
5. Click `Done` to close the Manager

## Running the plug-in

Select from the menu bar: `Library` -> `Plug-in Extras` -> `Collection Date Rename`

For each top-level Collection, it will ask you whether you want to continue with renaming that Collection. You can either accept, skip that Collection, or quit the entire process.

## Development notes

- If the directory is named `*.lrdevplugin` then it is treated as a directory by OSX (`*.lrplugin` is treated as a package).

- Changes to `Info.lua` (but not `rename.lua`) require reloading the plug-in (in the `Plug-in Manager`)

- Helpful resources:
  - https://www.adobe.io/apis/creativecloud/lightroomclassic.htm
  - https://akrabat.com/writing-a-lightroom-classic-plug-in/
  - https://akrabat.com/creating-collections-with-the-lightroom-classic-sdk/
  - https://github.com/akrabat/collection-creator-lrplugin
  - https://johnrellis.com/lightroom/debugging-toolkit.htm
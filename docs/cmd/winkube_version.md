## winkube version

Print the version

### Synopsis

The version string is completely dependent on how the binary was built, so you should not depend on the version format. It may change without notice.
This could be an arbitrary string, if specified via -ldflags.
This could also be the go module version, if built with go modules (often "(devel)").

```
winkube version [flags]
```

### Options

```
  -h, --help   help for version
```

### Options inherited from parent commands

```
      --config string   config file (default is $HOME/.winkube.yaml)
  -d, --debug           Turn on debug verbosity
  -q, --quiet           Turn off all output.
  -t, --trace           Turn on trace verbosity
```

### SEE ALSO

* [winkube](winkube.md)	 - Run kubernetes on Windows

###### Auto generated by spf13/cobra on 12-Jan-2022

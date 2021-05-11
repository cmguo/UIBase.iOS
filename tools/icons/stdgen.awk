#!/usr/local/bin/gawk -F [\t] -f

BEGIN {
  lines[0] = 0
  delete lines[0]
  started = 0
}

{
  if (NR == FNR) {
    sub(/.+\//, "", $1)
    sub(".svg", "", $1)
    lines[length(lines)] = "    @SvgIconURLWrapper(\"" $1 "\")"
    lines[length(lines)] = "    public static var " $1
    lines[length(lines)] = ""
  } else {
    if ($0 == "extension URL {") {
      print $0
      print ""
      for (i in lines) {
        print lines[i]
      }
      started = 1
    } else if ($0 == "}") {
      print $0
      started = 0
    } else if (started) {
      next
    } else {
      print $0
    }
  }
}

END {
}


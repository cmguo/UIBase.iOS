#!/usr/local/bin/gawk -F [\t] -f

BEGIN {
  lines[0] = 0
  delete lines[0]
  lines2[0] = 0
  delete lines2[0]
  started = 0
}

{
  if (NR == FNR) {
    sub(/.+\//, "", $1)
    sub(".svg", "", $1)
    lines[length(lines)] = "    @SvgIconURLWrapper(\"" $1 "\")"
    lines[length(lines)] = "    public static var " $1
    lines[length(lines)] = ""
    lines2[length(lines2)] = "        " $1 ","
  } else {
    if ($0 == "extension URL {") {
      print $0
      print ""
      for (i in lines) {
        print lines[i]
      }
      print "    public static let svgIcons: [URL] = ["
      for (i in lines2) {
        print lines2[i]
      }
      print "    ]"
      print ""
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


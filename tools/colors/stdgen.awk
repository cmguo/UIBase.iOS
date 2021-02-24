#!/usr/local/bin/gawk -F [\t] -f

BEGIN {
  lines[0] = 0
  delete lines[0]
}

{
  if (NR == FNR) {
    if (Mode != "dark") {
      if (match($2, /([0-9]+)%/, result) > 0) {
        p = result[1] * 255 / 100
        p = sprintf("%0.2X", p)
        sub("#", "#" p, $2)
        sub(/ \w+%/, "", $2)
        $4 = result[1] "% " $4
      }
    } else {
      if ($3 == "") {
        $3 = $2
      }
      if (match($3, /([0-9]+)%/, result) > 0) {
        p = result[1] * 255 / 100
        p = sprintf("%0.2X", p)
        sub("#", "#" p, $3)
        sub(/ \w+%/, "", $3)
        $4 = result[1] "% " $4
      }
    }
    if ($1 != "" && substr($2, 1, 1) == "#") {
      if (Mode == "default") {
        lines[NR] = "    \"" $1 "\" : \"" $2 "\"," # // dark " $3 ", " $4
      } else if (Mode == "dark") {
        lines[NR] = "    \"" $1 "\" : \"" $3 "\"," # // default " $2 ", " $4
      } else {
        lines[length(lines) + 1] = "    public var " $1 " : UIColor {"
        lines[length(lines) + 1] = "        return ThemeColor.color(path: \"" $1 "\", defaultColor: \"" $2 "\", des: \"" $2 $3 "\")"
        lines[length(lines) + 1] = "    }"
      }
    }
  } else {
    if ($0 == "public class ThemeColor: NSObject {") {
      print $0
      for (i in lines) {
        print lines[i]
      }
    } else if ($0 == "{") {
      print $0
      for (i in lines) {
        print lines[i]
      }
    } else if (match($0, /public var \w+ : UIColor \{/, result) > 0) {
      getline
      getline
      next
    } else if (match($0, /"(\w+)"\s+: "#[0-9A-F]+"/, result) > 0) {
      next
    } else {
      print $0
    }
  }
}

END {
}


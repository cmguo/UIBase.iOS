#!/usr/local/bin/gawk -F [\t] -f

BEGIN {
  lines[0] = 0
  delete lines[0]
  started = 0
}

{
  if (NR == FNR) {
    if ($3 == $2) $3 = ""
    # day color, handle %
    if (match($2, /([0-9]+)%/, result) > 0) {
      p = result[1] * 255 / 100
      p = sprintf("%0.2X", p)
      sub("#", "0x" p, $2)
      sub(/ \w+%/, "", $2)
      $4 = result[1] "% " $4
    } else {
      sub("#", "0xFF", $2)
    }
    # night color, handle %
    if (match($3, /([0-9]+)%/, result) > 0) {
      p = result[1] * 255 / 100
      p = sprintf("%0.2X", p)
      sub("#", "0x" p, $3)
      sub(/ \w+%/, "", $3)
      $4 = result[1] "% " $4
    } else {
      sub("#", "0xFF", $3)
    }
    if ($4 != "") $4 = " //" $4
    if ($1 != "" && substr($2, 1, 2) == "0x") {
      if (substr($3, 1, 2) == "0x" && $3 != $2) {
        lines[length(lines)] = "    @DayNightColorWrapper(dayColor: " $2 ", nightColor: " $3 ")"
        lines[length(lines)] = "    public static var " $1 $4
      } else {
        lines[length(lines)] = "    public static var " $1 " = UIColor(rgba: " $2 ")" $4
      }
      lines[length(lines)] = ""
    }
  } else {
    if ($0 == "extension UIColor {") {
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


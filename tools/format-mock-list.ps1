# format-mock-list.ps1
# Reads Mock_list.txt and writes a CSV with one row per player.
# Original text file is never modified.
# Usage: .\format-mock-list.ps1 [-InputPath <txt>] [-OutputPath <csv>]

param(
  [string]$InputPath  = "c:\Users\shreshtb\Documents\Untitled\Mock_list.txt",
  [string]$OutputPath = "c:\Users\shreshtb\Documents\Untitled\.kiro\specs\ipl-ai-auction-game\data\mock-auction-list.csv"
)

# Blocks whose printed count is known to differ from the real count.
# Set 3 prints 16 but Rahane was removed at the owner's request, so 15 is correct.
$expectedOverride = @{ 'Set 3' = 15 }

$text = [IO.File]::ReadAllText($InputPath)
$hdr = [regex]'(?<label>[A-Za-z]+(?: \d+)?(?: Set \d+)?\d*) \((?<count>\d+) players\)'
$row = [regex]'(?<name>[A-Za-z][A-Za-z\.\- ]*?)\s*(?<role>All-Rounder|Wicket-Keeper|Batsman|Bowler)\s*(?<os>OS)?\s*(?<price>\d+(?:\.\d+)?) ?(?<unit>Cr|L)\s*Base'

$hits = $hdr.Matches($text)
$out = New-Object System.Collections.Generic.List[object]
$seen = @{}
$dropped = New-Object System.Collections.Generic.List[string]
$problems = 0

for ($i = 0; $i -lt $hits.Count; $i++) {
  $h = $hits[$i]
  $label = $h.Groups['label'].Value
  $printed = [int]$h.Groups['count'].Value
  $expected = if ($expectedOverride.ContainsKey($label)) { $expectedOverride[$label] } else { $printed }
  $start = $h.Index + $h.Length
  $end = if ($i + 1 -lt $hits.Count) { $hits[$i + 1].Index } else { $text.Length }
  $found = 0
  foreach ($m in $row.Matches($text.Substring($start, $end - $start))) {
    $found++
    $name = $m.Groups['name'].Value.Trim()
    if ($seen.ContainsKey($name)) { $dropped.Add("$name (kept in $($seen[$name]), dropped from $label)"); continue }
    $seen[$name] = $label
    $unit = if ($m.Groups['unit'].Value -eq 'Cr') { [decimal]10000000 } else { [decimal]100000 }
    $rupees = [decimal]::Parse($m.Groups['price'].Value, [Globalization.CultureInfo]::InvariantCulture) * $unit
    if ($rupees -ne [decimal]::Truncate($rupees)) { throw "Non-whole rupee amount for $name" }
    $out.Add([pscustomobject]@{
      set_name           = $label
      set_order          = $i + 1
      set_printed_count  = $printed
      player             = $name
      role               = $m.Groups['role'].Value
      overseas           = [bool]$m.Groups['os'].Success
      base_price_label   = "$($m.Groups['price'].Value) $($m.Groups['unit'].Value)"
      base_price_rupees  = [int64]$rupees
      isSample           = $true
    })
  }
  if ($found -ne $expected) { $problems++; "COUNT MISMATCH: $label expected=$expected found=$found" }
}

$out | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
"blocks: $($hits.Count)  rows written: $($out.Count)  count problems: $problems  duplicates dropped: $($dropped.Count)"
$dropped
"output: $OutputPath"

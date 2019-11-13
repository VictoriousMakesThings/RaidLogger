function raid_to_csv(classes, delimeter1, delimeter2)
  csv = "";
  total_members = 0;
  for i=1,GetNumGroupMembers() do
    total_members = total_members + 1;
    name,a,a,a,class,a,a,a,a,a=GetRaidRosterInfo(i);
    if classes==true then
      csv = csv .. name .. delimeter2 .. class .. delimeter1;
    else
      csv = csv .. name .. delimeter1
    end
  end
  return csv, total_members;
end

function print_raid(classes, delimeter1, delimeter2)
  csv, members = raid_to_csv(classes, delimeter1, delimeter2)
  print(members .. " members")
  print(csv)
end

function raid_export(verbose, extra, classes, delimeter1, delimeter2)
  -- verbose: lets the raid know
  -- extra: prepends CSV with metadata consisting of zone and date
  -- classes: appends each line with delimeter2, followed by class
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","

  local zone = GetRealZoneText();
  local date = date("%d/%m/%y %H:%M:%S");
  csv, members = raid_to_csv(classes, delimeter1, delimeter2);

  if verbose then
    SendChatMessage("RtCSV: Raid snapshot taken (" .. date .. ", " .. zone .. ", " .. members .. " raid members)","RAID")
  end
  
  local s = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
  s:SetSize(300,200)
  s:SetPoint("CENTER")
  s:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
  s:SetBackdropColor(0, 0, 0)
  local e = CreateFrame("EditBox", nil, s)
  e:SetMultiLine(true)
  e:SetFontObject(ChatFontNormal)
  e:SetWidth(300)
  s:SetScrollChild(e)

  if extra then
    csv = zone .. delimeter2 .. date .. delimeter1 .. csv
  end

  e:SetText(csv)
  e:HighlightText()

  e:SetScript("OnEscapePressed", function()
    s:Hide()
  end)
end
function create_dumpframe(text)
  -- Have to do it this way until CopyToClipboard() is no longer a secure function.

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

  e:SetText(text)
  e:HighlightText()

  e:SetScript("OnEscapePressed", function()
    s:Hide()
  end)
end

function buff_check(player, bufflist)
  -- Checks the player for at least one buff from bufflist
  -- bufflist presets include "onyxia", "diremaul" and "darkmoon"
  -- You can feed an array of your own buffs to check for as well

  local onyxia = {"Rallying Cry of the Dragonslayer"};
  local diremaul = {
    "Slip'kik's Savvy",
    "Fengus' Ferocity",
    "Mol'dar's Moxie"
  };
  local darkmoon = {
    "Sayge's Dark Fortune of Damage",
    "Sayge's Dark Fortune of Resistance",
    "Sayge's Dark Fortune of Armor",
    "Sayge's Dark Fortune of Versatility",
    "Sayge's Dark Fortune of Intelligence",
    "Sayge's Dark Fortune of Resistance",
    "Sayge's Dark Fortune of Stamina",
    "Sayge's Dark Fortune of Strength",
    "Sayge's Dark Fortune of Agility",
    "Sayge's Dark Fortune of Intelligence",
    "Sayge's Dark Fortune of Versatility",
    "Sayge's Dark Fortune of Armor"
  };
  local zulgurub = {
    "Spirit of Zandalar"
  };
  local songflower = {
    "Songflower Serenade"
  };
  local warchief = {
    "Warchief's Blessing"
  };

  if tContains({"darkmoon","onyxia","diremaul","songflower","zulgurub","warchief"}, bufflist) then
    if bufflist=="darkmoon" then bufflist=darkmoon;
    elseif bufflist=="onyxia" then bufflist=onyxia;
    elseif bufflist=="diremaul" then bufflist=diremaul;
    elseif bufflist=="songflower" then bufflist=songflower;
    elseif bufflist=="zulgurub" then bufflist=zulgurub;
    elseif bufflist=="warchief" then bufflist=warchief;
    end
  end

  for i=1,40 do local B=UnitBuff(player,i);
    if tContains(bufflist, B) then 
      return true;
    end
  end

  return false;
end

function raid_snapshot(verbose, delimeter1, delimeter2)
  -- verbose: give more information
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","
  local zone = GetRealZoneText();
  local date = date("%d/%m/%y %H:%M:%S");
  
  local total_members = 0;
  local raid_members = {};

  for i=1,GetNumGroupMembers() do
    local name,a,a,a,class,a,a,online = GetRaidRosterInfo(i);
    tinsert(raid_members,{name,class,online})
  end

  if verbose then
    SendChatMessage("RaidLogger: Raid snapshot taken (" .. date .. ", " .. zone .. ", " .. getn(raid_members) .. " raid members)", "RAID")
  end

  local csv_buff_line = "";

  for i=1, getn(raid_members) do
    local member = raid_members[i][1]
    local class = raid_members[i][2]
    local online = raid_members[i][3]
    local buff_line = ""

    if online then
      buff_line =  member .. delimeter2 .. class
                .. delimeter2 .. tostring(buff_check(member,"onyxia"))
                .. delimeter2 .. tostring(buff_check(member, "zulgurub"))
                .. delimeter2 .. tostring(buff_check(member, "diremaul"))
                .. delimeter2 .. tostring(buff_check(member, "songflower"))
                .. delimeter2 .. tostring(buff_check(member, "warchief"))
                .. delimeter2 .. tostring(buff_check(member, "darkmoon"))
    else
      buff_line =  member .. delimeter2 .. class
                .. delimeter2 .. "OFFLINE"
                .. delimeter2 .. "OFFLINE"
                .. delimeter2 .. "OFFLINE"
                .. delimeter2 .. "OFFLINE"
                .. delimeter2 .. "OFFLINE"
                .. delimeter2 .. "OFFLINE"
    end
    
    if string.len(csv_buff_line) > 0 then
      csv_buff_line = csv_buff_line .. delimeter1 .. buff_line
    else
      csv_buff_line = buff_line
    end
  end

  create_dumpframe(csv_buff_line)
end

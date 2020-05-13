function raid_to_csv(headers, delimeter1, delimeter2)
  local csv = "";
  --csv = headers;
  total_members = 0;
  for i=1,GetNumGroupMembers() do
    total_members = total_members + 1;
    name,a,a,a,class,a,a,a,a,a=GetRaidRosterInfo(i);
    csv = csv .. delimeter1 .. name; -- .. delimeter2 .. class;
  end
  return csv, total_members;
end

function clear_all_officer_notes()
  online_members,x,a = GetNumGuildMembers()
  for i=1,online_members do
    name,rank,rankIndex,level,class,zone,note,officer__note,online=GetGuildRosterInfo(i);
    if officer__note=="0,0" then
      GuildRosterSetOfficerNote(i,"")
    end
  end
end

function class_composition(CHAT_LOCATION)
  -- Add player names, sorted alphabetically? https://wowwiki.fandom.com/wiki/API_sort
  total_members = 0;
  priests = 0;
  mages = 0;
  warlocks = 0;
  druids = 0;
  rogues = 0;
  hunters = 0;
  shamans = 0;
  warriors = 0;
  paladins = 0;

  for i=1,GetNumGroupMembers() do
    total_members = total_members + 1;
    name,a,a,a,class,a,a,a,a,a=GetRaidRosterInfo(i);
    if class=="Priest" then priests=priests+1
    elseif class=="Mage" then mages=mages+1;
    elseif class=="Warlock" then warlocks=warlocks+1;
    elseif class=="Druid" then druids=druids+1;
    elseif class=="Rogue" then rogues=rogues+1;
    elseif class=="Hunter" then hunters=hunters+1;
    elseif class=="Shaman" then shamans=shamans+1;
    elseif class=="Warrior" then warriors=warriors+1;
    elseif class=="Paladin" then paladins=paladins+1;
    end
  end
  if CHAT_LOCATION=="print" then
    print("RaidLogger class_composition() \n Raid composition of " .. total_members .. " members consists of: \n  "
           .. priests .. " priests \n  "
           .. mages .. " mages \n  "
           .. warlocks .. " warlocks \n  "
           .. druids .. " druids \n  "
           .. rogues .. " rogues \n  "
           .. hunters .. " hunters \n  "
           .. shamans .. " shamans \n  "
           .. warriors .. " warriors \n  "
           .. paladins .. " paladins \n  "
    );
  else
    SendChatMessage("Raid composition of " .. total_members .. " members consists of:", CHAT_LOCATION);
    SendChatMessage("  " .. priests .. " priests, " .. mages .. " mages, " .. warlocks .. " warlocks, ", CHAT_LOCATION);
    SendChatMessage("  " .. druids .. " druids, " .. rogues .. " rogues, " .. hunters .. " hunters, ", CHAT_LOCATION);
    SendChatMessage("  " .. warriors .. " warriors, " .. paladins .. " paladins.", CHAT_LOCATION);
  end
end

function create_dumpframe(text)
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

function raid_export(verbose, delimeter1, delimeter2)
  -- verbose: lets the raid know
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","

  local zone = GetRealZoneText();
  local date = date("%d/%m/%y %H:%M:%S");
  csv, members = raid_to_csv("name" .. delimeter2 .. "class", delimeter1, delimeter2);

  if verbose then
    SendChatMessage("RaidLogger: Raid snapshot taken (" .. date .. ", " .. zone .. ", " .. members .. " raid members)", "RAID")
  end

  create_dumpframe(csv)
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

function buff_export_intensity(verbose, delimeter1, delimeter2)
  -- verbose: lets the raid know
  -- mode: simple (dumps a list of all players with the expected buffs), csv (exports csv)
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","
  local zone = GetRealZoneText();
  local date = date("%d/%m/%y %H:%M:%S");
  
  total_members = 0;
  raid_members = {};

  for i=1,GetNumGroupMembers() do
    total_members = total_members + 1;
    name,a,a,a,class,a,a,a,a,a=GetRaidRosterInfo(i);
    tinsert(raid_members,name)
  end

  if verbose then
    SendChatMessage("RaidLogger: Raid snapshot taken (" .. date .. ", " .. zone .. ", " .. total_members .. " raid members)", "RAID")
  end

  local csv = "";
  --headers
  --csv = csv .. "name" .. delimeter2 .. "onyxia" .. delimeter2 .. "diremaul" .. delimeter2 .. "songflower" .. delimeter2 .. "darkmoon" .. delimeter2 .. "zulgurub" .. delimeter2 .. "warchief"
  for i=1, getn(raid_members) do
    csv = csv .. delimeter1 .. raid_members[i] .. delimeter2 .. tostring(buff_check(raid_members[i],"onyxia"))
              .. delimeter2 .. tostring(buff_check(raid_members[i], "diremaul"))
              .. delimeter2 .. tostring(buff_check(raid_members[i], "songflower"))
              .. delimeter2 .. tostring(buff_check(raid_members[i], "darkmoon"))
              .. delimeter2 .. tostring(buff_check(raid_members[i], "zulgurub"))
              .. delimeter2 .. tostring(buff_check(raid_members[i], "warchief"))
  end

  create_dumpframe(csv)
end

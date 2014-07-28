
#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include "multi1v1/generic.sp"
#include "include/multi1v1.inc"

new Handle:g_hStatsWebsite = INVALID_HANDLE;

public Plugin:myinfo = {
    name = "[Multi1v1] Stats viewing module",
    author = "splewis",
    version = PLUGIN_VERSION,
    url = "https://github.com/splewis/csgo-multi-1v1"
};

public OnPluginStart() {
    LoadTranslations("common.phrases");
    g_hStatsWebsite = CreateConVar("sm_multi1v1_stats_url", "", "URL to send player stats to. For example: http://csgo1v1.splewis.net/redirect_stats/. The accountID is appened to this url for each player.");
    RegConsoleCmd("sm_stats", Command_Stats, "Displays a players multi-1v1 stats");
    RegConsoleCmd("sm_rank", Command_Stats, "Displays a players multi-1v1 stats");
    RegConsoleCmd("sm_rating", Command_Stats, "Displays a players multi-1v1 stats");
}

public Action:Command_Stats(client, args) {
    new String:arg1[32];
    if (args >= 1 && GetCmdArg(1, arg1, sizeof(arg1))) {
        new target = FindTarget(client, arg1, true, false);
        if (target != -1) {
            ShowStatsForPlayer(client, target);
        }
    } else {
        ShowStatsForPlayer(client, client);
    }

    return Plugin_Handled;
}

public ShowStatsForPlayer(client, target) {
    decl String:url[255];
    GetConVarString(g_hStatsWebsite, url, sizeof(url));
    if (StrEqual(url, "")) {
        Multi1v1Message(client, "Sorry, there is no stats website for this server.");
        return;
    }

    decl String:player_url[255];
    Format(player_url, sizeof(player_url), "%s%d", url, GetSteamAccountID(target));
    ShowMOTDPanel(client, "Multi1v1 Stats", player_url, MOTDPANEL_TYPE_URL);
}

#pragma semicolon 1

#include <sourcemod>
#include <discord>

public Plugin myinfo = {
	name = "Discord Join Event",
	author = "Spaenny",
	description = "Announces fully joined players in the Discord",
	version = "1.0.0",
	url = "github.com/Spaenny"
};

public void OnPluginStart() {
	HookEvent("player_connect", Event_PlayerConnect);
	HookEvent("player_disconnect", Event_PlayerDisconnect);
}

public Action:Event_PlayerConnect(Event event, const char[] name, bool dontBroadcast) {	
	decl ConVar:convar; 
	decl String:nick[64];
	decl String:hostname[512];
	new bot;

	bot = GetEventInt(event, "bot");
	if(bot == 1) {
		return Plugin_Handled;
	}

	convar = FindConVar("hostname");
	GetEventString(event, "name", nick, sizeof(nick));

	if(!GetConVarString(convar, hostname, sizeof(hostname))) {
		hostname = "UNKOWN SERVER:";
	}

	char sChannel[64] = "global";
	char sMessage[512];
	
	Format(sMessage, sizeof(sMessage), "%s has just joined the \"%s\"!", nick, hostname);
	SendMessageToDiscord(sChannel, sMessage);
	
	return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast) {	
	decl ConVar:convar; 
	decl String:nick[64];
	decl String:hostname[512];
	decl String:reason[64];
	new bot;

	bot = GetEventInt(event, "bot");
	if(bot == 1) {
		return Plugin_Handled;
	}

	convar = FindConVar("hostname");

	GetEventString(event, "name", nick, sizeof(nick));
	if(!GetEventString(event, "reason", reason, sizeof(reason))) {
		reason = "UNKOWN REASON";
	} 

	if(!GetConVarString(convar, hostname, sizeof(hostname))) {
		hostname = "UNKOWN SERVER:";
	}

	char sChannel[64] = "global";
	char sMessage[512];
	
	Format(sMessage, sizeof(sMessage), "%s has just disconnected from the \"%s\"! (%s)", nick, hostname, reason);
	SendMessageToDiscord(sChannel, sMessage);
	
	return Plugin_Continue;
}
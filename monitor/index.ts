import { GameDig } from "gamedig";
import axios from "axios";

// Environment variables
const WEBHOOK = process.env.DISCORD_WEBHOOK_URL;
if (!WEBHOOK) {
  console.error("Please set the DISCORD_WEBHOOK_URL environment variable.");
  process.exit(1);
}

const SERVERS_JSON = process.env.SERVERS_JSON;
if (!SERVERS_JSON) {
  console.error("Please set the SERVERS_JSON environment variable.");
  process.exit(1);
}

let SERVERS: Array<{ id: string; type: string; host: string; port: number }>;
try {
  SERVERS = JSON.parse(SERVERS_JSON);
} catch (err) {
  console.error("Failed to parse SERVERS_JSON:", err);
  process.exit(1);
}

const POLL_INTERVAL = parseInt(process.env.POLL_INTERVAL || "10000");

interface Player {
  name: string;
  id?: string;
  score?: number;
  time?: number;
  ping?: number;
}

type ServerInfo = {
  info: {
    name: string;
    map: string;
    players: number;
    maxplayers: number;
    bots: number;
    ping: number;
  };
  players: Player[];
};

const lastPlayers: Record<string, Player[]> = {};
const lastInfo: Record<string, ServerInfo["info"]> = {};

async function queryServer(
  server: (typeof SERVERS)[number]
): Promise<ServerInfo> {
  const res = await GameDig.query({
    type: server.type,
    host: server.host,
    port: server.port,
  });
  return {
    info: {
      name: res.name,
      map: res.map,
      players: res.players.length,
      maxplayers: res.maxplayers,
      bots: res.bots.length,
      ping: res.ping,
    },
    players: res.players as Player[],
  };
}

function diff(oldP: Player[], newP: Player[]) {
  const filteredOld = oldP.filter((p) => p.name.trim() !== "");
  const filteredNew = newP.filter((p) => p.name.trim() !== "");

  const oldSet = new Set(filteredOld.map((p) => p.name));
  const newSet = new Set(filteredNew.map((p) => p.name));

  return {
    joined: filteredNew.filter((p) => !oldSet.has(p.name)),
    left: filteredOld.filter((p) => !newSet.has(p.name)),
  };
}

async function sendEmbed(
  server: (typeof SERVERS)[number],
  action: string,
  joined: Player[],
  left: Player[],
  oldMap: string | null,
  info: ServerInfo["info"],
  currentPlayers: Player[]
) {
  const embed: any = {
    title: `🔍 ${server.type.toUpperCase()} Server (${server.id}): ${action}`,
    description: [
      `**${info.name}**`,
      oldMap && oldMap !== info.map
        ? `🔄 Map changed: \`${oldMap}\` → \`${info.map}\``
        : `Map: \`${info.map}\``,
      `Players: **${info.players}/${info.maxplayers}**`,
      `Bots: **${info.bots}**`,
      `Ping: **${info.ping}ms**`,
      `IP: \`${server.host}:${server.port}\``,
    ].join("\n"),
    color:
      action === "Map Changed"
        ? 0x0000ff
        : joined.length
        ? 0x00ff00
        : left.length
        ? 0xff0000
        : 0xcccccc,
    fields: [],
    timestamp: new Date().toISOString(),
  };

  if (joined.length) {
    embed.fields.push({
      name: "🟢 Joined",
      value: joined
        .map(
          (p) =>
            `\`${p.name}\` (${p.score ?? "–"} pts, ${Math.floor(
              (p.time || 0) / 60
            )}m)`
        )
        .join("\n"),
      inline: false,
    });
  }
  if (left.length) {
    embed.fields.push({
      name: "🔴 Left",
      value: left.map((p) => `\`${p.name}\``).join("\n"),
      inline: false,
    });
  }

  embed.fields.push({
    name: "👥 Current Players",
    value: currentPlayers.length
      ? currentPlayers.map((p) => `\`${p.name}\``).join(", ")
      : "*(none)*",
    inline: false,
  });

  // Uncomment to enable actual webhook sending
  await axios.post(WEBHOOK, { embeds: [embed] });
}

async function monitor() {
  for (const server of SERVERS) {
    try {
      const { info, players } = await queryServer(server);
      const oldPlayers = lastPlayers[server.id] || [];
      const oldInfoEntry = lastInfo[server.id] || info;

      console.log(
        `[${server.id}] Players: ${players.length} | ${info.name} | ${info.map}`
      );

      const { joined, left } = diff(oldPlayers, players);
      const mapChanged = oldInfoEntry.map !== info.map;

      if (mapChanged && players.length > 0) {
        await sendEmbed(
          server,
          "Map Changed",
          [],
          [],
          oldInfoEntry.map,
          info,
          players
        );
      }

      if (joined.length || left.length) {
        let action = "";
        if (joined.length && left.length) action = "Players Joined & Left";
        else if (joined.length) action = "Players Joined";
        else if (left.length) action = "Players Left";
        await sendEmbed(server, action, joined, left, null, info, players);
      }

      lastPlayers[server.id] = players;
      lastInfo[server.id] = info;
    } catch (err) {
      console.error(`Error querying ${server.id}:`, err);
    }
  }
}

(async () => {
  await Promise.all(
    SERVERS.map(async (server) => {
      const { info, players } = await queryServer(server);
      lastPlayers[server.id] = players;
      lastInfo[server.id] = info;
    })
  );

  console.log("Starting multi-server monitor…");
  setInterval(monitor, POLL_INTERVAL);
})();

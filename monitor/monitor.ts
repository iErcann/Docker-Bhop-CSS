// @ts-check
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

import * as dotenv from "dotenv";
import Docker from "dockerode";
import fetch from "node-fetch";

dotenv.config();

const webhookUrl = process.env.DISCORD_WEBHOOK_URL;
if (!webhookUrl) {
  console.error("Error: DISCORD_WEBHOOK_URL environment variable is not set");
  process.exit(1);
}

const docker = new Docker({
  socketPath: process.env.DOCKER_SOCKET || "/var/run/docker.sock",
});

const CONTAINER_NAME = process.env.CONTAINER_NAME || "css-server";
const LOG_PATTERNS = [
  "error",
  "failed",
  "warning",
  "exception",
  "crash",
  "started",
  "stopped",
  "shutdown",
  "connection",
].map((term) => new RegExp(term, "i"));

// Regex to capture chat messages after the Docker timestamp
const CHAT_PATTERN =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z\s(\S+):\s(.+)$/;

const lastSentLogs = new Set<string>();

async function sendToDiscord(message: string): Promise<void> {
  try {
    const response = await fetch(webhookUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        content: message,
        username: "Docker Log Monitor",
        avatar_url:
          "https://www.docker.com/wp-content/uploads/2022/03/vertical-logo-monochromatic.png",
      }),
    });
    if (!response.ok) {
      console.error(
        `Failed to send message to Discord: ${response.statusText}`
      );
    }
  } catch (error) {
    console.error(
      "Error sending message to Discord:",
      error instanceof Error ? error.message : "Unknown error"
    );
  }
}

async function checkLogs(): Promise<void> {
  try {
    const containers = await docker.listContainers();
    const containerInfo = containers.find((c) =>
      c.Names.some((n: string) => n.includes(CONTAINER_NAME))
    );

    if (!containerInfo) {
      console.warn(`Container ${CONTAINER_NAME} not found`);
      return;
    }

    const container = docker.getContainer(containerInfo.Id);
    const logs = await container.logs({
      follow: false,
      stdout: true,
      stderr: true,
      tail: 10,
      timestamps: true,
    });

    const logLines = Buffer.isBuffer(logs)
      ? logs.toString("utf-8").split("\n").filter(Boolean)
      : [];

    for (const line of logLines) {
      if (lastSentLogs.has(line)) continue;

      // Check for chat messages
      const chatMatch = line.match(CHAT_PATTERN);
      if (chatMatch) {
        const [, username, message] = chatMatch;
        await sendToDiscord(`💬 **${username}**: ${message}`);
        lastSentLogs.add(line);
        continue; // Skip further checks for this line
      }

      // Check for other log patterns
      const shouldSend = LOG_PATTERNS.some((pattern) => pattern.test(line));
      if (shouldSend) {
        const message = `**${CONTAINER_NAME}**\n\`\`\`\n${line}\n\`\`\``;
        await sendToDiscord(message);
        lastSentLogs.add(line);
      }

      if (lastSentLogs.size > 100) {
        const first = lastSentLogs.values().next().value;
        if (first) lastSentLogs.delete(first);
      }
    }
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown error";
    console.error("Error checking logs:", errorMessage);
    await sendToDiscord(
      `❌ Error monitoring ${CONTAINER_NAME}: ${errorMessage}`
    );
  }
}

async function main() {
  console.log(`Monitoring logs for ${CONTAINER_NAME}...`);
  await checkLogs();
  setInterval(checkLogs, parseInt(process.env.CHECK_INTERVAL || "10000", 10));
}

main().catch((e) => {
  console.error("Fatal error:", e);
  process.exit(1);
});

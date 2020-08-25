const RPC = require("discord-rpc");
const fs = require("fs");
const path = require("path");

const configPath = path.resolve(__dirname, "./config.json");
const { assets, clientId } = readConfig();
const extensions = Object.keys(assets);
const startTimestamp = new Date();

const client = new RPC.Client({ transport: "ipc" });

function readConfig() {
  return JSON.parse(fs.readFileSync(configPath), "utf8");
}

function updateActivity(client) {
  const { buffer, details, state } = readConfig();
  const e = extensions.find(x => buffer.endsWith(x));
  const largeImageKey = assets[e] || assets["_default"];
  client.setActivity({ details, state, startTimestamp, largeImageKey });
}

client.once("ready", _ => {
  updateActivity(client);
  setInterval(_ => updateActivity(client), 15000);
});

client.login({ clientId });
